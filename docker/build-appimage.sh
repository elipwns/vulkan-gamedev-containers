#!/bin/bash
# Build script that creates both regular executable and AppImage

BUILD_TYPE=${1:-Release}

echo "Building project with AppImage packaging..."
echo "Build type: $BUILD_TYPE"

# First, build the regular executable
if ! cmake -B build -S . -DCMAKE_TOOLCHAIN_FILE=/vcpkg/scripts/buildsystems/vcpkg.cmake -DCMAKE_BUILD_TYPE="$BUILD_TYPE"; then
    echo "CMake configuration failed!" >&2
    exit 1
fi

if ! cmake --build build --config "$BUILD_TYPE"; then
    echo "Build failed!" >&2
    exit 1
fi

echo "Regular build completed successfully!"

# Test the executable before packaging
echo "Testing executable..."
if ! ldd build/Game_Engine; then
    echo "Warning: Could not check dependencies"
fi

# Create AppImage
echo "Creating AppImage..."

# Create AppDir structure
mkdir -p AppDir/usr/bin
mkdir -p AppDir/usr/lib
mkdir -p AppDir/usr/share/applications
mkdir -p AppDir/usr/share/icons/hicolor/256x256/apps

# Copy executable
cp build/Game_Engine AppDir/usr/bin/

# Create desktop file automatically
cat > AppDir/Game_Engine.desktop << 'EOF'
[Desktop Entry]
Type=Application
Name=Game Engine
Comment=Vulkan-based Game Engine
Exec=Game_Engine
Icon=Game_Engine
Categories=Game;
Terminal=false
EOF

# Copy desktop file to proper locations
cp AppDir/Game_Engine.desktop AppDir/usr/share/applications/

# Copy icon if it exists, otherwise create a placeholder
if ls *.png 1> /dev/null 2>&1; then
    cp *.png AppDir/usr/share/icons/hicolor/256x256/apps/Game_Engine.png
    cp *.png AppDir/Game_Engine.png
else
    # Create a simple placeholder icon (1x1 transparent PNG)
    echo 'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNkYPhfDwAChwGA60e6kgAAAABJRU5ErkJggg==' | base64 -d > AppDir/Game_Engine.png
    cp AppDir/Game_Engine.png AppDir/usr/share/icons/hicolor/256x256/apps/
fi
    
    # Copy ALL required libraries (not just vulkan/glfw)
    echo "Copying required libraries..."
    ldd build/Game_Engine | grep "=> /" | awk '{print $3}' | while read lib; do
        if [ -f "$lib" ]; then
            # Skip system libraries that should be available everywhere
            case "$lib" in
                /lib/x86_64-linux-gnu/* | /usr/lib/x86_64-linux-gnu/libc.* | /usr/lib/x86_64-linux-gnu/libm.* | /usr/lib/x86_64-linux-gnu/libpthread.* | /usr/lib/x86_64-linux-gnu/libdl.*)
                    echo "Skipping system library: $lib"
                    ;;
                *)
                    echo "Copying library: $lib"
                    cp "$lib" AppDir/usr/lib/ 2>/dev/null || echo "Failed to copy $lib"
                    ;;
            esac
        fi
    done
    
    # Create AppRun script with better error handling
    cat > AppDir/AppRun << 'EOF'
#!/bin/bash
HERE="$(dirname "$(readlink -f "${0}")")"
export LD_LIBRARY_PATH="${HERE}/usr/lib:${LD_LIBRARY_PATH}"

# Debug output (remove in production)
echo "AppImage starting..."
echo "LD_LIBRARY_PATH: $LD_LIBRARY_PATH"

# Check if Vulkan is available
if ! command -v vulkaninfo >/dev/null 2>&1; then
    echo "Warning: vulkaninfo not found, Vulkan may not be available"
fi

# Run with error output
exec "${HERE}/usr/bin/Game_Engine" "$@" 2>&1
EOF
    chmod +x AppDir/AppRun
    
    # Create AppImage
    ARCH=x86_64 /usr/local/bin/appimagetool --no-appstream AppDir Game_Engine-x86_64.AppImage
    
    if [ $? -eq 0 ]; then
        echo "AppImage created successfully: Game_Engine-x86_64.AppImage"
        
        # Test the AppImage
        echo "Testing AppImage..."
        chmod +x Game_Engine-x86_64.AppImage
        echo "AppImage is executable"
    else
        echo "AppImage creation failed, but regular build is available"
    fi


echo "Build completed!"
echo "Regular executable: build/Game_Engine"
if [ -f "Game_Engine-x86_64.AppImage" ]; then
    echo "AppImage: Game_Engine-x86_64.AppImage"
    echo ""
    echo "To debug AppImage issues, run:"
    echo "./Game_Engine-x86_64.AppImage"
    echo ""
    echo "Or extract and run manually:"
    echo "./Game_Engine-x86_64.AppImage --appimage-extract"
    echo "cd squashfs-root && ./AppRun"
fi
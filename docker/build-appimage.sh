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

# Create AppImage if desktop file exists
if ls *.desktop 1> /dev/null 2>&1; then
    echo "Creating AppImage..."
    
    # Create AppDir structure
    mkdir -p AppDir/usr/bin
    mkdir -p AppDir/usr/lib
    mkdir -p AppDir/usr/share/applications
    mkdir -p AppDir/usr/share/icons/hicolor/256x256/apps
    
    # Copy executable
    cp build/Game_Engine AppDir/usr/bin/
    
    # Copy desktop file and icon
    cp *.desktop AppDir/usr/share/applications/
    cp *.desktop AppDir/  # AppImageTool looks for it in root of AppDir
    if ls *.png 1> /dev/null 2>&1; then
        cp *.png AppDir/usr/share/icons/hicolor/256x256/apps/
        cp *.png AppDir/  # Also copy icon to AppDir root
    fi
    
    # Copy required libraries
    ldd build/Game_Engine | grep "=> /" | awk '{print $3}' | grep -E "(vulkan|glfw)" | while read lib; do
        if [ -f "$lib" ]; then
            cp "$lib" AppDir/usr/lib/
        fi
    done
    
    # Create AppRun script
    cat > AppDir/AppRun << 'EOF'
#!/bin/bash
HERE="$(dirname "$(readlink -f "${0}")")"
export LD_LIBRARY_PATH="${HERE}/usr/lib:${LD_LIBRARY_PATH}"
exec "${HERE}/usr/bin/Game_Engine" "$@"
EOF
    chmod +x AppDir/AppRun
    
    # Create AppImage
    ARCH=x86_64 /usr/local/bin/appimagetool --no-appstream AppDir Game_Engine-x86_64.AppImage
    
    if [ $? -eq 0 ]; then
        echo "AppImage created successfully: Game_Engine-x86_64.AppImage"
    else
        echo "AppImage creation failed, but regular build is available"
    fi
else
    echo "No .desktop file found, skipping AppImage creation"
fi

echo "Build completed!"
echo "Regular executable: build/Game_Engine"
if [ -f "Game_Engine-x86_64.AppImage" ]; then
    echo "AppImage: Game_Engine-x86_64.AppImage"
fi
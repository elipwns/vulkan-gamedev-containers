#!/bin/bash
# Simple build script for vcpkg projects on Linux

BUILD_TYPE=${1:-Release}

echo "Building project with vcpkg toolchain..."
echo "Build type: $BUILD_TYPE"

# Configure with vcpkg toolchain
if ! cmake -B build -S . -DCMAKE_TOOLCHAIN_FILE=/vcpkg/scripts/buildsystems/vcpkg.cmake -DCMAKE_BUILD_TYPE="$BUILD_TYPE"; then
    echo "CMake configuration failed!" >&2
    exit 1
fi

# Build the project
if ! cmake --build build --config "$BUILD_TYPE"; then
    echo "Build failed!" >&2
    exit 1
fi

# Determine the correct executable path based on build type
if [ "$BUILD_TYPE" = "Debug" ]; then
    EXECUTABLE_PATH="build/Debug/Game_Engine"
else
    EXECUTABLE_PATH="build/Release/Game_Engine"
fi

echo "Build completed successfully!"
echo "Executable: $EXECUTABLE_PATH"
echo ""
echo "To run:"
echo "chmod +x $EXECUTABLE_PATH"
echo "./$EXECUTABLE_PATH"
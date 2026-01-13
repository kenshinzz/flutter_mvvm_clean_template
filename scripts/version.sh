#!/bin/bash

# Version management script for Flutter app
# Usage: ./scripts/version.sh [command] [options]

set -e

PUBSPEC_FILE="pubspec.yaml"
VERSION_REGEX="version:\s*([0-9]+)\.([0-9]+)\.([0-9]+)\+([0-9]+)"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Print colored output
print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

# Read current version from pubspec.yaml
get_version() {
    if [ ! -f "$PUBSPEC_FILE" ]; then
        print_error "pubspec.yaml not found!"
        exit 1
    fi
    
    local version_line=$(grep -E "^version:" "$PUBSPEC_FILE" | head -1)
    if [ -z "$version_line" ]; then
        print_error "Version not found in pubspec.yaml!"
        exit 1
    fi
    
    # Extract version name and build number
    local version_name=$(echo "$version_line" | sed -E 's/.*version:[[:space:]]*([0-9]+\.[0-9]+\.[0-9]+)\+[0-9]+.*/\1/')
    local build_number=$(echo "$version_line" | sed -E 's/.*version:[[:space:]]*[0-9]+\.[0-9]+\.[0-9]+\+([0-9]+).*/\1/')
    
    echo "$version_name $build_number"
}

# Update version in pubspec.yaml
update_version() {
    local version_name=$1
    local build_number=$2
    
    if [ ! -f "$PUBSPEC_FILE" ]; then
        print_error "pubspec.yaml not found!"
        exit 1
    fi
    
    # Use sed to update version (works on both macOS and Linux)
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        sed -i '' "s/^version:.*/version: ${version_name}+${build_number}/" "$PUBSPEC_FILE"
    else
        # Linux
        sed -i "s/^version:.*/version: ${version_name}+${build_number}/" "$PUBSPEC_FILE"
    fi
    
    print_success "Version updated to ${version_name}+${build_number}"
}

# Bump version
bump_version() {
    local type=$1
    
    read current_version current_build <<< $(get_version)
    IFS='.' read -ra VERSION_PARTS <<< "$current_version"
    local major=${VERSION_PARTS[0]}
    local minor=${VERSION_PARTS[1]}
    local patch=${VERSION_PARTS[2]}
    
    case $type in
        major)
            major=$((major + 1))
            minor=0
            patch=0
            ;;
        minor)
            minor=$((minor + 1))
            patch=0
            ;;
        patch)
            patch=$((patch + 1))
            ;;
        build)
            current_build=$((current_build + 1))
            update_version "$current_version" "$current_build"
            return
            ;;
        *)
            print_error "Invalid bump type: $type"
            print_info "Usage: bump [major|minor|patch|build]"
            exit 1
            ;;
    esac
    
    local new_version="${major}.${minor}.${patch}"
    update_version "$new_version" "1"
}

# Show current version
show_version() {
    read version_name build_number <<< $(get_version)
    echo "Version: ${version_name}"
    echo "Build: ${build_number}"
    echo "Full: ${version_name}+${build_number}"
}

# Set version explicitly
set_version() {
    local version_name=$1
    local build_number=${2:-1}
    
    # Validate version format
    if ! [[ "$version_name" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        print_error "Invalid version format: $version_name"
        print_info "Version must be in format: MAJOR.MINOR.PATCH (e.g., 1.2.3)"
        exit 1
    fi
    
    # Validate build number
    if ! [[ "$build_number" =~ ^[0-9]+$ ]]; then
        print_error "Invalid build number: $build_number"
        exit 1
    fi
    
    update_version "$version_name" "$build_number"
}

# Main command handler
case "$1" in
    get|show)
        show_version
        ;;
    bump)
        if [ -z "$2" ]; then
            print_error "Bump type required!"
            print_info "Usage: ./scripts/version.sh bump [major|minor|patch|build]"
            exit 1
        fi
        bump_version "$2"
        ;;
    set)
        if [ -z "$2" ]; then
            print_error "Version required!"
            print_info "Usage: ./scripts/version.sh set VERSION [BUILD_NUMBER]"
            exit 1
        fi
        set_version "$2" "$3"
        ;;
    *)
        echo "Version Management Script"
        echo ""
        echo "Usage: ./scripts/version.sh [command] [options]"
        echo ""
        echo "Commands:"
        echo "  get, show              Show current version"
        echo "  bump [type]           Bump version (major|minor|patch|build)"
        echo "  set VERSION [BUILD]   Set version explicitly"
        echo ""
        echo "Examples:"
        echo "  ./scripts/version.sh get"
        echo "  ./scripts/version.sh bump patch"
        echo "  ./scripts/version.sh set 1.2.3 10"
        exit 1
        ;;
esac

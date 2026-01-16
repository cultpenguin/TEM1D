#!/bin/bash
# Script to clean all output directories from running TEM1D examples
# Usage: ./clean_output.sh

echo "========================================"
echo "Cleaning TEM1D Example Outputs"
echo "========================================"
echo ""

# Count output directories
OUTPUT_COUNT=$(find . -maxdepth 1 -type d -name "output_*" 2>/dev/null | wc -l)

if [ "$OUTPUT_COUNT" -eq 0 ]; then
    echo "No output directories found. Nothing to clean."
    exit 0
fi

echo "Found $OUTPUT_COUNT output director(y/ies):"
find . -maxdepth 1 -type d -name "output_*" 2>/dev/null | sed 's|^\./|  |' | sort

echo ""
read -p "Remove all output directories? [y/N] " -n 1 -r
echo ""

if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "Removing output directories..."
    rm -rf output_*

    # Also clean up any stray FORREAD files
    if [ -f "FORREAD" ]; then
        echo "Removing FORREAD..."
        rm -f FORREAD
    fi

    echo ""
    echo "✓ Cleanup complete!"
else
    echo "Cleanup cancelled."
    exit 0
fi

echo ""
echo "========================================"
echo "Examples directory is now clean"
echo "========================================"

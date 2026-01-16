#!/bin/bash
# Script to run a single TEM1D example
# Usage: ./run_example.sh example_file.txt

set -e  # Exit on error

# Check if example file is provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <example_file.txt>"
    echo ""
    echo "Available examples:"
    ls -1 example*.txt 2>/dev/null | sed 's/^/  /'
    exit 1
fi

EXAMPLE_FILE="$1"
EXAMPLE_NAME=$(basename "$EXAMPLE_FILE" .txt)

# Check if example file exists
if [ ! -f "$EXAMPLE_FILE" ]; then
    echo "Error: Example file '$EXAMPLE_FILE' not found"
    exit 1
fi

# Check if temtest executable exists
if [ ! -f "../temtest" ]; then
    echo "Error: temtest executable not found in parent directory"
    echo "Please run 'make' in the repository root first"
    exit 1
fi

echo "========================================"
echo "Running example: $EXAMPLE_NAME"
echo "========================================"
echo ""

# Create output directory for this example
OUTPUT_DIR="output_${EXAMPLE_NAME}"
mkdir -p "$OUTPUT_DIR"

# Copy input file to FORREAD
cp "$EXAMPLE_FILE" FORREAD

# Run TEM1D
echo "Executing TEM1D..."
../temtest

# Move output files to example-specific directory
if [ -f "OUT" ]; then
    mv OUT "$OUTPUT_DIR/OUT"
    echo "Detailed output saved to: $OUTPUT_DIR/OUT"
fi

if [ -f "FORWRITE" ]; then
    mv FORWRITE "$OUTPUT_DIR/FORWRITE"
    echo "Data output saved to: $OUTPUT_DIR/FORWRITE"
fi

# Clean up FORREAD
rm -f FORREAD

echo ""
echo "========================================"
echo "Example completed successfully!"
echo "Output directory: $OUTPUT_DIR"
echo "========================================"

# Display a snippet of the results
if [ -f "$OUTPUT_DIR/OUT" ]; then
    echo ""
    echo "Sample output (first 30 lines):"
    echo "--------"
    head -30 "$OUTPUT_DIR/OUT"
    echo "--------"
    echo "(See full output in $OUTPUT_DIR/OUT)"
fi

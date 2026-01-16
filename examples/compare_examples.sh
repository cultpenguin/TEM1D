#!/bin/bash
# Script to compare multiple TEM1D examples by plotting them together
# Usage: ./compare_examples.sh

set -e

echo "========================================"
echo "Comparing TEM1D Example Responses"
echo "========================================"
echo ""

# Check if Python and matplotlib are available
if ! command -v python3 &> /dev/null; then
    echo "Error: python3 not found. Please install Python 3."
    exit 1
fi

# Check if matplotlib is available
if ! python3 -c "import matplotlib" 2>/dev/null; then
    echo "Warning: matplotlib not found. Install with: pip install matplotlib numpy"
    echo "Skipping plot generation..."
    exit 1
fi

# Find all FORWRITE output files
FORWRITE_FILES=$(find output_* -name "FORWRITE" 2>/dev/null | sort)

if [ -z "$FORWRITE_FILES" ]; then
    echo "No output files found. Please run examples first using:"
    echo "  ./run_all_examples.sh"
    exit 1
fi

echo "Found output files:"
echo "$FORWRITE_FILES" | sed 's/^/  /'
echo ""

# Create comparison plot
echo "Creating comparison plot..."
python3 plot_results.py $FORWRITE_FILES

echo ""
echo "Comparison complete!"

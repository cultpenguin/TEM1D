#!/bin/bash
# Script to run all TEM1D examples
# Usage: ./run_all_examples.sh

set -e  # Exit on error

echo "========================================"
echo "Running all TEM1D examples"
echo "========================================"
echo ""

# Check if temtest executable exists
if [ ! -f "../temtest" ]; then
    echo "Error: temtest executable not found in parent directory"
    echo "Please run 'make' in the repository root first"
    exit 1
fi

# Count examples
EXAMPLE_COUNT=$(ls -1 example*.txt 2>/dev/null | wc -l)
if [ "$EXAMPLE_COUNT" -eq 0 ]; then
    echo "Error: No example files found"
    exit 1
fi

echo "Found $EXAMPLE_COUNT examples"
echo ""

# Run each example
COUNTER=0
SUCCESS_COUNT=0
FAIL_COUNT=0

for EXAMPLE_FILE in example*.txt; do
    COUNTER=$((COUNTER + 1))
    EXAMPLE_NAME=$(basename "$EXAMPLE_FILE" .txt)

    echo ""
    echo "[$COUNTER/$EXAMPLE_COUNT] Running: $EXAMPLE_NAME"
    echo "----------------------------------------"

    # Try to run the example
    if ./run_example.sh "$EXAMPLE_FILE" > "output_${EXAMPLE_NAME}/run.log" 2>&1; then
        echo "✓ SUCCESS: $EXAMPLE_NAME"
        SUCCESS_COUNT=$((SUCCESS_COUNT + 1))
    else
        echo "✗ FAILED: $EXAMPLE_NAME"
        echo "  See output_${EXAMPLE_NAME}/run.log for details"
        FAIL_COUNT=$((FAIL_COUNT + 1))
    fi
done

echo ""
echo "========================================"
echo "All examples completed"
echo "========================================"
echo "Total:   $EXAMPLE_COUNT"
echo "Success: $SUCCESS_COUNT"
echo "Failed:  $FAIL_COUNT"
echo ""

if [ $FAIL_COUNT -eq 0 ]; then
    echo "All examples ran successfully!"
    exit 0
else
    echo "Some examples failed. Check the log files for details."
    exit 1
fi

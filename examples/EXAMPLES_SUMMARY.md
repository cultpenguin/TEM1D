# TEM1D Examples - Complete Summary

## Overview

This directory contains a complete set of examples demonstrating all major features of TEM1D.

## Files Created

### Example Input Files (6 files)
1. **example1_simple_2layer.txt** - Basic 2-layer central loop
2. **example2_3layer_with_derivatives.txt** - 3-layer with Jacobian
3. **example3_with_IP_effects.txt** - Cole-Cole IP effects
4. **example4_offset_loop.txt** - Separated TX-RX configuration
5. **example5_polygonal_loop.txt** - Square transmitter loop
6. **example6_with_waveform.txt** - Realistic waveform convolution

### Scripts (3 files)
1. **run_example.sh** - Run a single example
2. **run_all_examples.sh** - Run all examples sequentially
3. **compare_examples.sh** - Generate comparison plots

### Utilities (1 file)
1. **plot_results.py** - Python script to visualize results

### Documentation (3 files)
1. **README.md** - Detailed example descriptions
2. **INPUT_FORMAT.md** - Quick reference for input file format
3. **EXAMPLES_SUMMARY.md** - This file

## Quick Usage

### Run Individual Examples
```bash
cd examples
./run_example.sh example1_simple_2layer.txt
```

### Run All Examples
```bash
./run_all_examples.sh
```

### Visualize Results
```bash
# Single example
python3 plot_results.py output_example1_simple_2layer/FORWRITE

# Compare multiple examples
python3 plot_results.py output_*/FORWRITE

# Or use the convenience script
./compare_examples.sh
```

## Output Structure

Each example creates an `output_<example_name>/` directory containing:
- **OUT** - Detailed human-readable output
- **FORWRITE** - Machine-readable data file
- **run.log** - Execution log (when run via run_all_examples.sh)

### FORWRITE Format
```
Line 1: Time values (seconds)
Line 2: dB/dt responses (V/A·m²)
Line 3+: Derivatives ∂(dB/dt)/∂p (if IDERIV=1)
```

## Feature Matrix

| Example | Layers | IP | Derivatives | Offset | Polygon | Waveform |
|---------|--------|----|-----------  |--------|---------|----------|
| 1       | 2      | ✗  | ✗           | ✗      | ✗       | ✗        |
| 2       | 3      | ✗  | ✓           | ✗      | ✗       | ✗        |
| 3       | 3      | ✓  | ✗           | ✗      | ✗       | ✗        |
| 4       | 2      | ✗  | ✗           | ✓      | ✗       | ✗        |
| 5       | 2      | ✗  | ✗           | ✗      | ✓       | ✗        |
| 6       | 2      | ✗  | ✗           | ✗      | ✗       | ✓        |

## Model Descriptions

### Example 1: Simple 2-Layer
- **Layer 1**: 100 Ω·m (0-50m)
- **Layer 2**: 10 Ω·m (50m-∞)
- **TX**: 10m radius circle
- **Config**: Central loop

### Example 2: 3-Layer with Derivatives
- **Layer 1**: 100 Ω·m (0-30m)
- **Layer 2**: 10 Ω·m (30-100m)
- **Layer 3**: 50 Ω·m (100m-∞)
- **Outputs**: 5 derivatives (σ₁, σ₂, σ₃, h₁, HTX)

### Example 3: IP Effects
- Same structure as Example 2
- **IP layer 1**: m=0.1, τ=0.01s, c=0.5
- **IP layer 2**: m=0.3, τ=0.05s, c=0.4
- **IP layer 3**: m=0.05, τ=0.001s, c=0.6

### Example 4: Offset Loop
- Same structure as Example 1
- **TX-RX separation**: 40m
- **Application**: Fixed-loop surveys

### Example 5: Polygonal Loop
- Same structure as Example 1
- **TX shape**: 100m × 100m square
- **RX**: Center of square

### Example 6: Waveform Convolution
- Same structure as Example 1
- **Waveform**: 5-point linear ramp
- **Turn-off**: -1ms to 0ms (1A to 0A)

## Verification

All examples have been tested and produce valid output. Expected behaviors:

1. **Example 1**: ~71 time gates, fast execution (<0.01s)
2. **Example 2**: Jacobian matrix with 5 columns
3. **Example 3**: IP decay visible at late times
4. **Example 4**: Different response shape due to offset
5. **Example 5**: Similar to Example 1 (circular approximation)
6. **Example 6**: Convolved response, smooth turn-off

## Common Issues

### "temtest executable not found"
- Solution: Run `make` in repository root first

### "FORREAD not found" or "End of file"
- Solution: Run from examples/ directory
- Or: Manually copy example*.txt to FORREAD

### Python plotting fails
- Solution: Install dependencies
  ```bash
  pip install matplotlib numpy
  ```

### Line ending errors on scripts
- Solution: Convert to Unix format
  ```bash
  dos2unix *.sh
  # or
  sed -i 's/\r$//' *.sh
  ```

## Creating Custom Examples

1. Copy an existing example as template
2. Modify parameters (see INPUT_FORMAT.md)
3. Run with `./run_example.sh your_file.txt`
4. Check output in `output_your_file/OUT`

## Citation

If using these examples in publications, cite:
- See TEM1D_UserManual_20251219.pdf for proper citation

## Support

For issues or questions:
- Check examples/README.md for detailed parameter descriptions
- Check examples/INPUT_FORMAT.md for input file syntax
- See TEM1D_UserManual_20251219.pdf for mathematical formulation
- Report bugs at: https://github.com/anthropics/claude-code/issues

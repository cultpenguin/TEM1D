# TEM1D
Fortran code to produce 1D TEM forward responses and derivatives.

## Quick Start

```bash
# Build the code
make

# Run an example
cd examples
./run_example.sh example1_simple_2layer.txt

# Run all examples
./run_all_examples.sh
```

## Documentation

- **User Manual**: `TEM1D_UserManual_20251219.pdf` - Complete mathematical formulation and input file formats
- **CLAUDE.md**: Code architecture and development guide for AI assistants
- **examples/**: Six example cases demonstrating different features (see `examples/README.md`)

## Examples

The `examples/` directory contains ready-to-run examples:
- Simple 2-layer model (basic)
- 3-layer model with derivative calculation
- Induced polarization (IP) effects
- Offset loop configuration
- Polygonal transmitter loop
- Waveform convolution

See `examples/README.md` for detailed descriptions.

# TEM1D Examples

This directory contains example input files demonstrating various features of TEM1D.

## Running Examples

To run any example:

```bash
# From the repository root directory
cd examples
./run_example.sh example1_simple_2layer.txt

# Or manually:
cp example1_simple_2layer.txt FORREAD
../temtest
```

To run all examples:
```bash
./run_all_examples.sh
```

## Example Descriptions

### Example 1: Simple 2-Layer Model (`example1_simple_2layer.txt`)
**Basic central loop configuration**
- **Model**: 2 layers (100 Ωm over 10 Ωm halfspace)
- **Interface depth**: 50 m
- **Configuration**: Central loop (RTXRX = 0)
- **TX**: Circular loop, area = 314.16 m² (radius ≈ 10 m)
- **Response type**: Step response without IP effects
- **Derivatives**: Not calculated

This is the simplest configuration for testing the code.

### Example 2: 3-Layer Model with Derivatives (`example2_3layer_with_derivatives.txt`)
**Three-layer earth model with Jacobian calculation**
- **Model**: 3 layers (100 Ωm / 10 Ωm / 50 Ωm)
- **Interface depths**: 30 m and 100 m
- **Configuration**: Central loop
- **Derivatives**: Enabled (IDERIV=1)
- **Output**: Includes sensitivity matrix for inversion

Use this to test derivative calculations for sensitivity analysis or inversion.

### Example 3: Model with IP Effects (`example3_with_IP_effects.txt`)
**Induced polarization using Cole-Cole model**
- **Model**: Same 3-layer structure as Example 2
- **IP parameters** (chargeability, time constant, power):
  - Layer 1: m=0.1, τ=0.01s, c=0.5
  - Layer 2: m=0.3, τ=0.05s, c=0.4 (most polarizable)
  - Layer 3: m=0.05, τ=0.001s, c=0.6
- **Configuration**: Central loop

Demonstrates time-domain IP effects in TEM sounding.

### Example 4: Offset Loop (`example4_offset_loop.txt`)
**Separated transmitter and receiver**
- **Model**: 2 layers (100 Ωm over 10 Ωm)
- **Configuration**: Offset loop with RTXRX = 40 m
- **TX-RX separation**: 40 meters
- **Application**: Large fixed-loop surveys

Use for testing separated TX-RX configurations.

### Example 5: Polygonal Loop (`example5_polygonal_loop.txt`)
**Rectangular transmitter loop**
- **Model**: 2 layers (100 Ωm over 10 Ωm)
- **TX shape**: Square loop, 100m × 100m
  - Corners: (-50,-50), (50,-50), (50,50), (-50,50)
- **RX position**: Center (0, 0)
- **TX area**: 10,000 m²

Demonstrates arbitrary loop geometries for realistic field layouts.

### Example 6: Waveform Convolution (`example6_with_waveform.txt`)
**Realistic instrument response with current waveform**
- **Model**: 2 layers (100 Ωm over 10 Ωm)
- **Response type**: IRESPTYPE=2 (convolved response)
- **Waveform**: 5-point piecewise linear current waveform
  - Turn-off from 1.0 A at t=-1 ms to 0 A at t=0
  - Models realistic transmitter current decay
- **Waveform convolution**: Enabled (IWCONV=1)

Use for modeling actual instrument responses with finite turn-off times.

## Input File Format

Each input file follows this structure:

```
MODEL PARAMETERS              # Label (required)
IMLM                          # 0=few-layer, 1=multi-layer model
NLAY                          # Number of layers
RHON(1)  DEPN(1)             # Resistivity (Ωm), Depth to top (m)
RHON(2)  DEPN(2)             # ... for each layer
...

IP PARAMETERS                 # Label (required)
IMODIP                        # 0=no IP, 1=Cole-Cole IP model
[CHAIP(i) TAUIP(i) POWIP(i)] # If IMODIP=1: Chargeability, τ(s), power
...                           # ... for each layer

INSTRUMENT PARAMETERS         # Label (required)
TXAREA                        # Transmitter area (m²)
ISHTX1                        # TX1 polarity: -1, 0, or 1
ISHRX1                        # RX1 polarity: -1, 0, or 1
ISHTX2                        # TX2 polarity: -1, 0, or 1
ISHRX2                        # RX2 polarity: -1, 0, or 1
HTX1                          # TX1 height (m, positive up)
HRX1                          # RX1 height (m)
HTX2                          # TX2 height (m)
HRX2                          # RX2 height (m)
RTXRX                         # TX-RX separation (m), 0=central loop
IZEROPOS                      # 0=normal, 1=zero-coupled position

POLYGON PARAMETERS            # Label (required)
NPOLY                         # Number of polygon sides (0=circular)
[XPOLY(i) YPOLY(i)]          # If NPOLY>0: (x,y) coordinates of vertices
...                           # ... for each vertex
[X0RX]                        # If NPOLY>0: RX x-coordinate
[Y0RX]                        # If NPOLY>0: RX y-coordinate
[Z0RX]                        # If NPOLY>0: RX z-coordinate (not used in input)

RESPONSE PARAMETERS           # Label (required)
IRESPTYPE                     # 0=step, 1=impulse, 2=convolved
IDERIV                        # 0=no derivatives, 1=calculate Jacobian
IWCONV                        # 0=no waveform conv., 1=convolve
IREP                          # 0=no repetition, 1=model repetition
[REPFREQ]                     # If IREP=1: Repetition frequency (Hz)
NFILT                         # Number of filters (0-16)
[FILTFREQ(i)]                # If NFILT>0: Filter frequencies (Hz)
...

WAVEFORM PARAMETERS           # Label (required)
NWAVE                         # Number of waveform points (0=none)
[TWAVE(i) AWAVE(i)]          # If NWAVE>0: Time(s), Amplitude
...                           # ... for each waveform point
```

## Output Files

After running an example, TEM1D produces:

- **OUT**: Detailed human-readable output with model parameters and responses
- **FORWRITE**: Machine-readable output for post-processing (e.g., MATLAB)
  - Line 1: Time values (s)
  - Line 2: dB/dt responses (V/A·m²)
  - Lines 3+: Derivatives (if IDERIV=1)

## Notes

- All units are SI: meters, seconds, Ohm·m, Tesla
- Depths are measured from surface (DEPN(1) = 0)
- The last layer is a halfspace (infinite depth)
- TX area for circular loops: A = πr²
- For polygonal loops, vertices should be ordered counterclockwise

## Tips

1. **Start simple**: Begin with Example 1 and verify it runs
2. **Check convergence**: Large contrasts or thin layers may need careful parameter selection
3. **Derivatives**: Enable only when needed (slower computation)
4. **Polygonal loops**: Ensure vertices are properly ordered and form a closed loop
5. **Waveform**: Times should span the turn-off period symmetrically around t=0

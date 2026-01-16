# TEM1D Input File Format Quick Reference

This document provides a quick reference for creating custom TEM1D input files.

## File Structure

Input files must follow this exact order:

```
Line 1:  "MODEL PARAMETERS"         (label, any text)
Line 2:  IMLM                        (0 or 1)
Line 3:  NLAY                        (number of layers)
Line 4+: RHON(1) DEPN(1)            (resistivity, depth for each layer)
...

Next:    "IP PARAMETERS"             (label)
Next:    IMODIP                      (0 or 1)
Next:    [CHAIP TAUIP POWIP]        (for each layer if IMODIP=1)
...

Next:    "INSTRUMENT PARAMETERS"     (label)
Next:    TXAREA                      (m²)
Next:    ISHTX1                      (-1, 0, or 1)
Next:    ISHRX1                      (-1, 0, or 1)
Next:    ISHTX2                      (-1, 0, or 1)
Next:    ISHRX2                      (-1, 0, or 1)
Next:    HTX1                        (m)
Next:    HRX1                        (m)
Next:    HTX2                        (m)
Next:    HRX2                        (m)
Next:    RTXRX                       (m, 0 for central loop)
Next:    IZEROPOS                    (0 or 1)

Next:    "POLYGON PARAMETERS"        (label)
Next:    NPOLY                       (0 for circular loop)
Next:    [XPOLY(i) YPOLY(i)]        (for each vertex if NPOLY>0)
...
Next:    [X0RX]                      (if NPOLY>0)
Next:    [Y0RX]                      (if NPOLY>0)
Next:    [Z0RX]                      (if NPOLY>0, typically 0)

Next:    "RESPONSE PARAMETERS"       (label)
Next:    IRESPTYPE                   (0, 1, or 2)
Next:    IDERIV                      (0 or 1)
Next:    IWCONV                      (0 or 1)
Next:    IREP                        (0 or 1)
Next:    [REPFREQ]                   (Hz, if IREP=1)
Next:    NFILT                       (0 to 16)
Next:    [FILTFREQ(i)]              (Hz, for each filter if NFILT>0)
...

Next:    "WAVEFORM PARAMETERS"       (label)
Next:    NWAVE                       (0 if no waveform)
Next:    [TWAVE(i) AWAVE(i)]        (time, amplitude for each point if NWAVE>0)
...
```

## Parameter Descriptions

### Model Parameters

- **IMLM**: Model type
  - `0` = Few-layer model (only conductivity derivatives)
  - `1` = Multi-layer model (conductivity + thickness derivatives)

- **NLAY**: Number of layers (2-512)

- **RHON(i)**: Resistivity of layer i (Ω·m, positive)

- **DEPN(i)**: Depth to top of layer i (m)
  - `DEPN(1)` must be `0.0` (surface)
  - Must be monotonically increasing
  - Last layer extends to infinity (halfspace)

### IP Parameters

- **IMODIP**: Induced polarization model
  - `0` = No IP effects
  - `1` = Cole-Cole IP model

- **CHAIP(i)**: Chargeability of layer i (dimensionless, 0-1)

- **TAUIP(i)**: Time constant (s, positive)

- **POWIP(i)**: Cole-Cole exponent (dimensionless, 0-1)

### Instrument Parameters

- **TXAREA**: Transmitter loop area (m²)
  - For circular loop: A = πr²
  - For polygonal loop: Approximate area

- **ISHTX1, ISHTX2**: Transmitter polarities
  - `-1` = Negative polarity
  - `0` = Not used
  - `1` = Positive polarity

- **ISHRX1, ISHRX2**: Receiver polarities
  - Same convention as transmitter

- **HTX1, HTX2**: Transmitter heights (m)
  - Positive = above surface
  - Negative = below surface

- **HRX1, HRX2**: Receiver heights (m)

- **RTXRX**: TX-RX separation (m)
  - `0.0` = Central loop (coincident)
  - `> 0` = Offset loop

- **IZEROPOS**: Zero-coupling position calculation
  - `0` = Normal calculation
  - `1` = Calculate equivalent zero-coupled position

### Polygon Parameters

- **NPOLY**: Number of polygon vertices
  - `0` = Circular transmitter (use TXAREA)
  - `≥ 3` = Polygonal transmitter

- **XPOLY(i), YPOLY(i)**: Vertex coordinates (m)
  - Order vertices counterclockwise
  - Forms a closed loop (last connects to first)

- **X0RX, Y0RX**: Receiver position in loop plane (m)
  - Relative to polygon coordinate system

- **Z0RX**: Receiver height relative to TX plane (m)
  - Usually set to `0.0` (program calculates automatically)

### Response Parameters

- **IRESPTYPE**: Response type
  - `0` = Step response (∂H/∂t)
  - `1` = Impulse response
  - `2` = Convolved response (requires waveform)

- **IDERIV**: Calculate derivatives (Jacobian)
  - `0` = Response only
  - `1` = Response + derivatives for inversion

- **IWCONV**: Waveform convolution
  - `0` = No convolution
  - `1` = Convolve with waveform (requires IRESPTYPE=2)

- **IREP**: Repetition modeling
  - `0` = Single pulse
  - `1` = Repetitive pulses

- **REPFREQ**: Repetition frequency (Hz, if IREP=1)

- **NFILT**: Number of low-pass filters (0-16)

- **FILTFREQ(i)**: Filter cutoff frequencies (Hz)
  - First-order low-pass filters applied in series

### Waveform Parameters

- **NWAVE**: Number of waveform points
  - `0` = No waveform (step or impulse)
  - `≥ 2` = Piecewise linear waveform

- **TWAVE(i)**: Time of waveform point i (s)
  - Should span turn-off period
  - Typically centered around t=0

- **AWAVE(i)**: Amplitude at time i (normalized, typically 0-1)
  - Current amplitude (arbitrary units)

## Common Configurations

### 1. Simple Central Loop Survey
```
IMLM = 0, NLAY = 2
RTXRX = 0.0 (central loop)
NPOLY = 0 (circular)
IRESPTYPE = 0 (step response)
IDERIV = 0 (no derivatives)
NWAVE = 0 (no waveform)
```

### 2. Offset Loop with Derivatives
```
IMLM = 0, NLAY = 3
RTXRX = 40.0 (40m separation)
NPOLY = 0 (circular)
IRESPTYPE = 0 (step)
IDERIV = 1 (with Jacobian)
NWAVE = 0
```

### 3. Realistic Survey with Waveform
```
IMLM = 0, NLAY = 3
RTXRX = 0.0 (central)
NPOLY = 0 (circular)
IRESPTYPE = 2 (convolved)
IWCONV = 1 (with convolution)
NWAVE = 5 (5-point waveform)
```

### 4. Square Loop Configuration
```
NPOLY = 4 (4 vertices)
XPOLY = [-50, 50, 50, -50]
YPOLY = [-50, -50, 50, 50]
X0RX = 0.0, Y0RX = 0.0 (center)
```

## Tips

1. **Always include label lines** - Even though they're not used, they're required
2. **Watch the order** - Parameters must appear in exact order
3. **Consistent units** - All SI units (meters, seconds, Ohm·meters)
4. **DEPN(1) = 0** - First layer must start at surface
5. **Closed polygons** - Last vertex connects to first automatically
6. **Waveform symmetry** - Time values should span turn-off symmetrically
7. **Test incrementally** - Start simple, add complexity gradually

## Validation Checklist

Before running, verify:
- [ ] All label lines present
- [ ] NLAY matches number of resistivity/depth pairs
- [ ] Depths are monotonically increasing
- [ ] DEPN(1) = 0.0
- [ ] If IMODIP=1, NLAY Cole-Cole parameter sets provided
- [ ] If NPOLY>0, vertex coordinates and receiver position provided
- [ ] If IREP=1, REPFREQ specified
- [ ] If NFILT>0, NFILT filter frequencies provided
- [ ] If NWAVE>0, NWAVE time/amplitude pairs provided
- [ ] IRESPTYPE=2 and IWCONV=1 requires NWAVE>0

## Example Template

Copy and modify this template:

```
MODEL PARAMETERS
0
2
100.0   0.0
10.0    50.0
IP PARAMETERS
0
INSTRUMENT PARAMETERS
314.16
1
1
0
0
1.0
1.0
0.0
0.0
0.0
0
POLYGON PARAMETERS
0
RESPONSE PARAMETERS
0
0
0
0
0
WAVEFORM PARAMETERS
0
```

This represents the simplest valid configuration (2-layer, central loop, step response).

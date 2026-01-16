# pytem1d Examples

This directory contains example scripts demonstrating various features of pytem1d.

## Quick Start

```bash
# Run any example
python basic_usage.py
python class_api.py
python plotting_demo.py
python batch_random_models.py
python numerical_derivatives.py
```

## Example Descriptions

### 1. basic_usage.py
**Simple functional API demonstration**

- Computes response for a simple 2-layer model
- Uses the functional `run_tem1d()` interface
- Creates a basic log-log plot
- **Best for**: Getting started, quick calculations

```python
result = run_tem1d([100, 10], [0, 50], tx_area=314.16)
plt.loglog(result.times * 1e3, abs(result.responses))
```

**Output**: `basic_tem_response.png`

### 2. class_api.py
**Advanced class-based API demonstration**

- Uses the `TEM1DModel` class for stateful modeling
- Demonstrates parameter studies (varying resistivity)
- Shows derivative calculation
- Uses built-in plotting functions
- **Best for**: Parameter studies, multiple runs

```python
tem = TEM1DModel()
tem.set_earth_model([100, 10, 50], [0, 30, 100])
tem.enable_derivatives(True)
result = tem.run()
```

**Output**:
- `class_api_response.png`
- `class_api_derivatives.png`
- `class_api_parameter_study.png`

### 3. plotting_demo.py
**Comprehensive visualization demonstration**

- Demonstrates all plotting utilities
- Creates multi-panel figures
- Shows different model types (2-layer, 3-layer, H-type)
- Includes normalized responses, decay curves
- Derivative heatmaps
- **Best for**: Publication-quality figures

**Output**:
- `plotting_demo_all.png` (6-panel figure)
- `derivatives_heatmap.png`

### 4. batch_random_models.py ⭐ NEW
**Batch processing and API comparison with configurable layers**

- Generates 1000 random N-layer models (default: 3 layers)
- Computes responses using BOTH functional and class-based APIs
- Validates that both APIs produce identical results
- Performance comparison between approaches
- Ensemble statistics and visualization
- **Best for**: Monte Carlo studies, uncertainty quantification

**Features**:
- **Configurable number of layers** (set `N_LAYERS` at top of file)
- Random model generation (log-uniform resistivities, 1-1000 Ω·m)
- Automatic depth generation (ensures monotonically increasing interfaces)
- Progress tracking with timing
- Comprehensive validation
- Statistical analysis (median, percentiles, variability)
- Adaptive plots (adjust to number of layers)

**Configuration** (edit at top of file):
```python
N_MODELS = 1000      # Number of random models
N_LAYERS = 3         # Number of layers (2, 3, 4, 5, ...)
RANDOM_SEED = 42     # For reproducibility
```

**Examples**:
```bash
# Default: 1000 random 3-layer models
python batch_random_models.py

# Modify script to use 5 layers:
# Set N_LAYERS = 5 at top of file
python batch_random_models.py

# Quick test with 100 models:
# Set N_MODELS = 100 at top of file
python batch_random_models.py
```

**Output**:
- `batch_random_models_ensemble.png` (ensemble statistics, 4 panels)
- `batch_random_models_parameters.png` (parameter distributions, adapts to N_LAYERS)

**Key Results**:
```
1000 models in ~7 seconds
Class-based API is ~1.2x faster for batch work
Maximum difference between APIs: 0.00e+00 (identical!)
Scales to any number of layers (tested 2-10 layers)
```

### 5. numerical_derivatives.py
**Finite difference derivatives workaround**

- Computes numerical Jacobian using finite differences
- Workaround for analytical derivative limitation
- Demonstrates perturbation method
- Includes sensitivity plots
- **Best for**: When you need derivatives for inversion

```python
times, jacobian, param_names = compute_numerical_jacobian(
    [100, 10, 50], [0, 30, 100], delta_percent=1.0
)
```

**Output**: `numerical_derivatives.png`

## Performance Benchmarks

Based on running `batch_random_models.py`:

| API Style | Speed | Use Case |
|-----------|-------|----------|
| Functional | ~140 models/s | Quick one-off calculations |
| Class-based | ~170 models/s | Batch processing, parameter studies |

**Recommendation**: Use class-based API for batch processing (20-30% faster due to object reuse).

## Expected Runtime

| Example | Runtime | Models Computed |
|---------|---------|-----------------|
| basic_usage.py | ~1s | 1 |
| class_api.py | ~2s | 5 |
| plotting_demo.py | ~3s | 4 |
| batch_random_models.py | ~7s | 1000 |
| numerical_derivatives.py | ~1s | 7 (base + 6 perturbed) |

## Requirements

All examples require:
- numpy
- matplotlib
- pytem1d (installed with `pip install -e .`)

## Tips

1. **Modify parameters**: All examples use reasonable defaults, but feel free to change resistivities, depths, etc.

2. **Save results**: Use `save_result()` to save computed responses:
   ```python
   from pytem1d import save_result
   save_result(result, "my_result.npz")
   ```

3. **Combine examples**: Mix and match code from different examples

4. **Scaling up**: `batch_random_models.py` can handle 10,000+ models by changing `N_MODELS`

5. **Reproducibility**: Examples use fixed random seeds (`np.random.seed(42)`)

## Troubleshooting

**Import error**: Make sure pytem1d is installed:
```bash
cd ../
pip install -e .
```

**Plotting issues**: If plots don't show, you may need to set the backend:
```python
import matplotlib
matplotlib.use('TkAgg')  # or 'Qt5Agg'
```

**Slow performance**: First run may be slower due to library loading. Subsequent runs are faster.

## Contributing

Have an interesting use case? Consider contributing an example! Examples should:
- Be self-contained (one file)
- Include docstring explaining what it does
- Save output figures
- Run in < 30 seconds (or provide `N_MODELS` parameter to scale)

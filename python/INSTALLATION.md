# pytem1d Installation Guide

## Quick Start

```bash
# Navigate to the python directory
cd python/

# Build the Fortran shared library
make

# Install the Python package
pip install -e .

# Test the installation
python -c "import pytem1d; print(f'✓ pytem1d v{pytem1d.__version__}')"
```

## Requirements

### System Requirements
- **Operating System**: Linux, macOS, or Windows (with MinGW)
- **Python**: >= 3.8
- **Fortran Compiler**: gfortran (or compatible)
- **Build Tools**: make

### Python Dependencies
- numpy >= 1.20
- matplotlib >= 3.3

### Optional Dependencies (Development)
- pytest >= 6.0
- pytest-cov
- black (code formatting)
- mypy (type checking)
- ruff (linting)

## Detailed Installation Steps

### 1. Install System Dependencies

#### Linux (Ubuntu/Debian)
```bash
sudo apt-get update
sudo apt-get install gfortran make python3 python3-pip
```

#### Linux (Fedora/RHEL)
```bash
sudo dnf install gcc-gfortran make python3 python3-pip
```

#### macOS
```bash
# Install Homebrew if not already installed
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install gfortran
brew install gcc make

# Python usually pre-installed, or:
brew install python3
```

#### Windows
Install MinGW-w64:
1. Download from https://sourceforge.net/projects/mingw-w64/
2. Install with defaults
3. Add `C:\mingw-w64\bin` to PATH

Or use WSL (Windows Subsystem for Linux) and follow Linux instructions.

### 2. Build Fortran Shared Library

```bash
cd python/
make
```

Expected output:
```
Building TEM1D shared library for Linux...
gfortran -O2 -std=legacy -fbacktrace -w -fPIC -shared -o ...
✓ Shared library created: src/pytem1d/lib/libtem1d.so
```

Verify the build:
```bash
make test
```

### 3. Install Python Package

#### Standard Installation
```bash
pip install -e .
```

#### With Development Dependencies
```bash
pip install -e ".[dev]"
```

#### System-wide Installation (not recommended)
```bash
sudo pip install .
```

### 4. Verify Installation

```bash
# Import test
python -c "import pytem1d; print(pytem1d.__version__)"

# Functionality test
python -c "
from pytem1d import run_tem1d
result = run_tem1d([100, 10], [0, 50])
print(f'✓ {len(result.times)} time gates computed')
"
```

## Running Tests

```bash
# Install development dependencies
pip install -e ".[dev]"

# Run all tests
pytest tests/ -v

# Run with coverage
pytest --cov=pytem1d tests/

# Run specific test file
pytest tests/test_basic.py -v
```

## Running Examples

```bash
cd examples/

# Basic functional API
python basic_usage.py

# Class-based API
python class_api.py

# Visualization demo
python plotting_demo.py
```

## Troubleshooting

### Problem: "libtem1d.so not found"

**Solution**:
```bash
cd python/
make clean
make
pip install -e . --force-reinstall
```

### Problem: "gfortran: command not found"

**Solution**: Install gfortran (see system dependencies above)

### Problem: Compilation errors with legacy Fortran

**Solution**: Ensure you're using gfortran >= 4.8. Check version:
```bash
gfortran --version
```

### Problem: Import error "No module named 'pytem1d'"

**Solution**: Ensure you're in the python/ directory when running `pip install`:
```bash
cd /path/to/TEM1D/python
pip install -e .
```

### Problem: Results differ from TEMTEST

**Solution**: Small numerical differences (<1%) are expected due to floating-point precision. Larger differences may indicate:
- Different input parameters
- Different time gates
- Bug in wrapper (please report!)

## Uninstalling

```bash
pip uninstall pytem1d
```

To also remove build artifacts:
```bash
cd python/
make cleanall
```

## Development Installation

For development, install with editable mode and all dependencies:

```bash
cd python/

# Build library
make

# Install in development mode
pip install -e ".[dev]"

# Run tests
pytest tests/ -v

# Format code
black src/pytem1d/

# Type check
mypy src/pytem1d/

# Lint
ruff src/pytem1d/
```

## Platform-Specific Notes

### Linux
- Recommended platform, fully tested
- Shared library: `.so`

### macOS
- Requires GCC from Homebrew (not Apple Clang)
- Shared library: `.dylib`
- May need to allow library in Security & Privacy settings

### Windows
- Requires MinGW-w64 or similar
- Shared library: `.dll`
- WSL recommended for easier setup
- May need to adjust compiler paths in Makefile

## Getting Help

If you encounter issues:

1. Check this troubleshooting guide
2. Verify all system dependencies are installed
3. Try clean rebuild: `make cleanall && make`
4. Check GitHub issues
5. Open a new issue with:
   - Operating system and version
   - Python version (`python --version`)
   - gfortran version (`gfortran --version`)
   - Full error message
   - Output of `make test`

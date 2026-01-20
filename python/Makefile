# Makefile for building TEM1D shared library for Python interface
# ================================================================

# Detect platform
UNAME_S := $(shell uname -s)

# Compiler settings
FC = gfortran
FFLAGS = -O2 -std=legacy -fbacktrace -w -fPIC
LDFLAGS = -shared

# Platform-specific library extension and flags
ifeq ($(UNAME_S),Linux)
    LIB_EXT = so
    LIB_NAME = libtem1d.so
endif
ifeq ($(UNAME_S),Darwin)
    LIB_EXT = dylib
    LIB_NAME = libtem1d.dylib
    LDFLAGS += -dynamiclib
endif
ifeq ($(OS),Windows_NT)
    LIB_EXT = dll
    LIB_NAME = libtem1d.dll
endif

# Paths
SRC_DIR = ..
LIB_DIR = src/pytem1d/lib
TARGET = $(LIB_DIR)/$(LIB_NAME)

# Fortran source files (from parent directory)
SOURCES = $(SRC_DIR)/TEM1D.for \
          $(SRC_DIR)/TEM1DRESP.for \
          $(SRC_DIR)/TEM1DRESPIP.for \
          $(SRC_DIR)/TEM1DRESPPOLY.for \
          $(SRC_DIR)/TEM1DRESPPOLYIP.for \
          $(SRC_DIR)/TEM1DFHT.for \
          $(SRC_DIR)/TEM1DFUNC.for

# Add platform-specific timing source
#ifeq ($(UNAME_S),Linux)
#    SOURCES += $(SRC_DIR)/gettim_linux.for
#endif
ifeq ($(UNAME_S),Darwin)
    SOURCES += $(SRC_DIR)/gettim_linux.for
endif

# Include files (for dependencies)
INCLUDES = $(SRC_DIR)/ARRAYSDIMBL.INC \
           $(SRC_DIR)/MODELBL.INC \
           $(SRC_DIR)/IPBL.INC \
           $(SRC_DIR)/INSTRUMENTBL.INC \
           $(SRC_DIR)/POLYGONBL.INC \
           $(SRC_DIR)/RESPBL.INC \
           $(SRC_DIR)/WAVEBL.INC

# Object files
OBJECTS = $(SOURCES:.for=.o)

# Default target
all: $(TARGET)

# Create library directory if it doesn't exist
$(LIB_DIR):
	@mkdir -p $(LIB_DIR)

# Build shared library
$(TARGET): $(LIB_DIR) $(SOURCES) $(INCLUDES)
	@echo "Building TEM1D shared library for $(UNAME_S)..."
	$(FC) $(FFLAGS) $(LDFLAGS) -o $@ $(SOURCES)
	@echo "✓ Shared library created: $@"
	@echo ""
	@echo "You can now install the Python package:"
	@echo "  pip install -e ."

# Clean build artifacts
clean:
	rm -f $(OBJECTS)
	rm -f *.mod
	@echo "Cleaned build artifacts"

# Clean everything including the shared library
cleanall: clean
	rm -f $(TARGET)
	@echo "Cleaned all including shared library"

# Test that library was created
test:
	@echo "Checking for shared library..."
	@if [ -f "$(TARGET)" ]; then \
		echo "✓ Found: $(TARGET)"; \
		ls -lh $(TARGET); \
	else \
		echo "✗ Not found: $(TARGET)"; \
		echo "Run 'make' to build it first"; \
		exit 1; \
	fi

# Help target
help:
	@echo "TEM1D Python Interface Makefile"
	@echo ""
	@echo "Targets:"
	@echo "  make          - Build shared library"
	@echo "  make clean    - Remove object files"
	@echo "  make cleanall - Remove everything including library"
	@echo "  make test     - Check if library exists"
	@echo "  make help     - Show this help"
	@echo ""
	@echo "Platform: $(UNAME_S)"
	@echo "Library:  $(LIB_NAME)"
	@echo "Output:   $(TARGET)"

# Phony targets
.PHONY: all clean cleanall test help

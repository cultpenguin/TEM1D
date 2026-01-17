# Makefile for TEM1D - 1D TEM Forward Response Code
# =================================================

# Compiler settings
FC = gfortran
FFLAGS = -O2 -std=legacy -fbacktrace -w
FFLAGS_DEBUG = -g -O0 -std=legacy -fbacktrace -Wall -fbounds-check -fcheck=all
LDFLAGS =

# Executable name
TARGET = temtest
TARGET_DEBUG = temtest_debug

# Detect platform
UNAME_S := $(shell uname -s)

# Source files
SOURCES = TEMTEST.for \
          TEM1D.for \
          TEM1DRESP.for \
          TEM1DRESPIP.for \
          TEM1DRESPPOLY.for \
          TEM1DRESPPOLYIP.for \
          TEM1DFHT.for \
          TEM1DFUNC.for

# Add platform-specific files
#ifeq ($(UNAME_S),Linux)
#    SOURCES += gettim_linux.for
#endif

# Include files (for dependencies)
INCLUDES = ARRAYSDIMBL.INC \
           MODELBL.INC \
           IPBL.INC \
           INSTRUMENTBL.INC \
           POLYGONBL.INC \
           RESPBL.INC \
           WAVEBL.INC

# Object files
OBJECTS = $(SOURCES:.for=.o)
OBJECTS_DEBUG = $(SOURCES:.for=_debug.o)

# Default target
all: $(TARGET)

# Debug target
debug: FFLAGS = $(FFLAGS_DEBUG)
debug: $(TARGET_DEBUG)

# Link the executable
$(TARGET): $(OBJECTS)
	$(FC) $(FFLAGS) $(LDFLAGS) -o $@ $^

# Debug executable
$(TARGET_DEBUG): $(OBJECTS_DEBUG)
	$(FC) $(FFLAGS_DEBUG) $(LDFLAGS) -o $@ $^

# Compile source files to object files
%.o: %.for $(INCLUDES)
	$(FC) $(FFLAGS) -c $< -o $@

# Debug object files
%_debug.o: %.for $(INCLUDES)
	$(FC) $(FFLAGS_DEBUG) -c $< -o $@

# Clean build artifacts
clean:
	rm -f $(OBJECTS) $(OBJECTS_DEBUG) $(TARGET) $(TARGET_DEBUG)
	rm -f *.mod
	rm -f OUT FORWRITE

# Clean everything including output files
cleanall: clean
	rm -f OUT FORWRITE FORREAD

# Install target (copy to /usr/local/bin or similar)
install: $(TARGET)
	@echo "Installing $(TARGET) to /usr/local/bin (requires sudo)"
	@sudo cp $(TARGET) /usr/local/bin/

# Uninstall
uninstall:
	@echo "Removing $(TARGET) from /usr/local/bin (requires sudo)"
	@sudo rm -f /usr/local/bin/$(TARGET)

# Help target
help:
	@echo "TEM1D Makefile targets:"
	@echo "  make          - Build optimized executable (temtest)"
	@echo "  make debug    - Build debug executable (temtest_debug)"
	@echo "  make clean    - Remove object files and executables"
	@echo "  make cleanall - Remove all generated files including outputs"
	@echo "  make install  - Install to /usr/local/bin (requires sudo)"
	@echo "  make uninstall- Remove from /usr/local/bin (requires sudo)"
	@echo "  make help     - Show this help message"
	@echo ""
	@echo "Compiler: $(FC)"
	@echo "Flags: $(FFLAGS)"

# Phony targets
.PHONY: all debug clean cleanall install uninstall help

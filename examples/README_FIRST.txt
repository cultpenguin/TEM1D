================================================================================
  TEM1D Examples - Quick Start Guide
================================================================================

Welcome! This directory contains 6 ready-to-run examples demonstrating the
TEM1D forward modeling code.

FIRST STEPS:
------------
1. Build TEM1D (if not already done):
   cd ..
   make

2. Run your first example:
   cd examples                                    (you are here)
   ./run_example.sh example1_simple_2layer.txt

3. Check the output:
   cat output_example1_simple_2layer/OUT

4. Run all examples:
   ./run_all_examples.sh

WHAT'S INCLUDED:
----------------
Example Files (6):
  - example1_simple_2layer.txt           Basic 2-layer model
  - example2_3layer_with_derivatives.txt With Jacobian for inversion
  - example3_with_IP_effects.txt         Cole-Cole IP effects
  - example4_offset_loop.txt             TX-RX separated
  - example5_polygonal_loop.txt          Square transmitter loop
  - example6_with_waveform.txt           Realistic waveform

Scripts (3):
  - run_example.sh         Run single example
  - run_all_examples.sh    Run all examples
  - compare_examples.sh    Plot comparisons (needs Python)

Documentation (4):
  - README.md              Detailed descriptions (start here!)
  - INPUT_FORMAT.md        Quick reference for file format
  - EXAMPLES_SUMMARY.md    Complete feature matrix
  - README_FIRST.txt       This file

Visualization:
  - plot_results.py        Python plotting script

TYPICAL WORKFLOW:
-----------------
1. Browse examples to find one similar to your needs
2. Copy and modify the example file
3. Run with: ./run_example.sh your_file.txt
4. Check output in output_your_file/OUT
5. Visualize: python3 plot_results.py output_your_file/FORWRITE

OUTPUT FORMAT:
--------------
Each example creates output_<name>/ directory with:
  - OUT       : Human-readable detailed output
  - FORWRITE  : Machine-readable data (for plotting/processing)

FORWRITE format:
  Line 1: Time values (seconds)
  Line 2: dB/dt responses (V/A·m²)
  Line 3+: Derivatives (if requested)

NEED HELP?
----------
- Detailed parameter guide: INPUT_FORMAT.md
- Example descriptions: README.md
- Complete manual: ../TEM1D_UserManual_20251219.pdf
- Code architecture: ../CLAUDE.md

Happy modeling!
================================================================================

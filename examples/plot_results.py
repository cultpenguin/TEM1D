#!/usr/bin/env python3
"""
Plot TEM1D results from FORWRITE output files

Usage:
    python plot_results.py output_example1_simple_2layer/FORWRITE
    python plot_results.py output_*/FORWRITE  # Plot all examples
"""

import sys
import os
import numpy as np
import matplotlib.pyplot as plt
from pathlib import Path

def read_forwrite(filepath):
    """
    Read TEM1D FORWRITE output file

    Returns:
        times: array of time values (seconds)
        responses: array of dB/dt responses (V/A·m²)
        derivatives: array of derivatives if present (optional)
    """
    with open(filepath, 'r') as f:
        lines = f.readlines()

    # First line: times
    times = np.array([float(x) for x in lines[0].split()])

    # Second line: responses
    responses = np.array([float(x) for x in lines[1].split()])

    # Additional lines: derivatives (if present)
    derivatives = None
    if len(lines) > 2:
        derivatives = []
        for line in lines[2:]:
            derivatives.append(np.array([float(x) for x in line.split()]))
        derivatives = np.array(derivatives)

    return times, responses, derivatives

def plot_single_response(filepath, ax=None, label=None):
    """Plot a single TEM response"""
    times, responses, derivatives = read_forwrite(filepath)

    if ax is None:
        fig, ax = plt.subplots(figsize=(10, 6))

    if label is None:
        label = Path(filepath).parent.name.replace('output_', '')

    ax.loglog(times * 1e3, np.abs(responses), 'o-', linewidth=2, markersize=4, label=label)

    return ax

def plot_responses_comparison(filepaths):
    """Plot multiple TEM responses for comparison"""
    fig, ax = plt.subplots(figsize=(12, 7))

    for filepath in filepaths:
        if os.path.exists(filepath):
            plot_single_response(filepath, ax=ax)

    ax.set_xlabel('Time (ms)', fontsize=12)
    ax.set_ylabel('|dB/dt| (V/A·m²)', fontsize=12)
    ax.set_title('TEM1D Forward Responses', fontsize=14, fontweight='bold')
    ax.grid(True, which='both', alpha=0.3)
    ax.legend(fontsize=10)

    plt.tight_layout()
    return fig

def plot_response_with_derivatives(filepath):
    """Plot response and its derivatives"""
    times, responses, derivatives = read_forwrite(filepath)

    if derivatives is None:
        print(f"No derivatives found in {filepath}")
        return plot_single_response(filepath)

    nparam = derivatives.shape[0]

    fig, axes = plt.subplots(2, 1, figsize=(12, 10))

    # Plot response
    ax = axes[0]
    ax.loglog(times * 1e3, np.abs(responses), 'o-', linewidth=2, markersize=4)
    ax.set_xlabel('Time (ms)', fontsize=12)
    ax.set_ylabel('|dB/dt| (V/A·m²)', fontsize=12)
    ax.set_title('TEM Response', fontsize=14, fontweight='bold')
    ax.grid(True, which='both', alpha=0.3)

    # Plot derivatives (Jacobian)
    ax = axes[1]
    for i in range(nparam):
        ax.loglog(times * 1e3, np.abs(derivatives[i, :]), 'o-',
                 linewidth=1.5, markersize=3, label=f'Parameter {i+1}')

    ax.set_xlabel('Time (ms)', fontsize=12)
    ax.set_ylabel('|∂(dB/dt)/∂p| (Sensitivity)', fontsize=12)
    ax.set_title('Jacobian Matrix (Parameter Sensitivities)', fontsize=14, fontweight='bold')
    ax.grid(True, which='both', alpha=0.3)
    ax.legend(fontsize=9)

    plt.tight_layout()
    return fig

def main():
    if len(sys.argv) < 2:
        print(__doc__)
        print("\nAvailable output files:")
        for f in sorted(Path('.').glob('output_*/FORWRITE')):
            print(f"  {f}")
        sys.exit(1)

    filepaths = sys.argv[1:]

    # Check if we're plotting multiple files or single file with derivatives
    if len(filepaths) == 1:
        filepath = filepaths[0]
        if not os.path.exists(filepath):
            print(f"Error: File '{filepath}' not found")
            sys.exit(1)

        # Try to plot with derivatives first
        times, responses, derivatives = read_forwrite(filepath)
        if derivatives is not None:
            fig = plot_response_with_derivatives(filepath)
            output_name = Path(filepath).parent.name + '_with_derivatives.png'
        else:
            fig = plot_responses_comparison([filepath])
            output_name = Path(filepath).parent.name + '.png'
    else:
        # Multiple files: comparison plot
        fig = plot_responses_comparison(filepaths)
        output_name = 'tem1d_comparison.png'

    # Save figure
    plt.savefig(output_name, dpi=150, bbox_inches='tight')
    print(f"Plot saved to: {output_name}")

    # Show plot
    plt.show()

if __name__ == '__main__':
    main()

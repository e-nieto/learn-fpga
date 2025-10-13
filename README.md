# FPGA Learning Project

This project is a personal exploration of FPGA development 
and VHDL using an open-source toolchain and the Alchitry Cu V2 board.

## Goals

This is a personal project for me to get into VHDL and FPGAs. For 
the moment focused on iCE40, open toolchain and Alchitry Cu V2.

Following the examples from "Getting started with FPGAs" by 
Russell Merrick.

You should use this maybe only as reference on how to setup 
your stuff on Linux, not much more going on here.

## Tools

- **GHDL** – VHDL simulation and synthesis, using VHDL 08.
- **GTKWave** - Digital signal visualization.
- **Yosys** – Logic synthesis with GHDL plugin.
- **Nextpnr** – Place and route.
- **Icepack** – Bitstream packaging.
- **Alchitry Cu V2** – FPGA development board (Lattice iCE40-HX8k-CB132).

## Workflow

1. Write and simulate VHDL code with GHDL ahd testbenches.
2. Synthesize with Yosys targeting iCE40.
3. Place and route with Nextpnr.
4. Generate a bitstream with Icepack.
5. Flash the board with Alchitry Load.

## Requirements

- A Linux environment (didn't try on WSL, it could work except uploading)
- The open-source tools installed and available in `PATH`, 
yosys-ghdl-plugin compiled from source.
- Alchitry Cu V2 connected via USB

## Building

Use the provided `Makefile`:

```sh
make all TOP=entity -> Provides bitstream with entity being top level.
make install TOP=entity -> Uploads to FPGA.
make simulate TOP=testbench_entity -> Simulates and opens GTKWave
```


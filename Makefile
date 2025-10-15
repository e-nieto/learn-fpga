# Makefile for iCE40HX8k FPGA flow with GHDL, Yosys, Nextpnr, and GTKWave

# Top-level entity/module name
TOP ?= top
SRC_DIR := ./src
CONSTRAINTS_DIR := $(SRC_DIR)/constraints
TARGET_DIR := ./target

SIM_DIR := $(TARGET_DIR)/sim
SYNTH_DIR := $(TARGET_DIR)/synth
PNR_DIR := $(TARGET_DIR)/pnr
BITSTREAM_DIR := $(TARGET_DIR)/bitstream

VHDL_SRCS := $(shell find $(SRC_DIR) -name "*.vhdl")
SYNTH_VHDL_SRCS := $(filter-out %_tb.vhdl, $(VHDL_SRCS))
SIM_VHDL_SRCS := $(filter %_tb.vhdl, $(VHDL_SRCS))
YOSYS_GHDL_SOURCES := $(SYNTH_VHDL_SRCS)

JSON_FILE := $(SYNTH_DIR)/$(TOP).json
ASC_FILE := $(PNR_DIR)/$(TOP).asc
BIN_FILE := $(BITSTREAM_DIR)/$(TOP).bin
GTKWAVE_FILE := $(SIM_DIR)/$(TOP).vcd

DEVICE := hx8k
PACKAGE := cb132
PCF ?= $(CONSTRAINTS_DIR)/$(TOP).pcf   # Pin constraint file (optional)

# Default target
all: bitstream

## === Synthesis Flow ===

# Synthesize with Yosys
$(JSON_FILE): $(VHDL_SRCS)
	@mkdir -p $(SYNTH_DIR)
	yosys -m ghdl -p "ghdl $(foreach file,$(SYNTH_VHDL_SRCS),$(file)) -e $(TOP); synth_ice40 -top $(TOP) -json $@" 1>/dev/null

# Place & Route with nextpnr
$(ASC_FILE): $(JSON_FILE)
	@mkdir -p $(PNR_DIR)
	nextpnr-ice40 --$(DEVICE) --package $(PACKAGE) --json $< --pcf $(PCF) --asc $@

# Generate binary with icepack
$(BIN_FILE): $(ASC_FILE)
	@mkdir -p $(BITSTREAM_DIR)
	icepack $< $@

bitstream: $(BIN_FILE)
	@echo "Bitstream generated at $(BIN_FILE)"

# Install in target
install: bitstream
	@echo "Uploading using Alchitry"
	alchitry load -b CuV2 -f --bin $(BIN_FILE)

## === Simulation ===

simulate: $(GTKWAVE_FILE)
	gtkwave $<

# GHDL simulation and waveform generation
$(GTKWAVE_FILE): $(VHDL_SRCS)
	@mkdir -p $(SIM_DIR)
	# Synthesize first all the non-testbench units:
	ghdl -a --std=08 --workdir=$(SIM_DIR) $(SYNTH_VHDL_SRCS)
	# And now testbenches
	ghdl -a --std=08 --workdir=$(SIM_DIR) $(SIM_VHDL_SRCS)
	# And now elaborate for testbench
	ghdl -e --std=08 --workdir=$(SIM_DIR) -o $(SIM_DIR)/$(TOP)_sim $(TOP)
	# And run simulations?
	ghdl -r --std=08 --workdir=$(SIM_DIR) $(TOP) --vcd=$(GTKWAVE_FILE)

## === Clean ===

clean:
	rm -rf $(TARGET_DIR)

.PHONY: all bitstream simulate clean


#!/bin/bash -f
# ****************************************************************************
# Vivado (TM) v2022.2 (64-bit)
#
# Filename    : elaborate.sh
# Simulator   : Xilinx Vivado Simulator
# Description : Script for elaborating the compiled design
#
# Generated by Vivado on Sat Oct 05 13:40:55 CEST 2024
# SW Build 3671981 on Fri Oct 14 04:59:54 MDT 2022
#
# IP Build 3669848 on Fri Oct 14 08:30:02 MDT 2022
#
# usage: elaborate.sh
#
# ****************************************************************************
set -Eeuo pipefail
# elaborate design
echo "xelab --incr --debug typical --relax --mt 8 -L xil_defaultlib -L secureip --snapshot sim_UART_RX_behav xil_defaultlib.sim_UART_RX -log elaborate.log"
xelab --incr --debug typical --relax --mt 8 -L xil_defaultlib -L secureip --snapshot sim_UART_RX_behav xil_defaultlib.sim_UART_RX -log elaborate.log

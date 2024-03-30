#!/bin/bash -f
# ****************************************************************************
# Vivado (TM) v2019.1 (64-bit)
#
# Filename    : simulate.sh
# Simulator   : Xilinx Vivado Simulator
# Description : Script for simulating the design by launching the simulator
#
# Generated by Vivado on Sat Mar 30 05:07:19 IST 2024
# SW Build 2552052 on Fri May 24 14:47:09 MDT 2019
#
# Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
#
# usage: simulate.sh
#
# ****************************************************************************
set -Eeuo pipefail
echo "xsim pbit_tb_behav -key {Behavioral:sim_1:Functional:pbit_tb} -tclbatch pbit_tb.tcl -view /home/ullas/Probabilistic-Computer-Design/pbit/project_1/pbit_tb_behav.wcfg -log simulate.log"
xsim pbit_tb_behav -key {Behavioral:sim_1:Functional:pbit_tb} -tclbatch pbit_tb.tcl -view /home/ullas/Probabilistic-Computer-Design/pbit/project_1/pbit_tb_behav.wcfg -log simulate.log


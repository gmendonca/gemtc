
/home/skrieder/sfw/stc/bin/stc test_hist_n.swift
export TURBINE_USER_LIB=$PWD
export TURBINE_LOG=0
export TURBINE_DEBUG=0
time /home/skrieder/sfw/turbine/bin/turbine -n 18 test_hist_n.tcl

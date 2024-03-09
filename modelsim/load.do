#####################################################
# Create Modelsim library and compile design files. #
#####################################################

# Create a library for working in
vlib work

set rtl ../rtl

vlog -quiet $rtl/*.v


quit

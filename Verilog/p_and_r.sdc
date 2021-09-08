# Synopsys, Inc. constraint file
# C:\SBT\designs\blinky\demo_syn.sdc
# Written on Tue Feb 07 15:09:02 2012
# by Synplify Pro, E-2011.03S-SP1-1 Scope Editor

#
# Collections
#

#
# Clocks
#
define_clock   {CLK_32KHz} -name {CLK_32KHz}  -freq 0.032 -clockgroup default_clkgroup_0
define_clock -disable   {n:Divider_to_1Hz.COUNTER[9]} -name {n:Divider_to_1Hz.COUNTER[9]}  -clockgroup default_clkgroup_1
define_clock -disable   {n:DIVIDE_32MHz.COUNTER[20]} -name {n:DIVIDE_32MHz.COUNTER[20]}  -clockgroup default_clkgroup_2
define_clock -disable   {n:DIVIDE_32MHz.COUNTER[27]} -name {n:DIVIDE_32MHz.COUNTER[27]}  -clockgroup default_clkgroup_3
define_clock   {CLK_32MHZ} -name {CLK_32MHZ}  -freq 32 -clockgroup default_clkgroup_4

#
# Clock to Clock
#

#
# Inputs/Outputs
#

#
# Registers
#

#
# Delay Paths
#

#
# Attributes
#

#
# I/O Standards
#

#
# Compile Points
#

#
# Other
#

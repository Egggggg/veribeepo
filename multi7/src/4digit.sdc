//Copyright (C)2014-2023 GOWIN Semiconductor Corporation.
//All rights reserved.
//File Title: Timing Constraints file
//GOWIN Version: 1.9.9 Beta-4 Education
//Created Time: 2023-11-09 22:22:52
create_clock -name clock -period 37.037 -waveform {0 18.518} [get_ports {i_clk}]

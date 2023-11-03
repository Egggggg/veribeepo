//Copyright (C)2014-2023 GOWIN Semiconductor Corporation.
//All rights reserved.
//File Title: Timing Constraints file
//GOWIN Version: 1.9.9 Beta-4 Education
//Created Time: 2023-11-02 21:24:40
create_clock -name i_clock -period 400 -waveform {0 200} [get_ports {i_clock}]

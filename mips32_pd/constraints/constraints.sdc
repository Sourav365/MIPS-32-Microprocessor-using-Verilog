create_clock -name clk1 -period 20 -waveform {5 10} [get_ports "clk1"]
create_clock -name clk2 -period 20 -waveform {15 20} [get_ports "clk2"]

set_clock_transition -rise 0.1 [get_clocks "clk1"]
set_clock_transition -fall 0.1 [get_clocks "clk1"]
set_clock_uncertainty 0.01 [get_ports "clk1"]

set_clock_transition -rise 0.1 [get_clocks "clk2"]
set_clock_transition -fall 0.1 [get_clocks "clk2"]
set_clock_uncertainty 0.01 [get_ports "clk2"]
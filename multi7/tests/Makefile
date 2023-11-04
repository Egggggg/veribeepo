ICARUS_FILES = inputs.txt
ICARUS_OUT = out

build: ${ICARUS_FILES}
	iverilog -o ${ICARUS_OUT} -c $^

vvp: build
	vvp ${ICARUS_OUT}

wave: vvp
	gtkwave dump.vcd
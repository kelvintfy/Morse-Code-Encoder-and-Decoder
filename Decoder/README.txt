Top level file connecting all the files is not included. You have to write it yourself. 
You can write it based on the sample in Encoder project.

Design source: 		au2mc.vhd	<- turning binary input into symbol signals
	       		symdet.vhd	<- detect the symbols and turn it into "dash" or "dot" signals
	       		mcdecoder.vhd	<- detect the "dash" or "dot" signals and turn them into ASCII code
			sim_mcgen.vhd & simpuart <- UART file to output the signal to FPGA board

Input source:	morse_48k_goodluck.txt	<- binary input file

Output: "HKU EEE"
Design source: 		mcencoder.vhd	<- top level file connecting other two files
	       		rd_ascii.vhd	<- store input data and output them one by one
	       		symbol_output.vhd<- turn ASCII code into symbol output

Simulation source:	sim_encoder	<- simulation file providing 48kHz clock and data input

Output:	"A BC."	"F."
module Etapa1_SPI(
	//////////// CLOCK //////////
	input 		          		ADC_CLK_10,
	input 		          		MAX10_CLK1_50,
	input 		          		MAX10_CLK2_50,

	//////////// SEG7 //////////
	output		     [7:0]		HEX0,
	output		     [7:0]		HEX1,
	output		     [7:0]		HEX2,
	output		     [7:0]		HEX3,
	output		     [7:0]		HEX4,
	output		     [7:0]		HEX5,

	//////////// KEY //////////
	input 		     [1:0]		KEY,

	//////////// LED //////////
	output		     [9:0]		LEDR,

	//////////// SW //////////
	input 		     [9:0]		SW,

	//////////// Accelerometer //////////
	output		          		GSENSOR_CS_N,
	input 		     [2:1]		GSENSOR_INT,
	output		          		GSENSOR_SCLK,
	inout 		          		GSENSOR_SDI,
	inout 		          		GSENSOR_SDO
);
wire clk;
wire sclk;
wire acknowledge;
wire [7:0]  pachet_returnat;
wire [15:0] pachet_trimis;

wire request;
assign GSENSOR_SCLK = sclk;

assign LEDR = pachet_returnat;
pll_spi
pll_spi_inst(
.areset (~KEY[0]      ),
.inclk0 (MAX10_CLK1_50),
.c0     (clk			 ),
.c1     (sclk 			 ),
.locked ()

);
masterspi masterspi_inst(
.clk_i           (clk),
.rst_n_i         (KEY[0]),
.ack_i           (acknowledge),  
.req_o           (request), 
.pachet_primit   (pachet_returnat), 
.pachet_trimis   (pachet_trimis)  
);




secventiator secventiator_inst(
.clk_i        (clk),
.rst_n_i      (KEY[0]),
.req_i        (request),   
.ack_o        (acknowledge),   
.pachet_trimis(pachet_returnat),  
.pachet_primit(pachet_trimis),   
.SPI_SDI      (GSENSOR_SDI),  
.SPI_SDO      (GSENSOR_SDO),   
.SPI_CS_N     (GSENSOR_CS_N)  
);



endmodule

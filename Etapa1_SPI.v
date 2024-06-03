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
wire [7:0] datax;
wire [7:0] datay;
wire acknowledge;
wire [7:0]  pachet_returnat;
wire [15:0] pachet_trimis;
wire request;
assign LEDR[7:0] = datax;

pll_spi
pll_spi_inst(
.areset (~KEY[0]      ),
.inclk0 (MAX10_CLK2_50),
.c0     (clk			 ),
.c1     (sclk 			 ),
.locked ()
);

secventiator secventiator_inst(
.clk_i           (clk),
.rst_n_i         (KEY[0]),
.ack_i           (acknowledge),  
.req_o           (request),
.datax(datax),
.datay(datay),
.pachet_returnat (pachet_returnat),
.pachet_trimis   (pachet_trimis) 
 
);


masterspi master_inst(
.clk_i        (clk),
.rst_n_i      (KEY[0]),
.clk_defazat  (sclk),
.clk_c1       (GSENSOR_SCLK),
.req_i        (request),   
.ack_o        (acknowledge),   
.pachet_trimis(pachet_returnat),  
.pachet_primit(pachet_trimis),   
.SPI_SDI      (GSENSOR_SDI),  
.SPI_SDO      (GSENSOR_SDO),   
.SPI_CS_N     (GSENSOR_CS_N)  
);

Display_control displayc_inst(

.sdata_x(datax),
.sdata_y(datay),
.HEX0   (HEX0),
.HEX1   (HEX1),
.HEX2   (HEX2),
.HEX3   (HEX3),
.HEX4   (HEX4),
.HEX5   (HEX5)
);

endmodule

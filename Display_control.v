module Display_control(

input   [7:0] sdata_x,
input   [7:0] sdata_y,
output  [7:0]	HEX0,
output  [7:0]	HEX1,
output  [7:0]	HEX2,
output  [7:0]	HEX3,
output  [7:0]	HEX4,
output  [7:0]	HEX5
);
localparam UP   = 8'b1001_1100;
localparam DOWN = 8'b1010_0011;
localparam OFF  = 8'b1111_1111;
 
 wire hex0;
 wire hex1;
 wire hex2;
 wire hex3;
 wire hex4;
 wire hex5;
 
  assign hex0 = ({sdata_x[7],sdata_x[5:4]} ==3'b100 || {sdata_x[7],sdata_x[5:4]} ==3'b101 || {sdata_x[7],sdata_x[6],sdata_x[5:4]} ==4'b1011);  
  assign hex1 = ({sdata_x[7],sdata_x[5:4]} ==3'b110); 
  assign hex2 = ({sdata_x[7],sdata_x[6],sdata_x[5:4]} ==4'b1111); 
  assign hex3 = ({sdata_x[7],sdata_x[6],sdata_x[5:4]} ==4'b0000); 
  assign hex4 = ({sdata_x[7],sdata_x[5:4]} ==3'b001); 
  assign hex5 = ({sdata_x[7],sdata_x[5:4]} ==3'b011 || {sdata_x[7],sdata_x[5:4]} ==3'b010 || {sdata_x[7],sdata_x[6],sdata_x[5:4]} ==4'b0100); 
	
	assign HEX0 = (hex0 && sdata_y[7]) 	  ?  UP   : 
				     (hex0 && ~(sdata_y[7]))   ?  DOWN : OFF;
	
	assign HEX1 = (hex1 && sdata_y[7]) 	  ?  UP   : 
				     (hex1 && ~(sdata_y[7]))   ?  DOWN : OFF;
	
	assign HEX2 = (hex2 && sdata_y[7]) 	  ?  UP   : 
				     (hex2 && ~(sdata_y[7]))   ?  DOWN : OFF;

	assign HEX3 = (hex3 && sdata_y[7]) 	  ?  UP   : 
				     (hex3 && ~(sdata_y[7]))   ?  DOWN : OFF;					  

	assign HEX4 = (hex4 && sdata_y[7]) 	  ?  UP   : 
				     (hex4 && ~(sdata_y[7]))   ?  DOWN : OFF;					  

	assign HEX5 = (hex5 && sdata_y[7]) 	  ?  UP   : 
				     (hex5 && ~(sdata_y[7]))   ?  DOWN : OFF;					  
	 
					  
					  
					  
					  
endmodule
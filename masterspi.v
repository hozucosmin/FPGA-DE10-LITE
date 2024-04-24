module masterspi(


input clk_i,
input rst_n_i,

input ack_i,  
output reg req_o, 

input [7:0]      pachet_primit, 

output reg [15:0] pachet_trimis  
);

localparam BW_RATE_ADDR       =8'b0010_1100;
localparam BW_RATE_VALUE      =8'b0000_1011;
localparam POWER_CTL_ADDR     =8'b0010_1101;
localparam POWER_CTL_VALUE    =8'b0000_1000;
localparam DATAFORMAT_ADDR		=8'b0011_0001; 
localparam DATAFORMAT_VALUE   =8'b0000_1100;
localparam DEVID_ADDR			=8'b0000_0000;
localparam Mb				    	=1'b0; 
localparam WR					   =1'b0;
localparam ZERO               =8'b00000000;
localparam DATAX1_ADDR        =6'b11_0011;
localparam DATAY1_ADDR        =6'b11_0101;
reg [2:0]  counter;


localparam DATAFORMAT_WRITE   = 4'b0001;
localparam BW_RATE_WRITE      = 4'b0010;
localparam POWER_CTL_WRITE 	= 4'b0011;
localparam DATAX1_READ        = 4'b0100;
 

always @(posedge clk_i or negedge rst_n_i)
begin
	if(~rst_n_i)
	begin
		pachet_trimis<=0;
		req_o <= 0;
		counter <=1;
	end 
	
	else begin

	if(counter <= 3) 
	begin
	 if (ack_i)counter<=counter+1;
   end
	
	case(counter)
	
	DATAFORMAT_WRITE:
		if(~ack_i) 
		begin
			req_o <= 1;
			pachet_trimis<={WR,Mb,DATAFORMAT_ADDR,DATAFORMAT_VALUE};
		end 
		else 
		begin
			pachet_trimis<=0;
			req_o<=0;
		end
	
	BW_RATE_WRITE:
		if(~ack_i) 
		begin
			req_o <= 1;
			pachet_trimis<={WR,Mb,BW_RATE_ADDR, BW_RATE_VALUE};
		end 
		else 
		begin
			pachet_trimis<=0;
			req_o<=0;
		end
	
	POWER_CTL_WRITE:
		if(~ack_i) 
		begin
			req_o <= 1;
			pachet_trimis<={WR,Mb,POWER_CTL_ADDR, POWER_CTL_VALUE};
		end 
		else 
		begin
			pachet_trimis<=0;
			req_o<=0;
		end
	
	DATAX1_READ:
	   if(~ack_i) 
		begin
			req_o <= 1;
			pachet_trimis<={(~WR),Mb,DATAX1_ADDR,ZERO};
	
		end 
		else 
		begin
			pachet_trimis<=0;
			req_o<=0;
		end
	

	default:
	begin
		req_o<=1'b0;
		pachet_trimis<=0;
	end
	endcase
	
	end
	end



endmodule
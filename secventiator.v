module secventiator(

input clk_i,
input rst_n_i,
input ack_i,  
output reg req_o, 
input [7:0] pachet_returnat,
output reg [7:0] datax,
output reg [7:0] datay,
output reg [15:0] pachet_trimis  
);


localparam BW_RATE_ADDR       =8'b0010_1100;
localparam BW_RATE_VALUE      =8'b0000_1011;
localparam POWER_CTL_ADDR     =8'b0010_1101;
localparam POWER_CTL_VALUE    =8'b0000_1000;
localparam DATAFORMAT_ADDR		=8'b0011_0001; 
localparam DATAFORMAT_VALUE   =8'b0000_1100;
//localparam DATAFORMAT_VALUE   =8'b0000_0000;
//localparam DEVID_READ         = 4'b0100;
localparam DEVID_ADDR			=6'b00_0000;
localparam MB				    	=1'b0; 
localparam WR					   =1'b0;
localparam ZERO               =8'b00000000;
localparam DATAX1_ADDR        =6'b11_0011;
localparam DATAY1_ADDR        =6'b11_0101;
reg [2:0]  counter;
localparam DATAFORMAT_WRITE   = 4'b0001;
localparam BW_RATE_WRITE      = 4'b0010;
localparam POWER_CTL_WRITE 	= 4'b0011;
localparam DATAX1_READ        = 4'b0100;
localparam DATAY1_READ        = 4'b0101;

always @(posedge clk_i or negedge rst_n_i)
begin
	if(~rst_n_i)
	begin
		pachet_trimis<=0;
		req_o <= 0;
		counter <=1;
	end 
	
	else begin

   if ((counter < 5) && ack_i)  counter<=counter+1; 
	else if (ack_i && (counter ==5)) counter<=counter-1;
	
	case(counter)
	
	DATAFORMAT_WRITE:
		if(~ack_i) 
		begin
			req_o <= 1;
			pachet_trimis<={WR,MB,DATAFORMAT_ADDR,DATAFORMAT_VALUE};
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
			pachet_trimis<={WR,MB,BW_RATE_ADDR, BW_RATE_VALUE};
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
			pachet_trimis<={WR,MB,POWER_CTL_ADDR, POWER_CTL_VALUE};
		end 
		else 
		begin
			pachet_trimis<=0;
			req_o<=0;
		end
			 
	DATAX1_READ:
			begin
				if(~ack_i) 
				begin
					req_o <= 1;
					pachet_trimis<={(~WR),MB,DATAX1_ADDR,ZERO};					
				end 
				else 
				begin	
				   datax<=pachet_returnat;
					pachet_trimis<=0;
					req_o<=0;
				end
						
		   end
			
	DATAY1_READ:
			begin
				if(~ack_i) 
				begin
					req_o <= 1;
					pachet_trimis<={(~WR),MB,DATAY1_ADDR,ZERO};
				end 
				else 
				begin
					datay<=pachet_returnat;
					pachet_trimis<=0;
					req_o<=0;
				end 
			
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
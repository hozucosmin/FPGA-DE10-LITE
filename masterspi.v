module masterspi(

input  clk_i,
input  clk_defazat,
input  rst_n_i,
input  req_i,   
output reg ack_o,  
output reg [7:0]     pachet_trimis, 
input      [15:0]    pachet_primit,  
output      reg      SPI_SDI,
output 		       	clk_c1,  
input                SPI_SDO,  
output      reg      SPI_CS_N

);
    localparam COUNT_MAX =100000;
    reg [22:0] counter;
    reg [15:0] pachet_primit1;
    reg [2:0]  current_state;
    reg [2:0]  next_state;
    localparam IDLE          = 4'b0000;
    localparam WAIT_1SEC     = 4'b0001;
    localparam WRITE         = 4'b0010; 
    localparam READ          = 4'b0011;
    localparam ACKN          = 4'B0100;
   


always @(posedge clk_i or negedge rst_n_i) 
begin
    if(~rst_n_i) current_state<= IDLE;
    else 
    current_state <= next_state;
end
always @(*)
begin
    case (current_state)
    IDLE:       begin
                if(req_i ==1'b1) next_state<= WAIT_1SEC;
                else next_state<=IDLE;
                end   
					 
    WAIT_1SEC:  begin
                if(counter== COUNT_MAX && pachet_primit[15]) 
                begin 
                next_state<=READ;               
                end
                else if(counter== COUNT_MAX &&(~pachet_primit[15])) 
                begin 
                next_state<=WRITE;
                end
                else 
                begin
                next_state<=WAIT_1SEC;              
                end
                end 
					 
    READ :      begin
                if(counter==16) next_state<=ACKN;
                else next_state<=READ;
					 end
					 
    WRITE:      begin
                if(counter==16) next_state<=ACKN;
                else next_state<=WRITE;
                end
					 
    ACKN:       begin
                next_state <= IDLE;
                end 
					 
    default : next_state <= IDLE;
    endcase
end

assign clk_c1 = SPI_CS_N? 1'b1 : clk_defazat;



always @ (posedge clk_i or negedge rst_n_i) begin
    if (~rst_n_i) begin
        ack_o <= 1'b0;
        pachet_trimis<=0;
        SPI_SDI <= 1'b0;
        SPI_CS_N <= 1'b1;
        counter <=0;		
        end
			  
    else begin
       case(current_state)  
		 
        IDLE:
        begin
                ack_o <= 1'b0;
                SPI_CS_N <= 1'b1;
        end
		  
        WAIT_1SEC:
        begin
            pachet_primit1 <= pachet_primit;
            if(counter != COUNT_MAX) counter<=counter+1;
            else counter <=0;   
        end 
		  
        READ: 
        begin
            SPI_CS_N = 1'b0;  
            if (counter<8)
            begin 
                pachet_primit1 <= pachet_primit1<<1; 
                SPI_SDI <= pachet_primit1[15]; 
            end         
            else 
            begin  				 
				 pachet_trimis<=pachet_trimis << 1;
             pachet_trimis[0]<=SPI_SDO;    
            end
             counter<=counter+1;
        end
		  
        WRITE: 
        begin
            SPI_CS_N = 1'b0;   
            pachet_primit1<=pachet_primit1<<1; 
            SPI_SDI <=pachet_primit1[15];       
			   counter<=counter+1;
        end
		  
        ACKN: 
        begin
            ack_o<=1'b1;
            SPI_CS_N<=1'b1;
            counter<=0;  
				
        end
        endcase  
		
   end
end 
endmodule
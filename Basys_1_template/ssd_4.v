`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Description: This module drives the seven segment displays. It // has got 8 different inputs
//						for the 8 digits on the board. // It's inputs are not directly the binary numbers.
//						 
//	a[0],b[0],c[0],d[0],e[0],f[0],g[0],p[0] belongs to digit0, rigth 
// most digit on the board.
//	a[1],b[1],c[1],d[1],e[1],f[1],g[1],p[1] belongs to digit1, 2.
// from the rigth most digit on the board.
//	a[2],b[2],c[2],d[2],e[2],f[2],g[2],p[2] belongs to digit2, 3. 
// from the rigth most digit on the board.
//	a[3],b[3],c[3],d[3],e[3],f[3],g[3],p[3] belongs to digit3, 3. 
// from the rigth most digit on the board.
//	a[4],b[4],c[4],d[4],e[4],f[4],g[4],p[4] belongs to digit4, 4. 
// from the rigth most digit on the board.
//	a[5],b[5],c[5],d[5],e[5],f[5],g[5],p[5] belongs to digit5, 5. 
// from the rigth most digit on the board.
//
//	a[6],b[6],c[6],d[6],e[6],f[6],g[6],p[6]belongs to digit6, 6. 
// from the rigth most digit on the board.
//
//	a[7],b[7],c[7],d[7],e[7],f[7],g[7],p[7] belongs to digit7, 
// left most digit on the board.
//						
// The values that you connect to these inputs will appear on the 
// display digits.
// Thus, you just need to make the appropriate connections.
//
//
//////////////////////////////////////////////////////////////////////////////////

module ssd(
    input clk,
    input rst,
    input [6:0] SSD3,
    input [6:0] SSD2,
    input [6:0] SSD1,
    input [6:0] SSD0,
    output reg a_out,
    output reg b_out,
    output reg c_out,
    output reg d_out,
    output reg e_out,
    output reg f_out,
    output reg g_out,
    output reg p_out,
	output reg [3:0] an
          );



reg [2:0] state;//holds state number (3 bit)
reg [14:0] counter;//counter to slow the input clock(15 bit)

//in this always block the speed of the clock reduced by 25000 times so that display works properly
always @ (posedge clk) begin //state counter
    if(rst) begin	//synchronus reset
        state <= 0;		//if reset set state and counter to zero
        counter <= 0;
    end 
    else begin //else the counter untill 25000

        if(counter == 15'h61A8) begin	 //if equal to 25000
            if (state == 3'b100) //if it is in the last state return to state 1
                state <= 1;
            else 						//else go one state up
                state <= state + 1;
            
            counter <= 0;		//0 the counter because after it reaches 25000
        end
        else
            counter <= counter + 1; //if not 25000 add 1
    end
end

//in this always block we give the inputs to the leds by choosing 
//different display segment in each time

always@(posedge clk)
begin
	if(rst)// if reset initilize the outputs
	begin
		an[3:0] <= 4'b1111;
		a_out <= 1;
		b_out  <= 1;
		c_out  <= 1;
		d_out  <= 1;
		e_out  <= 1;
		f_out  <= 1;
		g_out  <= 1;
		p_out  <= 1;
	end
	else
	begin
	   case(state)
	   1:
	   begin
            an[3:0] <= 4'b1110;
            a_out  <= SSD0[6];
            b_out  <= SSD0[5];
            c_out  <= SSD0[4];
            d_out  <= SSD0[3];
            e_out  <= SSD0[2];
            f_out  <= SSD0[1];
            g_out  <= SSD0[0];
	   end
	   2:
	   begin
            an[3:0] <= 4'b1101;
            a_out  <= SSD1[6];
            b_out  <= SSD1[5];
            c_out  <= SSD1[4];
            d_out  <= SSD1[3];
            e_out  <= SSD1[2];
            f_out  <= SSD1[1];
            g_out  <= SSD1[0];
	   end
	   3:
	   begin
            an[3:0] <= 4'b1011;
            a_out  <= SSD2[6];
            b_out  <= SSD2[5];
            c_out  <= SSD2[4];
            d_out  <= SSD2[3];
            e_out  <= SSD2[2];
            f_out  <= SSD2[1];
            g_out  <= SSD2[0];
	   end
	   4:
	   begin
            an[3:0] <= 4'b0111;
            a_out  <= SSD3[6];
            b_out  <= SSD3[5];
            c_out  <= SSD3[4];
            d_out  <= SSD3[3];
            e_out  <= SSD3[2];
            f_out  <= SSD3[1];
            g_out  <= SSD3[0];
	   end
	   endcase
	end
	
	
end

endmodule

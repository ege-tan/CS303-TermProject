`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/05/2023 05:35:09 PM
// Design Name: 
// Module Name: top_module
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module top_module(
    input clk,
    input rst,
    
    input BTNA,
    input BTNB,
    
    input [1:0] DIRA,
    input [1:0] DIRB,
    
    input [2:0] YA,
    input [2:0] YB,
   
    output LEDA,
    output LEDB,
    output [4:0] LEDX,
    
    output a_out,b_out,c_out,d_out,e_out,f_out,g_out,p_out,
    output [7:0]an
);

wire clock ,btn_a ,btn_b;
wire [6:0] ssd0;
wire [6:0] ssd1;
wire [6:0] ssd2;
wire [6:0] ssd3;
wire [6:0] ssd4;
wire [6:0] ssd5;
wire [6:0] ssd6;
wire [6:0] ssd7;

clk_divider dividermodule (clk,rst,clock);

debouncer A (clock,rst,BTNA,btn_a);
debouncer B (clock,rst,BTNB,btn_b);

hockey mymodule (clock,rst,btn_a,btn_b,DIRA,DIRB,YA,YB,LEDA,LEDB,LEDX,ssd7,ssd6,ssd5,ssd4,ssd3,ssd2,ssd1,ssd0);

ssd displa_ssd (clk,rst,ssd7,ssd6,ssd5,ssd4,ssd3,ssd2,ssd1,ssd0,a_out,b_out,c_out,d_out,e_out,f_out,g_out,p_out,an);
    
   
	
endmodule

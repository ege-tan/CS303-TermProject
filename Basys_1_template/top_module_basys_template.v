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
    
    input [1:0] DIRA, // You will use DIRA for both DIRA and DIRB (The switches will be the same: connect the DIRB input of hockey module to DIRA as well)
    
    input [2:0] YA,
    input [2:0] YB,
   
    output LEDA,
    output LEDB,
    output [4:0] LEDX,
    
    output a_out,b_out,c_out,d_out,e_out,f_out,g_out,p_out,
    output [3:0]an
);
	
	
endmodule

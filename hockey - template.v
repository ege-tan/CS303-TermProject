module hockey(

    input clk,
    input rst,
    
    input BTNA,
    input BTNB,
    
    input [1:0] DIRA,
    input [1:0] DIRB,
    
    input [2:0] YA,
    input [2:0] YB,
   
    output reg LEDA,
    output reg LEDB,
    output reg [4:0] LEDX,
    
    output reg [6:0] SSD7,
    output reg [6:0] SSD6,
    output reg [6:0] SSD5,
    output reg [6:0] SSD4, 
    output reg [6:0] SSD3,
    output reg [6:0] SSD2,
    output reg [6:0] SSD1,
    output reg [6:0] SSD0   
    
    );
    
    // you may use additional always blocks or drive SSDs and LEDs in one always block
    // for state machine and memory elements 
    always @(posedge clk or posedge rst)
    begin
       
    
    end
    
    // for SSDs
    always @ (*)
   
    
    end
    
    //for LEDs
    always @ (*)
    begin
        
      
    
    end
    
    
endmodule

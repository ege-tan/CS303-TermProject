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
    reg [2:0] X_COORD;
	reg [2:0] Y_COORD;

    // you may use additional always blocks or drive SSDs and LEDs in one always block
    // for state machine and memory elements 
    reg [9:0] mytime = 10'b0001100100; 
    reg [2:0] blink ;
    // Define the counter
    reg [9:0] counter = 10'b0000000000;
    
    // Define states for the game
    parameter IDLE   = 4'b0000;
    parameter DISP   = 4'b0001;
    parameter HIT_B  = 4'b0010;
    parameter HIT_A  = 4'b0011;
    parameter SEND_A = 4'b0100;
    parameter SEND_B = 4'b0101;
    parameter RESP_A = 4'b0110;
    parameter RESP_B = 4'b0111;
    parameter GOAL_A = 4'b1000;
    parameter GOAL_B = 4'b1001;
    parameter ENDstate = 4'b1010;

    reg [3:0] current_state;
    reg [3:0] next_state;
    reg [1:0] a_score;
    reg [1:0] b_score;
    reg turn;
    reg [1:0] dirY;
    
    // you may use additional always blocks or drive SSDs and LEDs in one always block
    // for state machine and memory elements 
    always @(posedge clk or posedge rst)begin
        //$display (current_state);
        if (rst)begin
            counter <= 0;
            a_score <= 0;
            b_score <=0;
            X_COORD <= 0;
            Y_COORD <= 0;
            current_state <= IDLE;
            dirY <= 0;
            blink <= 0;
            turn <= 0;
        end 
        else case(current_state)
            IDLE:
            begin
                if (BTNA == 1 && BTNB == 0)begin
                   turn <= 0;
                   current_state <= DISP;           
                end
                else if (BTNA == 0 && BTNB == 1)begin
                    turn <= 1;
                    current_state <= DISP;
                end
                else if (BTNA == 0 && BTNB == 0)begin
                    current_state <= IDLE;
                end
                else begin
                    current_state <= IDLE;
                end
            end
            DISP:
            begin
                if (counter < mytime) begin
                    counter <= counter + 1;
                    //display the score
                    current_state <= DISP;
                end
                else begin
                    counter <= 0;
                    if (turn == 1)begin
                        current_state <= HIT_B;
                    end
                    else begin
                        current_state <= HIT_A;
                    end
                end
            end
            HIT_A:
            begin
                if (BTNA == 1 && YA < 5 )begin
                    X_COORD <= 0;
                    Y_COORD <= YA;
                    dirY <= DIRA;
                    current_state <= SEND_B;
                end
                else begin
                    current_state <= HIT_A;
                end
            end
            HIT_B:
            begin
                if (BTNB == 1 && YB < 5)begin
                    X_COORD <= 4;
                    Y_COORD <= YB;
                    dirY <= DIRB;
                    current_state <= SEND_A;
                end
                else begin
                    current_state <= HIT_B;
                end
            end
            SEND_A:
            begin
                if (counter < mytime) begin
                    counter <= counter + 1;
                    current_state <= SEND_A;
                end 
                else begin
                    counter <= 0;
                    if(dirY == 2'b10)begin
                        if(Y_COORD == 0)begin
                            dirY <= 2'b01;
                            Y_COORD <= Y_COORD + 1;
                            if(X_COORD > 1)begin
                                X_COORD <= X_COORD - 1;
                                current_state <= SEND_A;
                            end
                            else begin
                                X_COORD <= 0;
                                current_state <= RESP_A;
                            end
                        end
                        else begin
                            Y_COORD <= Y_COORD - 1;
                            if(X_COORD > 1)begin
                                X_COORD <= X_COORD - 1;
                                current_state <= SEND_A;
                            end
                            else begin
                                X_COORD <= 0;
                                current_state <= RESP_A;
                            end
                        end
                    end
                    else if(dirY == 2'b01)begin
                        if(Y_COORD == 4)begin
                            dirY <= 2'b10;
                            Y_COORD <= Y_COORD - 1;
                            if(X_COORD > 1)begin
                                X_COORD <= X_COORD - 1;
                                current_state <= SEND_A;
                            end
                            else begin
                                X_COORD <= 0;
                                current_state <= RESP_A;
                            end
                        end
                        else begin
                            Y_COORD <= Y_COORD + 1;
                            if(X_COORD > 1)begin
                                X_COORD <= X_COORD - 1;
                                current_state <= SEND_A;
                            end
                            else begin
                                X_COORD <= 0;
                                current_state <= RESP_A;
                            end
                        end
                    end
                    else if (dirY == 2'b00)begin
                        if(X_COORD > 1)begin
                            X_COORD <= X_COORD - 1;
                            current_state <= SEND_A;
                        end
                        else begin
                            X_COORD <= 0;
                            current_state <= RESP_A;
                        end
                    end
                    else begin
                        //defult
                        if(X_COORD > 1)begin
                            X_COORD <= X_COORD + 1;
                            current_state <= SEND_A;
                        end
                        else begin
                            X_COORD <= 0;
                            current_state <= RESP_A;
                        end
                        //default (00 ile aynÄ±)
                    end
                end
            end
            RESP_A:
            begin
                if (counter < mytime) begin
                    if(BTNA == 1 && Y_COORD == YA)begin
                        X_COORD <= 1;
                        counter <= 0;
                        if(DIRA == 2'b00)begin
                            dirY <= DIRA;
                            current_state <= SEND_B;
                        end
                        else if(DIRA == 2'b01)begin
                            if(Y_COORD == 4)begin
                                dirY <= 2'b10;
                                Y_COORD <= Y_COORD - 1;
                                current_state <= SEND_B;
                            end
                            else begin
                                dirY <= DIRA;
                                Y_COORD <= Y_COORD + 1;
                                current_state <= SEND_B;
                            end
                        end
                        else if(DIRA == 2'b10)begin
                            if(Y_COORD == 0)begin
                                dirY <= 2'b01;
                                Y_COORD <= Y_COORD + 1;
                                current_state <= SEND_B;
                            end
                            else begin
                                dirY <= DIRA;
                                Y_COORD <= Y_COORD -1;
                                current_state <= SEND_B;
                            end
                        end
                        else begin
                            dirY <= DIRA;
                            current_state <= SEND_B;
                        end
                    end
                    else begin
                        counter <= counter + 1;
                        current_state <= RESP_A;
                    end
                end 
                else begin
                    counter <= 0;
                    b_score <= b_score + 1;
                    current_state <= GOAL_B;                                       
               end
            end
            GOAL_B:
            begin
                //$display (a_score ,b_score);
                if (counter < mytime) begin
                    counter <= counter + 1;
                    current_state <= GOAL_B;
                end 
                else begin
                    counter <= 0;
                    if(b_score == 3)begin
                        turn <= 1;
                        counter <= 0;
                        current_state <= ENDstate;
                    end
                    else begin
                        current_state <= HIT_A;
                    end
                end
            end
            SEND_B:
            begin
                if (counter < mytime) begin
                    counter <= counter + 1;
                    current_state <= SEND_B;
                end 
                else begin
                    counter <= 0;
                    if(dirY == 2'b10)begin
                        if(Y_COORD == 0)begin
                            dirY <= 2'b01;
                            Y_COORD <= Y_COORD + 1;
                            if(X_COORD < 3)begin
                                X_COORD <= X_COORD + 1;
                                current_state <= SEND_B;
                            end
                            else begin
                                X_COORD <= 4;
                                current_state <= RESP_B;
                            end
                        end
                        else begin
                            Y_COORD <= Y_COORD - 1;
                            if(X_COORD < 3)begin
                                X_COORD <= X_COORD + 1;
                                current_state <= SEND_B;
                            end
                            else begin
                                X_COORD <= 4;
                                current_state <= RESP_B;
                            end
                        end
                    end
                    else if(dirY == 2'b01)begin
                        if(Y_COORD == 4)begin
                            dirY <= 2'b10;
                            Y_COORD <= Y_COORD - 1;
                            if(X_COORD < 3)begin
                                X_COORD <= X_COORD + 1;
                                current_state <= SEND_B;
                            end
                            else begin
                                X_COORD <= 4;
                                current_state <= RESP_B;
                            end
                        end
                        else begin
                            Y_COORD <= Y_COORD + 1;
                            if(X_COORD < 3)begin
                                X_COORD <= X_COORD + 1;
                                current_state <= SEND_B;
                            end
                            else begin
                                X_COORD <= 4;
                                current_state <= RESP_B;
                            end
                        end
                    end
                    else if (dirY == 2'b00)begin
                        if(X_COORD < 3)begin
                            X_COORD <= X_COORD + 1;
                            current_state <= SEND_B;
                        end
                        else begin
                            X_COORD <= 4;
                            current_state <= RESP_B;
                        end
                    end
                    else begin
                        //defult
                        if(X_COORD < 3)begin
                            X_COORD <= X_COORD + 1;
                            current_state <= SEND_B;
                        end
                        else begin
                            X_COORD <= 4;
                            current_state <= RESP_B;
                        end
                        //default (00 ile aynÃ¯Â¿Â½)
                    end
                end
            end
            RESP_B:
            begin
                if (counter < mytime) begin
                    if (BTNB == 1 && Y_COORD == YB)begin
                        X_COORD <= 3;
                        counter <= 0;
                        if (DIRB == 2'b00)begin
                            dirY <= DIRB;
                            current_state <= SEND_A;
                        end
                        if (DIRB == 2'b01)begin
                            if (Y_COORD == 4) begin
                                dirY <= 2'b10;
                                Y_COORD <= Y_COORD - 1;
                                current_state <= SEND_A;
                            end
                            else begin
                                dirY <= DIRB;
                                Y_COORD <= Y_COORD + 1;
                                current_state <= SEND_A;
                            end
                        end
                        if (DIRB == 2'b10) begin
                            if (Y_COORD == 0) begin
                                dirY <= 2'b01;
                                Y_COORD <= Y_COORD + 1;
                                current_state <= SEND_A;
                            end
                            else begin
                                dirY <= DIRB;
                                Y_COORD <= Y_COORD - 1;
                                current_state <= SEND_A;
                            end
                        end
                        else begin
                            dirY <= DIRB;
                            current_state <= SEND_A;
                        end
                    end
                    else begin
                        counter <= counter + 1;
                        current_state <= RESP_B;
                    end
                end
                else begin
                    counter <= 0;
                    a_score <= a_score + 1;
                    current_state <= GOAL_A;
                end
            end
            GOAL_A:
            begin
                //$display (a_score ,b_score);
                if (counter < mytime) begin
                    counter <= counter + 1;
                    current_state <= GOAL_A;
                end    
                else begin
                    counter <= 0;
                    if (a_score == 3) begin
                        turn <= 0;
                        counter <= 0;
                        current_state <= ENDstate;
                    end
                    else begin
                        current_state <= HIT_B;
                    end
                end
            end
            ENDstate:
            begin
                current_state <= ENDstate;
                if(counter < (mytime/2))begin
                    counter <= 1+ counter;
                    blink <= 0;
                
                end
                else if (counter< mytime)begin
                    counter <= counter + 1;
                    blink <= 1;
                end
                else begin
                    counter <= 0;
                    blink <= 0;
                end        
            end
            default:
            begin
                current_state <= ENDstate;
                if(counter < (mytime/2))begin
                    counter <= 1+ counter;
                    blink <= 0;
                
                end
                else if (counter< mytime)begin
                    counter <= counter + 1;
                    blink <= 1;
                end
                else begin
                    counter <= 0;
                    blink <= 0;
                end        
            end
        endcase
    end
    
    // for SSDs
    always @ (*)
    begin
        SSD3 = 7'b1111111;
        SSD5 = 7'b1111111;
        SSD6 = 7'b1111111;
        SSD7 = 7'b1111111;
        case (current_state)
            IDLE:
            begin
                // A-b
                SSD0 = 7'b1100000;
                SSD1 = 7'b1111110;
                SSD2 = 7'b0001000;
                SSD4 = 7'b1111111;
            end
            DISP:
            begin
                // 0-0
                SSD0 = 7'b0000001;
                SSD1 = 7'b1111110;
                SSD2 = 7'b0000001;
                SSD4 = 7'b1111111;
            end
            HIT_A:
            begin
                if(YA < 3'b101)
                begin
                    if(YA == 3'b000)
                    begin
                        SSD0 = 7'b1111111;
                        SSD1 = 7'b1111111;
                        SSD2 = 7'b1111111;
                        SSD4 = 7'b0000001;
                    end
                    else if(YA == 3'b001)
                    begin
                        SSD0 = 7'b1111111;
                        SSD1 = 7'b1111111;
                        SSD2 = 7'b1111111;
                        SSD4 = 7'b1001111;
                    end
                    
                    else if(YA == 3'b010)
                    begin
                        SSD0 = 7'b1111111;
                        SSD1 = 7'b1111111;
                        SSD2 = 7'b1111111;
                        SSD4 = 7'b0010010;
                    end
                    
                    else if(YA == 3'b011)
                    begin
                        SSD0 = 7'b1111111;
                        SSD1 = 7'b1111111;
                        SSD2 = 7'b1111111;
                        SSD4 = 7'b0000110;
                    end
                    
                    else if(YA == 3'b100)
                    begin
                        SSD0 = 7'b1111111;
                        SSD1 = 7'b1111111;
                        SSD2 = 7'b1111111;
                        SSD4 = 7'b1001100;
                    end
                    
                    else
                    begin
                        SSD0 = 7'b1111111;
                        SSD1 = 7'b1111111;
                        SSD2 = 7'b1111111;
                        SSD4 = 7'b1001100;
                    end
                end
                else
                begin
                    SSD0 = 7'b1111111;
                    SSD1 = 7'b1111111;
                    SSD2 = 7'b1111111;
                    SSD4 = 7'b1111110;
                end
            end
            HIT_B:
            begin
                if(YB < 3'b101)
                begin
                    if(YB == 3'b000)
                    begin
                        SSD0 = 7'b1111111;
                        SSD1 = 7'b1111111;
                        SSD2 = 7'b1111111;
                        SSD4 = 7'b0000001;
                    end
                    else if(YB == 3'b001)
                    begin
                        SSD0 = 7'b1111111;
                        SSD1 = 7'b1111111;
                        SSD2 = 7'b1111111;
                        SSD4 = 7'b1001111;
                    end
                    
                    else if(YB == 3'b010)
                    begin
                        SSD0 = 7'b1111111;
                        SSD1 = 7'b1111111;
                        SSD2 = 7'b1111111;
                        SSD4 = 7'b0010010;
                    end
                    
                    else if(YB == 3'b011)
                    begin
                        SSD0 = 7'b1111111;
                        SSD1 = 7'b1111111;
                        SSD2 = 7'b1111111;
                        SSD4 = 7'b0000110;
                    end
                    
                    else if(YB == 3'b100)
                    begin
                        SSD0 = 7'b1111111;
                        SSD1 = 7'b1111111;
                        SSD2 = 7'b1111111;
                        SSD4 = 7'b1001100;
                    end
                    
                    else
                    begin
                        SSD0 = 7'b1111111;
                        SSD1 = 7'b1111111;
                        SSD2 = 7'b1111111;
                        SSD4 = 7'b1001100;
                    end
                end
                else
                begin
                    SSD0 = 7'b1111111;
                    SSD1 = 7'b1111111;
                    SSD2 = 7'b1111111;
                    SSD4 = 7'b1111110;
                end
            end
            RESP_A:
            begin
                if(Y_COORD == 3'b000)
                begin
                    SSD0 = 7'b1111111;
                    SSD1 = 7'b1111111;
                    SSD2 = 7'b1111111;
                    SSD4 = 7'b0000001;
                end
                else if(Y_COORD == 3'b001)
                begin
                    SSD0 = 7'b1111111;
                    SSD1 = 7'b1111111;
                    SSD2 = 7'b1111111;
                    SSD4 = 7'b1001111;
                end
                else if(Y_COORD == 3'b010)
                begin
                    SSD0 = 7'b1111111;
                    SSD1 = 7'b1111111;
                    SSD2 = 7'b1111111;
                    SSD4 = 7'b0010010;
                end
                else if(Y_COORD == 3'b011)
                begin
                    SSD0 = 7'b1111111;
                    SSD1 = 7'b1111111;
                    SSD2 = 7'b1111111;
                    SSD4 = 7'b0000110;
                end
                else if(Y_COORD == 3'b100)
                begin
                    SSD0 = 7'b1111111;
                    SSD1 = 7'b1111111;
                    SSD2 = 7'b1111111;
                    SSD4 = 7'b1001100;
                end
                else
                    begin
                        SSD0 = 7'b1111111;
                        SSD1 = 7'b1111111;
                        SSD2 = 7'b1111111;
                        SSD4 = 7'b1001100;
                    end
            end
            RESP_B:
            begin
                if(Y_COORD == 3'b000)
                begin
                    SSD0 = 7'b1111111;
                    SSD1 = 7'b1111111;
                    SSD2 = 7'b1111111;
                    SSD4 = 7'b0000001;
                end
                else if(Y_COORD == 3'b001)
                begin
                    SSD0 = 7'b1111111;
                    SSD1 = 7'b1111111;
                    SSD2 = 7'b1111111;
                    SSD4 = 7'b1001111;
                end
                else if(Y_COORD == 3'b010)
                begin
                    SSD0 = 7'b1111111;
                    SSD1 = 7'b1111111;
                    SSD2 = 7'b1111111;
                    SSD4 = 7'b0010010;
                end
                else if(Y_COORD == 3'b011)
                begin
                    SSD0 = 7'b1111111;
                    SSD1 = 7'b1111111;
                    SSD2 = 7'b1111111;
                    SSD4 = 7'b0000110;
                end
                else if(Y_COORD == 3'b100)
                begin
                    SSD0 = 7'b1111111;
                    SSD1 = 7'b1111111;
                    SSD2 = 7'b1111111;
                    SSD4 = 7'b1001100;
                end
                else
                    begin
                        SSD0 = 7'b1111111;
                        SSD1 = 7'b1111111;
                        SSD2 = 7'b1111111;
                        SSD4 = 7'b1001100;
                    end
            end
            SEND_A:
            begin
                if(Y_COORD == 3'b000)
                begin
                    SSD0 = 7'b1111111;
                    SSD1 = 7'b1111111;
                    SSD2 = 7'b1111111;
                    SSD4 = 7'b0000001;
                end
                else if(Y_COORD == 3'b001)
                begin
                    SSD0 = 7'b1111111;
                    SSD1 = 7'b1111111;
                    SSD2 = 7'b1111111;
                    SSD4 = 7'b1001111;
                end
                else if(Y_COORD == 3'b010)
                begin
                    SSD0 = 7'b1111111;
                    SSD1 = 7'b1111111;
                    SSD2 = 7'b1111111;
                    SSD4 = 7'b0010010;
                end
                else if(Y_COORD == 3'b011)
                begin
                    SSD0 = 7'b1111111;
                    SSD1 = 7'b1111111;
                    SSD2 = 7'b1111111;
                    SSD4 = 7'b0000110;
                end
                else if(Y_COORD == 3'b100)
                begin
                    SSD0 = 7'b1111111;
                    SSD1 = 7'b1111111;
                    SSD2 = 7'b1111111;
                    SSD4 = 7'b1001100;
                end
                else
                    begin
                        SSD0 = 7'b1111111;
                        SSD1 = 7'b1111111;
                        SSD2 = 7'b1111111;
                        SSD4 = 7'b1001100;
                    end
            end
            SEND_B:
            begin
                if(Y_COORD == 3'b000)
                begin
                    SSD0 = 7'b1111111;
                    SSD1 = 7'b1111111;
                    SSD2 = 7'b1111111;
                    SSD4 = 7'b0000001;
                end
                else if(Y_COORD == 3'b001)
                begin
                    SSD0 = 7'b1111111;
                    SSD1 = 7'b1111111;
                    SSD2 = 7'b1111111;
                    SSD4 = 7'b1001111;
                end
                else if(Y_COORD == 3'b010)
                begin
                    SSD0 = 7'b1111111;
                    SSD1 = 7'b1111111;
                    SSD2 = 7'b1111111;
                    SSD4 = 7'b0010010;
                end
                else if(Y_COORD == 3'b011)
                begin
                    SSD0 = 7'b1111111;
                    SSD1 = 7'b1111111;
                    SSD2 = 7'b1111111;
                    SSD4 = 7'b0000110;
                end
                else if(Y_COORD == 3'b100)
                begin
                    SSD0 = 7'b1111111;
                    SSD1 = 7'b1111111;
                    SSD2 = 7'b1111111;
                    SSD4 = 7'b1001100;
                end
                else 
                    begin
                        SSD0 = 7'b1111111;
                        SSD1 = 7'b1111111;
                        SSD2 = 7'b1111111;
                        SSD4 = 7'b1001100;
                    end
            end
            GOAL_A:
            begin
                if(a_score == 3'b000)
                begin
                    SSD2 = 7'b0000001;
                end
                else if(a_score == 3'b001)
                begin
                    SSD2 = 7'b1001111;
                end
                else if(a_score == 3'b010)
                begin
                    SSD2 = 7'b0010010;
                end
                else if(a_score == 3'b011)
                begin
                    SSD2 = 7'b0000110;
                end
                else
                begin
                    SSD2 = 7'b0000110;
                    SSD4 = 7'b1111111;
                    SSD1 = 7'b1111110;
                    SSD0 = 7'b0000001;
                end
                if(b_score == 3'b000)
                begin
                    SSD4 = 7'b1111111;
                    SSD1 = 7'b1111110;
                    SSD0 = 7'b0000001;
                end
                else if(b_score == 3'b001)
                begin
                    SSD4 = 7'b1111111;
                    SSD1 = 7'b1111110;
                    SSD0 = 7'b1001111;
                end
                else if(b_score == 3'b010)
                begin
                    SSD4 = 7'b1111111;
                    SSD1 = 7'b1111110;
                    SSD0 = 7'b0010010;
                end
                else if(b_score == 3'b011)
                begin
                    SSD4 = 7'b1111111;
                    SSD1 = 7'b1111110;
                    SSD0 = 7'b0000110;
                end
                else
                begin
                    SSD2 = 7'b0000110;
                    SSD4 = 7'b1111111;
                    SSD1 = 7'b1111110;
                    SSD0 = 7'b0000110;
                end
            end
            GOAL_B:
            begin
                if(a_score == 3'b000)
                begin
                    SSD2 = 7'b0000001;
                end
                else if(a_score == 3'b001)
                begin
                    SSD2 = 7'b1001111;
                end
                else if(a_score == 3'b010)
                begin
                    SSD2 = 7'b0010010;
                end
                else if(a_score == 3'b011)
                begin
                    SSD2 = 7'b0000110;
                end
                else 
                begin
                    SSD2 = 7'b0000110;
                    SSD4 = 7'b1111111;
                    SSD1 = 7'b1111110;
                    SSD0 = 7'b0000001;
                end
                if(b_score == 3'b000)
                begin
                    SSD4 = 7'b1111111;
                    SSD1 = 7'b1111110;
                    SSD0 = 7'b0000001;
                end
                else if(b_score == 3'b001)
                begin
                    SSD4 = 7'b1111111;
                    SSD1 = 7'b1111110;
                    SSD0 = 7'b1001111;
                end
                else if(b_score == 3'b010)
                begin
                    SSD4 = 7'b1111111;
                    SSD1 = 7'b1111110;
                    SSD0 = 7'b0010010;
                end
                else if(b_score == 3'b011)
                begin
                    SSD4 = 7'b1111111;
                    SSD1 = 7'b1111110;
                    SSD0 = 7'b0000110;
                end
                else 
                begin
                    SSD2 = 7'b0000110;
                    SSD4 = 7'b1111111;
                    SSD1 = 7'b1111110;
                    SSD0 = 7'b0000001;
                end
            end
            ENDstate:
            begin
                if(a_score == 3)
                begin
                    SSD4 = 7'b0001000;
                    SSD2 = 7'b0000110;
                    SSD1 = 7'b1111110;
                    if(b_score == 3'b000)
                    begin
                        SSD0 = 7'b0000001;
                    end
                    else if(b_score == 3'b001)
                    begin
                        SSD0 = 7'b1001111;
                    end
                    else if(b_score == 3'b010)
                    begin
                        SSD0 = 7'b0010010;
                    end
                    else
                    begin
                        SSD0 = 7'b0010010;
                    end
                end
                else if(b_score == 3)
                begin
                    SSD4 = 7'b1100000;
                    SSD1 = 7'b1111110;
                    SSD0 = 7'b0000110;
                    if(a_score == 3'b000)
                    begin
                        SSD2 = 7'b0000001;
                    end
                    else if(a_score == 3'b001)
                    begin
                        SSD2 = 7'b1001111;
                    end
                    else if(a_score == 3'b010)
                    begin
                        SSD2 = 7'b0010010;
                    end
                    else
                    begin
                        SSD2 = 7'b0010010;
                    end
                end
                else if(b_score == 3)
                begin
                    SSD4 = 7'b1100000;
                    SSD1 = 7'b1111110;
                    SSD0 = 7'b0000110;
                    if(a_score == 3'b000)
                    begin
                        SSD2 = 7'b0000001;
                    end
                    else if(a_score == 3'b001)
                    begin
                        SSD2 = 7'b1001111;
                    end
                    else if(a_score == 3'b010)
                    begin
                        SSD2 = 7'b0010010;
                    end
                    else
                    begin
                        SSD2 = 7'b0010010;
                    end
                end
                else
                begin
                    SSD4 = 7'b1100000;
                    SSD1 = 7'b1111110;
                    SSD0 = 7'b0000110;
                    if(a_score == 3'b000)
                    begin
                        SSD2 = 7'b0000001;
                    end
                    else if(a_score == 3'b001)
                    begin
                        SSD2 = 7'b1001111;
                    end
                    else if(a_score == 3'b010)
                    begin
                        SSD2 = 7'b0010010;
                    end
                    else
                    begin
                        SSD2 = 7'b0010010;
                    end
                end
            end
            default:
            begin
                if(a_score == 3)
                begin
                    SSD4 = 7'b0001000;
                    SSD2 = 7'b0000110;
                    SSD1 = 7'b1111110;
                    if(b_score == 3'b000)
                    begin
                        SSD0 = 7'b0000001;
                    end
                    else if(b_score == 3'b001)
                    begin
                        SSD0 = 7'b1001111;
                    end
                    else if(b_score == 3'b010)
                    begin
                        SSD0 = 7'b0010010;
                    end
                    else
                    begin
                        SSD0 = 7'b0010010;
                    end
                end
                else if(b_score == 3)
                begin
                    SSD4 = 7'b1100000;
                    SSD1 = 7'b1111110;
                    SSD0 = 7'b0000110;
                    if(a_score == 3'b000)
                    begin
                        SSD2 = 7'b0000001;
                    end
                    else if(a_score == 3'b001)
                    begin
                        SSD2 = 7'b1001111;
                    end
                    else if(a_score == 3'b010)
                    begin
                        SSD2 = 7'b0010010;
                    end
                    else
                    begin
                        SSD2 = 7'b0010010;
                    end
                end
                else if(b_score == 3)
                begin
                    SSD4 = 7'b1100000;
                    SSD1 = 7'b1111110;
                    SSD0 = 7'b0000110;
                    if(a_score == 3'b000)
                    begin
                        SSD2 = 7'b0000001;
                    end
                    else if(a_score == 3'b001)
                    begin
                        SSD2 = 7'b1001111;
                    end
                    else if(a_score == 3'b010)
                    begin
                        SSD2 = 7'b0010010;
                    end
                    else
                    begin
                        SSD2 = 7'b0010010;
                    end
                end
                else
                begin
                    SSD4 = 7'b1100000;
                    SSD1 = 7'b1111110;
                    SSD0 = 7'b0000110;
                    if(a_score == 3'b000)
                    begin
                        SSD2 = 7'b0000001;
                    end
                    else if(a_score == 3'b001)
                    begin
                        SSD2 = 7'b1001111;
                    end
                    else if(a_score == 3'b010)
                    begin
                        SSD2 = 7'b0010010;
                    end
                    else
                    begin
                        SSD2 = 7'b0010010;
                    end
                end
            end
        endcase
    end

    //for LEDs
    always @ (*)
    begin
        case(current_state)
        IDLE:
        begin
            LEDA = 1;
            LEDB = 1;
            LEDX[0]= 0;
            LEDX[1]= 0;
            LEDX[2]= 0;
            LEDX[3]= 0;
            LEDX[4]= 0;
        end
        DISP:
        begin
            LEDA = 0;
            LEDB = 0;
            LEDX[0]= 1;
            LEDX[1]= 1;
            LEDX[2]= 1;
            LEDX[3]= 1;
            LEDX[4]= 1;
        end
        HIT_B:
        begin
            LEDA = 0;
            LEDB = 1;
            LEDX[0]= 0;
            LEDX[1]= 0;
            LEDX[2]= 0;
            LEDX[3]= 0;
            LEDX[4]= 0;
        end
        HIT_A:
        begin
            LEDA = 1;
            LEDB = 0;
            LEDX[0]= 0;
            LEDX[1]= 0;
            LEDX[2]= 0;
            LEDX[3]= 0;
            LEDX[4]= 0;
        end
        GOAL_A:
        begin
            LEDA = 0;
            LEDB = 0;
            LEDX[0]= 1;
            LEDX[1]= 1;
            LEDX[2]= 1;
            LEDX[3]= 1;
            LEDX[4]= 1;
        end
        GOAL_B:
        begin
            LEDA = 0;
            LEDB = 0;
            LEDX[0]= 1;
            LEDX[1]= 1;
            LEDX[2]= 1;
            LEDX[3]= 1;
            LEDX[4]= 1;
        end
        SEND_A:
        begin
            if(X_COORD == 3'b000)
            begin
                LEDA = 0;
                LEDB = 0;
                LEDX[0]= 0;
                LEDX[1]= 0;
                LEDX[2]= 0;
                LEDX[3]= 0;
                LEDX[4]= 1;
            end
            else if(X_COORD == 3'b001)
            begin
                LEDA = 0;
                LEDB = 0;
                LEDX[0]= 0;
                LEDX[1]= 0;
                LEDX[2]= 0;
                LEDX[3]= 1;
                LEDX[4]= 0;
            end
           else if(X_COORD == 3'b010)
            begin
                LEDA = 0;
                LEDB = 0;
                LEDX[0]= 0;
                LEDX[1]= 0;
                LEDX[2]= 1;
                LEDX[3]= 0;
                LEDX[4]= 0;
            end
            else if(X_COORD == 3'b011)
            begin
                LEDA = 0;
                LEDB = 0;
                LEDX[0]= 0;
                LEDX[1]= 1;
                LEDX[2]= 0;
                LEDX[3]= 0;
                LEDX[4]= 0;
            end
            else if(X_COORD == 3'b100)
            begin
                LEDA = 0;
                LEDB = 0;
                LEDX[0]= 1;
                LEDX[1]= 0;
                LEDX[2]= 0;
                LEDX[3]= 0;
                LEDX[4]= 0;
            end
            else
            begin
                LEDA = 0;
                LEDB = 0;
                LEDX[0]= 1;
                LEDX[1]= 0;
                LEDX[2]= 0;
                LEDX[3]= 0;
                LEDX[4]= 0;
            end
        end
        SEND_B:
        begin
            if(X_COORD == 3'b000)
            begin
                LEDA = 0;
                LEDB = 0;
                LEDX[0]= 0;
                LEDX[1]= 0;
                LEDX[2]= 0;
                LEDX[3]= 0;
                LEDX[4]= 1;
            end
            else if(X_COORD == 3'b001)
            begin
                LEDA = 0;
                LEDB = 0;
                LEDX[0]= 0;
                LEDX[1]= 0;
                LEDX[2]= 0;
                LEDX[3]= 1;
                LEDX[4]= 0;
            end
            else if(X_COORD == 3'b010)
            begin
                LEDA = 0;
                LEDB = 0;
                LEDX[0]= 0;
                LEDX[1]= 0;
                LEDX[2]= 1;
                LEDX[3]= 0;
                LEDX[4]= 0;
            end
            else if(X_COORD == 3'b011)
            begin
                LEDA = 0;
                LEDB = 0;
                LEDX[0]= 0;
                LEDX[1]= 1;
                LEDX[2]= 0;
                LEDX[3]= 0;
                LEDX[4]= 0;
            end
            else if(X_COORD == 3'b100)
            begin
                LEDA = 0;
                LEDB = 0;
                LEDX[0]= 1;
                LEDX[1]= 0;
                LEDX[2]= 0;
                LEDX[3]= 0;
                LEDX[4]= 0;
            end
            else
            begin
                LEDA = 0;
                LEDB = 0;
                LEDX[0]= 1;
                LEDX[1]= 0;
                LEDX[2]= 0;
                LEDX[3]= 0;
                LEDX[4]= 0;
            end
        end
        RESP_A:
        begin
            LEDA = 1;
            LEDB = 0;
            LEDX[0]= 0;
            LEDX[1]= 0;
            LEDX[2]= 0;
            LEDX[3]= 0;
            LEDX[4]= 1;
        end
        RESP_B:
        begin
            LEDA = 0;
            LEDB = 1;
            LEDX[0]= 1;
            LEDX[1]= 0;
            LEDX[2]= 0;
            LEDX[3]= 0;
            LEDX[4]= 0;
        end
        ENDstate:
        begin
            LEDA = 0;
            LEDB = 0;
            if(blink == 0)
            begin
                LEDX[0]= 1;
                LEDX[1]= 0;
                LEDX[2]= 1;
                LEDX[3]= 0;
                LEDX[4]= 1;
            end
            else if(blink == 1)
            begin
                LEDX[0]= 0;
                LEDX[1]= 1;
                LEDX[2]= 0;
                LEDX[3]= 1;
                LEDX[4]= 0;   
            end   
            else
            begin
                LEDX[0]= 0;
                LEDX[1]= 1;
                LEDX[2]= 0;
                LEDX[3]= 1;
                LEDX[4]= 0;   
            end                       
        end
        default:
        begin
            LEDA = 0;
            LEDB = 0;
            if(blink == 0)
            begin
                LEDX[0]= 1;
                LEDX[1]= 0;
                LEDX[2]= 1;
                LEDX[3]= 0;
                LEDX[4]= 1;
            end
            else if(blink == 1)
            begin
                LEDX[0]= 0;
                LEDX[1]= 1;
                LEDX[2]= 0;
                LEDX[3]= 1;
                LEDX[4]= 0;   
            end   
            else
            begin
                LEDX[0]= 0;
                LEDX[1]= 1;
                LEDX[2]= 0;
                LEDX[3]= 1;
                LEDX[4]= 0;   
            end  
        end
        endcase
    end
endmodule
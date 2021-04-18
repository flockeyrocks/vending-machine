`timescale 1ns / 1ps

module vending_machine_fsm(
    input clk, c5, c10, c25, item_taken, reset_n,
    output dispense, 
    output r5, r10, r20,
    output [7:0] amount
    );
    
    localparam s0=4'b0000, s1=4'b0001, s2=4'b0010, s3=4'b0011, s4=4'b0100,
               s5=4'b0101, s6=4'b0110, s7=4'b0111, s8=4'b1000,
               s9=4'b1001;
               
    reg[3:0] state_reg, state_next;
    
    wire[2:0] coins;
    assign coins = {c25,c10,c5};
    
    always @(posedge clk, negedge reset_n)
    begin
        if(~reset_n)
        begin
            state_reg <= 0;
        end
        else
            state_reg <= state_next;   
    end
    
    always@*
    begin
        case(state_reg)
            s0: case(coins)
                    3'b000:state_next = s0;
                    3'b001:state_next = s1;
                    3'b010:state_next = s2;
                    3'b100:state_next = s5;
                endcase
                    
            s1: case(coins)
                    3'b000:state_next = s1;
                    3'b001:state_next = s2;
                    3'b010:state_next = s3;
                    3'b100:state_next = s6;
                endcase
                    
            s2: case(coins)
                    3'b000:state_next = s2;
                    3'b001:state_next = s3;
                    3'b010:state_next = s4;
                    3'b100:state_next = s7;
                endcase
                    
            s3: case(coins)
                    3'b000:state_next = s3;
                    3'b001:state_next = s4;
                    3'b010:state_next = s5;
                    3'b100:state_next = s8;
                endcase
                    
            s4: case(coins)
                    3'b000:state_next = s4;
                    3'b001:state_next = s5;
                    3'b010:state_next = s6;
                    3'b100:state_next = s9;
                endcase
                    
            s5: case(item_taken)
                    1'b0:state_next = s5;
                    1'b1:state_next = s0;
                endcase
                                  
            s6: case(item_taken)
                    1'b0:state_next = s6;
                    1'b1:state_next = s0;
                endcase 
                    
            s7: case(item_taken)
                    1'b0:state_next = s7;
                    1'b1:state_next = s0;
                endcase 
            
            s8: case(item_taken)
                    1'b0:state_next = s8;
                    1'b1:state_next = s0;
                endcase 
                    
            s9: case(item_taken)
                    1'b0:state_next = s9;
                    1'b1:state_next = s0;
                endcase 
            
            default state_next = state_reg;
            
        endcase
    end
    
    assign dispense = (state_reg == s5) | (state_reg == s6) | (state_reg == s7) | 
                      (state_reg == s8) | (state_reg == s9);
    assign r5 = (state_reg == s6) | (state_reg == s8);
    assign r10 = (state_reg == s7) | (state_reg == s8);
    assign r20 = (state_reg == s9);
    assign amount = (state_reg*5);
    
endmodule

`timescale 1ns / 1ps

module vending_machine(
    input clk, c5, c10, c25, item_taken, reset_n,
    output [7:0] AN,
    output [6:0] sseg,
    output DP,
    output r5, r10, r20,
    output red_led, green_led
    );
    
    wire c5_edge, c10_edge, c25_edge;
    wire red_led, green_led;
    wire [7:0] amount;
    reg [7:0] return;
    wire [2:0] r_concat;
    
    button_handler fix_buttons(
        .clk(clk),
        .reset_n(reset_n),
        .button_1(c5),
        .button_2(c10),
        .button_3(c25),
        .button_1_edge(c5_edge),
        .button_2_edge(c10_edge),
        .button_3_edge(c25_edge)
    );

    
    vending_machine_fsm vend(
        .clk(clk),
        .c5(c5_edge),
        .c10(c10_edge),
        .c25(c25_edge),
        .item_taken(item_taken),
        .reset_n(reset_n),
        .dispense(dispense),
        .r5(r5),
        .r10(r10),
        .r20(r20),
        .amount(amount)
    );
    
    assign red_led = ~dispense;
    assign green_led = dispense;
    
    assign r_concat = {r20, r10, r5};
    
    always@*
    begin
        case(r_concat)
            8'b00000000: return = 0;
            8'b00000001: return = 5;
            8'b00000010: return = 10;
            8'b00000011: return = 15;
            8'b00000100: return = 20;
            default: return = 0;
        endcase
    end
    
    wire [11:0] amount_BCD, return_BCD;
    
    bin2bcd amountConverter(
        .binary(amount),
        .BCD(amount_BCD)
    );
    
    bin2bcd returnConverter(
        .binary(return),
        .BCD(return_BCD)
    );
    
    sseg_driver #(.DesiredHz(10000)) driver
    (
         .clk(clk),
         .reset_n(1),
         .i0({1'b1,amount_BCD[3:0],1'b1}),
         .i1({1'b1,amount_BCD[7:4],1'b1}),
         .i2({1'b1,amount_BCD[11:8],1'b1}),
         .i4({1'b1,return_BCD[3:0],1'b1}),
         .i5({1'b1,return_BCD[7:4],1'b1}),
         .i6({1'b1,return_BCD[11:8],1'b1}),
         .AN(AN),
         .DP(DP),
         .sseg(sseg)
    );
    
endmodule

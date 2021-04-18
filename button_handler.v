`timescale 1ns / 1ps

module button_handler(
    input clk, reset_n, button_1, button_2, button_3,
    output button_1_edge, button_2_edge, button_3_edge
    );
    
    wire button_1_debounce, button_2_debounce, button_3_debounce;
    
    debouncer_delayed b_1(
        .clk(clk),
        .reset_n(reset_n),
        .noisy(button_1),
        .debounced(button_1_debounce)
    );
    
    debouncer_delayed b_2(
        .clk(clk),
        .reset_n(reset_n),
        .noisy(button_2),
        .debounced(button_2_debounce)
    );
    
    debouncer_delayed b_3(
        .clk(clk),
        .reset_n(reset_n),
        .noisy(button_3),
        .debounced(button_3_debounce)
    );
    
    edge_detector edge_1(
        .clk(clk),
        .reset_n(reset_n),
        .level(button_1_debounce),
        .p_edge(button_1_edge)
    );
    
    edge_detector edge_2(
        .clk(clk),
        .reset_n(reset_n),
        .level(button_2_debounce),
        .p_edge(button_2_edge)
    );
    
    edge_detector edge_3(
        .clk(clk),
        .reset_n(reset_n),
        .level(button_3_debounce),
        .p_edge(button_3_edge)
    );
    
endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.06.2025 11:43:38
// Design Name: 
// Module Name: uart_rx
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


module uart_rx #(
    parameter divisor = 10
)(
    input clk,
    input rst,
    input frame,

    output reg [7:0] data,
    output reg ready,
    output reg error_detected,
    output reg error_corrected,
    output reg overall_parity_error
);

reg [1:0] state;
reg [10:0] clk_counter;
reg [3:0] bit_counter;
reg [12:0] data_register;
wire [7:0] data_decoded;
wire error_wire;
wire wire_error_detected;
wire wire_error_corrected;
wire wire_overall_parity_error;
reg [12:0] reg_for_testing;
//parity_checker #(8) parity_check_rx(data_register, error_wire);
hamming_decoder decoder(data_register, data_decoded, wire_error_detected, wire_error_corrected,wire_overall_parity_error);

always @(posedge clk) begin
    if (rst) begin
        state <= 2'b00;
        clk_counter <= 0;
        bit_counter <= 0;
        data_register <= 0;
        ready <= 0;
        error_detected <= 0;
        error_corrected <= 0;
        overall_parity_error <= 0;
    end
    else begin
        case (state)
            2'b00: begin
                if (frame == 0) begin  // idle stage to identify the start bit
                    clk_counter <= 0;
                    state <= 2'b01;
                    ready <=0;
                end
            end
            
            2'b01: begin
                if (clk_counter < (divisor/2)-1) begin
                    clk_counter <= clk_counter + 1; // waiting for the half bit time
                end
                else begin
                    if (frame == 0) begin
                        clk_counter <= 0;
                        bit_counter <= 0;
                        state <= 2'b10;
                    end
                    else begin
                        state <= 2'b00;
                    end
                end
            end

            2'b10: begin
                if (clk_counter < divisor -1) begin
                    // waiting for full bit here
                    clk_counter <= clk_counter + 1;
                end
                else begin
                    clk_counter <= 0;
                    data_register[bit_counter] <= frame;
                    if (bit_counter < 12) begin
                        bit_counter <= bit_counter + 1;
                    end 
                    else begin
                        state <= 2'b11;
                    end
                end
            end
            
            2'b11: begin
                // Stoping phase
                if (clk_counter < divisor - 1) begin
                    clk_counter <= clk_counter + 1;
                end
                else begin
                    data <= data_decoded;
                    reg_for_testing <= data_register;
                    error_corrected <= wire_error_corrected;
                    error_detected <= wire_error_detected;
                    overall_parity_error <= wire_overall_parity_error;
                    ready <= 1;
                    state <= 2'b00;
                end
            end
            default: state <= 0; 
        endcase
    end
end
endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.06.2025 01:07:54
// Design Name: 
// Module Name: uart_protocol
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


module uart_protocol (
    input clk,
    input rst,
    output reg [7:0] data_from_memory,
    output reg [7:0] data_sent,
    output reg line,
    output reg baud_tick,
    output reg [7:0] data_recorded,
    output reg [7:0] data_saved_to_memory
);


wire [7:0] data_bus;
wire [7:0] data_bus_out;
wire [7:0] data_memory_test;
wire frame;
wire ready;
wire ready_rx;

memory_1 transmitter_memory(clk, ready, rst, data_bus);

uart_tx #(10) transmitter(clk, data_bus, rst, ready, frame);

uart_rx #(10) receiver(clk, rst, frame, data_bus_out, ready_rx);

memory_2 receiver_memory(clk, rst, data_bus_out, ready_rx, data_memory_test);

always @(posedge clk) begin
    data_from_memory <= data_bus;
    data_sent <= transmitter.data_register;
    line <= frame;
    baud_tick <= transmitter.baud_tick;
    data_recorded <= data_bus_out;
    data_saved_to_memory <= data_memory_test;
end



endmodule
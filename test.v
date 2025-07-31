`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/07/2025 12:20:30 AM
// Design Name: 
// Module Name: test
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



module test();

reg clk;
reg rst;
wire [7:0] data_from_memory;
wire [12:0] data_sent;
wire line;
wire baud_tick;
wire [12:0] data_recorded;
wire [7:0] data_saved_to_memory;
wire error_detected;
wire error_corrected;
wire overall_parity_error;

uart_protocol uut(clk, rst, data_from_memory, data_sent, line, baud_tick, data_recorded, data_saved_to_memory, error_detected, error_corrected, overall_parity_error);

initial begin
    rst = 1;
    #40;
    rst = 0; 
end

always #10 clk = ~clk;

initial begin
    clk = 0;
    #25000;
    $finish;
end
endmodule

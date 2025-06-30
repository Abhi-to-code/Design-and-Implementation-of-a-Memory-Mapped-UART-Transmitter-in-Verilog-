`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.06.2025 12:02:21
// Design Name: 
// Module Name: memory_2
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


module memory_2 (
    input clk,
    input rst,
    input [7:0] data,
    input ready,
    output reg [7:0] test
);

reg [4:0] address_counter;
reg [7:0] register [0:31];

always @(posedge clk) begin
    if (rst) begin
        address_counter <= 0;
    end
    else begin
        if (ready) begin
            if (address_counter < 32) begin
                register[address_counter] <= data;
                address_counter <= address_counter + 1;
                test <= data;
            end
            else address_counter <= address_counter + 1;
        end
    end
end
endmodule
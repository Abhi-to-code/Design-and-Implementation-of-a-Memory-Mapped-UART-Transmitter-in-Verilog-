`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/06/2025 09:48:03 PM
// Design Name: 
// Module Name: channel
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


module channel #(
    parameter threshold_error = 3
)
(
    input clk,
    input in,
    input enable_error,
    output reg out
);
    
reg [7:0] lfsr = 8'h10; //linear feedback shift register - used to create the random numbers

always @(posedge clk) begin
    lfsr <= {lfsr[6:0], lfsr[7]^lfsr[5]};

    if (enable_error && (lfsr[5:0] < threshold_error)) begin
        out <= ~in;
    end
    else out <= in;
end


endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/07/2025 12:41:48 AM
// Design Name: 
// Module Name: hamming_encoder
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

module hamming_encoder (
    input [7:0] data,
    output reg [12:0] encoded_message // 8+4 = 12 plus one overall parity bit = 13
);

// we are creating the hamming(13, 8) encoder;

reg [11:0] temp;
reg p1, p2, p3, p4, op;
wire [12:0] out;





//even_parity_bit_generator #(12) overall_parity(temp, out);

always @(*) begin
    temp[2]  = data[0]; // D1 -> position 3
    temp[4]  = data[1]; // D2 -> position 5
    temp[5]  = data[2]; // D3 -> position 6
    temp[6]  = data[3]; // D4 -> position 7
    temp[8]  = data[4]; // D5 -> position 9
    temp[9]  = data[5]; // D6 -> position 10
    temp[10] = data[6]; // D7 -> position 11
    temp[11] = data[7]; // D8 -> position 12

    p1 = temp[2] ^ temp[4] ^ temp[6] ^ temp[8] ^ temp[10];             //  3,5,7,9,11
    p2 = temp[2] ^ temp[5] ^ temp[6] ^ temp[9] ^ temp[10];             //  3,6,7,10,11
    p3 = temp[4] ^ temp[5] ^ temp[6] ^ temp[11];                       //  5,6,7,12
    p4 = temp[8] ^ temp[9] ^ temp[10] ^ temp[11];

    temp[0] = p1;
    temp[1] = p2;
    temp[3] = p3;
    temp[7] = p4;   // 1,2,4,8

    op = ^temp;
    encoded_message = {temp, op};
    
end
endmodule

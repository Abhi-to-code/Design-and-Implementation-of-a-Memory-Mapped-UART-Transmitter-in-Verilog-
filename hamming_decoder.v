`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/07/2025 01:01:47 AM
// Design Name: 
// Module Name: hamming_decoder
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



module hamming_decoder (
    input [12:0] encoded_message,
    output reg [7:0] data,
    output reg error_detected,
    output reg error_corrected,
    output reg overall_parity_error
);
    

reg [3:0] syndrome;
reg [12:0] corrected_code;
reg overall_parity;
reg op_error;

//parity_checker #(13) overall_parity_check (encoded_message, op_error);

always @(*) begin
    syndrome[0] = encoded_message[1] ^ encoded_message[3] ^ encoded_message[5] ^ encoded_message[7] ^ encoded_message[9] ^ encoded_message[11];  // P1
    syndrome[1] = encoded_message[2] ^ encoded_message[3] ^ encoded_message[6] ^ encoded_message[7] ^ encoded_message[10] ^ encoded_message[11];  // P2
    syndrome[2] = encoded_message[4] ^ encoded_message[5] ^ encoded_message[6] ^ encoded_message[7] ^ encoded_message[12];              // P3
    syndrome[3] = encoded_message[8] ^ encoded_message[9] ^ encoded_message[10] ^ encoded_message[11] ^ encoded_message[12];             // P4
    

//    op_error <= ^encoded_message;
    overall_parity_error = ^encoded_message;
    corrected_code = encoded_message;
    error_detected = (syndrome != 4'b0000);
    error_corrected = 0;

    if (error_detected) begin
        if (syndrome <= 13) begin
            corrected_code[syndrome -1 ] = ~encoded_message[syndrome - 1];
            error_corrected = 1;
        end
    end

//    data[0] = corrected_code[3];   // D1
//    data[1] = corrected_code[5];   // D2
//    data[2] = corrected_code[6];   // D3
//    data[3] = corrected_code[7];   // D4
//    data[4] = corrected_code[9];   // D5
//    data[5] = corrected_code[10];   // D6
//    data[6] = corrected_code[11];  // D7
//    data[7] = corrected_code[12];  // D8

    if (!overall_parity_error && (!error_detected || error_corrected)) begin
        data[0] = corrected_code[3];   // D1
        data[1] = corrected_code[5];   // D2
        data[2] = corrected_code[6];   // D3
        data[3] = corrected_code[7];   // D4
        data[4] = corrected_code[9];   // D5
        data[5] = corrected_code[10];  // D6
        data[6] = corrected_code[11];  // D7
        data[7] = corrected_code[12];  // D8
    end else begin
        data = 8'b0; // or 8'bx if allowed in simulation
end
end
endmodule

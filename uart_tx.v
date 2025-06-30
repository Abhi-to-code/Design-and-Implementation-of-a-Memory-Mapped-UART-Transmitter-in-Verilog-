`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.06.2025 23:53:24
// Design Name: 
// Module Name: uart_tx
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

module uart_tx (
    input clk,
    input [7:0] data,
    input rst,
    output reg ready,
    output reg frame
);


reg [10:0] clk_counter;
reg [3:0] bit_counter;
reg baud_tick;
reg [1:0] state;
reg [7:0] data_register;

initial baud_tick <= 0;
initial frame <= 1;

always @(posedge clk) begin
    if (clk_counter < 4) begin
        clk_counter <= clk_counter + 1;
        baud_tick <= 0;
    end
    else begin
        baud_tick <= 1;
        clk_counter <= 0;
    end
end

always @(posedge clk) begin
    if (rst) begin
        clk_counter <= 0;
        bit_counter <= 0;
        baud_tick <= 0;
        state <= 2'b00;
        ready <= 0;
        frame <= 1;
    end

    else begin
        ready <= 0;
        if (baud_tick) begin

            case (state)
                2'b00: begin
                    // the idle state
                    data_register <= data;
                    ready <= 1;
                    state <= 2'b01;
                end
                
                2'b01: begin  
                    // starting the transmition
                    ready <= 0;
                    frame <= 0;
                    bit_counter <= 0;
                    state <= 2'b10;
                end
                
                2'b10: begin
                    frame <= data_register[bit_counter];
                    if(bit_counter < 7) begin
                        bit_counter <= bit_counter + 1;
                        state <= 2'b10;
                    end
                    else state <= 2'b11;
                end
                
                2'b11: begin
                    //stop phase
                    frame <= 1;
                    state <= 2'b00;
                end
                default: state <= 2'b00;
            endcase
            
        end
    end
end
endmodule
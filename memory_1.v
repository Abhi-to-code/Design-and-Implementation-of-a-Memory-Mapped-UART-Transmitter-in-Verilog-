module memory_1 (
    input clk,
    input ready,
    input rst,
    output reg [7:0] data
);

reg [4:0] address_counter;
reg [7:0] register [0:31];
reg prev_ready;

initial address_counter <= 0;
initial prev_ready <= 0;

initial begin
    register[0]  = 8'h12; register[1]  = 8'h34; register[2]  = 8'hC1; register[3]  = 8'h5D;
    register[4]  = 8'hA2; register[5]  = 8'h9B; register[6]  = 8'hE4; register[7]  = 8'h16;
    register[8]  = 8'h38; register[9]  = 8'h4C; register[10] = 8'hF0; register[11] = 8'h23;
    register[12] = 8'h8E; register[13] = 8'h11; register[14] = 8'hD9; register[15] = 8'h72;
    register[16] = 8'h06; register[17] = 8'hBC; register[18] = 8'hA7; register[19] = 8'h5A;
    register[20] = 8'h2F; register[21] = 8'hC6; register[22] = 8'h19; register[23] = 8'h9D;
    register[24] = 8'h0E; register[25] = 8'h67; register[26] = 8'hD4; register[27] = 8'hB3;
    register[28] = 8'h41; register[29] = 8'hFE; register[30] = 8'h8B; register[31] = 8'h30;
end

//always @(*) begin
//    if (rst) begin
//        data <= 8'b00;
//    end
//    else data <= register[address_counter];
//end


always @(posedge clk) begin
    if (rst) begin
        address_counter <= 0;
        data <= 0;
    end
    else begin
        if (ready) begin
            data <= register[address_counter];
            if (address_counter < 32) begin
                address_counter <= address_counter + 1;
            end
            else address_counter <= 0;
        end
        
        prev_ready <= ready;
        
    end
end
    
endmodule

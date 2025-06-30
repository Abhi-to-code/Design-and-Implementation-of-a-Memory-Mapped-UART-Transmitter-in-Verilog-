# Design-and-Implementation-of-a-Memory-Mapped-UART-Transmitter-in-Verilog-

## Intruction
I have made the implementation of UART protocol by using the uart transmitter and receiver.
The data from the memory goes to the uart_tx which transmits the serial data to the line. This line is sampled by uart_rx and data is restored from it.
The restored data is then saved into the new memory. Now the content of the memory_1 is shared to memory_2 succesfully by using the uart protocol.

## Diagram

     ___   _D0_  _D1_  _D2_  _D3_  _D4_  _D5_  _D6_  _D7_  _______
    |   | |    | |    | |    | |    | |    | |    | |    | |       |
Idle| S | |    | |    | |    | |    | |    | |    | |    | | STOP  | Idle
____|___|_|____|_|____|_|____|_|____|_|____|_|____|_|____|_|_______|_____
      ^   ^    ^    ^    ^    ^    ^    ^    ^    ^    ^
      |   |    |    |    |    |    |    |    |    |    |
      |   |----|----|----|----|----|----|----|----|----|---> Sample Points
      |
    Wait 1/2 bit,
    then 1 full bit
    for each sample

## Implementation

The uart_tx is implemented by FSM having 4 stages
1) IDLE stage: takes the data from the memory
2) START_BIT stage: sends the start bit to the line by making the line LOW
3) DATA stage: send the data serially to the line
4) STOP_bit stage: sends the stop bit by making the line HIGH and goes to stage 0

uart_rx works the same way but it samples the data at the middle of the bit as shown in code

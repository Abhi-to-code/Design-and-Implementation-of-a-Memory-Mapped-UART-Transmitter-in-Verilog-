# Design and Implementation of a Memory Mapped UART Transmitter in Verilog 

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
The receiver continuously monitors the i_rx_serial wire. Remember, this wire is normally HIGH (idle state). The very first thing we need to do is detect when the line goes from HIGH to LOW. This is our signal that a Start Bit has begun.
Once we detect this falling edge, we know a frame is likely starting.
New Challenge #2: The Sampling Problem
Okay, so we've detected a Start Bit. We know that 8 data bits will follow. But when exactly should we read the voltage on the wire to see if it's a '1' or a '0'?
 * If we read it right at the beginning of the bit time, a small bit of noise or a slow-changing signal might give us the wrong value.
 * If we read it at the very end, we might be too late and already be seeing the next bit.
The Solution: Sample in the Middle!
The safest place to check the value of a bit is right in its center. This gives us the best chance of reading the correct, stable value.
Here's our plan:
 * Detect the Start Bit: When the line goes from HIGH to LOW, we start a timer.
 * Wait Half a Bit: We wait for half of a bit-time. We do this to get to the middle of the Start Bit. We check the line again. Is it still LOW? If yes, great! This confirms it was a real Start Bit and not just a random glitch.
 * Wait a Full Bit: From that middle point, we now wait one full bit-time. This will land us perfectly in the middle of the first data bit (D0). We read the value and store it.
 * Repeat: We wait another full bit-time. This lands us in the middle of the next data bit (D1). We read it. We repeat this for all 8 data bits.
 * Check the Stop Bit: After reading the 8th data bit, we wait one more full bit-time. This should land us in the middle of the Stop Bit. We check to make sure the line is HIGH. If it is, we know the frame was received correctly.
 * Done! We can now present the 8 data bits we collected and signal that we are finished.

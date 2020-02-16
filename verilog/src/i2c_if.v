module i2c_if #(
  parameter CLK_FREQ = 250000,
  parameter FIFO_DEPTH = 8) 
( 
  input clkIn,
  input rstIn,
  input enIn,
  input startIn,
  input stopIn,
  input wrDataRdyIn,
  input [7:0] wrDataIn,
  output rdDataRdyOut,
  output [7:0] rdDataOut,
  output wrFifoFullOut,
  output ackErrOut,
  inout sclBi,
  inout sdaBi
);

  localparam CLK_DIV_NUM = 100000000/25;
  localparam IDLE = 2'b00;
  localparam WRITE_ADDR = 2'b01;
  localparam WRITE = 2'b10;
  localparam READ = 2'b11;

  // 1 start bit + 1 stop bit + 8 bits of data
  localparam FIFO_WIDTH = 10;

  integer wrIdx;

  reg [1:0] i2cFSMR;
  reg rdEnR;
  reg sdaR;
  reg sclR;

  wire [7:0] wrDataW;
  wire wrEnW;
  wire rdEnW;
  wire fifoEmptyW;
  wire clkW;
  wire clkNotW = ~clkW;

  clk_divider #(DIV_NUM = 400) clk250kHz (
    .clkIn(clkIn),
    .rstIn(rstIn),
    .clkOut(clkW)
  );

  // External module to write data -> Write FIFO -> I2C State Machine -> Read FIFO
  reg_fifo #(.FIFO_WIDTH(FIFO_WIDTH), .FIFO_DEPTH(FIFO_DEPTH)) wrFifo
  (
    .clkIn(clkW),
    .rstIn(rstIn),
    .wrDataIn({startIn, stopIn, wrDataIn}),
    .wrEnIn(wrDataRdyIn),
    .rdDataOut(wrDataW),
    .rdEnIn(rdEnR),        // Comes from always procedural block
    .fifoFullOut(wrFifoFullOut),
    .fifoEmptyOut(fifoEmptyW)   // Goes into always procedural block to know when to read from FIFO
  );

  // Don't need a read fifo since the external module should be waiting to receive that data.

  always @ (posedge rstIn, posedge clkW) begin
    if (rstIn == 1) begin
      i2cFSMR <= IDLE;
      rdEnR   <= 0;
      sdaR    <= 1;
      sclR    <= 1;
      wrIdx   <= 7;
    end

    else if (clkW == 1) begin
      rdEnR <= 0;
      sdaR  <= 1;
      sclR  <= 1;

      case (i2cFSMR)
        IDLE : 
          begin
            if (fifoEmptyW == 0) begin
              rdEnR   <= 1;
              i2cFSMR <= WRITE_ADDR;
              sdaR    <= 0
            end
          end

        WRITE_ADDR : 
          begin
            sclR  <= clkNotW;
            sdaR  <= wrDataW[wrIdx];

            if (wrIdx == 0) begin
              wrIdx   <= 7;

              if (wrDataW[0] == 0) begin
                i2cFSMR <= WRITE;
                rdEnR   <= 1;
              end

              else begin
                i2cFSMR <= READ;
                rdEnR   <= 1;
              end
            end

            else begin
              wrIdx <= wrIdx - 1;
            end
          end

        WRITE :
          begin


      endcase
      

    end
  end

endmodule

/*
Design Notes

Start condition: Pull SDA low first, then SCL low
Stop condition: Pull SCL high first, then SDA high

Process:
Send start condition
Send slave device 7-bit/10-bit address (MSB first)
Tack on a 1 at the end of address for reads and 0 for writes
Wait for acknowledge bit
Receive or send data
Loop back to send start condition or send stop condition

Ports:
SCL
SDA
enIn (controls for continuous start)
wrDataIn [7:0]
wrDataRdyIn
rdDataOut [7:0]
rdDataRdyOut

State Machine States: IDLE, WRITE_ADDR, READ, WRITE

IDLE -> WRITE_ADDR

if enIn == 1
  WRITE_ADDR -> READ/WRITE
  READ -> READ
  WRITE -> WRITE

else
  IDLE -> IDLE
  READ -> IDLE
  WRITE -> IDLE

IDLE:
  Upon the rising edge of enIn, capture wrDataIn into either a shift register or fifo.
  Move to WRITE_ADDR state

WRITE_ADDR:
  Move the slave address bits through the data line as well the R/W bit.
  Depending on the last bit, move to WRITE or READ after slave acknowledges.

WRITE:
  As long as enIn is a 1, the module will keep waiting on data to write to the slave.
  It will once again capture the data into either a shift register or fifo.
  Then, moves it through the data line and wait for acknowledge.
  Check acknowledge, if 1, proceed. If not, error out and move back to IDLE.
  If enIn goes low, send stop condition.
  If enIn remains high, wait for wrDataRdyIn to pulse high again and repeat WRITE steps.

READ:
  As long as enIn is a 1, the module will keep waiting on data to read from the slave.
  It capture the data into the output port reg rdDataOut.
  Once it has captured all of it, send back an acknowledge to slave.
  Maybe if it takes too long to receive data, send a nack.
  Pulse rdDataRdyOut high afterwards
  If enIn goes low, send stop condition.
  If enIn remains high, wait for next set of data and repeat READ steps.

  
As long as you pulse the clock, data transfers will occur after the initial specification of a read or write.

To not fake a stop condition, SDA must not change
when SCL is high. This means that I have to run the 
system at the system clock speed (100 MHz), fill
up a fifo with the appropriate data. Then, at the slower
clock rate, send the data over. This might not be
necessary if both of them going high at the same time
don't count. So, I'll try the easier way first.

Challenge requirements:
Test Done
Submit to GitHub and let other person load onto their device to verify
Read and display ID on seven segment display when center button is pressed
Write
Read

Bonus challenge requirements:
Display both fahrenheit and celsius at the same time on sseg display.
RTOI

The I2C interface shall operate at a baud rate of 250kHz.
The SCL shall operate with a duty cycle of 50%.
The ADC shall have a resolution of 13-bits.
The high setpoint shall be set to a temperature of 90F degrees.
The low setpoint shall be set to a temperature of 70F degrees.
The critical setpoint shall be set to a temperature of 100F degrees.
The CT pin shall be reconfigured to active high.
The INT pin shall be reconfigured to active high.
The sensor shall be configured to interrupt mode.
The sensor shall be configured to continuous mode.
The temperature data shall be read at a frequency of 1Hz.
The fault queue shall be set to 1 fault.
The RGB LED shall light blue when less than or equal to low setpoint.
The RGB LED shall light red when greater than or equal to high setpoint.
The RGB LED shall light green when between low and high setpoints.
The I2C SCL and SDA signals shall be forked and outputted to one of the pmods. 


*/
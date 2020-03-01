/* Module Name: xadc_if.v
   Author:      Jak Huyen
   Description: XADC Interface Wrapper for Nexys 4 DDR
   Notes:       A hard-coded wrapper for the XADC Xilinx IP. Plan to make it more configurable
                and operate without Xilinx IP, instead using JTAG communication.
*/
module xadc_if (
  input clkIn,
  input rstIn,
  input xadcN0In,
  input xadcP0In,
  input vp_in,
  input vn_in,
  output [11:0] adcDataOut
);

  wire [15:0] adcDataW;
  wire enW;

  assign adcDataOut = adcDataW[15:4];

  xadc_wiz_0 adc (
    .daddr_in(8'h12),
    .dclk_in(clkIn),
    .den_in(enW),
    .di_in(0),
    .dwe_in(0),
    .reset_in(rstIn),
    .vauxp2(xadcP0In),
    .vauxn2(xadcN0In),
    .busy_out(),            // Don't need since using continous conversion
    .channel_out(),         // Don't need cause single channel
    .do_out(adcDataW),
    .drdy_out(),            // Don't need since the segment display will always be on
    .eoc_out(enW),
    .eos_out(),             // Not using the sequencer configuration
    .ot_out(),              // Could record overtemperature later
    .user_temp_alarm_out(), // Could record user temp alarm later
    .alarm_out(),           // Could record all alarms later
    .vp_in(vp_in),          // Must always connect, don't know where this is located on board
    .vn_in(vn_in)           // Must always connect, don't know where this is located on board
  );

endmodule
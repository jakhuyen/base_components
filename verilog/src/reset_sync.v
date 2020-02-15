/* Module Name: reset_sync.v
   Author:      Jak Huyen
   Description: Reset Synchronizer
   Notes:       A reset synchronizer that creates an asynchronous assert, synchronous deassert reset output.
                Made to combat the disadvantages of solely asynchronous or soley synchronous reset.
*/

module reset_sync #(parameter RST_IN_POLARITY = 1'b0, parameter RST_OUT_POLARITY = 1'b1) (
  input clkIn,
  input rstIn,
  output rstOut
);

  wire ff1OutR;

  FF #(.RST_POLARITY(RST_IN_POLARITY)) syncFF1 (.clkIn(clkIn), .rstIn(rstIn), .enIn(1), .dIn(1), .qOut(ff1OutR));

  if (RST_OUT_POLARITY == 1) begin
    FF #(.RST_POLARITY(RST_IN_POLARITY)) syncFF1 (.clkIn(clkIn), .rstIn(rstIn), .enIn(1), .dIn(ff1OutR), .qNotOut(rstOut));
  end

  else if (RST_OUT_POLARITY == 0) begin
    FF #(.RST_POLARITY(RST_IN_POLARITY)) syncFF1 (.clkIn(clkIn), .rstIn(rstIn), .enIn(1), .dIn(ff1OutR), .qOut(rstOut));
  end

endmodule
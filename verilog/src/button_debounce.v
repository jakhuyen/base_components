// This module is a button debounce module made of 3 flip-flops and 1 counter.
module button_debounce #(parameter DEBOUNCE_CNT = 0) (
  input clkIn,
  input rstIn,
  input buttonIn,
  output buttonOut
);

  wire ff1ToFf2W;
  wire ff2ToCntrW;
  wire ffEnOutW;
  wire debounceRstW = (ff1ToFf2W ^ ff2ToCntrW) | rstIn;

  // Input button press is passed through consecutive flip-flops (ff1, ff2, and ff_out).
  // ff_out will be enabled when the counter below finishes counting and will pass through the state of the button at that time.
  DFF ff1    (.clkIn(clkIn), .rstIn(rstIn), .enIn(1),        .dIn(buttonIn),   .qOut(ff1ToFf2W),  .qNotOut());
  DFF ff2    (.clkIn(clkIn), .rstIn(rstIn), .enIn(1),        .dIn(ff1ToFf2W),  .qOut(ff2ToCntrW), .qNotOut());
  DFF ff_out (.clkIn(clkIn), .rstIn(rstIn), .enIn(ffEnOutW), .dIn(ff2ToCntrW), .qOut(buttonOut),  .qNotOut());
  
  // The counter will not loop.
  // Once the counter finishes counting, ffEnOutW will be a 1 and passed to the enable of ff_out.
  counter #(.MAX_CNT(DEBOUNCE_CNT), .LOOP(0)) debounce
  (
    .clkIn(clkIn),
    .rstIn(debounceRstW),
    .enIn(1'b1),
    .cntDoneOut(ffEnOutW),
    .cntValOut()
  );

endmodule
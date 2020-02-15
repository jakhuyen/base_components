// Module for a D Flip-FLop with an enable control pin
module DFF #(parameter RST_POLARITY = 1'b1) (
  input clkIn,
  input rstIn,
  input enIn,
  input dIn,
  output reg qOut,
  output reg qNotOut
);

  always @(posedge rstIn, posedge clkIn) begin
    if (rstIn == IS_RST_LOW) begin
      qOut    <= 0;
      qNotOut <= 1;
    end

    else if (clkIn == 1) begin
      // If enable is asserted, both q and q_not will be assigned the appropriate input value.
      // If enable is de-asserted, q and q_not will stay the same as before.
      if (enIn == 1) begin
        qOut    <= dIn;
        qNotOut <= ~dIn;
      end
    end
  end
endmodule
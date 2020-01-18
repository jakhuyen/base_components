module pulse (
  input clkIn,
  input rstIn,
  input sigIn,
  output pulseOut
);

  reg pulseR;

  assign pulseOut = pulseR;

  always @ (posedge rstIn, posedge clkIn) begin
    if (rstIn == 1) begin
      pulseR <= 0;
    end

    else if (clkIn == 1) begin
      pulseR <= 0;

      @ (posedge sigIn) begin
        pulseR <= 1;
      end
    end
  end
endmodule
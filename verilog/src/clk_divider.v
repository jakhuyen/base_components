module clk_divider #(parameter DIV_NUM = 4) (
  input clkIn,
  input rstIn,
  output clkOut
);

  reg clkR;

  wire cntDoneW;

  assign clkOut = clkR;

  counter #(.MAX_CNT(DIV_NUM), .LOOP(1)) cnt_div
  (
    .clkIn(clkIn),
    .rstIn(rstIn),
    .doneCntOut(cntDoneW),
    .cntValOut()
  );

  always @ (posedge rstIn, posedge clkIn) begin
    if (rstIn == 1) begin
      clkR      <= 0;
    end

    else if (clkIn == 1) begin
      if (cntDoneW == 1) begin
        clkR <= ~clkR;
      end
    end
  end
endmodule
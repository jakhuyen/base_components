module counter #(
  parameter integer MAX_CNT = 2, 
  parameter LOOP = 1'b1,
  parameter IS_CNT_DOWN = 1'b0,
  localparam integer CNT_ARR_SIZE = IS_CNT_DOWN?$rtoi($floor($log10(MAX_CNT)/$log10(2)+1)):$rtoi($floor($log10(MAX_CNT)/$log10(2)))
)
(
  input clkIn,
  input rstIn,
  input enIn,
  output cntDoneOut,
  output [CNT_ARR_SIZE:0] cntValOut
);

  // When a parameter is dependent on another parameter, it seems like it will be evaluated last.
  reg [CNT_ARR_SIZE:0] cntValR = 0;
  reg cntDoneR;
  reg enR;

  assign cntDoneOut = cntDoneR;
  assign cntValOut  = cntValR;

  always @ (posedge rstIn, posedge clkIn) begin
    if (rstIn == 1) begin
      cntValR  <= 0;
      cntDoneR <= 0;
      enR       <= 0;
    end

    else if (clkIn == 1) begin
      if (enIn == 1) begin
        cntDoneR <= 0;

        if (IS_CNT_DOWN == 0) begin
          cntValR <= cntValR + 1;

          if (cntValR == MAX_CNT) begin
            cntDoneR <= 1;
            cntValR  <= 0;
          end
        end

        else begin
          cntValR <= cntValR - 1;

          if (cntValR[CNT_ARR_SIZE] == 1) begin
            cntDoneR <= 1;
            cntValR  <= MAX_CNT;
          end
        end
      end
    end
  end
endmodule
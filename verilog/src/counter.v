module counter #(
  parameter MAX_CNT = 2, 
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
      cntValR  <= IS_CNT_DOWN?0:MAX_CNT-1;
      cntDoneR <= 0;
      enR      <= 0;
    end

    else if (clkIn == 1) begin
      if (enIn == 1) begin
        cntDoneR <= 0;

        if (IS_CNT_DOWN == 0) begin
          if (cntValR == MAX_CNT) begin
            cntDoneR <= 1;

            if (LOOP == 1) begin
              cntValR  <= 1;
            end
          end

          else begin
            cntValR <= cntValR + 1;
          end
        end

        else begin
          if (cntValR[CNT_ARR_SIZE] == 1) begin
            cntDoneR <= 1;

            if (LOOP == 1) begin
              cntValR  <= MAX_CNT-2;
            end
          end

          else begin
            cntValR <= cntValR - 1;
          end
        end
      end
    end
  end
endmodule
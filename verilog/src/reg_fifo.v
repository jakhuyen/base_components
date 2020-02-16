module reg_fifo #(parameter FIFO_WIDTH = 1, parameter FIFO_DEPTH = 8) (
  input clkIn,
  input rstIn,
  input [FIFO_WIDTH-1:0] wrDataIn,
  input wrEnIn,
  output reg [FIFO_WIDTH-1:0] rdDataOut,
  output rdEnIn,
  output reg fifoFullOut,
  output reg fifoEmptyOut
);

  localparam CNT_SIZE = $rtoi($floor($log10(FIFO_DEPTH-1)/$log10(2)));

  integer i;

  reg [FIFO_WIDTH-1:0] fifoR [FIFO_DEPTH-1:0];
  reg [CNT_SIZE:0] fifoCntR;
  reg [CNT_SIZE:0] wrPtrR;
  reg [CNT_SIZE:0] rdPtrR;

  always @ (posedge rstIn, posedge clkIn) begin
    if (rstIn == 1) begin
      for (i = 0; i < FIFO_DEPTH - 1; i = i + 1) begin
        fifoR[i] <= 0;
      end

      wrPtrR       <= 0;
      rdPtrR       <= 0;
      fifoCntR     <= 0;
      fifoFullOut  <= 0;
      fifoEmptyOut <= 1;
    end

    else if (clkIn == 1) begin
      fifoFullOut  <= 0;
      fifoEmptyOut <= 0;

      if (wrEnIn == 1 && fifoCntR < FIFO_DEPTH) begin
        fifoCntR      <= fifoCntR + 1;
        fifoR[wrPtrR] <= wrDataIn;

        if (wrPtrR == FIFO_DEPTH) begin
          wrPtrR <= 0;
        end

        else begin
          wrPtrR <= wrPtrR + 1;
        end
      end

      if (rdEnIn == 1 && fifoCntR > 0) begin
        fifoCntR  <= fifoCntR - 1;
        rdDataOut <= fifoR[rdPtrR];

        if (rdPtrR == FIFO_DEPTH) begin
          rdPtrR <= 0;
        end

        else begin
          rdPtrR <= rdPtrR + 1;
        end
      end

      if (fifoCntR == FIFO_DEPTH) begin
        fifoFullOut <= 1;
      end

      else if (fifoCntR == 0) begin
        fifoEmptyOut <= 1;
      end

    end
  end

endmodule
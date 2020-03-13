module spi_flash_single #(
  parameter DATA_WIDTH = 8,
  parameter CPOL = 0,
  parameter CPHA = 0,
  parameter NUM_SS = 1,
  parameter SCLK_FREQ = 50000)
(
  input clkIn,
  input rstIn,
  input enIn,
  input misoIn,
  input rdEnIn,
  input [31:0] csIn,
  input [DATA_WIDTH-1:0] txDataIn,
  output [DATA_WIDTH-1:0] rxDataOut,
  output rxRdyOut,
  output mosiOut,
  output [NUM_SS-1:0] csLowOut,
  output sclkOut
);

  localparam DIV_NUM = 100000000/SCLK_FREQ;

  integer txBitCntR, rxBitCntR;

  reg prevClkStateR;
  reg idleR;
  reg [NUM_SS-1:0] csLowR;
  reg getTxDataR;
  reg pushRxDataR;
  reg [DATA_WIDTH-1:0] rxDataR;
  reg rxDoneR, txDoneR;

  wire txDataW, txFifoFullW, txFifoEmptyW;
  wire sclkW;
  wire sclkMainW  = (CPOL == 0)?sclkW:~sclkW;
  assign sclkOut  = sclkMainW;
  assign csLowOut = csLowR;

  clk_divider #(.DIV_NUM(DIV_NUM)) sclk_inst
  (
    .clkIn(clkIn),
    .rstIn(rstIn & idleR),
    .enIn(1'b1)
    .clkOut(sclkR)
  );

  reg_fifo #(.FIFO_WIDTH(DATA_WIDTH), .FIFO_DEPTH(8)) tx_fifo
  (
    .clkIn(clkIn),
    .rstIn(rstIn),
    .wrDataIn(txDataIn),
    .wrEnIn(enIn),
    .rdDataOut(txDataW),
    .rdEnIn(getTxDataR),
    .fifoFullOut(txFifoFullW),
    .fifoEmptyOut(txFifoEmptyW)
  );

  reg_fifo #(.FIFO_WIDTH(DATA_WIDTH), .FIFO_DEPTH(8)) rx_fifo
  (
    .clkIn(clkIn),
    .rstIn(rstIn),
    .wrDataIn(rxDataR),
    .wrEnIn(pushRxDataR),
    .rdDataOut(rxDataOut),
    .rdEnIn(rdEnIn),
    .fifoFullOut(),
    .fifoEmptyOut(rxFifoEmptyW)
  );

  always @ (posedge rstIn, posedge clkIn) begin
    if (rstIn == 1) begin
      prevClkStateR <= CPOL;
      idleR         <= 1;
      csLowR        <= NUM_SS{1'b1};
      getTxDataR    <= 0;
      pushRxDataR   <= 0;
      txBitCntR     <= 0;
      rxBitCntR     <= 0;
      rxDoneR       <= 0;
      txDoneR       <= 0;
    end

    else if (clkIn == 1) begin
      prevClkStateR <= sclkMainW;
      idleR         <= 0;
      getTxDataR    <= 0;
      pushRxDataR   <= 0;

      case (spiFSMR)
        IDLE:
          begin
            txBitCntR <= 0;
            rxBitCntR <= 0;
            txDoneR   <= 0;
            rxDoneR   <= 0;
            csLowR    <= NUM_SS{1'b1};

            if (enIn == 1) begin
              csLowR[csIn]  <= 1'b0;
              spiFSMR <= GET_DATA;
            end

        GET_DATA:
          begin
            if (txFifoEmptyW == 0) begin
              getTxDataR <= 1;
              spiFSMR    <= TR;
            end

            // False start
            else begin
              spiFSMR <= IDLE;
            end

        TR:
          begin
            // Detect rising edge
            if (prevClkStateR == 0 && sclkMainW == 1) begin
              // CPOL = 0, CPHA = 0 (Sample Data)
              // CPOL = 0, CPHA = 1 (Change Data)
              // CPOL = 1, CPHA = 0 (Change Data)
              // CPOL = 1, CPHA = 1 (Sample Data)
              // Mode 0
              if ((CPOL = 0 && CPHA == 0) || (CPOL = 1 && CPHA == 1)) begin
                if (rxBitCntR != DATA_WIDTH) begin
                  rxBitCntR <= rxBitCntR + 1;
                  rxDataR   <= {rxDataR[DATA_WIDTH-1:1], misoIn};
                end

                else if (rxBitCntR == DATA_WIDTH) begin
                  if (misoIn == 1'bZ) begin
                    rxDoneR <= 1;
                  end

                  else begin
                    rxBitCntR   <= 1;
                    rxDataR     <= misoIn;
                  end
              end

              // If data changes on trailing edge
              else if (CPHA == 1) begin
                if 
                end
              end
            end


            // Detect falling edge
            else if (prevClkStateR == 1 && sclkMainW == 0)
              // CPOL = 0, CPHA = 0 (Change Data)
              // CPOL = 0, CPHA = 1 (Sample Data)
              // CPOL = 1, CPHA = 0 (Sample Data)
              // CPOL = 1, CPHA = 1 (Change Data)
              // If sampling data on falling edge
              if (CPHA == 1 && misoIn != 1'bZ) begin

              end

              // If shifting data on falling edge
              if (CPHA == 0) begin

              end
            end

            // If data is finished transmitting and there is more data
            if (txBitCntR == DATA_WIDTH && txFifoEmptyW == 0) begin
              getTxDataR <= 1;
            end
          end



      prevClkStateR <= (CPHA == 0)?

      // 

endmodule

// Whenever enIn is asserted, txDataIn will be captured in a FIFO.

// Whenever rxRdyOut is asserted, data can be pulled out of rxDataOut

// CPOL = 0 (Clock Idle State is low)
// CPOL = 1 (Clock Idle State is high)
// CPHA = 0 (Data sampled on leading edge, data changes on the trailing edge)
// CPHA = 1 (Data changes on the leading edge, data sampled on trailing edge)

// CPHA = 0, MOSI data must be available before first clock edge
// CPHA = 1, MISO data must be held valid until CS is deasserted. I don't have to do anything since the slave takes care of this.
// For CPOL = 0 and CPHA = 0
// MOSI shifts out on falling edge
// MISO samples on rising edge
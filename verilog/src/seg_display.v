module seg_display (
    input clkIn,
    input rstIn,
    input [4:0] digitIn,
    output reg [6:0] segOut,
    output reg decimalOut
);

  // A is the LSB and G is the MSB
  // 1's turn off the segment.
  // ----A----
  // |       |
  // F       B
  // |       |
  // |---G---|
  // |       |
  // E       C
  // |       |
  // ----D----
  
  reg [6:0] segR   = {7{1'b1}};
  reg [4:0] digitR = {4{1'b1}};

  always @ (posedge rstIn, posedge clkIn) begin
    if (rstIn == 1) begin
      segR <= 7'hFF;
    end

    else if (clkIn == 1) begin
      case (digitIn)
        1 : segR <= 7'h79;
        2 : segR <= 7'h24;
        3 : segR <= 7'h30;
        4 : segR <= 7'h19;
        5 : segR <= 7'h12;
        6 : segR <= 7'h02;
        7 : segR <= 7'h78;
        8 : segR <= 7'h00;
        9 : segR <= 7'h10;
        default : segR <= 7'hFF;
      endcase

      segOut     <= r_seg;
      decimalOut <= 1'b1;
    end
  end  
endmodule
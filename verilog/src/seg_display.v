module seg_display (
    input clkIn,
    input rstIn,
    input [3:0] digitIn,
    output [6:0] segOut
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

  assign segOut     = segR;

  always @ (posedge rstIn, posedge clkIn) begin
    if (rstIn == 1) begin
      segR <= 7'hFF;
    end

    else if (clkIn == 1) begin
      case (digitIn)
        4'h0 : segR <= 7'h40;
        4'h1 : segR <= 7'h79;
        4'h2 : segR <= 7'h24;
        4'h3 : segR <= 7'h30;
        4'h4 : segR <= 7'h19;
        4'h5 : segR <= 7'h12;
        4'h6 : segR <= 7'h02;
        4'h7 : segR <= 7'h78;
        4'h8 : segR <= 7'h00;
        4'h9 : segR <= 7'h10;
        4'hA : segR <= 7'h08;
        4'hB : segR <= 7'h03;
        4'hC : segR <= 7'h46;
        4'hD : segR <= 7'h21;
        4'hE : segR <= 7'h06;
        4'hF : segR <= 7'h0E;

        default : segR <= 7'hBF;
      endcase
    end
  end  
endmodule
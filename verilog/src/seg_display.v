module seg_display (
    input i_clk,
    input i_rst,
    input [4:0] i_digit,
    output reg [6:0] o_seg,
    output reg o_decimal
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
  
  reg [6:0] r_seg   = {7{1'b1}};
  reg [4:0] r_digit = {4{1'b1}};

  always @ (posedge i_rst, posedge i_clk) begin
    if (i_rst == 1) begin
      r_seg <= 7'hFF;
    end

    else if (i_clk == 1) begin
      case (i_digit)
        1 : r_seg <= 7'h79;
        2 : r_seg <= 7'h24;
        3 : r_seg <= 7'h30;
        4 : r_seg <= 7'h19;
        5 : r_seg <= 7'h12;
        6 : r_seg <= 7'h02;
        7 : r_seg <= 7'h78;
        8 : r_seg <= 7'h00;
        9 : r_seg <= 7'h10;
        default : r_seg <= 7'hFF;
      endcase

      o_seg <= r_seg;
      o_decimal <= 1'b1;
    end
  end  
endmodule
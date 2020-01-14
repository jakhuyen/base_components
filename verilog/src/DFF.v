// Module for a D Flip-FLop with an enable control pin
module DFF (
  input i_clk,
  input i_rst,
  input i_en,
  input i_d,
  output reg o_q,
  output reg o_q_not
);

  always @(posedge i_rst, posedge i_clk) begin
    if (i_rst == 1) begin
      o_q     <= 0;
      o_q_not <= 1;
    end

    else if (i_clk == 1) begin
      // If enable is asserted, both q and q_not will be assigned the appropriate input value.
      // If enable is de-asserted, q and q_not will stay the same as before.
      if (i_en == 1) begin
        o_q     <= i_d;
        o_q_not <= ~i_d;
      end
  end
endmodule
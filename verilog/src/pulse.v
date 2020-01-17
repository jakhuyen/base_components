module pulse (
  input i_clk,
  input i_rst,
  input i_sig,
  output o_pulse
);

  reg r_pulse;

  assign o_pulse = r_pulse;

  always @ (posedge i_rst, posedge i_clk) begin
    if (i_rst == 1) begin
      r_pulse <= 0;
    end

    else if (i_clk == 1) begin
      r_pulse <= 0;

      @ (posedge i_sig) begin
        r_pulse <= 1;
      end
    end
  end
endmodule
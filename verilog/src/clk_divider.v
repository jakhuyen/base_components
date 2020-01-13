module clk_divider #(parameter DIV_NUM = 4) (
  input i_clk,
  input i_rst,
  output o_clk
);

  reg r_clk;

  wire w_cnt_done;

  assign o_clk = r_clk;

  counter #(.MAX_CNT(DIV_NUM), .LOOP(1)) cnt_div
  (
    .i_clk(i_clk),
    .i_rst(i_rst),
    .o_cnt_done(w_cnt_done),
    .o_cnt_val()
  );

  always @ (posedge i_rst, posedge i_clk) begin
    if (i_rst == 1) begin
      r_clk      <= 0;
    end

    else if (i_clk == 1) begin
      if (w_cnt_done == 1) begin
        r_clk <= ~r_clk;
      end
    end
  end
endmodule
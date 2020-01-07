module clk_divider #(parameter DIV_NUM = 3) (
    input i_clk,
    input i_rst,
    output o_clk
);

    counter #(.MAX_CNT(DIV_NUM), .LOOP(1)) cnt_div
    (
        .i_clk(i_clk),
        .i_rst(i_rst),
        .o_cnt_done(r_cnt_done),
        .o_cnt_val(r_cnt_out)
    );

    always @ (posedge i_rst, posedge i_clk) begin
        if (i_rst == 1) begin
            

endmodule
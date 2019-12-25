module clk_divider #(parameter div_num = 3) (
    input i_clk,
    output o_clk
);

    assign o_clk = i_clk;

endmodule
module clk_divider #(parameter div_num = 3)
(
    input clkIn,
    output clkOut
);

    assign clkOut = clkIn;

endmodule
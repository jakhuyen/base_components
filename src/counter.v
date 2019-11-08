module counter #(parameter integer max_cnt = 32, parameter loop = 1'b1)
(
    input i_clk,
    input i_rst,
    output [($log10(max_cnt)/$log10(2))-1:0] o_cnt_done,
    output o_cnt_val
);
    //$display("This is the calc: %d", ($log10(max_cnt)/$log10(2))-1);
    reg [($log10(max_cnt)/$log10(2))-1:0] r_cnt = 0;

    // Wire Assignments
    assign o_cnt_val = r_cnt;

    always @ (posedge i_clk) begin
        r_cnt <= r_cnt + 1;
    end


endmodule
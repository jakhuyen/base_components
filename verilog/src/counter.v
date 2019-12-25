module counter #(
    parameter integer MAX_CNT, 
    parameter LOOP = 1'b1,
    localparam integer C_CNT_ARR_SIZE = ($log10(MAX_CNT)/$log10(2))
)
(
    input i_clk,
    input i_rst,
    output o_cnt_done,
    output [($log10(MAX_CNT)/$log10(2)):0] o_cnt_val
);

    reg [($log10(MAX_CNT)/$log10(2)):0] r_cnt_val = 0;
    reg r_cnt_done = 0;

    // Wire Assignments
    assign o_cnt_val  = r_cnt_val;
    assign o_cnt_done = r_cnt_done;

    always @ (posedge i_rst, posedge i_clk) begin
        if (i_rst == 1) begin
            r_cnt_val <= 0;
        end

        else if (i_clk == 1) begin
            r_cnt_done <= 0;
            r_cnt_val  <= r_cnt_val + 1;

            if (r_cnt_val == MAX_CNT) begin
                r_cnt_done <= 1;
            end
        end
    end


endmodule
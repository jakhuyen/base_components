module counter #(
    parameter integer MAX_CNT = 2, 
    parameter LOOP = 1'b1,
    parameter IS_CNT_DOWN = 1'b0,
    localparam integer C_CNT_ARR_SIZE = IS_CNT_DOWN?($floor($log10(MAX_CNT)/$log10(2)+1)):$floor($log10(MAX_CNT)/$log10(2))
)
(
    input i_clk,
    input i_rst,
    input i_ctrl,
    output o_cnt_done,
    output [C_CNT_ARR_SIZE:0] o_cnt_val
);

    // When a parameter is dependent on another parameter, it seems like it will be evaluated last.
    reg [C_CNT_ARR_SIZE:0] r_cnt_val = 0;
    reg r_cnt_done;
    reg r_ctrl;

    assign o_cnt_done = r_cnt_done;
    assign o_cnt_val  = r_cnt_val;

    always @ (posedge i_rst, posedge i_clk) begin
        if (i_rst == 1) begin
            r_cnt_val  <= 0;
            r_cnt_done <= 0;
            r_ctrl     <= 0;
        end

        else if (i_clk == 1) begin
            r_cnt_done <= 0;

            if (r_ctrl == 0 && i_ctrl == 1) begin
                r_ctrl <= 1;
            end

            else if (r_ctrl == 1 && i_ctrl == 1) begin
                r_ctrl <= 0;
            end

            if (IS_CNT_DOWN == 0) begin
                r_cnt_val <= r_cnt_val + 1;

                if (r_cnt_val == MAX_CNT) begin
                    r_cnt_done <= 1;
                    r_cnt_val  <= 0;
                end
            end

            else begin
                r_cnt_val <= r_cnt_val - 1;

                //if (r_cnt_val[] == )
            end
        end
    end


endmodule
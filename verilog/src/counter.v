module counter #(
    parameter integer MAX_CNT = 2, 
    parameter LOOP = 1'b1,
    parameter IS_CNT_DOWN = 1'b0,
    localparam integer C_CNT_ARR_SIZE = IS_CNT_DOWN?$rtoi($floor($log10(MAX_CNT)/$log10(2)+1)):$rtoi($floor($log10(MAX_CNT)/$log10(2)))
)
(
    input i_clk,
    input i_rst,
    input i_en,
    output o_cnt_done,
    output [C_CNT_ARR_SIZE:0] o_cnt_val
);

    // When a parameter is dependent on another parameter, it seems like it will be evaluated last.
    reg [C_CNT_ARR_SIZE:0] r_cnt_val = 0;
    reg r_cnt_done;
    reg r_en;

    assign o_cnt_done = r_cnt_done;
    assign o_cnt_val  = r_cnt_val;

    always @ (posedge i_rst, posedge i_clk) begin
        if (i_rst == 1) begin
            r_cnt_val  <= 0;
            r_cnt_done <= 0;
            r_en       <= 0;
        end

        else if (i_clk == 1) begin
            if (i_en == 1) begin
                r_cnt_done <= 0;

                if (IS_CNT_DOWN == 0) begin
                   r_cnt_val <= r_cnt_val + 1;

                    if (r_cnt_val == MAX_CNT) begin
                        r_cnt_done <= 1;
                        r_cnt_val  <= 0;
                    end
                end

                else begin
                    r_cnt_val <= r_cnt_val - 1;

                    if (r_cnt_val[C_CNT_ARR_SIZE] == 1) begin
                        r_cnt_done <= 1;
                        r_cnt_val  <= MAX_CNT;
                    end
                end
            end
        end
    end


endmodule
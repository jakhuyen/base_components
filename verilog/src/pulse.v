module pulse (
    input i_clk,
    input i_rst,
    input i_sig,
    output o_pulse);

    reg r_sig;

    always @ (posedge i_rst, posedge i_clk) begin
        if (i_rst == 1) begin
            r_sig <= 0;
        end

        else if (i_clk == 1) begin
            r_sig <= 0;

            if (posedge i_sig) begin
                r_sig <= 1;
            end
        end
    end
endmodule
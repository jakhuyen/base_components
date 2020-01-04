module pulse (
    input i_clk,
    input i_rst,
    input i_sig,
    output reg o_pulse);

    // TODO: If i_sig goes high, output a single pulse out of o_pulse.
    // However, only do that on a rising edge of i_sig.


    always @ (posedge i_rst, posedge i_clk) begin
        if (i_rst == 1) begin

        end

        else if (i_clk == 1) begin

        end
    end
endmodule
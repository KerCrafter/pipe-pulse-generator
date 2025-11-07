`default_nettype none

module pipe_pulse_generator (
    input  wire clk,
    input  wire s,          // signal d’entrée (le signal à surveiller)
    input  wire pipe_in,    // entrée du pipeline
    output wire pipe_out,   // sortie du pipeline
    input  wire reset         // reset asynchrone
);

    reg shift_reg = 1'b0;
    reg pulse = 1'b0;
    reg s_prev = 1'b0;

    wire s_rising = s & ~s_prev;
    wire trigger = s_rising | pipe_in;

    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 1'b0;
            pulse <= 1'b0;
            s_prev <= 1'b0;
        end else begin
            s_prev <= s;

            if (trigger) begin
                shift_reg <= 1'b1;
            end else begin
                shift_reg <= 1'b0;
            end

            pulse <= shift_reg;
        end
    end

    assign pipe_out = pulse;

endmodule

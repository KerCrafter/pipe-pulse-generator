module pipe_pulse_generator #(
    parameter WIDTH = 1
)(
    input  wire clk,
    input  wire s,          // signal d’entrée (le signal à surveiller)
    input  wire pipe_in,    // entrée du pipeline
    output wire pipe_out,   // sortie du pipeline
    input  wire reset         // reset asynchrone
);

    reg [WIDTH-1:0] shift_reg = {WIDTH{1'b0}};
    reg pulse = 1'b0;
    reg s_prev = 1'b0;

    wire s_rising = s & ~s_prev;
    wire trigger = s_rising | pipe_in;

    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= {WIDTH{1'b0}};
            pulse <= 1'b0;
            s_prev <= 1'b0;
        end else begin
            s_prev <= s;

            if (trigger) begin
                if (WIDTH > 1)
                    shift_reg <= {shift_reg[WIDTH-2:0], 1'b1};
                else
                    shift_reg <= 1'b1;
            end else begin
                if (WIDTH > 1)
                    shift_reg <= {shift_reg[WIDTH-2:0], 1'b0};
                else
                    shift_reg <= 1'b0;
            end

            pulse <= shift_reg[WIDTH-1];
        end
    end

    assign pipe_out = pulse;

endmodule

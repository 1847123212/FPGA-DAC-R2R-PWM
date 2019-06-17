
module pwm_sim();

localparam R2R_BITS = 2;
localparam PWM_BITS = 4;
localparam DAC_BITS = R2R_BITS + PWM_BITS;

reg clk=1'b1, rst_n=1'b0;
initial # 8 rst_n = 1'b1;
always # 2 clk = ~clk;

wire val_req;
reg  [DAC_BITS-1:0] dac_val = 0;

wire [R2R_BITS-1:0] r2r_out;
wire pwm_out;

always @ (posedge clk) begin
    if(val_req)
        dac_val = dac_val+6'b010001;
end

pwm #(
    .R2R_BITS     ( R2R_BITS   ),
    .PWM_BITS     ( PWM_BITS   )
) pwm_inst (
    .clk          ( clk        ),
    .rst_n        ( rst_n      ),
    
    .val_req      ( val_req    ),
    .dac_val      ( dac_val    ),
    
    .r2r_out      ( r2r_out    ),
    .pwm_out      ( pwm_out    )
);

endmodule


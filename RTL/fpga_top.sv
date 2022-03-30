
module fpga_top (
    input         rstn,
    input         clk,
    output [ 3:0] gpio
);


localparam R2R_BITS = 3;
localparam PWM_BITS = 11;
localparam DAC_BITS = R2R_BITS + PWM_BITS;


wire                val_req;
reg  [DAC_BITS-1:0] dac_val = '0;
reg                 dacval_incdec = 1'b0;


always @ (posedge clk)
    if(val_req) begin             // 生成锯齿波
        if(~dacval_incdec) begin  // increase
            if(dac_val >= 14'b10_0000_0000_0000)  // max
                dacval_incdec = 1'b1;
        end else begin
            if(dac_val <= 14'b01_0000_0000_0000)  // min
                dacval_incdec = 1'b0;
        end
        if(~dacval_incdec)
            dac_val <= dac_val + (DAC_BITS)'(1);
        else
            dac_val <= dac_val - (DAC_BITS)'(1);
    end


r2r_pwm #(
    .R2R_BITS     ( R2R_BITS   ),
    .PWM_BITS     ( PWM_BITS   )
) r2r_pwm_i (
    .rstn         ( rstn       ),
    .clk          ( clk        ),
    
    .val_req      ( val_req    ),
    .dac_val      ( dac_val    ),  // 可以在这里修改截断位数，来测试PWM低位的有效性，比如 {dac_val[13:2],2'h0} 就代表截断低2位
    
    .r2r_out      ( gpio[3:1]  ),
    .pwm_out      ( gpio[0]    )
);

endmodule

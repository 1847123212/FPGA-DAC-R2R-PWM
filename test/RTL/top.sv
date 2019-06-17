
module top(
    input  clk, rst_n,
    
    output [ 7:0] led,

    output [ 3:0] gpio
);

wire clkt;
reg [31:0] cnt=0;
assign clkt = cnt[1];
always @ (posedge clk)
    cnt++;

localparam R2R_BITS = 3;
localparam PWM_BITS = 11;
localparam DAC_BITS = R2R_BITS + PWM_BITS;

wire val_req;
reg  [DAC_BITS-1:0] dac_val = 0;
reg  dacval_incdec = 1'b0;

  // 生成锯齿波
/*
always @ (posedge clkt) begin
    if(val_req) begin   // 生成锯齿波
        if(~dacval_incdec) begin  // increase
            if((&dac_val)==1'b1)  // max
                dacval_incdec = 1'b1;
        end else begin
            if(dac_val==0)  // zero
                dacval_incdec = 1'b0;
        end
        if(~dacval_incdec)
            dac_val++;
        else
            dac_val--;
    end
end
*/

always @ (posedge clkt) begin
    if(val_req) begin   // 生成锯齿波
        if(~dacval_incdec) begin  // increase
            if(dac_val > 14'b000_000_0000_1110)  // max
                dacval_incdec = 1'b1;
        end else begin
            if(dac_val < 14'b000_000_0000_1010)  // min
                dacval_incdec = 1'b0;
        end
        if(~dacval_incdec)
            dac_val+=1;
        else
            dac_val-=1;
    end
end


wire [R2R_BITS-1:0] r2r_out;
wire pwm_out;

pwm #(
    .R2R_BITS     ( R2R_BITS   ),
    .PWM_BITS     ( PWM_BITS   )
) pwm_inst (
    .clk          ( clkt        ),
    .rst_n        ( rst_n      ),
    
    .val_req      ( val_req    ),
    .dac_val      ( {dac_val[13:1],1'b1}    ),
    
    .r2r_out      ( r2r_out    ),
    .pwm_out      ( pwm_out    )
);

assign gpio[0] = r2r_out[2];
assign gpio[1] = r2r_out[1];
assign gpio[2] = r2r_out[0];
assign gpio[3] = pwm_out;

assign led = {r2r_out, pwm_out, 4'h0};

endmodule


module pwm #(
    parameter  R2R_BITS = 4,
    parameter  PWM_BITS = 12 // for example, when PWM_BITS=12, pwm value=0~4095, 4095=2^12-1
)(
    input  wire  clk, rst_n,
    // user control interface
    output reg   val_req,
    input  wire  [(R2R_BITS+PWM_BITS)-1:0] dac_val,
    // connect to R2R resistor net
    output reg   [R2R_BITS-1:0] r2r_out,
    output reg   pwm_out
);

localparam N = (1<<PWM_BITS);

initial begin val_req=1'b0; pwm_out=1'b0; r2r_out=0; end

reg  [R2R_BITS-1:0] r2r_valr=0;
reg  [PWM_BITS-1:0] cnt=0, cntr=0, pwm_valr=0, idx=0;

always @ (posedge clk or negedge rst_n)
    if(~rst_n) begin
        cnt = 0;
        val_req=1'b0;
    end else begin
        cnt = cnt+1;
        val_req = (cnt==0);
    end

always @ (posedge clk or negedge rst_n)
    if(~rst_n) begin
        cntr = 0;
        {r2r_valr, pwm_valr} = 0;
    end else begin
        cntr = cnt;
        if(val_req) begin
            {r2r_valr, pwm_valr} = dac_val;
        end
    end
    
always @ (posedge clk or negedge rst_n)
    if(~rst_n) begin
        idx = 0;
        pwm_out=1'b0;
        r2r_out=0;
    end else begin
        if(cntr==0) begin
            idx = 1;
            pwm_out = (pwm_valr>0);
            r2r_out = r2r_valr;
        end else begin
            if(pwm_valr==0) begin
                pwm_out = 1'b0;
            end else if(cntr>=(idx*N/pwm_valr)) begin
                idx = idx+1;
                pwm_out = 1'b1;
            end else begin
                pwm_out = 1'b0;
            end
        end
    end

endmodule


module k2_reg(

    //update changing 32 bit input to 16 bit and output bit from 34 to 32 bit. (10/31)

    //adding new funcation for low coefficient that would repalce ki. Meaning that once ki is inputed LC would take that vaule and use it, replacing the ki (10/30).

    input logic nrst, clk, 
    input logic clear, 
    input logic ren, 
    input logic lc,
    // change to one input bus 
    // input logic [15:0] ki,
    // input logic [15:0] error,
    input logic [15:0] error_coeff,
    output logic [15:0] k2,
    output logic overflow
);

    //finshed in two cycle with additon and multiplication
    // hold the accumulated sum
    // state logic
    logic [31:0] sum_reg, n_sum_reg;

    // accommodate the new input signal "lc"
    logic [15:0] reg_lc, n_reg_lc;


    logic [31:0] intermed;


    //  Sequential: registers update on negedge (state block)
    always_ff @(posedge clk or negedge nrst) begin

        if (nrst == 1'b0) begin // negative rest will will rest everything
            sum_reg <= 'd0;
            reg_lc <= 'd0;
        end
/* moving out the clear logic to comb block

        else if (clear == 1'b1) begin //clear will rest everything
            sum_reg <= 'd0;
            reg_lc <= 'd0;
        end
*/
        else begin // otherwise the summing register will continue summing up the error and the overflow detecter will continue also.
            sum_reg <= n_sum_reg;
            reg_lc <= n_reg_lc;
        end        
    end



    // moving the clear logic to comb block
    // summing block
    always_comb begin 
        n_reg_lc = reg_lc;
        n_sum_reg = sum_reg;
        overflow = '0;
        // Clear logic (Highest Priority)
        if (clear) begin
            n_reg_lc  = '0;
            n_sum_reg = '0;
        end 
        else begin            
            // For changing lc value
            if (lc) begin
                n_reg_lc = error_coeff;
            end

            // For the summing of the error
            if (ren) begin
                n_sum_reg = sum_reg + {16'b0, error_coeff};
                overflow  = (n_sum_reg < sum_reg);

            end
        end
    end


/* 
    A dadda tree would be too hard

    //multiplication_block
    dadda d1 (
      .x(sum_reg),
      .y(reg_lc[15:0]),
      .z0(intermed0),
      .z1(intermed1)  
    );
*/


    assign intermed = sum_reg * reg_lc;
    assign k2 = intermed[27:12];

endmodule

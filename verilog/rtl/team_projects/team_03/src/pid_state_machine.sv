
`timescale 1ns / 10ps 

module pid_state_machine(
    input logic clk,
    input logic n_rst,
    input logic start,
    input logic start_coeff,
    input logic error_flag,
    output logic read_busy,
    output logic write_busy,
    output logic [3:0] load_coeff);
    
    typedef enum logic [4:0] {
        IDLE = 5'd0,
        READ_REG = 5'd1,
        CALC = 5'd2,
        WRITE = 5'd3,
        ERROR = 5'd4,

        LOAD_COEFF0 = 5'd5,
        WAIT_COEFF1 = 5'd6,
        LOAD_COEFF1 = 5'd7,
        WAIT_COEFF2 = 5'd8,
        LOAD_COEFF2 = 5'd9, //same channel two separate signals
        //one area angle, one determine overloading coefficients
        WAIT_TIMESCALING = 5'd10,
        LOAD_TIMESCALING = 5'd11
    } states_t;
    
    states_t curr_state, next_state;
    //cmd bus values:
    /*
        16'd0: CLEAR
        16'd1: START
        16'd2: LOAD_COEFF0
        16'd3: LOAD TIMESCALING
    */
    always_ff @(posedge clk or negedge n_rst) begin
        if (!n_rst) 
        curr_state <= IDLE;
    else
        curr_state <= next_state;
    end
    
    always_comb begin
        next_state = curr_state; //hold
        case (curr_state)
            IDLE: begin
                if (start_coeff)
                    next_state = LOAD_COEFF0;
                else if (start) 
                    next_state = READ_REG;
                else 
                    next_state = IDLE;
            end

            READ_REG: begin 
                next_state = CALC; //I'm guessing read completes in one cycle
            end

            CALC: begin 
                next_state = (error_flag) ? ERROR: WRITE;
            end

            WRITE: begin
                next_state = IDLE;
            end

            ERROR: begin
                /*if (!endpacket) 
                    next_state = READ_REG;
                else 
                    next_state = IDLE;*/
                next_state = IDLE;
            end

            LOAD_COEFF0: begin
                /*if (!start_coeff)
                    next_state = IDLE;
                else
                    next_state = WAIT_COEFF1;*/
                next_state = WAIT_COEFF1;
            end

            WAIT_COEFF1: begin
                /*if (!start_coeff)
                    next_state = IDLE;
                else 
                    next_state = LOAD_COEFF1;*/
                next_state = LOAD_COEFF1;
            end

            LOAD_COEFF1: begin
                /*if (!start_coeff)
                    next_state = IDLE;
                else
                    next_state = WAIT_COEFF2;*/
                next_state = WAIT_COEFF2;
            end

            WAIT_COEFF2: begin
                /*if (!start_coeff)
                    next_state = IDLE;
                else 
                    next_state = LOAD_COEFF2;*/
                next_state = LOAD_COEFF2;
            end

            LOAD_COEFF2: begin
                next_state = WAIT_TIMESCALING;
            end

            WAIT_TIMESCALING: begin
                next_state = LOAD_TIMESCALING;
            end

            LOAD_TIMESCALING: begin
                next_state = IDLE;
            end
            default: next_state = IDLE; 
        endcase
    end
    
    assign read_busy = (curr_state == READ_REG);
    assign write_busy = (curr_state == WRITE);
    assign load_coeff = {curr_state == LOAD_TIMESCALING, curr_state == LOAD_COEFF2, curr_state == LOAD_COEFF1, curr_state == LOAD_COEFF0};
endmodule

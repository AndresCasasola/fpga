
/////////////////////////////////////////////////////////////////////////////////
//
// Engineer:        Andres Casasola Dominguez
// Github:          AndresCasasola

// Create Date:     07/2021
// Module Name:     sequence_detector
// Dependencies:    None
// Description:     4-bit sequence detector.
// 
/////////////////////////////////////////////////////////////////////////////////

module sequence_detector(   input   wire        clk,
                            input   wire        rst,
                            input   wire        din,  
                            output  wire        dout);
    
    // Parameters
    parameter   IDLE    = 0,
                S1      = 1,
                S2      = 2,
                S3      = 3,
                S4      = 4;

    parameter[3:0] sequence = 4'b0101;      // Sequence to check

    // Variables
    reg[2:0] current_state, next_state;     // State variables

    // State register
    always@(posedge clk) begin
        if (rst)
            current_state <= IDLE;
        else
            current_state <= next_state;
    end

    // FSM
    always@(current_state or din) begin
        case (current_state)
            IDLE: begin
                if (din == 1)   next_state <= S1;       // Sequence fits: go to S1
                else            next_state <= IDLE;
            end
            S1: begin
                if (din == 0)   next_state <= S2;       // Sequence fits: go to S2
                else            next_state <= S1;       // Not IDLE because din is 1
            end
            S2: begin
                if (din == 1)   next_state <= S3;       // Sequence fits: go to S3
                else            next_state <= IDLE;
            end
            S3: begin
                if (din == 0)   next_state <= S4;       // Sequence fits: go to S4
                else            next_state <= IDLE;
            end
            S4: begin
                next_state <= IDLE;         // Sequence completed, go to IDLE and start again
            end
        endcase
    end

    // Output data
    assign dout = (current_state == S4) ? 1 : 0;

endmodule
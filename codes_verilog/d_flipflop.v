
/////////////////////////////////////////////////////////////////////////////////
//
// Engineer:        Andres Casasola Dominguez
// Github:          AndresCasasola

// Create Date:     07/2021
// Module Name:     d_flipflop
// Dependencies:    None
// Description:     D type Flip-Flop.
// 
/////////////////////////////////////////////////////////////////////////////////

module d_flipflop ( input   wire    d,
                    input   wire    rstn,
                    input   wire    clk,
                    output  reg     q);
    
    // Registers and wires
    reg q_reg;

    // Behavioral
    always@(posedge clk)
    begin
        if (!rstn)
            q_reg <= 0;
        else
            q_reg <= d;
    end

    assign q = q_reg;

endmodule
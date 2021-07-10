
/////////////////////////////////////////////////////////////////////////////////
//
// Engineer:        Andres Casasola Dominguez
// Github:          AndresCasasola

// Create Date:     07/2021
// Module Name:     frcounter
// Dependencies:    None
// Description:     4-bit Free Running Up Counter.
// 
/////////////////////////////////////////////////////////////////////////////////

module frcounter (  input   wire        clk_in,
                    input   wire        rst_in,
                    output  wire        tc_out,  
                    output  wire[3:0]   data_out);
    
    // Registers and wires
    reg[3:0] data_out_reg;

    // Behavioral
    always@(posedge clk_in)
    begin
        if (rst_in)
            //data_out_reg <= "0000";   // Both are ok
            data_out_reg <= 4'b0000;
        else
            begin
                if (data_out_reg == 4'b1111)
                begin
                    data_out_reg <= 4'b0000;
                end
                else
                    data_out_reg <= data_out_reg + 1;
            end
    end

    assign data_out = data_out_reg;
    assign tc_out = (data_out_reg[0] & data_out_reg[1]) & (data_out_reg[2] & data_out_reg[3]);

endmodule
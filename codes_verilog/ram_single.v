
/////////////////////////////////////////////////////////////////////////////////
//
// Engineer:        Andres Casasola Dominguez
// Github:          AndresCasasola

// Create Date:     07/2021
// Module Name:     ram_single
// Dependencies:    None
// Description:     Block RAM: 16K x 2, single port.
// 
/////////////////////////////////////////////////////////////////////////////////

module ram_single(  input wire          clka,
                    input wire          rsta,
                    input wire          wea,
                    input wire          ena,
                    input wire [1:0]    dina,
                    input wire [13:0]   addra,      // 14 bits width to cover 16k positions
                    output reg [1:0]    douta );

    // RAM parameters
    parameter DEPTH = 14;       // 16k
    parameter WIDTH = 2;        // 2-bit wide

    //Variables
    reg[WIDTH-1:0] ram[(2**DEPTH)-1:0];      // (2**DEPTH x WIDTH) RAM memory variable

    always@(posedge clka) begin
            if(ena) begin
                if(wea) begin
                    ram[addra] <= dina;             // Write
                end else begin
                    if (rsta)
                        douta <= 0;             // Reset output register
                    else
                        douta <= ram[addra];    // Read
                end
            end
    end

endmodule
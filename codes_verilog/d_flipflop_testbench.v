
/////////////////////////////////////////////////////////////////////////////////
//
// Engineer:        Andres Casasola Dominguez
// Github:          AndresCasasola

// Create Date:     07/2021
// Module Name:     d_flipflop_testbench
// Dependencies:    None
// Description:     Testbench for d_flipflop.
// 
/////////////////////////////////////////////////////////////////////////////////

module d_flipflop_tb;
    
    // Registers and wires
    reg tb_clk;
    reg tb_d;
    reg tb_rstn;
    wire tb_q;

    // Instance of design under test (DUT)
    d_flipflop d_flipflop0  (   .clk    (tb_clk),
                                .d      (tb_d),
                                .rstn   (tb_rstn),
                                .q      (tb_q)
                            );

    // Simulus generation

    // Clock
    always #10 tb_clk = ~tb_clk;

    // Variables
    integer i, delay;

    initial 
    begin
        tb_rstn     <= 1'b0;
        tb_clk      <= 1'b0;
        tb_d        <= 1'b0;
    
        #15 tb_d <= 1;
        #10 tb_rstn <= 1;

        #65 tb_d <= 0;
        
        // Randomize data input
        
        for (i = 0; i < 5; i=i+1) 
        begin
            delay = $random % 50;
            #(delay)
            tb_d <= ~tb_d;
            $display("iteration: %d, delay: %d",i, delay);
        end
        
    
    end

endmodule
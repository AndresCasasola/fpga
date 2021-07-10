
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
    integer loops = 100;
    integer iter = 0;
    reg d_last = 1'b0;
    reg fail = 0;

    initial 
    begin

        $display("Starting test...");

        // Initialization
        tb_rstn     <= 1'b0;
        tb_clk      <= 1'b0;
        tb_d        <= 1'b0;
    
        // RST signal
        #15 tb_d <= 1;
        #10 tb_rstn <= 1;
        #65 tb_d <= 0;
        
        // Wait RST to disable
        $display("Waiting RST to disable...");
        wait (tb_rstn == 1'b1);
        $display("RST disabled");

        // Randomize data input value and timing
        $display("Generating random input data:");
        for (i = 0; i < loops; i=i+1) 
        begin
            delay = $urandom_range(50, 10);
            #(delay)
            tb_d <= $urandom_range(1, 0);
            //$display("Iteration: %d, delay: %d", i, delay);
        end
    
    end

    // Automation test
    always@(posedge tb_clk)
    begin
        if (d_last != tb_q)
        begin
            $display("Iteration: %d -> Error", iter);
            fail = 1'b1;
        end
        else
        begin
            $display("Iteration: %d -> Success", iter);
        d_last <= tb_d;
        end
        iter = iter + 1;
        if (fail) 
        begin
            //$display("Stopping simulation -.- DUT operating error");
            $stop;
        end
    end

endmodule
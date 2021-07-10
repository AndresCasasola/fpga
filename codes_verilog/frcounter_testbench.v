
/////////////////////////////////////////////////////////////////////////////////
//
// Engineer:        Andres Casasola Dominguez
// Github:          AndresCasasola

// Create Date:     07/2021
// Module Name:     frcounter_testbench
// Dependencies:    None
// Description:     Testbench for frcounter.
// 
/////////////////////////////////////////////////////////////////////////////////

module frcounter_tb;
    
    // Registers and wires
    reg tb_clk_in;
    reg tb_rst_in;
    wire tb_tc_out;
    wire[3:0] tb_data_out;

    // Instance of design under test (DUT)
    frcounter frcounter0    (   .clk_in     (tb_clk_in),
                                .rst_in     (tb_rst_in),
                                .tc_out     (tb_tc_out),
                                .data_out   (tb_data_out));

    // Simulus generation

    // Clock
    always #10 tb_clk_in = ~tb_clk_in;

    // Variables
    integer counter = 0;
    reg fail = 0;

    initial 
    begin

        $display("Starting test...");

        // Initialization
        tb_clk_in       <= 1'b0;
        tb_rst_in       <= 1'b1;
    
        // RST signal
        #10 tb_rst_in <= 0;
        
        // Wait RST to disable
        $display("Waiting RST to disable...");
        wait (tb_rst_in == 1'b0);
        $display("RST disabled");
    
    end

    // Automation test
    always@(posedge tb_clk_in)
    begin
        if(tb_rst_in)
        begin
            counter = 0;
        end
        else
        begin
            if ((counter != tb_data_out) | ((counter == 15) & (tb_tc_out == 0'b0)) )
            begin
                $display("Count: %d -> Error", counter);
                fail = 1'b1;
            end
            else
            begin
                $display("Count: %d -> Success", counter);
            end
            
            if (counter == 15)
            begin
                counter = 0'b0000; 
            end
            else
            begin
                counter = counter + 1;
            end
            
            if (fail) 
            begin
                //$display("Stopping simulation -.- DUT operating error");
                $stop;
            end
        end
    end


endmodule
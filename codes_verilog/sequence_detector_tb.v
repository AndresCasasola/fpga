
/////////////////////////////////////////////////////////////////////////////////
//
// Engineer:        Andres Casasola Dominguez
// Github:          AndresCasasola

// Create Date:     07/2021
// Module Name:     sequence_detector_tb
// Dependencies:    None
// Description:     Testbench for sequence_detector.
// 
/////////////////////////////////////////////////////////////////////////////////

module sequence_detector_tb;
    
    // DUT ports
    reg tb_clk;
    reg tb_rst;
    reg tb_din;
    wire tb_dout;

    // Instance of design under test (DUT)
    sequence_detector sd0   (   .clk    (tb_clk),
                                .rst    (tb_rst),
                                .din    (tb_din),
                                .dout   (tb_dout));

    wire[2:0] tb_current_state = sd0.current_state;

    // Simulus generation
    // Clock
    always #10 tb_clk = ~tb_clk;

    // Variables
    reg         error = 0;
    reg[3:0]    sr  = 0;

    initial 
    begin

        $display("* Starting test *");

        // Initialization
        tb_clk  <= 1'b0;
        tb_rst  <= 1'b1;

        // RST signal
        #10 tb_rst <= 0;
    
    end

    // Automation check
    always@(posedge tb_clk) begin
        if (tb_rst) begin            
            tb_din <= 0;
            sr <= 0;
        end
        else begin
            tb_din <= $random % 2;       // Random value between 0 and 1.
            sr <= {sr[2:0], tb_din};     // Inserts data into shift register.

            // If dout = 1, then sr = 4'hA.
            if ((sr != 4'hA) && (tb_dout == 1)) begin
                $display("sr error!!! tb_dout: %d, sr: %b, time: %t", tb_dout, sr, $time);
                error = 1;
            end
            // If dout = 1, then current_state = S4.
            if (tb_dout == 1 && (tb_current_state != sd0.S4)) begin
                $display("state error!!! tb_dout: %d, sr: %b, time: %t", tb_dout, sr, $time);
                error = 1;
            end

            // If error = 0, print OK message.
            if(!error)
                $display("OK! tb_dout: %d, sr: %b, time: %t", tb_dout, sr, $time);
            else
                $finish;
        end  

    end

endmodule
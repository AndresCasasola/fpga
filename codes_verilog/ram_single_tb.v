
/////////////////////////////////////////////////////////////////////////////////
//
// Engineer:        Andres Casasola Dominguez
// Github:          AndresCasasola

// Create Date:     07/2021
// Module Name:     ram_single_tb
// Dependencies:    None
// Description:     Testbench for ram_single.
// 
/////////////////////////////////////////////////////////////////////////////////

module ram_single_tb;
    
    // DUT ports
    reg         tb_clka;
    reg         tb_rsta;
    reg         tb_wea;
    reg         tb_ena;
    reg[1:0]    tb_dina;
    reg[13:0]   tb_addra;
    wire[1:0]   tb_douta;

    // Instance of design under test (DUT)
    ram_single  ram0   (    .clka   (tb_clka),
                            .rsta   (tb_rsta),
                            .wea    (tb_wea),
                            .ena    (tb_ena),
                            .dina   (tb_dina),
                            .addra  (tb_addra),
                            .douta  (tb_douta) );


    // Simulus generation
    // Clock
    always #10 tb_clka = ~tb_clka;

    // Parameters
    parameter   WRITE       = 0,
                READ        = 1,
                GET_DOUT    = 2,
                CHECK       = 3;

    // Variables
    reg[1:0]    dout = 0;
    reg[1:0]    din = 0;
    reg[13:0]   addr = 0;
    reg[1:0]    state = WRITE;

    initial begin

        $display("* Starting test *");

        // Initialization
        tb_clka     <= 1'b0;
        tb_rsta     <= 1'b1;
        tb_ena      <= 1'b1;

        // RST signal
        #10 tb_rsta <= 0;

        // Write
        /*tb_addra    <= 14'b00000000000000;
        tb_dina     <= 2'b01;
        tb_wea      <= 1'b1;
        #20
        // Write
        tb_addra    <= 14'b00000000000100;
        tb_dina     <= 2'b10;
        tb_wea      <= 1'b1;
        #20
        // Read
        tb_addra    <= 14'b00000000000000;
        tb_dina     <= 2'b01;
        tb_wea      <= 1'b0;
        #20        
        // Read
        tb_addra    <= 14'b00000000000100;
        tb_dina     <= 2'b01;
        tb_wea      <= 1'b0;*/

    end

    // Automation check
    always@(posedge tb_clka) begin
        case (state)
            WRITE: begin
                addr <= $urandom_range((2**14)-1, 0);
                tb_wea <= 1'b1;
                din <= $random % 4;
                state <= READ;
            end
            READ: begin
                tb_wea <= 1'b0;
                state <= GET_DOUT;
            end
            GET_DOUT: begin
                state <= CHECK;
            end
            CHECK: begin
                if (tb_douta != din) begin
                    $display("Error!!! Debug-> din: %b, dout: %b, time: %t", din, dout, $time);
                    $finish;
                end
                else
                    $display("Operation OK!");
                
                state <= WRITE;
            end
        endcase
    end

    assign tb_dina = din;
    assign tb_addra = addr;

endmodule
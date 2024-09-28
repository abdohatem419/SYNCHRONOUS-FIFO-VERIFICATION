//===========================================================
// Project:     FIFO Verification
// File:        FIFO_testbench.sv
// Author:      Abdelrahman Hatem Nasr
// Date:        2024-09-28
// Description: This testbench drives the FIFO interface 
//              with randomized transactions. The testbench 
//              generates signals such as read enable, write 
//              enable, and data input, then monitors the 
//              FIFO behavior for a set number of iterations.
//===========================================================

module FIFO_testbench(FIFO_INT.TEST fifo_interface_instance);

    //===========================================================
    // Imports
    //===========================================================
    import transaction_pkg::*;
    import shared_pkg::*;

    //===========================================================
    // Local Parameters
    //===========================================================
    localparam ITERATIONS = 5000;

    //===========================================================
    // Transaction Object Declaration
    //===========================================================
    FIFO_transaction transaction_object;

    //===========================================================
    // Initial Block
    // Description: Drives the FIFO interface with randomized 
    //              values over multiple iterations and resets 
    //              the FIFO at the beginning of the simulation.
    //===========================================================
    initial begin
        transaction_object = new();
        fifo_interface_instance.rst_n = 0;
        @(negedge fifo_interface_instance.clk);
        fifo_interface_instance.rst_n = 1;

        // Loop for driving randomized transactions
        for(int i = 0 ; i < ITERATIONS ; i++) begin
            @(negedge fifo_interface_instance.clk);
            assert(transaction_object.randomize());
            fifo_interface_instance.rst_n   = transaction_object.rst_n;
            fifo_interface_instance.rd_en   = transaction_object.rd_en;
            fifo_interface_instance.wr_en   = transaction_object.wr_en;
            fifo_interface_instance.data_in = transaction_object.data_in;
        end

        shared_pkg::test_finished = 1;
    end

endmodule

//===========================================================
// Project:     FIFO Verification
// File:        FIFO_monitor.sv
// Author:      Abdelrahman Hatem Nasr
// Date:        2024-09-28
// Description: This module monitors the FIFO interface by 
//              capturing signals and updating transaction, 
//              coverage, and scoreboard instances. It runs 
//              continuously to sample data and check correctness 
//              while monitoring for test completion.
//===========================================================

module FIFO_monitor(FIFO_INT.MONITOR fifo_interface_instance);

    //===========================================================
    // Imports
    //===========================================================
    import transaction_pkg::*;
    import coverage_pkg::*;
    import scoreboard_pkg::*;
    import shared_pkg::*;

    //===========================================================
    // Instance Declarations
    //===========================================================
    FIFO_transaction transaction_inst;
    FIFO_coverage    coverage_inst;
    FIFO_scoreboard  scoreboard_inst;

    //===========================================================
    // Initial Block
    // Description: Initializes the transaction, coverage, and 
    //              scoreboard instances, then continuously 
    //              monitors the FIFO interface signals.
    //===========================================================
    initial begin
        transaction_inst = new();
        coverage_inst    = new();
        scoreboard_inst  = new();

        forever begin
            @(negedge fifo_interface_instance.clk);
            transaction_inst.rst_n       = fifo_interface_instance.rst_n;
            transaction_inst.data_in     = fifo_interface_instance.data_in;
            transaction_inst.wr_en       = fifo_interface_instance.wr_en;
            transaction_inst.rd_en       = fifo_interface_instance.rd_en;
            transaction_inst.data_out    = fifo_interface_instance.data_out;
            transaction_inst.full        = fifo_interface_instance.full;
            transaction_inst.almostfull  = fifo_interface_instance.almostfull;
            transaction_inst.empty       = fifo_interface_instance.empty;
            transaction_inst.almostempty = fifo_interface_instance.almostempty;
            transaction_inst.overflow    = fifo_interface_instance.overflow;
            transaction_inst.underflow   = fifo_interface_instance.underflow;
            transaction_inst.wr_ack      = fifo_interface_instance.wr_ack;

            // Fork to sample data and check correctness
            fork
                begin
                    coverage_inst.sample_data(transaction_inst);
                end
                begin
                    scoreboard_inst.check_data(transaction_inst);
                end
            join

            if(shared_pkg::test_finished) begin
                $display("Test finished correctly with the following summary: Correct counts = %d, Error counts = %d", shared_pkg::CORRECT_COUNT, shared_pkg::ERROR_COUNT);
                $stop;
            end
        end
        
    end
    
endmodule

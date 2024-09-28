//===========================================================
// Project:     FIFO Verification
// File:        top.sv
// Author:      Abdelrahman Hatem Nasr
// Date:        2024-09-28
// Description: This module serves as the top-level design for 
//              the FIFO verification environment. It generates 
//              the clock signal and instantiates the FIFO 
//              interface, the DUT (FIFO), the testbench, and 
//              the monitor for checking the FIFO operations.
//===========================================================

module top;

    //===========================================================
    // Clock Signal Declaration
    //===========================================================
    bit clk;

    //===========================================================
    // Clock Generation
    //===========================================================
    initial begin
        clk = 0;
        forever #1 clk = ~clk;
    end

    //===========================================================
    // Module Instantiations
    //===========================================================
    FIFO_INT fifo_interface_instance (clk);
    FIFO fifo_dut (fifo_interface_instance);
    FIFO_testbench fifo_tb (fifo_interface_instance);
    FIFO_monitor fifo_mt (fifo_interface_instance);

endmodule

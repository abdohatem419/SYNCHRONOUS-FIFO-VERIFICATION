//===========================================================
// Project:     FIFO Verification
// File:        FIFO_INT.sv
// Author:      Abdelrahman Hatem Nasr
// Date:        2024-09-28
// Description: This interface defines the FIFO input/output 
//              signals and the modports for different roles 
//              (DUT, TEST, MONITOR) in the FIFO verification 
//              environment. It includes parameters for FIFO 
//              width and depth as well as necessary control 
//              and status signals.
//===========================================================

interface FIFO_INT(input bit clk);

    //===========================================================
    // Parameters
    //===========================================================
    parameter FIFO_WIDTH = 16;
    parameter FIFO_DEPTH = 8;

    //===========================================================
    // Input/Output Signals
    //===========================================================
    logic [FIFO_WIDTH-1:0] data_in;
    logic rst_n, wr_en, rd_en;
    logic [FIFO_WIDTH-1:0] data_out;
    logic wr_ack, overflow;
    logic full, empty, almostfull, almostempty, underflow;

    //===========================================================
    // Modport Declarations
    //===========================================================
    modport DUT (
        input clk,
        data_in,
        rst_n,
        wr_en,
        rd_en,
        output data_out,
        wr_ack,
        overflow,
        full,
        empty,
        almostfull,
        almostempty,
        underflow
    );

    modport TEST (
        output data_in,
        rst_n,
        wr_en,
        rd_en,
        input clk,
        data_out,
        wr_ack,
        overflow,
        full,
        empty,
        almostfull,
        almostempty,
        underflow
    );

    modport MONITOR (
        input clk,
        data_in,
        rst_n,
        wr_en,
        rd_en,
        data_out,
        wr_ack,
        overflow,
        full,
        empty,
        almostfull,
        almostempty,
        underflow
    );

endinterface

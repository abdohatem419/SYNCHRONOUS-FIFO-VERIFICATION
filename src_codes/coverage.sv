//===========================================================
// Project:     FIFO Verification
// File:        coverage_pkg.sv
// Author:      Abdelrahman Hatem Nasr
// Date:        2024-09-28
// Description: This package defines the functional coverage 
//              for the FIFO module. It utilizes transaction 
//              data to track the various signal states and 
//              their combinations for read, write, overflow,
//              underflow, and other FIFO conditions.
//===========================================================

package coverage_pkg;
import transaction_pkg::*;
import shared_pkg::*;

//===========================================================
// Class:       FIFO_coverage
// Description: This class contains the covergroup to capture 
//              functional coverage of FIFO operations. 
//              Coverage is recorded for read enable, write 
//              enable, and various FIFO status signals.
//              Cross coverage is also defined to observe 
//              combinations of these signals.
//===========================================================
class FIFO_coverage;

//===========================================================
// Transaction object to capture FIFO states
//===========================================================
FIFO_transaction F_cvg_txn = new();

//===========================================================
// Covergroup:  cvg
// Description: The covergroup defines coverpoints for 
//              monitoring FIFO signals such as read enable, 
//              write enable, overflow, and other conditions.
//              Cross coverage is also defined to observe 
//              combinations of these signals.
//===========================================================
covergroup cvg;
      cp_rd_en:       coverpoint F_cvg_txn.rd_en;
      cp_wr_en:       coverpoint F_cvg_txn.wr_en;
      cp_wr_ack:      coverpoint F_cvg_txn.wr_ack;
      cp_overflow:    coverpoint F_cvg_txn.overflow;
      cp_full:        coverpoint F_cvg_txn.full;
      cp_empty:       coverpoint F_cvg_txn.empty;
      cp_almostfull:  coverpoint F_cvg_txn.almostfull;
      cp_almostempty: coverpoint F_cvg_txn.almostempty;
      cp_underflow:   coverpoint F_cvg_txn.underflow;

      //===========================================================
      // Cross coverage definitions for signal interactions
      //===========================================================
      cross cp_rd_en, cp_wr_en, cp_wr_ack;
      cross cp_rd_en, cp_wr_en, cp_overflow;
      cross cp_rd_en, cp_wr_en, cp_full;
      cross cp_rd_en, cp_wr_en, cp_empty;
      cross cp_rd_en, cp_wr_en, cp_almostfull;
      cross cp_rd_en, cp_wr_en, cp_almostempty;
      cross cp_rd_en, cp_wr_en, cp_underflow;
endgroup

//===========================================================
// Function:    new
// Description: Constructor for the FIFO_coverage class, 
//              initializes the covergroup.
//===========================================================
function new();
    cvg = new();
endfunction

//===========================================================
// Function:    sample_data
// Description: This function samples the data from the 
//              FIFO transaction object and triggers the 
//              covergroup sampling.
//===========================================================
function void sample_data(FIFO_transaction F_txn);
    F_cvg_txn = F_txn;
    cvg.sample();
endfunction

endclass
endpackage

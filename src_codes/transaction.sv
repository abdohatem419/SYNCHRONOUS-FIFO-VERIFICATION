//===========================================================
// Project:     FIFO Verification
// File:        transaction_pkg.sv
// Author:      Abdelrahman Hatem Nasr
// Date:        2024-09-28
// Description: This package defines the FIFO_transaction class, 
//              which encapsulates the transaction details for 
//              the FIFO interface, including data input/output 
//              signals and control signals. It includes 
//              randomization constraints for enabling read and 
//              write operations, as well as a constructor to 
//              initialize distribution parameters.
//===========================================================

package transaction_pkg;

    //===========================================================
    // Imports
    //===========================================================
    import shared_pkg::*;

    //===========================================================
    // FIFO Transaction Class
    //===========================================================
    class FIFO_transaction;

        //===========================================================
        // Properties
        //===========================================================
        bit clk;
        parameter FIFO_WIDTH = 16;
        parameter FIFO_DEPTH = 8;
        rand logic [FIFO_WIDTH-1:0] data_in;
        rand logic rst_n, wr_en, rd_en;
        logic [FIFO_WIDTH-1:0] data_out;
        logic wr_ack, overflow;
        logic full, empty, almostfull, almostempty, underflow;
        int RD_EN_ON_DIST, WR_EN_ON_DIST;

        //===========================================================
        // Constructor
        //===========================================================
        function new(int rd = 30, int wr = 70);
            this.RD_EN_ON_DIST = rd;
            this.WR_EN_ON_DIST = wr;
        endfunction

        //===========================================================
        // Constraints
        //===========================================================
        constraint reset_n {
            rst_n dist {
                0 := 20,
                1 := 80
            };
        }

        constraint write_enable {
            wr_en dist {
                0 := 100 - WR_EN_ON_DIST,
                1 := WR_EN_ON_DIST
            };
        }

        constraint read_enable {
            rd_en dist {
                0 := 100 - RD_EN_ON_DIST,
                1 := RD_EN_ON_DIST
            };
        }
    endclass

endpackage

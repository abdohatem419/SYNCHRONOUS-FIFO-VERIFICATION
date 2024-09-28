//===========================================================
// Project:     FIFO Verification
// File:        scoreboard_pkg.sv
// Author:      Abdelrahman Hatem Nasr
// Date:        2024-09-28
// Description: This package defines the FIFO scoreboard class 
//              which is responsible for checking the correctness 
//              of data output from the FIFO based on a reference 
//              model. It maintains a reference FIFO and counts 
//              items in it to validate operations performed by 
//              the DUT.
//===========================================================

package scoreboard_pkg;

import transaction_pkg::*;
import shared_pkg::*;

class FIFO_scoreboard;

    //===========================================================
    // Parameter Declarations
    //===========================================================
    parameter FIFO_WIDTH = 16;
    parameter FIFO_DEPTH = 8;

    //===========================================================
    // Variable Declarations
    //===========================================================
    logic [FIFO_WIDTH-1:0] data_out_ref;
    logic [FIFO_WIDTH-1:0] poped_out;
    logic [FIFO_WIDTH-1:0] fifo_ref [FIFO_DEPTH-1:0]; //  memory for the FIFO reference
    int fifo_count_ref;    // Reference count of items in the FIFO
    int write_pointer_ref; // Reference write pointer
    int read_pointer_ref;  // Reference read pointer

    //===========================================================
    // Constructor
    //===========================================================
    function new();
         fifo_count_ref = 0; 
         write_pointer_ref = 0;
         read_pointer_ref = 0;
    endfunction

    //===========================================================
    // Function to Check Data
    //===========================================================
    function void check_data(FIFO_transaction ftran);
         reference_model(ftran);
         if(data_out_ref != ftran.data_out) begin
            ERROR_COUNT++;
            $display("ERROR ENCOUNTERED! EXPECTED DATA OUT: %h, GOT: %h", data_out_ref, ftran.data_out);
         end
         else begin
            CORRECT_COUNT++;
         end
    endfunction

    //===========================================================
    // Reference Model Function
    //===========================================================
    function void reference_model(FIFO_transaction ftran);
         if(!ftran.rst_n) begin
            write_pointer_ref <= 0; 
            read_pointer_ref <= 0;
            fifo_count_ref <= 0;
         end
         else begin
            fork
               begin
                  // Write operation logic
                  if (ftran.wr_en && !ftran.full) begin
                     fifo_ref[write_pointer_ref] <= ftran.data_in;
                     write_pointer_ref <= write_pointer_ref + 1; 
                  end
               end
               begin
                  // Read operation logic
                  if (ftran.rd_en && !ftran.empty) begin
                     data_out_ref <= fifo_ref[read_pointer_ref];
                     read_pointer_ref <= read_pointer_ref + 1; 
                  end
               end
               begin
                  // Counter operation logic 
                  if (({ftran.wr_en, ftran.rd_en} == 2'b10 && !ftran.full) || 
                      ({ftran.wr_en, ftran.rd_en} == 2'b11 && ftran.empty)) 
                     fifo_count_ref <= fifo_count_ref + 1;
                  else if (({ftran.wr_en, ftran.rd_en} == 2'b01 && !ftran.empty) || 
                           ({ftran.wr_en, ftran.rd_en} == 2'b11 && ftran.full))
                     fifo_count_ref <= fifo_count_ref - 1;
               end
            join
         end
         ftran.full = (fifo_count_ref == FIFO_DEPTH) ? 1 : 0;
         ftran.almostfull = (fifo_count_ref == FIFO_DEPTH - 1) ? 1 : 0;
         ftran.empty = (fifo_count_ref == 0) ? 1 : 0;
         ftran.almostempty = (fifo_count_ref == 1) ? 1 : 0;
    endfunction

endclass

endpackage

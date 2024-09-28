//===========================================================
// Project:     FIFO Verification
// File:        shared_pkg.sv
// Author:      Abdelrahman Hatem Nasr
// Date:        2024-09-28
// Description: This package defines shared parameters and 
//              variables used across different modules in the 
//              FIFO verification environment, including error 
//              counts and a flag to indicate test completion.
//===========================================================

package shared_pkg;

    //===========================================================
    // Local Parameters
    //===========================================================
    localparam SYSTEM_PATH = 64;

    //===========================================================
    // Static Variables
    //===========================================================
    static bit [SYSTEM_PATH-1:0] ERROR_COUNT, CORRECT_COUNT;
    static bit test_finished;

endpackage

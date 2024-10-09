////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: FIFO Design 
// 
////////////////////////////////////////////////////////////////////////////////
module FIFO(FIFO_INT.DUT fifo_interface_instance);
import shared_pkg::*;
 
localparam max_fifo_addr = $clog2(fifo_interface_instance.FIFO_DEPTH);

reg [fifo_interface_instance.FIFO_WIDTH-1:0] mem [fifo_interface_instance.FIFO_DEPTH-1:0];

reg [max_fifo_addr-1:0] wr_ptr, rd_ptr;
reg [max_fifo_addr:0] count;

always @(posedge fifo_interface_instance.clk or negedge fifo_interface_instance.rst_n) begin
	if (!fifo_interface_instance.rst_n) begin
		wr_ptr <= 0;
		fifo_interface_instance.overflow <= 0;
		fifo_interface_instance.wr_ack <= 0;
	end
	else if (fifo_interface_instance.wr_en && count < fifo_interface_instance.FIFO_DEPTH) begin
		mem[wr_ptr] <= fifo_interface_instance.data_in;
		fifo_interface_instance.wr_ack <= 1;
		wr_ptr <= wr_ptr + 1;
	end
	else begin 
		fifo_interface_instance.wr_ack <= 0; 
		if (fifo_interface_instance.full && fifo_interface_instance.wr_en)
			fifo_interface_instance.overflow <= 1;
		else
			fifo_interface_instance.overflow <= 0;
	end
end

always @(posedge fifo_interface_instance.clk or negedge fifo_interface_instance.rst_n) begin
	if (!fifo_interface_instance.rst_n) begin
		rd_ptr <= 0;
		fifo_interface_instance.underflow <= 0;
	end
	else if (fifo_interface_instance.rd_en && count != 0) begin
		fifo_interface_instance.data_out <= mem[rd_ptr];
		rd_ptr <= rd_ptr + 1;
	end
	else begin 
		if (fifo_interface_instance.empty && fifo_interface_instance.rd_en)
			fifo_interface_instance.underflow <= 1;
		else
			fifo_interface_instance.underflow <= 0;
	end
end

always @(posedge fifo_interface_instance.clk or negedge fifo_interface_instance.rst_n) begin
	if (!fifo_interface_instance.rst_n) begin
		count <= 0;
	end
	else begin
		if	( (({fifo_interface_instance.wr_en, fifo_interface_instance.rd_en} == 2'b10) && (!fifo_interface_instance.full)) || 
			 (({fifo_interface_instance.wr_en, fifo_interface_instance.rd_en} == 2'b11) && (fifo_interface_instance.empty))) 
			count <= count + 1;
		else if ((({fifo_interface_instance.wr_en, fifo_interface_instance.rd_en} == 2'b01) && (!fifo_interface_instance.empty)) || 
			 (({fifo_interface_instance.wr_en, fifo_interface_instance.rd_en} == 2'b11) && (fifo_interface_instance.full)))
			count <= count - 1;
	end
end

assign fifo_interface_instance.full = (count == fifo_interface_instance.FIFO_DEPTH)? 1 : 0;
assign fifo_interface_instance.empty = (count == 0)? 1 : 0;
assign fifo_interface_instance.almostfull = (count == fifo_interface_instance.FIFO_DEPTH-1)? 1 : 0; 
assign fifo_interface_instance.almostempty = (count == 1)? 1 : 0;

// Assertions for Outputs and Internals (wrapped in `ifdef SIM)
    `ifdef SIM

    property write_acknowledge;
	@(posedge fifo_interface_instance.clk) disable iff(!fifo_interface_instance.rst_n) (fifo_interface_instance.wr_en && !fifo_interface_instance.full) |=> fifo_interface_instance.wr_ack
	endproperty

   
    property full_flag;
	@(posedge fifo_interface_instance.clk) (count == fifo_interface_instance.FIFO_DEPTH) |-> fifo_interface_instance.full == 1
	endproperty

    
	property empty_flag;
	@(posedge fifo_interface_instance.clk) (count == 0) |-> fifo_interface_instance.empty == 1
	endproperty


	property almostfull_flag;
	@(posedge fifo_interface_instance.clk) (count == fifo_interface_instance.FIFO_DEPTH-1) |-> fifo_interface_instance.almostfull
	endproperty


	property almostempty_flag;
    @(posedge fifo_interface_instance.clk) (count == 1) |-> fifo_interface_instance.almostempty
	endproperty


	property overflow_flag;
	@(posedge fifo_interface_instance.clk) disable iff(!fifo_interface_instance.rst_n) (fifo_interface_instance.full && fifo_interface_instance.wr_en) |=> fifo_interface_instance.overflow
	endproperty

	property underflow_flag;
	@(posedge fifo_interface_instance.clk) disable iff(!fifo_interface_instance.rst_n) (fifo_interface_instance.empty && fifo_interface_instance.rd_en ) |=> fifo_interface_instance.underflow
	endproperty


	property counter_overflow;
	@(posedge fifo_interface_instance.clk) (count <= fifo_interface_instance.FIFO_DEPTH)
	endproperty


	property read_pointer_overflow;
	@(posedge fifo_interface_instance.clk) (rd_ptr < fifo_interface_instance.FIFO_DEPTH)
	endproperty


	property write_pointer_overflow;
	@(posedge fifo_interface_instance.clk) (wr_ptr < fifo_interface_instance.FIFO_DEPTH)
	endproperty


	property counter_operation_up;
	@(posedge fifo_interface_instance.clk) disable iff(!fifo_interface_instance.rst_n) ( (({fifo_interface_instance.wr_en, fifo_interface_instance.rd_en} == 2'b10) && (!fifo_interface_instance.full)) || (({fifo_interface_instance.wr_en, fifo_interface_instance.rd_en} == 2'b11) && (fifo_interface_instance.empty))) |=> count == $past(count) + 4'b0001
	endproperty


	property counter_operation_down;
	@(posedge fifo_interface_instance.clk) disable iff(!fifo_interface_instance.rst_n)( (({fifo_interface_instance.wr_en, fifo_interface_instance.rd_en} == 2'b01) && (!fifo_interface_instance.empty)) || (({fifo_interface_instance.wr_en, fifo_interface_instance.rd_en} == 2'b11) && (fifo_interface_instance.full))) |=> count == $past(count) - 4'b0001
	endproperty


	property read_pointer_operation;
	@(posedge fifo_interface_instance.clk) disable iff(!fifo_interface_instance.rst_n) (fifo_interface_instance.rd_en && !fifo_interface_instance.empty) |=> rd_ptr == $past(rd_ptr)+3'b001
	endproperty


	property write_pointer_operatrion;
	@(posedge fifo_interface_instance.clk) disable iff(!fifo_interface_instance.rst_n) (fifo_interface_instance.wr_en && !fifo_interface_instance.full) |=> wr_ptr == $past(wr_ptr)+3'b001
	endproperty

	always_comb begin
		if(!fifo_interface_instance.rst_n) begin
		a_reset: assert final(count == 0);
		b_reset: assert final(fifo_interface_instance.overflow == 0);
		c_reset: assert final(fifo_interface_instance.underflow == 0);
		d_reset: assert final(wr_ptr == 0);
		e_reset: assert final(rd_ptr == 0);
		f_reset: assert final(fifo_interface_instance.wr_ack == 0);
		end
	end

	ast1  : assert property(write_acknowledge)        else $fatal("Assertion failed: 'wr_ack' should be asserted when write occurs and FIFO is not full!");
	cvr1  : cover property(write_acknowledge);
	ast2  : assert property(full_flag)                else $fatal("Assertion failed: 'full' flag mismatch with fifo_count!");
	cvr2  : cover property(full_flag);
	ast3  : assert property(empty_flag) 	          else $fatal("Assertion failed: 'empty' flag mismatch with fifo_count!");
	cvr3  : cover property(empty_flag);
	ast4  : assert property(almostfull_flag)          else $fatal("Assertion failed: 'almostfull' flag mismatch with fifo_count!");
	cvr4  : cover property(almostfull_flag);
 	ast5  : assert property(almostempty_flag)         else $fatal("Assertion failed: 'almostempty' flag mismatch with fifo_count!");
	cvr5  : cover property(almostempty_flag);
	ast6  : assert property(overflow_flag)            else $fatal("Assertion failed: 'overflow' flag mismatch if full and wr_en it should be assertd!");
	cvr6  : cover property(overflow_flag);
	ast7  : assert property(underflow_flag)           else $fatal("Assertion failed: 'underflow' flag mismatch if empty and rd_en it should be assertd!");
	cvr7  : cover property(underflow_flag);
	ast8  : assert property(counter_overflow)         else $fatal("Assertion failed: 'count overflow'!");
	cvr8  : cover property(counter_overflow);
	ast9  : assert property(read_pointer_overflow)    else $fatal("Assertion failed: 'read pointer overflow'!");
	cvr9  : cover property(read_pointer_overflow);
	ast10 : assert property(write_pointer_overflow)   else $fatal("Assertion failed: 'write pointer overflow'!");
	cvr10 : cover property(write_pointer_overflow);
	ast11 : assert property(counter_operation_up)     else $fatal("Assertion failed: 'count' when wr_en is high and rd_en is low it should increased!");
	cvr11 : cover property(counter_operation_up);
	ast12 : assert property(counter_operation_down)   else $fatal("Assertion failed: 'count' when wr_en is low and rd_en is high it should decreased!");
	cvr12 : cover property(counter_operation_down);
	ast13 : assert property(read_pointer_operation)   else $fatal("Assertion failed: 'rd_ptr' should increased!");
	cvr13 : cover property(read_pointer_operation);
	ast14 : assert property(write_pointer_operatrion) else $fatal("Assertion failed: 'wr_ptr' should increased!");
	cvr14 : cover property(write_pointer_operatrion);
    `endif

endmodule

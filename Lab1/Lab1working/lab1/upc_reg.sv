// micro-program counter, asynchronous reset
// Active high load
// Active low increment
module upcreg(
  input              clk,
  input              reset,
  input              load_incr,
  input [4:0]        upc_next,
  output logic [4:0] upc);

  always_ff @ (posedge clk, posedge reset) begin
    if      (reset     == 1) upc <= '0;
    else if (load_incr == 1) upc <= upc_next;
    else if (load_incr == 0) upc <= upc + 1;
//   reset    load_incr	    upc
//     1	1            0
//     1	0            0
//     0	1	   upc_next
//     0	0          upc+1
  end
endmodule    


// // Code your design here
// `include "addsub.sv"
// `include "counter_down.sv"
// `include "mux2.sv"
// `include "mux3.sv"
// `include "mux5.sv"
// `include "register_hl.sv"
// `include "register.sv"
// `include "robs_control_unit_micro.sv"
// `include "robs_data_path.sv"
// `include "robsmult.sv"
// `include "right_shift_register.sv"
// `include "rom.sv"
// `include "upc_reg.sv"
// `include "robertsonstest.sv"




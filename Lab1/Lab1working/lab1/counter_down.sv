// Counter that decrements from WIDTH to 0 at every positive clock edge.
// CSE140L      lab 1
module counter_down	#(parameter dw=8, WIDTH=7)
(
  input                 clk,
  input                 reset,
  input                 ena,
  output logic [dw-1:0] result);

  always @(posedge clk)	 begin
    if      (reset == 1) result <= WIDTH;      // reset result
    else if(ena) begin
      if(result > 0) result <= result - 1;   // Decrement if enabled and greater than 0
      // No need to handle the case where result is 0 and ena is 1, because it should stay at 0
    end
//reset   ena      result
//  1      1       WIDTH
//  1      0       WIDTH						 
//  0      1       decrease by 1				 
//  0      0       hold							 
  end
endmodule	
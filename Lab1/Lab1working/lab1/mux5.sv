// 5:1 MULTIPLEXER	(combinational 5-way switch)
module mux5 (input        d0, d1, d2, d3, d4,
             input [2:0]  s, 
             output logic y);

  always_comb begin
    case(s)
      3'b000: y = d0;
      3'b001: y = d1;
      3'b010: y = d2;
      3'b011: y = d3;
      3'b100: y = d4;
      default: y = 0; // Covers cases 3'b101, 3'b110, and 3'b111
    endcase
  end
//  s      y
//  0	  d0	    s = 3'b000
//  1	  d1
//  2	  d2
//  3	  d3
//  4	  d4
//  5	   0
//  6	   0
//  7	   0	    s = 3'b111
endmodule

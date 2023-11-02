// CSE140 lab 2  
// How does this work? How long does the alarm stay on? 
// (buzz is the alarm itself)
module alarm(
  input[6:0]   tmin,
               amin,
			   thrs,
			   ahrs,
  input en,						 
  output logic buzz
);

  always_comb
    buzz = tmin==amin && thrs==ahrs && en;

endmodule
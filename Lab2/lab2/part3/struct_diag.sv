// CSE140L  
// see Structural Diagram in Lab2 assignment writeup
// fill in missing connections and parameters
module struct_diag #(parameter NS=60, NH=24, ND = 7, NM = 12)(
  input Reset,
        Timeset, 	  // manual buttons
        Alarmset,	  //	(five total)
		Minadv,
		Hrsadv,
    Dayadv,
    Dateadv,
		Monthadv,
		Alarmon,
		Pulse,		  // assume 1/sec.
// 6 decimal digit display (8 segment)
  output [6:0] S1disp, S0disp, 	   // 2-digit seconds display
               M1disp, M0disp, 
               H1disp, H0disp,
               D0disp, Month1disp, Month0disp,
	             Date1disp, Date0disp,
  output logic Buzz);	           // alarm sounds
// internal connections (may need more)
  logic[6:0] TSec, TMin, THrs,     // clock/time 
             AMin, AHrs, TDays, 
             TDate, TMonth;		   // alarm setting
  logic[6:0] Min, Hrs, DaysInMonth;
  logic Szero, Mzero, Hzero, Dtzero, 	   // "carry out" from sec -> min, min -> hrs, hrs -> days
        TMen, THen, AMen, AHen, TDen, TDateEn, TMonthEn,
        AlarmEnable; 

always_comb begin
TMen = Szero || (Timeset&&Minadv);
THen = (Mzero&&Szero) || (Timeset&&Hrsadv);
AMen = Minadv && Alarmset;
AHen = Hrsadv && Alarmset;
TDen = (Mzero&&Szero&&Hzero) || (Timeset&&Dayadv);
TDateEn = (Mzero&&Szero&&Hzero) || (Timeset&&Dateadv);
TMonthEn = (Mzero&&Szero&&Hzero&&Dtzero) || (Timeset&&Monthadv);
AlarmEnable = (Alarmon && TDays != 5 && TDays != 6);
end

always_comb begin
if(TMonth == 1) DaysInMonth = 28;
else if(TMonth == 3 || TMonth == 5 || TMonth == 8 || TMonth == 10) DaysInMonth = 30;
else DaysInMonth = 31;
end

// free-running seconds counter	-- be sure to set parameters on ct_mod_N modules 
  ct_mod_N #(.N(NS)) Sct(
// input ports
    .clk(Pulse), .rst(Reset), .en(!Timeset), 
// output ports    
    .ct_out(TSec), .z(Szero)
    );
// minutes counter -- runs at either 1/sec or 1/60sec
  ct_mod_N #(.N(NS)) Mct(
    .clk(Pulse), .rst(Reset), .en(TMen), .ct_out(TMin), .z(Mzero)
    );
// hours counter -- runs at either 1/sec or 1/60min
  ct_mod_N #(.N(NH)) Hct(
	.clk(Pulse), .rst(Reset), .en(THen), .ct_out(THrs), .z(Hzero)
    );
// alarm set registers -- either hold or advance 1/sec
  ct_mod_N #(.N(NS)) Mreg(
// input ports
    .clk(Pulse), .rst(Reset), .en(AMen), 
// output ports    
    .ct_out(AMin), .z()
    ); 

  ct_mod_N #(.N(NH)) Hreg(
    .clk(Pulse), .rst(Reset), .en(AHen), .ct_out(AHrs), .z()
    ); 

//Day counter
  ct_mod_N #(.N(ND)) Dct(
    .clk(Pulse), .rst(Reset), .en(TDen), .ct_out(TDays), .z()
  );

//Date counter
  ct_mod_D Dtct(
    .clk(Pulse), .rst(Reset), .en(TDateEn), .ct_out(TDate), .z(Dtzero), .N(DaysInMonth)
  );

//Month counter
  ct_mod_N #(.N(NM)) Mtct(
    .clk(Pulse), .rst(Reset), .en(TMonthEn), .ct_out(TMonth), .z()
  );

// display drivers (2 digits each, 6 digits total)
  lcd_int Sdisp(
    .bin_in    (TSec)  ,
	.Segment1  (S1disp),
	.Segment0  (S0disp)
	);

  lcd_int Mdisp(
    .bin_in    (Alarmset?AMin:TMin),
	.Segment1  (M1disp),
	.Segment0  (M0disp)
	);

  lcd_int Hdisp(
    .bin_in    (Alarmset?AHrs:THrs),
	.Segment1  (H1disp),
	.Segment0  (H0disp)
	);

  lcd_int Ddisp(
    .bin_in(TDays),
    .Segment0(D0disp)
  );

  lcd_int Dtisp(
    .bin_in(TDate+1),
    .Segment0(Date0disp),
    .Segment1(Date1disp)
  );

  lcd_int Mtdisp(
    .bin_in(TMonth+1),
    .Segment0(Month0disp),
    .Segment1(Month1disp)
  );

// buzz off :)	  make the connections
  alarm a1(
    .tmin(TMin), .amin(AMin), .thrs(THrs), .ahrs(AHrs), .buzz(Buzz), .en(AlarmEnable)
	);

endmodule
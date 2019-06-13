// >>>>>>>>>>>>>>>>>>>>>>>>> COPYRIGHT NOTICE <<<<<<<<<<<<<<<<<<<<<<<<<
// Author:
//		zequn yu
//		boteng yuan 
//--------------------------------------------------------------------
// Copyright (c) 2019 by UCSD CSE 140L
// --------------------------------------------------------------------
//
// Permission:
//
//   This code for use in UCSD CSE 140L.
//   It is synthesisable for Lattice iCEstick 40HX.  
//
// Disclaimer:
//
//   This Verilog source code is intended as a design reference
//   which illustrates how these types of functions can be implemented.
//   It is the user's responsibility to verify their design for
//   consistency and functionality through the use of formal
//   verification methods.  
//
// -------------------------------------------------------------------- //           
//                     UCSD CSE Department
//                     9500 Gilman Dr, La Jolla, CA 92093
//                     U.S.A
//
// --------------------------------------------------------------------

module Lab3_140L (
		  input wire 	    rst, // reset signal (active high)
		  input wire 	    clk, // global clock
		  input wire oneSecStrb,  	    
		  input 	    bu_rx_data_rdy, // data from the uart ready
		  input [7:0] 	    bu_rx_data, // data from the uart
		  output wire 	    L3_tx_data_rdy, // data to the alarm display
		  output wire [7:0] L3_tx_data,     // data to the alarm display
		  output [4:0] 	    L3_led,
		  output wire [6:0] 	    L3_segment1, // 1's seconds
		  output wire [6:0] 	    L3_segment2, // 10's seconds
		  output wire [6:0] 	    L3_segment3, // 1's minutes
		  output wire [6:0] 	    L3_segment4, // 10's minutes

		  output [3:0] 	    di_Mtens,
		  output [3:0] 	    di_Mones,
		  output [3:0] 	    di_Stens,
		  output wire [3:0] di_Sones,
		  output [3:0] 	    di_AMtens,
		  output [3:0] 	    di_AMones,
		  output [3:0] 	    di_AStens,
		  output [3:0] 	    di_ASones
		  );
		  
		  wire [6:0] L3_seg1;
  		  wire [6:0] L3_seg2;
  		  wire [6:0] L3_seg3;
 		  wire [6:0] L3_seg4;
 		  
		  wire dicLdMtens, dicLdMones, dicLdStens, dicLdSones, 
 		  	  dicLdAMtens, dicLdAMones, dicLdAStens, dicLdASones,
 		  	  dicRun, did_alarmMatch, dicAlarmArmed, dicAlarmIdle, dicAlarmTrig;

		  wire [7:0] dib0;
		  wire [7:0] dib1;
		  wire [7:0] dib2;
		  wire [7:0] dib3;
		  wire [7:0] dib4;
		  wire [7:0] dib5;
		  wire [7:0] dib6;
		  wire [7:0] dib7;
 		  
		  assign dib0 = {4'b0011, di_AMtens};
    		  assign dib1 = {4'b0011, di_AMones};
    		  assign dib2 = 8'b00111010;
    		  assign dib3 = {4'b0011, di_AStens};
   		  assign dib4 = {4'b0011, di_ASones};
    		  assign dib5 = 8'b00100000;
    		  assign dib7 = 8'b00001101;
    
   		  reg [7:0] br6;
    		  always @(*) begin
                         	if (dicAlarmIdle) br6[7:0] = 8'b00101110;
     			else if (dicAlarmArmed) br6[7:0] = 8'b01100001;
     			else if (dicAlarmTrig) br6[7:0] = 8'b01010100;
    		  end
    		  assign dib6[7:0] = br6;
		  
		  dispString d1(.rdy(L3_tx_data_rdy), .dOut(L3_tx_data), .b0(dib0), .b1(dib1), .b2(dib2), .b3(dib3), .b4(dib4), .b5(dib5), .b6(dib6), .b7(dib7), .go(oneSecStrb), .clk(clk), .rst(rst));
 		  

		  bcd2segment b1(.segment(L3_segment1), .num(di_Sones), .enable(1'b1));
		  bcd2segment b2(.segment(L3_segment2), .num(di_Stens), .enable(1'b1));
		  bcd2segment b3(.segment(L3_segment3), .num(di_Mones), .enable(1'b1));
	 	  bcd2segment b4(.segment(L3_segment4), .num(di_Mtens), .enable(1'b1));
		
		  dictrl dic(.dicLdMtens(dicLdMtens), .dicLdMones(dicLdMones), .dicLdStens(dicLdStens), .dicLdSones(dicLdSones),
 		  			 .dicLdAMtens(dicLdAMtens), .dicLdAMones(dicLdAMones), .dicLdAStens(dicLdAStens), .dicLdASones(dicLdASones),
 		  			 .dicRun(dicRun), .dicAlarmIdle(dicAlarmIdle), .dicAlarmArmed(dicAlarmArmed), .dicAlarmTrig(dicAlarmTrig),
 		  			 .did_alarmMatch(did_alarmMatch), .bu_rx_data_rdy(bu_rx_data_rdy), .bu_rx_data(bu_rx_data), .rst(rst), .clk(clk));
 		  	
 		  
 		  //didp didp(di_Mtens, di_Mones, di_Stens, di_Sones, di_AMtens, di_AMones, 
 		  //	di_AStens, di_ASones, did_alarmMatch, L3_led, bu_rx_data, 1'b0, 1'b0, 1'b0, 
 		  //	1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, oneSecStrb, rst, clk);
 		  


			didp dp1(.di_AMtens(di_AMtens), .di_AMones(di_AMones), .di_AStens(di_AStens), .di_ASones(di_ASones), .bu_rx_data(bu_rx_data), .L3_led(L3_led), .di_Mtens(di_Mtens), .di_Mones(di_Mones), .di_Stens(di_Stens), .di_Sones(di_Sones), .dicLdMtens(dicLdMtens),
					 .dicLdMones(dicLdMones), .dicLdStens(dicLdStens), .dicLdSones(dicLdSones), .dicRun(dicRun), .oneSecStrb(oneSecStrb),
					 .rst(rst), .clk(clk), .dicLdAMtens(dicLdAMtens), .dicLdAMones(dicLdAMones), .dicLdAStens(dicLdAStens), .dicLdASones(dicLdASones));




endmodule // Lab3_140L



//
//
// sample interface for clock datpath
//
module didp (
	     output [3:0] di_Mtens, // current 10's minutes
	     output [3:0] di_Mones, // current 1's minutes
	     output [3:0] di_Stens, // current 10's second
	     output [3:0] di_Sones, // current 1's second

	     output [3:0] di_AMtens, // current alarm 10's minutes
	     output [3:0] di_AMones, // current alarm 1's minutes
	     output [3:0] di_AStens, // current alarm 10's second
	     output [3:0] di_ASones, // current alarm 1's second

	     output wire  did_alarmMatch, // one cydie alarm match (raw signal, unqualified)

	     output [4:0] L3_led,

	     input [7:0]  bu_rx_data,
	     input 	  dicLdMtens, // load 10's minute
	     input 	  dicLdMones, // load 1's minute
	     input 	  dicLdStens, // load 10's second
	     input 	  dicLdSones, // load 1's second
	     
	     input 	  dicLdAMtens, // load alarm 10's minute
	     input 	  dicLdAMones, // load alarm 1's minute
	     input 	  dicLdAStens, // load alarm 10's second
	     input 	  dicLdASones, // load alarm 1's second
	     input 	  dicRun, //clock should run 	  
	     input 	  oneSecStrb, // one cycle strobe
	     input 	  rst,
	     input 	  clk 	  
	     );
		  
		  // set rst for 4 digits 
		  reg rst_so;
		  reg rst_st;
		  reg rst_mo;
		  reg rst_mt;
		  // set ce for 4 digits
		  reg ce_so;
		  reg ce_st;
		  reg ce_mo;
		  reg ce_mt;
		  
		  
		  // set reset for sec_one
		  always @* begin
					// check if so is 9(1001)
					if (di_Sones == 4'b1001) begin
							rst_so = 1'b1;
					end
					// if not
					else begin
							rst_so = 1'b0;
					end
		  
			// final set with OneSecStrb
			rst_so = (rst_so & oneSecStrb) | rst;
			// set ce 
			// ce_so = dicRun & oneSecStrb | dicLdSones;
		  end
		  // call funtion to increment
		  countrce c1( .q(di_Sones), .d(bu_rx_data[3:0]), .ld(dicLdSones), .ce(dicRun & oneSecStrb | dicLdSones), .rst(rst_so), .clk(clk) );
		  
		  
		  
		  // set reset for sec_ten
		  always @* begin
					// check if so is 9 and reset
					if (di_Sones == 4'b1001) begin
						// check if st is 5(0101)
						if (di_Stens == 4'b0101) begin
							rst_st = 1'b1;
						end
						// if not 5
						else begin
							rst_st = 1'b0;
						end
					end
					// if so not reset
					else begin
						rst_st = 1'b0;
					end
			
				// final set with oneSecStrb
				rst_st = (rst_st & oneSecStrb) | rst;
				// set ce
				// if so is 1001
			end
			always @* begin
				if (di_Sones == 4'b1001) begin
					ce_so = 1'b1;
				end
				else begin
					ce_so = 1'b0;
				end
			
				// final set ce 
				//ce_st = ce_so & oneSecStrb | dicLdStens;
			end
			// call function to increment
			countrce c2( .q(di_Stens), .d(bu_rx_data[3:0]), .ld(dicLdStens), .ce(ce_so & oneSecStrb | dicLdStens), .rst(rst_st), .clk(clk) );
			
			
			// set reset for min_one
			always @* begin
				// check if x9:59
				if ((di_Sones == 4'b1001) & (di_Stens == 4'b0101) & (di_Mones == 4'b1001) ) begin
					rst_mo = 1'b1;
				end
				// if not
				else begin
					rst_mo = 1'b0;
				end
			
				// final set with oneSecStrb
				rst_mo = (rst_mo & oneSecStrb) | rst;
			end
			// set ce for min_one
			always @* begin
				// check if xx:59
				if (di_Stens == 4'b0101) begin
					ce_st = 1'b1;
				end
				// if not
				else begin
					ce_st = 1'b0;
				end
			
				// final set ce
				//ce_mo = (ce_st & ce_so & oneSecStrb) | dicLdMones;
			end
			// call function to increment
			countrce c3( .q(di_Mones), .d(bu_rx_data[3:0]), .ld(dicLdMones), .ce((ce_st & ce_so & oneSecStrb) | dicLdMones), .rst(rst_mo), .clk(clk) );
			
			
			// set reset for min_ten
			always @* begin
				// check if 59:59
				if ((di_Sones == 4'b1001) & (di_Stens == 4'b0101) & (di_Mones == 4'b1001) & (di_Mtens == 4'b0101)) begin
					rst_mt = 1'b1;
				end
				// if not
				else begin
					rst_mt = 1'b0;
				end
			
				// final set rst
				rst_mt = (rst_mt & oneSecStrb) | rst;
			end
			// set ce
			always @* begin
				if (di_Mones == 4'b1001) begin
					ce_mo = 1'b1;
				end
				else begin
					ce_mo = 1'b0;
				end
			
				// final set ce
				// ce_mt = (ce_mo & ce_st & ce_so & oneSecStrb)| dicLdMtens;
			end
			// call function to increment
			countrce c4( .q(di_Mtens), .d(bu_rx_data[3:0]), .ld(dicLdMtens), .ce((ce_mo & ce_st & ce_so & oneSecStrb)| dicLdMtens), .rst(rst_mt), .clk(clk) );
		 
		 
		 //-----------
		 
		 
		 regrce r1( .q(di_ASones), .d(bu_rx_data[3:0]), .ce(oneSecStrb & dicLdASones), .rst(rst), .clk(clk));
		 regrce r2( .q(di_AStens), .d(bu_rx_data[3:0]), .ce(oneSecStrb & dicLdAStens), .rst(rst), .clk(clk));
		 regrce r3( .q(di_AMones), .d(bu_rx_data[3:0]), .ce(oneSecStrb & dicLdAMones), .rst(rst), .clk(clk));
		 regrce r4( .q(di_AMtens), .d(bu_rx_data[3:0]), .ce(oneSecStrb & dicLdAMtens), .rst(rst), .clk(clk));
		 
		 assign did_alarmMatch = ((di_ASones == di_Sones) & (di_AStens == di_Stens)
		 						 & (di_AMones == di_Mones) & (di_AMtens == di_Mtens));
		 
		 
		 
endmodule




//
//
// sample interface for clock control
//
module dictrl(
	      output reg dicLdMtens, // load the 10's minutes
	      output reg dicLdMones, // load the 1's minutes
	      output reg dicLdStens, // load the 10's seconds
	      output reg dicLdSones, // load the 1's seconds
	      output reg dicLdAMtens, // load the alarm 10's minutes
	      output reg dicLdAMones, // load the alarm 1's minutes
	      output reg dicLdAStens, // load the alarm 10's seconds
	      output reg dicLdASones, // load the alarm 1's seconds
	      output reg dicRun, // clock should run

	      output reg dicAlarmIdle, // alarm is off
	      output reg dicAlarmArmed, // alarm is armed
	      output reg dicAlarmTrig, // alarm is triggered

	      input       did_alarmMatch, // raw alarm match

              input 	  bu_rx_data_rdy, // new data from uart rdy
              input [7:0] bu_rx_data, // new data from uart
              input 	  rst,
	      input 	  clk
	      );
	      
	      wire de_esc, de_num, de_num0to5, de_cr, de_atSign, de_littleA, de_littleL, de_littleN;
	      decodeKeys dk(de_esc, de_num, de_num0to5, de_cr, de_atSign, de_littleA, de_littleL, de_littleN, bu_rx_data, bu_rx_data_rdy);
	      
   		  parameter size1 = 3;
   		  parameter off = 3'b001, armed = 3'b010, triggered = 3'b100;
   		  
   		  reg [size1-1:0] state1;
   		  reg [size1-1:0] next_state1;
   		  
   		  always @ (state1 or de_atSign or did_alarmMatch)
   		  begin : FSM_COMBO1
   		  	next_state1 = 3'b000;
   		  	case(state1)
   		  		off:
   		  			if (de_atSign == 1'b1) begin
   		  				next_state1 = armed;
   		  			end else begin 
   		  			 	next_state1 = off;
   		  			end
   		  		armed: 
   		  			if (de_atSign == 1'b1) begin
   		  				next_state1 = off;
   		  			end else if (did_alarmMatch == 1'b1) begin
   		  				next_state1 = triggered;
   		  			end else begin
   		  				next_state1 = armed;
   		  			end
   		  		triggered:
   		  			if (de_atSign == 1'b1) begin
   		  				next_state1 = off;
   		  			end else begin
   		  				next_state1 = triggered;
   		  			end 
   		  		default: next_state1 = off;
   		  	endcase
   		  end
   		  
   		  always @ (posedge clk)
   		  begin : FSM_SEQ1
   		  	if (rst == 1'b1) begin 
   		  		state1 <= #1 off;
   		  	end else begin
   		  		state1 <= #1 next_state1;
   		  	end
   		  end
   		  
   		  always @ (posedge clk)
   		  begin : OUTPUT_LOGIC1
   		  	if (rst == 1'b1) begin
   		  		dicAlarmArmed = 1'b0;
   		  		dicAlarmIdle = 1'b1;
   		  		dicAlarmTrig = 1'b0;
   		  	end else begin 
   		  		case(state1)
   		  			off: 
   		  				begin
   		  					dicAlarmArmed = #1 1'b0;
   		  					dicAlarmIdle = #1 1'b1;
   		  					dicAlarmTrig = #1 1'b0;
   		  				end
   		  			armed:
   		  				begin
   		  					dicAlarmArmed = #1 1'b1;
   		  					dicAlarmIdle = #1 1'b0;
   		  					dicAlarmTrig = #1 1'b0;
   		  				end
   		  			triggered:
   		  				begin
   		  					dicAlarmArmed = #1 1'b0;
   		  					dicAlarmIdle = #1 1'b0;
   		  					dicAlarmTrig = #1 1'b1;
   		  				end
   		  			default:
   		  				begin
   		  					dicAlarmArmed = #1 1'b0;
   		  					dicAlarmIdle = #1 1'b1;
   		  					dicAlarmTrig = #1 1'b0;
   		  				end
   		  		endcase
   		  	end
   		  end 
   		  
   		  parameter size2 = 11;
   		  parameter start = 11'b00000000001, loadT = 11'b00000000010, loadA = 11'b00000000100,
   		  			TMtens = 11'b00000001000, TMones = 11'b00000010000, TStens = 11'b00000100000, TSones = 11'b00001000000,
   		  			AMtens = 11'b00010000000, AMones = 11'b00100000000, AStens = 11'b01000000000, ASones = 11'b10000000000;
   		  
   		  reg [size2-1:0] state2;
   		  reg [size2-1:0] next_state2;
   		  
   		  always @ (state2 or de_num or de_num0to5 or de_cr or de_littleA or de_littleL)
   		  begin : FSM_COMBO2
   		  	next_state2 = 11'b00000000000;
   		  	case(state2)
   		  		start:
   		  			if (de_littleL == 1'b1) begin
   		  				next_state2 = loadT;
   		  			end else if (de_littleA == 1'b1) begin
   		  				next_state2 = loadA;
   		  			end else begin
   		  				next_state2 = start;
   		  			end
				loadT:
					if (de_num0to5 == 1'b1) begin
   		  				next_state2 = TMtens;
   		  			end else begin
   		  				next_state2 = loadT;
   		  			end
				loadA:
					if (de_num0to5 == 1'b1) begin
   		  				next_state2 = AMtens;
   		  			end else begin
   		  				next_state2 = loadA;
   		  			end
				TMtens:
					if (de_num == 1'b1) begin
   		  				next_state2 = TMones;
   		  			end else begin
   		  				next_state2 = TMtens;
   		  			end
				TMones:
					if (de_num0to5 == 1'b1) begin
   		  				next_state2 = TStens;
   		  			end else begin
   		  				next_state2 = TMones;
   		  			end
				TStens:
					if (de_num == 1'b1) begin
   		  				next_state2 = TSones;
   		  			end else begin
   		  				next_state2 = TStens;
   		  			end
				TSones:
					if (de_cr == 1'b1) begin
   		  				next_state2 = start;
   		  			end else begin
   		  				next_state2 = TSones;
   		  			end
				AMtens:
					if (de_num == 1'b1) begin
   		  				next_state2 = AMones;
   		  			end else begin
   		  				next_state2 = AMtens;
   		  			end
				AMones:
					if (de_num0to5 == 1'b1) begin
   		  				next_state2 = AStens;
   		  			end else begin
   		  				next_state2 = AMones;
   		  			end
				AStens:
					if (de_num == 1'b1) begin
   		  				next_state2 = ASones;
   		  			end else begin
   		  				next_state2 = AStens;
   		  			end
				ASones:
					if (de_cr == 1'b1) begin
   		  				next_state2 = start;
   		  			end else begin
   		  				next_state2 = ASones;
   		  			end
   		  		default: next_state2 = start;
   		  	endcase
   		  end
   		  
   		  always @ (posedge clk)
   		  begin : FSM_SEQ2
   		  	if (rst == 1'b1) begin 
   		  		state2 <= start;
   		  	end else begin
   		  		state2 <= next_state2;
   		  	end
   		  end
   		  
   		  always @ (posedge clk)
   		  begin : OUTPUT_LOGIC2
   		  	if (rst == 1'b1) begin
   		  		dicLdMtens <= 1'b0;
	      	    dicLdMones <= 1'b0;
	       	  	dicLdStens <= 1'b0;
	       	  	dicLdSones <= 1'b0;
	       	  	dicLdAMtens <= 1'b0;
	       	  	dicLdAMones <= 1'b0;
	       	  	dicLdAStens <= 1'b0;
	       	  	dicLdASones <= 1'b0;
	       	  	dicRun <= 1'b1;
   		  	end else begin 
   		  		case(state2)
   		  			start:
   		  				begin 
   		  					dicLdMtens <= #1 1'b0;
	      	    			dicLdMones <= #1 1'b0; 
	       	  				dicLdStens <= #1 1'b0;
	       	 			 	dicLdSones <= #1 1'b0;
	       	 			 	dicLdAMtens <= #1 1'b0;
	       	 			 	dicLdAMones <= #1 1'b0;
	       	 			 	dicLdAStens <= #1 1'b0;
	       	  				dicLdASones <= #1 1'b0;
	       	 			 	dicRun <= #1 1'b1;
	       	 			end
					loadT:
						begin 
   		  					dicLdMtens <= #1 1'b0;
	      	    			dicLdMones <= #1 1'b0;
	       	  				dicLdStens <= #1 1'b0;
	       	 			 	dicLdSones <= #1 1'b0;
	       	 			 	dicLdAMtens <= #1 1'b0;
	       	 			 	dicLdAMones <= #1 1'b0;
	       	 			 	dicLdAStens <= #1 1'b0;
	       	  				dicLdASones <= #1 1'b0;
	       	 			 	dicRun <= #1 1'b0;
	       	 			end
					loadA:
						begin 
   		  					dicLdMtens <= #1 1'b0;
	      	    			dicLdMones <= #1 1'b0;
	       	  				dicLdStens <= #1 1'b0;
	       	 			 	dicLdSones <= #1 1'b0;
	       	 			 	dicLdAMtens <= #1 1'b0;
	       	 			 	dicLdAMones <= #1 1'b0;
	       	 			 	dicLdAStens <= #1 1'b0;
	       	  				dicLdASones <= #1 1'b0;
	       	 			 	dicRun <= #1 1'b1;
	       	 			end
					TMtens:
						begin 
   		  					dicLdMtens <= #1 1'b1;
	      	    			dicLdMones <= #1 1'b0;
	       	  				dicLdStens <= #1 1'b0;
	       	 			 	dicLdSones <= #1 1'b0;
	       	 			 	dicLdAMtens <= #1 1'b0;
	       	 			 	dicLdAMones <= #1 1'b0;
	       	 			 	dicLdAStens <= #1 1'b0;
	       	  				dicLdASones <= #1 1'b0;
	       	 			 	dicRun <= #1 1'b0;
	       	 			end
					TMones:
						begin 
   		  					dicLdMtens <= #1 1'b0;
	      	    			dicLdMones <= #1 1'b1;
	       	  				dicLdStens <= #1 1'b0;
	       	 			 	dicLdSones <= #1 1'b0;
	       	 			 	dicLdAMtens <= #1 1'b0;
	       	 			 	dicLdAMones <= #1 1'b0;
	       	 			 	dicLdAStens <= #1 1'b0;
	       	  				dicLdASones <= #1 1'b0;
	       	 			 	dicRun <= #1 1'b0;
	       	 			end
					TStens:
						begin 
   		  					dicLdMtens <= #1 1'b0;
	      	    			dicLdMones <= #1 1'b0;
	       	  				dicLdStens <= #1 1'b1;
	       	 			 	dicLdSones <= #1 1'b0;
	       	 			 	dicLdAMtens <= #1 1'b0;
	       	 			 	dicLdAMones <= #1 1'b0;
	       	 			 	dicLdAStens <= #1 1'b0;
	       	  				dicLdASones <= #1 1'b0;
	       	 			 	dicRun <= #1 1'b0;
	       	 			end
					TSones:
						begin 
   		  					dicLdMtens <= 1'b0;
	      	    			dicLdMones <= 1'b0;
	       	  				dicLdStens <= 1'b0;
	       	 			 	dicLdSones <= 1'b1;
	       	 			 	dicLdAMtens <= 1'b0;
	       	 			 	dicLdAMones <= 1'b0;
	       	 			 	dicLdAStens <= 1'b0;
	       	  				dicLdASones <= 1'b0;
	       	 			 	dicRun <= 1'b0;
	       	 			end
					AMtens:
						begin 
   		  					dicLdMtens <= #1 1'b0;
	      	    			dicLdMones <= #1 1'b0;
	       	  				dicLdStens <= #1 1'b0;
	       	 			 	dicLdSones <= #1 1'b0;
	       	 			 	dicLdAMtens <= #1 1'b1;
	       	 			 	dicLdAMones <= #1 1'b0;
	       	 			 	dicLdAStens <= #1 1'b0;
	       	  				dicLdASones <= #1 1'b0;
	       	 			 	dicRun <= #1 1'b1;
	       	 			end
					AMones:
						begin 
   		  					dicLdMtens <= #1 1'b0;
	      	    			dicLdMones <= #1 1'b0;
	       	  				dicLdStens <= #1 1'b0;
	       	 			 	dicLdSones <= #1 1'b0;
	       	 			 	dicLdAMtens <= #1 1'b0;
	       	 			 	dicLdAMones <= #1 1'b1;
	       	 			 	dicLdAStens <= #1 1'b0;
	       	  				dicLdASones <= #1 1'b0;
	       	 			 	dicRun <= #1 1'b1;
	       	 			end
					AStens:
						begin 
   		  					dicLdMtens <= #1 1'b0;
	      	    			dicLdMones <= #1 1'b0;
	       	  				dicLdStens <= #1 1'b0;
	       	 			 	dicLdSones <= #1 1'b0;
	       	 			 	dicLdAMtens <= #1 1'b0;
	       	 			 	dicLdAMones <= #1 1'b0;
	       	 			 	dicLdAStens <= #1 1'b1;
	       	  				dicLdASones <= #1 1'b0;
	       	 			 	dicRun <= #1 1'b1;
	       	 			end
					ASones:
						begin 
   		  					dicLdMtens <= #1 1'b0;
	      	    			dicLdMones <= #1 1'b0;
	       	  				dicLdStens <= #1 1'b0;
	       	 			 	dicLdSones <= #1 1'b0;
	       	 			 	dicLdAMtens <= #1 1'b0;
	       	 			 	dicLdAMones <= #1 1'b0;
	       	 			 	dicLdAStens <= #1 1'b0;
	       	  				dicLdASones <= #1 1'b1;
	       	 			 	dicRun <= #1 1'b1;
	       	 			end
   		  			default:
   		  				begin 
   		  					dicLdMtens <= #1 1'b0;
	      	    			dicLdMones <= #1 1'b0; 
	       	  				dicLdStens <= #1 1'b0;
	       	 			 	dicLdSones <= #1 1'b0;
	       	 			 	dicLdAMtens <= #1 1'b0;
	       	 			 	dicLdAMones <= #1 1'b0;
	       	 			 	dicLdAStens <= #1 1'b0;
	       	  				dicLdASones <= #1 1'b0;
	       	 			 	dicRun <= #1 1'b1;
	       	 			end
   		  		endcase
   		  	end
   		  end 
   		  
endmodule

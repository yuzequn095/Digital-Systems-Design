// Author: Zequn Yu
// PID: A14712777
// Github: yuzequn095
// --------------------------------------------------------------------
// >>>>>>>>>>>>>>>>>>>>>>>>> COPYRIGHT NOTICE <<<<<<<<<<<<<<<<<<<<<<<<<
// --------------------------------------------------------------------
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
module Lab2_140L (
 input wire Gl_rst,                  // reset signal (active high)
 input wire clk,                     // global clock
 input wire Gl_adder_start,          // r1, r2, OP are ready  
 input wire Gl_subtract,             // subtract (active high)
 input wire [7:0] Gl_r1           , // 8bit number 1
 input wire [7:0] Gl_r2           , // 8bit number 1
 output wire [7:0] L2_adder_data   ,   // 8 bit ascii sum
 output wire L2_adder_rdy          , //pulse
 output wire [7:0] L2_led
);

// call fullAdder
//wire c_out;
wire [4:0] sum_out;
fullAdder f1(Gl_r1, Gl_r2, L2_adder_data[3:0], sum_out, Gl_subtract);

// set led
reg [3:0] left_most;
always @* begin
	// check flip
	// if sub
	if(Gl_subtract == 1) begin 
		// then flip 
		if(sum_out[4] == 0) begin
			left_most[3:0] <= {4'b0101};
			//L2_adder_data[7:4] <= left_most[3:0]; error
		end
		else begin
			left_most[3:0] <= {4'b0011};
			//L2_adder_data[7:4] <= left_most[3:0];
		end
	end
	// if add
	else begin
		// don't flip
		if(sum_out[4] == 0) begin
			left_most[3:0] <= {4'b0011};
			//L2_adder_data[7:4] <= left_most[3:0];
		end
		else begin
			left_most[3:0] <= {4'b0101};
			//L2_adder_data[7:4] <= left_most[3:0];
		end
	end
end

// set value
assign L2_adder_data[7:4] = left_most[3:0];
// led only care right most 5 bits
// set led value, error case: 3-2
wire if_flip = sum_out[4]^Gl_subtract;
assign L2_led[7:0] = {3'b000, if_flip, L2_adder_data[3:0]};

// call sigDelay
sigDelay s1(L2_adder_rdy, Gl_adder_start, clk, Gl_rst);

endmodule


// function to calculate each bit
module bitAdder(input bit_a, input bit_b, input c_in, output c_out, output sum);
		  assign sum = bit_a ^ bit_b ^ c_in;
		  assign c_out = (bit_a & bit_b) | c_in & (bit_a ^ bit_b);
endmodule

// function to calculate the whole full adder
module fullAdder(input [3:0] Gl_r1, input [3:0] Gl_r2, output [3:0] L2_adder_data, output [4:0]sum_out, input Gl_subtract);
		  // set each cout
		  wire co0;
		  wire co1;
		  wire co2;
		  
		  // set sum
		  wire s0;
		  wire s1;
		  wire s2;
		  wire s3;
		  
		  // set c_out
		  wire c_out;
		  // set tmp Gl_r
		  //wire Gl_r; //error: mul use constant
		  
		  // convert neg if need (xor)
		  // and call bit operation
		  // set sum_out as well
		  xor(s0, Gl_subtract, Gl_r2[0]);
		  bitAdder b1( Gl_r1[0], s0, Gl_subtract, co0, L2_adder_data[0] );
		  assign sum_out[0] = L2_adder_data[0];
		  //xor(Gl_r, Gl_subtract, Gl_r2[0]);
		  //bitAdder b1( Gl_r1[0], Gl_r, Gl_subtract, co0, L2_adder_data[0] );
		  xor(s1, Gl_subtract, Gl_r2[1]);
		  bitAdder b2( Gl_r1[1], s1, co0, co1, L2_adder_data[1] );
		  assign sum_out[1] = L2_adder_data[1];
		  //xor(Gl_r, Gl_subtract, Gl_r2[1]);
		  //bitAdder b2( Gl_r1[1], Gl_r, co0, co1, L2_adder_data[1] );		  
		  xor(s2, Gl_subtract, Gl_r2[2]);
		  bitAdder b3( Gl_r1[2], s2, co1, co2, L2_adder_data[2] );
		  assign sum_out[2] = L2_adder_data[2];
		  //xor(Gl_r, Gl_subtract, Gl_r2[2]);
		  //bitAdder b3( Gl_r1[2], Gl_r, co1, co2, L2_adder_data[2] );
		  xor(s3, Gl_subtract, Gl_r2[3]);
		  bitAdder b4( Gl_r1[3], s3, co2, c_out, L2_adder_data[3] );
		  assign sum_out[3] = L2_adder_data[3];
		  assign sum_out[4] = c_out;
		  //xor(Gl_r, Gl_subtract, Gl_r2[3]);
		  //bitAdder b4( Gl_r1[3], Gl_r, co2, c_out, L2_adder_data[3] );
		  
endmodule
		  
module sigDelay(
		  output      sigOut,
		  input       sigIn,
		  input       clk,
		  input       rst);

   parameter delayVal = 4;
   reg [15:0] 		      delayReg;


   always @(posedge clk) begin
      if (rst)
	delayReg <= 16'b0;
      else begin
	 delayReg <= {delayReg[14:0], sigIn};
      end
   end

   assign sigOut = delayReg[delayVal];
endmodule // sigDelay



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
// -------------------------------------------------------------------- //           
//                     Lih-Feng Tsaur
//                     Bryan Chin
//                     UCSD CSE Department
//                     9500 Gilman Dr, La Jolla, CA 92093
//                     U.S.A
//
// --------------------------------------------------------------------
//
//
//  decodeKeys
//
// decode the 8 bit ascii input charData when
// charDataValid is asserted.
// specifically, we decode
//   'ESC' - escape key
//   '0-9'
//   '0-5'
//   'CR' - carriage return
//   '@'
//   'a'
//   'l' - lowercase L
//   'n'
//
module decodeKeys(
		  output      de_esc,
		  output      de_num,
		  output      de_num0to5, 
		  output      de_cr,
		  output      de_atSign,
		  output      de_littleA,
		  output      de_littleL,
		  output      de_littleN,
		  input [7:0] charData,
		  input       charDataValid
		  );


   wire 		      is_b0_1 = charData[0];
   wire 		      is_b1_1 = charData[1];
   wire 		      is_b2_1 = charData[2];
   wire 		      is_b3_1 = charData[3];
   wire 		      is_b4_1 = charData[4];
   wire 		      is_b5_1 = charData[5];
   wire 		      is_b6_1 = charData[6];
   wire 		      is_b7_1 = charData[7];
   wire 		      is_b0_0 = ~charData[0];
   wire 		      is_b1_0 = ~charData[1];
   wire 		      is_b2_0 = ~charData[2];
   wire 		      is_b3_0 = ~charData[3];
   wire 		      is_b4_0 = ~charData[4];
   wire 		      is_b5_0 = ~charData[5];
   wire 		      is_b6_0 = ~charData[6];
   wire 		      is_b7_0 = ~charData[7];
   

   // esc - 1b
   assign de_esc = &{is_b7_0, is_b6_0, is_b5_0, is_b4_1,
                     is_b3_1, is_b2_0, is_b1_1, is_b0_1} & charDataValid;

   // 0-5
   assign de_num0to5 = &{is_b7_0, is_b6_0, is_b5_1, is_b4_1} &
		      (&{is_b3_0, is_b2_0} |   // 0, 1, 2, 3
		       &{is_b3_0, is_b2_1, is_b1_0}) & // 4, 5
		      charDataValid;
   
   // 0-9
   assign de_num = &{is_b7_0, is_b6_0 , is_b5_1, is_b4_1} & 
		   (is_b3_0 |   // 0-7
		    &{is_b3_1, is_b2_0, is_b1_0}) & // 8,9
		   charDataValid;      

   assign de_cr = &{is_b7_0, is_b6_0, is_b5_0, is_b4_0, is_b3_1, is_b2_1, is_b1_0, is_b0_1} & 
		  charDataValid;

   // "a" = 61
   assign de_littleA = &{is_b7_0, is_b6_1, is_b5_1, is_b4_0, is_b3_0, is_b2_0, is_b1_0, is_b0_1} & 
		    charDataValid;
   // "l" = 6C
   assign de_littleL = &{is_b7_0, is_b6_1, is_b5_1, is_b4_0, is_b3_1, is_b2_1, is_b1_0, is_b0_0} & 
		    charDataValid;

   // "n" = 6E
   assign de_littleN = &{is_b7_0, is_b6_1, is_b5_1, is_b4_0, is_b3_1, is_b2_1, is_b1_1, is_b0_0} & 
		    charDataValid;

   // "@" = 40
   assign de_atSign = &{is_b7_0, is_b6_1, is_b5_0, is_b4_0, is_b3_0, is_b2_0, is_b1_0, is_b0_0} & 
		    charDataValid;
   
endmodule

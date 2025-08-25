`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.03.2025 15:29:59
// Design Name: 
// Module Name: top_level_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module top_level_tb
    import ascon_pack::*;
(

    );
    logic clock_s=1'b0;
	logic resetb_s;
	logic go_s;
	logic [127:0] key_s;
    logic [127:0] nonce_s;
	logic [63 : 0] cipher_s;
	logic cipher_valid_s;
	logic [127 : 0] tag_s;
	
	top_level DUT (
	       .clock_i(clock_s),
	       .resetb_i(resetb_s),
	       .go_i(go_s),
	       .key_i(key_s),
	       .nonce_i(nonce_s),
	       .cipher_o(cipher_s),
	       .cipher_valid_o(cipher_valid_s),
	       .tag_o(tag_s)
);

    always begin 				//generation de la clock
		assign clock_s=~clock_s;
		#10;
	end
	
	
	initial begin 
		key_s=128'h8A55114D1CB6A9A2BE263D4D7AECAAFF;
		nonce_s=128'h4ED0EC0B98C529B7C8CDDF37BCD0284A;
		go_s=1'b0;
		resetb_s=1'b0;
		#20;
		resetb_s=1'b1;
		#20;
		go_s=1'b1;
		#40;
		go_s=1'b0;
		#10000;
		
		#100;
	end
endmodule : top_level_tb






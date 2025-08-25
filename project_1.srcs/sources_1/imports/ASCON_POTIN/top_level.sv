`timescale 1ns / 1ps

module top_level
	import ascon_pack::*;
(
	input logic clock_i,		
	input logic resetb_i,
	input logic go_i,
	input  logic [127:0] key_i,
    input  logic [127:0] nonce_i,
    input logic [63:0] data_i,
    input logic [63:0] data_associate_i,
    output logic init_o,
	output logic [63 : 0] cipher_o,
	output logic cipher_valid_o,
	output logic [127 : 0] tag_o,
	output logic [4:0] cpt_block_o,
	output logic en_ascon_reg_o,
	output logic end_tag_o
);

    logic reset_s;
	logic end_associate_s, end_cipher_s, end_tag_s, end_initialisation_s;
	logic associate_data_s, en_cpt_b_s, init_a_cpt_s, init_s, finalisation_s, data_valid_s;
	logic [4:0] cpt_block_s;
	logic [63:0] data_s;
	logic en_ascon_reg_s;
	logic [127 : 0] tag_s;
	

	fsm_ASCON fsm2 (						//instanciation de la fsm
		.clock_i(clock_i),
		.resetb_i(resetb_i),
		.go_i(go_i),
		.end_associate_i(end_associate_s),
		.end_cipher_i(end_cipher_s),
		.end_tag_i(end_tag_s),
		.end_initialisation_i(end_initialisation_s),
		.cpt_block_i(cpt_block_s),
		.ascon_data_i(data_i),
		.data_associate_i(data_associate_i),
		.data_valid_o(data_valid_s),
		.data_o(data_s),
		.associate_data_o(associate_data_s),
		.en_cpt_b_o(en_cpt_b_s),
		.init_a_cpt_o(init_a_cpt_s),
		.init_o(init_s),
		.finalisation_o(finalisation_s),
		.en_ascon_reg_o(en_ascon_reg_s)
);

assign en_ascon_reg_o = en_ascon_reg_s;

assign init_o = init_s;

	compteur_simple_init compteur1 (
		.clock_i(clock_i),
		.resetb_i(resetb_i),
		.en_i(en_cpt_b_s),
		.init_a_i(init_a_cpt_s),
		.cpt_o(cpt_block_s)
);  


    assign cpt_block_o=cpt_block_s;
    
    
    assign reset_s = ~resetb_i;
	ascon ASCON1 (
		.clock_i(clock_i),
		.reset_i(reset_s),
		.init_i(init_s),
		.associate_data_i(associate_data_s),
		.finalisation_i(finalisation_s),
		.data_i(data_s),
		.data_valid_i(data_valid_s),
		.key_i(key_i),
		.nonce_i(nonce_i),
		.end_associate_o(end_associate_s),
		.cipher_o(cipher_o),
		.cipher_valid_o(cipher_valid_o),
		.tag_o(tag_s),
		.end_tag_o(end_tag_s),
		.end_initialisation_o(end_initialisation_s),
		.end_cipher_o(end_cipher_s)
);

assign tag_o = tag_s;
assign end_tag_o = end_tag_s;

ila_TOP toop_0 (
	.clk(clock_i), // input wire clk


	.probe0(go_i), // input wire [0:0]  probe0  
	.probe1(key_i), // input wire [127:0]  probe1 
	.probe2(nonce_i), // input wire [127:0]  probe2 
	.probe3(data_i), // input wire [63:0]  probe3 
	.probe4(data_associate_i), // input wire [63:0]  probe4 
	.probe5(init_o), // input wire [0:0]  probe5 
	.probe6(cipher_o), // input wire [63:0]  probe6 
	.probe7(vipher_valid_o), // input wire [0:0]  probe7 
	.probe8(tag_o), // input wire [127:0]  probe8 
	.probe9(cpt_block_o), // input wire [4:0]  probe9 
	.probe10(en_ascon_reg_o), // input wire [0:0]  probe10 
	.probe11(end_tag_o) // input wire [0:0]  probe11
);
endmodule : top_level
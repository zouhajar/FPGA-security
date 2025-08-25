`timescale 1ns / 1ps

module fsm_ASCON
	import ascon_pack::*;			//importation du package du projet
(
	input  logic       clock_i,
    input  logic       resetb_i,
    input logic go_i,
	input logic end_associate_i,
	input logic end_cipher_i,
	input logic end_tag_i,
	input logic end_initialisation_i,
	input logic [4:0] cpt_block_i,
	input logic [63:0] ascon_data_i,
	input logic [63:0] data_associate_i,
	output logic [63:0] data_o,
	output logic data_valid_o,
	output logic associate_data_o,
	output logic en_cpt_b_o,
	output logic init_a_cpt_o,
	output logic init_o,
	output logic finalisation_o,
	output logic en_ascon_reg_o
);
    //logic [63:0] ascon_data_s;
    //logic [1471:0] ecg_s=1472'h5A5B5B5A5A5A5A5A59554E4A4C4F545553515354565758575A5A595756595B5A5554545252504F4F4C4C4D4D4A49444447474644424341403B36383E4449494747464644434243454745444546474A494745484F58697C92AECEEDFFFFE3B47C471600041729363C3F3E40414141403F3F403F3E3B3A3B3E3D3E3C393C41464646454447464A4C4F4C505555524F5155595C5A595A5C5C5B5959575351504F4F53575A5C5A5B5D5E6060615F605F5E5A5857545252800000;
	typedef enum {idle, init, conf_da, da, conf_cipher, cipher, end_cipher, finalisation, idle_tag, end_state} state_t;
	
	state_t current_state, next_state;
	//logic [4:0] num_block_s=4'b00000;

	//squential process modeling the state register
	always_ff @(posedge clock_i or negedge resetb_i) begin: seq_0
		if(resetb_i ==1'b0)
			current_state <= idle;
		else
			current_state <= next_state;
	end : seq_0

    /*always_comb begin : mux_data
        case (cpt_block_i)
        0: ascon_data_s = ecg_s[1471:1471-63];
        1: ascon_data_s = ecg_s[1471-64:1471-64-63];
        2: ascon_data_s = ecg_s[1471-2*64:1471-2*64-63];
        3: ascon_data_s = ecg_s[1471-3*64:1471-3*64-63];
        4: ascon_data_s = ecg_s[1471-4*64:1471-4*64-63];
        5: ascon_data_s = ecg_s[1471-5*64:1471-5*64-63];
        6: ascon_data_s = ecg_s[1471-6*64:1471-6*64-63];
        7: ascon_data_s = ecg_s[1471-7*64:1471-7*64-63];
        8: ascon_data_s = ecg_s[1471-8*64:1471-8*64-63];
        9: ascon_data_s = ecg_s[1471-9*64:1471-9*64-63];
        10: ascon_data_s = ecg_s[1471-10*64:1471-10*64-63];
        11: ascon_data_s = ecg_s[1471-11*64:1471-11*64-63];
        12: ascon_data_s = ecg_s[1471-12*64:1471-12*64-63];
        13: ascon_data_s = ecg_s[1471-13*64:1471-13*64-63];
        14: ascon_data_s = ecg_s[1471-14*64:1471-14*64-63];
        15: ascon_data_s = ecg_s[1471-15*64:1471-15*64-63];
        16: ascon_data_s = ecg_s[1471-16*64:1471-16*64-63];
        17: ascon_data_s = ecg_s[1471-17*64:1471-17*64-63];
        18: ascon_data_s = ecg_s[1471-18*64:1471-18*64-63];
        19: ascon_data_s = ecg_s[1471-19*64:1471-19*64-63];
        20: ascon_data_s = ecg_s[1471-20*64:1471-20*64-63];
        21: ascon_data_s = ecg_s[1471-21*64:1471-21*64-63];
        22: ascon_data_s = ecg_s[1471-22*64:1471-22*64-63];
        endcase
    end : mux_data*/
    
	//first combinatianl process for transitions
	always_comb begin : comb_0
		case(current_state)
		    idle:
		        if(go_i == 1'b1)
					next_state=init;
				else
					next_state=idle;
			init:						//la transistion de idle a conf_init est permise quand start_i=1
				if(end_initialisation_i == 1'b0)
					next_state=init;
				else
					next_state=conf_da;

			conf_da:
				next_state=da;
			da:
				if(end_associate_i == 1'b0)
					next_state=da;
				else
					next_state=conf_cipher;
			conf_cipher:
					next_state=cipher;
			cipher:
				if(end_cipher_i == 1'b0)
					next_state=cipher;
				else
					next_state=end_cipher;
			end_cipher:
				if(cpt_block_i >= 5'b10101)
					next_state=finalisation;
				else
					next_state=conf_cipher;
			finalisation:
				next_state=idle_tag;
			idle_tag:
				if(end_tag_i == 1'b0)
					next_state=idle_tag;
				else
					next_state=end_state;
			end_state:
				next_state=idle;
		endcase
	end : comb_0

	always_comb begin : comb_1
		data_valid_o=1'b0;
		data_o=64'h00000000;
		associate_data_o=1'b0;
		en_cpt_b_o=1'b0;
		init_a_cpt_o=1'b0;
		init_o=1'b0;
		finalisation_o=1'b0;
		en_ascon_reg_o=1'b0;
		case(current_state)
		    idle:
		       begin
		       data_valid_o=1'b0;
		       data_o=64'h00000000;
		       associate_data_o=1'b0;
		       en_cpt_b_o=1'b1;
		       init_a_cpt_o=1'b1;
		       init_o=1'b0;
		       finalisation_o=1'b0;
		       en_ascon_reg_o=1'b0;
		       end
			init:
				begin
				data_valid_o=1'b0;
				data_o=64'h00000000;
				associate_data_o=1'b0;
				en_cpt_b_o=1'b0;
				init_a_cpt_o=1'b0;
				init_o=1'b1;
				finalisation_o=1'b0;
				en_ascon_reg_o=1'b0;
				end
			conf_da:
				begin
				data_valid_o=1'b1;
				data_o=data_associate_i;
				associate_data_o=1'b1;
				en_cpt_b_o=1'b0;
				init_a_cpt_o=1'b0;
				init_o=1'b0;
				finalisation_o=1'b0;
				en_ascon_reg_o=1'b0;
				end
			da:
				begin
				data_valid_o=1'b0;
				data_o=data_associate_i;
				associate_data_o=1'b1;
				en_cpt_b_o=1'b0;
				init_a_cpt_o=1'b0;
				init_o=1'b0;
				finalisation_o=1'b0;
				en_ascon_reg_o=1'b0;
				end
		    
			conf_cipher:
				begin
				data_valid_o=1'b1;
				data_o=ascon_data_i;
				associate_data_o=1'b0;
				en_cpt_b_o=1'b0;
				init_a_cpt_o=1'b0;
				init_o=1'b0;
				finalisation_o=1'b0;
				en_ascon_reg_o=1'b0;
				end
			cipher:
				begin
				data_valid_o=1'b0;
				data_o=ascon_data_i;
				associate_data_o=1'b0;
				en_cpt_b_o=1'b0;
				init_a_cpt_o=1'b0;
				init_o=1'b0;
				finalisation_o=1'b0;
				en_ascon_reg_o=1'b0;
				end
			end_cipher:
				begin
				data_valid_o=1'b0;
				data_o=ascon_data_i;
				associate_data_o=1'b0;
				en_cpt_b_o=1'b1;
				init_a_cpt_o=1'b0;
				init_o=1'b0;
				finalisation_o=1'b0;
				en_ascon_reg_o=1'b1;
				end
			finalisation:
				begin
				data_valid_o=1'b1;
				data_o=ascon_data_i;
				associate_data_o=1'b0;
				en_cpt_b_o=1'b0;
				init_a_cpt_o=1'b0;
				init_o=1'b0;
				finalisation_o=1'b1;
				en_ascon_reg_o=1'b0;
				end
			idle_tag:
				begin
				data_valid_o=1'b0;
				data_o=ascon_data_i;
				associate_data_o=1'b0;
				en_cpt_b_o=1'b0;
				init_a_cpt_o=1'b0;
				init_o=1'b0;
				finalisation_o=1'b1;
				en_ascon_reg_o=1'b0;
				end
			end_state:
				begin
				data_valid_o=1'b0;
				data_o=ascon_data_i;
				associate_data_o=1'b0;
				en_cpt_b_o=1'b0;
				init_a_cpt_o=1'b0;
				init_o=1'b0;
				finalisation_o=1'b0;
				en_ascon_reg_o=1'b1;
				end
		endcase
	end: comb_1
endmodule : fsm_ASCON
























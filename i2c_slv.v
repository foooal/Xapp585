`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
module i2c_slv
	(
	input clk,
	input scl_in,
	input sda_in,
	output reg sda_out,

//	input [15:0] step_cnt,
    output     reg [28:0] cnt_r,
	
	output reg        erase_sof_en,
	output reg        rectify_en,
	input      [15:0] zero_value,
	
	output reg  		mf_cw,            //
	output reg  		mf_anti_cw,
	output reg  		mf_end,
	
	input             manu_focus_en,
	output reg        manu_focus_en_s,   //
	
	//
	output reg[7:0]        data_mem1,
	output reg[7:0]        data_mem2,
	output reg[7:0]        data_mem3,
	output reg[7:0]        data_mem4,
	output reg[7:0]        data_mem5,
	output reg[7:0]        data_mem6,
	output reg[7:0]        data_mem7,
	output reg[7:0]        data_mem8,
	output reg[7:0]        data_mem9,
	//
	input      [15:0]  step_cnt0,
	input			[15:0]	step_cnt1,
	output reg  		af_en, 
	output reg	[15:0]focus_offset,
	output reg			focus_ofs_en,
	
	output reg  		mf_cw0,            //
	output reg  		mf_anti_cw0,
	output reg  		mf_end0,
	
	output reg  		mf_cw1,            //
	output reg  		mf_anti_cw1,
	output reg  		mf_end1,	
	
	output reg             drect_dsp,

	output reg	[15:0]search_step0,
	output reg	[15:0]search_step1,
	output reg			search_en,
	
	input      [8:0]  step_cnt,
//	output reg [15:0] step_n,
//	output reg [15:0] y_para,

	output reg [1:0]  drect, //140813
	output reg        re_con, //140813
	
	output     [7:0]  o_sector,
	output reg        sector_en,
	
	output     [15:0]	o_vs_dsp,
	output reg        vs_en,
	
	output     [15:0]	o_vf_dsp,
	output reg        vf_en,
	
	output     [15:0]	o_gain_dsp,
	output reg        gain_en,
	
	output     [15:0]	o_int_dsp,
	output reg        int_en,
	
	output reg        Hi_en,
	
	output reg        Lo_en,
	
	output reg        save_en,

    output reg      lid_offset_en,
    output reg      lid_load_en,
    output reg [7:0]lid_sector,
    output reg [7:0]video_mode,
	input	[15:0]			fpa_temp,
    
    output  reg [15:0]      noise_limit,
    output                  auto_st,
    output  reg             init_st,
	
	input			[15:0]fpa_int,
	input			[15:0]fpa_vs,
    input			[15:0]fpa_vf,
	input			[15:0]fpa_gain,
	
	output     [15:0]	o_cursor_x_dsp,
	output     [15:0]	o_cursor_y_dsp,
	output reg        cursor_en,
    output reg	[15:0]line_x_dsp,
	output reg 	[15:0]line_y_dsp,
	output reg			line_en_x,
	output reg 			line_en_y,

	output reg [7:0] time_para_3d,
    output reg [7:0] space_para_3d,
    
    ///////////////////////////////online update 
    output reg project_skip,
	/////////////////////////////
    

    input               load_state_return,
///////////////////////////////////

	input			[15:0]version,
	output			image_mode,
	output			nuc_mode,
	output	[7:0]	range_limit,
	output	[7:0]	zoom,
	output   [10:0]af_offset,
	
	output reg        oled_en,
	output [3:0] byte_cnt_r,

	output reg [9:0]  step, //visi_zoom
	output reg [9:0]  x_offset,
	output reg [8:0]  y_offset,
//	output reg [15:0] int_time,   //140522 qw
	output reg 			video_select_mode	//2013.12.20 gecj
//	output reg [15:0] data,	   
//	output reg			data_v
	);

	////////////////////////////////////////////////////////////////
	/////////////// the inner wire and reg defination //////////////
	////////////////////////////////////////////////////////////////
	localparam [6:0] LOCAL_I2C_ADDR = 7'b1100011; //7'b0100100; //0x24   //
	localparam [3:0] MAX_R = 4'b1001;             //9     
	localparam [3:0] MAX_T = 4'b1001;             //9
	//
	reg scl_in_d0,scl_in_d1;
	reg sda_in_d0,sda_in_d1;
	
	wire [7:0] shift_reg_in;
	reg        shift_reg_in_en;

	reg        shift_reg_out_ld;               
	reg  [7:0] shift_reg_out;
	reg        shift_reg_out_en;
	
	//
	reg shift_reg_out_en1;
	reg shift_reg_out_ld1;
	
	wire [2:0] bit_cnt;
	reg        bit_cnt_en;
	reg        bit_cnt_clr;
	
//	wire [3:0] byte_cnt_r;         
	wire       byte_cnt_r_en;
	wire       byte_cnt_r_clr;
	
	wire [3:0] byte_cnt_t;
	wire       byte_cnt_t_en;
	wire       byte_cnt_t_clr;    

	reg [7:0] data_mem_r[8:0];	 
	reg [7:0] data_mem_t[8:0];	  
	reg [7:0] data_racc;         
	reg       we;
	
	//
	wire sda_out_s;              
	reg start_det, stop_det;
	//// main state defination
	localparam [2:0] IDLE       = 3'b000,
	                 START      = 3'b001,
	                 HEADER     = 3'b010,
						  ACK_HEADER = 3'b011,
	                 RECV_DATA  = 3'b100,
						  ACK_DATA   = 3'b101,
						  XMIT_DATA  = 3'b110,
						  WAIT_ACK   = 3'b111;
	reg [2:0] pre_state,next_state;
	
	reg data_v;
//	reg [15:0] step_n;
	reg [15:0] x_para;

	reg [15:0] x1_para,x2_para,x3_para,x4_para,x5_para,x6_para,x7_para,x8_para,
	           x9_para,x10_para,x11_para,x12_para,x13_para,x14_para,x15_para,x16_para;	
	reg [15:0] y1_para,y2_para;
	reg [7:0]  n1;
//	reg [15:0] y_para_0,y_para_1,y_para_2,y_para_3,y_para_4,y_para_5,y_para_6,y_para_7;
//	reg [15:0] y_para_8,y_para_9,y_para_10,y_para_11,y_para_12,y_para_13,y_para_14,y_para_15;
	reg [7:0] sector,sector_d0;
	reg       sector_en_s,sector_en_s_d0;
	
	reg [15:0] vs_dsp;
	reg        vs_en_s,vs_en_s_d0;
	
	reg [15:0] vf_dsp;
	reg        vf_en_s,vf_en_s_d0;
	
	reg [15:0] cursor_x_dsp;
	reg [15:0] cursor_y_dsp;
	reg        cursor_en_s,cursor_en_s_d0;
	
	reg [15:0] gain_dsp;
	reg        gain_en_s,gain_en_s_d0;
	
	reg [15:0] int_dsp;
	reg        int_en_s,int_en_s_d0;
	
   reg        Hi_en_s,Hi_en_s_d0;
	
   reg        Lo_en_s,Lo_en_s_d0;
	
   reg        save_en_s,save_en_s_d0;
		
	reg manu_focus_en_s0,manu_focus_en_s0_d0;

	reg [15:0] bn;
	reg [15:0] bn_0,bn_1,bn_2,bn_3,bn_4;
	
	reg [15:0] x_para_0,x_para_1,x_para_2,x_para_3;
	reg [15:0] y_para_0,y_para_1,y_para_2,y_para_3;

	reg [15:0] n_0,n_1,n_2,n_3,n_4;
	reg [15:0] x_para_a0,x_para_a1,x_para_a2,x_para_a3;
	reg [15:0] y_para_a0,y_para_a1,y_para_a2,y_para_a3;
	
	reg [16:0] bn_s_0,bn_s_1,bn_s_2,bn_s_3;
	reg [15:0] bn_s_00,bn_s_10,bn_s_20,bn_s_30;	
	
	reg [15:0] bn_s_00_1,bn_s_00_2,bn_s_00_3,bn_s_00_4,bn_s_00_5,bn_s_00_6,bn_s_00_7;
	reg [15:0] bn_s_10_1,bn_s_10_2,bn_s_10_3,bn_s_10_4,bn_s_10_5,bn_s_10_6,bn_s_10_7;
	reg [15:0] bn_s_20_1,bn_s_20_2,bn_s_20_3,bn_s_20_4,bn_s_20_5,bn_s_20_6,bn_s_20_7;	
	reg [15:0] bn_s_30_1,bn_s_30_2,bn_s_30_3,bn_s_30_4,bn_s_30_5,bn_s_30_6,bn_s_30_7;	
	
	reg [16:0] n_s_0,n_s_1,n_s_2,n_s_3;
	reg [15:0] n_s_00,n_s_10,n_s_20,n_s_30;	
	
	reg [15:0] n_s_00_1,n_s_00_2,n_s_00_3,n_s_00_4,n_s_00_5,n_s_00_6,n_s_00_7;
	reg [15:0] n_s_10_1,n_s_10_2,n_s_10_3,n_s_10_4,n_s_10_5,n_s_10_6,n_s_10_7;
	reg [15:0] n_s_20_1,n_s_20_2,n_s_20_3,n_s_20_4,n_s_20_5,n_s_20_6,n_s_20_7;
	reg [15:0] n_s_30_1,n_s_30_2,n_s_30_3,n_s_30_4,n_s_30_5,n_s_30_6,n_s_30_7;
	
	reg [7:0] oled_en_s;
	reg [7:0]video_select_mode_s;

/////////////////////////////////////online updata
    reg       arm_heart,arm_heart_d0;
    reg         update_data_valid;
/////////////////////////////////////

/////////////////////////////////////
	////////////////////////////////////////////////////////////////
	///////////////////// the implementation ///////////////////////
	////////////////////////////////////////////////////////////////
   cnt #(.CNT_WIDTH(3))
       bit_cnt_inst(.clk(clk),
							 .clr(bit_cnt_clr),
							 .en(bit_cnt_en),
							 .q(bit_cnt));
   cnt #(.CNT_WIDTH(4))
       byte_cnt_r_inst(.clk(clk),
							 .clr(byte_cnt_r_clr),
							 .en(byte_cnt_r_en),
							 .q(byte_cnt_r));
   cnt #(.CNT_WIDTH(4))
       byte_cnt_t_inst(.clk(clk),
							 .clr(byte_cnt_t_clr),
							 .en(byte_cnt_t_en),
							 .q(byte_cnt_t));							 
	shift_i #(.SHIFT_WIDTH(8))
		shift_reg_i_inst(.clk(clk),
		                 .shift_en(shift_reg_in_en),
							  .sdi(sda_in_d0),
							  .data(shift_reg_in));
							  
	shift_o #(.SHIFT_WIDTH(8))                       
	   shift_reg_o_inst(.clk(clk),
		                 .ld(shift_reg_out_ld1), //
							  .data(shift_reg_out),
							  .shift_en(shift_reg_out_en1),
							  .sdo(sda_out_s));							  
	////////////////////////////////////////////////////////
	always @(posedge clk)
	begin
		{scl_in_d1,scl_in_d0} <= {scl_in_d0,scl_in};
		{sda_in_d1,sda_in_d0} <= {sda_in_d0,sda_in};
	end
	//// start detect
	always @(posedge clk)
	begin
		if(scl_in_d0 && sda_in_d1 && !sda_in_d0)
			start_det <= 1'b1;
		else 
			start_det <= 1'b0;
	end
	//// stop detect
	always @(posedge clk)
	begin
		if(scl_in_d0 && !sda_in_d1 && sda_in_d0)
			stop_det <= 1'b1;
		else 
			stop_det <= 1'b0;
	end
	////////////////////////////////////////////////////////
	/////////////// main state machine start ///////////////
	////////////////////////////////////////////////////////
	//// the state register
	always @(posedge clk)
	begin
		if(stop_det)
			pre_state <= IDLE;
		else
			pre_state <= next_state;
	end	
	//// the combinational logic
	always @(*)
	begin
		// state machine defaults
		bit_cnt_clr = 1'b1;
		bit_cnt_en  = 1'b0;
		
		shift_reg_in_en = 1'b0;
		shift_reg_out_en = 1'b0;    
		shift_reg_out_ld = 1'b0;    
		
		we = 1'b0;
		
		next_state = pre_state;
		
		case(pre_state)
			IDLE:
				begin
					if(start_det)
						next_state = START;
				end
			START:
				begin
					if(!scl_in_d0)
						next_state = HEADER;
					else if(sda_in_d0)
						next_state = IDLE;
				end
			HEADER:
				begin
					bit_cnt_clr = 1'b0;
					
					if(scl_in_d1 && !scl_in_d0)
						bit_cnt_en = 1'b1;
					else
						bit_cnt_en = 1'b0;
						
					if(!scl_in_d1 && scl_in_d0)
						shift_reg_in_en = 1'b1;
					else
						shift_reg_in_en = 1'b0;	
						
					if(start_det)
						next_state = START;	
						
					if((bit_cnt == 3'b111) && scl_in_d1 && !scl_in_d0)
						begin
							if(shift_reg_in[7:1] == LOCAL_I2C_ADDR) 	//match		
							begin
								next_state = ACK_HEADER;
							end
							else                                      //not match
								next_state = IDLE;							
						end
					else                                            
						begin
							next_state = HEADER;
						end		
				end
			ACK_HEADER:
				begin
					if(scl_in_d1 && !scl_in_d0)                              
					begin
					   if(shift_reg_in[0])            //1:read; 0:write
						begin	
							next_state = XMIT_DATA;
							shift_reg_out_ld = 1'b1;   //old
						end
						else
						begin
						   next_state = RECV_DATA;
						end					
					end	
				end
			RECV_DATA:
				begin
					bit_cnt_clr = 1'b0;
					
					if(scl_in_d1 && !scl_in_d0)
						bit_cnt_en = 1'b1;
					else
						bit_cnt_en = 1'b0;
						
					if(!scl_in_d1 && scl_in_d0)
					begin
						shift_reg_in_en = 1'b1;
					end
					else
						shift_reg_in_en = 1'b0;	
					
					if(start_det)
						next_state = START;
					
					if((bit_cnt == 3'b111) && scl_in_d1 && !scl_in_d0)
						begin
							we = 1'b1;
							next_state = ACK_DATA;														
						end
				end
			ACK_DATA:
				begin
					if(scl_in_d1 && !scl_in_d0)
						begin
							next_state = RECV_DATA;

						end
				end
			XMIT_DATA:
			begin
					bit_cnt_clr = 1'b0;
					
					if(scl_in_d1 && !scl_in_d0)
						bit_cnt_en = 1'b1;
					else
						bit_cnt_en = 1'b0;
		
						
					if(scl_in_d1 && !scl_in_d0)
					begin
						shift_reg_out_en = 1'b1;						
					end
					else
						shift_reg_out_en = 1'b0;			  	
					
					if(start_det)
						next_state = START;
					
					if((bit_cnt == 3'b111) && scl_in_d1 && !scl_in_d0)
						begin
							next_state = WAIT_ACK;	
						end		
			end
			WAIT_ACK:
				begin
					if(scl_in_d1 && !scl_in_d0)
						begin
							shift_reg_out_ld = 1'b1;                
						end
						
					if(scl_in_d0 && sda_in_d0)                 
						next_state = IDLE;
						
					if(scl_in_d1 && !scl_in_d0)
						next_state = XMIT_DATA;

				end			     
			default:
				begin
					next_state = IDLE;
				end
		endcase	
	end	
	////
	always @(posedge clk)
	begin
		if((pre_state == ACK_HEADER) || (pre_state == ACK_DATA))
			sda_out <= 1'b0;
		else if(pre_state == XMIT_DATA)
		   sda_out <= sda_out_s;
		else
		   sda_out <= 1'b1;
	end
	
	assign byte_cnt_r_clr = (pre_state == IDLE || pre_state == START || pre_state == HEADER || pre_state == ACK_HEADER); 
	assign byte_cnt_t_clr = (pre_state == IDLE || pre_state == START || pre_state == HEADER || pre_state == ACK_HEADER); 
	assign byte_cnt_r_en  = we;          //1023
	assign byte_cnt_t_en  = shift_reg_out_ld1;          //1023


	//
	initial
	begin
		oled_en = 1'b0;
		sector_en = 1'b0;
		sector = 8'd1;	
		vs_en = 1'b0;
		vf_en = 1'b0;
		gain_en = 1'b0;
		int_en = 1'b0;
		vs_dsp = 16'd1700;
		vf_dsp = 16'd1500;
		gain_dsp = 16'd2;
		int_dsp  = 16'd300;
		cursor_x_dsp = 16'd320;
		cursor_y_dsp = 16'd240;
		bn_4 = 16'd19000;
		n_4 = 16'd0;
		cnt_r=1'b0;
		flag=1'b0;
//		int_time = 16'd80;
	end
	
	reg flag;
	
	always@(posedge clk)
	begin
	   if(sector_en_s)
	      flag<=1;	   
	end
	
	always@(posedge clk)
	begin
	   if(flag)
	     cnt_r<=cnt_r+1'b1;
	   else
	     cnt_r<=1'b0;
	end
	//
	//reg shift_reg_out_en1;
	always @(posedge clk)                           
	begin
		shift_reg_out_en1 <= shift_reg_out_en;
	end
	
	always @(posedge clk)                           
	begin
		shift_reg_out_ld1 <= shift_reg_out_ld;
	end
		
	////
	always @(posedge clk)                           
	begin
//			if(byte_cnt_t == 8'h0)
//			begin
//				shift_reg_out <= 8'h53;
//			end
//			
//			if(byte_cnt_t == 8'h1)
//			begin
//				shift_reg_out <= 8'h6e;
//			end
//			
//			if(byte_cnt_t == 8'h2)
//			begin
//				shift_reg_out <= 8'h00;
//			end
//			
//			if(byte_cnt_t == 8'h3)
//			begin
//				shift_reg_out <= 8'h00;
//			end
//			
//			if(byte_cnt_t == 8'h4)
//			begin
//				shift_reg_out <= 8'h70;
//			end
//			
//			if(byte_cnt_t == 8'h5)
//			begin
//				shift_reg_out <= 8'h17;
//			end
//			
//			if(byte_cnt_t == 8'h6)
//			begin
//				shift_reg_out <= 8'h00;
//			end
//			
//			if(byte_cnt_t == 8'h7)
//			begin
//				shift_reg_out <= 8'h87;
//			end
//			
//			if(byte_cnt_t == 8'h8)
//			begin
//				shift_reg_out <= 8'h45;
//			end


			shift_reg_out <= data_mem_t[byte_cnt_t];

		if(we)
		begin
				data_mem_r[byte_cnt_r] <= shift_reg_in;

				data_mem1 <= data_mem_r[0];
				data_mem2 <= data_mem_r[1];
				data_mem3 <= data_mem_r[2];
				data_mem4 <= data_mem_r[3];
				data_mem5 <= data_mem_r[4];
				data_mem6 <= data_mem_r[5];
				data_mem7 <= data_mem_r[6];
				data_mem8 <= data_mem_r[7];
				data_mem9 <= data_mem_r[8];
		end
	end 
	
	
	///////////////////////////////////////////////////
	///////////////////////////////////////////////////online updata
	always @(*)
	begin
//		if((pre_state == RECV_DATA) && stop_det && (data_mem_r[7] == data_racc))
//		if((pre_state == RECV_DATA) && stop_det)	
		if(pre_state == RECV_DATA)
			data_v <= 1'b1;	
		else 
			data_v <= 1'b0;
	end	
	
////////////////////////////////	
	

	//
//	reg data_v_enable;
//	always @(posedge clk)
//	begin
//		data_v_enable <= data_v;
//	end
	//
	
	//dsp读模式,先接收命令串，再准备写数据
	always @(posedge clk)                             
	begin
		if(data_v)
		begin
//			data_mem_t[0] <= 8'h53;
//			data_mem_t[7] <= data_mem_r[7];		
//			data_mem_t[8] <= data_mem_r[8];	
			case(data_mem_r[2])
			8'h00:   // FPGA Device type
			begin
				data_mem_t[2] <= 8'h08;
				data_mem_t[3] <= 8'h23;
				data_mem_t[4] <= 8'h40;
				data_mem_t[5] <= 8'h0e;
				data_mem_t[6] <= 8'h4c;
				data_mem_t[7] <= 8'h0e;
			end
			8'h01:   // Version 
			begin
				data_mem_t[2] <= 8'h00;
				data_mem_t[3] <= 8'h01;
				data_mem_t[4] <= 8'h00;
				data_mem_t[5] <= 8'h00;
				data_mem_t[6] <= 8'h00;
				data_mem_t[7] <= 8'h01;
			end		
			8'h02:     //FPGA pixel
			begin
				data_mem_t[2] <= 8'h00;
				data_mem_t[3] <= 8'h00;
				data_mem_t[4] <= 8'hf0;
				data_mem_t[5] <= 8'h00;  //240
				data_mem_t[6] <= 8'h40;
				data_mem_t[7] <= 8'h01;  //320
			end
			8'h52:   //vs
			begin
				data_mem_t[0] <= 8'h53;
				data_mem_t[1] <= 8'h52;
				data_mem_t[2] <= fpa_vs[15:8];
				data_mem_t[3] <= fpa_vs[7:0];
				data_mem_t[4] <= 8'h00;
				data_mem_t[5] <= 8'h00;
				data_mem_t[6] <= 8'h00;
				data_mem_t[7] <= fpa_vs[15:8] + fpa_vs[7:0];
				data_mem_t[8] <= 8'h45;
			end
			8'h51:   //vf
			begin
				data_mem_t[0] <= 8'h53;
				data_mem_t[1] <= 8'h51;
				data_mem_t[2] <= fpa_vf[15:8];
				data_mem_t[3] <= fpa_vf[7:0];
				data_mem_t[4] <= 8'h00;
				data_mem_t[5] <= 8'h00;
				data_mem_t[6] <= 8'h00;
				data_mem_t[7] <= fpa_vf[15:8] + fpa_vf[7:0];
				data_mem_t[8] <= 8'h45;
			end
			8'h53:   //gain
			begin
				data_mem_t[0] <= 8'h53;
				data_mem_t[1] <= 8'h53;
				data_mem_t[2] <= fpa_gain[15:8];
				data_mem_t[3] <= fpa_gain[7:0];
				data_mem_t[4] <= 8'h00;
				data_mem_t[5] <= 8'h00;
				data_mem_t[6] <= 8'h00;
				data_mem_t[7] <= fpa_gain[15:8] + fpa_gain[7:0];
				data_mem_t[8] <= 8'h45;
			end
			8'h54:   //int
			begin
				data_mem_t[0] <= 8'h53;
				data_mem_t[1] <= 8'h54;
				data_mem_t[2] <= fpa_int[15:8];
				data_mem_t[3] <= fpa_int[7:0];
				data_mem_t[4] <= 8'h00;
				data_mem_t[5] <= 8'h00;
				data_mem_t[6] <= 8'h00;
				data_mem_t[7] <= fpa_int[15:8] + fpa_int[7:0];
				data_mem_t[8] <= 8'h45;
			end

			8'h6e:
			begin
//				mf_anti_cw <= 1'b0;
				data_mem_t[0] <= 8'h53;
				data_mem_t[1] <= 8'h6e;
				data_mem_t[2] <= zero_value[15:8];
				data_mem_t[3] <= zero_value[7:0];
				data_mem_t[4] <= 8'h00;
				data_mem_t[5] <= 8'h00;
				data_mem_t[6] <= 8'h00;
				data_mem_t[7] <= zero_value[15:8] + zero_value[7:0];
				data_mem_t[8] <= 8'h45;
			end		
		
			8'hb9:   //vtemp                                     
			begin
				data_mem_t[2] <= 8'h06;
				data_mem_t[3] <= 8'h05;
				data_mem_t[4] <= 8'h04;
				data_mem_t[5] <= 8'h03;
//				data_mem_t[6] <= data_vtp[7:0];
//				data_mem_t[7] <= data_vtp[15:8];
			end	
			8'hce:  //step_cnt                                      
			begin
				data_mem_t[2] <= 8'h00;
				data_mem_t[3] <= 8'h00;
				data_mem_t[4] <= 8'h00;
				data_mem_t[5] <= 8'h00;
				data_mem_t[6] <= step_cnt[7:0];
				data_mem_t[7] <= {7'd0,step_cnt[8]};
			end	
			8'h5c:
			begin
				data_mem_t[0] <= 8'h53;
				data_mem_t[1] <= 8'h5c;
				data_mem_t[2] <= version[15:8];
				data_mem_t[3] <= version[7:0];
				data_mem_t[4] <= 8'h00;
				data_mem_t[5] <= 8'h00;
				data_mem_t[6] <= 8'h00;
				data_mem_t[7] <= version[15:8] + version[7:0];
				data_mem_t[8] <= 8'h45;	
			end
			8'ha4:
			begin
				data_mem_t[0] <= 8'h53;
				data_mem_t[1] <= 8'ha4;
				data_mem_t[2] <= fpa_temp[15:8];
				data_mem_t[3] <= fpa_temp[7:0];
				data_mem_t[4] <= 8'h00;
				data_mem_t[5] <= 8'h00;
				data_mem_t[6] <= 8'h00;
				data_mem_t[7] <= fpa_temp[15:8]+fpa_temp[7:0];
				data_mem_t[8] <= 8'h45;
			end
			8'h75:  //step_cnt                                      
			begin
				data_mem_t[0] <= 8'h53;
				data_mem_t[1] <= 8'h75;
				data_mem_t[2] <= step_cnt0[15:8];
				data_mem_t[3] <= step_cnt0[7:0];
				data_mem_t[4] <= step_cnt1[15:8];
				data_mem_t[5] <= step_cnt1[7:0];
				data_mem_t[6] <= 8'h00;
				data_mem_t[7] <= step_cnt0[15:8] + step_cnt0[7:0] + step_cnt1[15:8] + step_cnt1[7:0];
				data_mem_t[8] <= 8'h45;
			end	
////////////////////////////////////////////online updata
            8'hfd:
            begin
				data_mem_t[0] <= 8'h53;
				data_mem_t[1] <= 8'hfd;
				data_mem_t[2] <= update_end;
				data_mem_t[3] <= 8'h00;
				data_mem_t[4] <= 8'h00;
				data_mem_t[5] <= 8'h00;
				data_mem_t[6] <= 8'h00;
				data_mem_t[7] <= update_end;
				data_mem_t[8] <= 8'h45;
			end
            8'h11:
			begin
				data_mem_t[0] <= 8'h53;
				data_mem_t[1] <= 8'h11;
				data_mem_t[2] <= {7'b0,load_state_return};
				data_mem_t[3] <= 8'h00;
				data_mem_t[4] <= 8'h00;
				data_mem_t[5] <= 8'h00;
				data_mem_t[6] <= 8'h00;
				data_mem_t[7] <= {7'b0,load_state_return};
				data_mem_t[8] <= 8'h45;	
			end
///////////////////////////////////////////
		endcase
		end
	end  
   
	initial
	begin
//		oled_en = 1'b0;
//		sector_en = 1'b0;
//		sector = 8'd1;	

		bn_4 = 16'd23760;
//		n_4 = 16'd10;
	end
	
	always @(posedge clk)                             
	begin	
		if((sector == 8'h01)|(sector == 8'h02))
			begin
				bn_4 = 16'd23760;
//				n_4 = 16'd50;
			end
		else if((sector == 8'h03)|(sector == 8'h04))
			begin
				bn_4 = 16'd23760;
//				n_4 = 16'd10;
			end
	end
	

	
	always @(posedge clk)
	begin
		if(sector_d0 != sector)
			re_con <= 1'b0;
		else
			re_con <= 1'b1;
	end
	
	//dsp写模式,fpga接收数据
	reg [15:0] step_s;
	reg	[7:0]range_limit_reg = 8'd80;
	reg	[7:0]zoom_reg = 8'd48;
	reg	[7:0]image_mode_s;
	reg	[7:0]nuc_mode_s = 1'b0;
	reg 	[10:0]af_offset_reg = 11'd200;
    reg     lid_load_en_s,lid_load_en_s_d0;
    reg	[15:0]temp_data;
    reg [7:0]   auto_st_s = 8'd0;
	reg			focus_offset_en;
	
	always @(posedge clk)                             
	begin		
		mf_cw0            <= 1'b0;
		mf_anti_cw0       <= 1'b0;
		mf_end0           <= 1'b0;
		mf_cw1            <= 1'b0;
		mf_anti_cw1       <= 1'b0;
		mf_end1           <= 1'b0;
		manu_focus_en_s0 <= 1'b0;
		af_en            <= 1'b0;
//		sector           <= 8'd0;	
		rectify_en       <= 1'b0;
		sector_en_s      <= 1'b0;
		vs_en_s          <= 1'b0;
		vf_en_s          <= 1'b0;
		gain_en_s        <= 1'b0;
		int_en_s         <= 1'b0;
		Hi_en_s          <= 1'b0;
		Lo_en_s          <= 1'b0;
		save_en_s        <= 1'b0;
		cursor_en_s      <= 1'b0;
		erase_sof_en     <= 1'b0;
        lid_offset_en    <= 1'b0;
        init_st          <= 1'b0;
        line_en_x        <= 1'b0;
        line_en_y        <= 1'b0;
		search_en			<= 1'b0;
        focus_ofs_en     <= 1'b0;
////////////////////////////////////////online updata
        update_data_valid    <= 1'b0;
        update_transfer_end       <= 1'b0;
///////////////////////////////////////
		if(data_v && byte_cnt_r == 7)
		begin
			case(data_mem_r[2])
			8'h10:
			begin 
				sector <= data_mem_r[3];
				sector_en_s <= 1'b1;
			end
			8'h56:
			begin
				vs_dsp  <= {data_mem_r[3],data_mem_r[4]};
				vs_en_s <= 1'b1;
			end
			8'h55:
			begin
				vf_dsp  <= {data_mem_r[3],data_mem_r[4]};
				vf_en_s <= 1'b1;
			end
			8'h57:
			begin
				gain_dsp  <= {data_mem_r[3],data_mem_r[4]};
				gain_en_s <= 1'b1;
			end
			8'h58:
			begin
				int_dsp  <= {data_mem_r[3],data_mem_r[4]};
				int_en_s <= 1'b1;
			end
			8'h59:
			begin
				Hi_en_s   <= 1'b1;
			end
			8'h5a:
			begin
				Lo_en_s   <= 1'b1;
			end
			8'h5b:
			begin
				save_en_s <= 1'b1;
			end
			8'h5d:
			begin
				cursor_x_dsp  <= {data_mem_r[3],data_mem_r[4]};
				cursor_y_dsp  <= {data_mem_r[5],data_mem_r[6]};
//				cursor_y_dsp  <= {data_mem_r[3],data_mem_r[4]};
				cursor_en_s <= 1'b1;
			end
            8'h46:
			begin
				line_x_dsp  <= {data_mem_r[4],data_mem_r[3]};
				line_en_x <= 1'b1;
			end
			8'h47:
			begin
				line_y_dsp  <= {data_mem_r[4],data_mem_r[3]};
				line_en_y <= 1'b1;
            end
			8'h6d:   // one point rectify
				rectify_en <= 1'b1;
			8'h45:
			    af_offset_reg <= {data_mem_r[4],data_mem_r[3]};
			8'h80:
			    erase_sof_en <= 1'b1;
//			8'h80:   // one point rectify 
//				int_time <= {data_mem_r[5],data_mem_r[6]};		
			8'hc1:   // 
				y1_para <= {data_mem_r[5],data_mem_r[6]};				
			8'hc2:   // 
				n1 <= {data_mem_r[5],data_mem_r[6]};				
			8'h22:
				mf_anti_cw0 <= 1'b1;	
			8'h23:   // manu focus en clockwise 
				mf_cw0 <= 1'b1;					
			8'h24:   // manu focus end
				mf_end0 <= 1'b1;
			8'h27:
				mf_anti_cw1 <= 1'b1;
			8'h28:
				mf_cw1 <= 1'b1;
			8'h29:
				mf_end1 <= 1'b1;
			8'h26:   // auto focus en                                     
				af_en <= 1'b1; 
//			8'hba:
//				oled_en <= 1'b1;
			8'h79:
				bn   <= {data_mem_r[3],data_mem_r[4]};
			8'he0:			                            		//mf
				bn_0 <= {data_mem_r[3],data_mem_r[4]};
			8'he1:
				x_para_0 <= {data_mem_r[3],data_mem_r[4]};
			8'he2:
				y_para_0 <= {data_mem_r[3],data_mem_r[4]};	
			8'he3:			
				bn_1 <= {data_mem_r[3],data_mem_r[4]};
			8'he4:
				x_para_1 <= {data_mem_r[3],data_mem_r[4]};
			8'he5:
				y_para_1 <= {data_mem_r[3],data_mem_r[4]};		
			8'he6:			
				bn_2 <= {data_mem_r[3],data_mem_r[4]};
			8'he7:
				x_para_2 <= {data_mem_r[3],data_mem_r[4]};
			8'he8:
				y_para_2 <= {data_mem_r[3],data_mem_r[4]};		
			8'he9:			
				bn_3 <= {data_mem_r[3],data_mem_r[4]};
			8'hea:
				x_para_3 <= {data_mem_r[3],data_mem_r[4]};
//			8'hea:
//				step <= {data_mem_r[5],data_mem_r[6]};
			8'heb:
				y_para_3 <= {data_mem_r[3],data_mem_r[4]};
			8'hba:
				oled_en_s <= data_mem_r[6];
			8'hc6:
				manu_focus_en_s0 <= 1'b1;
			8'hc5:							
				video_select_mode_s<=data_mem_r[6];
			8'h43:
				range_limit_reg <= data_mem_r[3];
			8'h44:
				zoom_reg <= data_mem_r[3];
		   8'h01:
				image_mode_s <= data_mem_r[3];
			8'h41:
				nuc_mode_s <= data_mem_r[3];
            8'h77:
                lid_offset_en <= 1'b1; 
            8'h78:
                video_mode <= data_mem_r[3];
            8'h31:
				lid_sector <= data_mem_r[3];
            8'h72:
				temp_data  <= {data_mem_r[4],data_mem_r[3]};
            8'h48:
				auto_st_s <= data_mem_r[3];
			8'h49:
				init_st <= 1'b1;
			8'h4a:
				noise_limit <= data_mem_r[3];
            /*8'h45:
                begin
                    focus_offset <= {data_mem_r[4],data_mem_r[3]};
                    focus_ofs_en <= 1'b1;
                end*/
			8'h5e:
				begin
					search_step0 <= {data_mem_r[3],data_mem_r[4]};
					search_step1 <= {data_mem_r[5],data_mem_r[6]};
					search_en <= 1'b1;
                end
            ////////////////////////////online update
             8'hf2:
                project_skip <= 1'b1;
            ////////////////////////////////////
			 8'h81:                              
				time_para_3d <= data_mem_r[3]; 
			8'h82:                             
				space_para_3d <= data_mem_r[3];
			8'h61:
            begin
                drect_dsp <=  data_mem_r[3][0];   
            end	
			endcase
		end
	end
	
    assign  auto_st = auto_st_s[0];
	assign  o_sector = sector-1'b1;
	assign  o_vs_dsp = vs_dsp;
	assign  o_vf_dsp = vf_dsp;
	assign  o_gain_dsp = gain_dsp;
	assign  o_int_dsp = int_dsp; 
	assign  o_cursor_x_dsp = cursor_x_dsp;
	assign  o_cursor_y_dsp = cursor_y_dsp;
	assign  range_limit	= range_limit_reg;
	assign  zoom			= zoom_reg;
	assign  af_offset = af_offset_reg;
	assign	image_mode = image_mode_s[0];
	assign	nuc_mode = nuc_mode_s[0];

always @(posedge clk)
begin //1
		if(bn == 16'd0)
					begin
						x_offset <= x_para_0[9:0];
						y_offset <= y_para_0[8:0];
					end	
					else if(bn == 16'd1)
					begin
						x_offset <= x_para_1[9:0];
						y_offset <= y_para_1[8:0];
					end	
					else if(bn == 16'd2)
					begin
						x_offset <= x_para_2[9:0];
						y_offset <= y_para_2[8:0];
					end	
					else if(bn == 16'd3)
					begin
						x_offset <= x_para_3[9:0];
						y_offset <= y_para_3[8:0];
					end

end	  
	
	
	always @(posedge clk)      //2014.08.26                       
	begin
		if(video_select_mode)
			step<=10'd256;
		else 	if((sector == 8'h01)|(sector == 8'h02))
			step <= 10'd192;
		else 	if((sector == 8'h03)|(sector == 8'h04))
			step <= 10'd123;
		else
			step <= 10'd256;
	end
	
	always @(posedge clk)
	begin
		oled_en <= oled_en_s[0];
	end
	
	
	always @(posedge clk)//2013.12.20 gecj
	begin
		video_select_mode <= video_select_mode_s[0];
	end
	
	
		///////////////////////////////online update

    always@(posedge clk)
    begin
        sector_en <= sector_en_s;
        lid_load_en <= lid_load_en_s;
        vs_en <= vs_en_s;
        vf_en <= vf_en_s;
        gain_en <= gain_en_s;
        int_en <= int_en_s;
        Lo_en <= Lo_en_s;
        Hi_en <= Hi_en_s;
        save_en <= save_en_s;
        cursor_en <= cursor_en_s;
    end

/////////////////////////////////////online update	
reg update_st = 1'b0;
reg update_st_d0;
reg update_data_valid_d0;

always@(posedge clk )
begin
    if(update_data_valid)
        update_st <= 1'b1;
    else
        update_st <= update_st;
end

always@(posedge clk)
begin
    update_st_d0 <= update_st;
    update_data_valid_d0 <= update_data_valid;
end

always@(posedge clk)
begin
    if(!update_st_d0 && update_st)
        update_vd <= 1'b1;
    else
        update_vd <= 1'b0;
end

always@(posedge clk)
begin
    if(!update_data_valid_d0 &&update_data_valid)
        update_data_en <= 1'b1;
    else
        update_data_en <= 1'b0;
end

////////////////////////////////////////

	/*
	always @(posedge clk)
	begin
		manu_focus_en_s0_d0 <= manu_focus_en_s0;
	end
	
	initial
	begin
		manu_focus_en_s = 1'b0;
	end

	always @(posedge clk)
	begin
		if(!manu_focus_en_s0_d0 & manu_focus_en_s0)
			manu_focus_en_s <= ~manu_focus_en_s;
	end	

	
	always @(posedge clk)                             
	begin		
		sector_en_s_d0 <= sector_en_s;
	end
	
	always @(posedge clk)                             
	begin		
		sector_d0 <= sector;
		if(!sector_en_s_d0 & sector_en_s)
			sector_en <= ~sector_en;
	end

    always @(posedge clk)                             
	begin		
		if(data_mem_r[2]==8'h31 && video_mode==8'd3)
			lid_load_en_s <= 1'd1;
		else
			lid_load_en_s <= 1'b0;
	end
	always @(posedge clk)                             
	begin		
		lid_load_en_s_d0 <= lid_load_en_s;
	end
	
	always @(posedge clk)                             
	begin		
		if(lid_load_en_s_d0 & !lid_load_en_s)
			lid_load_en <= ~lid_load_en;
	end
	
	always @(posedge clk)                             
	begin		
		vs_en_s_d0 <= vs_en_s;
	end
	
	always @(posedge clk)                             
	begin	
		if(!vs_en_s_d0 & vs_en_s)
			vs_en <= ~vs_en;
	end
	
	always @(posedge clk)                             
	begin		
		vf_en_s_d0 <= vf_en_s;
	end
	
	always @(posedge clk)                             
	begin	
		if(!vf_en_s_d0 & vf_en_s)
			vf_en <= ~vf_en;
	end
	
	always @(posedge clk)                             
	begin		
		gain_en_s_d0 <= gain_en_s;
	end
	
	always @(posedge clk)                             
	begin	
		if(!gain_en_s_d0 & gain_en_s)
			gain_en <= ~gain_en;
	end
	
	always @(posedge clk)                             
	begin		
		int_en_s_d0 <= int_en_s;
	end
	
	always @(posedge clk)                             
	begin	
		if(!int_en_s_d0 & int_en_s)
			int_en <= ~int_en;
	end
	
	always @(posedge clk)                             
	begin		
		Hi_en_s_d0 <= Hi_en_s;
	end
	
	always @(posedge clk)                             
	begin	
		if(!Hi_en_s_d0 & Hi_en_s)
			Hi_en <= ~Hi_en;
	end
	
	always @(posedge clk)                             
	begin		
		Lo_en_s_d0 <= Lo_en_s;
	end
	
	always @(posedge clk)                             
	begin	
		if(!Lo_en_s_d0 & Lo_en_s)
			Lo_en <= ~Lo_en;
	end
	
	always @(posedge clk)                             
	begin		
		save_en_s_d0 <= save_en_s;
	end
	
	always @(posedge clk)                             
	begin	
		if(!save_en_s_d0 & save_en_s)
			save_en <= ~save_en;
	end
	
	always @(posedge clk)                             
	begin		
		cursor_en_s_d0 <= cursor_en_s;
	end
	
	always @(posedge clk)                             
	begin	
		if(!cursor_en_s_d0 & cursor_en_s)
			cursor_en <= ~cursor_en;
	end*/


////////////////////////////////////////////////////
	
endmodule

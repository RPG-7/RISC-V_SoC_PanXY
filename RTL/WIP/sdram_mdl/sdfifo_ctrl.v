`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////
// Company		: 
// Engineer		: ��Ȩ franchises3
// Create Date	: 2009.05.11
// Design Name	: 
// Module Name	: sdfifo_ctrl
// Project Name	: 
// Target Device: Cyclone EP1C3T144C8 
// Tool versions: Quartus II 8.1
// Description	: SDRAM fifo����ģ��						
//				
// Revision		: V1.0
// Additional Comments	:  
// 
////////////////////////////////////////////////////////////////////////////////
module sdfifo_ctrl(
				clk_25m,clk_100m,
				wrf_din,wrf_wrreq,
				sdram_wr_ack,/*sys_addr,*/sys_data_in,sdram_wr_req,
				sys_data_out,rdf_rdreq,sdram_rd_ack,rdf_dout,sdram_rd_req,
				syswr_done,tx_start
			);

input clk_25m;	//PLL���25MHzʱ��
input clk_100m;	//PLL���100MHzʱ��

	//wrfifo
input[15:0] wrf_din;		//sdram����д�뻺��FIFO������������
input wrf_wrreq;			//sdram����д�뻺��FIFO�����������󣬸���Ч
input sdram_wr_ack;			//ϵͳдSDRAM��Ӧ�ź�,��ΪwrFIFO�������Ч�ź�

//output[21:0] sys_addr;		//��дSDRAMʱ��ַ�ݴ�����(bit21-20)L-Bank��ַ:(bit19-8)Ϊ�е�ַ��(bit7-0)Ϊ�е�ַ 
output[15:0] sys_data_in;	//sdram����д�뻺��FIFO����������ߣ���дSDRAMʱ�����ݴ���
output sdram_wr_req;		//ϵͳдSDRAM�����ź�

	//rdfifo
input[15:0] sys_data_out;	//sdram���ݶ�������FIFO������������
input rdf_rdreq;			//sdram���ݶ�������FIFO����������󣬸���Ч
input sdram_rd_ack;			//ϵͳ��SDRAM��Ӧ�ź�,��ΪrdFIFO����д��Ч�ź�

output[15:0] rdf_dout;		//sdram���ݶ�������FIFO�����������
output sdram_rd_req;		//ϵͳ��SDRAM�����ź�

input syswr_done;		//��������д��sdram��ɱ�־λ
output tx_start;		//���ڷ�������������־λ������Ч

//------------------------------------------------
wire[8:0] wrf_use;			//sdram����д�뻺��FIFO���ô洢�ռ�����
wire[8:0] rdf_use;			//sdram���ݶ�������FIFO���ô洢�ռ�����	

//assign sys_addr = 22'h1a9e21;	//������
assign sdram_wr_req = ((wrf_use >= 9'd8) & ~syswr_done);	//FIFO��8��16bit���ݣ�������дSDRAM�����ź�
assign sdram_rd_req = ((rdf_use <= 9'd256) & syswr_done);	//sdramд�������FIFO��գ�256��16bit���ݣ���������SDRAM�����ź�
assign tx_start = ((rdf_use != 9'd0) & syswr_done);		//�������ڷ�������

//------------------------------------------------
//����SDRAMд�����ݻ���FIFOģ��
wrfifo			uut_wrfifo(
					.data(wrf_din),
					.rdclk(clk_100m),
					.rdreq(sdram_wr_ack),
					.wrclk(clk_25m),
					.wrreq(wrf_wrreq),
					.q(sys_data_in),
					.wrusedw(wrf_use)
					);	

//------------------------------------------------
//����SDRAM�������ݻ���FIFOģ��
rdfifo			uut_rdfifo(
					.data(sys_data_out),
					.rdclk(clk_25m),
					.rdreq(rdf_rdreq),
					.wrclk(clk_100m),
					.wrreq(/*rdf_wrreq*/sdram_rd_ack),
					.q(rdf_dout),
					.wrusedw(rdf_use)
					);	

endmodule

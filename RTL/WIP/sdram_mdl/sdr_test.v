`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////
// Company		: 
// Engineer		: ��Ȩ franchises3
// Create Date	: 2009.05.11
// Design Name	: 
// Module Name	: sdr_test
// Project Name	: 
// Target Device: Cyclone EP1C3T144C8 
// Tool versions: Quartus II 8.1
// Description	: 
//				
// Revision		: V1.0
// Additional Comments	:  
// 
////////////////////////////////////////////////////////////////////////////////
module sdr_test(
				clk,rst_n,
				sdram_clk,sdram_cke,sdram_cs_n,sdram_ras_n,sdram_cas_n,sdram_we_n,
				sdram_ba,sdram_addr,sdram_data,//sdram_udqm,sdram_ldqm	
				rs232_tx,
	/*			sdram_rd_req,sdram_wr_ack,sdram_rd_ack,
				sys_data_out,sdram_busy,sys_data_in,sys_dout_rdy,
			*/	rdf_dout/*,rdf_rdreq*/
			);

input clk;			//ϵͳʱ�ӣ�100MHz
input rst_n;		//��λ�źţ��͵�ƽ��Ч

	// FPGA��SDRAMӲ���ӿ�
output sdram_clk;			//	SDRAMʱ���ź�
output sdram_cke;			//  SDRAMʱ����Ч�ź�
output sdram_cs_n;			//	SDRAMƬѡ�ź�
output sdram_ras_n;			//	SDRAM�е�ַѡͨ����
output sdram_cas_n;			//	SDRAM�е�ַѡͨ����
output sdram_we_n;			//	SDRAMд����λ
output[1:0] sdram_ba;		//	SDRAM��L-Bank��ַ��
output[11:0] sdram_addr;	//  SDRAM��ַ����
//output sdram_udqm;			// SDRAM���ֽ�����
//output sdram_ldqm;			// SDRAM���ֽ�����
inout[15:0] sdram_data;		// SDRAM��������

output rs232_tx;		//RS232���������ź�

////////////////////////////////////////////////
	// SDRAM�ķ�װ�ӿڲ�������
/*output sdram_rd_req;			//ϵͳ��SDRAM�����ź�
output sdram_wr_ack;		//ϵͳдSDRAM��Ӧ�ź�
output sdram_rd_ack;		//ϵͳ��SDRAM��Ӧ�ź�	
output[15:0] sys_data_in;	//дSDRAMʱ�����ݴ�����4��ͻ����д�����ݣ�Ĭ��Ϊ00��ַbit15-0;01��ַbit31-16;10��ַbit47-32;11��ַbit63-48

output[15:0] sys_data_out;	//��SDRAMʱ�����ݴ���,(��ʽͬ��)
output sdram_busy;			// SDRAMæ��־���߱�ʾSDRAM���ڹ�����
output sys_dout_rdy;			// SDRAM���������ɱ�־
*/
output[15:0] rdf_dout;		//sdram���ݶ�������FIFO�����������	
//output rdf_rdreq;			//sdram���ݶ�������FIFO����������󣬸���Ч

////////////////////////////////////////////////


	// SDRAM�ķ�װ�ӿ�
wire sdram_wr_req;			//ϵͳдSDRAM�����ź�
wire sdram_rd_req;			//ϵͳ��SDRAM�����ź�
wire sdram_wr_ack;			//ϵͳдSDRAM��Ӧ�ź�,��ΪwrFIFO�������Ч�ź�
wire sdram_rd_ack;			//ϵͳ��SDRAM��Ӧ�ź�,��ΪrdFIFO����д��Ч�ź�	
wire[21:0] sys_addr;		//��дSDRAMʱ��ַ�ݴ�����(bit21-20)L-Bank��ַ:(bit19-8)Ϊ�е�ַ��(bit7-0)Ϊ�е�ַ 
wire[15:0] sys_data_in;		//дSDRAMʱ�����ݴ���

wire[15:0] sys_data_out;	//sdram���ݶ�������FIFO������������
wire sdram_busy;			// SDRAMæ��־���߱�ʾSDRAM���ڹ�����
wire sys_dout_rdy;			// SDRAM���������ɱ�־

	//wrFIFO������ƽӿ�
wire[15:0] wrf_din;		//sdram����д�뻺��FIFO������������
wire wrf_wrreq;			//sdram����д�뻺��FIFO�����������󣬸���Ч
	//rdFIFO������ƽӿ�
wire[15:0] rdf_dout;		//sdram���ݶ�������FIFO�����������	
wire rdf_rdreq;			//sdram���ݶ�������FIFO����������󣬸���Ч

	//ϵͳ��������źŽӿ�
wire clk_25m;	//PLL���25MHzʱ��
wire clk_100m;	//PLL���100MHzʱ��
wire sys_rst_n;	//ϵͳ��λ�źţ�����Ч


//------------------------------------------------
//����ϵͳ��λ�źź�PLL����ģ��
sys_ctrl		uut_sysctrl(
					.clk(clk),
					.rst_n(rst_n),
					.sys_rst_n(sys_rst_n),
					.clk_25m(clk_25m),
					.clk_100m(clk_100m),
					.sdram_clk(sdram_clk)
					);

//------------------------------------------------
//����SDRAM��װ����ģ��
sdram_top		uut_sdramtop(				// SDRAM
							.clk(clk_100m),
							.rst_n(sys_rst_n),
							.sdram_wr_req(sdram_wr_req),
							.sdram_rd_req(sdram_rd_req),
							.sdram_wr_ack(sdram_wr_ack),
							.sdram_rd_ack(sdram_rd_ack),	
							.sys_addr(sys_addr),
							.sys_data_in(sys_data_in),
							.sys_data_out(sys_data_out),
							.sys_dout_rdy(sys_dout_rdy),
							//.sdram_clk(sdram_clk),
							.sdram_busy(sdram_busy),
							.sdram_cke(sdram_cke),
							.sdram_cs_n(sdram_cs_n),
							.sdram_ras_n(sdram_ras_n),
							.sdram_cas_n(sdram_cas_n),
							.sdram_we_n(sdram_we_n),
							.sdram_ba(sdram_ba),
							.sdram_addr(sdram_addr),
							.sdram_data(sdram_data)
						//	.sdram_udqm(sdram_udqm),
						//	.sdram_ldqm(sdram_ldqm)
					);
	

//------------------------------------------------
//��дSDRAM���ݻ���FIFOģ������	
sdfifo_ctrl			uut_sdffifoctrl(
						.clk_25m(clk_25m),
						.clk_100m(clk_100m),
						.wrf_din(wrf_din),
						.wrf_wrreq(wrf_wrreq),
						.sdram_wr_ack(sdram_wr_ack),
						//.sys_addr(sys_addr),
						.sys_data_in(sys_data_in),
						.sdram_wr_req(sdram_wr_req),
						.sys_data_out(sys_data_out),
						.rdf_rdreq(rdf_rdreq),
						.sdram_rd_ack(sdram_rd_ack),
						.rdf_dout(rdf_dout),
						.sdram_rd_req(sdram_rd_req),
						.syswr_done(syswr_done),
						.tx_start(tx_start)		
						);	
						
//------------------------------------------------
//����ģ��д�����ݵ�sdramģ��
wire syswr_done;		//��������д��sdram��ɱ�־λ
datagene			uut_datagene(
						.clk(clk_25m),
						.rst_n(sys_rst_n),
						.wrf_din(wrf_din),
						.wrf_wrreq(wrf_wrreq),
						.moni_addr(sys_addr),
						.syswr_done(syswr_done),
						.sdram_rd_ack(sdram_rd_ack)
					);


//------------------------------------------------
//�����������ݷ��Ϳ���ģ��
wire tx_start;		//���ڷ�������������־λ������Ч
uart_ctrl		uut_uartctrl(
					.clk(clk_25m),
					.rst_n(sys_rst_n),
					.tx_data(rdf_dout[7:0]),
					.tx_start(tx_start),		///////////
					.fifo232_rdreq(rdf_rdreq),
					.rs232_tx(rs232_tx)
					);

endmodule

`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////
// Company		: 
// Engineer		: ��Ȩ franchises3
// Create Date	: 2009.05.12
// Design Name	: 
// Module Name	: datagene
// Project Name	: 
// Target Device: Cyclone EP1C3T144C8 
// Tool versions: Quartus II 8.1
// Description	: ģ��д�����ݵ�sdramģ��
//				
// Revision		: V1.0
// Additional Comments	:  
// 
////////////////////////////////////////////////////////////////////////////////
module datagene(
				clk,rst_n,
				wrf_din,wrf_wrreq,
				moni_addr,syswr_done,
				sdram_rd_ack
			);

input clk;		//FPAG����ʱ���ź�25MHz
input rst_n;	//FPGA���븴λ�ź�

	//wrFIFO������ƽӿ�
output[15:0] wrf_din;		//sdram����д�뻺��FIFO������������
output wrf_wrreq;			//sdram����д�뻺��FIFO�����������󣬸���Ч

output[21:0] moni_addr;	//sdram��д��ַ����
output syswr_done;		//��������д��sdram��ɱ�־λ

input sdram_rd_ack;			//ϵͳ��SDRAM��Ӧ�ź�,��ΪrdFIFO����д��Ч�ź�,���ﲶ�������½�����Ϊ����ַ�����ӱ�־λ

reg sdr_rdackr1,sdr_rdackr2;

//------------------------------------------
//����sdram_rd_ack�½��ر�־λ
always @(posedge clk or negedge rst_n)		
		if(!rst_n) begin
				sdr_rdackr1 <= 1'b0;
				sdr_rdackr2 <= 1'b0;
			end
		else begin
				sdr_rdackr1 <= sdram_rd_ack;
				sdr_rdackr2 <= sdr_rdackr1;				
			end

wire neg_rdack = ~sdr_rdackr1 & sdr_rdackr2;

//------------------------------------------
//�ϵ�500us��ʱ�ȴ�sdram����
reg[13:0] delay;	//500us��ʱ������

always @(posedge clk or negedge rst_n)
	if(!rst_n) delay <= 14'd0;
	else if(delay < 14'd12500) delay <= delay+1'b1;

wire delay_done = (delay == 14'd12500);	//1ms��ʱ����

//------------------------------------------
//ÿ640nsд��8��16bit���ݵ�sdram��
//�ϵ�����е�ַд�����ʱ����Ҫ����360msʱ��
reg[5:0] cntwr;	//дsdram��ʱ������

always @(posedge clk or negedge rst_n)
	if(!rst_n) cntwr <= 6'd0;
	else if(delay_done) cntwr <= cntwr+1'b1;

//------------------------------------------
//��дsdram��ַ����
reg[18:0] addr;		//sdram��ַ�Ĵ���

always @(posedge clk or negedge rst_n)
	if(!rst_n) addr <= 19'd0;
	else if(!wr_done && cntwr == 6'h3f) addr <= addr+1'b1;//д��ַ����
	else if(wr_done && neg_rdack) addr <= addr+1'b1;	//����ַ����	////////////test

assign moni_addr = {addr,3'b000};

reg wr_done;	//��������д��sdram��ɱ�־λ
always @(posedge clk or negedge rst_n)
	if(!rst_n) wr_done <= 1'b0;
	else if(addr == 19'h7ffff) wr_done <= 1'b1;

assign syswr_done = wr_done;

//------------------------------------------
//дsdram�����źŲ�������wrfifo��д����Ч�ź�
reg wrf_wrreqr;		//wrfifo��д����Ч�ź�
reg[15:0] wrf_dinr;	//wrfifo��д������

always @(posedge clk or negedge rst_n)
	if(!rst_n) wrf_wrreqr <= 1'b0;
	else if(!wr_done) begin	//�ϵ�0.5ms��ʱ���
		if(cntwr == 6'h05) wrf_wrreqr <= 1'b1;	//д�����źŲ���
		else if(cntwr == 6'h0d) wrf_wrreqr <= 1'b0;	//�����źų���
	end

always @(posedge clk or negedge rst_n)
	if(!rst_n) wrf_dinr <= 16'd0;
	else if(!wr_done && ((cntwr > 6'h05) && (cntwr <= 6'h0d))) begin	//�ϵ�0.5ms��ʱ���
			wrf_dinr <= wrf_dinr+1'b1;	//д�����ݵ���
		end
	
assign wrf_wrreq = wrf_wrreqr;
assign wrf_din = wrf_dinr;


endmodule

`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////
// Company		: 
// Engineer		: ��Ȩ franchises3
// Create Date	: 2009.05.04
// Design Name	: 
// Module Name	: uart_speed_select
// Project Name	: sdrsvgaprj
// Target Device: Cyclone EP1C3T144C8 
// Tool versions: Quartus II 8.1
// Description	: �������ݷ��Ͳ����ʿ���ģ��
//				
// Revision		: V1.0
// Additional Comments	:  
// 
////////////////////////////////////////////////////////////////////////////////
module uart_speed_select(
				clk,rst_n,
				bps_start,clk_bps
			);

input clk;			// 25MHzʱ��
input rst_n;		//�͵�ƽ��λ�ź�
input bps_start;	//������ʱ�Ӽ����������źţ�����Ч
output clk_bps;		//�������ݱ�־λ������Ч

/*
`define 	bps9600 		5207/2	//������Ϊ9600bps
`define	 	bps19200 		2603/2	//������Ϊ19200bps
`define		bps38400 		1301/2	//������Ϊ38400bps
`define		bps57600 		867/2	//������Ϊ57600bps
`define		bps115200		433/2	//������Ϊ115200bps

`define 	bps9600_2 		2603/2
`define		bps19200_2		1301/2
`define		bps38400_2		650/2
`define		bps57600_2		433/2
`define		bps115200_2		216/2 
*/

	//���²����ʷ�Ƶ����ֵ�ɲ�������Ĳ������и���
`define		BPS_PARA		2604	//������Ϊ9600ʱ�ķ�Ƶ����ֵ
`define 	BPS_PARA_2		1302		//������Ϊ9600ʱ�ķ�Ƶ����ֵ��һ�룬�������ݲ���

//----------------------------------------------------------
//----------------------------------------------------------
reg[12:0] cnt;			//��Ƶ������
reg clk_bps_r;			//���������ݸı��־λ
reg[2:0] uart_ctrl;		// uart������ѡ��Ĵ���


always @ (posedge clk or negedge rst_n)
	if(!rst_n) cnt <= 13'd0;
	else if(cnt == `BPS_PARA) cnt <= 13'd0;	//�����ʼ������������
	else if(bps_start) cnt <= cnt+1'b1;		//������ʱ�Ӽ�������
	else cnt <= 13'd0;		//�����ʼ���ֹͣ

always @ (posedge clk or negedge rst_n)
	if(!rst_n) clk_bps_r <= 1'b0;
	else if(cnt == `BPS_PARA_2) clk_bps_r <= 1'b1;	// clk_bps_r�ߵ�ƽ��Ϊ�������ݵ����ݸı��
	else clk_bps_r <= 1'b0;

assign clk_bps = clk_bps_r;

endmodule




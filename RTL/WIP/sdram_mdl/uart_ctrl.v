`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////
// Company		: 
// Engineer		: ��Ȩ franchises3
// Create Date	: 2009.05.04
// Design Name	: 
// Module Name	: uart_ctrl
// Project Name	: sdrsvgaprj
// Target Device: Cyclone EP1C3T144C8 
// Tool versions: Quartus II 8.1
// Description	: �������ݷ��Ϳ���ģ��
//				
// Revision		: V1.0
// Additional Comments	:  
// 
////////////////////////////////////////////////////////////////////////////////
module uart_ctrl(
				clk,rst_n,
				tx_data,tx_start,
				fifo232_rdreq,
				rs232_tx
			);

input clk;			// 25MHz��ʱ��
input rst_n;		//�͵�ƽ��λ�ź�
input[7:0] tx_data;	//����������
input tx_start;		//���ڷ�������������־λ������Ч

output fifo232_rdreq;	//FIFO�������źţ�����Ч
output rs232_tx;		//RS232���������ź�

//----------------------------------------------------------------
	//���ڷ��͵ײ�ģ��ʹ��ڲ�����ѡ��ģ��ӿ�
wire clk_bps;		//�������ݱ�־λ������Ч
wire bps_start;		//������ʱ�Ӽ����������ź�,����Ч

//----------------------------------------------------------------
//�����������ݷ��͵ײ�ģ��
uart_tx		uut_tx(
				.clk(clk),
				.rst_n(rst_n),
				.tx_data(tx_data),
				.tx_start(tx_start),
				.clk_bps(clk_bps),
				.rs232_tx(rs232_tx),
				.bps_start(bps_start),
				.fifo232_rdreq(fifo232_rdreq)				
				);

//�����������ݷ��Ͳ����ʿ���ģ��
uart_speed_select		uut_ss(
							.clk(clk),
							.rst_n(rst_n),
							.bps_start(bps_start),
							.clk_bps(clk_bps)
							);


endmodule

`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////
// Company		: 
// Engineer		: ��Ȩ franchises3
// Create Date	: 2009.05.04
// Design Name	: 
// Module Name	: uart_tx
// Project Name	: sdrsvgaprj
// Target Device: Cyclone EP1C3T144C8 
// Tool versions: Quartus II 8.1
// Description	: �������ݷ��͵ײ�ģ��
//					1bit��ʼλ+8bit����+1bitֹͣλ
// Revision		: V1.0
// Additional Comments	:  
// 
////////////////////////////////////////////////////////////////////////////////
module uart_tx(
				clk,rst_n,
				tx_data,tx_start,clk_bps,
				rs232_tx,bps_start,fifo232_rdreq
			);

input clk;			// 25MHz��ʱ��
input rst_n;		//�͵�ƽ��λ�ź�
input[7:0] tx_data;	//����������
input tx_start;		//���ڷ�������������־λ������Ч
input clk_bps;		//�������ݱ�־λ������Ч

output rs232_tx;	// RS232���������ź�
output bps_start;	//������ʱ�Ӽ����������ź�,����Ч
output fifo232_rdreq;	//FIFO�������źţ�����Ч

//---------------------------------------------------------
reg tx_en;			//��������ʹ���źţ�����Ч
reg[3:0] num;

always @ (posedge clk or negedge rst_n)
	if(!rst_n) tx_en <= 1'b0;
	else if(num==4'd11) tx_en <= 1'b0;	//���ݷ������			
	else if(tx_start) tx_en <= 1'b1;	//���뷢������״̬��

assign bps_start = tx_en;

//tx_en���������ؼ�⣬��ΪFIFO��ʹ���ź�
reg tx_enr1,tx_enr2;	//tx_en�Ĵ���
always @(posedge clk or negedge rst_n)
	if(!rst_n) begin
			tx_enr1 <= 1'b1;
			tx_enr2 <= 1'b1;
		end
	else begin
			tx_enr1 <= tx_en;
			tx_enr2 <= tx_enr1;
		end

assign fifo232_rdreq = tx_enr1 & ~tx_enr2;	//tx_en�������ø�һ��ʱ������

//---------------------------------------------------------
reg rs232_tx_r;		// RS232���������ź�

always @ (posedge clk or negedge rst_n)
	if(!rst_n) begin
			num <= 4'd0;
			rs232_tx_r <= 1'b1;
		end
	else if(tx_en) begin
			if(clk_bps)	begin
					num <= num+1'b1;
					case (num)
						4'd0: rs232_tx_r <= 1'b0; 	//������ʼλ
						4'd1: rs232_tx_r <= tx_data[0];	//����bit0
						4'd2: rs232_tx_r <= tx_data[1];	//����bit1
						4'd3: rs232_tx_r <= tx_data[2];	//����bit2
						4'd4: rs232_tx_r <= tx_data[3];	//����bit3
						4'd5: rs232_tx_r <= tx_data[4];	//����bit4
						4'd6: rs232_tx_r <= tx_data[5];	//����bit5
						4'd7: rs232_tx_r <= tx_data[6];	//����bit6
						4'd8: rs232_tx_r <= tx_data[7];	//����bit7
						4'd9: rs232_tx_r <= 1'b1;	//���ͽ���λ
					 	default: rs232_tx_r <= 1'b1;
						endcase
				end
			else if(num==4'd11) num <= 4'd0;	//��λ,ʵ�ʷ���һ������ʱ��Ϊ10.5��������ʱ������
		end

assign rs232_tx = rs232_tx_r;



endmodule

//
//  Module: AHB decoder
//  (defined by ARM Design Kit Technical Reference Manual--AHB component)
//  Author: Lianghao Yuan
//  Email: yuanlianghao@gmail.com
//  Date: 07/13/2015
//  Description:
//  The system decoder decodes the address bus and generates select lines to
//  each of the system bus slaves, indicating that a read or write access to
//  that slave is required. The default configuration is 7 slots. No REMAP
//  signal implemented. 

`ifndef AHB_DECODER_V
`define AHB_DECODER_V

//`include "ahb_defines.v"

module ahb_decoder
(
  // -------------
  // Input pins //
  // -------------
  input [33:0] HADDR,
  // --------------
  // Output pins //
  // --------------
  output HSELx0,
  output HSELx7,
  output HSELx1,
  output HSELx2,
  output HSELx3,
  output HSELx4,
  output HSELx5,
  output HSELx6
);
	assign HSELx0=(HADDR[33:17]==17'h000);		//Page 0x0000_0000-0x0001_ffff 	(128KiB)
	assign HSELx7=(HADDR[33:17]==17'h001);     	//Page 0x0002_0000-0x0003_ffff 	(128KiB)
	assign HSELx1=(HADDR[33:17]==17'h7fe);		//Page 0x0ffc_0000-0x0ffd_ffff 	(128KiB)
	assign HSELx2=(HADDR[33:17]==17'h7ff);		//Page 0x0ffe_0000-0x0fff_ffff 	(128KiB)
	assign HSELx3=(HADDR[33:28]==6'h01);		//Page 0x1000_0000-0x1fff_ffff	(256MiB)
	assign HSELx4=(HADDR[33:28]==6'h07);		//Page 0x7000_0000-0x7fff_ffff	(256MiB)
	assign HSELx5=(HADDR[33:31]!=3'h0);			//Page 0x7000_0000-0x3_ffff_ffff(12GiB)
	assign HSELx6={HSELx0,HSELx1,HSELx2,HSELx3,HSELx4,HSELx5,HSELx7}==0;//Reserved
endmodule

`endif // AHB_DECODER_V

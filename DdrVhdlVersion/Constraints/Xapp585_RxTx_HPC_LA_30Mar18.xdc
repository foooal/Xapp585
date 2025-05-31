#--------------------------------------------------------------------------------------------
#-   ____  ____
#-  /   /\/   /
#- /___/  \  /
#- \   \   \/    © Copyright 2018 Xilinx, Inc. All rights reserved.
#-  \   \        This file contains confidential and proprietary information of Xilinx, Inc.
#-  /   /        and is protected under U.S. and international copyright and other
#- /___/   /\    intellectual property laws.
#- \   \  /
#-  \___\/\___
#-
#--------------------------------------------------------------------------------------------
#- Device:              7-Series, Zync
#- Author:              Defossez
#- Entity Name:         Xapp585_RxTx_HPC_LA_<date>
#- Purpose:             Constraint file for reference design of XAPP585 ported on
#-                      a KC705 board. Transmitter and receiver pins are output on
#-                      the FMC LPC connector and used with the XM107 loopback board.
#-
#- Tools:               Vivado_2017.4 or higher
#- Limitations:         none
#-
#- Vendor:              Xilinx Inc.
#- Version:
#- Filename:            Xapp585_RxTx_HPC_LA_<date>.xdc
#- Date Created:        Mar 2018
#- Date Last Modified:  Mar 2018
#--------------------------------------------------------------------------------------------
#- Disclaimer:
#-      This disclaimer is not a license and does not grant any rights to the materials
#-      distributed herewith. Except as otherwise provided in a valid license issued to you
#-      by Xilinx, and to the maximum extent permitted by applicable law: (1) THESE MATERIALS
#-      ARE MADE AVAILABLE "AS IS" AND WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL
#-      WARRANTIES AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING BUT NOT LIMITED
#-      TO WARRANTIES OF MERCHANTABILITY, NON-INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR
#-      PURPOSE; and (2) Xilinx shall not be liable (whether in contract or tort, including
#-      negligence, or under any other theory of liability) for any loss or damage of any
#-      kind or nature related to, arising under or in connection with these materials,
#-      including for any direct, or any indirect, special, incidental, or consequential
#-      loss or damage (including loss of data, profits, goodwill, or any type of loss or
#-      damage suffered as a result of any action brought by a third party) even if such
#-      damage or loss was reasonably foreseeable or Xilinx had been advised of the
#-      possibility of the same.
#-
#- CRITICAL APPLICATIONS
#-      Xilinx products are not designed or intended to be fail-safe, or for use in any
#-      application requiring fail-safe performance, such as life-support or safety devices
#-      or systems, Class III medical devices, nuclear facilities, applications related to
#-      the deployment of airbags, or any other applications that could lead to death,
#-      personal injury, or severe property or environmental damage (individually and
#-      collectively, "Critical Applications"). Customer assumes the sole risk and
#-      liability of any use of Xilinx products in Critical Applications, subject only to
#-      applicable laws and regulations governing limitations on product liability.
#-
#- THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS PART OF THIS FILE AT ALL TIMES.
#-
#- Contact:    e-mail  hotline@xilinx.com        phone   + 1 800 255 7778
#----------------------------------------------------------------------------------------------
#- Revision History:
#-  Rev. -
#----------------------------------------------------------------------------------------------
#- Pinout and possible loopback configurations of the XM107 mezzanine board.
#
# | FPGA Pin name      | FPGA | KC705 Net Names    | FMC  | FMC Pin      | <= | FMC Pin      | FMC | KC705 Net Names    | FPGA | FPGA Pin name      |
# |                    | Pin  |                    | Pin  |  Name        | => |  Name        | Pin |                    | Pin  |                    |
# |--------------------|------|--------------------|------|--------------|----|--------------|-----|--------------------|------|--------------------|
# | IO_L12P_T1_MRCC_16 | C25  | FMC_HPC_LA00_CC_P  |  G6  | LA00_CC_P    |    | LA17_CC_P    | D20 | FMC_HPC_LA17_CC_P  | F20  | IO_L12P_T1_MRCC_17 |
# | IO_L12N_T1_MRCC_16 | B25  | FMC_HPC_LA00_CC_N  |  G7  | LA00_CC_N    |    | LA17_CC_N    | D21 | FMC_HPC_LA17_CC_N  | E20  | IO_L12N_T1_MRCC_17 |
# | IO_L11P_T1_SRCC_16 | D26  | FMC_HPC_LA01_CC_P  |  D8  | LA01_CC_P    |    | LA18_CC_P    | C22 | FMC_HPC_LA18_CC_P  | F21  | IO_L11P_T1_SRCC_17 |
# | IO_L11N_T1_SRCC_16 | C26  | FMC_HPC_LA01_CC_N  |  D9  | LA01_CC_N    |    | LA18_CC_N    | C23 | FMC_HPC_LA18_CC_N  | E21  | IO_L11N_T1_SRCC_17 |
# | IO_L19P_T3_16      | H24  | FMC_HPC_LA02_P     |  H7  | LA02_P       |    | LA19_P       | H22 | FMC_HPC_LA19_P     | G18  | IO_L16P_T2_17      |
# | IO_L19N_T3_VREF_16 | H25  | FMC_HPC_LA02_N     |  H8  | LA02_N       |    | LA19_N       | H23 | FMC_HPC_LA19_N     | F18  | IO_L16N_T2_17      |
# | IO_L23P_T3_16      | H26  | FMC_HPC_LA03_P     |  G9  | LA03_P       |    | LA20_P       | G21 | FMC_HPC_LA20_P     | E19  | IO_L14P_T2_SRCC_17 |
# | IO_L23N_T3_16      | H27  | FMC_HPC_LA03_N     |  G10 | LA03_N       |    | LA20_N       | G22 | FMC_HPC_LA20_N     | D19  | IO_L14N_T2_SRCC_17 |
# | IO_L20P_T3_16      | G28  | FMC_HPC_LA04_P     |  H10 | LA04_P       |    | LA21_P       | H25 | FMC_HPC_LA21_P     | A20  | IO_L21P_T3_DQS_17  |
# | IO_L20N_T3_16      | F28  | FMC_HPC_LA04_N     |  H11 | LA04_N       |    | LA21_N       | H26 | FMC_HPC_LA21_N     | A21  | IO_L21N_T3_DQS_17  |
# | IO_L22P_T3_16      | G29  | FMC_HPC_LA05_P     |  D11 | LA05_P       |    | LA22_P       | G24 | FMC_HPC_LA22_P     | C20  | IO_L19P_T3_17      |
# | IO_L22N_T3_16      | F30  | FMC_HPC_LA05_N     |  D12 | LA05_N       |    | LA22_N       | G25 | FMC_HPC_LA22_N     | B20  | IO_L19N_T3_VREF_17 |
# | IO_L24P_T3_16      | H30  | FMC_HPC_LA06_P     |  C10 | LA06_P       |    | LA23_P       | D23 | FMC_HPC_LA23_P     | B22  | IO_L23P_T3_17      |
# | IO_L24N_T3_16      | G30  | FMC_HPC_LA06_N     |  C11 | LA06_N       |    | LA23_N       | D24 | FMC_HPC_LA23_N     | A22  | IO_L23N_T3_17      |
# | IO_L14P_T2_SRCC_16 | E28  | FMC_HPC_LA07_P     |  H13 | LA07_P       |    | LA24_P       | H28 | FMC_HPC_LA24_P     | A16  | IO_L20P_T3_17      |
# | IO_L14N_T2_SRCC_16 | D28  | FMC_HPC_LA07_N     |  H14 | LA07_N       |    | LA24_N       | H29 | FMC_HPC_LA24_N     | A17  | IO_L20N_T3_17      |
# | IO_L18P_T2_16      | E29  | FMC_HPC_LA08_P     |  G12 | LA08_P       |    | LA25_P       | G27 | FMC_HPC_LA25_P     | G17  | IO_L18P_T2_17      |
# | IO_L18N_T2_16      | E30  | FMC_HPC_LA08_N     |  G13 | LA08_N       |    | LA25_N       | G28 | FMC_HPC_LA25_N     | F17  | IO_L18N_T2_17      |
# | IO_L17P_T2_16      | B30  | FMC_HPC_LA09_P     |  D14 | LA09_P       |    | LA26_P       | D26 | FMC_HPC_LA26_P     | B18  | IO_L22P_T3_17      |
# | IO_L17N_T2_16      | A30  | FMC_HPC_LA09_N     |  D15 | LA09_N       |    | LA26_N       | D27 | FMC_HPC_LA26_N     | A18  | IO_L22N_T3_17      |
# | IO_L16P_T2_16      | D29  | FMC_HPC_LA10_P     |  C14 | LA10_P       |    | LA27_P       | C26 | FMC_HPC_LA27_P     | C19  | IO_L24P_T3_17      |
# | IO_L16N_T2_16      | C30  | FMC_HPC_LA10_N     |  C15 | LA10_N       |    | LA27_N       | C27 | FMC_HPC_LA27_N     | B19  | IO_L24N_T3_17      |
# | IO_L21P_T3_DQS_16  | G27  | FMC_HPC_LA11_P     |  H16 | LA11_P       |    | LA28_P       | H31 | FMC_HPC_LA28_P     | D16  | IO_L15P_T2_DQS_17  |
# | IO_L21N_T3_DQS_16  | F27  | FMC_HPC_LA11_N     |  H17 | LA11_N       |    | LA28_N       | H32 | FMC_HPC_LA28_N     | C16  | IO_L15N_T2_DQS_17  |
# | IO_L15P_T2_DQS_16  | C29  | FMC_HPC_LA12_P     |  G15 | LA12_P       |    | LA29_P       | G30 | FMC_HPC_LA29_P     | C17  | IO_L17P_T2_17      |
# | IO_L15N_T2_DQS_16  | B29  | FMC_HPC_LA12_N     |  G16 | LA12_N       |    | LA29_N       | G31 | FMC_HPC_LA29_N     | B17  | IO_L17N_T2_17      |
# | IO_L10P_T1_16      | A25  | FMC_HPC_LA13_P     |  D17 | LA13_P       |    | LA30_P       | H34 | FMC_HPC_LA30_P     | D22  | IO_L10P_T1_17      |
# | IO_L10N_T1_16      | A26  | FMC_HPC_LA13_N     |  D18 | LA13_N       |    | LA30_N       | H35 | FMC_HPC_LA30_N     | C22  | IO_L10N_T1_17      |
# | IO_L9P_T1_DQS_16   | B28  | FMC_HPC_LA14_P     |  C18 | LA14_P       |    | LA31_P       | G33 | FMC_HPC_LA31_P     | G22  | IO_L9P_T1_DQS_17   |
# | IO_L9N_T1_DQS_16   | A28  | FMC_HPC_LA14_N     |  C19 | LA14_N       |    | LA31_N       | G34 | FMC_HPC_LA31_N     | F22  | IO_L9N_T1_DQS_17   |
# | IO_L8P_T1_16       | C24  | FMC_HPC_LA15_P     |  H19 | LA15_P       |    | LA32_P       | H37 | FMC_HPC_LA32_P     | D21  | IO_L8P_T1_17       |
# | IO_L8N_T1_16       | B24  | FMC_HPC_LA15_N     |  H20 | LA15_N       |    | LA32_N       | H38 | FMC_HPC_LA32_N     | C21  | IO_L8N_T1_17       |
# | IO_L7P_T1_16       | B27  | FMC_HPC_LA16_P     |  G18 | LA16_P       |    | LA33_P       | G36 | FMC_HPC_LA33_P     | H21  | IO_L7P_T1_17       |
# | IO_L7N_T1_16       | A27  | FMC_HPC_LA16_N     |  G19 | LA16_N       |    | LA33_N       | G37 | FMC_HPC_LA33_N     | H22  | IO_L7N_T1_17       |
# |--------------------|------|--------------------|------|--------------|----|--------------|-----|--------------------|------|--------------------|
#-
# | FPGA Pin name      | FPGA | KC705 Net Names    | FMC  | FMC Pin      | <= | FMC Pin      | FMC | KC705 Net Names    | FPGA | FPGA Pin name      |
# |                    | Pin  |                    | Pin  |  Name        | => |  Name        | Pin |                    | Pin  |                    |
# |--------------------|------|--------------------|------|--------------|----|--------------|-----|--------------------|------|--------------------|
#   Clock from mezzanine board XM107 - Programmable via I2C
# |--------------------|------|--------------------|------|--------------|----|--------------|-----|--------------------|------|--------------------|
# | IO_L13P_T2_MRCC_16 | D27  | FMC_HPC_CLK0_M2C_P | H4   |  CLK0_M2C_P  |    |  CLK1_M2C_P  | G2  | FMC_HPC_CLK1_M2C_P | D17  | IO_L13P_T2_MRCC_17 |
# | IO_L13N_T2_MRCC_16 | C27  | FMC_HPC_CLK0_M2C_N | H5   |  CLK0_M2C_N  |    |  CLK1_M2C_N  | G3  | FMC_HPC_CLK1_M2C_N | D18  | IO_L13N_T2_MRCC_17 |
# |                    |      | FMC_HPC_IIC_SDA    | C31  |  SDA         |    |              |     |                    |      |                    |
# |                    |      | FMC_HPC_IIC_SCL    | C30  |  SCL         |    |              |     |                    |      |                    |
# |--------------------|------|--------------------|------|--------------|----|--------------|-----|--------------------|------|--------------------|
#   I2C pins.
# |--------------------|------|--------------------|------|--------------|----|--------------|-----|--------------------|------|--------------------|
# | IO_L4P_T0_AD9N_15  | L21  | IIC_SDA_MAIN       |      |              |    |              |     |                    |      |                    |
# | IO_L4N_T0_AD9N_15  | K21  | IIC_SCL_MAIN       |      |              |    |              |     |                    |      |                    |
# | IO_L21P_T3_DQS_15  | P23  | IIC_MUX_RESET_B    |      |              |    |              |     |                    |      |                    |
# |--------------------|------|--------------------|------|--------------|----|--------------|-----|--------------------|------|--------------------|
#-  On-board Si570 clock generator - Programmable via I2C (USER_CLOCK_SDA/SCL)
# |--------------------|------|--------------------|------|--------------|----|--------------|-----|--------------------|------|--------------------|
# | IO_L13P_T2_MRCC_15 | K28  | USER_CLOCK_P       |      |              |    |              |     |                    |      |                    |
# | IO_L13N_T2_MRCC_15 | K29  | USER_CLOCK_N       |      |              |    |              |     |                    |      |                    |
# |--------------------|------|--------------------|------|--------------|----|--------------|-----|--------------------|------|--------------------|
#   So called system clock of 200 MHz
# |--------------------|------|--------------------|------|--------------|----|--------------|-----|--------------------|------|--------------------|
# | IO_L12P_T1_MRCC_33 | AD12 | SYSCLK_P           |      |              |    |              |     |                    |      |                    |
# | IO_L12N_T1_MRCC_33 | AD11 | SYSCLK_N           |      |              |    |              |     |                    |      |                    |
# |--------------------|------|--------------------|------|--------------|----|--------------|-----|--------------------|------|--------------------|
#
#-
#---------------------------------------------------------------------------------------------
#- Pinning for the design
#---------------------------------------------------------------------------------------------
# IO-Bank 16 - TRANSMITTER
# Default IOSTANDARD = LVCMOS25
# Default VCCO = VADJ_FPGA
#---------------------------------------------------------------------------------------------
#- set_property PACKAGE_PIN G25     [get_ports  ];                #- IO_25_16
#- set_property PACKAGE_PIN G30     [get_ports  ];                #- IO_L24N_T3_16
#- set_property PACKAGE_PIN H30     [get_ports  ];                #- IO_L24P_T3_16
#- set_property PACKAGE_PIN H27     [get_ports  ];                #- IO_L23N_T3_16
#- set_property PACKAGE_PIN H26     [get_ports  ];                #- IO_L23P_T3_16
#- set_property PACKAGE_PIN F30     [get_ports  ];                #- IO_L22N_T3_16
#- set_property PACKAGE_PIN G29     [get_ports  ];                #- IO_L22P_T3_16
#- set_property PACKAGE_PIN F27     [get_ports  ];                #- IO_L21N_T3_DQS_16
#- set_property PACKAGE_PIN G27     [get_ports  ];                #- IO_L21P_T3_DQS_16
   set_property PACKAGE_PIN F28     [get_ports dataout2_n[4]   ]; #- IO_L20N_T3_16
   set_property PACKAGE_PIN G28     [get_ports dataout2_p[4]   ]; #- IO_L20P_T3_16
   set_property PACKAGE_PIN H25     [get_ports dataout1_n[4]   ]; #- IO_L19N_T3_VREF_16
   set_property PACKAGE_PIN H24     [get_ports dataout1_p[4]   ]; #- IO_L19P_T3_16
   set_property PACKAGE_PIN E30     [get_ports dataout2_n[3]   ]; #- IO_L18N_T2_16
   set_property PACKAGE_PIN E29     [get_ports dataout2_p[3]   ]; #- IO_L18P_T2_16
   set_property PACKAGE_PIN A30     [get_ports dataout2_n[2]   ]; #- IO_L17N_T2_16
   set_property PACKAGE_PIN B30     [get_ports dataout2_p[2]   ]; #- IO_L17P_T2_16
   set_property PACKAGE_PIN C30     [get_ports dataout1_n[3]   ]; #- IO_L16N_T2_16
   set_property PACKAGE_PIN D29     [get_ports dataout1_p[3]   ]; #- IO_L16P_T2_16
   set_property PACKAGE_PIN B29     [get_ports dataout1_n[2]   ]; #- IO_L15N_T2_DQS_16
   set_property PACKAGE_PIN C29     [get_ports dataout1_p[2]   ]; #- IO_L15P_T2_DQS_16
   set_property PACKAGE_PIN D28     [get_ports dataout2_n[1]   ]; #- IO_L14N_T2_SRCC_16
   set_property PACKAGE_PIN E28     [get_ports dataout2_p[1]   ]; #- IO_L14P_T2_SRCC_16
#- set_property PACKAGE_PIN C27     [get_ports  ];                #- IO_L13N_T2_MRCC_16
#- set_property PACKAGE_PIN D27     [get_ports  ];                #- IO_L13P_T2_MRCC_16
   set_property PACKAGE_PIN B25     [get_ports clkout1_n       ]; #- IO_L12N_T1_MRCC_16
   set_property PACKAGE_PIN C25     [get_ports clkout1_p       ]; #- IO_L12P_T1_MRCC_16
   set_property PACKAGE_PIN C26     [get_ports clkout2_n       ]; #- IO_L11N_T1_SRCC_16
   set_property PACKAGE_PIN D26     [get_ports clkout2_p       ]; #- IO_L11P_T1_SRCC_16
   set_property PACKAGE_PIN A26     [get_ports dataout1_n[1]   ]; #- IO_L10N_T1_16
   set_property PACKAGE_PIN A25     [get_ports dataout1_p[1]   ]; #- IO_L10P_T1_16
   set_property PACKAGE_PIN A28     [get_ports dataout2_n[0]   ]; #- IO_L9N_T1_DQS_16
   set_property PACKAGE_PIN B28     [get_ports dataout2_p[0]   ]; #- IO_L9P_T1_DQS_16
   set_property PACKAGE_PIN B24     [get_ports dataout1_n[0]   ]; #- IO_L8N_T1_16
   set_property PACKAGE_PIN C24     [get_ports dataout1_p[0]   ]; #- IO_L8P_T1_16
#- set_property PACKAGE_PIN A27     [get_ports  ];                #- IO_L7N_T1_16
#- set_property PACKAGE_PIN B27     [get_ports  ];                #- IO_L7P_T1_16
#- set_property PACKAGE_PIN G24     [get_ports  ];                #- IO_L6N_T0_VREF_16
#- set_property PACKAGE_PIN G23     [get_ports  ];                #- IO_L6P_T0_16
#- set_property PACKAGE_PIN E26     [get_ports  ];                #- IO_L5N_T0_16
#- set_property PACKAGE_PIN F26     [get_ports  ];                #- IO_L5P_T0_16
#- set_property PACKAGE_PIN D24     [get_ports  ];                #- IO_L4N_T0_16
#- set_property PACKAGE_PIN E24     [get_ports  ];                #- IO_L4P_T0_16
#- set_property PACKAGE_PIN E25     [get_ports  ];                #- IO_L3N_T0_DQS_16
#- set_property PACKAGE_PIN F25     [get_ports  ];                #- IO_L3P_T0_DQS_16
#- set_property PACKAGE_PIN D23     [get_ports  ];                #- IO_L2N_T0_16
#- set_property PACKAGE_PIN E23     [get_ports  ];                #- IO_L2P_T0_16
#- set_property PACKAGE_PIN A23     [get_ports  ];                #- IO_L1N_T0_16
#- set_property PACKAGE_PIN B23     [get_ports  ];                #- IO_L1P_T0_16
#- set_property PACKAGE_PIN F23     [get_ports  ];                #- IO_0_16
#---------------------------------------------------------------------------------------------
# IO-Bank 17 - RECEIVER
# Default IOSTANDARD = LVCMOS25
# Default VCCO = VADJ_FPGA
#---------------------------------------------------------------------------------------------
#- set_property PACKAGE_PIN E18     [get_ports  ];                #- IO_25_17
   set_property PACKAGE_PIN B19     [get_ports datain1_n[3]    ];  #- IO_L24N_T3_17
   set_property PACKAGE_PIN C19     [get_ports datain1_p[3]    ];  #- IO_L24P_T3_17
#- set_property PACKAGE_PIN A22     [get_ports  ];                #- IO_L23N_T3_17
#- set_property PACKAGE_PIN B22     [get_ports  ];                #- IO_L23P_T3_17
   set_property PACKAGE_PIN A18     [get_ports datain2_n[2]    ]; #- IO_L22N_T3_17
   set_property PACKAGE_PIN B18     [get_ports datain2_p[2]    ]; #- IO_L22P_T3_17
   set_property PACKAGE_PIN A21     [get_ports datain2_n[4]    ]; #- IO_L21N_T3_DQS_17
   set_property PACKAGE_PIN A20     [get_ports datain2_p[4]    ]; #- IO_L21P_T3_DQS_17
   set_property PACKAGE_PIN A17     [get_ports datain2_n[1]    ]; #- IO_L20N_T3_17
   set_property PACKAGE_PIN A16     [get_ports datain2_p[1]    ]; #- IO_L20P_T3_17
#- set_property PACKAGE_PIN B20     [get_ports   ];               #- IO_L19N_T3_VREF_17
#- set_property PACKAGE_PIN C20     [get_ports   ];               #- IO_L19P_T3_17
   set_property PACKAGE_PIN F17     [get_ports datain2_n[3]    ]; #- IO_L18N_T2_17
   set_property PACKAGE_PIN G17     [get_ports datain2_p[3]    ]; #- IO_L18P_T2_17
   set_property PACKAGE_PIN B17     [get_ports datain1_n[2]    ]; #- IO_L17N_T2_17
   set_property PACKAGE_PIN C17     [get_ports datain1_p[2]    ]; #- IO_L17P_T2_17
   set_property PACKAGE_PIN F18     [get_ports datain1_n[4]    ]; #- IO_L16N_T2_17
   set_property PACKAGE_PIN G18     [get_ports datain1_p[4]    ]; #- IO_L16P_T2_17
#- set_property PACKAGE_PIN C16     [get_ports   ];               #- IO_L15N_T2_DQS_17
#- set_property PACKAGE_PIN D16     [get_ports   ];               #- IO_L15P_T2_DQS_17
#- set_property PACKAGE_PIN D19     [get_ports   ];               #- IO_L14N_T2_SRCC_17
#- set_property PACKAGE_PIN E19     [get_ports   ];               #- IO_L14P_T2_SRCC_17
#- set_property PACKAGE_PIN D18     [get_ports   ];               #- IO_L13N_T2_MRCC_17
#- set_property PACKAGE_PIN D17     [get_ports   ];               #- IO_L13P_T2_MRCC_17
   set_property PACKAGE_PIN E20     [get_ports clkin1_n        ]; #- IO_L12N_T1_MRCC_17
   set_property PACKAGE_PIN F20     [get_ports clkin1_p        ]; #- IO_L12P_T1_MRCC_17
   set_property PACKAGE_PIN E21     [get_ports clkin2_n        ]; #- IO_L11N_T1_SRCC_17
   set_property PACKAGE_PIN F21     [get_ports clkin2_p        ]; #- IO_L11P_T1_SRCC_17
   set_property PACKAGE_PIN C22     [get_ports datain1_n[1]    ]; #- IO_L10N_T1_17
   set_property PACKAGE_PIN D22     [get_ports datain1_p[1]    ]; #- IO_L10P_T1_17
   set_property PACKAGE_PIN F22     [get_ports datain2_n[0]    ]; #- IO_L9N_T1_DQS_17
   set_property PACKAGE_PIN G22     [get_ports datain2_p[0]    ]; #- IO_L9P_T1_DQS_17
   set_property PACKAGE_PIN C21     [get_ports datain1_n[0]    ]; #- IO_L8N_T1_17
   set_property PACKAGE_PIN D21     [get_ports datain1_p[0]    ]; #- IO_L8P_T1_17
#- set_property PACKAGE_PIN H22     [get_ports  ];                #- IO_L7N_T1_17
#- set_property PACKAGE_PIN H21     [get_ports  ];                #- IO_L7P_T1_17
#- set_property PACKAGE_PIN K20     [get_ports  ];                #- IO_L6N_T0_VREF_17
#- set_property PACKAGE_PIN K19     [get_ports  ];                #- IO_L6P_T0_17
#- set_property PACKAGE_PIN L18     [get_ports  ];                #- IO_L5N_T0_17
#- set_property PACKAGE_PIN L17     [get_ports  ];                #- IO_L5P_T0_17
#- set_property PACKAGE_PIN H19     [get_ports  ];                #- IO_L4N_T0_17
#- set_property PACKAGE_PIN J19     [get_ports  ];                #- IO_L4P_T0_17
#- set_property PACKAGE_PIN H17     [get_ports  ];                #- IO_L3N_T0_DQS_17
#- set_property PACKAGE_PIN J17     [get_ports  ];                #- IO_L3P_T0_DQS_17
#- set_property PACKAGE_PIN G20     [get_ports  ];                #- IO_L2N_T0_17
#- set_property PACKAGE_PIN H20     [get_ports  ];                #- IO_L2P_T0_17
#- set_property PACKAGE_PIN J18     [get_ports  ];                #- IO_L1N_T0_17
#- set_property PACKAGE_PIN K18     [get_ports  ];                #- IO_L1P_T0_17
#- set_property PACKAGE_PIN G19     [get_ports  ];                #- IO_0_17
#---------------------------------------------------------------------------------------------
#
#---------------------------------------------------------------------------------------------
# TRANSMITTER IOSTANDARDS
#---------------------------------------------------------------------------------------------
   set_property IOSTANDARD  LVDS_25 [get_ports clkout1_p       ];
   set_property IOSTANDARD  LVDS_25 [get_ports clkout1_n       ];
   set_property IOSTANDARD  LVDS_25 [get_ports {dataout1_p[0]} ];
   set_property IOSTANDARD  LVDS_25 [get_ports {dataout1_n[0]} ];
   set_property IOSTANDARD  LVDS_25 [get_ports {dataout1_p[1]} ];
   set_property IOSTANDARD  LVDS_25 [get_ports {dataout1_n[1]} ];
   set_property IOSTANDARD  LVDS_25 [get_ports {dataout1_p[2]} ];
   set_property IOSTANDARD  LVDS_25 [get_ports {dataout1_n[2]} ];
   set_property IOSTANDARD  LVDS_25 [get_ports {dataout1_p[3]} ];
   set_property IOSTANDARD  LVDS_25 [get_ports {dataout1_n[3]} ];
   set_property IOSTANDARD  LVDS_25 [get_ports {dataout1_p[4]} ];
   set_property IOSTANDARD  LVDS_25 [get_ports {dataout1_n[4]} ];
   set_property IOSTANDARD  LVDS_25 [get_ports clkout2_p       ];
   set_property IOSTANDARD  LVDS_25 [get_ports clkout2_n       ];
   set_property IOSTANDARD  LVDS_25 [get_ports {dataout2_p[0]} ];
   set_property IOSTANDARD  LVDS_25 [get_ports {dataout2_n[0]} ];
   set_property IOSTANDARD  LVDS_25 [get_ports {dataout2_p[1]} ];
   set_property IOSTANDARD  LVDS_25 [get_ports {dataout2_n[1]} ];
   set_property IOSTANDARD  LVDS_25 [get_ports {dataout2_p[2]} ];
   set_property IOSTANDARD  LVDS_25 [get_ports {dataout2_n[2]} ];
   set_property IOSTANDARD  LVDS_25 [get_ports {dataout2_p[3]} ];
   set_property IOSTANDARD  LVDS_25 [get_ports {dataout2_n[3]} ];
   set_property IOSTANDARD  LVDS_25 [get_ports {dataout2_p[4]} ];
   set_property IOSTANDARD  LVDS_25 [get_ports {dataout2_n[4]} ];
   set_property IOSTANDARD  LVDS_25 [get_ports {Si570_to_sma_n}];
   set_property IOSTANDARD  LVDS_25 [get_ports {Si570_to_sma_p}];
#---------------------------------------------------------------------------------------------
# RECEIVER IOSTANDARDS
#---------------------------------------------------------------------------------------------
   set_property IOSTANDARD  LVDS_25 [get_ports clkin1_p        ];
   set_property IOSTANDARD  LVDS_25 [get_ports clkin1_n        ];
   set_property IOSTANDARD  LVDS_25 [get_ports {datain1_p[0]}  ];
   set_property IOSTANDARD  LVDS_25 [get_ports {datain1_n[0]}  ];
   set_property IOSTANDARD  LVDS_25 [get_ports {datain1_p[1]}  ];
   set_property IOSTANDARD  LVDS_25 [get_ports {datain1_n[1]}  ];
   set_property IOSTANDARD  LVDS_25 [get_ports {datain1_p[2]}  ];
   set_property IOSTANDARD  LVDS_25 [get_ports {datain1_n[2]}  ];
   set_property IOSTANDARD  LVDS_25 [get_ports {datain1_p[3]}  ];
   set_property IOSTANDARD  LVDS_25 [get_ports {datain1_n[3]}  ];
   set_property IOSTANDARD  LVDS_25 [get_ports {datain1_p[4]}  ];
   set_property IOSTANDARD  LVDS_25 [get_ports {datain1_n[4]}  ];
   set_property IOSTANDARD  LVDS_25 [get_ports clkin2_p        ];
   set_property IOSTANDARD  LVDS_25 [get_ports clkin2_n        ];
   set_property IOSTANDARD  LVDS_25 [get_ports {datain2_p[0]}  ];
   set_property IOSTANDARD  LVDS_25 [get_ports {datain2_n[0]}  ];
   set_property IOSTANDARD  LVDS_25 [get_ports {datain2_p[1]}  ];
   set_property IOSTANDARD  LVDS_25 [get_ports {datain2_n[1]}  ];
   set_property IOSTANDARD  LVDS_25 [get_ports {datain2_p[2]}  ];
   set_property IOSTANDARD  LVDS_25 [get_ports {datain2_n[2]}  ];
   set_property IOSTANDARD  LVDS_25 [get_ports {datain2_p[3]}  ];
   set_property IOSTANDARD  LVDS_25 [get_ports {datain2_n[3]}  ];
   set_property IOSTANDARD  LVDS_25 [get_ports {datain2_p[4]}  ];
   set_property IOSTANDARD  LVDS_25 [get_ports {datain2_n[4]}  ];
#
   set_property DIFF_TERM   TRUE    [get_ports clkin1_p        ];
   set_property DIFF_TERM   TRUE    [get_ports clkin1_n        ];
   set_property DIFF_TERM   TRUE    [get_ports {datain1_p[0]}  ];
   set_property DIFF_TERM   TRUE    [get_ports {datain1_n[0]}  ];
   set_property DIFF_TERM   TRUE    [get_ports {datain1_p[1]}  ];
   set_property DIFF_TERM   TRUE    [get_ports {datain1_n[1]}  ];
   set_property DIFF_TERM   TRUE    [get_ports {datain1_p[2]}  ];
   set_property DIFF_TERM   TRUE    [get_ports {datain1_n[2]}  ];
   set_property DIFF_TERM   TRUE    [get_ports {datain1_p[3]}  ];
   set_property DIFF_TERM   TRUE    [get_ports {datain1_n[3]}  ];
   set_property DIFF_TERM   TRUE    [get_ports {datain1_p[4]}  ];
   set_property DIFF_TERM   TRUE    [get_ports {datain1_n[4]}  ];
   set_property DIFF_TERM   TRUE    [get_ports clkin2_p        ];
   set_property DIFF_TERM   TRUE    [get_ports clkin2_n        ];
   set_property DIFF_TERM   TRUE    [get_ports {datain2_p[0]}  ];
   set_property DIFF_TERM   TRUE    [get_ports {datain2_n[0]}  ];
   set_property DIFF_TERM   TRUE    [get_ports {datain2_p[1]}  ];
   set_property DIFF_TERM   TRUE    [get_ports {datain2_n[1]}  ];
   set_property DIFF_TERM   TRUE    [get_ports {datain2_p[2]}  ];
   set_property DIFF_TERM   TRUE    [get_ports {datain2_n[2]}  ];
   set_property DIFF_TERM   TRUE    [get_ports {datain2_p[3]}  ];
   set_property DIFF_TERM   TRUE    [get_ports {datain2_n[3]}  ];
   set_property DIFF_TERM   TRUE    [get_ports {datain2_p[4]}  ];
   set_property DIFF_TERM   TRUE    [get_ports {datain2_n[4]}  ];
#
#---------------------------------------------------------------------------------------------
# EXTRA PINS
#---------------------------------------------------------------------------------------------
#- Reference clock of 200MHz (IO-Bank 33)
set_property PACKAGE_PIN AD11 [get_ports refclkin_n];
set_property PACKAGE_PIN AD12 [get_ports refclkin_p];
#-
#- LED
#- LED are located on FPGA pins:
#-      LED 7     6     5    4    3    2    1    0
#-          F16, E18, G19, AE26, AB9, AC9, AA8, AB8
set_property PACKAGE_PIN  AE26  [get_ports rx_dummy ];
#-
#- I2C Si570 oscillator
#- I2C_MAIN output of the FPGA (IO_Bank_15)
#- The I2C FPGA pins control all traffic on the KC705 board through a PCA9548ARGER (U49) device.
#- The PCA9548 I2C multiplexer accesses eight I2C trees.
set_property PACKAGE_PIN L21     [get_ports i2c_data ];
set_property PACKAGE_PIN K21     [get_ports i2c_clock];
#- set_property PACKAGE_PIN P23     [get_ports ] #- I2C_MUX_RESET_B
#-
#- There is a I2C Si570 oscillator available on the XM107 loopback board.
#- When that is used following pins are the clock input pins to the FPGA.
#-     These pins arrive to the FPGA from the HPC-FMC connector.
#- FPGA IO-Bank 16
#-set_property PACKAGE_PIN C27 [get_ports tx_freqgen_n  ]; #- IO_L13N_T2_MRCC_16 CLK0_M2C
#-set_property PACKAGE_PIN D27 [get_ports tx_freqgen_p  ]; #- IO_L13P_T2_MRCC_16 CLK0_M2C
#- FPGA IO-Bank 17
#-set_property PACKAGE_PIN D18 [get_ports   ]; #- IO_L13N_T2_MRCC_17 CLK1_M2C
#-set_property PACKAGE_PIN D17 [get_ports   ]; #- IO_L13P_T2_MRCC_17 CLK1_M2C
#-
#- There is a Si570 oscillator placed on the KC705 board.
#- When that is used the FPGA clock input pins are:
set_property PACKAGE_PIN K29     [get_ports tx_freqgen_n  ]; #- IO_L13N_T2_MRCC_15 CLK0_M2C
set_property PACKAGE_PIN K28     [get_ports tx_freqgen_p  ]; #- IO_L13P_T2_MRCC_15 CLK0_M2C
set_property IOSTANDARD  LVDS_25 [get_ports tx_freqgen_n  ];
set_property IOSTANDARD  LVDS_25 [get_ports tx_freqgen_p  ];
set_property DIFF_TERM      TRUE      [get_ports tx_freqgen_n  ];
set_property DIFF_TERM      TRUE      [get_ports tx_freqgen_p  ];
#-
#- SMA clock output
set_property PACKAGE_PIN Y24  [get_ports  Si570_to_sma_n ]; #- IO_L1N_T0_12
set_property PACKAGE_PIN Y23  [get_ports  Si570_to_sma_p ]; #- IO_L1P_T0_12
#---------------------------------------------------------------------------------------------
# LOGIC PLACEMENT
#---------------------------------------------------------------------------------------------
create_pblock Receiver
add_cells_to_pblock [get_pblocks Receiver] [get_cells \
    [list \
        */Rxd \
        */Rxd/loop1.loop0[1].rxn \
        */Rxd/loop1.loop0[1].rxn/gb0 \
        */Rxd/loop1.loop0[1].rxn/loop3[0].dc_inst \
        */Rxd/rx0 \
        */Rxd/rx0/gb0 \
        */Rxd/rx0/loop3[0].dc_inst
    ]]
resize_pblock [get_pblocks Receiver] -add {SLICE_X0Y250:SLICE_X13Y299}
resize_pblock [get_pblocks Receiver] -add {MMCME2_ADV_X0Y5}
#-
create_pblock Transmitter
add_cells_to_pblock [get_pblocks Transmitter] [get_cells \
    [list \
        */Txd \
        */Txd/clkgen \
        */Txd/dataout
    ]]
resize_pblock [get_pblocks Transmitter] -add {SLICE_X0Y200:SLICE_X13Y249}
resize_pblock [get_pblocks Transmitter] -add {MMCME2_ADV_X0Y4}
#- This signal is add in the design as debug signal, and can be removed in a real design.
#- For the reference design to work, below constraint is necessary.
set_property CLOCK_DEDICATED_ROUTE BACKBONE [get_nets */Txd/clkgen/clkint]
#-
create_pblock CtrlVio
add_cells_to_pblock [get_pblocks CtrlVio] [get_cells \
    [list \
        Gen_10.ctrl_vio
       ]]
resize_pblock [get_pblocks CtrlVio] -add {SLICE_X14Y200:SLICE_X25Y299}
#-
create_pblock CtrlIla
add_cells_to_pblock [get_pblocks CtrlIla] [get_cells \
    [list \
        Gen_12.ctrl_ila
    ]]
resize_pblock [get_pblocks CtrlIla] -add {SLICE_X30Y250:SLICE_X55Y299}
#-
#---------------------------------------------------------------------------------------------
#- The End ..........
#---------------------------------------------------------------------------------------------

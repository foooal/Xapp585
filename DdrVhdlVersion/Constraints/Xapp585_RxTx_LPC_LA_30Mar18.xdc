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
#- Entity Name:         Xapp585_RxTx_LPC_LA_<date>
#- Purpose:             Constraint file for reference design of XAPP585 ported on
#-                      a KC705 board. Transmitter and receiver pins are output on
#-                      the FMC LPC connector and used with the XM107 loopback board.
#-
#- Tools:               Vivado_2017.4 or higher
#- Limitations:         none
#-
#- Vendor:              Xilinx Inc.
#- Version:
#- Filename:            Xapp585_RxTx_LPC_LA_<date>.xdc
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
# | FPGA Pin name      | FPGA | KC705 Net Names    | FMC  | FMC Pin Name | <= | FMC Pin Name | FMC | KC705 Net Names    | FPGA | FPGA Pin name      |
# |                    | Pin  |                    | Pin  |              | => |              | Pin |                    | Pin  |                    |
# |--------------------|------|--------------------|------|--------------|----|--------------|-----|--------------------|------|--------------------|
# | IO_L12P_T1_MRCC_12 | AD23 | FMC_LPC_LA00_CC_P  | G6   |  LA00_CC_P   |    |  LA17_CC_P   | D20 | FMC_LPC_LA17_CC_P  | AB27 | IO_L12P_T1_MRCC_13 |
# | IO_L12N_T1_MRCC_12 | AE24 | FMC_LPC_LA00_CC_N  | G7   |  LA00_CC_N   |    |  LA17_CC_N   | D21 | FMC_LPC_LA17_CC_N  | AC27 | IO_L12N_T1_MRCC_13 |
# | IO_L11P_T1_SRCC_12 | AE23 | FMC_LPC_LA01_CC_P  | D8   |  LA01_CC_P   |    |  LA18_CC_P   | C22 | FMC_LPC_LA18_CC_P  | AD27 | IO_L11P_T1_SRCC_13 |
# | IO_L11N_T1_SRCC_12 | AF23 | FMC_LPC_LA01_CC_N  | D9   |  LA01_CC_N   |    |  LA18_CC_N   | C23 | FMC_LPC_LA18_CC_N  | AD28 | IO_L11N_T1_SRCC_13 |
# | IO_L19P_T3_12      | AF20 | FMC_LPC_LA02_P     | H7   |  LA02_P      |    |  LA19_P      | H22 | FMC_LPC_LA19_P     | AJ26 | IO_L24P_T3_13      |
# | IO_L19N_T3_VREF_12 | AF21 | FMC_LPC_LA02_N     | H8   |  LA02_N      |    |  LA19_N      | H23 | FMC_LPC_LA19_N     | AK26 | IO_L24N_T3_13      |
# | IO_L22P_T3_12      | AG20 | FMC_LPC_LA03_P     | G9   |  LA03_P      |    |  LA20_P      | G21 | FMC_LPC_LA20_P     | AF26 | IO_L23P_T3_13      |
# | IO_L22N_T3_12      | AH20 | FMC_LPC_LA03_N     | G10  |  LA03_N      |    |  LA20_N      | G22 | FMC_LPC_LA20_N     | AF27 | IO_L23N_T3_13      |
# | IO_L23P_T3_12      | AH21 | FMC_LPC_LA04_P     | H10  |  LA04_P      |    |  LA21_P      | H25 | FMC_LPC_LA21_P     | AG27 | IO_L21P_T3_DQS_13  |
# | IO_L23N_T3_12      | AJ21 | FMC_LPC_LA04_N     | H11  |  LA04_N      |    |  LA21_N      | H26 | FMC_LPC_LA21_N     | AG28 | IO_L21N_T3_DQS_13  |
# | IO_L20P_T3_12      | AG22 | FMC_LPC_LA05_P     | D11  |  LA05_P      |    |  LA22_P      | G24 | FMC_LPC_LA22_P     | AJ27 | IO_L20P_T3_13      |
# | IO_L20N_T3_12      | AH22 | FMC_LPC_LA05_N     | D12  |  LA05_N      |    |  LA22_N      | G25 | FMC_LPC_LA22_N     | AK28 | IO_L20N_T3_13      |
# | IO_L24P_T3_12      | AK20 | FMC_LPC_LA06_P     | C10  |  LA06_P      |    |  LA23_P      | D23 | FMC_LPC_LA23_P     | AH26 | IO_L22P_T3_13      |
# | IO_L24N_T3_12      | AK21 | FMC_LPC_LA06_N     | C11  |  LA06_N      |    |  LA23_N      | D24 | FMC_LPC_LA23_N     | AH27 | IO_L22N_T3_13      |
# | IO_L18P_T2_12      | AG25 | FMC_LPC_LA07_P     | H13  |  LA07_P      |    |  LA24_P      | H28 | FMC_LPC_LA24_P     | AG30 | IO_L18P_T2_13      |
# | IO_L18N_T2_12      | AH25 | FMC_LPC_LA07_N     | H14  |  LA07_N      |    |  LA24_N      | H29 | FMC_LPC_LA24_N     | AH30 | IO_L18N_T2_13      |
# | IO_L21P_T3_DQS_12  | AJ22 | FMC_LPC_LA08_P     | G12  |  LA08_P      |    |  LA25_P      | G27 | FMC_LPC_LA25_P     | AC26 | IO_L19P_T3_13      |
# | IO_L21N_T3_DQS_12  | AJ23 | FMC_LPC_LA08_N     | G13  |  LA08_N      |    |  LA25_N      | G28 | FMC_LPC_LA25_N     | AD26 | IO_L19N_T3_VREF_13 |
# | IO_L17P_T2_12      | AK23 | FMC_LPC_LA09_P     | D14  |  LA09_P      |    |  LA26_P      | D26 | FMC_LPC_LA26_P     | AK29 | IO_L15P_T2_DQS_13  |
# | IO_L17N_T2_12      | AK24 | FMC_LPC_LA09_N     | D15  |  LA09_N      |    |  LA26_N      | D27 | FMC_LPC_LA26_N     | AK30 | IO_L15N_T2_DQS_13  |
# | IO_L15P_T2_DQS_12  | AJ24 | FMC_LPC_LA10_P     | C14  |  LA10_P      |    |  LA27_P      | C26 | FMC_LPC_LA27_P     | AJ28 | IO_L17P_T2_13      |
# | IO_L15N_T2_DQS_12  | AK25 | FMC_LPC_LA10_N     | C15  |  LA10_N      |    |  LA27_N      | C27 | FMC_LPC_LA27_N     | AJ29 | IO_L17N_T2_13      |
# | IO_L16P_T2_12      | AE25 | FMC_LPC_LA11_P     | H16  |  LA11_P      |    |  LA28_P      | H31 | FMC_LPC_LA28_P     | AE30 | IO_L16P_T2_13      |
# | IO_L16N_T2_12      | AF25 | FMC_LPC_LA11_N     | H17  |  LA11_N      |    |  LA28_N      | H32 | FMC_LPC_LA28_N     | AF30 | IO_L16N_T2_13      |
# | IO_L6P_T0_12       | AA20 | FMC_LPC_LA12_P     | G15  |  LA12_P      |    |  LA29_P      | G30 | FMC_LPC_LA29_P     | AE28 | IO_L14P_T2_SRCC_13 |
# | IO_L6N_T0_VREF_12  | AB20 | FMC_LPC_LA12_N     | G16  |  LA12_N      |    |  LA29_N      | G31 | FMC_LPC_LA29_N     | AF28 | IO_L14N_T2_SRCC_13 |
# | IO_L7P_T1_12       | AB24 | FMC_LPC_LA13_P     | D17  |  LA13_P      |    |  LA30_P      | H34 | FMC_LPC_LA30_P     | AB29 | IO_L10P_T1_13      |
# | IO_L7N_T1_12       | AC25 | FMC_LPC_LA13_N     | D18  |  LA13_N      |    |  LA30_N      | H35 | FMC_LPC_LA30_N     | AB30 | IO_L10N_T1_13      |
# | IO_L10P_T1_12      | AD21 | FMC_LPC_LA14_P     | C18  |  LA14_P      |    |  LA31_P      | G33 | FMC_LPC_LA31_P     | AD29 | IO_L9P_T1_DQS_13   |
# | IO_L10N_T1_12      | AE21 | FMC_LPC_LA14_N     | C19  |  LA14_N      |    |  LA31_N      | G34 | FMC_LPC_LA31_N     | AE29 | IO_L9N_T1_DQS_13   |
# | IO_L9P_T1_DQS_12   | AC24 | FMC_LPC_LA15_P     | H19  |  LA15_P      |    |  LA32_P      | H37 | FMC_LPC_LA32_P     | Y30  | IO_L8P_T1_13       |
# | IO_L9N_T1_DQS_12   | AD24 | FMC_LPC_LA15_N     | H20  |  LA15_N      |    |  LA32_N      | H38 | FMC_LPC_LA32_N     | AA30 | IO_L8N_T1_13       |
# | IO_L8P_T1_12       | AC22 | FMC_LPC_LA16_P     | G18  |  LA16_P      |    |  LA33_P      | G36 | FMC_LPC_LA33_P     | AC29 | IO_L7P_T1_13       |
# | IO_L8N_T1_12       | AD22 | FMC_LPC_LA16_N     | G19  |  LA16_N      |    |  LA33_N      | G37 | FMC_LPC_LA33_N     | AC30 | IO_L7N_T1_13       |
# |--------------------|------|--------------------|------|--------------|----|--------------|-----|--------------------|------|--------------------|
#-
# | FPGA Pin name      | FPGA | KC705 Net Names    | FMC  | FMC Pin      | <= | FMC Pin      | FMC | KC705 Net Names    | FPGA | FPGA Pin name      |
# |                    | Pin  |                    | Pin  |  Name        | => |  Name        | Pin |                    | Pin  |                    |
# |--------------------|------|--------------------|------|--------------|----|--------------|-----|--------------------|------|--------------------|
#   Clock from mezzanine board XM107 - Programmable via I2C
# |--------------------|------|--------------------|------|--------------|----|--------------|-----|--------------------|------|--------------------|
# | IO_L13P_T2_MRCC_12 | AF22 | FMC_LPC_CLK0_M2C_P | H4   |  CLK0_M2C_P  |    |  CLK1_M2C_P  | G2  | FMC_LPC_CLK1_M2C_P | AG29 | IO_L13P_T2_MRCC_13 |
# | IO_L13N_T2_MRCC_12 | AG23 | FMC_LPC_CLK0_M2C_N | H5   |  CLK0_M2C_N  |    |  CLK1_M2C_N  | G3  | FMC_LPC_CLK1_M2C_N | AH29 | IO_L13N_T2_MRCC_13 |
# |                    |      | FMC_LPC_IIC_SDA    | C31  |  SDA         |    |              |     |                    |      |                    |
# |                    |      | FMC_LPC_IIC_SCL    | C30  |  SCL         |    |              |     |                    |      |                    |
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
#-
#---------------------------------------------------------------------------------------------
#- Pinning for the design
#---------------------------------------------------------------------------------------------
# IO-Bank 12 - TRANSMITTER
# Default IOSTANDARD = LVCMOS25
# Default VCCO = VADJ_FPGA
#---------------------------------------------------------------------------------------------
#- set_property PACKAGE_PIN AE20    [get_ports  ];               # IO_25_12           -- SI5326_RST_LS
#- set_property PACKAGE_PIN AK21    [get_ports  ];               # IO_L24N_T3_12      -- FMC_LPC_LA06_N
#- set_property PACKAGE_PIN AK20    [get_ports  ];               # IO_L24P_T3_12      -- FMC_LPC_LA06_P
#- set_property PACKAGE_PIN AJ21    [get_ports  ];               # IO_L23N_T3_12      -- FMC_LPC_LA04_N
#- set_property PACKAGE_PIN AH21    [get_ports  ];               # IO_L23P_T3_12      -- FMC_LPC_LA04_P
#- set_property PACKAGE_PIN AH20    [get_ports  ];               # IO_L22N_T3_12      -- FMC_LPC_LA03_N
#- set_property PACKAGE_PIN AG20    [get_ports  ];               # IO_L22P_T3_12      -- FMC_LPC_LA03_P
   set_property PACKAGE_PIN AJ23    [get_ports dataout2_n[4]  ]; # IO_L21N_T3_DQS_12  -- FMC_LPC_LA08_N
   set_property PACKAGE_PIN AJ22    [get_ports dataout2_p[4]  ]; # IO_L21P_T3_DQS_12  -- FMC_LPC_LA08_P
   set_property PACKAGE_PIN AH22    [get_ports dataout1_n[4]  ]; # IO_L20N_T3_12      -- FMC_LPC_LA05_N
   set_property PACKAGE_PIN AG22    [get_ports dataout1_p[4]  ]; # IO_L20P_T3_12      -- FMC_LPC_LA05_P
   set_property PACKAGE_PIN AF21    [get_ports dataout2_n[3]  ]; # IO_L19N_T3_VREF_12 -- FMC_LPC_LA02_N
   set_property PACKAGE_PIN AF20    [get_ports dataout2_p[3]  ]; # IO_L19P_T3_12      -- FMC_LPC_LA02_P
   set_property PACKAGE_PIN AH25    [get_ports dataout2_n[2]  ]; # IO_L18N_T2_12      -- FMC_LPC_LA07_N
   set_property PACKAGE_PIN AG25    [get_ports dataout2_p[2]  ]; # IO_L18P_T2_12      -- FMC_LPC_LA07_P
   set_property PACKAGE_PIN AK24    [get_ports dataout1_n[3]  ]; # IO_L17N_T2_12      -- FMC_LPC_LA09_N
   set_property PACKAGE_PIN AK23    [get_ports dataout1_p[3]  ]; # IO_L17P_T2_12      -- FMC_LPC_LA09_P
   set_property PACKAGE_PIN AF25    [get_ports dataout1_n[2]  ]; # IO_L16N_T2_12      -- FMC_LPC_LA11_N
   set_property PACKAGE_PIN AE25    [get_ports dataout1_p[2]  ]; # IO_L16P_T2_12      -- FMC_LPC_LA11_P
   set_property PACKAGE_PIN AK25    [get_ports dataout2_n[1]  ]; # IO_L15N_T2_DQS_12  -- FMC_LPC_LA10_N
   set_property PACKAGE_PIN AJ24    [get_ports dataout2_p[1]  ]; # IO_L15P_T2_DQS_12  -- FMC_LPC_LA10_P
#- set_property PACKAGE_PIN AH24    [get_ports  ];               # IO_L14N_T2_SRCC_12 -- HDMI_INT
#- set_property PACKAGE_PIN AG24    [get_ports  ];               # IO_L14P_T2_SRCC_12 -- SI5326_INT_ALM_LS
#- set_property PACKAGE_PIN AG23    [get_ports tx_freqgen_n   ]; # IO_L13N_T2_MRCC_12 -- FMC_LPC_CLK0_M2C_N
#- set_property PACKAGE_PIN AF22    [get_ports tx_freqgen_p   ]; # IO_L13P_T2_MRCC_12 -- FMC_LPC_CLK0_M2C_P
   set_property PACKAGE_PIN AE24    [get_ports clkout1_n      ]; # IO_L12N_T1_MRCC_12 -- FMC_LPC_LA00_CC_N
   set_property PACKAGE_PIN AD23    [get_ports clkout1_p      ]; # IO_L12P_T1_MRCC_12 -- FMC_LPC_LA00_CC_P
   set_property PACKAGE_PIN AF23    [get_ports clkout2_n      ]; # IO_L11N_T1_SRCC_12 -- FMC_LPC_LA01_CC_N
   set_property PACKAGE_PIN AE23    [get_ports clkout2_p      ]; # IO_L11P_T1_SRCC_12 -- FMC_LPC_LA01_CC_P
   set_property PACKAGE_PIN AE21    [get_ports dataout1_n[1]  ]; # IO_L10N_T1_12      -- FMC_LPC_LA14_N
   set_property PACKAGE_PIN AD21    [get_ports dataout1_p[1]  ]; # IO_L10P_T1_12      -- FMC_LPC_LA14_P
   set_property PACKAGE_PIN AD24    [get_ports dataout2_n[0]  ]; # IO_L9N_T1_DQS_12   -- FMC_LPC_LA15_N
   set_property PACKAGE_PIN AC24    [get_ports dataout2_p[0]  ]; # IO_L9P_T1_DQS_12   -- FMC_LPC_LA15_P
   set_property PACKAGE_PIN AD22    [get_ports dataout1_n[0]  ]; # IO_L8N_T1_12       -- FMC_LPC_LA16_N
   set_property PACKAGE_PIN AC22    [get_ports dataout1_p[0]  ]; # IO_L8P_T1_12       -- FMC_LPC_LA16_P
#- set_property PACKAGE_PIN AC25    [get_ports  ];               # IO_L7N_T1_12       -- FMC_LPC_LA13_N
#- set_property PACKAGE_PIN AB24    [get_ports  ];               # IO_L7P_T1_12       -- FMC_LPC_LA13_P
#- set_property PACKAGE_PIN AB20    [get_ports  ];               # IO_L6N_T0_VREF_12  -- FMC_LPC_LA12_N
#- set_property PACKAGE_PIN AA20    [get_ports  ];               # IO_L6P_T0_12       -- FMC_LPC_LA12_P
#- set_property PACKAGE_PIN AC21    [get_ports  ];               # IO_L5N_T0_12       -- SDIO_CD_DAT3_LS
#- set_property PACKAGE_PIN AC20    [get_ports  ];               # IO_L5P_T0_12       -- SDIO_DAT0_LS
#- set_property PACKAGE_PIN AA23    [get_ports  ];               # IO_L4N_T0_12       -- SDIO_DAT1_LS
#- set_property PACKAGE_PIN AA22    [get_ports  ];               # IO_L4P_T0_12       -- SDIO_DAT2_LS
#- set_property PACKAGE_PIN AB23    [get_ports  ];               # IO_L3N_T0_DQS_12   -- SDIO_CLK_LS
#- set_property PACKAGE_PIN AB22    [get_ports  ];               # IO_L3P_T0_DQS_12   -- SDIO_CMD_LS
#- set_property PACKAGE_PIN AA21    [get_ports  ];               # IO_L2N_T0_12       -- SDIO_SDDET
#- set_property PACKAGE_PIN Y21     [get_ports  ];               # IO_L2P_T0_12       -- SDIO_SDWP
   set_property PACKAGE_PIN Y24     [get_ports Si570_to_sma_n ]; # IO_L1N_T0_12       -- USER_SMA_GPIO_N
   set_property PACKAGE_PIN Y23     [get_ports Si570_to_sma_p ]; # IO_L1P_T0_12       -- USER_SMA_GPIO_P
#- set_property PACKAGE_PIN Y20     [get_ports  ];               # IO_0_12            -- SFP_TX_DISABLE
#---------------------------------------------------------------------------------------------
# IO-Bank 13 - RECEIVER
# Default IOSTANDARD = LVCMOS25
# Default VCCO = VADJ_FPGA
#---------------------------------------------------------------------------------------------
#- set_property PACKAGE_PIN AE26    [get_ports   ];              # IO_25_13           -- GPIO_LED_4_LS
   set_property PACKAGE_PIN AK26    [get_ports datain2_n[3]   ]; # IO_L24N_T3_13      -- FMC_LPC_LA19_N
   set_property PACKAGE_PIN AJ26    [get_ports datain2_p[3]   ]; # IO_L24P_T3_13      -- FMC_LPC_LA19_P
#- set_property PACKAGE_PIN AF27    [get_ports   ];              # IO_L23N_T3_13      -- FMC_LPC_LA20_N
#- set_property PACKAGE_PIN AF26    [get_ports   ];              # IO_L23P_T3_13      -- FMC_LPC_LA20_P
#- set_property PACKAGE_PIN AH27    [get_ports   ];              # IO_L22N_T3_13      -- FMC_LPC_LA23_N
#- set_property PACKAGE_PIN AH26    [get_ports   ];              # IO_L22P_T3_13      -- FMC_LPC_LA23_P
#- set_property PACKAGE_PIN AG28    [get_ports   ];              # IO_L21N_T3_DQS_13  -- FMC_LPC_LA21_N
#- set_property PACKAGE_PIN AG27    [get_ports   ];              # IO_L21P_T3_DQS_13  -- FMC_LPC_LA21_P
   set_property PACKAGE_PIN AK28    [get_ports datain1_n[4]   ]; # IO_L20N_T3_13      -- FMC_LPC_LA22_N
   set_property PACKAGE_PIN AJ27    [get_ports datain1_p[4]   ]; # IO_L20P_T3_13      -- FMC_LPC_LA22_P
   set_property PACKAGE_PIN AD26    [get_ports datain2_n[4]   ]; # IO_L19N_T3_VREF_13 -- FMC_LPC_LA25_N
   set_property PACKAGE_PIN AC26    [get_ports datain2_p[4]   ]; # IO_L19P_T3_13      -- FMC_LPC_LA25_P
   set_property PACKAGE_PIN AH30    [get_ports datain2_n[2]   ]; # IO_L18N_T2_13      -- FMC_LPC_LA24_N
   set_property PACKAGE_PIN AG30    [get_ports datain2_p[2]   ]; # IO_L18P_T2_13      -- FMC_LPC_LA24_P
   set_property PACKAGE_PIN AJ29    [get_ports datain2_n[1]   ]; # IO_L17N_T2_13      -- FMC_LPC_LA27_N
   set_property PACKAGE_PIN AJ28    [get_ports datain2_p[1]   ]; # IO_L17P_T2_13      -- FMC_LPC_LA27_P
   set_property PACKAGE_PIN AF30    [get_ports datain1_n[2]   ]; # IO_L16N_T2_13      -- FMC_LPC_LA28_N
   set_property PACKAGE_PIN AE30    [get_ports datain1_p[2]   ]; # IO_L16P_T2_13      -- FMC_LPC_LA28_P
   set_property PACKAGE_PIN AK30    [get_ports datain1_n[3]   ]; # IO_L15N_T2_DQS_13  -- FMC_LPC_LA26_N
   set_property PACKAGE_PIN AK29    [get_ports datain1_p[3]   ]; # IO_L15P_T2_DQS_13  -- FMC_LPC_LA26_P
#- set_property PACKAGE_PIN AF28    [get_ports   ];              # IO_L14N_T2_SRCC_13 -- FMC_LPC_LA29_N
#- set_property PACKAGE_PIN AE28    [get_ports   ];              # IO_L14P_T2_SRCC_13 -- FMC_LPC_LA29_P
#- set_property PACKAGE_PIN AH29    [get_ports   ];              # IO_L13N_T2_MRCC_13 -- FMC_LPC_CLK1_M2C_N
#- set_property PACKAGE_PIN AG29    [get_ports   ];              # IO_L13P_T2_MRCC_13 -- FMC_LPC_CLK1_M2C_P
   set_property PACKAGE_PIN AC27    [get_ports clkin1_n       ]; # IO_L12N_T1_MRCC_13 -- FMC_LPC_LA17_CC_N
   set_property PACKAGE_PIN AB27    [get_ports clkin1_p       ]; # IO_L12P_T1_MRCC_13 -- FMC_LPC_LA17_CC_P
   set_property PACKAGE_PIN AD28    [get_ports clkin2_n       ]; # IO_L11N_T1_SRCC_13 -- FMC_LPC_LA18_CC_N
   set_property PACKAGE_PIN AD27    [get_ports clkin2_p       ]; # IO_L11P_T1_SRCC_13 -- FMC_LPC_LA18_CC_P
#- set_property PACKAGE_PIN AB30    [get_ports   ];              # IO_L10N_T1_13      -- FMC_LPC_LA30_N
#- set_property PACKAGE_PIN AB29    [get_ports   ];              # IO_L10P_T1_13      -- FMC_LPC_LA30_P
   set_property PACKAGE_PIN AE29    [get_ports datain1_n[1]   ]; # IO_L9N_T1_DQS_13   -- FMC_LPC_LA31_N
   set_property PACKAGE_PIN AD29    [get_ports datain1_p[1]   ]; # IO_L9P_T1_DQS_13   -- FMC_LPC_LA31_P
   set_property PACKAGE_PIN AA30    [get_ports datain2_n[0]   ]; # IO_L8N_T1_13       -- FMC_LPC_LA32_N
   set_property PACKAGE_PIN Y30     [get_ports datain2_p[0]   ]; # IO_L8P_T1_13       -- FMC_LPC_LA32_P
   set_property PACKAGE_PIN AC30    [get_ports datain1_n[0]   ]; # IO_L7N_T1_13       -- FMC_LPC_LA33_N
   set_property PACKAGE_PIN AC29    [get_ports datain1_p[0]   ]; # IO_L7P_T1_13       -- FMC_LPC_LA33_P
#- set_property PACKAGE_PIN AB25    [get_ports   ];              # IO_L6N_T0_VREF_13  -- XADC_GPIO_0
#- set_property PACKAGE_PIN AA25    [get_ports   ];              # IO_L6P_T0_13       -- XADC_GPIO_1
#- set_property PACKAGE_PIN AB28    [get_ports   ];              # IO_L5N_T0_13       -- XADC_GPIO_2
#- set_property PACKAGE_PIN AA27    [get_ports   ];              # IO_L5P_T0_13       -- XADC_GPIO_3
#- set_property PACKAGE_PIN Y29     [get_ports   ];              # IO_L4N_T0_13       -- GPIO_DIP_SW0
#- set_property PACKAGE_PIN W29     [get_ports   ];              # IO_L4P_T0_13       -- GPIO_DIP_SW1
#- set_property PACKAGE_PIN AA28    [get_ports   ];              # IO_L3N_T0_DQS_13   -- GPIO_DIP_SW2
#- set_property PACKAGE_PIN Y28     [get_ports   ];              # IO_L3P_T0_DQS_13   -- GPIO_DIP_SW3
#- set_property PACKAGE_PIN W28     [get_ports   ];              # IO_L2N_T0_13       -- REC_CLOCK_C_N
#- set_property PACKAGE_PIN W27     [get_ports   ];              # IO_L2P_T0_13       -- REC_CLOCK_C_P
#- set_property PACKAGE_PIN AA26    [get_ports   ];              # IO_L1N_T0_13       -- ROTARY_PUSH
#- set_property PACKAGE_PIN Y26     [get_ports   ];              # IO_L1P_T0_13       -- ROTARY_INCA
#- set_property PACKAGE_PIN Y25     [get_ports   ];              # IO_0_13             -- ROTARY_INCB
#---------------------------------------------------------------------------------------------
#
#---------------------------------------------------------------------------------------------
# TRANSMITTER IOSTANDARDS
#---------------------------------------------------------------------------------------------
   set_property IOSTANDARD  LVDS_25 [get_ports clkout1_p      ];
   set_property IOSTANDARD  LVDS_25 [get_ports clkout1_n      ];
   set_property IOSTANDARD  LVDS_25 [get_ports dataout1_p[0]  ];
   set_property IOSTANDARD  LVDS_25 [get_ports dataout1_n[0]  ];
   set_property IOSTANDARD  LVDS_25 [get_ports dataout1_p[1]  ];
   set_property IOSTANDARD  LVDS_25 [get_ports dataout1_n[1]  ];
   set_property IOSTANDARD  LVDS_25 [get_ports dataout1_p[2]  ];
   set_property IOSTANDARD  LVDS_25 [get_ports dataout1_n[2]  ];
   set_property IOSTANDARD  LVDS_25 [get_ports dataout1_p[3]  ];
   set_property IOSTANDARD  LVDS_25 [get_ports dataout1_n[3]  ];
   set_property IOSTANDARD  LVDS_25 [get_ports dataout1_p[4]  ];
   set_property IOSTANDARD  LVDS_25 [get_ports dataout1_n[4]  ];
   set_property IOSTANDARD  LVDS_25 [get_ports clkout2_p      ];
   set_property IOSTANDARD  LVDS_25 [get_ports clkout2_n      ];
   set_property IOSTANDARD  LVDS_25 [get_ports dataout2_p[0]  ];
   set_property IOSTANDARD  LVDS_25 [get_ports dataout2_n[0]  ];
   set_property IOSTANDARD  LVDS_25 [get_ports dataout2_p[1]  ];
   set_property IOSTANDARD  LVDS_25 [get_ports dataout2_n[1]  ];
   set_property IOSTANDARD  LVDS_25 [get_ports dataout2_p[2]  ];
   set_property IOSTANDARD  LVDS_25 [get_ports dataout2_n[2]  ];
   set_property IOSTANDARD  LVDS_25 [get_ports dataout2_p[3]  ];
   set_property IOSTANDARD  LVDS_25 [get_ports dataout2_n[3]  ];
   set_property IOSTANDARD  LVDS_25 [get_ports dataout2_p[4]  ];
   set_property IOSTANDARD  LVDS_25 [get_ports dataout2_n[4]  ];
   set_property IOSTANDARD  LVDS_25 [get_ports Si570_to_sma_n ];
   set_property IOSTANDARD  LVDS_25 [get_ports Si570_to_sma_p ];
#---------------------------------------------------------------------------------------------
# RECEIVER IOSTANDARDS
#---------------------------------------------------------------------------------------------
   set_property IOSTANDARD  LVDS_25 [get_ports clkin1_p       ];
   set_property IOSTANDARD  LVDS_25 [get_ports clkin1_n       ];
   set_property IOSTANDARD  LVDS_25 [get_ports datain1_p[0]   ];
   set_property IOSTANDARD  LVDS_25 [get_ports datain1_n[0]   ];
   set_property IOSTANDARD  LVDS_25 [get_ports datain1_p[1]   ];
   set_property IOSTANDARD  LVDS_25 [get_ports datain1_n[1]   ];
   set_property IOSTANDARD  LVDS_25 [get_ports datain1_p[2]   ];
   set_property IOSTANDARD  LVDS_25 [get_ports datain1_n[2]   ];
   set_property IOSTANDARD  LVDS_25 [get_ports datain1_p[3]   ];
   set_property IOSTANDARD  LVDS_25 [get_ports datain1_n[3]   ];
   set_property IOSTANDARD  LVDS_25 [get_ports datain1_p[4]   ];
   set_property IOSTANDARD  LVDS_25 [get_ports datain1_n[4]   ];
   set_property IOSTANDARD  LVDS_25 [get_ports clkin2_p       ];
   set_property IOSTANDARD  LVDS_25 [get_ports clkin2_n       ];
   set_property IOSTANDARD  LVDS_25 [get_ports datain2_p[0]   ];
   set_property IOSTANDARD  LVDS_25 [get_ports datain2_n[0]   ];
   set_property IOSTANDARD  LVDS_25 [get_ports datain2_p[1]   ];
   set_property IOSTANDARD  LVDS_25 [get_ports datain2_n[1]   ];
   set_property IOSTANDARD  LVDS_25 [get_ports datain2_p[2]   ];
   set_property IOSTANDARD  LVDS_25 [get_ports datain2_n[2]   ];
   set_property IOSTANDARD  LVDS_25 [get_ports datain2_p[3]   ];
   set_property IOSTANDARD  LVDS_25 [get_ports datain2_n[3]   ];
   set_property IOSTANDARD  LVDS_25 [get_ports datain2_p[4]   ];
   set_property IOSTANDARD  LVDS_25 [get_ports datain2_n[4]   ];
#
   set_property DIFF_TERM   TRUE    [get_ports clkin1_p       ];
   set_property DIFF_TERM   TRUE    [get_ports clkin1_n       ];
   set_property DIFF_TERM   TRUE    [get_ports datain1_p[0]   ];
   set_property DIFF_TERM   TRUE    [get_ports datain1_n[0]   ];
   set_property DIFF_TERM   TRUE    [get_ports datain1_p[1]   ];
   set_property DIFF_TERM   TRUE    [get_ports datain1_n[1]   ];
   set_property DIFF_TERM   TRUE    [get_ports datain1_p[2]   ];
   set_property DIFF_TERM   TRUE    [get_ports datain1_n[2]   ];
   set_property DIFF_TERM   TRUE    [get_ports datain1_p[3]   ];
   set_property DIFF_TERM   TRUE    [get_ports datain1_n[3]   ];
   set_property DIFF_TERM   TRUE    [get_ports datain1_p[4]   ];
   set_property DIFF_TERM   TRUE    [get_ports datain1_n[4]   ];
   set_property DIFF_TERM   TRUE    [get_ports clkin2_p       ];
   set_property DIFF_TERM   TRUE    [get_ports clkin2_n       ];
   set_property DIFF_TERM   TRUE    [get_ports datain2_p[0]   ];
   set_property DIFF_TERM   TRUE    [get_ports datain2_n[0]   ];
   set_property DIFF_TERM   TRUE    [get_ports datain2_p[1]   ];
   set_property DIFF_TERM   TRUE    [get_ports datain2_n[1]   ];
   set_property DIFF_TERM   TRUE    [get_ports datain2_p[2]   ];
   set_property DIFF_TERM   TRUE    [get_ports datain2_n[2]   ];
   set_property DIFF_TERM   TRUE    [get_ports datain2_p[3]   ];
   set_property DIFF_TERM   TRUE    [get_ports datain2_n[3]   ];
   set_property DIFF_TERM   TRUE    [get_ports datain2_p[4]   ];
   set_property DIFF_TERM   TRUE    [get_ports datain2_n[4]   ];
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
set_property PACKAGE_PIN  L21 [get_ports i2c_data ];
set_property PACKAGE_PIN  K21 [get_ports i2c_clock];
#- set_property PACKAGE_PIN P23 [get_ports ] #- I2C_MUX_RESET_B
#-
#- There is a I2C Si570 oscillator available on the XM107 loopback board.
#- When that is used following pins are the clock input pins to the FPGA.
#-     These pins arrive to the FPGA from the LPC-FMC connector.
#- FPGA IO-Bank 12 (see also in IO-Bank 12 above)
#-set_property PACKAGE_PIN AG23 [get_ports tx_freqgen_n  ]; #- IO_L13N_T2_MRCC_12 CLK0_M2C
#-set_property PACKAGE_PIN AF22 [get_ports tx_freqgen_p  ]; #- IO_L13P_T2_MRCC_12 CLK0_M2C
#- FPGA IO-Bank 13
#- There is a Si570 oscillator placed on the KC705 board.
#- When that is used the FPGA clock input pins are:
set_property PACKAGE_PIN K29     [get_ports tx_freqgen_n  ]; #- IO_L13N_T2_MRCC_15 CLK0_M2C
set_property PACKAGE_PIN K28     [get_ports tx_freqgen_p  ]; #- IO_L13P_T2_MRCC_15 CLK0_M2C
set_property IOSTANDARD  LVDS_25 [get_ports tx_freqgen_n  ];
set_property IOSTANDARD  LVDS_25 [get_ports tx_freqgen_p  ];
set_property DIFF_TERM   TRUE    [get_ports tx_freqgen_n  ];
set_property DIFF_TERM   TRUE    [get_ports tx_freqgen_p  ];
#-
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
resize_pblock [get_pblocks Receiver] -add {SLICE_X0Y50:SLICE_X13Y99}
#-
create_pblock Transmitter
add_cells_to_pblock [get_pblocks Transmitter] [get_cells \
    [list \
        */Txd \
        */Txd/clkgen \
        */Txd/dataout
    ]]
resize_pblock [get_pblocks Transmitter] -add {SLICE_X0Y0:SLICE_X13Y49}
#-
create_pblock CtrlVio
add_cells_to_pblock [get_pblocks CtrlVio] [get_cells \
    [list \
        Gen_10.ctrl_vio
       ]]
resize_pblock [get_pblocks CtrlVio] -add {SLICE_X14Y0:SLICE_X25Y99}
#-
create_pblock CtrlIla
add_cells_to_pblock [get_pblocks CtrlIla] [get_cells \
    [list \
        Gen_12.ctrl_ila
    ]]
resize_pblock [get_pblocks CtrlIla] -add {SLICE_X30Y50:SLICE_X55Y99}
#-
#---------------------------------------------------------------------------------------------
#- The End ..........
#---------------------------------------------------------------------------------------------

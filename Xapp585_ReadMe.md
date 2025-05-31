*************************************************************************
```
   ____  ____
  /   /\/   /
 /___/  \  /
 \   \   \/    � Copyright 2012-2018 Xilinx, Inc. All rights reserved.
  \   \        This file contains confidential and proprietary
  /   /        information of Xilinx, Inc. and is protected under U.S.
 /___/   /\    and international copyright and other intellectual
 \   \  /  \   property laws.
  \___\/\___\
```
*************************************************************************

Vendor: Xilinx
Current readme.txt Version: 2.0
Date Last Modified:  16JUL2018
Date Created: 30MAY2012

Associated Filename: xapp585.zip
Associated Document: xapp585, LVDS Source Synchronous 7:1 Serialization and
                     Deserialization Using Clock Multiplication

Supported Device(s): Virtex-7 FPGAs Kintex-7 FPGAs Artix-7 FPGAs

*************************************************************************
```
Disclaimer:

      This disclaimer is not a license and does not grant any rights to
      the materials distributed herewith. Except as otherwise provided in
      a valid license issued to you by Xilinx, and to the maximum extent
      permitted by applicable law: (1) THESE MATERIALS ARE MADE AVAILABLE
      "AS IS" AND WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL
      WARRANTIES AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY,
      INCLUDING BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY,
      NON-INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
      (2) Xilinx shall not be liable (whether in contract or tort,
      including negligence, or under any other theory of liability) for
      any loss or damage of any kind or nature related to, arising under
      or in connection with these materials, including for any direct, or
      any indirect, special, incidental, or consequential loss or damage
      (including loss of data, profits, goodwill, or any type of loss or
      damage suffered as a result of any action brought by a third party)
      even if such damage or loss was reasonably foreseeable or Xilinx
      had been advised of the possibility of the same.

Critical Applications:

      Xilinx products are not designed or intended to be fail-safe, or
      for use in any application requiring fail-safe performance, such as
      life-support or safety devices or systems, Class III medical
      devices, nuclear facilities, applications related to the deployment
      of airbags, or any other applications that could lead to death,
      personal injury, or severe property or environmental damage
      (individually and collectively, "Critical Applications"). Customer
      assumes the sole risk and liability of any use of Xilinx products
      in Critical Applications, subject only to applicable laws and
      regulations governing limitations on product liability.

THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS PART OF THIS
FILE AT ALL TIMES.
```
*************************************************************************

This readme file contains these sections:

1. REVISION HISTORY
2. OVERVIEW
3. SOFTWARE TOOLS AND SYSTEM REQUIREMENTS
4. DESIGN FILE HIERARCHY
5. INSTALLATION AND OPERATING INSTRUCTIONS
6. OTHER INFORMATION (OPTIONAL)
7. SUPPORT


1. REVISION HISTORY

|      Date       | Version | Revision Description                                                         |
| --------------- | ------- | ---------------------------------------------------------------------------- |
| June 27th 2012  | 1.0     | Initial Xilinx release.                                                      |
| Sept 12th 2012  | 1.1     | Slight changes and a typo fixed in the top-level example                     |
|                 |         | files, see the individual files for details.                                 |
| Sept 30th 2013  | 1.2     | Vivado constraints added, Data eye monitoring added, see xapp for details.   |
|                 |         | Hierarchy changes                                                            |
|                 |         |   Low frequency operation modified, both SDR and DDR now work correctly down |
|                 |         |   to the MMCM minimum input frequency Phase detector operation now per-bit   |
|                 |         |   rather than per-word, updated format.                                      |
| April 30th 2018 | 2.0     | Some code changes applied to original design to make the                     |
|                 |         |   verilog and VHDL source code create exactly the same design.               |
|                 |         |   Design (folder organization) updated, see below.                           |
|                 |         |   Extra VHDL design implementation created as example running                |
|                 |         |   on a KC705 Xilinx development board.                                       |
| July 16th 2018  | 2.1     | Made ALL readme file sin the reference design Markdown reader compatible.    |

2. OVERVIEW

This readme describes how to use the files that come with XAPP585


3. SOFTWARE TOOLS AND SYSTEM REQUIREMENTS

* Vivado 2017.4 or higher

4. DESIGN FILE HIERARCHY

The directory structure underneath this top-level folder (XAPP585) is described
below :
```
Xapp585
    -- \DdrVhdlVersion      - Design version for KC705 development board.
        -- \Constraints     - Constraints files to make the design fit a KC705 board.
        -- \Documents       - "xapp585_ Uncertainties_ tool_ 1.2.xlsx" Excel tool.
        -- \Libraries       - Reference design and extras necessary to make design run
                              on a KC705 board.
            -- \Ila_Lib
            -- \Osc_Control_Lib
            -- \Receiver_Lib    - Reference design files as found in "OrgVhdlVersion".
            -- \Transmitter_Lib - Reference design files as found in "OrgVhdlVersion".
            -- \Vio_Lib
        -- \SimScripts      - Scripts for running simulations with QuestaSim.
                                Read the "Readme_Simulation.md" file.
        -- \Simulation      - Directory used by teh simulator.
        -- \Vhdl            - Top level source code.
        -- \Vivado          - Design Synthesis and implementation.
                                Read the "ReadMe_Vivado.md" file.

    -- \OrgVerilogVersion   - Files and folders from the original reference design.
        -- \Constraints     - These are the files as posted in teh original, previous, released
        -- \Documents       - reference design. The files are rearranged and updated.
        -- \Verilog_macros
        -- \Verilog_Testbanch
        -- \Verilog_to_level_examples

    -- \OrgVhdlVersion      - Files and folders from the original reference design.
        -- \Constraints     - These are the files as posted in teh original, previous, released
        -- \Documents       - reference design. The files are rearranged and updated.
        -- \Libraries
        -- \Vhdl
        -- \Vhdl_Testbench
        -- Vivado

    -- readme.txt           - This file
```

5. INSTALLATION AND OPERATING INSTRUCTIONS

Choose whether your design needs SDR or DDR techniques using the application note and
enclosed spreadsheet.

Make sure to have Vivado_2017.4 or later installed.

To incorporate the appropriate module into a Vivado design project:
Read the readme files in teh different directories.

Design guidelines that hav enot been changed.
Verilog flow:

1) For SDR receiver designs, instantiate the receiver module n_x_serdes_1_to_7_mmcm_idelay_sdr.v and set
   the number of channels (N) and number of data-bits per channel (D) appropriately for the application.
   An example top-level design for 2 channels of 5-bits each is provided in the .zip file
2) For SDR transmitter designs, instantiate the receiver module n_x_serdes_7_to_1_diff_sdr.v and the clock
   generator module clock_generator_pll_7_to_1_diff_sdr.v and set the number of channels (N) and number
   of data-bits per channel (D) appropriately for the application.
   An example top-level design for 2 channels of 5-bits each is provided in the .zip file
3) For DDR receiver designs, instantiate the receiver module n_x_serdes_1_to_7_mmcm_idelay_ddr.v and set
   the number of channels (N) and number of data-bits per channel (D) appropriately for the application.
   An example top-level design for 2 channels of 5-bits each is provided in the .zip file
4) For DDR transmitter designs, instantiate the receiver module n_x_serdes_7_to_1_diff_ddr.v and the clock
   generator module clock_generator_pll_7_to_1_diff_ddr.v and set the number of channels (N) and number
   of data-bits per channel (D) appropriately for the application.
   An example top-level design for 2 channels of 5-bits each is provided in the .zip file
5) For designs containing both a receiver and a transmitter, the clock from the reciver module can be used
   for transmission instead of those from the clock generator module

VHDL flow:

1) For SDR receiver designs, instantiate the receiver module n_x_serdes_1_to_7_mmcm_idelay_sdr.vhd and
   set the number of channels (N) and number of data-bits per channel (D) appropriately for the application.
   An example top-level design for 2 channels of 5-bits each is provided in the .zip file
2) For SDR transmitter designs, instantiate the receiver module n_x_serdes_7_to_1_diff_sdr.vhd and the
   clock generator module clock_generator_pll_7_to_1_diff_sdr.vhd and set the number of channels (N) and
   number of data-bits per channel (D) appropriately for the application.
   An example top-level design for 2 channels of 5-bits each is provided in the .zip file
3) For DDR receiver designs, instantiate the receiver module n_x_serdes_1_to_7_mmcm_idelay_ddr.vhd and
   set the number of channels (N) and number of data-bits per channel (D) appropriately for the application.
   An example top-level design for 2 channels of 5-bits each is provided in the .zip file
4) For DDR transmitter designs, instantiate the receiver module n_x_serdes_7_to_1_diff_ddr.vhd and the
   clock generator module clock_generator_pll_7_to_1_diff_ddr.vhd and set the number of channels (N) and
   number of data-bits per channel (D) appropriately for the application.
   An example top-level design for 2 channels of 5-bits each is provided in the .zip file
5) For designs containing both a receiver and a transmitter, the clock from the reciver module can be used
   for transmission instead of those from the clock generator module


6. OTHER INFORMATION (OPTIONAL)

1) Warnings


2) Design Notes


3) Fixes


4) Known Issues

When processing these designs with ISE version 14.1, map will possibly give an error. The fix for this
condition is to set the  "-ignore_keep_hierarchy" option in map, either via the graphical user interface,
or as a command line option.

7. SUPPORT

To obtain technical support for this reference design, go to
www.xilinx.com/support to locate answers to known issues in the Xilinx
Answers Database or to create a WebCase.

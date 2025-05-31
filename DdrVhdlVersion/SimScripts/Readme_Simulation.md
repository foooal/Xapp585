*************************************************************************
```
   ____  ____
  /   /\/   /
 /___/  \  /
 \   \   \/    � Copyright 2018 Xilinx, Inc. All rights reserved.
  \   \        This file contains confidential and proprietary
  /   /        information of Xilinx, Inc. and is protected under U.S.
 /___/   /\    and international copyright and other intellectual
 \   \  /  \   property laws.
  \___\/\___\
```
*************************************************************************
Vendor:                 Xilinx
Current:                ReadMe.txt (For simulation)
Version:                1.0
Date Last Modified:     Mar 2018
Date Created:           Feb 2018
Associated Filename:
Associated Document:
Supported Device(s):    7-Series
*************************************************************************
Disclaimer:
```
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
```
Critical Applications:
```
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
```
THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS PART OF THIS FILE AT ALL TIMES.
*************************************************************************
##Simulation starts here.

##ReadMe files in the design Hierarchy
  *A md file is a Markdown text file.*
  *It can be opened with a normal editor, as if it was a txt file.*
  *Opening it in a markdown reader or in a web browser provides better readable layout.*
**PLEASE**: Read the "...ReadMe...md" files in the different folders.

Open and read the */SimScripts/Readme_Simulation.md* file, follow the instructions how to
operate the simulation. Simulation is run in Modelsim QuestaSim but operating the simulation
in a different simulator will require the same steps as described in this Readme file.
**REMARK:** The best, most complete and comprehensive simulation of the design is obtained
by implementing a minimal version of the design and control it through the VIO while
gathering visual, waveforms, information in a ILA.

For the full explication and detailed view over of the design read the **"ReadMe_Design_**
**Hierarchy_Structure.md(txt)"** in the root directory of this project.
At a glance this is the design setup:
- A top level containing a lower level of the design (PRBS), VIO and or ILA.
- The PRBS level of the design containing the Asynchronous Data Capturing design and
  for each used TX/RX data channel a PRBS generator and cheker.
- The Asynchronous Data Capture design and its lower hierarchical levels.
The simulation of the design starts from the PRBS level. The reason why simulation is
starting from this level: it provides the simulation the same control handles as when it is
used with a VIO in hardware.

###Invoke and start Quesasim.
- Open a terminal(Linux)/command window(Windows).
- Change directory to the folder where you found this "Readme_Simulation.txt" file.
- Type "*questasim*" for Windows or "*vsim*" when simulating in Linux.
    - Above command starts Mentor QuestaSim tool.
- In QuestaSim do:
    - Click the **[Tools]** tap.
    - Select from the fall down menu: **[Tcl]**
    - Under **[Tcl]** select **[Execute Macro]**
    - Browse to the directory where you found this "Readme_Simulation.md" file and
        select the: **<ProjectName>_FuncSim.do** file.
    - Click **[Open]**

the simulation will start, after compilation and pop-up of the waveform window,
The simulation will run a in the **<ProjectName>_FuncSim.do** file predefined number
of cycles. type in the transcript window 'run xxxxxx' to run etra cycles.
The waveform window will now show waveform actions.

###REMARK_0:
- If a simulation contains verilog coded files, then: to get simulation working a special
  file must be included in the compiler file list of the **<ProjectName>_FuncSim.do**.
- This line must contain the compilation for simulation of the global 3-state and reset
  nets in a design (glbl.v)
- Depending the installation of the Xilinx Vivado tools it might be necessary to change
  this setting in the **<ProjectName>_FuncSim.do** file.
- Default the line is entered in the **<ProjectName>_FuncSim.do** file using a hard coded
  path pointing to the installation of the Xilinx Vivado tool chain.
  ```
  vlog -novopt -work work {<drive>:/Path/ToTools/Xilinx/Vivado/2017.n/data/verilog/src/glbl.v}
                Where "n" is the year version number of the Vivado software.
  ```
- On Windows systems the environment variable XILINX_VIVADO is set by the Xilinx Vivado
  tools and points to the installation of the Vivado tool chain. The line in the .do
  file can then look as:
    ```
    vlog -novopt -work work $env(XILINX_VIVADO)/data/verilog/src/glbl.v
    ```
- On stand alone Linux systems it is possible that the "XILINX_VIVADO" environment variable
  is set when the Vivado tools are started, but that it's unset when the Vivado tools are
  closed or not running.
- On networked Linux systems where the Vivado software is installed central, it is very likely
  that the environment "XILINX_VIVADO" is not set at all on a user machine or as in previous
  point the environment variable is set when the Vivado tools are started/running.
- In both above cases it might be a good solution to find out where and what Vivado tools
  are used and then leave a hard coded path to the "glbl.v" library.

###REMARK_1:
- Questasim runs default in a 'ns' setup. This simulation allows that a clock is modified
  fwith a deviation on the normal clock cycle. This deviation is given in 'fs'.
  In order to let the waveform window display the deviation of the clock the simulation
  must be run adn displayed in 'fs'.
- The **<ProjectName>_FuncSim.do** file runs the simulation in 'fs' using this command line:
  ```
  vsim -novopt -t fs -L unisims_ver -L secureip xil_defaultlib...
  ```
- To make Questasim display the waveforms in fs, the timing needs to be changed in the
  **modelsim.ini** file.
  - Change under the header **[vsim]** the **resolution** from ns to fs.

###REMARK_2:
- It necessary that the Xilinx simulation libraries are synthesized for QuestaSim.
- To synthesize simulation libraries do:
  - Create a folder for hosting the compiled Xilinx libraries.
    - Example:
    ```
      /<Folder/Where/CompiledSimulation/Libraries/Stored>/XilinxQuestaLibraries
    ```
    - Open a terminal(Linux)/command window(Windows).
    - Change directory (cd) to the earlier created folder.
    - Start Vivado (Type: vivado or vivado &).
    - In the GUI select the **[Tools]** tab and from the fall down menu
      select **[Compile Simulation Libraries...]**.
    - In the new pop-up menu select:
      - Simulator: QuestaSim
      - Language: All, VHDL or Verilog
          ​      For mixed designs leave: All
      - Library: All, Simprim, Unisim
          ​      Leave it to 'All' when behavioural and timing simulation must be done.
      - Family: All or select <A Family>
          ​      Leave it to all when this is the master library folder for used for
          ​      all design simulations.
      - Compiled Library Location:
          The folder created to contain the simulation libraries/models.
          <Path_To_Folder_Where_all_Projects_Are>/XilinxQuestaLibraries
      - Simulator Executable Path:
          Find the path to the QuestaSim executable.
          Example:  ../../QuestaSim64_10_6b/win64
      - Click [Compile]
          All or selected libraries for all or selected FPGA families will be compiled and
          stored in the given folder. There is a "modelsim.ini" file generated and stored
          in that folder. Several options are open to make use of this 'local' modelsim.ini
          file.
- Option_1:
  - Open the modelsim.ini file (make it writable first) in the installation
    folder of QuestaSim.
  - Add following lines:
  ```
    ; Xilinx Libraries       <-- comments
    others = ../XilinxLibraries/modelsim.ini  <-- Path to the local ini file.
  ```
- Option_2:
  - Create an environment: MODELSIM
  - Like this:
  ```
      MODELSIM=/Folder/Where/CustomSimulation/Libraries/AreStored/QuestaSimLibs/modelsim.ini
  ```
  - Starting Questasim will now look into this folder and add the libraries to
    the loaded simulation libraries.

###REMARK_3:
- Whenever changes are done to any of the VHDL files, the syntheses run for simulation
  must be redone.
- Do this as:
    - Type in the command line of the transcript window following commands.
      ```
      quit -sim : This will close a running simulation
      ```
- With the up and down arrows it's possible to browse through earlier executed command.
- Find the "do" command and run it again.
    ```
    do <Path_to_the_>/Simscripts/Byte_Top_RxTx_Prbs_Nat_FuncSim.do
    ```
- To run the simulation longer or shorted as the "run" command in the .do file, type:
    ```
    run <value>
    ```
###REMARK_4:
- The QuestaSim transcript log file will be written into this /SimScripts folder.
- The transcripts folder allows you to find all simulation commands, warnings
   and errors that have also been displayed in the GUI transcript window.

##Modify the simulation files.
The setup of the simulation test bench lloks like this:
```
                        DTU                                       UUT
                   +-----------+                             +-----------+
 +--------------->-|           |-->----------------------->--|           |->---------------+
 | +------------->-|  Byte_    |-->----------------------->--|  Byte_    |->-------------+ |
 | | +----------->-|  Top_     |-->--  All inputs of the ->--|  Top_     |->-----------+ | |
 | | | | +------->-|  Prbs_    |-->--  UUT are connected ->--|  Prbs_    |->---------+ | | |
 | | | +--------->-|  RxTx_    |-->--  to outputs of the ->--|  RxTx_    |->-------+ | | | |
 | | | | | +----->-|  Tester   |-->--  to the DTU        ->--|  .vhd     |->-----+ | | | | |
 | | | | | | +--->-|  .vhd     |-->----------------------->--|           |->---+ | | | | | |
 | | | | | | | +->-|           |-->----------------------->--|           |->-+ | | | | | | |
 | | | | | | | |   +-----------+                             +-----------+   | | | | | | | |
 | | | | | | | |                                                             | | | | | | | |
 + + + + + + + +=============================================================+ + + + + + + +
+ + + + + + + +==============================================================+ + + + + + + +

```
The customized Asynchronous Data Capturing design (UUT) is tested using a VHDL file (DTU)
generating stimuli for the UUT and collecting data from the UUT.
With a simulator these signals, and all signals of both UUT and DTU can be made visible.

There are the files to modify:
```
    /Vhdl
       |-- Byte_Top_RxTx_Prbs_Testbench.vhd
       |-- Byte_Top_RxTx_Prbs_Tester.vhd
```
###Byte_Top_RxTx_Prbs_TestBench.vhd
To run the customized design in simulation, one needs to adapt this simulation test bench.
The simulation test bench must reflect the real design, meaning:
- The **instantiated component** *"Byte_Top_RxTx_Prbs"* must thus have exact the same setup
  as the entity of the *Byte_Top_RxTx_Prbs.vhd* file, in fact the component in this file is a
  copy of the entity of the *Byte_Top_RxTx_Prbs.vhd* file.
  ```
  ---------------------------------------------------------------------------------------------
  -- Component Instantiation
  ---------------------------------------------------------------------------------------------
      component Byte_Top_RxTx_Prbs
          generic (
              ..........
          );
          port (
              .......
          );
      end component Byte_Top_RxTx_Prbs;
  ```
- The **constants** must be set correctly.
```
- Another instantiated component is the Byte_Top_RxTx_Prbs_Tester. This is the component
  controlling the simulation and gathering results. This component needs no tweaking.
  The functioning of this component is explained later om in this document.
---------------------------------------------------------------------------------------------
-- Constants:
-- Define the simulation settings here!
---------------------------------------------------------------------------------------------
Sim_C_Rx_UsedDataChnls : Maximal twelve RX/TX data channels can be put in an IO-Bank.
                         A 12-bit vector of which each bit stands for a used data channel.
Sim_C_Tx_UsedDataChnls : Maximal twelve RX/TX data channels can be put in an IO-Bank.
                         The 12-bit vector represents all possible channels in the IO-Bank.
                         Set a bit in the 12-bit vector to 1 for a used data channel.
                         In the 12-bit vector the bits are positional, meaning that
                         data channel 1 corresponds to bit 1 and data channel 12
                         corresponds to bit 12 of the vector.
    Example:
      RX Data channels 2 and 3 used = "000000000110".
      TX Data channels 2 and 3 used = "000000000110".
Sim_C_ExternalClock     : The data sample clock can be located in the same IO-Bank as the
                        : data channels. When that is the case the data sample clock
                        : arrives in Byte_2/lower nibble/bitslkivce_0. This corresponds
                        : to RX Data Channel 07.
                        : When the above is the case, SET THE CONSTANT TO: 0.
                        : When the data sample clock arrives from somewhere else in the
                        : design, SET THE CONSTANT TO 1.
Sim_C_ClockPeriod       : In ns. This is the clock generated in the "_Tester" and is the
                        : frequency of the ClockIn_p/n. This clock is also used to capture
                        : in the DTU the by the UUT transmitted data.
Sim_C_Deviation         : in PPM, ex: 200 = 200PPM. A internal DTU generated clock, related
                        : the ClockIn_p/n clock but with positive or negative deviation
                        : used to transmit data to the UUT receiver.
                        : 1 PPM = 0,001%
                        : 200 PPM = 0.02%
                        : Clock = 625MHz
                        : 625MHz + 0.02% = 625.125MHz (1.5996 ns)
                        : 625MHz - 0.02% = 624.875MHz (1.6003 ns)
                        : See also: https://www.jitterlabs.com/support/calculators/ppm
REMARK: in order to be able to calculate values smaller than ps the vsim command
      in the .do file is set to fs. Normally this is set to ps.
Sim_C_DevDir            : Sense of the given deviation. "pos" generates a clock of frequency
                        : equal to Sim_C_ClockPeriod + Sim_C_Deviation. "neg" generates a clock
                        : of frequency equal to Sim_C_ClockPeriod - Sim_C_Deviation.
Sim_C_Rx_PrbsBits       : Number of bits the PRBS works on.
Sim_C_Tx_PrbsBits       : Number of bits the PRBS works on.
Sim_C_Rx_Poly_Length    : PRBS checker polynomial length.
Sim_C_Rx_Poly_Tap       : PRBS checker tap on polynomial.
Sim_C_Tx_Poly_Length    : PRBS generator polynomial length.
Sim_C_Tx_Poly_Tap       : PRBS generator tap on polynomial.
```
- The **signals**, in the signal section of the file, must reflect the used connections between
  the UUT and DTU. It means that the commented and uncomment signals must be a reflection
  of the commented/uncommented ports of the instantiated "Byte_Top_RxTx_Prbs" component.
  ```
  ---------------------------------------------------------------------------------------------
  -- Signals:
  -- Connections between DTU and UUT and UUT and DTU
  ---------------------------------------------------------------------------------------------
  ```
- After **begin** the UUT must again have the same ports commented/uncommented as the
  _Byte_Top_RxTx_Prbs_ component and the signals.
- The DTU needs the most work. All used ports of the DTU must be connected with the
  used, uncommented, signals. Then the inputs and outputs of the DTU will connect to the
  outputs and inputs of the UUT.
  All other ports must be tied _Low_ or left _open_.
  ```
  ---------------------------------------------------------------------------------------------
  begin
    --
  UUT : Byte_Top_RxTx_Prbs
      generic map (
      )
      port map (

      );
  --
  DTU : Byte_Top_RxTx_Prbs_Tester
      generic map (
      )
      port map (

      );
  ---------------------------------------------------------------------------------------------
  ```
- The help tuning the test bench file, all signals and all ports are connected up.
  and only the ports and signals used in this reference design are uncommented or used.
  One modifying this file should have an easier job and at the same time get guidelines
  by just using the file.

###Byte_Top_RxTx_Prbs_Tester.vhd
This file contains the stimuli for the UUT.
There is one PRBS generator and one PRBS checker per data channel.
Enable, uncomment, only the PRBS generator and checkers for the data channels used in the
deisgn and leave the rest commented.
These PRBS engines are each described as separate process. The description starts after:
```
---------------------------------------------------------------------------------------------
-- Architecture Concurrent Statements
---------------------------------------------------------------------------------------------
```
First find twelve PRBS checkers and then find twelve PRBS generators.
The PRBS checker code contains a serial-to parallel conversion and then the checker itself.
```
    SerToPar_**n** : process
    ..........
    .......
    end process SerToPar_**n**;
    --
    PrbsChk_**n** : process
    ...............
    ..........
    end process PrbsChk_**n**;
```
The PRBS generator code conatins the generator and a parallel-to-serial convertor.
```
    PrbsGen_**n** : process
    ...............
    ...........
    end process PrbsGen_**n**;
    --
    ParToSer_**n** : process
    ...............
    ...........
    end process ParToSer_**n**;
```
The **n** is the number of the data cahnnel, between 12 and 01.


Kind regards,

XILINX

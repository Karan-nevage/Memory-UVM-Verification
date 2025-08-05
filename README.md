# Memory-UVM-Verification

## Overview
This project provides verification environments for a synchronous single-port RAM module implemented in Verilog. It includes two approaches:
- **Traditional Verilog-based Verification**: A simple Verilog testbench to verify reset, write, and read operations.
- **UVM-based Verification**: A Universal Verification Methodology (UVM) testbench for structured, industry-standard verification.

## Prerequisites
- Access to **EDA Playground** with **Siemens QuestaSim** for simulation.
- Basic knowledge of Verilog, SystemVerilog and UVM for understanding and modifying the testbenches.

## Tools Used
This project is developed and tested using **Siemens QuestaSim** on **EDA Playground**. Access the project at:  
[https://www.edaplayground.com/x/PxJb](https://www.edaplayground.com/x/PxJb)

## Access the Project:
   **Verilog Verification**
   - Open the project on EDA Playground: [https://www.edaplayground.com/x/PxJb](https://www.edaplayground.com/x/PxJb).
   - Ensure QuestaSim is selected as the simulator.
     
  **UVM Verification**
  - Open the project on EDA Playground: [https://www.edaplayground.com/x/ZBa4](https://www.edaplayground.com/x/ZBa4).
   - Ensure QuestaSim is selected as the simulator.
   - Ensure UVM 1.2 is enabled.
## UVM Test-Bench Architecture
![TB Architecture](https://github.com/Karan-nevage/Memory-UVM-Verification/blob/main/UVM%20Verification/Testbench%20Architecture.png)  
## Signal Descriptions
The memory module (`memory.v`) has the following signals, used in both Verilog and UVM verification environments:

| Signal Name       | Direction | Width                | Description                                                                 |
|-------------------|-----------|----------------------|-----------------------------------------------------------------------------|
| `clk_i`           | Input     | 1 bit                | Clock input for synchronous operation of the memory module.                 |
| `rst_i`           | Input     | 1 bit                | Active-high reset to clear memory array and output registers (`rdata_o`, `ready_o`). |
| `addr_i`          | Input     | `ADDR_WIDTH-1:0`     | Address input to specify the memory location for read or write operations.  |
| `wdata_i`         | Input     | `WIDTH-1:0`          | Data input for write operations to the memory.                             |
| `wr_rd_i`         | Input     | 1 bit                | Write/Read control signal (1: write to memory, 0: read from memory).        |
| `valid_i`         | Input     | 1 bit                | Valid signal to initiate a read or write operation.                         |
| `rdata_o`         | Output    | `WIDTH-1:0`          | Data output from the memory during read operations.                         |
| `ready_o`         | Output    | 1 bit                | Ready signal indicating the memory has completed the requested operation.   |

The project includes two verification environments:

## Waveform
The waveform generated from the Verilog testbench can be viewed in the VCD file (`dump.vcd`) on EDA Playground. Below is a snapshot of the waveform:  
![Waveform Snapshot](https://github.com/Karan-nevage/Memory-UVM-Verification/blob/main/Verilog%20Waveform%20%20Based%20Verification/Waveform%20Memory%20Result.png)  

1. **Traditional Verilog-based Verification**:
   - Features a testbench (`memory_tb.v`) that verifies the memory module by:
     - Applying an active-high reset to clear memory and output registers.
     - Writing random data to all memory locations.
     - Reading back data to confirm correct operation.
   - Generates a VCD file (`dump.vcd`) for waveform analysis using EDA Playground’s viewer.

2. **UVM-based Verification**:
   - Implements a Universal Verification Methodology (UVM) testbench with the following components:
     - `memory.v`: Verilog memory module (shared with Verilog verification).
     - `mem_intf.sv`: Interface for signal connections.
     - `mem_tx.sv`: Transaction class for memory operations.
     - `mem_drv.sv`: Driver to drive transactions to the DUT.
     - `mem_mon.sv`: Monitor to observe DUT signals.
     - `mem_sqr.sv`: Sequencer to manage test sequences.
     - `mem_agent.sv`: Agent to integrate driver, monitor, and sequencer.
     - `mem_env.sv`: Environment to integrate all components.
     - `mem_seq_lib.sv`: Sequence library for test scenarios.
     - `test_lib.sv`: Test cases for various scenarios.
     - `mem_cov.sv`: Coverage model for functional coverage.
     - `mem_common.sv`: Common definitions for the UVM environment.
   - Tests reset, sequential write/read, random data, and boundary conditions.

This project serves as a learning resource for Verilog and UVM verification techniques and a practical example for verifying memory designs.

## Usage
- **Verilog Verification**: The testbench (`tb.v`) applies reset, writes random data to all memory locations, and reads back data. Modify `tb.v` for custom test cases (e.g., specific addresses or data patterns).
- **UVM Verification**: The UVM testbench includes components for driving, monitoring, and scoring transactions. Tests cover reset, sequential write/read, random data, and boundary conditions. Extend tests in `test_lib.sv` or `mem_seq_lib.sv`.

## Author
- **Name**: Karankumar Nevage
- **Email**: karanpr9423@gmail.com
- **LinkedIn**: [https://www.linkedin.com/in/karankumar-nevage/](https://www.linkedin.com/in/karankumar-nevage/)

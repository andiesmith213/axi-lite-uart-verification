# Summary

This document defines the verification scope, requirements baseline, test plan,
coverage plan, and closure criteria for `axiluart`.

# Design Overview

Target DUT: ZipCPU's `axiluart` AXI-Lite UART controller, consisting of:
- a 32-bit AXI4-Lite register interface;
- a configurable UART receiver and receive FIFO;
- a configurable UART transmitter and transmit FIFO;
- active-low hardware flow-control signals;
- receive, transmit, and FIFO interrupt outputs.

Default assumptions are a 200 MHz maximum system clock,
an 16-entry FIFO when `LGFLEN=4`, and a 31-bit setup value.


# Requirements Baseline
The original project did not have existing requirements. The requirements below were copilot generated.

## AXI4-Lite Interface

| ID | Requirement |
|---|---|
| AXI-001 | `S_AXI_ARESETN` shall be an active-low reset; while asserted, AXI valid outputs and DUT operational state shall be reset to their idle/reset values. |
| AXI-002 | The DUT shall implement a 32-bit AXI4-Lite interface with a 4-bit address bus and a single 32-bit data beat per transaction. |
| AXI-003 | Address `0x0`, `0x4`, `0x8`, and `0xC` shall map respectively to SETUP, FIFO, RX_DATA, and TX_DATA; accesses to other addresses shall not have unintended side effects. |
| AXI-004 | An AXI write shall complete only after its address and data handshakes are both accepted, and shall return `BRESP=2'b00`. |
| AXI-005 | An AXI read shall return `RRESP=2'b00` and valid data on `RDATA` for a completed read request. |
| AXI-006 | `WSTRB` shall select the bytes updated by a write to the SETUP, RX_DATA reset/error, and TX_DATA control fields. |
| AXI-007 | `BVALID`/`RVALID` shall remain asserted until `BREADY`/`RREADY` is sampled high respectively. |

## Setup Register

| ID | Requirement |
|---|---|
| REG-001 | SETUP at offset `0x0` shall be readable and writable; bit 31 shall read as zero and shall not affect operation. |
| REG-002 | SETUP bit 30 shall disable hardware flow control when set. |
| REG-003 | SETUP bits 29:28 shall select 8, 7, 6, or 5 data bits for values `00`, `01`, `10`, or `11`, respectively. |
| REG-004 | SETUP bit 27 shall select one stop bit when clear and two stop bits when set. |
| REG-005 | SETUP bit 26 shall enable parity when set and disable parity when clear. |
| REG-006 | With parity enabled and SETUP bit 25 clear, SETUP bit 24 shall select odd parity when clear and even parity when set. |
| REG-007 | With parity enabled and SETUP bit 25 set, SETUP bit 24 shall select fixed space (`0`) or fixed mark (`1`) parity. |
| REG-008 | SETUP bits 23:0 shall contain the integer number of system clocks in one baud interval. |
| REG-009 | Configuration changes shall take effect in the transmitter only when it is idle and in the receiver between received bytes. |
| REG-010 | Writing SETUP shall reset the receive and transmit state and receive FIFO as implemented by the AXI wrapper. |

## UART Transmitter

| ID | Requirement |
|---|---|
| TX-001 | The UART transmitter shall idle with `o_uart_tx` high and shall drive a low start bit for each accepted byte. |
| TX-002 | Transmitted data shall be sent least-significant bit first, followed by the configured parity and stop bit(s). |
| TX-003 | Each UART bit shall persist for exactly the setup-selected `CLKS` system-clock intervals except for benign phase effects at initial acceptance. |
| TX-004 | TX_DATA writes shall enqueue the low byte when the transmit FIFO has space. A write while full shall set the transmit FIFO overflow indication and shall not corrupt existing data. |
| TX-005 | `o_uart_tx_int` shall assert when at least one transmit FIFO entry is writable. |
| TX-006 | `o_uart_txfifo_int` shall assert when the transmit FIFO is less than half full. |
| TX-007 | Writing TX_DATA bit 9 shall place the transmitter in break; clearing that bit shall remove break mode. |
| TX-008 | Writing TX_DATA bit 12 shall reset the transmit FIFO; the FIFO error indication shall be cleared by the reset. |

## UART Receiver

| ID | Requirement |
|---|---|
| RX-001 | The receiver shall synchronize `i_uart_rx` before decoding and shall detect a start edge as a high-to-low transition. |
| RX-002 | For each frame, the receiver shall sample at the middle of each configured bit period and return received data least-significant bit first. |
| RX-003 | A missing expected stop level shall set the frame-error indication. |
| RX-004 | An incorrect calculated or fixed parity bit shall set the sticky parity-error indication. |
| RX-005 | Parity and framing sticky error indications shall remain set until explicitly cleared by a write of `1` to their RX_DATA control bits. |
| RX-006 | A line held low for the configured break interval shall set the break indication and halt normal frame reception until the line becomes idle. |
| RX-007 | Reading RX_DATA shall pop the receive FIFO and return the oldest byte. Reading while empty shall set the RX FIFO error indication. |
| RX-008 | Received bytes shall be held in the receive FIFO until read; FIFO capacity shall be `2**LGFLEN`, bounded by the AXI wrapper to 2-1024 entries. |
| RX-009 | `o_uart_rx_int` shall assert while the receive FIFO is non-empty. |
| RX-010 | `o_uart_rxfifo_int` shall assert while the receive FIFO is at least half full. |
| RX-011 | Setup changes shall reset the receive FIFO and shall require at least sixteen idle baud intervals before normal reception resumes. |

## FIFO and Status Registers

| ID | Requirement |
|---|---|
| FIF-001 | The FIFO register at offset `0x4` shall report the FIFO log-size and fill/status fields for TX and RX in the specified upper and lower 16-bit halves. |
| FIF-002 | TX FIFO fill status shall report the number of available TX entries; RX FIFO fill status shall report the number of received entries. |
| FIF-003 | Writes to the FIFO status register shall be ignored. |
| FIF-004 | RX_DATA shall expose the oldest byte, sticky frame/parity/break flags, and receive FIFO overflow status in its defined fields. |
| FIF-005 | Writing `1` to RX_DATA reset bit 12 shall clear the receiver and receive FIFO and hold reception in reset until the UART line is idle. |
| FIF-006 | TX_DATA shall expose transmit busy/break status and transmit FIFO status/error fields in its defined fields. |

## Hardware Flow Control

| ID | Requirement |
|---|---|
| HFC-001 | `o_rts_n` shall be active low and shall prevent/indicate acceptance before the receive FIFO reaches the configured near-full condition when hardware flow control is enabled. |
| HFC-002 | The transmitter shall not start or continue a frame when enabled active-low `i_cts_n` indicates not clear to send. |
| HFC-003 | Setting the hardware-flow-control-disable parameter or setup bit shall remove hardware-flow-control gating without changing serial frame data formats. |

# Verification Plan

## Project Scope

In scope:
- AXI4-Lite reset, address decode, handshakes, byte strobes, read/write responses,
  and register field behavior;
- setup reconfiguration and all supported word-width, stop-bit, and parity modes;
- transmit and receive data integrity;
- FIFO fill, overflow, underflow, reset, and interrupt behavior;
- hardware flow control;
- break and line-error detection;
- baud timing and receive start/stop sampling.

Out of scope:
- AXI3/AXI4 protocol variations;
- Wishbone behavior;
- electrical/board-level SI, clock generation, and synthesis timing closure.

## Testbench Architecture & Verification Methodology
Verification methodology: UVM verification is in scope, directed testing is out of scope
RAL Layer for register
UART agent extended to create TX and RX versions
Scoreboard and Reference Model
AXI-lite protocol checker

The UVM environment will contain:
- AXI4-Lite agent including:
    - a Register Abstraction Layer
    - Assertions for AXI protocol checking
    - Driver
    - Monitor
    - Sequencer
    - Scoreboard
- Reusable UART agent including:
    - Extensiibility to create separate RX and TX UART agents
    - Driver
    - Monitor
    - Sequencer
- DUT reference model 
- Scoreboard to compare expected output from reference model to actual output


## Test Plan

| Test | Requirements | Description |
|---|---|---|
| `test_reset` | AXI-001, AXI-002, FIF-* | Assert reset during idle and active traffic; verify idle outputs and reset state. |
| `test_register_rw` | AXI-003..007, REG-001, FIF-003 | Test SETUP/FIFO/RX_DATA/TX_DATA reads, writes, byte strobes, and address decode. |
| `test_uart_loopback` | TX-001..003, RX-001..004 | Program one format, transmit bytes, loop/compare serial frames, and read receive FIFO. |
| `test_data_width_stop_parity` | REG-003..007, TX-002, RX-002..004 | Cross 5-8 data bits, 1-2 stop bits, parity off/odd/even/fixed mark/fixed space. |
| `test_baud_ranges` | REG-008, TX-003 | Exercise low/high divisor values and verify TX baud periods and RX mid-bit sampling. |
| `test_tx_fifo_stress` | TX-004..006, FIF-001..002 | Back-to-back writes, simultaneous drain, full/empty/half-full transitions. |
| `test_rx_fifo_stress` | RX-007..010, FIF-001..002 | Burst RX, simultaneous reads/writes where valid, and empty/half-full/full transitions. |
| `test_rx_errors_break` | RX-003..006 | Inject frame, parity, and break conditions and verify sticky/reset behavior. |
| `test_fifo_overflow_underflow` | FIF-004..006 | Attempt RX reads from empty and TX writes to full FIFO. |
| `test_flow_control` | HFC-001..003 | Toggle CTS and fill RX FIFO to validate RTS and transmit pausing. |
| `test_reconfigure_reset` | REG-009..010, RX-011, RX-008 | Change setup and reset controls during traffic; verify quiescent receive/transmit recovery. |
| `test_interrupts` | TX-005..006, RX-009..010 | Sweep FIFO thresholds and compare interrupt outputs to status. |
| `test_axi_backpressure_random` | AXI-004..007 | Random valid/ready timing, outstanding requests, and reset injection. |

## Coverage Plan

### Functional Coverage

- Setup fields: data width, stop count, parity mode, fixed parity value,
  hardware-flow-control setting, and divisor ranges.
- Serial frames: 5-8 data bits; 1-2 stop bits; no/odd/even/mark/space parity;
  all 256 transmitted and selected representative received byte patterns.
- AXI timing: address/data/response zero-delay and backpressure combinations;
  aligned and byte-strobe writes.
- FIFO state: empty, partially filled, half-full, full, simultaneous read/write,
  overflow, underflow, and reset.
- Interrupt state: asserted/deasserted at empty/half/full and non-empty thresholds.
- Error state: framing, parity, break, RX FIFO overflow/underflow, TX overflow,
  and sticky-error clearing.

### Cross-Coverage

- Baud divisor x serial format.
- FIFO fill state x read/write direction.
- Flow-control state x setup mode.
- Setup reconfiguration x TX busy/RX active.
- Interrupt thresholds x FIFO depth.

### Code Coverage

- Line coverage target: 95%.
- Toggle coverage target: 90%.
- Branch/condition coverage target: 95%.
- 100% coverage of meaningful UART and AXI protocol state transitions.

# Coverage Metrics

Coverage is measured from the committed UVM regression using simulator coverage
reports and the requirements traceability table. A waiver record must identify
the file, line/coverage point, and reason for any waived unreachable logic.

# Verification Closure & Sign-Off Criteria

Verification is complete only when:
- all planned tests pass with no unexpected errors or X/Z values;
- no unreviewed protocol assertion or scoreboard failure remains;
- all requirements have at least one passing directed or random test;
- functional coverage goals are met or explicitly waived;
- code coverage thresholds are met or explicitly waived;
- reset, loopback, error, FIFO, flow-control, and reconfiguration regressions
  pass in the final regression configuration.
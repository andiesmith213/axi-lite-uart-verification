# Summary
This document provides a detailed overview of the verification effort, including the verification methodology to be used, project scope, test/coverage plans and coverage metrics. Additionally, an overview of the design will be included in this document.

# Design Overview
Target DUT: ZipCPU's axiluart which consists of:
- AXI4-Lite register interface
- RX UART + RXFIFO
- TX UART + TXFIFO
- 200MHz (max) System clock 

# Verification Plan 
## Project Scope
## Testbench Architecture & Verification Methodology
## System Features and Coverage
## Test Plan
## Coverage Plan
## Coverage Metrics         
                  +-----------------------------------+
                  |           UVM Environment         |
                  |                                   |
                  |  +-------------+  +------------+  |
                  |  | AXI4-Lite   |  | UART Serial|  |
                  |  | Agent       |  | Agent      |  |
                  |  +------+------+  +-----+------+  |
                  |         |               |         |
                  |  +------+------+  +-----+------+  |
                  |  | Scoreboard  |  | Reference  |  |
                  |  | & Predictor |  | Model      |  |
                  |  +-------------+  +------------+  |
                  +---------+---------------+---------+
                            |               |
             AXI4-Lite Bus  |               | Serial Rx/Tx Pins
             (AW, W, B,     v               v
              AR, R)    +-----------------------+
                        |        axiluart       |
                        |         (DUT)         |
                        +-----------------------+
AXI4-Lite Agent: Active master agent driving address, write data, and read requests while monitoring handshakes (AWVALID/READY, WVALID/READY, BVALID/READY, ARVALID/READY, RVALID/READY).UART Serial Agent: Passive/Active agent modeling the asynchronous serial line, injecting bitstreams into the RX pin and capturing bitstream outputs from the TX pin.Scoreboard & Predictor: Maintains a mirror model of the control registers, baud divisors, and expected FIFO states to verify data integrity end-to-end.3. Feature Matrix & Requirements TraceabilityFeature IDDescriptionVerification MethodPriorityREQ-AXI-01AXI4-Lite write response (BVALID) must wait for both write address and write data channels (AWVALID & WVALID).Constrained-Random AXI SequencesHighREQ-AXI-02Issuing a read or write to an invalid address or handling bus errors appropriately.Error-Injection Test CasesMediumREQ-REG-01Baud rate divisor register configuration correctly scales the internal sample clock.Directed & Random Register SequencesHighREQ-FIFO-01Transmit FIFO (16-deep) handles back-to-back writes; writing to a full FIFO triggers proper error/stall behavior.FIFO Saturation SequencesHighREQ-FIFO-02Receive FIFO (16-deep) correctly stores incoming serial characters; reading an empty FIFO returns error responses.Underflow & Burst Read SequencesHighREQ-UART-01Full-duplex parallel-to-serial (TX) and serial-to-parallel (RX) data translation matches byte-for-byte.End-to-End Scoreboard ComparisonHighREQ-INT-01Interrupt lines assert when RX FIFO is non-empty or TX FIFO goes empty (respecting mask bits).Interrupt Monitoring ChecksMedium4. Test Plan (Stimulus Scenarios)test_reset_behavior: Verify all registers return to default values upon assertion of S_AXI_ARESETN.test_reg_rw: Perform exhaustive read/write operations across all accessible control, status, and baud divisor registers.test_uart_loopback_basic: Send a single character via AXI write to the TX FIFO, monitor the serial TX pin, loop it back to the RX pin, and read it back via AXI.test_fifo_stress_constrained_random: Back-to-back randomized writes to fill the 16-character TX FIFO, interspersed with random baud rate changes and asynchronous RX inputs.test_error_conditions: Attempt to read an empty RX FIFO or write to a full TX FIFO, verifying correct AXI error response handling (SLVERR).5. Checking Strategy (Scoreboards & Assertions)Scoreboard Checking:Captures AXI write payloads destined for the TX FIFO, models the bit-level serial transmission delay based on the current baud divisor, and cross-checks the captured waveform on the serial TX pin.Injects randomized bytes into the RX serial pin, packs them into characters based on configured data width, and expects them to appear precisely at the top of the AXI RX FIFO register read queue.SystemVerilog Assertions (SVA):Handshake Stability: PROPERTY (S_AXI_AWVALID |-> stable(S_AXI_AWADDR)).No Overflows: Assert that internal FIFO write pointers never increment past capacity when full.6. Functional & Code Coverage PlanCode Coverage Goals:Line Coverage: > 95%Toggle Coverage: > 90%FSM State / Branch Coverage: 100% of control state machine transitions.Functional Coverage (Covergroups):Baud Rate Cross FIFO Depth: Cross-coverage binning varying baud divisor speeds against empty, half-full, and fully saturated FIFO states.AXI Handshake Timing: Cross-binning AW/W/AR ready-to-valid timing delays (zero-cycle turnaround vs. multi-cycle stalls). 
## Verification Closure & Sign-Off CriteriaVerification will be declared complete when:All test cases in the test plan execute with 0 errors.100% Functional Coverage goals are met and verified via test reports.Code coverage thresholds (>95% line / >90% toggle) are satisfied.All SVA assertion checks pass with zero violations across a 100,000-cycle regression run.
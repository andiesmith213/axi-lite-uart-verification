

module testbench;
    //import UVM packages and macros
    import uvm_pkg::*
    `include "uvm_macros.svh"

    //import environment & uart package here

    //Clock and reset generation
    logic clk; 
    bit rst;
    assign #5 clk = !clk;

    initial begin
        rst = 1;
        #5 rst = 0;
    end
    

    //Connect DUT to environment via virtual interface


    //Instantiate DUT
    axiluart DUT (    
            .S_AXI_ACLK (clk),
            .S_AXI_ARESETN (rst),
            .S_AXI_AWVALID (),
            .S_AXI_AWREADY (),
            .S_AXI_AWADDR (),
            .S_AXI_AWPROT (),
            .S_AXI_WVALID (),
            .S_AXI_WREADY (),
            .S_AXI_WDATA (),
            .S_AXI_WSTRB (),
            .S_AXI_BVALID (),
            .S_AXI_BREADY (),
            .S_AXI_BRESP (),
            .S_AXI_ARVALID (),
            .S_AXI_ARREADY (),
            .S_AXI_ARADDR (),
            .S_AXI_ARPROT (),
            .S_AXI_RVALID (),
            .S_AXI_RREADY (),
            .S_AXI_RDATA (),
            .S_AXI_RRESP (),
            .i_uart_rx (),
            .o_uart_tx (),
            .i_cts_n (),
            .o_rts_n (),
            .o_uart_rx_int (),  //irq
            .o_uart_tx_int (),  //irq
            .o_uart_rxfifo_int (),  //irq
            .o_uart_txfifo_int ()   //irq
    );

    //dump waveforms
    initial begin
        $dumpfile("dump.vcd"); $dumpvars;
    end

    //incude and run tests
    `include "test_lib.sv"
    initial begin
        run_test("basic_sanity_check");
    end

endmodule
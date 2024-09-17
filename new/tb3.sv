`timescale 1ns / 1ps
//*************************************************///////

// ASSIGNMENTS AND TESTING FOR SECTION 8: IPC

//*************************************************///////


// ASSIGNMENT A71: INTERFACES, DRIVER, GENERATOR //

class transaction;
    randc bit [3:0] a, b;
    bit [7:0] mul;

    function transaction copy();
        copy = new();
        copy.a = this.a;
        copy.b = this.b;
        copy.mul = this.mul;
    endfunction
endclass

class generator;
    transaction tx;
    mailbox #(transaction) gen2drv;
    event data_processed;

    function new(input mailbox #(transaction) gen2drv, input event data_processed);
        tx = new();
        this.gen2drv = gen2drv;
        this.data_processed = data_processed;
    endfunction : new

    task run();
        repeat (10) begin
            // Randomize transaction with fail check
            assert(tx.randomize()) else $display("Randomization Failed");
            // Send copy of tx to mailbox
            gen2drv.put(tx.copy());
            $display("[GEN]: DATA SENT TO DRIVER AT %0t: a = %0d, b = %0d", $time, tx.a, tx.b);
            // Wait for driver to finish with data
            @(data_processed.triggered);
        end
    endtask : run
endclass

interface dut_if (input logic clk);
    logic [3:0] a, b;
    logic [7:0] mul;

    
    clocking cb @(posedge clk);
        output a, b;
        input mul;
    endclocking

    modport TB (clocking cb);

    modport DUT (input a, b,
                    output mul);
endinterface

class driver;
    virtual dut_if.TB dif;
    transaction data;
    mailbox #(transaction) gen2drv;
    event data_processed;

    // Construct new driver and assign mailbox, event, and interface
    function new(input mailbox #(transaction) gen2drv, input event data_processed);
        this.gen2drv = gen2drv;
        this.data_processed = data_processed;
        this.dif = tb3.dif;
    endfunction : new

    task run();
        // Initialize interface ports
        dif.cb.a <= 0;
        dif.cb.b <= 0;

        forever begin
            // Grab tx from mailbox
            gen2drv.get(data);
            @(dif.cb);
            // Send individual signals to interface
            dif.cb.a <= data.a;
            dif.cb.b <= data.b;
            $display("[DRV]: DATA SENT TO INTERFACE AT %0t: a = %0d, b = %0d", $time, data.a, data.b);
            // Trigger event to signal to generator that it can send next transaction
            ->data_processed;
        end
    endtask
endclass

module tb3();
    // Construct driver, clock, generator, mailbox, and interface
    // Also construct event to synchronize driver and generator
    bit clk;
    mailbox #(transaction) gen2drv;
    driver drv;
    generator gen;
    dut_if dif(clk);
    event data_processed;

    // Start clock
    initial begin
        clk = 0;
        forever begin
            #5;
            clk = ~clk;
        end
    end

    // Initialize mailbox, interface, and testbench parts
    initial begin
        gen2drv = new();
        drv = new(gen2drv, data_processed);
        gen = new(gen2drv, data_processed);
        // Spawn threads for driver and generator
        fork
            gen.run();
            drv.run();
        join_none
        #2000;
        $finish;
    end
endmodule



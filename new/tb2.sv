`timescale 1ns / 1ps
//*************************************************///////

// ASSIGNMENTS AND TESTING FOR SECTION 5 THROUGH 7

//*************************************************///////


// ASSIGNMENT A51: CLASS INITIALIZATION //

/*
class TestClass;
        bit [31:0] d1, d2, d3;
endclass
 
module tb2();
    
    TestClass test;
    
    initial begin
        test = new();
        test.d1 = 45;
        test.d2 = 78;
        test.d3 = 90;
        $display("The values are: %0d, %0d, and %0d.", test.d1, test.d2, test.d3);
    end
    
endmodule
*/

//*************************************************//

// ASSIGNMENT A52: FUNCTIONS //

/*
module tb2();
    bit[63:0] result;
    function bit[63:0] multiply(bit[31:0] a, bit[31:0] b);
        return a*b;
    endfunction
    
    initial begin
        result = multiply(5,4);
        $display("The result is %0d.", result);
    end
endmodule
*/

//*************************************************//

// ASSIGNMENT A53: TASKS //
/*
module tb2();
    logic [5:0] addr;
    logic en, wr;
    logic clk = 0;
    
    task genstim(input a, b, input logic [5:0] c);
        en = a;
        wr = b;
        addr = c;
    endtask
    
    initial begin
        #20;
        genstim(1, 1, 12);
        #40;
        genstim(1, 1, 14);
        #40;
        genstim(1, 0, 23);
        #40;
        genstim(1, 0, 48);
        #40;
        genstim(0, 0, 56);
        #40;
    end
    
    always begin
        #20;
        clk = ~clk;
    end
endmodule
*/

//*************************************************//

// ASSIGNMENT A54: PASSING ARRAYS TO FUNCTIONS //
/*
module tb2();

    logic[7:0] arr[32];
    
    function automatic void gen_values(ref logic[7:0] res_array[32]);
        for (int i = 0; i < 32; i++) begin
            res_array[i] = 8*i;
        end
    endfunction
    
    initial begin
        gen_values(arr);
        #1;
        $display("The array result is: %0p", arr);
    end
endmodule
*/

//*************************************************//

// ASSIGNMENT A54.5: STREAMING OPERATORS //
/*
module tb2();
    initial begin
        bit[11:0] a = 12'b1110_0001_1100;
        bit[11:0] b = {<<{{<<4{a}}}};
        $display("Result: %b", b);
    end
endmodule
*/

//*************************************************//

// ASSIGNMENT A55: CUSTOM CONSTRUCTORS FOR CLASSES //
/*
module tb2();
    class test_class;
        bit [7:0] a, b, c;

        function new(input bit [7:0] a, b, c);
            this.a = a;
            this.b = b;
            this.c = c;
        endfunction
    endclass

    initial begin
        test_class test;
        test = new(2, 4, 56);
        $display("a equals %0d, b equal %0d, c equals %0d", test.a, test.b, test.c);
    end
endmodule
*/

//*************************************************//

// ASSIGNMENT A56: TASKS IN CLASSES //
/*
module tb2();
    class test_class;
        bit [4:0] a, b, c;

        function new(input bit [4:0] a = 0, b = 0, c = 0);
            this.a = a;
            this.b = b;
            this.c = c;
        endfunction

        // The sum of three 4-bit numbers needs a 6-bit result.
        task add_members(output bit [6:0] sum);
            sum = a + b + c;
            $display("The sum of %0d, %0d, and %0d is: %0d", a, b, c, sum);
        endtask
    endclass
 
    initial begin
        test_class test;
        bit [6:0] sum;
        test = new(1, 2, 4);
        test.add_members(sum);
        $display("The sum outside of the class is %0d", sum);
    end
endmodule
*/

//*************************************************//

// ASSIGNMENT A55: CUSTOM CONSTRUCTORS FOR CLASSES //
/*
module tb2();
    class generator;
        bit [3:0] a = 5,b =7;
        bit wr = 1;
        bit en = 1;
        bit [4:0] s = 12;
        
        function void display();
            $display("a:%0d b:%0d wr:%0b en:%0b s:%0d", a,b,wr,en,s);
        endfunction

        function generator copy();
            copy = new();
            copy.a = a;
            copy.b = b;
            copy.wr = wr;
            copy.en = en;
            copy.s = s;
        endfunction
    endclass

    class top;
        generator gen;

        function new();
            gen = new();
        endfunction

        function top copy();
            copy = new();
            copy.gen = gen.copy();
        endfunction
    endclass

    initial begin
        top t1;
        top t2;
        t1 = new();
        t2 = t1.copy();
        $display("T1 generator a value is %0d", t1.gen.a);
        t2.gen.a = 2;
        $display("T2 generator a value is %0d", t2.gen.a);
        $display("T1 generator new a value is %0d", t1.gen.a);
    end

endmodule
*/

//*************************************************//

// ASSIGNMENT A61: RANDOMIZING GENERATOR //
/*
module tb2();
    class generator;
        rand bit [7:0] x, y, z;

        function display();
            $display("The values of x, y, and z at time %0t are %0d, %0d, and %0d", $time, x, y, z);
        endfunction
    endclass

    initial begin
        generator g;
        for (int i = 0; i < 20; i++) begin
            g = new();
            assert(g.randomize()) else begin
                $display("Randomization failed at time %0t", $time);
            end;
            g.display();
            #20;
        end
    end

endmodule
*/

//*************************************************//

// ASSIGNMENT A62: RANDOM CONSTRAINTS AND EXTERNAL CONSTRAINTS/FUNCTIONS //
/*
module tb2();
    class generator;
        rand bit [7:0] x, y, z;

        extern constraint data;
        extern function void display();
    endclass

    constraint generator::data { 
        x inside {[0:50]};
        y inside {[0:50]};
        z inside {[0:50]};
    }

    function void generator::display();
        $display("The values are x = %0d, y = %0d, z = %0d", x, y, z);
    endfunction

    generator g;

    initial begin
        for (int i = 0; i < 20; i++) begin
            g = new();
            g.randomize();
            g.display();
            #20;
        end
    end

endmodule
*/

//*************************************************//

// ASSIGNMENT A63: RANDOM CONSTRAINTS AND RANDOMIZATION FAILURES //
/*
module tb2();
    class generator;
        rand bit [4:0] a;
        rand bit [5:0] b;

        constraint data {
        a inside {[0:8]};
        b inside {[0:5]};
        }

    endclass

    initial begin
        generator g;
        bit status;
        int failures = 0;
        for (int i = 0; i < 20; i++) begin
            g = new();
            status = g.randomize();
            if (!status) begin
                failures += 1;
            end
            $display("a = %0d, b = %0d", g.a, g.b);
            #10;
        end
        #10;
        $display("Number of failures: %0d", failures);
    end

endmodule
*/

//*************************************************//

// ASSIGNMENT A64: WEIGHTED DISTRIBUTIONS //
/*
module tb2();
    class generator;
        rand bit wr, rst;

        constraint c_signals {
            {wr==0} -> {rst==1};
        }
        
        /*constraint c_dist {
            wr dist {0:=50, 1:=50};
            rst dist {0:=50, 1:=50};
        }

        function void display();
            $display("wr is %0d, rst is %0d", wr, rst);
        endfunction
    endclass

    generator g;
    int status;
    int high_high_count = 0;
    int high_low_count = 0;
    int low_high_count = 0;
    int low_low_count = 0;

    initial begin
        for (int i = 0; i < 10000; i++) begin
            g = new();
            status = g.randomize();
            if (!status) begin
                $finish("Randomization failed!");
            end
            g.display();
            if (g.wr == 1 && g.rst == 1) begin
                high_high_count += 1;
            end
            else if (g.wr == 1 && g.rst == 0) begin
                high_low_count += 1;
            end
            else if (g.wr == 0 && g.rst == 1) begin
                low_high_count += 1;
            end
            else begin
                low_low_count += 1;
            end
            #1;
        end

        //$display("wr was high for %0d iterations. rst was high for %0d iterations.", wr_count, rst_count);
        $display("high_high = %0d, high_low = %0d, low_high = %0d, low_low = %0d", high_high_count, high_low_count, low_high_count, low_low_count);
        $finish;
    end
endmodule
*/

//*************************************************//

// ASSIGNMENT A65: CONSTRAINT IMPLICATION AND EQUIVALENCE OPERATORS //
/*
module tb2();
    class generator;
        rand bit [3:0] addr;
        rand bit wr;

        constraint signals {
            {wr == 1} -> {addr inside {[0:7]}};
            {wr == 0} -> {addr inside {[8:15]}};
        }

    endclass

    generator g;
    
    initial begin
        for (int i = 0; i < 20; i++) begin
            g = new();
            g.randomize();
            $display("wr: %0d, addr: %0d", g.wr, g.addr);
        end
    end
endmodule
*/

//*************************************************//

// ASSIGNMENT A81: PARALLEL TASKS WITH FORK...JOIN //
/*
module tb2();

    task automatic task_1(ref int count);
        forever begin
            #20;
            $display("Task 1 Trigger");
            count += 1;
        end
    endtask

    task automatic task_2(ref int count);
        forever begin
            #40;
            $display("Task 2 Trigger");
            count += 1;
        end
    endtask

    int task_1_count = 0;
    int task_2_count = 0;
    
    initial begin
        fork
            task_1(task_1_count);
            task_2(task_2_count);
            #200;
        join_any
        $display("Task 1 executed %0d times, Task 2 executed %0d times.", task_1_count, task_2_count);
        $finish;
    end

endmodule
*/

//*************************************************//

// ASSIGNMENT A82: MAILBOXES //

module tb2();

    class transaction;
        bit [7:0] addr = 7'h12;
        bit [3:0] data = 4'h4;
        bit we = 1'b1;
        bit rst = 1'b0;
    endclass

    class generator;
        mailbox #(transaction) gen2drv;
        transaction t;

        function new(mailbox #(transaction) gen2drv);
            this.gen2drv = gen2drv;
        endfunction

        task run;
            forever begin
                t = new();
                gen2drv.put(t);
                $display("[GENERATOR] Sent transaction at time %0t: addr=%0h, data=%0h, we=%0b, rst=%0b", $time, t.addr, t.data, t.we, t.rst);
                #10;
            end
        endtask
    endclass

    class driver;
        mailbox #(transaction) gen2drv;
        transaction t;

        function new(mailbox #(transaction) gen2drv);
            this.gen2drv = gen2drv;
        endfunction

        task run;
            forever begin
                gen2drv.get(t);
                $display("[DRIVER] Received transaction at time %0t: addr=%0h, data=%0h, we=%0b, rst=%0b", $time, t.addr, t.data, t.we, t.rst);
                #10;
            end
        endtask
    endclass

    generator g;
    driver d;
    mailbox #(transaction) gen2drv;

    initial begin
        gen2drv = new();
        g = new(gen2drv);
        d = new(gen2drv);
        fork
            g.run();
            d.run();
        join_none
    end

    initial begin
        #200;
        $finish;
    end

endmodule
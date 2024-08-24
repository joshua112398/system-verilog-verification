`timescale 1ns / 1ps
/////////////////////////////////////////////////

// ASSIGNMENTS AND TESTING FOR SECTION 5: OOP CONSTRUCTS

/////////////////////////////////////////////////


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

////////////////////////////////////////////

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

////////////////////////////////////////////

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

////////////////////////////////////////////

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

////////////////////////////////////////////

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
////////////////////////////////////////////

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
////////////////////////////////////////////

// ASSIGNMENT A55: CUSTOM CONSTRUCTORS FOR CLASSES //
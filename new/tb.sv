`timescale 1ns/1ns

/////////////////////////////////////////////////

// ASSIGNMENTS AND TESTING FOR SECTION 3: UNDERSTANDING SV DATATYPES

/////////////////////////////////////////////////

/* ASSIGNMENT 6: ARRAY INITIALIZATION
module tb();
    logic [31:0] arr[10];
    int i = 0;
    initial begin
        for (i = 0; i < 10; i++) begin
            arr[i] = i**2;
        end
        $display("Array is: %p", arr);
    end
    
endmodule
*/

/* ASSIGNMENT 7: FIXED-SIZE ARRAYS 

module tb();
    reg [31:0] arr1[15], arr2[15];
    initial begin
        foreach(arr1[i]) begin
            arr1[i] = $urandom;
            arr2[i] = $urandom;
        end
        #5;
        $display("Array 1 is: %p", arr1);
        #1;
        $display("Array 2 is %p", arr2);
        $finish;
    end
endmodule

*/

/* ASSIGNMENT 8: DYNAMIC ARRAYS 

module tb();
    logic [7:0] arr[];
    initial begin
        arr = new[7];
        foreach(arr[i]) begin
            arr[i] = (i+1)*7;
        end
        #20;
        arr = new[20](arr);
        for(int i = 7; i < 20; i++) begin
            arr[i] = (i-6)*5;
        end
        $display("The final array is: %p", arr);
    end
endmodule

*/

/* ASSIGNMENT 9: QUEUES 

module tb();
    reg [7:0] arr[20];
    reg [7:0] q[$];
    
    initial begin
        foreach (arr[i]) begin
            arr[i] = $urandom;
        end
        #1;
        foreach (arr[i]) begin
            q.push_front(arr[i]);
        end
        $display("The array is: %0p", arr);
        $display("The queue is: %0p", q);
    end
endmodule

*/

/* EXPERIMENT: TESTING IF ARRAY COPY IS BY VALUE 

module tb();
    logic [3:0] arr1[];
    logic [3:0] arr2[];
    
    initial begin
        arr1 = new[10];
        arr2 = new[10];
        arr1 = '{0,1,2,3,4,5,6,7,8,9};
        arr2 = '{default:'0};
        $display("Arr 1 is %p", arr1);
        $display("Arr 2 is %p", arr2);
        arr2 = arr1;
        $display("New Arr 2 is %p", arr2);
        arr1[0] = 9;
        #1;
        $display("New Arr 2 is %p", arr2);
    end
endmodule

*/

module tb();
endmodule


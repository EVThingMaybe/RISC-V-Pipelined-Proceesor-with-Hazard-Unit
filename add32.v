//*********************************************************//
//************  adder 32-bit   *******************************//
//************************************************************//
module add32(a, b, sum, carry_out,carry_in);
    input [31:0] a, b;
    input carry_in;
    output [31:0] sum;
    output carry_out;
    assign {carry_out, sum} = a + b + carry_in;
endmodule

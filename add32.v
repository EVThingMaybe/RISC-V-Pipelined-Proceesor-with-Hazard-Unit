//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    18:55:22 05/15/2019
// Design Name:
// Module Name:    add32
// Project Name:
// Target Devices:
// Tool versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////
module add32(a, b, sum, carry_out,carry_in);
    input [31:0] a, b;
    input carry_in;
    output [31:0] sum;
    output carry_out;
    assign {carry_out, sum} = a + b + carry_in;
endmodule
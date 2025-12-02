
module alu (
  input [7:0] a,
  input [7:0] b,
  input [3:0] op,
  output reg [7:0] result,
  output reg carry,
  output reg zero,
  output reg overflow,
  output reg negative
);

always @(*) begin
  carry = 0;
  overflow = 0;
  negative = 0;
  zero = 0;
  case (op)
    4'h0: {carry, result} = a + b;
    4'h1: {carry, result} = a - b;
    4'h2: result = a & b;
    4'h3: result = a | b;
    4'h4: result = a ^ b;
    4'h5: result = a << b[2:0];
    4'h6: result = a >> b[2:0];
    4'h7: result = $signed(a) >>> b[2:0];
    4'h8: {carry, result} = a * b[7:0]; // Low byte, carry high
    default: result = 8'h0;
  endcase
  zero = (result == 8'h0);
  negative = result[7];
  if (op == 4'h0) overflow = (a[7] == b[7]) & (result[7] != a[7]);
  if (op == 4'h1) overflow = (a[7] != b[7]) & (result[7] != a[7]);
end
endmodule
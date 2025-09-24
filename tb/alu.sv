
module alu #(
  parameter int unsigned BW = 16
) (
  input  logic signed [BW-1:0] in_a,
  input  logic signed [BW-1:0] in_b,
  input  logic        [2:0]    opcode,
  output logic signed [BW-1:0] out,
  output logic        [2:0]    flags // {overflow, negative, zero}
);

localparam ADD  = 3'b000;
localparam SUB  = 3'b001;
localparam AND_ = 3'b010;
localparam OR_  = 3'b011;
localparam XOR_ = 3'b100;
localparam INC  = 3'b101;
localparam MOVA = 3'b110;
localparam MOVB = 3'b111;

logic zero, negative, overflow;

always_comb begin
  out = '0;
  case (opcode)
    ADD : out = in_a + in_b;
    SUB : out = in_a - in_b;
    AND_: out = in_a & in_b;
    OR_ : out = in_a | in_b;
    XOR_: out = in_a ^ in_b;
    INC : out = in_a + 1;
    MOVA: out = in_a;
    MOVB: out = in_b;
    default: out = '0;//In simulation, change it to x to find bugs
  endcase
end

always_comb begin
  zero     = (out == '0)?1'b1 : 1'b0;
  negative = (out < 0)?1'b1 : 1'b0;
  case (opcode)
    ADD: overflow = (in_a[BW-1] == in_b[BW-1]) && (out[BW-1] != in_a[BW-1]);
    SUB: overflow = (in_a[BW-1] != in_b[BW-1]) && (out[BW-1] != in_a[BW-1]);
    default: overflow = 1'b0;
  endcase
end

assign flags = {overflow, negative, zero};

endmodule

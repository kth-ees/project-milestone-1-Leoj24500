`timescale 1ns/1ps
module alu_tb;

  parameter BW = 16; // bitwidth

  logic signed [BW-1:0] in_a;
  logic signed [BW-1:0] in_b;
  logic             [2:0] opcode;
  logic signed [BW-1:0] out;
  logic             [2:0] flags; // {overflow, negative, zero}

  // Instantiate the ALU
  alu #(BW) dut (
    .in_a(in_a),
    .in_b(in_b),
    .opcode(opcode),
    .out(out),
    .flags(flags)
  );

  //function  automatic logic [BW-1: 0] expAdd (input logic [BW-1: 0]);
  //endfunction
  task automatic rand_in_range(output int val, input int low, input int high);
    val = $urandom_range(low + 32768, high + 32768) - 32768;
  endtask
  // Generate stimuli to test the ALU
  initial begin
    // sepereate all parts of the code (Opcode)
    //check if they are the same as expected answer
    //$urandom
    //int rand_val;
    int result;
      opcode = 000;
      //all pos may overflow
      //not overflow
      for (int i = 0; i< 5; i++) begin
        rand_in_range(in_a, 0, 16384);
        rand_in_range(in_b, 0, 16384);
        result= in_a + in_b;
        #10ns;
        if (out !== result)$error("ERROR: addition error opcode 000: a-number %0d and b-number %0d, output %0d", in_a, in_b, out);

        rand_in_range(in_a, 16385, 32767);
        rand_in_range(in_b, 16385, 32767);
        result = in_a + in_b;
        #10ns;
        if (out !== result) $display("opcode 000: overflow a-number %0d and b-number %0d, output %0d", in_a, in_b, out);
        //might be 110 becuse the bit may flip over to negative when an overflow occures
        if (!(flags == 3'b100 || flags == 3'b110)) $error("opcode 000 _1: Flag error a-number %0d and b-number %0d, flag %0d", in_a, in_b, flags);
         
        rand_in_range(in_a, -16385, -1);
        rand_in_range(in_b, -16385, -1);
        result = in_a + in_b;
        #10ns;
        if (out !== result) $display("opcode 000: overflow a-number %0d and b-number %0d, output %0d", in_a, in_b, out);
        if (flags !== 3'b010) $error("opcode 000_2: Flag error a-number %0d and b-number %0d, flag %0d", in_a, in_b, flags); 
      end
      //zero flag check
      in_a = 0;
      in_b = 0;
      result = in_a + in_b;
      #10ns;
      if (out !== result) $error("opcode 000: overflow a-number %0d and b-number %0d, output %0d", in_a, in_b, out);
      if (flags !== 3'b001) $error("opcode 000_3: Flag error a-number %0d and b-number %0d, flag %0d", in_a, in_b, flags); 

      //overflow
      //all neg may overflow
      //one pos one neg
      opcode = 001;
      //underflow
      for (int i = 0; i< 5; i++) begin
        rand_in_range(in_a, -32768, -16386);
        rand_in_range(in_b, 16385, 32767);
        result = in_a - in_b;
        #10ns;
        if (out !== result) $display("opcode 001: overflow a-number %0d and b-number %0d, output %0d", in_a, in_b, out);
        rand_in_range(in_a, -16386, 0);
        rand_in_range(in_b, 0, 16385);
        result = in_a - in_b;
        #10ns;
        if (out !== result) $error("opcode 001: overflow a-number %0d and b-number %0d, output %0d", in_a, in_b, out);
        if (flags !== 3'b010) $error("opcode 001: Flag error a-number %0d and b-number %0d, Flag %0d", in_a, in_b, flags);
        //overflow
        rand_in_range(in_a, -32768, -16388);
        rand_in_range(in_b, 16385, 32767);
        result = in_a - in_b;
        #10ns;
        if (out !== result) $display("opcode 001: overflow a-number %0d and b-number %0d, output %0d", in_a, in_b, out);
        if (flags !== 3'b100) $error("opcode 001: Flag error a-number %0d and b-number %0d, Flag %0d", in_a, in_b, flags);
      end
      in_a = 0;
      in_b = 0;
      result = in_a - in_b;
      #10ns;
      if (out !== result) $error("opcode 001: overflow a-number %0d and b-number %0d, output %0d", in_a, in_b, out);
      if (flags !== 3'b001) $error("opcode 001: Flag error a-number %0d and b-number %0d, Flag %0d", in_a, in_b, flags); 

      opcode = 010;
      for (int i = 0; i< 5; i++) begin
        rand_in_range(in_a, -32768, 32767);
        rand_in_range(in_b, -32768, 32767);
        result = in_a & in_b;
        #10ns;
        if (out !== result) $display("opcode 010: overflow a-number %0d and b-number %0d, output %0d", in_a, in_b, out);
      end
      in_a = 0;
      in_b = 0;
      result = in_a & in_b;
      #10ns;
      if (out !== result) $display("opcode 010: overflow a-number %0d and b-number %0d, output %0d", in_a, in_b, out);
      if (flags !== 3'b001) $error("opcode 010: Flag error a-number %0d and b-number %0d, Flag %0d", in_a, in_b, flags); 

      opcode = 011;
      for (int i = 0; i< 5; i++) begin
        rand_in_range(in_a, -32768, 32767);
        rand_in_range(in_b, -32768, 32767);
        result = in_a | in_b;
        #10ns;
        if (out !== result) $display("opcode 011: overflow a-number %0d and b-number %0d, output %0d", in_a, in_b, out);
      end
      in_a = 0;
      in_b = 0;
      result = in_a | in_b;
      #10ns;
      if (out !== result) $display("opcode 011: overflow a-number %0d and b-number %0d, output %0d", in_a, in_b, out);
      if (flags !== 3'b001) $error("opcode 011: Flag error a-number %0d and b-number %0d, Flag %0d", in_a, in_b, flags); 

      opcode = 100;
      for (int i = 0; i< 5; i++) begin
        rand_in_range(in_a, -32768, 32767);
        rand_in_range(in_b, -32768, 32767);
        result = in_a ^ in_b;
        #10ns;
        if (out !== result) $display("opcode 100: overflow a-number %0d and b-number %0d, output %0d", in_a, in_b, out);
      end
      in_a = 0;
      in_b = 0;
      result = in_a ^ in_b;
      #10ns;
      if (out !== result) $display("opcode 100: overflow a-number %0d and b-number %0d, output %0d", in_a, in_b, out);
      if (flags !== 3'b001) $error("opcode 100: Flag error a-number %0d and b-number %0d, Flag %0d", in_a, in_b, flags); 

      opcode = 101;
      for (int i = 0; i< 5; i++) begin
        rand_in_range(in_a, -32768, 32767);
        rand_in_range(in_b, -32768, 32767);
          result = in_a + 1;
          #10ns;
        if (out !== result) $display("opcode 101: overflow a-number %0d and b-number %0d, output %0d", in_a, in_b, out);
      end
      in_a = 16'b1111111111111111;
      result = in_a + 1;
      #10ns;
      //Check overflow flag
      if (flags !== 3'b100) $display("opcode 101: Flag error a-number %0d and b-number %0d, Flag %0d", in_a, in_b, flags); 
      in_a = -1;
      in_b = 0;
      result = in_a + 1;
      #10ns;
      if (out !== result) $display("opcode 101: overflow a-number %0d and b-number %0d, output %0d", in_a, in_b, out);
      if (flags !== 3'b001) $error("opcode 101: Flag error a-number %0d and b-number %0d, Flag %0d", in_a, in_b, flags); 

      rand_in_range(in_a, -32768, -2);
      in_b = 0;
      result = in_a + 1;
      #10ns;
      if (out !== result) $display("opcode 101: overflow a-number %0d and b-number %0d, output %0d", in_a, in_b, out);
      if (flags !== 3'b010) $error("opcode 101: Flag error a-number %0d and b-number %0d, Flag %0d", in_a, in_b, flags); 

      opcode = 110;
      for (int i = 0; i< 5; i++) begin
        rand_in_range(in_a, -32768, 32767);
        rand_in_range(in_b, -32768, 32767);
        #10ns;
        if (out !== in_a) $error("opcode 110: overflow a-number %0d and b-number %0d, output %0d", in_a, in_b, out);
      end
      in_a = 0;
      in_b = 1;
      #10ns;
      if (out !== in_a) $error("opcode 110: overflow a-number %0d and b-number %0d, output %0d", in_a, in_b, out);
      if (flags !== 3'b001) $error("opcode 110: Flag error a-number %0d and b-number %0d, Flag %0d", in_a, in_b, flags); 

      opcode = 111;
      for (int i = 0; i< 5; i++) begin
        rand_in_range(in_a, -32768, 32767);
        rand_in_range(in_b, -32768, 32767);
        #10ns;
        if (out !== in_b) $display("opcode 111: overflow a-number %0d and b-number %0d, output %0d", in_a, in_b, out);
      end
      in_a = 1;
      in_b = 0;
      #10ns;
      if (out !== in_b) $error("opcode 111: overflow a-number %0d and b-number %0d, output %0d", in_a, in_b, out);
      if (flags !== 3'b001) $error("opcode 111: Flag error a-number %0d and b-number %0d, Flag %0d", in_a, in_b, flags); 
  end
endmodule

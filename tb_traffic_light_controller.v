`timescale 1ns/1ps

module tb_traffic_light_controller;

  parameter DATA_WIDTH = 3;
  parameter NUM_INPUTS = 4;      

  reg clk;
  reg reset;
  reg valid;
  reg [DATA_WIDTH-1:0] instruction;
  wire [3:0] lights;

  reg [DATA_WIDTH-1:0] instr_mem [0:NUM_INPUTS-1];
  integer i;

  traffic_light_controller dut (
    .clk(clk),
    .reset(reset),
    .valid(valid),
    .instruction(instruction),
    .lights(lights)
  );

  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  initial begin
    reset = 1;
    valid = 0;
    instruction = 0;
  
    #20;
    reset = 0;
    
    $readmemb("input.txt", instr_mem);

    for (i = 0; i < NUM_INPUTS; i = i + 1) begin
      @(posedge clk);
      instruction = instr_mem[i];
      valid = 1;
      $display("");
      $display("Testbench: Applying instruction %b", instruction);
      $display("");
      @(posedge clk);
      valid = 0;
      if (instr_mem[i][2] == 1'b1) begin
         repeat (5) @(posedge clk);
      end
    end

    repeat (2) begin
      @(posedge clk);
      instruction = 0;
      valid = 0;
      $display("");
      $display("Testbench: No instruction (Normal Transition)");
      $display("");
    end

    $finish;
  end

endmodule
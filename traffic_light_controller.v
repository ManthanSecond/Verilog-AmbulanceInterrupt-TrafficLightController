module traffic_light_controller(
    input clk,
    input reset,
    input valid,             
    input [2:0] instruction, 
    output reg [3:0] lights  
);

  localparam STATE_FETCH         = 3'd0;
  localparam STATE_NORMAL        = 3'd1;
  localparam STATE_INT_STORE     = 3'd2;
  localparam STATE_INT_ALL_RED   = 3'd3;
  localparam STATE_INT_AMBULANCE = 3'd4;
  localparam STATE_INT_RECOVERY  = 3'd5;
  localparam STATE_INT_RESTORE   = 3'd6;

  reg [2:0] state;
  reg [1:0] current_road;  
  reg [1:0] stored_road;   
  reg [2:0] instr_reg;     
  reg       interrupt;     
  reg [1:0] ambulance_road;

  reg [31:0] instr_counter;      
  reg [31:0] stored_instr_counter; 

  always @(posedge clk or posedge reset) begin
    if (reset) begin
      state                <= STATE_FETCH;
      current_road         <= 2'd0;
      stored_road          <= 2'd0;
      instr_reg            <= 3'd0;
      interrupt            <= 1'b0;
      ambulance_road       <= 2'd0;
      lights               <= 4'b0001; 
      instr_counter        <= 32'd0;
      stored_instr_counter <= 32'd0;
    end else begin
      case (state)
        STATE_FETCH: begin
          $display("\n============================================");
          if (valid) begin
            // FETCH
            instr_reg      <= instruction;
            // DECODE
            interrupt      <= instruction[2];
            ambulance_road <= instruction[1:0];
            
            instr_counter <= instr_counter + 1;
            $display(">> Fetched Instruction: %03b", instruction);
            $display(">> Decoded: Interrupt=%0d, Ambulance Road=%02b", instruction[2], instruction[1:0]);
            $display(">> Instruction Counter: %0d", instr_counter + 1);
          end else begin
            $display(">> Fetched: NONE");
            $display(">> Continuing normal operation...");
          end
          $display("============================================\n");
          if (valid && instruction[2] == 1'b1)
            state <= STATE_INT_STORE;
          else
            state <= STATE_NORMAL;
        end

        STATE_NORMAL: begin
          $display("Normal Transition:");
          $display("--------------------------------------------------");
          $display("| R0: %-5s | R1: %-5s | R2: %-5s | R3: %-5s |",
                   (current_road==0) ? "GREEN" : "RED",
                   (current_road==1) ? "GREEN" : "RED",
                   (current_road==2) ? "GREEN" : "RED",
                   (current_road==3) ? "GREEN" : "RED");
          $display("--------------------------------------------------");
          $display("Transitioning to next road...\n");
          lights <= (4'b0001 << current_road);
          current_road <= current_road + 1;
          state <= STATE_FETCH;
        end

        STATE_INT_STORE: begin
          stored_road <= current_road;
          stored_instr_counter <= instr_counter;
          $display(">> INTERRUPT DETECTED!");
          $display(">> Stored in RAM: current_road = %0d, instruction counter = %0d", current_road, instr_counter);
          state <= STATE_INT_ALL_RED;
        end

        STATE_INT_ALL_RED: begin
          lights <= 4'b0000;  
          $display("--------------------------------------------------");
          $display("| R0: RED   | R1: RED   | R2: RED   | R3: RED   |  ALL RED");
          $display("--------------------------------------------------");
          state <= STATE_INT_AMBULANCE;
        end

        STATE_INT_AMBULANCE: begin
          lights <= (4'b0001 << ambulance_road);
          $display("--------------------------------------------------");
          $display("| R0: %-5s | R1: %-5s | R2: %-5s | R3: %-5s |  Ambulance on road %0d",
                   (ambulance_road==0) ? "GREEN" : "RED",
                   (ambulance_road==1) ? "GREEN" : "RED",
                   (ambulance_road==2) ? "GREEN" : "RED",
                   (ambulance_road==3) ? "GREEN" : "RED",
                   ambulance_road);
          $display("--------------------------------------------------");
          state <= STATE_INT_RECOVERY;
        end

        STATE_INT_RECOVERY: begin
          lights <= 4'b0000;
          $display("--------------------------------------------------");
          $display("| R0: RED   | R1: RED   | R2: RED   | R3: RED   |  RECOVERY");
          $display("--------------------------------------------------");
          state <= STATE_INT_RESTORE;
        end

        STATE_INT_RESTORE: begin
          current_road <= stored_road;
          $display(">> Restored from RAM: current_road = %0d\n", stored_road);
          state <= STATE_FETCH;
        end

        default: state <= STATE_FETCH;
      endcase
    end
  end

endmodule
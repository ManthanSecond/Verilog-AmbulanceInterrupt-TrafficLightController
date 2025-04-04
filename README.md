# Verilog-AmbulanceInterrupt-TrafficLightController

# Traffic Light Controller with Ambulance Interrupt

## Introduction

This project is about a 4-way crossroad traffic light controller with an ambulance interrupt and a basic computer implementation. It uses Verilog to design a traffic light controller that manages a four-way intersection with intelligent emergency handling.

The controller cycles through four roads in a fixed sequence under normal conditions, ensuring that only one road has a green light at a time while the others remain red.

In the event of an ambulance emergency:
- The system interrupts the normal flow,
- Stores the current active road,
- Turns all lights red,
- Temporarily gives the green light to the ambulance road.

After a brief recovery phase, it resumes normal operation **from where it left off**.

A **testbench** simulates this behavior by feeding **3-bit instructions from an input file**, allowing the system to respond dynamically to both regular and interrupt scenarios.

This project demonstrates effective use of:
- Finite State Machines (FSM),
- Memory elements,
- Clock-driven behavior in Verilog,

to create a **realistic traffic management system**.

---

## Computer Architecture Concepts Used (Brief)

1. **Fetch**  
2. **Decode**  
3. **Execute based on interrupt bit**  
   - a. Normal State Transition  
   - b. Interrupt Cycle  

4. **Interrupt Cycle**  
   - a. Stores instruction counter in RAM  
   - b. Stores current road in RAM  
   - c. Follows interrupt cycle  
   - d. Returns to the next instruction and next road in the normal sequence after retrieving data from RAM  

5. **FSM: Finite State Machine**  
   - a. Normal state transitions that make each road green one after the other
# Python Prototyping

First, we created a prototype version of the project in Python by building functions that would later be mirrored as Verilog modules. These functions were then used in the main function to simulate and validate the desired behavior.

---

## `TrafficLightController` Class

### `__init__` Function
**Purpose:** Sets up the controller when it's first created  
**What it does:**
- Sets road 0 to have a green light initially
- Makes all other roads red
- Creates empty memory (RAM) for storing information during emergencies
- Initializes other variables needed for operation

---

### `fetch` Function
**Purpose:** Gets the next instruction to process  
**What it does:**
- Takes in an instruction (e.g., `"100"` or `"001"`)
- Saves it for later use
- Prints what instruction was received or `"NONE"` if there wasn't one

---

### `decode` Function
**Purpose:** Figures out what the instruction means  
**What it does:**
- Takes the first digit as the interrupt/emergency flag (`0` or `1`)
- Takes the remaining two digits as the ambulance road number (`0–3`)
- Prints what it understood from the instruction

---

### `execute` Function
**Purpose:** Carries out the appropriate action based on the instruction  
**What it does:**
- If it's an emergency (`interrupt = 1`): Starts the emergency sequence
- If it's not an emergency: Just moves to the next road in sequence

---

### `store_current_road_in_ram` Function
**Purpose:** Saves which road had the green light when an emergency happens  
**What it does:**
- Stores the current road number in RAM
- Prints what it stored

---

### `restore_road_from_ram` Function
**Purpose:** Returns to the saved road after an emergency is over  
**What it does:**
- Gets the saved road number from RAM
- Makes that the current road again
- Prints what it restored

---

### `handle_interrupt` Function
**Purpose:** Manages the entire emergency sequence  
**What it does:**
- Makes all roads red first (safety)
- Gives the ambulance road a green light
- Then puts all roads back to red during recovery
- Prints what's happening at each step

---

### `set_road_green` Function
**Purpose:** Updates the traffic lights to make a specific road green  
**What it does:**
- Sets all roads to red first
- Makes the specified road green (if a road is provided)
- Shows the current state of all lights

---

### `print_state` Function
**Purpose:** Shows the current status of all traffic lights  
**What it does:**
- Displays which color each road's light is showing
- Adds any additional message to explain what's happening

---

## The `main()` Function

This function runs the whole simulation:

1. Opens and reads the `input.txt` file to get instructions  
2. Creates a new traffic light controller  
3. Processes each instruction in sequence:
   - Fetches an instruction
   - Decodes what it means
   - Executes the appropriate action  
4. Continues running even after all instructions are used:
   - Runs 3 more normal cycles after the input file ends
   - This shows the system returning to normal operation

---

## Overall Program Flow

The program simulates what happens in a traffic light system:

1. It starts with **road 0 green**
2. It reads instructions from a file
3. For each instruction:
   - If it's normal (no emergency): It just moves to the next road
   - If it's an emergency: It saves the current state, handles the ambulance, and then restores normal operation
4. It continues normal cycling even after no more instructions

---

## Example Input and Output

We used an example `input.txt` file with the following values:

```
000
001
100
001
```

### Expected Output:
The output generated by the Python code correctly reflects the expected traffic light behavior with appropriate transitions between normal and interrupt states.


![image](https://github.com/user-attachments/assets/89b648cb-ad3b-42be-bf5a-db0f0b15c9df)

# Verilog Traffic Light Controller Documentation

---

## Module Definition

```verilog
module traffic_light_controller(
  input clk,
  input reset,
  input valid,
  input [2:0] instruction,
  output reg [3:0] lights
);
```

This defines the main component with:

- **`clk`**: A timing signal that keeps everything in sync (like a heartbeat).
- **`reset`**: Resets the controller back to its initial state.
- **`valid`**: Indicates when a new instruction is ready.
- **`instruction`**: A 3-bit input:
  - Bit 2 = Emergency flag (1 = emergency)
  - Bits 1-0 = Road number for ambulance (0–3)
- **`lights`**: A 4-bit output representing traffic lights for 4 roads (`1` = GREEN, `0` = RED)

---

## State Definitions

These are like "modes" the controller can operate in:

- **`STATE_FETCH`**: Waiting for the next instruction.
- **`STATE_NORMAL`**: Standard road cycling.
- **`STATE_INT_STORE`**: Save current state when an emergency begins.
- **`STATE_INT_ALL_RED`**: Safety step where all lights go red.
- **`STATE_INT_AMBULANCE`**: Turn the ambulance road green.
- **`STATE_INT_RECOVERY`**: Cooldown period after ambulance passes.
- **`STATE_INT_RESTORE`**: Resume normal operation from stored state.

---

## Register Variables

```verilog
reg [2:0] state;
reg [1:0] current_road;
reg [1:0] stored_road;
reg [2:0] instr_reg;
reg interrupt;
reg [1:0] ambulance_road;
reg [31:0] instr_counter;
reg [31:0] stored_instr_counter;
```

These memory elements track the system's internal status:

- **`state`**: Current FSM state.
- **`current_road`**: Road currently showing green.
- **`stored_road`**: Road saved during emergency to restore later.
- **`instr_reg`**: Instruction being processed.
- **`interrupt`**: Flag indicating if there's an emergency.
- **`ambulance_road`**: Road number for the ambulance.
- **`instr_counter`**: Number of processed instructions.
- **`stored_instr_counter`**: Counter snapshot before emergency.

---

## Main Processing Block

```verilog
always @(posedge clk or posedge reset)
```

This tells the controller to evaluate logic:

- On every rising edge of the clock (`clk`)
- Or when `reset` is triggered

---

## Reset Behavior

When `reset` is activated:

- Controller enters **FETCH** state
- Starts with **road 0 green**
- Traffic light output becomes `4'b0001` (only first road green)
- All counters and state registers are cleared

---

## FETCH State Logic

In **FETCH** mode:

- Waits for `valid` to go high
- When a valid instruction is received:
  - Save it in `instr_reg`
  - Decode emergency flag and ambulance road
  - Increment instruction counter
  - If it's an emergency, go to **INT_STORE**
  - Else, continue to **NORMAL**

---

## NORMAL State Logic

In **NORMAL** mode:

- Use bit shifting to set the green light:
  ```verilog
  lights = 4'b0001 << current_road;
  ```
- Move to the **next road** in sequence (`(current_road + 1) % 4`)
- Return to **FETCH** for the next instruction

---

## Interrupt State Logic

### INT_STORE

- Save current road in `stored_road`
- Save `instr_counter` into `stored_instr_counter`
- Transition to **INT_ALL_RED**

### INT_ALL_RED

- Set `lights = 4'b0000` (all red)
- Go to **INT_AMBULANCE**

### INT_AMBULANCE

- Set `lights = 4'b0001 << ambulance_road`
- Go to **INT_RECOVERY**

### INT_RECOVERY

- Again set `lights = 4'b0000` (all red)
- Prepare to go back to normal
- Go to **INT_RESTORE**

### INT_RESTORE

- Restore road from `stored_road` into `current_road`
- Resume to **FETCH** and continue cycling normally

---

## Testbench Explanation

The **testbench file** (`tb_traffic_light_controller.v`) is a simulation environment that:

1. Generates a clock signal toggling every 5 nanoseconds
2. Opens and reads instructions from `input.txt`
3. Feeds each instruction to the controller
4. Waits appropriate time before sending the next instruction
5. Monitors and displays changes in light signals




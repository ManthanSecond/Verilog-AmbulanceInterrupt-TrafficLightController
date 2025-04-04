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


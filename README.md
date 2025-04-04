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

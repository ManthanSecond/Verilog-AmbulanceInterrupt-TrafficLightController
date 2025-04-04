class TrafficLightController:
    def __init__(self):
        self.current_road = 0  # Default starting road
        self.lights = ["RED"] * 4
        self.lights[self.current_road] = "GREEN"  # Initial state
        self.ram = {}  # Simulating RAM storage
        self.instruction = None
        self.interrupt = 0
        self.ambulance_road = 0

    def fetch(self, instruction):
        """Fetch module - Loads the instruction"""
        self.instruction = instruction
        if instruction:
            print(f"Fetched: {instruction}")
        else:
            print("Fetched: NONE")

    def decode(self):
        """Decode module - Decodes instruction into interrupt and ambulance road"""
        if self.instruction:
            self.interrupt = int(self.instruction[0])
            self.ambulance_road = int(self.instruction[1:], 2)
            print(f"Decoded: interrupt={self.interrupt}, ambulance road={self.ambulance_road}")
        else:
            self.interrupt = 0
            self.ambulance_road = 0

    def execute(self):
        """Execute module - Executes the decoded instruction"""
        if self.interrupt:
            self.store_current_road_in_ram()
            self.handle_interrupt()
            self.restore_road_from_ram()
        else:
            self.set_road_green(self.current_road)
            self.current_road = (self.current_road + 1) % 4  # Move to next road

    def store_current_road_in_ram(self):
        """Stores the current road in RAM before handling an interrupt"""
        self.ram["current_road"] = self.current_road
        print(f"Stored in RAM: current_road = {self.current_road}")

    def restore_road_from_ram(self):
        """Restores the road from RAM after handling an interrupt"""
        if "current_road" in self.ram:
            self.current_road = self.ram["current_road"]
            print(f"Restored from RAM: current_road = {self.current_road}")

    def handle_interrupt(self):
        """Interrupt handling sequence"""
        print("INTERRUPT CYCLE:")
        self.set_road_green(None, "ALL RED")
        self.set_road_green(self.ambulance_road, f"Ambulance on road {self.ambulance_road}")
        self.set_road_green(None, "RECOVERY")

    def set_road_green(self, road, message=""):
        """Set the given road green, or all red if road is None"""
        self.lights = ["RED"] * 4
        if road is not None:
            self.lights[road] = "GREEN"
        self.print_state(message)

    def print_state(self, message=""):
        """Print the traffic light states"""
        print(f"R0: {self.lights[0]} | R1: {self.lights[1]} | R2: {self.lights[2]} | R3: {self.lights[3]}  |  {message}")

def main():
    with open("input.txt", "r") as file:
        instructions = [line.strip() for line in file]

    tlc = TrafficLightController()
    instruction_pointer = 0
    loop_count = 3  # Loop 3 times after input ends

    while instruction_pointer < len(instructions) or loop_count > 0:
        instruction = instructions[instruction_pointer] if instruction_pointer < len(instructions) else None

        # Verilog-style sequential processing
        tlc.fetch(instruction)
        tlc.decode()
        tlc.execute()

        if instruction_pointer >= len(instructions):
            loop_count -= 1  # Continue looping after input is exhausted
        else:
            instruction_pointer += 1

if __name__ == "__main__":
    main()

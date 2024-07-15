# Reason Logically, Move Continously!

The **vacuum cleaner robot** is a common didactic example in the field of multi-agent systems. Normally, the robot is placed inside a discrete grid world and reasons directly on the step to perform. In this project, we propose a different approach where **the robot body and the robot mind are separated**, the body is placed in a continuous environment and the mind reasons in a more abstract way on regions instead of cells, leaving to the body the task of moving continuously. In this way, the robot is able to abstract more and focus on high-level tasks instead of low-level details. Here you can find an implementation of the proposed approach with JaCaMo agents and a Godot simulation, using Region Connection Calculus (RCC) as base for the agent.

![](./Screenshots/example.gif)

## Getting Started

### Prerequisites

- gradle;
- Java 22;
- Godot 4.

### Launch

1. Clone the repository;

   ```bash
   git clone https://github.com/driacats/VacuumCleaner.git
   ```

2. Navigate to the project directory;
   ```bash
   cd VacuumCleaner
   ```

3. Open Godot and import the Godot folder as project folder;

4. Start the Godot project;

5. Launch the JaCaMo agent.
   ```bash
   cd Agent
   gradle run
   ```

   

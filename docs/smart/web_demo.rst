Web Demo Tutorial
=================

SMART provides an interactive web-based demonstration at https://smart-mapf.github.io/demo/ 
where you can visualize multi-agent path finding in real-time without any installation.

Overview
--------

The web demo allows you to:

* Visualize pre-computed MAPF solutions
* See realistic execution with robot dynamics
* Compare planned paths vs actual execution
* Observe delays, collisions, and coordination
* Experiment with different scenarios and algorithms

Accessing the Demo
------------------

Visit: https://smart-mapf.github.io/demo/

The demo runs entirely in your web browser - no downloads or installation required.

Interface Layout
----------------

The web interface consists of several main components:

**Visualization Area**
   The central canvas showing:
   
   * Map environment
   * Robots
   * Obstacles (white cubes)

**Control Panel**
   Located on the left side:
   
   * Example scenario selection
   * Scenario selection dropdown
   * Playback controls (play/pause/reset)
   * Speed slider
   * Statistics display


Getting Started
---------------

**Step 1: Select a Map and Plan**

1. At the **Input** menu
2. Choose the map file from local disk
3. Choose the scenario file from local disk (indicating start/goal positions)
4. Choose the MAPF plan file from local disk (pre-computed solution)

**Step 2: Load**

1. At the **Run** menu
2. Click **Simulate** ▶ to start the simulation


**Step 3: Play**

1. At the **Playback** menu
2. Toggle the **Time** and **Playback speed** buttons to control the simulation

Understanding the Visualization
--------------------------------

**Robot Representation**

* **Size** - Represents the robot's physical footprint
* **Opacity** - Faded robots have reached their goals

**Path Visualization**

* **Thin colored lines** - Planned paths from the MAPF algorithm
* **Thick colored lines** - Actual executed trajectories
* **Dotted lines** - Future planned waypoints
* **Solid lines** - Completed path segments

**Map Elements**

* **White cubes** - Obstacles (impassable)


**Execution Indicators**

* **Green glow** - Agent is on schedule
* **Yellow glow** - Minor delay detected
* **Red glow** - Collision or significant delay
* **Pulsing** - Agent is actively coordinating with neighbors

Playback Controls
-----------------

**Speed Control**

Use the speed slider to adjust playback rate:

* **0.25×** - Slow motion (see detailed movements)
* **1×** - Real-time speed
* **2×** - 2× speed
* **4×** - Fast forward
* **10×** - Very fast (for long simulations)

**Timeline Navigation**

* Click anywhere on the timeline to jump to that timestep
* Drag the timeline slider for precise control
* Use arrow keys (← →) for frame-by-frame stepping

**Camera Controls**

* **Mouse wheel** - Zoom in/out
* **Click and drag** - Pan the view

Statistics Panel
----------------

The statistics panel shows real-time metrics:

**Planning Metrics**

* **Makespan** - Maximum time any agent takes
* **Sum of Costs** - Total path lengths for all agents
* **Planning Time** - Time to compute the solution

**Execution Metrics**

* **Current Time** - Current simulation timestep
* **Completed Agents** - Number of agents that reached goals
* **Active Agents** - Agents still moving
* **Total Delays** - Cumulative delay across all agents
* **Collision Count** - Number of detected collisions

**Per-Agent Stats**

Click on any robot to see individual statistics:

* Agent ID and color
* Start and goal positions
* Planned vs actual path length
* Current position and velocity
* Delays encountered
* Goal completion time

Interactive Features
--------------------

**Agent Selection**

* **Click** on a robot to select and highlight it
* Selected agent's path is emphasized
* Statistics for selected agent appear in the side panel
* Press **ESC** to deselect


Export and Share
----------------

**Screenshot**

* Click **Screenshot** 📷 button
* Saves current visualization as PNG
* Useful for presentations or reports

**Export Statistics**

* Click **Export Stats** 📊 button
* Downloads CSV file with detailed metrics
* Import into Excel, Python, or other tools for analysis


Next Steps
----------

After exploring the web demo:

1. **Install SMART** - :doc:`installation` for full features
2. **Create scenarios** - :doc:`input_formats` for custom maps
3. **Integrate planners** - :doc:`planner_integration` for your algorithm
4. **Run experiments** - :doc:`usage` for batch evaluation

**Questions or Issues?**

* Check the :doc:`faq` for common questions
* Visit https://github.com/smart-mapf/smart for documentation
* Open an issue on GitHub for bugs or feature requests

Try It Now
----------

Ready to explore? Visit the demo:

👉 **https://smart-mapf.github.io/demo/**

Experiment with different scenarios, algorithms, and agent counts to understand
how MAPF algorithms perform in realistic execution environments!

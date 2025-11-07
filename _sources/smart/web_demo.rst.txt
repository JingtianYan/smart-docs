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
   
   * Grid-based map environment
   * Robots as colored circles
   * Planned paths (thin lines)
   * Actual trajectories (thick lines)
   * Obstacles (dark cells)

**Control Panel**
   Located on the left side:
   
   * Scenario selection dropdown
   * Algorithm selection
   * Playback controls (play/pause/reset)
   * Speed slider
   * Statistics display

**Timeline**
   Bottom bar showing:
   
   * Current timestep
   * Total simulation time
   * Progress indicator

Getting Started
---------------

**Step 1: Select a Scenario**

1. Click the **Scenario** dropdown menu
2. Choose from available options:
   
   * ``random-32-32-20`` - Random obstacles, 32×32 grid
   * ``maze-32-32-4`` - Maze environment
   * ``empty-32-32`` - Open space
   * ``warehouse-20-40`` - Warehouse layout

3. Select the number of agents (e.g., 10, 20, 50, 100)

**Step 2: Choose an Algorithm**

Select a MAPF algorithm from the dropdown:

* **CBS (Conflict-Based Search)** - Optimal solver
* **EECBS** - Enhanced CBS with bounded suboptimality
* **PBS (Priority-Based Search)** - Priority-based approach
* **LaCAM** - Lazy Constraints Addition MAPF

Each algorithm has different performance characteristics in terms of solution quality
and computation time.

**Step 3: Load and Play**

1. Click the **Load** button to initialize the scenario
2. Wait for the simulation to load (progress bar appears)
3. Click **Play** ▶ to start the simulation
4. Use **Pause** ⏸ to stop temporarily
5. Click **Reset** 🔄 to restart from the beginning

Understanding the Visualization
--------------------------------

**Robot Representation**

* **Colored circles** - Individual robots/agents
* **Color coding** - Each agent has a unique color
* **Size** - Represents the robot's physical footprint
* **Opacity** - Faded robots have reached their goals

**Path Visualization**

* **Thin colored lines** - Planned paths from the MAPF algorithm
* **Thick colored lines** - Actual executed trajectories
* **Dotted lines** - Future planned waypoints
* **Solid lines** - Completed path segments

**Map Elements**

* **White/light cells** - Free space (traversable)
* **Dark/black cells** - Obstacles (impassable)
* **Grid lines** - Cell boundaries
* **Start markers** - Small circles at agent starting positions
* **Goal markers** - Stars or crosses at goal positions

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
* **Double-click** - Center on a specific agent
* **R key** - Reset camera to default view
* **F key** - Follow mode (camera tracks agents)

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

**Path Comparison**

Toggle between views:

* **Planned Paths** - Show algorithm output
* **Executed Paths** - Show actual trajectories
* **Both** - Overlay for comparison (default)
* **None** - Hide paths, show only robots

**Heatmap Visualization**

Enable heatmap mode to see:

* **Traffic density** - Areas with high agent concentration
* **Delay hotspots** - Locations where delays occur
* **Collision points** - Where conflicts happened

Click the **Heatmap** button and select:

* Traffic
* Delays  
* Collisions

Scenario Details
----------------

**Random Maps**

* Randomly placed obstacles
* Various density levels (10%, 20%, 30%)
* Good for general algorithm testing

**Maze Environments**

* Structured obstacle patterns
* Narrow corridors and bottlenecks
* Tests coordination in constrained spaces

**Warehouse Layouts**

* Simulates automated warehouse
* Shelf rows and aisles
* Realistic multi-agent coordination scenarios

**Open Space**

* Minimal obstacles
* Tests pure coordination without environmental constraints
* Highlights algorithm efficiency

Algorithm Comparison
--------------------

Use the demo to compare different algorithms:

**Viewing Multiple Solutions**

1. Load a scenario with Algorithm A
2. Note the statistics (makespan, delays)
3. Click **Reset**
4. Change to Algorithm B
5. Click **Load** again
6. Compare the results

**Key Observations**

* **CBS** - Optimal but may take longer to compute
* **EECBS** - Faster with slightly longer paths
* **PBS** - Very fast but potentially more delays
* **LaCAM** - Good balance of speed and quality

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

**Share Scenario**

* Click **Share** 🔗 button
* Generates a unique URL for this specific scenario
* Share with others to view the same simulation

Tips for Best Experience
-------------------------

**Performance**

* Close other browser tabs for smoother playback
* Use Chrome or Firefox for best performance
* Reduce agent count if visualization lags
* Disable heatmap for faster rendering

**Learning**

* Start with small scenarios (10-20 agents)
* Use slow motion (0.5×) to understand coordination
* Compare same scenario with different algorithms
* Toggle planned vs executed paths to see differences

**Exploration**

* Try edge cases (very crowded or sparse)
* Observe bottlenecks in maze scenarios
* Watch how delays propagate through the system
* Compare optimal vs fast algorithms

Common Observations
-------------------

**Planned vs Executed Paths**

You'll notice the executed paths often differ from planned paths due to:

* **Robot dynamics** - Acceleration/deceleration constraints
* **Execution uncertainty** - Small position/timing errors
* **Coordination delays** - Waiting for other agents
* **Collision avoidance** - Real-time adjustments

**Delay Propagation**

Watch how a single delay can cascade:

1. Agent A delayed at bottleneck
2. Agent B must wait for Agent A
3. Agent C delayed by Agent B
4. Delays propagate through the system

**Emergent Behaviors**

Observe interesting phenomena:

* **Convoys** - Agents following each other
* **Oscillations** - Agents adjusting back and forth
* **Deadlocks** - Mutual waiting situations
* **Throughput limits** - Maximum flow through corridors

Limitations
-----------

The web demo is a simplified visualization:

* Pre-computed solutions only (no online planning)
* Limited scenario selection
* Simplified physics model
* Maximum ~100 agents for performance

For full SMART capabilities, use the desktop version:

* Custom maps and scenarios
* Integrate your own planner
* Full physics simulation
* Thousands of agents
* Detailed statistics and logging

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

Usage Guide
===========

This guide provides detailed information on using SMART for MAPF research and experiments.

Overview
--------

SMART provides a complete pipeline for evaluating MAPF algorithms:

1. **Plan generation** - Your MAPF algorithm generates paths
2. **Simulation** - ARGoS simulates realistic robot execution
3. **Monitoring** - Action Dependency Graph tracks execution
4. **Analysis** - Collect statistics on throughput, delays, collisions

Basic Workflow
--------------

The typical SMART workflow consists of:

1. Prepare a map file (`.map` format)
2. Create a scenario file (`.scen` format) with start/goal positions
3. Run your MAPF planner to generate paths
4. Execute the simulation with SMART
5. Analyze the results

Command Line Interface
----------------------

The main entry point is ``run_sim.py``:

.. code-block:: bash

   python run_sim.py \
       --map_name=random-32-32-20.map \
       --scen_name=random-32-32-20-random-1.scen \
       --num_agents=50 \
       --path_filename=paths.txt \
       --flip_coord=0

**Key Arguments:**

* ``--map_name`` - Map file to use (`.map` format)
* ``--scen_name`` - Scenario file with start/goal positions
* ``--num_agents`` - Number of agents to simulate
* ``--path_filename`` - Input path file from your planner
* ``--flip_coord`` - Coordinate system (0=xy, 1=yx)
* ``--headless`` - Run without visualization (default: False)
* ``--port_num`` - RPC port number (default: 8182)
* ``--stats_name`` - Output statistics CSV file

Visualization Mode
------------------

Run with visualization to observe the simulation in real-time:

.. code-block:: bash

   python run_sim.py \
       --map_name=empty-32-32.map \
       --scen_name=empty-32-32-random-1.scen \
       --num_agents=20 \
       --path_filename=my_paths.txt

The ARGoS visualizer will open showing:

* Robot movements in real-time
* Collision detection
* Path following behavior

**Controls:**

* Mouse - Rotate camera
* Arrow keys - Move camera
* Spacebar - Pause/resume
* F10 - Toggle fast forward

Headless Mode
-------------

For batch experiments and benchmarking, run in headless mode:

.. code-block:: bash

   python run_sim.py \
       --map_name=random-64-64-20.map \
       --scen_name=random-64-64-20-random-1.scen \
       --num_agents=100 \
       --path_filename=paths.txt \
       --headless=True \
       --stats_name=experiment_1.csv

Headless mode:

* Runs faster (no rendering overhead)
* Suitable for automated experiments
* Outputs statistics to CSV

Path File Format
----------------

The path file contains trajectories for each agent:

.. code-block:: text

   Agent 0:(5,16,0)->(5,17,1)->(5,18,2)->(6,18,3)->...
   Agent 1:(10,5,0)->(11,5,1)->(12,5,2)->...

Format: ``Agent ID:(x,y,t)->(x,y,t)->...``

* ``(x,y,t)`` - Position (x, y) at timestep t
* Paths should be collision-free in discrete time
* SMART adds realistic execution uncertainty

Coordinate Systems
------------------

SMART supports two coordinate conventions:

**XY format** (``--flip_coord=0``):

* Standard (x, y) coordinates
* x increases rightward, y increases upward

**YX format** (``--flip_coord=1``):

* Used by some MAPF planners
* Row-column format
* Automatically converted internally

Output Statistics
-----------------

SMART generates a CSV file with execution statistics:

.. code-block:: text

   agent_id,makespan,sum_of_costs,num_delays,num_collisions
   0,45,45,2,0
   1,52,53,3,1
   ...

**Metrics:**

* ``makespan`` - Time to reach goal
* ``sum_of_costs`` - Total path cost
* ``num_delays`` - Execution delays encountered
* ``num_collisions`` - Collision count

Configuration Files
-------------------

ARGoS configuration is generated automatically. To customize:

1. Run once to generate ``.argos`` file
2. Edit the configuration:

.. code-block:: bash

   vim output.argos

3. Run ARGoS directly:

.. code-block:: bash

   argos3 -c output.argos

See :doc:`settings` for advanced configuration options.

Map and Scenario Files
----------------------

**Map Format** (`.map` extension):

MovingAI format used by MAPF benchmarks:

.. code-block:: text

   type octile
   height 32
   width 32
   map
   @@@@@@@@...
   @......@...
   ...

* ``@`` - Obstacle
* ``.`` - Free space

**Scenario Format** (`.scen` extension):

.. code-block:: text

   version 1
   0 map.map 32 32 5 5 25 25 20.0
   1 map.map 32 32 10 10 20 20 10.0

Format: ``id map width height start_x start_y goal_x goal_y optimal_cost``

Next Steps
----------

* :doc:`examples` - Walkthrough examples
* :doc:`apis` - Python API reference
* :doc:`planner_integration` - Integrate your planner
* :doc:`settings` - Advanced configuration

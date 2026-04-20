Usage Guide
===========

This guide describes the public end-to-end workflow exposed by the current
SMART repository.

Overview
--------

SMART provides a complete pipeline for evaluating MAPF algorithms:

1. **Plan generation** - your MAPF algorithm generates a timed path file
2. **Simulation setup** - ``run_sim.py`` converts the map and scenario into an ARGoS config
3. **Execution monitoring** - ``ADG_server`` coordinates robot actions through the ADG
4. **Simulation** - ARGoS executes the controllers
5. **Analysis** - SMART writes a CSV row and prints a JSON summary

Basic Workflow
--------------

The typical SMART workflow consists of:

1. Prepare a map file (`.map` format)
2. Prepare a scenario file (`.scen` format)
3. Run your MAPF planner to generate a path file
4. Execute the simulation with SMART
5. Analyze the generated outputs

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

**Key arguments:**

* ``--map_name`` - map file to use (`.map` format)
* ``--scen_name`` - scenario file with start/goal positions
* ``--num_agents`` - number of agents to simulate
* ``--path_filename`` - input path file from your planner
* ``--flip_coord`` - coordinate system (0=xy, 1=yx)
* ``--headless`` - run without visualization
* ``--port_num`` - RPC port number
* ``--stats_name`` - output statistics CSV file
* ``--argos_config_name`` - filename of the generated ARGoS config

Visualization Mode
------------------

Use the shipped example files from the source repository to observe a run with
visualization:

.. code-block:: bash

   python run_sim.py \
       --map_name=random-32-32-20.map \
       --scen_name=random-32-32-20-random-1.scen \
       --num_agents=50 \
       --path_filename=example_paths_xy.txt \
       --flip_coord=0

The ARGoS visualizer will open showing:

* robot movements in real time
* obstacles derived from the input map
* path execution under the shipped foot-bot controller

The exact viewer controls come from ARGoS itself.

Headless Mode
-------------

For batch experiments and benchmarking, run in headless mode:

.. code-block:: bash

   python run_sim.py \
       --map_name=random-32-32-20.map \
       --scen_name=random-32-32-20-random-1.scen \
       --num_agents=50 \
       --path_filename=example_paths_xy.txt \
       --flip_coord=0 \
       --headless=True \
       --stats_name=experiment_1.csv

Headless mode:

* runs faster because rendering is disabled
* is suitable for automated experiments
* still generates an ARGoS config file
* appends one line to the selected CSV file

Path File Format
----------------

The path file contains trajectories for each agent:

.. code-block:: text

   Agent 0:(5,16,0)->(5,17,1)->(5,18,2)->(6,18,3)->...
   Agent 1:(10,5,0)->(11,5,1)->(12,5,2)->...

Format: ``Agent ID:(x,y,t)->(x,y,t)->...``

* ``(x,y,t)`` - position and timestamp
* one line per agent
* consecutive locations should be waits or axis-adjacent moves
* the file should contain the same number of agent paths as the run

Coordinate Systems
------------------

SMART supports two coordinate conventions:

**XY format** (``--flip_coord=0``):

* standard ``(x, y)`` coordinates
* x is the map column, y is the map row

**YX format** (``--flip_coord=1``):

* row-column format used by some planners
* ``(y, x)`` ordering in the path file
* converted internally by SMART

Output Statistics
-----------------

SMART appends a CSV row with the following header:

.. code-block:: text

   steps finish sim,sum of steps finish sim,time finish sim,sum finish time,original plan cost,#type-2 edges,#type-1 edges,#Nodes,#Move,#Rotate,#Consecutive Move,#Agent pair,instance name,number of agent

**Metrics:**

* ``steps finish sim`` - number of simulation steps completed
* ``sum of steps finish sim`` - sum of per-agent completion steps
* ``time finish sim`` - maximum wall-clock finish time
* ``sum finish time`` - sum of per-agent finish times
* ``original plan cost`` - cost read from the input plan
* ``#type-2 edges`` - number of type-2 ADG edges
* ``#type-1 edges`` - number of type-1 ADG edges
* ``#Nodes`` - number of ADG nodes
* ``#Move`` - number of move actions
* ``#Rotate`` - number of rotate actions
* ``#Consecutive Move`` - number of consecutive move sequences
* ``#Agent pair`` - number of interacting agent pairs
* ``instance name`` - path filename
* ``number of agent`` - number of agents in the run

At the end of a run, the server also prints a JSON summary containing the same
main fields plus several time values in seconds.

Generated Files
---------------

By default, the helper script creates:

* ``output.argos`` - generated ARGoS XML
* ``stats.csv`` - simulation statistics

You can rename these with ``--argos_config_name`` and ``--stats_name``.

Configuration Files
-------------------

ARGoS configuration is generated automatically. To customize it:

1. Run once to generate the ``.argos`` file
2. Edit the configuration:

.. code-block:: bash

   vim output.argos

3. Run ARGoS directly:

.. code-block:: bash

   argos3 -c output.argos

See :doc:`settings` for configuration details.

Map and Scenario Files
----------------------

**Map format** (`.map` extension):

MovingAI-style text grid:

.. code-block:: text

   type octile
   height 32
   width 32
   map
   @@@@@@@@...
   @......@...

**Scenario format** (`.scen` extension):

.. code-block:: text

   version 1
   0 map.map 32 32 5 5 25 25 20.0
   1 map.map 32 32 10 10 20 20 10.0

Format: ``id map width height start_x start_y goal_x goal_y optimal_cost``

Next Steps
----------

* :doc:`examples` - Walkthrough examples
* :doc:`apis` - Public interfaces and outputs
* :doc:`planner_integration` - Integrate your planner
* :doc:`settings` - Configuration details

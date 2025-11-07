Input Formats
=============

This page describes the input file formats used by SMART for maps, scenarios, and paths.

Map Files
---------

SMART uses the MovingAI map format (``.map`` extension) for environment representation.

**File Structure**

.. code-block:: text

   type octile
   height 32
   width 32
   map
   @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
   @..............................@
   @..............................@
   @..............................@
   @..............................@
   @..............................@
   @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

**Format Specification**

* **Line 1**: ``type octile`` - Movement type (octile for 8-connected, not yet supported)
* **Line 2**: ``height <N>`` - Number of rows in the map
* **Line 3**: ``width <N>`` - Number of columns in the map
* **Line 4**: ``map`` - Marks the beginning of the map data
* **Lines 5+**: Map grid representation

**Cell Types**

* ``@`` - Obstacle (impassable)
* ``.`` - Free space (traversable)
* ``T`` - Tree (treated as obstacle)
* ``S`` - Swamp (not supported, treated as free)
* ``W`` - Water (treated as obstacle)

**Example Map**

.. code-block:: text

   type octile
   height 8
   width 8
   map
   @@@@@@@@
   @......@
   @.@@...@
   @.@@...@
   @......@
   @...@@.@
   @......@
   @@@@@@@@

**Creating Custom Maps**

You can create maps using any text editor:

1. Start with type, height, width headers
2. Add ``map`` keyword
3. Draw your environment using ``@`` and ``.``
4. Ensure all rows have the same width
5. Save with ``.map`` extension

**Map Resources**

Download benchmark maps from:

* `MovingAI Lab <https://movingai.com/benchmarks/>`_ - Standard MAPF benchmarks
* SMART repository examples
* `2D Pathfinding Benchmarks <https://www.movingai.com/benchmarks/grids/index.html>`_

Scenario Files
--------------

Scenario files (``.scen`` extension) specify start and goal positions for agents.

**File Structure**

.. code-block:: text

   version 1
   0	random-32-32-20.map	32	32	5	5	25	25	28.284271
   1	random-32-32-20.map	32	32	10	8	22	18	16.485281
   2	random-32-32-20.map	32	32	3	15	20	28	22.071068

**Format Specification**

Header line:
``version 1``

Each subsequent line represents one agent with 9 tab-separated fields:

1. **Bucket ID** - Scenario grouping identifier (usually 0)
2. **Map filename** - Name of the associated map file
3. **Map width** - Number of columns
4. **Map height** - Number of rows  
5. **Start X** - Starting column coordinate
6. **Start Y** - Starting row coordinate
7. **Goal X** - Goal column coordinate
8. **Goal Y** - Goal row coordinate
9. **Optimal cost** - Optimal path length (optional, for reference)

**Coordinate System**

* (0,0) is the top-left corner
* X increases rightward (column index)
* Y increases downward (row index)

**Example Scenario**

.. code-block:: text

   version 1
   0	empty-8-8.map	8	8	1	1	6	6	7.071068
   0	empty-8-8.map	8	8	2	2	5	5	4.242641
   0	empty-8-8.map	8	8	1	6	6	1	7.071068

This defines 3 agents on the same map with different start/goal positions.

**Creating Scenarios**

You can create scenario files manually:

.. code-block:: python

   # Python script to generate scenario
   with open('my_scenario.scen', 'w') as f:
       f.write('version 1\\n')
       # Agent 0: from (5,5) to (25,25)
       f.write('0\\tmy_map.map\\t32\\t32\\t5\\t5\\t25\\t25\\t28.28\\n')
       # Agent 1: from (10,8) to (22,18)
       f.write('0\\tmy_map.map\\t32\\t32\\t10\\t8\\t22\\t18\\t16.49\\n')

Path Files
----------

Path files contain the planned trajectories output by your MAPF planner.

**SMART Native Format**

.. code-block:: text

   Agent 0:(5,16,0)->(5,17,1)->(5,18,2)->(6,18,3)->(7,18,4)->...
   Agent 1:(10,5,0)->(11,5,1)->(12,5,2)->(13,5,3)->...
   Agent 2:(3,20,0)->(4,20,1)->(5,20,2)->...

**Format Specification**

* Each line represents one agent's complete path
* Format: ``Agent <ID>:(<x>,<y>,<t>)->(<x>,<y>,<t>)->...``
* **Agent ID** - Zero-indexed agent identifier (must match scenario order)
* **x** - X coordinate (column)
* **y** - Y coordinate (row)
* **t** - Timestep (integer, starting from 0)

**Requirements**

* Paths must be temporally consistent (timesteps increment)
* Adjacent waypoints should be reachable in one timestep
* Coordinates must be within map bounds
* Must not be in obstacle cells
* Each agent needs at least start and goal positions

**Example Path**

.. code-block:: text

   Agent 0:(5,5,0)->(5,6,1)->(5,7,2)->(6,7,3)->(7,7,4)->(8,7,5)

This shows Agent 0 moving from (5,5) at t=0 to (8,7) at t=5.

**Coordinate Conventions**

SMART supports two coordinate formats via the ``--flip_coord`` flag:

**XY Format** (``--flip_coord=0``):
* Standard Cartesian coordinates
* (x, y) where x is column, y is row
* This is the default

**YX Format** (``--flip_coord=1``):
* Row-column format used by some planners
* (y, x) where y is row, x is column
* SMART will automatically convert internally

**Wait Actions**

Agents can wait in place:

.. code-block:: text

   Agent 0:(5,5,0)->(5,5,1)->(5,5,2)->(6,5,3)
   
Agent 0 waits at (5,5) from t=0 to t=2, then moves to (6,5) at t=3.

**Path Termination**

Paths can end at the goal:

.. code-block:: text

   Agent 0:(5,5,0)->(6,5,1)->(7,5,2)

Or continue with wait actions:

.. code-block:: text

   Agent 0:(5,5,0)->(6,5,1)->(7,5,2)->(7,5,3)->(7,5,4)

JSON Format (Alternative)
--------------------------

For programmatic generation, you can use JSON:

.. code-block:: json

   {
     "agents": [
       {
         "id": 0,
         "path": [
           [5, 16, 0],
           [5, 17, 1],
           [5, 18, 2],
           [6, 18, 3]
         ]
       },
       {
         "id": 1,
         "path": [
           [10, 5, 0],
           [11, 5, 1],
           [12, 5, 2]
         ]
       }
     ]
   }

Convert to SMART format using:

.. code-block:: python

   import json
   
   def json_to_smart_format(json_file, output_file):
       with open(json_file) as f:
           data = json.load(f)
       
       with open(output_file, 'w') as f:
           for agent in data['agents']:
               agent_id = agent['id']
               path_str = '->'.join([f"({x},{y},{t})" 
                                    for x, y, t in agent['path']])
               f.write(f"Agent {agent_id}:{path_str}\\n")

Validation
----------

**Validate Your Inputs**

Before running SMART, verify:

1. **Map is valid**
   * All rows have the same width
   * Width/height match the declared dimensions
   * Only contains valid cell types

2. **Scenario matches map**
   * Start/goal coordinates are within bounds
   * Start/goal positions are not in obstacles
   * Number of agents matches your planner input

3. **Paths are feasible**
   * All waypoints are within map bounds
   * No waypoints in obstacles
   * Timesteps are sequential
   * Number of paths matches number of agents

**Command-line Validation**

Check your files before running:

.. code-block:: bash

   # Verify map dimensions
   head -n 3 my_map.map
   
   # Count scenario agents
   wc -l my_scenario.scen
   
   # Count path entries
   wc -l my_paths.txt

Common Issues
-------------

**Map Issues**

* **Irregular rows**: Ensure all rows have exactly the width specified
* **Wrong dimensions**: Header height/width must match actual grid size
* **Invalid characters**: Use only ``@``, ``.``, ``T``, ``W``

**Scenario Issues**

* **Out of bounds**: Start/goal coordinates must be < width/height
* **In obstacle**: Start/goal positions must be in free space (``.``)
* **Wrong map reference**: Map filename must exist and match exactly

**Path Issues**

* **Missing agents**: Number of path lines must match scenario agents
* **Wrong format**: Follow ``Agent ID:(x,y,t)->`` syntax exactly
* **Invalid moves**: Adjacent waypoints must be reachable in one step
* **Coordinate mismatch**: Use ``--flip_coord`` if your planner uses (y,x)

**Debugging Tips**

.. code-block:: bash

   # Visualize your map
   cat my_map.map | tail -n +5
   
   # Check scenario syntax
   cat my_scenario.scen | column -t
   
   # Verify path format
   head -n 3 my_paths.txt

Examples
--------

**Complete Example Set**

Map (``example.map``):

.. code-block:: text

   type octile
   height 5
   width 5
   map
   @@@@@
   @...@
   @.@.@
   @...@
   @@@@@

Scenario (``example.scen``):

.. code-block:: text

   version 1
   0	example.map	5	5	1	1	3	3	2.828427
   0	example.map	5	5	1	3	3	1	2.828427

Paths (``example_paths.txt``):

.. code-block:: text

   Agent 0:(1,1,0)->(2,1,1)->(3,2,2)->(3,3,3)
   Agent 1:(1,3,0)->(2,3,1)->(3,2,2)->(3,1,3)

Run with:

.. code-block:: bash

   python run_sim.py \\
       --map_name=example.map \\
       --scen_name=example.scen \\
       --num_agents=2 \\
       --path_filename=example_paths.txt \\
       --flip_coord=0

Next Steps
----------

* :doc:`usage` - Learn how to use these files with SMART
* :doc:`planner_integration` - Integrate your MAPF planner
* :doc:`examples` - See complete working examples

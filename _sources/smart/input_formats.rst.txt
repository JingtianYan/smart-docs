Input Formats
=============

This page describes the input file formats used by SMART for maps, scenarios,
and paths.

Map Files
---------

SMART uses the MovingAI map format (``.map`` extension) for environment
representation.

**File structure**

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

**Format specification**

* **Line 1**: ``type octile`` - MovingAI header
* **Line 2**: ``height <N>`` - Number of rows in the map
* **Line 3**: ``width <N>`` - Number of columns in the map
* **Line 4**: ``map`` - Marks the beginning of the map data
* **Lines 5+**: Map grid representation

**Obstacle handling in the current public repo**

The current ``ArgosConfig/ToArgos.py`` converter treats only these characters
as obstacles:

* ``@``
* ``T``

All other characters are not given special treatment by the current converter.

**Example map**

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

**Creating custom maps**

1. Start with the ``type``, ``height``, and ``width`` headers
2. Add the ``map`` keyword
3. Draw the environment as a text grid
4. Ensure all rows have the same width
5. Save with a ``.map`` extension

**Map resources**

Download benchmark maps from:

* `MovingAI Lab <https://movingai.com/benchmarks/>`_
* SMART repository examples
* `2D Pathfinding Benchmarks <https://www.movingai.com/benchmarks/grids/index.html>`_

Scenario Files
--------------

Scenario files (``.scen`` extension) specify start and goal positions for
agents.

**File structure**

.. code-block:: text

   version 1
   0	random-32-32-20.map	32	32	5	5	25	25	28.284271
   1	random-32-32-20.map	32	32	10	8	22	18	16.485281
   2	random-32-32-20.map	32	32	3	15	20	28	22.071068

**Format specification**

Header line:
``version 1``

Each subsequent line represents one agent with 9 tab-separated fields:

1. **Bucket ID** - scenario grouping identifier
2. **Map filename** - name of the associated map file
3. **Map width** - number of columns
4. **Map height** - number of rows
5. **Start X** - starting column coordinate
6. **Start Y** - starting row coordinate
7. **Goal X** - goal column coordinate
8. **Goal Y** - goal row coordinate
9. **Optimal cost** - optimal path length

**Coordinate system**

* ``(0,0)`` is the top-left corner
* x increases rightward
* y increases downward

**Example scenario**

.. code-block:: text

   version 1
   0	empty-8-8.map	8	8	1	1	6	6	7.071068
   0	empty-8-8.map	8	8	2	2	5	5	4.242641
   0	empty-8-8.map	8	8	1	6	6	1	7.071068

Path Files
----------

Path files contain the planned trajectories output by your MAPF planner.

**SMART text format**

.. code-block:: text

   Agent 0:(5,16,0)->(5,17,1)->(5,18,2)->(6,18,3)->(7,18,4)->...
   Agent 1:(10,5,0)->(11,5,1)->(12,5,2)->(13,5,3)->...
   Agent 2:(3,20,0)->(4,20,1)->(5,20,2)->...

**Format specification**

* Each line represents one agent's complete path
* Format: ``Agent <ID>:(<x>,<y>,<t>)->(<x>,<y>,<t>)->...``
* **Agent ID** - label before the colon
* **x** - X coordinate (column)
* **y** - Y coordinate (row)
* **t** - numeric time value

**Requirements**

* Consecutive locations must be waits or axis-adjacent moves
* Coordinates must be within map bounds
* Waypoints must not be in obstacle cells
* One path line is needed for each agent in the run

**Example path**

.. code-block:: text

   Agent 0:(5,5,0)->(5,6,1)->(5,7,2)->(6,7,3)->(7,7,4)->(8,7,5)->

**Coordinate conventions**

SMART supports two path coordinate formats via ``--flip_coord``:

**XY format** (``--flip_coord=0``):

* standard Cartesian-style ordering
* ``(x, y)`` where x is column and y is row
* this is the setting used with ``example_paths_xy.txt``

**YX format** (``--flip_coord=1``):

* row-column ordering
* ``(y, x)`` where y is row and x is column
* this is the setting used with ``example_paths_yx.txt``

**Wait actions**

Agents can wait in place:

.. code-block:: text

   Agent 0:(5,5,0)->(5,5,1)->(5,5,2)->(6,5,3)->

SMART does not accept JSON path files directly through ``run_sim.py``. If your
planner writes JSON or another format, convert it to the text format above
before launching SMART.

Validation
----------

**Validate your inputs**

Before running SMART, verify:

1. **Map is valid**
   * All rows have the same width
   * Width and height match the declared dimensions

2. **Scenario matches map**
   * Start and goal coordinates are within bounds
   * Start and goal positions are not in obstacles
   * Number of agents matches your planner input

3. **Paths are feasible**
   * All waypoints are within map bounds
   * No waypoints in obstacles
   * Consecutive moves are waits or axis-adjacent moves
   * Number of paths matches number of agents

**Command-line validation**

.. code-block:: bash

   # Verify map dimensions
   head -n 3 my_map.map

   # Count scenario agents
   wc -l my_scenario.scen

   # Count path entries
   wc -l my_paths.txt

Common Issues
-------------

**Map issues**

* **Irregular rows**: Ensure all rows have exactly the width specified
* **Wrong dimensions**: Header height/width must match actual grid size
* **Unexpected obstacles**: Remember that the current converter only treats ``@`` and ``T`` as obstacles

**Scenario issues**

* **Out of bounds**: Start/goal coordinates must be within the map
* **In obstacle**: Start/goal positions must be in free space
* **Wrong map reference**: Map filename should match the instance you use

**Path issues**

* **Missing agents**: Number of path lines must match scenario agents
* **Wrong format**: Follow ``Agent ID:(x,y,t)->`` syntax exactly
* **Invalid moves**: Diagonal jumps are rejected by the current parser
* **Coordinate mismatch**: Use ``--flip_coord`` if your planner uses ``(y,x)``

Examples
--------

**Complete example set**

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

   Agent 0:(1,1,0)->(2,1,1)->(3,1,2)->(3,2,3)->(3,3,4)->
   Agent 1:(1,3,0)->(2,3,1)->(3,3,2)->(3,2,3)->(3,1,4)->

Run with:

.. code-block:: bash

   python run_sim.py \
       --map_name=example.map \
       --scen_name=example.scen \
       --num_agents=2 \
       --path_filename=example_paths.txt \
       --flip_coord=0

Next Steps
----------

* :doc:`usage` - Learn how to use these files with SMART
* :doc:`planner_integration` - Integrate your MAPF planner
* :doc:`examples` - See shipped example files

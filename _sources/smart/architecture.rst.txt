Architecture
============

This page summarizes the current SMART architecture as described by the public
repository and the paper.

Overview
--------

The paper describes SMART as three main modules:

1. **Simulator** - built on ARGoS 3
2. **Execution monitoring server** - based on the Action Dependency Graph (ADG)
3. **Executors/controllers** - one per robot

In the public repo, ``run_sim.py`` is a convenience wrapper around those
modules. It is not a separate public client SDK.

Components
----------

ARGoS Simulator
^^^^^^^^^^^^^^^

SMART uses `ARGoS 3 <https://www.argos-sim.info/>`_ as the physics-based simulator:

* **Physics engine** - ``dynamics2d`` in the generated ARGoS config
* **Robot model** - the current public repo uses the foot-bot controller path
* **Sensors** - the generated config enables foot-bot proximity and positioning sensors
* **Visualization** - ARGoS Qt/OpenGL when headless mode is disabled

**Location**: ``client/`` directory

**Key files**:

* ``client/controllers/`` - Robot controller logic
* ``client/controllers/footbot_diffusion/`` - shipped executor/controller
* ``client/loop_functions/`` - ARGoS loop function code

Action Dependency Graph (ADG)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The ADG server parses the path file, builds the execution graph, and coordinates
robot actions:

* **Plan parser** - reads the text path file
* **Action conversion** - converts timed locations into move/turn actions
* **Graph builder** - creates ADG dependencies
* **Execution monitor** - updates node status during execution

**Location**: ``server/`` directory

**Key files**:

* ``server/src/parser.cpp`` - path parsing and action conversion
* ``server/src/ADG.cpp`` - graph construction and updates
* ``server/src/ADG_server.cpp`` - RPC server and stats output

RPC Communication
^^^^^^^^^^^^^^^^^

SMART uses `rpclib <https://github.com/rpclib/rpclib>`_ internally between the
ADG server and the robot executors:

* **Protocol** - MessagePack over TCP
* **Port** - Default 8182 in ``run_sim.py``
* **Role** - robot executors poll the server for actions and report completion

Current methods bound by the public server implementation:

* ``init``
* ``update``
* ``receive_update``
* ``get_config``
* ``update_finish_agent``
* ``closeServer``

Wrapper Script
^^^^^^^^^^^^^^

The repository root contains a Python helper script:

* **CLI** - ``run_sim.py`` reads the map, scenario, and path file
* **Config generation** - ``ArgosConfig/ToArgos.py`` writes the ``.argos`` file
* **Process launching** - the script starts ``build/server/ADG_server`` and ``argos3``

**Location**: Root directory

**Key files**:

* ``run_sim.py`` - Main CLI entry point
* ``ArgosConfig/ToArgos.py`` - Configuration generation

Execution Flow
--------------

1. **Initialization**

   .. code-block:: text

      User -> run_sim.py -> generate .argos -> start ADG_server -> start argos3

2. **Load Scenario**

   .. code-block:: text

      Load .map -> Load .scen -> generate obstacle boxes and robot start poses

3. **Load Paths**

   .. code-block:: text

      Path file -> parser -> action list -> ADG

4. **Simulation**

   .. code-block:: text

      Controllers poll server -> execute move/turn actions in ARGoS -> report completion

5. **Results**

   .. code-block:: text

      Simulation complete -> write CSV -> print JSON summary

Data Flow
---------

**Input path**:

.. code-block:: text

   MAPF Planner
      |
   paths.txt
      |
   run_sim.py
      |
   ADG Server (parse to actions)
      |
   ARGoS (continuous execution)

**Output statistics**:

.. code-block:: text

   ARGoS (execution events)
      |
   ADG (aggregation)
      |
   CSV row + JSON summary

Design Principles
-----------------

The paper emphasizes three main goals:

* realistic execution through a physics-based simulator
* planner-agnostic path execution through the ADG framework
* scalability to large robot counts in headless experiments

Code Structure
--------------

.. code-block:: text

   smart/
   ├── client/              # ARGoS controllers and related code
   ├── server/              # ADG server
   ├── ArgosConfig/         # ARGoS XML generation
   ├── run_sim.py           # main helper script
   ├── example_paths_xy.txt
   ├── example_paths_yx.txt
   ├── random-32-32-20.map
   ├── random-32-32-20-random-1.scen
   └── CMakeLists.txt

Build System
------------

SMART uses CMake for building:

.. code-block:: cmake

   cmake_minimum_required(VERSION 3.16)
   project(Lifelong_SMART)

   option(BUILD_SERVER "Build ADG server" ON)
   option(BUILD_CLIENT "Build ARGoS client" ON)

   find_package(Boost REQUIRED)
   find_package(ARGoS QUIET)

Performance Considerations
--------------------------

What is clearly visible in the public codebase:

* the generated ARGoS config sets ``threads="32"``
* the server uses mutex-protected RPC handlers
* release-style compiler flags are enabled in the CMake files
* the paper reports headless experiments up to 2,000 robots

Extending SMART
---------------

Common extension points in the public repo:

* add a new metric in ``server/src/ADG_server.cpp``
* add or modify a controller in ``client/controllers/``
* change ARGoS XML generation in ``ArgosConfig/ToArgos.py``
* adjust parsing rules in ``server/src/parser.cpp``

Next Steps
----------

* `ARGoS Documentation <https://www.argos-sim.info/documentation.php>`_
* `rpclib Documentation <https://github.com/rpclib/rpclib>`_
* :doc:`usage` - Running the public workflow

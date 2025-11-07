Architecture
============

This page describes SMART's system architecture and design.

Overview
--------

SMART is built on a modular architecture consisting of:

1. **Simulator Core** (ARGoS-based)
2. **Execution Monitor** (Action Dependency Graph)
3. **RPC Server** (Communication layer)
4. **Python Client** (API and tools)

.. code-block:: text

                  ┌─────────────────────────┐
                  │   MAPF Planner          │
                  │   (Your Algorithm)      │
                  └───────────┬─────────────┘
                              │ Paths
                              ▼
                  ┌─────────────────────────┐
                  │   Python Client API     │
                  │   (run_sim.py)          │
                  └───────────┬─────────────┘
                              │ RPC
                              ▼
   ┌──────────────────────────────────────────────┐
   │              SMART Server (C++)              │
   ├──────────────────────────────────────────────┤
   │  ┌────────────────────────────────────────┐  │
   │  │   Action Dependency Graph (ADG)        │  │
   │  │   - Parse plans                        │  │
   │  │   - Build dependency graph             │  │
   │  │   - Monitor execution                  │  │
   │  └───────────────┬────────────────────────┘  │
   │                  │                            │
   │  ┌───────────────▼────────────────────────┐  │
   │  │   ARGoS Simulator                      │  │
   │  │   - Physics engine                     │  │
   │  │   - Robot controllers                  │  │
   │  │   - Collision detection                │  │
   │  └────────────────────────────────────────┘  │
   └──────────────────────────────────────────────┘
                              │
                              ▼
                  ┌─────────────────────────┐
                  │   Statistics & Logs     │
                  └─────────────────────────┘

Components
----------

ARGoS Simulator
^^^^^^^^^^^^^^^

SMART uses `ARGoS 3 <https://www.argos-sim.info/>`_ as the physics-based simulator:

* **Physics Engine** - Realistic 2D dynamics and collisions
* **Robot Models** - Differential drive robots (footbots)
* **Sensors** - Position, proximity, obstacle detection
* **Visualization** - 3D OpenGL rendering

**Location**: ``client/`` directory

**Key files**:
* ``client/controllers/`` - Robot controller logic
* ``client/loop_functions/`` - Simulation orchestration

Action Dependency Graph (ADG)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The ADG monitors plan execution and handles uncertainties:

* **Plan Parser** - Converts paths to action sequences
* **Graph Builder** - Creates dependency graph from actions
* **Execution Monitor** - Tracks progress and detects issues
* **Coordination** - Manages agent interactions

**Location**: ``server/`` directory

**Key files**:
* ``server/inc/parser.h`` - Path parsing
* ``server/src/ADG_server.cpp`` - Main server logic

RPC Communication
^^^^^^^^^^^^^^^^^

Uses `rpclib <https://github.com/rpclib/rpclib>`_ for client-server communication:

* **Protocol** - MessagePack over TCP
* **Port** - Default 8182 (configurable)
* **Methods** - Load scenario, set paths, run simulation, get stats

**Key RPC calls**:
* ``load_scenario(map, scen, agents)``
* ``set_paths(paths_json)``
* ``run_simulation(headless)``
* ``get_statistics()``

Python Client
^^^^^^^^^^^^^

High-level Python API and CLI tools:

* **CLI** - ``run_sim.py`` command-line interface
* **API** - ``SMARTClient`` class for programmatic access
* **Utilities** - Path conversion, visualization, analysis

**Location**: Root directory

**Key files**:
* ``run_sim.py`` - Main CLI entry point
* ``ArgosConfig/ToArgos.py`` - Configuration generation

Execution Flow
--------------

1. **Initialization**

   .. code-block:: text
   
      User → run_sim.py → Start ADG_server → Connect RPC

2. **Load Scenario**

   .. code-block:: text
   
      Load .map → Load .scen → Generate ARGoS config → Initialize robots

3. **Set Paths**

   .. code-block:: text
   
      MAPF paths → Parse to actions → Build ADG → Validate

4. **Simulation**

   .. code-block:: text
   
      ARGoS tick → Update robot states → Check ADG → 
      Detect delays/collisions → Log events

5. **Results**

   .. code-block:: text
   
      Simulation complete → Aggregate stats → Return to client

Data Flow
---------

**Path Input**:

.. code-block:: text

   MAPF Planner
      ↓
   paths.txt (discrete waypoints)
      ↓
   Python client (validation)
      ↓
   RPC (JSON serialization)
      ↓
   ADG Server (parse to actions)
      ↓
   ARGoS (continuous execution)

**Statistics Output**:

.. code-block:: text

   ARGoS (execution events)
      ↓
   ADG (aggregation)
      ↓
   RPC (JSON response)
      ↓
   Python client
      ↓
   CSV file / Python dict

Design Principles
-----------------

**Modularity**

Each component has a well-defined interface:

* Planner-agnostic: works with any MAPF algorithm
* Swappable simulator: ARGoS can be replaced
* Extensible: easy to add new metrics or features

**Scalability**

Designed for large numbers of agents:

* Efficient ADG representation
* Spatial hashing for collision detection
* Parallel simulation (when using ARGoS parallelization)

**Realism**

Bridges planning and reality:

* Physics-based dynamics
* Execution uncertainty
* Communication delays
* Sensor noise (configurable)

Code Structure
--------------

.. code-block:: text

   smart/
   ├── client/              # ARGoS components
   │   ├── controllers/     # Robot controllers
   │   ├── loop_functions/  # Simulation logic
   │   └── embedding/       # Utilities
   ├── server/              # ADG server
   │   ├── inc/             # Headers
   │   └── src/             # Implementation
   ├── ArgosConfig/         # Config generation
   ├── build/               # Build outputs
   ├── docs/                # Documentation
   ├── tests/               # Unit tests
   ├── run_sim.py           # Main CLI
   └── CMakeLists.txt       # Build config

Build System
------------

SMART uses CMake for building:

.. code-block:: cmake

   # Top-level CMakeLists.txt structure
   cmake_minimum_required(VERSION 3.16)
   project(Lifelong_SMART)
   
   # Build options
   option(BUILD_SERVER "Build ADG server" ON)
   option(BUILD_CLIENT "Build ARGoS client" ON)
   
   # Dependencies
   find_package(Boost REQUIRED)
   find_package(ARGoS REQUIRED)
   
   # Subdirectories
   add_subdirectory(server)
   add_subdirectory(client)

Threading Model
---------------

* **Main Thread** - ARGoS simulation loop
* **RPC Thread** - Handles client requests
* **Worker Threads** - Physics computations (ARGoS internal)

Thread safety is ensured through:
* Mutex locks on shared state
* Message queues for commands
* Atomic operations for statistics

Performance Considerations
--------------------------

**Bottlenecks**:

1. Physics simulation (ARGoS)
2. Collision detection
3. RPC serialization (for large path sets)

**Optimizations**:

* Spatial hashing for O(1) neighbor queries
* Lazy ADG evaluation
* Batch RPC calls
* Compiled with -O3 optimization

**Scaling**:

* ~100 agents: Real-time with visualization
* ~1000 agents: Real-time headless
* 1000+ agents: Use time-scaling or distributed simulation

Extending SMART
---------------

**Add a new metric**:

1. Modify ``server/src/ADG_server.cpp`` to track the metric
2. Update statistics struct
3. Return via RPC
4. Parse in Python client

**Add a new robot model**:

1. Create controller in ``client/controllers/``
2. Register in ``CMakeLists.txt``
3. Update ARGoS config generation
4. Add Python API wrapper

**Add a new sensor**:

1. Implement sensor in ARGoS controller
2. Expose data via RPC
3. Add Python API method

Next Steps
----------

* `ARGoS Documentation <https://www.argos-sim.info/documentation.php>`_
* `rpclib Documentation <https://github.com/rpclib/rpclib>`_
* :doc:`../contributing` - Contributing guide

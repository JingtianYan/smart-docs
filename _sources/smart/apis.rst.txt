Core APIs
=========

SMART provides Python APIs for interacting with the simulator and integrating
MAPF planners.

Overview
--------

The SMART APIs allow you to:

* Start and control simulations programmatically
* Integrate custom MAPF planners
* Retrieve real-time execution statistics
* Monitor agent states and positions

Client-Server Architecture
--------------------------

SMART uses an RPC-based client-server architecture:

* **Server** - C++ ARGoS-based simulator (``ADG_server``)
* **Client** - Python scripts communicate via RPC
* **Port** - Default 8182 (configurable)

Python API Reference
--------------------

**Basic Usage**

.. code-block:: python

   from smart_client import SMARTClient
   
   # Connect to SMART server
   client = SMARTClient(port=8182)
   
   # Load simulation
   client.load_simulation(
       map_file="random-32-32-20.map",
       scenario_file="random-32-32-20-random-1.scen",
       num_agents=50
   )
   
   # Set paths from your planner
   client.set_paths(agent_paths)
   
   # Run simulation
   stats = client.run()
   
   # Get results
   print(f"Makespan: {stats['makespan']}")
   print(f"Throughput: {stats['throughput']}")

**SMARTClient Class**

.. code-block:: python

   class SMARTClient:
       """
       Main client interface for SMART simulator.
       """
       
       def __init__(self, host='localhost', port=8182):
           """
           Initialize client connection.
           
           Args:
               host: Server hostname
               port: Server port number
           """
           pass
       
       def load_simulation(self, map_file, scenario_file, num_agents):
           """
           Load a simulation scenario.
           
           Args:
               map_file: Path to .map file
               scenario_file: Path to .scen file
               num_agents: Number of agents
           """
           pass
       
       def set_paths(self, paths):
           """
           Set planned paths for agents.
           
           Args:
               paths: List of paths, one per agent
                     Format: [[(x,y,t), (x,y,t), ...], ...]
           """
           pass
       
       def run(self, headless=False):
           """
           Execute the simulation.
           
           Args:
               headless: Run without visualization
               
           Returns:
               dict: Statistics including makespan, costs, delays
           """
           pass
       
       def get_agent_state(self, agent_id):
           """
           Get current state of an agent.
           
           Args:
               agent_id: Agent identifier
               
           Returns:
               dict: Position, velocity, status
           """
           pass
       
       def pause(self):
           """Pause the simulation."""
           pass
       
       def resume(self):
           """Resume the simulation."""
           pass
       
       def stop(self):
           """Stop and cleanup the simulation."""
           pass

Path Format
-----------

Paths should be provided as a list of waypoint tuples:

.. code-block:: python

   # Single agent path
   path = [
       (5, 16, 0),   # (x, y, timestep)
       (5, 17, 1),
       (5, 18, 2),
       (6, 18, 3),
       # ... goal
   ]
   
   # Multiple agents
   all_paths = [
       [(5,16,0), (5,17,1), ...],  # Agent 0
       [(10,5,0), (11,5,1), ...],  # Agent 1
       # ...
   ]
   
   client.set_paths(all_paths)

Statistics Output
-----------------

The ``run()`` method returns a dictionary with execution statistics:

.. code-block:: python

   stats = client.run()
   
   # Access statistics
   print(f"Makespan: {stats['makespan']}")
   print(f"Sum of costs: {stats['sum_of_costs']}")
   print(f"Throughput: {stats['throughput']}")
   print(f"Success rate: {stats['success_rate']}")
   
   # Per-agent statistics
   for agent_id, agent_stats in stats['agents'].items():
       print(f"Agent {agent_id}: {agent_stats['delays']} delays")

Return format:

.. code-block:: python

   {
       'makespan': int,           # Maximum completion time
       'sum_of_costs': int,       # Total path costs
       'throughput': float,       # Agents/second
       'success_rate': float,     # Fraction reaching goal
       'agents': {
           0: {
               'makespan': int,
               'cost': int,
               'delays': int,
               'collisions': int
           },
           # ...
       }
   }

Configuration API
-----------------

Customize simulation parameters:

.. code-block:: python

   client.set_config({
       'robot_radius': 0.2,        # Robot size (meters)
       'max_velocity': 0.5,        # Max speed (m/s)
       'time_limit': 1000,         # Simulation time limit
       'collision_threshold': 0.1  # Collision distance
   })

Event Callbacks
---------------

Register callbacks for simulation events:

.. code-block:: python

   def on_collision(agent_a, agent_b, timestep):
       print(f"Collision: Agent {agent_a} and {agent_b} at t={timestep}")
   
   def on_delay(agent_id, location, delay_time):
       print(f"Agent {agent_id} delayed at {location}")
   
   client.register_callback('collision', on_collision)
   client.register_callback('delay', on_delay)
   
   client.run()

RPC Protocol
------------

For advanced users implementing custom clients, SMART uses rpclib with the
following RPC methods:

* ``load_scenario(map, scen, num_agents)`` - Load simulation
* ``set_agent_paths(paths_json)`` - Set paths
* ``run_simulation(headless)`` - Execute
* ``get_statistics()`` - Retrieve results
* ``pause_simulation()`` - Pause
* ``resume_simulation()`` - Resume

See the `rpclib documentation <https://github.com/rpclib/rpclib>`_ for details.

Example Scripts
---------------

Complete examples are available in the repository:

* ``examples/simple_client.py`` - Basic API usage
* ``examples/batch_experiment.py`` - Run multiple scenarios
* ``examples/custom_planner.py`` - Integrate a MAPF planner

Next Steps
----------

* :doc:`planner_integration` - Integrate your MAPF algorithm
* :doc:`examples` - Complete examples
* :doc:`usage` - Command-line usage

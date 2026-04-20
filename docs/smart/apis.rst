Interfaces and Outputs
======================

The current public SMART repository does **not** ship a packaged public Python
client library such as ``SMARTClient``. The supported user-facing interface in
the repository is the command-line workflow built around ``run_sim.py``, text
input files, and the generated output files.

Public Entry Point
------------------

The main entry point is ``run_sim.py`` in the source repository root:

.. code-block:: bash

   python run_sim.py \
       --map_name=random-32-32-20.map \
       --scen_name=random-32-32-20-random-1.scen \
       --num_agents=50 \
       --path_filename=example_paths_xy.txt \
       --flip_coord=0

Current command-line arguments from ``python run_sim.py --help``:

* ``--map_name`` - input map file
* ``--scen_name`` - input scenario file
* ``--num_agents`` - number of agents to load from the scenario
* ``--headless`` - whether to disable ARGoS visualization
* ``--argos_config_name`` - generated ARGoS config filename
* ``--path_filename`` - input path file for the MAPF plan
* ``--stats_name`` - output CSV filename for simulation statistics
* ``--port_num`` - RPC port shared by the server and robot executors
* ``--flip_coord`` - coordinate convention flag, ``0`` for ``(x,y)``, ``1`` for ``(y,x)``

What ``run_sim.py`` Does
------------------------

For each run, ``run_sim.py``:

1. Reads the `.map` and `.scen` files.
2. Generates an ARGoS configuration file through ``ArgosConfig/``.
3. Starts ``build/server/ADG_server`` with the selected path file.
4. Starts ``argos3`` with the generated ``.argos`` file.

Public Outputs
--------------

The current repo produces three main kinds of outputs:

* A generated ARGoS XML file, ``output.argos`` by default
* A CSV file, ``stats.csv`` by default
* A JSON summary printed by ``ADG_server`` to standard output at the end of the run

The CSV header written by the current server implementation is:

.. code-block:: text

   steps finish sim,sum of steps finish sim,time finish sim,sum finish time,original plan cost,#type-2 edges,#type-1 edges,#Nodes,#Move,#Rotate,#Consecutive Move,#Agent pair,instance name,number of agent

The JSON summary contains the same main fields plus several time values in
seconds:

.. code-block:: text

   steps finish sim
   sum of steps finish sim
   time finish sim
   sum finish time
   original plan cost
   simulated makespan seconds
   simulated sum of cost seconds
   simulated average sum of cost seconds
   #type-2 edges
   #type-1 edges
   #Nodes
   #Move
   #Rotate
   #Consecutive Move
   #Agent pair
   instance name
   number of agent

Internal RPC Layer
------------------

SMART uses ``rpclib`` internally between the ADG server and the robot
executors. In the current public code, the server binds the following methods:

* ``init``
* ``update``
* ``receive_update``
* ``get_config``
* ``update_finish_agent``
* ``closeServer``

These RPC calls are implementation details of the shipped controller/server
pair. They are useful for code readers, but they are not documented as a
stable public client API.

What Is Not in the Public Repo
------------------------------

The current public repository does not include:

* a packaged ``smart_client`` Python module
* a public pause/resume callback API
* a documented JSON or REST control layer
* bundled example scripts named ``simple_client.py`` or ``batch_experiment.py``

Next Steps
----------

* :doc:`planner_integration` - prepare planner outputs for SMART
* :doc:`usage` - run the full workflow from source
* :doc:`input_formats` - format maps, scenarios, and path files correctly

FAQ - Frequently Asked Questions
=================================

Installation and Building
-------------------------

**Q: Which operating systems are supported?**

A: The current public README explicitly mentions Ubuntu 22.04. The paper reports
experiments on Ubuntu 20.04. This docs site avoids claiming broader official
platform support than that.

**Q: What do I need to build SMART?**

A: For a full run, you need:

* a Linux build environment
* CMake and a C++ compiler
* Boost
* ARGoS 3
* the rpclib submodule bundled with the SMART repo

**Q: Can I use SMART without compiling native code?**

A: Not in the current public repository. ``run_sim.py`` still depends on the
native server binary and the ARGoS client/controller build.

**Q: Do I need GPU support?**

A: No dedicated GPU requirement is documented in the public repo. SMART runs on
CPU-based ARGoS simulation.

Running Simulations
-------------------

**Q: What is the simplest command to run?**

A: The upstream README example is:

.. code-block:: bash

   python run_sim.py --map_name=random-32-32-20.map --scen_name=random-32-32-20-random-1.scen --num_agents=50 --path_filename=example_paths_xy.txt --flip_coord=0

**Q: Simulation hangs or freezes**

A: Check these common issues:

* server port already in use
* path file has syntax errors
* number of paths does not match ``--num_agents``
* ARGoS configuration issue

**Q: How many agents can SMART handle?**

A: The paper reports headless experiments up to 2,000 robots. Your practical
limit will still depend on the map, hardware, and whether visualization is
enabled.

**Q: Can I run multiple simulations in parallel?**

A: Yes, as long as you keep ports, output files, and generated ARGoS filenames
separate:

.. code-block:: bash

   # Terminal 1
   python run_sim.py --port_num=8182 --stats_name=run1.csv --argos_config_name=run1.argos ...

   # Terminal 2
   python run_sim.py --port_num=8183 --stats_name=run2.csv --argos_config_name=run2.argos ...

Path and Map Files
------------------

**Q: What map format does SMART use?**

A: SMART uses MovingAI-style ``.map`` files:

.. code-block:: text

   type octile
   height 32
   width 32
   map
   @@@@@@@@...
   @......@...

In the current public converter, ``@`` and ``T`` are treated as obstacles.

**Q: Where can I get map files?**

A: Download from:

* `MovingAI Lab Benchmarks <https://movingai.com/benchmarks/>`_
* SMART repository examples
* Your own text maps

**Q: My planner uses different coordinates**

A: Use ``--flip_coord=1`` if your path file is written in ``(y,x,t)`` order.
Use ``--flip_coord=0`` for ``(x,y,t)``.

**Q: Can my path file include diagonal moves?**

A: No. The current parser rejects consecutive locations whose Manhattan
distance is 2 or more. Waits and axis-aligned single-cell moves are fine.

API and Integration
-------------------

**Q: Can I use SMART with my custom planner?**

A: Yes. See :doc:`planner_integration`. The basic contract is that your planner
writes a SMART text path file.

**Q: Does the public repo ship a Python client library?**

A: No. The current public repository does not include a packaged
``smart_client`` module or a public ``SMARTClient`` API. The supported user
workflow is the command-line path described in :doc:`usage`.

**Q: Do I need to write C++ code?**

A: Not for the basic workflow. If you want to change controller behavior,
server logic, parsing rules, or metrics, then you will need to modify the C++
or ARGoS-side code.

**Q: Can SMART do online replanning through a public API?**

A: Not through a documented public interface in the current repo. The public
workflow is path-file execution rather than an interactive replanning API.

Results and Analysis
--------------------

**Q: What metrics does SMART provide?**

A: The current public server writes these main fields:

* ``steps finish sim``
* ``sum of steps finish sim``
* ``time finish sim``
* ``sum finish time``
* ``original plan cost``
* ``#type-2 edges``
* ``#type-1 edges``
* ``#Nodes``
* ``#Move``
* ``#Rotate``
* ``#Consecutive Move``
* ``#Agent pair``
* ``instance name``
* ``number of agent``

It also prints a JSON summary with the same main values plus several
second-based timing fields.

**Q: Does the public repo report throughput or success rate?**

A: Those metrics are not part of the current shipped CSV/JSON output format in
the public repo.

**Q: How do I reproduce results?**

A: The current public ``run_sim.py`` does not expose a ``--random_seed`` flag.
The generated ARGoS config hardcodes ``random_seed="124"``. If you want a
different seed, edit the generated ``.argos`` file before launching ARGoS
manually.

Visualization
-------------

**Q: How do I control the camera in ARGoS?**

A: Camera controls come from the ARGoS visualizer. The generated config only
sets the initial camera placement.

**Q: Is there a public web demo?**

A: Yes. See :doc:`web_demo` for the currently verified public demo behavior.

Advanced Topics
---------------

**Q: Can I use different robot models?**

A: The current public repo ships the foot-bot based controller path. Adding a
different robot model would require code changes in the client/controller side
and in ARGoS config generation.

**Q: Where should I look if I want to modify metrics or parsing?**

A:

* metrics and output formatting: ``server/src/ADG_server.cpp``
* path parsing and action conversion: ``server/src/parser.cpp``
* ARGoS XML generation: ``ArgosConfig/ToArgos.py``

Troubleshooting
---------------

**Q: "Connection refused" error**

A: Check that:

* ``build/server/ADG_server`` exists
* the chosen port is free
* the server and controller use the same port number

**Q: "Segmentation fault" when running**

A: Common causes:

* ARGoS not properly installed
* path file has wrong format
* memory pressure with larger runs

**Q: Visualization window is blank**

A: Try:

* checking that ARGoS itself runs correctly
* using a simpler map
* rebuilding after verifying the ARGoS installation

Getting Help
------------

**Q: Where can I ask questions?**

A:

* `Issue Tracker <https://github.com/smart-mapf/smart/issues>`_
* `Documentation repository <https://github.com/JingtianYan/smart-docs>`_

**Q: How do I report a bug?**

A: Open an issue with:

1. SMART version or commit
2. operating system
3. complete error message
4. minimal reproduction case
5. expected vs actual behavior

Still Have Questions?
---------------------

Check these resources:

* :doc:`overview` - Project overview
* :doc:`usage` - Detailed usage guide
* :doc:`apis` - Public interfaces and outputs
* `Paper <https://arxiv.org/abs/2503.04798>`_ - Technical details

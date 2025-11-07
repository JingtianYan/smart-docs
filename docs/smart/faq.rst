FAQ - Frequently Asked Questions
=================================

Installation and Building
--------------------------

**Q: Which operating systems are supported?**

A: SMART officially supports:

* Ubuntu 20.04+ (recommended)
* macOS 11+ (Big Sur and later)
* Other Linux distributions with ARGoS support

Windows is not currently supported for native builds. Consider using WSL2 or Docker.

**Q: Build fails with linking errors**

A: This often happens if conda is in your PATH. Try:

.. code-block:: bash

   # Temporarily remove conda from PATH
   export PATH=/usr/bin:/usr/local/bin:$PATH
   cd build
   cmake ..
   make

**Q: CMake cannot find ARGoS**

A: Specify the ARGoS installation path:

.. code-block:: bash

   cmake -DARGOS_PREFIX=/usr/local ..

Or set the PKG_CONFIG_PATH:

.. code-block:: bash

   export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH

**Q: Do I need GPU support?**

A: No, SMART runs on CPU only. GPU is not required for the physics simulation
or visualization.

Running Simulations
-------------------

**Q: The simulation runs too slowly**

A: Try these options:

1. Use headless mode: ``--headless=True``
2. Reduce visualization quality in ARGoS settings
3. Decrease physics accuracy: ``--physics_accuracy=low``
4. Use a release build: ``cmake -DCMAKE_BUILD_TYPE=Release ..``

**Q: Simulation hangs or freezes**

A: Check these common issues:

* Server port already in use (try different ``--port_num``)
* Path file has syntax errors
* Number of paths doesn't match ``--num_agents``
* ARGoS configuration issue (check logs)

**Q: How many agents can SMART handle?**

A: Performance varies by hardware:

* With visualization: ~100 agents at 10 FPS
* Headless mode: 500-1000+ agents
* For larger scales, consider time-scaling or batch processing

**Q: Can I run multiple simulations in parallel?**

A: Yes, use different port numbers:

.. code-block:: bash

   # Terminal 1
   python run_sim.py --port_num=8182 ...
   
   # Terminal 2
   python run_sim.py --port_num=8183 ...

Path and Map Files
------------------

**Q: What map format does SMART use?**

A: SMART uses the MovingAI map format (``.map`` files):

.. code-block:: text

   type octile
   height 32
   width 32
   map
   @@@@@@@@...
   @......@...

Where ``@`` = obstacle, ``.`` = free space.

**Q: Where can I get map files?**

A: Download from:

* `MovingAI Lab Benchmarks <https://movingai.com/benchmarks/>`_
* SMART repository examples
* Create custom maps (text files)

**Q: My planner uses different coordinates**

A: Use ``--flip_coord=1`` to convert (y,x) to (x,y), or convert in your
wrapper script.

**Q: What if paths have collisions?**

A: SMART will still execute the paths, but will:

* Detect and log collisions
* Report collision statistics
* Show delays and execution failures

Use this to evaluate how robust your planner is to execution uncertainty.

API and Integration
-------------------

**Q: Can I use SMART with my custom planner?**

A: Yes! See :doc:`planner_integration` for a complete guide. SMART works with
any planner that outputs timestamped paths.

**Q: Do I need to write C++ code?**

A: No, the Python API is sufficient for most use cases. Only modify C++ if
adding new sensors or robot models.

**Q: Can SMART do online replanning?**

A: The current version focuses on plan execution. Online replanning can be
implemented by:

1. Detecting delays/collisions via callbacks
2. Calling your replanner
3. Updating paths via API

**Q: How do I access raw robot trajectories?**

A: Enable trajectory logging:

.. code-block:: python

   client.set_logging({'log_trajectories': True})
   stats = client.run()
   trajectories = stats['trajectories']

Results and Analysis
--------------------

**Q: What metrics does SMART provide?**

A: Key metrics include:

* Makespan (max completion time)
* Sum of costs
* Throughput (agents/second)
* Success rate
* Number of delays
* Number of collisions
* Per-agent statistics

**Q: How is success rate calculated?**

A: Success rate = (agents reaching goal) / (total agents)

An agent is considered successful if it reaches within threshold distance of
its goal.

**Q: What causes delays in execution?**

A: Delays can occur from:

* Robot kinodynamic constraints
* Collisions or near-collisions
* Coordination overhead
* Execution uncertainty
* Communication delays

**Q: How do I reproduce results?**

A: Set a random seed:

.. code-block:: bash

   python run_sim.py --random_seed=42 ...

Or in Python:

.. code-block:: python

   client.set_config({'random_seed': 42})

Visualization
-------------

**Q: How do I control the camera in ARGoS?**

A: Use these controls:

* Mouse drag - Rotate view
* Scroll wheel - Zoom
* Arrow keys - Pan camera
* R - Reset camera
* F10 - Fast forward toggle

**Q: Can I record videos?**

A: Yes, use ARGoS's built-in recording:

1. In the visualizer, click the record button
2. Or use screen recording software (OBS, QuickTime, etc.)

**Q: Can I customize robot appearance?**

A: Edit the ARGoS configuration file:

.. code-block:: xml

   <footbot id="fb_0">
     <body position="5,5,0" color="red" />
   </footbot>

Advanced Topics
---------------

**Q: Can I use different robot models?**

A: Currently SMART uses footbot models. To add new models, you'll need to:

1. Implement ARGoS controller
2. Update CMakeLists.txt
3. Modify configuration generation

**Q: Can I add sensor noise?**

A: Yes, configure noise in settings:

.. code-block:: python

   client.set_config({
       'sensor_noise': 0.01,  # Position noise (meters)
       'actuator_noise': 0.05  # Velocity noise
   })

**Q: Can I simulate communication delays?**

A: Yes, set communication parameters:

.. code-block:: python

   client.set_config({
       'communication_delay': 0.1,  # Seconds
       'communication_range': 10.0  # Meters
   })

**Q: Does SMART support 3D environments?**

A: Currently SMART focuses on 2D ground navigation. 3D support would require
significant ARGoS configuration changes.

Troubleshooting
---------------

**Q: "Connection refused" error**

A: The SMART server is not running. Check:

1. Server binary compiled: ``ls build/server/ADG_server``
2. Port not in use: ``lsof -i :8182``
3. Firewall not blocking connection

**Q: "Segmentation fault" when running**

A: Common causes:

* ARGoS not properly installed
* Path file has wrong format
* Memory issue with large agent counts

Check the logs in ``/tmp/smart_*.log``

**Q: Statistics show zero throughput**

A: Possible causes:

* No agents reached their goals
* Simulation timeout too short
* Paths are invalid or have syntax errors

**Q: Visualization window is blank**

A: Try:

* Update graphics drivers
* Check ARGoS OpenGL support: ``argos3 -q all``
* Use a simpler environment/map

Getting Help
------------

**Q: Where can I ask questions?**

A:

* `GitHub Discussions <https://github.com/smart-mapf/smart/discussions>`_
* `Issue Tracker <https://github.com/smart-mapf/smart/issues>`_
* Email the maintainers (see repository)

**Q: How do I report a bug?**

A: Open an issue on GitHub with:

1. SMART version
2. Operating system
3. Complete error message
4. Minimal reproduction case
5. Expected vs actual behavior

**Q: Can I contribute to SMART?**

A: Yes! See the `Contributing Guide <https://github.com/smart-mapf/smart/blob/main/CONTRIBUTING.md>`_ in the repository.

Still Have Questions?
---------------------

Check these resources:

* :doc:`overview` - Project overview
* :doc:`usage` - Detailed usage guide
* :doc:`apis` - API reference
* `Paper <https://arxiv.org/abs/2503.04798>`_ - Technical details

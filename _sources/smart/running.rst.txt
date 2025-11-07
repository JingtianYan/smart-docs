Running SMART
=============

This page gives commonly used commands to run SMART components (visual and
headless) as taken from the project's README.

Running with visualization
--------------------------

Example command to run the full pipeline with the visualiser (Python helper):

.. code-block:: bash

   python run_sim.py --map_name=random-32-32-20.map \
       --scen_name=random-32-32-20-random-1.scen \
       --num_agents=50 \
       --path_filename=example_paths_xy.txt \
       --flip_coord=0

Or, for flipped coordinates (yx):

.. code-block:: bash

   python run_sim.py --map_name=random-32-32-20.map \
       --scen_name=random-32-32-20-random-1.scen \
       --num_agents=50 \
       --path_filename=example_paths_yx.txt \
       --flip_coord=1

Headless (no visualization)
----------------------------

To run the simulator in headless mode (useful for batch experiments):

.. code-block:: bash

   python run_sim.py --map_name=random-32-32-20.map \
       --scen_name=random-32-32-20-random-1.scen \
       --num_agents=50 \
       --path_filename=example_paths_xy.txt \
       --flip_coord=0 \
       --headless=True

Configuration and ports
-----------------------

The Python script accepts additional options (port numbers, output filenames,
headless flags). See `run_sim.py` in the SMART repo for full argument
descriptions.

Examples
========

This page collects small examples and pointers to example input/output files
included in the SMART repository.

Example: run with provided example path files
--------------------------------------------

The SMART repo ships example path files such as `example_paths_xy.txt` and
`example_paths_yx.txt`. A simple run that generates those example paths is:

.. code-block:: bash

   python run_sim.py --map_name=random-32-32-20.map \
       --scen_name=random-32-32-20-random-1.scen \
       --num_agents=50 \
       --path_filename=example_paths_xy.txt \
       --flip_coord=0

Inspecting example outputs
--------------------------

Example path files contain per‑agent sequences of (x,y,t) steps. For instance
an agent line looks like::

   Agent 0:(5,16,0)->(5,17,1)->(5,18,2)->(...)

See the original repository's `example_paths_xy.txt` and
`example_paths_yx.txt` for full examples used in demonstrations.

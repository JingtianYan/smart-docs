Planner Integration
===================

This guide shows how to integrate your MAPF planner with the current public
SMART workflow.

Overview
--------

In the public repository, planner integration is file-based:

1. Run your planner on a `.map` and `.scen` instance.
2. Write the resulting paths to a SMART path file.
3. Pass that path file to ``run_sim.py``.
4. Read the generated CSV or JSON summary.

Planner Output Format
---------------------

The path file format consumed by SMART is a plain-text file with one agent per
line:

.. code-block:: text

   Agent 0:(5,16,0)->(5,17,1)->(5,18,2)->(6,18,3)->...
   Agent 1:(10,5,0)->(11,5,1)->(12,5,2)->...

Each tuple is ``(x,y,t)`` or ``(y,x,t)`` depending on the ``--flip_coord``
flag you use when launching SMART.

Integration Template
--------------------

The simplest integration path is:

1. run your planner,
2. write a SMART path file,
3. call ``run_sim.py``.

Example wrapper:

.. code-block:: python

   # my_planner_wrapper.py

   import subprocess

   def write_smart_paths(paths, output_file):
       with open(output_file, "w") as f:
           for agent_id, agent_path in enumerate(paths):
               tuples = "->".join(
                   f"({x},{y},{t})" for x, y, t in agent_path
               )
               f.write(f"Agent {agent_id}:{tuples}->\\n")

   def run_my_planner(map_file, scen_file, num_agents):
       # Replace this with your real planner call.
       # Return one path per agent as a list of (x, y, t) tuples.
       raise NotImplementedError

   def evaluate_with_smart(map_file, scen_file, num_agents):
       path_file = "planner_paths.txt"
       paths = run_my_planner(map_file, scen_file, num_agents)
       write_smart_paths(paths, path_file)

       subprocess.run(
           [
               "python",
               "run_sim.py",
               f"--map_name={map_file}",
               f"--scen_name={scen_file}",
               f"--num_agents={num_agents}",
               f"--path_filename={path_file}",
               "--flip_coord=0",
               "--headless=True",
               "--stats_name=planner_eval.csv",
           ],
           check=True,
       )

Coordinate System Handling
--------------------------

If your planner writes row-column tuples, keep that order in the file and run
SMART with ``--flip_coord=1``.

If you prefer to convert the paths yourself, a simple helper looks like:

.. code-block:: python

   def convert_yx_to_xy(yx_paths):
       """Convert (y,x,t) to (x,y,t) format."""
       xy_paths = []
       for agent_path in yx_paths:
           xy_path = []
           for y, x, t in agent_path:
               xy_path.append((x, y, t))
           xy_paths.append(xy_path)
       return xy_paths

Or simply keep the planner output as ``(y,x,t)`` and use ``--flip_coord=1``.

Path Requirements
-----------------

The current parser expects:

* one line per agent
* explicit numeric time values in each tuple
* axis-aligned moves or wait actions between consecutive locations
* no diagonal jumps between consecutive locations
* a path count that matches the number of agents you run

Performance Tips
----------------

1. **Use headless mode** for batch experiments
2. **Keep path generation outside SMART** so you can reuse the same plan file
3. **Use distinct ports and output filenames** for parallel runs
4. **Run multiple trials** if you are studying variability

Next Steps
----------

* :doc:`apis` - current public interfaces and outputs
* :doc:`examples` - shipped example files
* :doc:`usage` - Running simulations

Planner Integration
===================

This guide shows how to integrate your MAPF planner with SMART.

Overview
--------

SMART is designed to work with any MAPF planner that produces timestamped paths.
The integration process:

1. Run your planner on a map/scenario
2. Convert output to SMART path format
3. Execute in SMART simulator
4. Analyze results

Planner Output Format
---------------------

Your MAPF planner should output paths in the following formats:

.. code-block:: text

   Agent 0:(5,16,0)->(5,17,1)->(5,18,2)->(6,18,3)->...
   Agent 1:(10,5,0)->(11,5,1)->(12,5,2)->...



Integration Template
--------------------

Create a wrapper script for your planner:

.. code-block:: python

   # my_planner_wrapper.py
   
   import subprocess
   import json
   from smart_client import SMARTClient
   
   def run_my_planner(map_file, scen_file, num_agents):
       """
       Run your MAPF planner.
       
       Returns:
           List of paths for each agent
       """
       # Call your planner executable
       result = subprocess.run([
           './my_planner',
           '--map', map_file,
           '--scen', scen_file,
           '--agents', str(num_agents),
           '--output', 'paths.json'
       ], capture_output=True)
       
       # Parse planner output
       with open('paths.json') as f:
           planner_output = json.load(f)
       
       # Convert to SMART format
       paths = convert_to_smart_format(planner_output)
       return paths
   
   def convert_to_smart_format(planner_output):
       """
       Convert your planner's output to SMART format.
       """
       paths = []
       for agent in planner_output['agents']:
           path = []
           for waypoint in agent['path']:
               x, y, t = waypoint
               path.append((x, y, t))
           paths.append(path)
       return paths
   
   def evaluate_planner(map_file, scen_file, num_agents):
       """
       Run planner and evaluate in SMART.
       """
       # Run your planner
       print(f"Running planner on {num_agents} agents...")
       paths = run_my_planner(map_file, scen_file, num_agents)
       
       # Connect to SMART
       client = SMARTClient(port=8182)
       client.load_simulation(map_file, scen_file, num_agents)
       client.set_paths(paths)
       
       # Run simulation
       print("Executing in SMART simulator...")
       stats = client.run(headless=True)
       
       # Print results
       print(f"Makespan: {stats['makespan']}")
       print(f"Success rate: {stats['success_rate']}")
       print(f"Throughput: {stats['throughput']:.2f} agents/sec")
       
       return stats
   
   if __name__ == '__main__':
       stats = evaluate_planner(
           'random-32-32-20.map',
           'random-32-32-20-random-1.scen',
           50
       )

Common Planners
---------------

**CBS (Conflict-Based Search)**

.. code-block:: python

   # Assuming CBS outputs paths as list of lists
   def convert_cbs_output(cbs_paths):
       smart_paths = []
       for agent_path in cbs_paths:
           timestamped = []
           for t, (x, y) in enumerate(agent_path):
               timestamped.append((x, y, t))
           smart_paths.append(timestamped)
       return smart_paths

**EECBS (Enhanced CBS)**

.. code-block:: python

   from eecbs import EECBS
   
   # Run EECBS
   eecbs = EECBS()
   solution = eecbs.solve(map_file, scen_file, num_agents)
   
   # Convert to SMART format
   paths = []
   for agent_id, agent_solution in enumerate(solution):
       path = [(x, y, t) for t, (x, y) in enumerate(agent_solution)]
       paths.append(path)

**MAPF-LNS (Large Neighborhood Search)**

.. code-block:: python

   from mapf_lns import MAPFLNS
   
   lns = MAPFLNS()
   solution = lns.solve(
       map_file=map_file,
       scen_file=scen_file,
       num_agents=num_agents,
       time_limit=60
   )
   
   # Already in correct format
   paths = solution['paths']

Batch Evaluation
----------------

Evaluate your planner across multiple scenarios:

.. code-block:: python

   import pandas as pd
   
   scenarios = [
       ('random-32-32-20.map', 'random-32-32-20-random-1.scen', 50),
       ('random-32-32-20.map', 'random-32-32-20-random-2.scen', 100),
       ('maze-32-32-4.map', 'maze-32-32-4-random-1.scen', 50),
   ]
   
   results = []
   for map_file, scen_file, num_agents in scenarios:
       print(f"\\nEvaluating: {scen_file} with {num_agents} agents")
       stats = evaluate_planner(map_file, scen_file, num_agents)
       results.append({
           'map': map_file,
           'scenario': scen_file,
           'agents': num_agents,
           'makespan': stats['makespan'],
           'success_rate': stats['success_rate'],
           'throughput': stats['throughput']
       })
   
   # Save results
   df = pd.DataFrame(results)
   df.to_csv('planner_evaluation.csv', index=False)
   print("\\nResults saved to planner_evaluation.csv")

Coordinate System Handling
---------------------------

If your planner uses row-column (y,x) format:

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

Or use the ``--flip_coord=1`` flag when running SMART directly.

Dealing with Continuous Time
-----------------------------

If your planner outputs continuous time paths:

.. code-block:: python

   def discretize_paths(continuous_paths, timestep=1.0):
       """Convert continuous time paths to discrete timesteps."""
       discrete_paths = []
       for agent_path in continuous_paths:
           discrete = []
           for x, y, t in agent_path:
               discrete_t = int(round(t / timestep))
               discrete.append((x, y, discrete_t))
           discrete_paths.append(discrete)
       return discrete_paths

Performance Tips
----------------

1. **Use headless mode** for batch experiments
2. **Pre-compile paths** to avoid repeated planning
3. **Use appropriate robot parameters** matching your assumptions
4. **Run multiple trials** for statistical significance

Example: Full Integration
--------------------------

Complete example integrating a custom planner:

.. code-block:: python

   # integrate_my_planner.py
   
   import argparse
   from pathlib import Path
   from smart_client import SMARTClient
   from my_planner import MyMAPFPlanner
   
   def main():
       parser = argparse.ArgumentParser()
       parser.add_argument('--map', required=True)
       parser.add_argument('--scen', required=True)
       parser.add_argument('--agents', type=int, required=True)
       parser.add_argument('--headless', action='store_true')
       parser.add_argument('--output', default='results.csv')
       args = parser.parse_args()
       
       # Initialize planner
       planner = MyMAPFPlanner()
       
       # Solve MAPF problem
       print(f"Planning for {args.agents} agents...")
       solution = planner.solve(
           map_file=args.map,
           scen_file=args.scen,
           num_agents=args.agents
       )
       
       if not solution:
           print("Planner failed to find solution!")
           return
       
       # Convert to SMART format
       paths = solution.get_paths()
       
       # Execute in SMART
       print("Running simulation...")
       client = SMARTClient()
       client.load_simulation(args.map, args.scen, args.agents)
       client.set_paths(paths)
       stats = client.run(headless=args.headless)
       
       # Report results
       print(f"\\nResults:")
       print(f"  Makespan: {stats['makespan']}")
       print(f"  Sum of costs: {stats['sum_of_costs']}")
       print(f"  Success rate: {stats['success_rate']*100:.1f}%")
       print(f"  Throughput: {stats['throughput']:.2f} agents/sec")
       
       # Save detailed stats
       import json
       with open(args.output, 'w') as f:
           json.dump(stats, f, indent=2)
       print(f"\\nDetailed stats saved to {args.output}")
   
   if __name__ == '__main__':
       main()

Next Steps
----------

* :doc:`apis` - Python API reference
* :doc:`examples` - Example integrations
* :doc:`usage` - Running simulations

Web Demo Tutorial
=================

SMART provides a public interactive demonstration at
https://smart-mapf.github.io/demo/ where you can explore SMART in the browser.

This page intentionally describes only behavior that is visible in the current
public demo bundle.

Overview
--------

The current demo exposes:

* bundled example maps
* map/scenario/path file inputs
* a **Simulate** action
* playback controls including **Time** and **Speed**
* robot selection details
* a **Statistics** panel that shows **Sum of costs**, **Makespan**, and **Average time**

Accessing the Demo
------------------

Visit: https://smart-mapf.github.io/demo/

The demo runs entirely in the browser.

Interface Layout
----------------

The current UI includes several named panels:

* **Examples** - bundled demo scenarios
* **Input** - map, scenario, and plan/path file inputs
* **Run** - simulation start controls
* **Playback** - time and speed controls
* **Selection** - details for selected robots
* **Statistics** - summary metrics after a run

Bundled Example Maps
--------------------

The current public bundle includes example maps for:

* ``den312d``
* ``empty-32-32``
* ``maze-32-32-4``
* ``random-64-64-10``
* ``room-64-64-16``
* ``warehouse-10-20-10-2-1``

Using Bundled Examples
----------------------

1. Open the demo.
2. In the **Examples** panel, open one of the bundled examples.
3. In the **Run** panel, click **Simulate**.
4. Use the **Playback** controls to adjust **Time** and **Speed**.

Using Your Own Files
--------------------

The current bundle also exposes file inputs for:

* **Map**
* **Scenario**
* **Plan/Path**

To try custom data:

1. Open the **Input** panel.
2. Upload a `.map` file.
3. Upload a matching `.scen` file.
4. Upload a path file.
5. Start the run with **Simulate**.

Playback
--------

The current public demo exposes:

* a **Time** control
* a **Speed** control
* an interactive 3D visualization window

Statistics Panel
----------------

After a simulation finishes, the current **Statistics** panel shows:

* **Sum of costs**
* **Makespan**
* **Average time**

Before the run ends, the panel shows a placeholder message rather than final
numbers.

Interactive Features
--------------------

The current public demo supports robot selection. When you select robots, the
**Selection** panel shows per-robot details such as:

* position
* rotation
* completion progress
* a small progress sparkline

Next Steps
----------

After exploring the web demo:

1. **Install SMART** - :doc:`installation`
2. **Create scenarios** - :doc:`input_formats`
3. **Integrate planners** - :doc:`planner_integration`
4. **Run experiments** - :doc:`usage`

**Questions or Issues?**

* Check the :doc:`faq` for common questions
* Visit https://github.com/smart-mapf/smart for the source repository
* Open an issue on GitHub for bugs or feature requests

Try It Now
----------

👉 **https://smart-mapf.github.io/demo/**

Try the bundled examples first, then upload your own map/scenario/path triplet
if you want to compare custom plans.

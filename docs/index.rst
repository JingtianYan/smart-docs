Welcome to SMART
================

SMART is an open-source testbed for executing and evaluating Multi-Agent Path
Finding (MAPF) plans in a realistic simulator. The public codebase combines
`ARGoS 3 <https://www.argos-sim.info/>`_ for simulation, an Action Dependency
Graph (ADG) based execution monitor, and helper scripts for turning benchmark
maps and scenarios into runnable experiments.

This documentation site tracks the current public SMART sources:

* Source code: `smart-mapf/smart <https://github.com/smart-mapf/smart>`_
* Paper: `arXiv:2503.04798 <https://arxiv.org/abs/2503.04798>`_
* Documentation source: `JingtianYan/smart-docs <https://github.com/JingtianYan/smart-docs>`_

Video Demo
----------

Watch the SMART demonstration video on YouTube:
`https://www.youtube.com/watch?v=TX-oGSgM8VQ <https://www.youtube.com/watch?v=TX-oGSgM8VQ>`_

How to Get It
-------------

The public repository is distributed as source code:

* :doc:`smart/build_linux` - Build on Ubuntu/Linux
* :doc:`smart/installation` - Installation summary

How to Use It
-------------

SMART provides a few practical entry points:

* **Web demo**: Explore the public demo at https://smart-mapf.github.io/demo/ - see :doc:`smart/web_demo`
* **Run the shipped examples**: See :doc:`smart/running` and :doc:`smart/examples`
* **Prepare inputs**: Use :doc:`smart/input_formats` for `.map`, `.scen`, and path files
* **Integrate a planner**: Write a SMART path file and run it with :doc:`smart/planner_integration`
* **Inspect outputs**: See :doc:`smart/apis` for the current command-line interface and statistics outputs

What the Public Repo Includes
-----------------------------

The current public SMART repository contains:

* ``run_sim.py`` as the main helper script
* ``ArgosConfig/`` for generating ARGoS configuration files
* ``server/`` for the ADG execution-monitoring server
* ``client/`` for ARGoS controllers and executors
* Example maps, scenarios, and path files in the repository root

Research Paper
--------------

The technical background and evaluation are described in the SMART paper:
`Advancing MAPF towards the Real World: A Scalable Multi-Agent Realistic Testbed (SMART) <https://arxiv.org/abs/2503.04798>`_.

Please cite it as:

.. code-block:: bibtex

   @article{yan2025smart,
     title={Advancing MAPF towards the Real World: A Scalable Multi-Agent Realistic Testbed (SMART)},
     author={Yan, Jingtian and Li, Zhifei and Kang, William and Zheng, Kevin and Zhang, Yulun and Chen, Zhe and Zhang, Yue and Harabor, Daniel and Smith, Stephen F and Li, Jiaoyang},
     journal={arXiv preprint arXiv:2503.04798},
     year={2025}
   }

Participate
-----------

* Source repository: `smart-mapf/smart <https://github.com/smart-mapf/smart>`_
* Source issue tracker: `smart-mapf/smart issues <https://github.com/smart-mapf/smart/issues>`_
* Documentation repository: `JingtianYan/smart-docs <https://github.com/JingtianYan/smart-docs>`_

FAQ
---

If you run into problems, check :doc:`smart/faq`.

License
-------

SMART is released under the MIT License.

Copyright (c) 2025 Carnegie Mellon University

Getting Started
---------------

.. toctree::
   :maxdepth: 2

   smart/overview
   smart/web_demo
   smart/installation
   smart/build_linux
   smart/running
   smart/input_formats

.. toctree::
   :hidden:
   :maxdepth: 2
   :caption: Using SMART

   smart/usage
   smart/examples
   smart/apis
   smart/planner_integration

.. toctree::
   :hidden:
   :maxdepth: 2
   :caption: Advanced

   smart/settings
   smart/architecture

.. toctree::
   :hidden:
   :maxdepth: 1
   :caption: Resources

   smart/paper
   smart/faq
   smart/who_is_using

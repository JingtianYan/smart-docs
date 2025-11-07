Welcome to SMART
================

SMART is a simulator for multi-agent path finding, built on `ARGoS <https://www.argos-sim.info/>`_. 
It is open-source, cross platform, and supports realistic physics-based simulation 
for evaluating MAPF algorithms with hundreds to thousands of agents.

Our goal is to develop SMART as a platform for MAPF research to bridge the gap 
between algorithmic planning and real-world deployment. For this purpose, SMART 
exposes APIs to integrate various MAPF planners and retrieve execution statistics.

**Video Demo**

Watch the SMART demonstration video on YouTube: `https://www.youtube.com/watch?v=TX-oGSgM8VQ <https://www.youtube.com/watch?v=TX-oGSgM8VQ>`_

How to Get It
-------------

**Download**

* Download the latest release from `GitHub Releases <https://github.com/smart-mapf/smart/releases>`_

**Build from Source**

* :doc:`smart/build_linux` - Build on Ubuntu/Linux
* :doc:`smart/installation` - General installation guide

How to Use It
-------------

SMART provides multiple ways to explore and use the testbed:

* **Try the Web Demo**: Experience SMART instantly at https://smart-mapf.github.io/demo/ - see :doc:`smart/web_demo` for a full walkthrough
* **Quick Start**: See :doc:`smart/running` to launch your first simulation
* **Python API**: Use the :doc:`smart/apis` for programmatic control
* **Planner Integration**: Connect your MAPF algorithm via :doc:`smart/planner_integration`
* **Configuration**: Customize simulations using :doc:`smart/settings`

Check out our :doc:`smart/examples` for common use cases.

Tutorials
---------

* :doc:`smart/examples` - Getting started examples
* :doc:`smart/paper` - Research paper and benchmarks

Participate
-----------

**Paper**

More technical details are available in the `SMART paper (arXiv:2503.04798) <https://arxiv.org/abs/2503.04798>`_.

Please cite this as:

.. code-block:: bibtex

   @article{yan2025smart,
     title={Advancing MAPF towards the Real World: A Scalable Multi-Agent Realistic Testbed (SMART)},
     author={Yan, Jingtian and Li, Zhifei and Kang, William and Zheng, Kevin and Zhang, Yulun and Chen, Zhe and Zhang, Yue and Harabor, Daniel and Smith, Stephen F and Li, Jiaoyang},
     journal={arXiv preprint arXiv:2503.04798},
     year={2025}
   }

**Contribute**

* `GitHub Repository <https://github.com/smart-mapf/smart>`_
* `Issue Tracker <https://github.com/smart-mapf/smart/issues>`_

**Who is Using SMART?**

See :doc:`smart/who_is_using` for projects and research using SMART.

What's New
----------

* Initial release with ARGoS-based simulation
* Support for 100+ agents
* Action Dependency Graph execution monitoring
* Python API for planner integration

FAQ
---

If you run into problems, check the :doc:`smart/faq`.

License
-------

This project is released under the MIT License.

Copyright © 2025 Carnegie Mellon University

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

Installation
============

This page summarises the main installation and build steps for SMART from the
public project README. The current public repository is a source-based project.
The README explicitly mentions Ubuntu 22.04, and the steps below show the
minimal build flow for a local development environment.

Prerequisites
-------------

* CMake (>= 3.16)
* A modern C++ compiler supported by the repo CMake files
* Boost (program_options, system, filesystem)
* ARGoS 3 (for robot simulation integration)
* Git, to fetch the repo and submodules

The SMART repository vendors rpclib as a git submodule.

Quick Build
-----------

From the SMART project root:

.. code-block:: bash

   git submodule init
   git submodule update
   mkdir build
   cd build
   cmake ..
   make -j

For a release build with optimizations:

.. code-block:: bash

   cmake -DCMAKE_BUILD_TYPE=Release ..
   make -j

Notes
-----

* The top-level CMake configuration can skip the ARGoS client component if
  ARGoS is not found, but a full SMART run still needs ARGoS plus the built
  controller library.
* The public repo does not currently provide a Python-only install path.
* See :doc:`build_linux` for a more detailed Linux walkthrough.

Installation
============

This page summarises the main installation and build steps for SMART (from the
original project README). The SMART project targets Ubuntu-like systems for
native builds; the steps below show the minimal commands for compiling and
running the code in a local development environment.

Prerequisites
-------------

- CMake (>= 3.16)
- A C++17 compatible compiler (g++ or clang)
- Boost (program_options, system, filesystem)
- Argos 3 (for robot simulation integration)
- rpclib (for RPC support)

Quick build (native)
---------------------

From the SMART project root:

.. code-block:: bash

   git submodule init
   git submodule update
   mkdir build
   cd build
   cmake ..
   make -j

To produce a Release build with optimizations:

.. code-block:: bash

   cmake -DCMAKE_BUILD_TYPE=Release ..
   make -j

Notes
-----

- If you only want to use the Python simulator components and avoid native
  compilation, consult the `Running` page for Python-based instructions that
  may require fewer system packages.

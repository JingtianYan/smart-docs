Build on Linux
==============

This page provides instructions for building SMART on Ubuntu and similar Linux
distributions.

Prerequisites
-------------

The public README explicitly mentions Ubuntu 22.04. A minimal package set is:

.. code-block:: bash

   sudo apt-get update
   sudo apt-get install -y \
       cmake \
       g++ \
       libboost-all-dev \
       git

Additional dependencies:

* **ARGoS 3** - physics-based robot simulator
* **rpclib** - included as a git submodule in the SMART repository

Install ARGoS 3
---------------

Follow the official `ARGoS installation guide <https://www.argos-sim.info/core.php>`_.

Quick install:

.. code-block:: bash

   cd /tmp
   git clone https://github.com/ilpincy/argos3.git
   cd argos3
   mkdir build && cd build
   cmake ../src
   make -j$(nproc)
   sudo make install

Build SMART
-----------

Clone the repository and build:

.. code-block:: bash

   git clone https://github.com/smart-mapf/smart.git
   cd smart
   git submodule init
   git submodule update
   mkdir build && cd build
   cmake ..
   make -j$(nproc)

For a release build with optimizations:

.. code-block:: bash

   cmake -DCMAKE_BUILD_TYPE=Release ..
   make -j$(nproc)

Verify Installation
-------------------

After building, verify the installation:

.. code-block:: bash

   # Check if the server binary was created
   ls -l build/server/ADG_server

   # Check that ARGoS is available
   argos3 -h

   # Inspect the SMART helper CLI
   cd ..
   python run_sim.py --help

Troubleshooting
---------------

**Linking errors with conda**

If you encounter linking errors and have conda in your PATH, try temporarily
removing conda from your shell environment before building. The upstream README
mentions this as a common source of linking problems.

**ARGoS not found**

If CMake cannot find ARGoS, install ARGoS 3 first and make sure its libraries
and CMake metadata are visible to your build environment. Then re-run CMake.

If the client component is skipped during configuration, SMART will not have
the controller library needed for a full simulation run.

Next Steps
----------

* :doc:`running` - Run your first simulation
* :doc:`usage` - Detailed usage guide

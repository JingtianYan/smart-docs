Build on Linux
==============

This page provides instructions for building SMART on Ubuntu and other Linux distributions.

Prerequisites
-------------

The following packages are required:

.. code-block:: bash

   sudo apt-get update
   sudo apt-get install -y \
       cmake \
       g++ \
       libboost-all-dev \
       git

Additional dependencies:

* **ARGoS 3** - Physics-based robot simulator
* **rpclib** - For RPC communication between planner and simulator

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

Install rpclib
--------------

The SMART repository includes rpclib as a submodule.

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

   # Check if server binary was created
   ls -l build/server/ADG_server
   
   # Run a simple test
   cd ..
   python run_sim.py --help

Troubleshooting
---------------

**Linking errors with conda**

If you encounter linking errors and have conda in your PATH, try temporarily
removing conda from your PATH before building:

.. code-block:: bash

   # Edit ~/.bashrc and comment out conda initialization
   # Then in a new terminal:
   mkdir build && cd build
   cmake ..
   make -j$(nproc)

**ARGoS not found**

If CMake cannot find ARGoS, specify the installation path:

.. code-block:: bash

   cmake -DARGOS_PREFIX=/usr/local ..

Next Steps
----------

* :doc:`running` - Run your first simulation
* :doc:`usage` - Detailed usage guide

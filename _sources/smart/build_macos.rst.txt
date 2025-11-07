Build on macOS
==============

This page provides instructions for building SMART on macOS.

Prerequisites
-------------

Install Xcode command line tools:

.. code-block:: bash

   xcode-select --install

Install Homebrew if not already installed:

.. code-block:: bash

   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

Install Dependencies
--------------------

Install required packages via Homebrew:

.. code-block:: bash

   brew install cmake boost git

Install ARGoS 3
---------------

Follow the official `ARGoS installation guide <https://www.argos-sim.info/core.php>`_.

Build ARGoS from source:

.. code-block:: bash

   cd /tmp
   git clone https://github.com/ilpincy/argos3.git
   cd argos3
   mkdir build && cd build
   cmake -DCMAKE_BUILD_TYPE=Release ../src
   make -j$(sysctl -n hw.ncpu)
   sudo make install

Install rpclib
--------------

The SMART repository includes rpclib as a submodule.

Build SMART
-----------

Clone and build:

.. code-block:: bash

   git clone https://github.com/smart-mapf/smart.git
   cd smart
   git submodule init
   git submodule update
   mkdir build && cd build
   cmake -DCMAKE_BUILD_TYPE=Release ..
   make -j$(sysctl -n hw.ncpu)

Verify Installation
-------------------

Check that the build succeeded:

.. code-block:: bash

   # Verify server binary
   ls -l build/server/ADG_server
   
   # Test Python wrapper
   cd ..
   python run_sim.py --help

Troubleshooting
---------------

**CMake not finding boost**

If CMake cannot find boost libraries, specify the path:

.. code-block:: bash

   cmake -DBOOST_ROOT=/opt/homebrew/opt/boost ..

**Compiler issues**

Ensure you're using Apple Clang or a recent GCC:

.. code-block:: bash

   which clang++
   clang++ --version

Next Steps
----------

* :doc:`running` - Run your first simulation
* :doc:`usage` - Detailed usage guide

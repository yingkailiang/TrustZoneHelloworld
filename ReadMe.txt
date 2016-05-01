Versatile Express TrustZone Example
====================================

This example demonstrates two images running in parallel, using the TrustZone Security Extensions.  Where one image runs in the Secure world, and the other image runs in the Normal (or Non-Secure) world.

The intention of the example is to provide a basic introduction to using the Security Extensions on a Versatile Express board.  It is not intended as a reference for developing a trusted execution environment.


Version
========
1.0


Support
========
The example is provided "as is" and without any support entitlement.  If you have questions you can try public resources, such as the ARM forums (http://forums.arm.com).


Prerequisites
==============
The example requires RVDS 4.1 Professional SP1 (or later).

RealView-ICE or DStream JTAG Debug Unit

Versatile Express Motherboard with CoreTile Express A9x4


Limitations
============
This example is intended to demonstrate the steps required to boot a TrustZone enabled system, and run software in both worlds.  It therefore aims for simplicity over efficiency or security.  In particular:
* The TrustZone Protection Controller (TZPC) is configured to allow non-secure access to all memory and peripherals.
* The Secure Monitor only provides a partial context switch.


Running the example
====================
*



Expected Output
================
hello from Normal world
hello from Secure world
hello from Normal world
hello from Secure world
hello from Normal world
hello from Secure world
hello from Normal world
hello from Secure world
hello from Normal world
hello from Secure world
hello from Normal world
hello from Secure world
hello from Normal world
hello from Secure world
hello from Normal world
hello from Secure world
hello from Normal world
hello from Secure world
hello from Normal world
hello from Secure world


File List
==========

 <root>
  |-> /headers
  |     |-> bp147_tzpc.h          C header file for BP147 TZPC helper functions
  |     |-> v7.h                  C header file for misc ARMv7-A helper functions
  |-> /obj                        This is where generated objected files will be placed
  |-> /src
  |     |-> bp147_tzpc.c          Implementation of BP147 TZPC helper functions
  |     |-> v7.s                  Implementation of misc ARMv7-A helper functions
  |     |-> main_normal.c         main() for the Normal world
  |     |-> main_secure.c         main() for the Secure world
  |     |-> monitor.c             Code for the Secure Monitor
  |     |-> retarget_normal.c     Wrapper for main(), for Normal world
  |     |-> retarget_secure.c     Wrapper for main(), for Secure world
  |     |-> startup_normal.s      Initialization code for Normal world
  |     |-> startup_secure.s      Initialization code for Secure world
  |-> build.bat                   Build script for DOS
  |-> build.sh                    Build script for BASH
  |-> ReadMe.txt                  This file
  |-> scatter_secure.txt          scatter file for the Secure world image
  |-> scatter_normal.txt          scatter file for the Normal world image
  |-> normal.axf                  Debug symbols for Normal world
  |-> secure.axf                  Debug symbols for Secure world, code for both worlds
  
  
Description
============

Execution flow
---------------

  secureStart     startup_secure.s: Initialization of Secure world
       |
    __main        ARM library initialization
       |
  $Sub$$main      retarget_secure.s: Enable caches and configure TZPC
       |
  monitorInit     monitor.s: Initialize Monitor and call NS world
       |
  << S -> NS >>
       |
  normalStart     startup_normal.s: Initialization of Normal world
       |
    __main        ARM library initialization
       |
  $Sub$$main      retarget_normal.s: Enable caches
       |
     main         main_normal.c: Print message and execute SMC
       |
  << NS -> S >>
       |
  SMC_Handler     monitor.s: Perform context switch from NS to S
       |
   $Sub$$main     retarget_secure.s: call Secure world's main()
       |
     main         main_secure.c: Print message and execute SMC
       |
  SMC_Handler     monitor.s: Perform context switch from NS to S
       |
  << S -> NS >>
       |
     main         main_normal.c: Print message and execute SMC
       |
  << NS -> S >>
       |
  SMC_Handler     monitor.s: Perform context switch from NS to S
       |
     main         main_secure.c: Print message and execute SMC
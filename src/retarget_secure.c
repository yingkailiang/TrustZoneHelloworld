/*
** Copyright (C) ARM Limited, 2005. All rights reserved.
*/

#include "bp147_tzpc.h"

extern void $Super$$main(void);
extern void enableCaches(void);
extern void monitorInit(void);

void $Sub$$main(void)
{
  unsigned int tmp;

  // Enable caches
  enableCaches();

  // Configure TZPC
  tmp = BP147_TZPC_BIT_0 | BP147_TZPC_BIT_1 |
        BP147_TZPC_BIT_2 | BP147_TZPC_BIT_3 |
        BP147_TZPC_BIT_4 | BP147_TZPC_BIT_5 |
        BP147_TZPC_BIT_6 | BP147_TZPC_BIT_7;
  setDecodeRegionNS(0, tmp);
  setDecodeRegionNS(1, tmp);
  setDecodeRegionNS(2, tmp);

  // Install monitor
  monitorInit();

  // Main program
  $Super$$main();  // calls original main()

  return;
}



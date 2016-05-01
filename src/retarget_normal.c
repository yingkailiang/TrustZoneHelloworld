/*
** Copyright (C) ARM Limited, 2005. All rights reserved.
*/
extern void $Super$$main(void);
extern void enableCaches(void);

void $Sub$$main(void)
{
  enableCaches(); // enables caches
  $Super$$main();  // calls original main()
}



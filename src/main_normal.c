#include <stdio.h>

__smc(0) void yeild(void);

int main(void)
{
  unsigned int i;

  for (i = 0; i < 10; i++)
  {
    printf("hello from Normal world\n");
    yeild();
  } 

  return 0;
}

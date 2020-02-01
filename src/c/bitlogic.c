#include <stdio.h>  // for printf
#include <stdlib.h> // for strtol(), and exit() 
#include <limits.h> // INT_MAX
#include <errno.h>  // for errno

void int2bin(int num) 
{
  // Use a character array to store the bit representation
  // of the integer number, Requires 8bit for the integer,
  // and one extra bit for the null-terminator
  char str[9] = {0};
  int i;
  // Right shift all bits of the integer number 
  // Start with the most left bit...
  for(i = 7; i >= 0; i--) 
  {
    // Ternary operator: if the (num & 1) equals 1 return 1, else return 0 
    str[i] = (num & 1) ? '1' : '0';
    // Shift one bit to the right
    num >>= 1;
  }
  // Print the bit pattern to output
  printf("%s\n", str);
}

int str2int(char *str)
{
  int num;     // integer return value
  errno = 0;   // clear errors
  char *p;     // input string is valid if '\0' on return of strtol
  // Convert str using the decimal system, base 10 for the conversion
  long val = strtol(str, &p, 10);
  // Make sure the return val fits into an int
  if (val > INT_MAX)
  {
    printf("\"%s\" is to large for int!\n", str);
    exit(1);
  }
  // Check if an error occurred, or if the string isn't a valid int 
  if (errno != 0 || *p != '\0')
  {
    printf("\"%s\" is not a valid int!\n", str);
    exit(1);
  }
  num = val;
  return num;
}

int main(int argc, char *argv[]) 
{

  // Users must provide to integer numbers x,y
  int x;
  if (argc == 2)
    x = str2int(argv[1]);
  else
  {
    printf("Integer arguments x missing!\n");
    exit(1);
  }

  printf("Bits counted from right to left:\nMost right bit is #0, and most left bit #7");

  printf("\n\nCheck if the integer is even or odd\n\n");
  printf("x              = ");
  int2bin(x);
  printf("1              = ");
  int2bin(1);
  printf("x & 1          = ");
  int2bin(x & 1);
  printf("(x & 1) == 0   = ");
  printf("%i ", (x & 1) == 0);
  if ((x & 1) == 0)
    printf("(true) -> \"%i\" is even (the least significant bit #0 is \"0\") \n", x);
  else
    printf("(false) -> \"%i\" is odd (the least significant bit #0 is \"1\")\n", x);

  printf("\n\nTest if the n-th bit is set\n\n");
  int n;
  for(n = 0; n < 8; n++)
  {
    printf("Bit #%i set?\n",n);
    printf("1 << %i         = ",n);
    int2bin(1 << n);
    printf("x              = ");
    int2bin(x);
    printf("x & (1 << %i)   = ", n);
    int2bin(x & (1 << n));
    printf("               = %i ", x & (1 << n));
    if (x & (1 << n))
      printf("(true)\n", x);
    else
      printf("(false)\n", x);
  }

  printf("\n\nSet the n-th bit\n\n");
  n = 0;
  for(n = 0; n < 8; n++)
  {
    printf("Bit #%i\n", n);
    printf("1 << %i         = ",n);
    int2bin(1 << n);
    printf("x              = ");
    int2bin(x);
    printf("x | (1 << %i)   = ",n);
    int2bin(x | (1 << n));
    printf("\n");
  }

  printf("\nUnset the n-th bit\n\n");
  n = 0;
  for(n = 0; n < 8; n++)
  {
    printf("Bit #%i\n", n);
    printf("1 << %i         = ",n);
    int2bin(1 << n);
    printf("~(1 << %i)      = ",n);
    int2bin(~(1 << n));
    printf("x              = ");
    int2bin(x);
    printf("x & ~(1 << %i)  = ",n);
    int2bin(x & ~(1 << n));
    printf("\n");
  }

  printf("\nToggle the n-th bit\n\n");
  n = 0;
  for(n = 0; n < 8; n++)
  {
    printf("Bit #%i\n", n);
    printf("1 << %i         = ",n);
    int2bin(1 << n);
    printf("x              = ");
    int2bin(x);
    printf("x ^ (1 << %i)   = ",n);
    int2bin(x ^ (1 << n));
    printf("\n");
  }

  printf("\nTurn off the rightmost 1-bit\n\n");
  printf("x - 1          = ");
  int2bin(x - 1);
  printf("x              = ");
  int2bin(x);
  printf("x & (x - 1)    = ");
  int2bin(x & (x - 1));

  printf("\nIsolate the rightmost 1-bit\n\n");
  printf("-x             = ");
  int2bin(-x);
  printf("x              = ");
  int2bin(x);
  printf("x & (-x)       = ");
  int2bin(x & (-x));

  printf("\nRight propagate the rightmost 1-bit\n\n");
  printf("x - 1          = ");
  int2bin(x - 1);
  printf("x              = ");
  int2bin(x);
  printf("x | (x - 1)    = ");
  int2bin(x | (x - 1));

  printf("\nIsolate the rightmost 0-bit\n\n");
  printf("x + 1          = ");
  int2bin(x + 1);
  printf("~x             = ");
  int2bin(~x);
  printf("x              = ");
  int2bin(x);
  printf("~x & (x + 1)   = ");
  int2bin(~x & (x + 1));

  printf("\nTurn on the rightmost 0-bit\n\n");
  printf("x + 1          = ");
  int2bin(x + 1);
  printf("x              = ");
  int2bin(x);
  printf("x | (x + 1)    = ");
  int2bin(x | (x + 1));

  exit(0);
}

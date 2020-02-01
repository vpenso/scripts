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
  int x,y;
  if (argc == 3)
  {
    // argv[] contains a list of pointers to strings,
    // convert the input strings to int
    x = str2int(argv[1]);
    y = str2int(argv[2]);
  }
  else
  {
    printf("To integer arguments x,y missing!\n");
    exit(1);
  }

  printf("Complement (bit flip)\n");
  printf("%c      = ",'x');
  int2bin(x);
  printf("%s","~x     = ");
  int2bin(~x);
  
  printf("Binary AND\n");
  printf("%c      = ",'x');
  int2bin(x);
  printf("%c      = ",'y');
  int2bin(y);
  printf("%s","x & y  = ");
  int2bin(x & y);

  printf("Binary OR\n");
  printf("%c      = ",'x');
  int2bin(x);
  printf("%c      = ",'y');
  int2bin(y);
  printf("%s","x | y  = ");
  int2bin(x | y);

  printf("Binary XOR\n");
  printf("%c      = ",'x');
  int2bin(x);
  printf("%c      = ",'y');
  int2bin(y);
  printf("%s","x ^ y  = ");
  int2bin(x ^ y);

  printf("Shift left:\n");
  int n = 0;
  for(n = 0; n < 8; n++)
  {
    printf("x << %i = ", n);
    int2bin(x << n);
  }
 
  printf("Shift right:\n");
  for(n = 0; n < 8; n++)
  {
    printf("x >> %i = ", n);
    int2bin(x >> n);
  }
  
  exit(0);
}

#include "unit/unit.h"

static int setup ()
{
  return 1;
}

static bool test ()
{
  return 1;
}

unit const version = {"tl version", NULL, setup, test};

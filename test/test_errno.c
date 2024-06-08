#include "../Unity/src/unity.h"
#include "../include/errno.h"
#include <stdio.h>

void setUp(void) {}

void tearDown(void) {}

void testing_errno_values(void) { TEST_ASSERT_EQUAL_INT(1, E2BIG); }

int main(void) {
  UNITY_BEGIN();
  RUN_TEST(testing_errno_values);
  return UNITY_END();
}

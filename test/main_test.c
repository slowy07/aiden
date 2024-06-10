#include "test_errno.h"
#include "test_stdarg.h"

void setUp(void) {}
void tearDown(void) {}

int main(void) {
  UNITY_BEGIN();

  /**
   * run testing:
   * - test_errno.h
   * - test_stdarg.h
   */
  // test errno
  RUN_TEST(testing_errno_values);
  // test stdarg
  RUN_TEST(test_va_start_and_va_end);
  RUN_TEST(test_va_arg);
  return UNITY_END();
}

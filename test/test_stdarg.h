#ifndef TEST_STDARG_H_
#include "../include/stdarg.h"
#include "test_util.h"

void test_va_start_and_va_end(void) {
#if defined(__i386__)
  va_list ap;
  int lastarg = 42;
  va_start(ap, lastarg);
  TEST_ASSERT_NOT_NULL(ap);
  va_end(ap);
  TEST_ASSERT_NULL(ap);
#endif // defined(__i386__)
}

void test_va_arg(void) {
#if defined(__i386__)
  va_list ap;
  int lastarg = 3;
  va_start(ap, lastarg);
  int first = 1;
  int second = 2;
  int result;
  ap = (char *)&first;
  result = va_arg(ap, int);
  TEST_ASSERT_EQUAL_INT(first, result);
  ap = (char *)&second;
  result = va_arg(ap, int);
  TEST_ASSERT_EQUAL_INT(second, result);
  va_end(ap);
#endif // defined(__i386__)
}

#endif // !TEST_STDARG_H_

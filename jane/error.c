#include "include/error.h"
#include "include/builtin.h"
#include <asm-generic/errno-base.h>
#include <asm-generic/errno.h>
#include <errno.h>

static dontinline long ReturnErrno(int e) {
  errno = e;
  return -1;
}

long ebadf(void) { return ReturnErrno(EBADF); }

long einval(void) { return ReturnErrno(EINVAL); }

long enomem(void) { return ReturnErrno(ENOMEM); }

long enosys(void) { return ReturnErrno(ENOSYS); }

long efault(void) { return ReturnErrno(EFAULT); }

long eintr(void) { return ReturnErrno(EINTR); }

long eoverflow(void) { return ReturnErrno(EOVERFLOW); }

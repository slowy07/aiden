#include "include/fds.h"
#include <stdlib.h>

int MachineFdAdd(struct MachineFds *mfds) {
  int fd;
  struct MachineFdClosed *closed;
  if ((closed = mfds->closed)) {
    fd = closed->fd;
    mfds->closed = closed->next;
    free(closed);
  } else {
    fd = mfds->i;
    if (mfds->i++ == mfds->n) {
      mfds->n = mfds->i + (mfds->i >> 1);
      mfds->p = realloc(mfds->p, mfds->n * sizeof(*mfds->p));
    }
  }
  return fd;
}

void MachineFdRemove(struct MachineFds *mfds, int fd) {
  struct MachineFdClosed *closed;
  mfds->p[fd].cb = NULL;
  if ((closed = malloc(sizeof(struct MachineFdClosed)))) {
    closed->fd = fd;
    closed->next = mfds->closed;
    mfds->closed = closed;
  }
}

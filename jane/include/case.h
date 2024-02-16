#ifndef AIDEN_CASE_H_
#define AIDEN_CASE_H_

#define CASE(OP, CODE)                                                         \
  case OP:                                                                     \
    CODE;                                                                      \
    break
#define CASR(OP, CODE)                                                         \
  case OP:                                                                     \
    CODE;                                                                      \
    return
#define XLAT(x, y)                                                             \
  case x:                                                                      \
    return y

#endif // !AIDEN_CASE_H_

/**
Copyright (c) 2024 arfy slowy

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
**/

/*
 * Copyright (c) 2004, 2005 by
 * Ralf Corsepius, Ulm/Germany. All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software
 * is freely granted, provided that this notice is preserved.
 */

#ifndef _SYS__INTSUP_H
#define _SYS__INTSUP_H

#include "features.h"

#if __GNUC_PREREQ(3, 2)
#define __STDINT_EXP(x) __##x##__
#else
#define __STDINT_EXP(x) x
#include <limits.h>
#endif

#if (defined(__LONG_LONG_MAX__) && (__LONG_LONG_MAX__ > 0x7fffffff)) ||        \
    (defined(LLONG_MAX) && (LLONG_MAX > 0x7fffffff))
#define __have_longlong64 1

#endif // (defined(__LONG_LONG_MAX__) && (__LONG_LONG_MAX__ > 0x7fffffff)) || (
       // defined(LLONG_MAX) && (LLONG_MAX > 0x7fffffff) )

#if __STDINT_EXP(LONG_MAX) > 0x7fffffff
#define __have_long64 1
#elif __STDINT_EXP(LONG_MAX) == 0x7fffffff && !defined(__SPU__)
#define __have_long32 1
#endif // __STDINT_EXP(LONG_MAX) > 0x7fffffff
#endif // !_SYS__INTSUP_H

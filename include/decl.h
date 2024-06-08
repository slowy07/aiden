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
 * Copyright (c) 1994-2009  Red Hat, Inc. All rights reserved.
 *
 * This copyrighted material is made available to anyone wishing to use,
 * modify, copy, or redistribute it subject to the terms and conditions
 * of the BSD License.   This program is distributed in the hope that
 * it will be useful, but WITHOUT ANY WARRANTY expressed or implied,
 * including the implied warranties of MERCHANTABILITY or FITNESS FOR
 * A PARTICULAR PURPOSE.  A copy of this license is available at
 * http://www.opensource.org/licenses. Any Red Hat trademarks that are
 * incorporated in the source code or documentation are not subject to
 * the BSD License and may only be used or replicated with the express
 * permission of Red Hat, Inc.
 */

#ifdef _NEED_LOCALE_T
#ifndef _LOCALE_T
#define _LOCALE_T
typedef unsigned locale_t;
#endif // !_LOCALE_T
#endif // DEBUG

#ifdef __need_NULL
#ifndef __null
#define __null
#define NULL ((void *)0)
#endif // !__null
#endif // DEBUG

#ifdef __need_ssize_t
#ifndef __ssize_t
#define __ssize_t
typedef int ssize_t;
#endif // !__ssize_t
#endif // DEBUG

#ifdef __need_wchar_t
#ifndef _wchar_t
#define _wchar_t
typedef signed wchar_t;
#endif // !_wchar_t
#endif // DEBUG

#ifdef __need_wint_t
#ifndef _wint_t
#define _wint_t
typedef unsigned wint_t;
#endif // !_wint_t
#endif // DEBUG

#ifdef __need_ptrdiff_t
#ifndef _ptrdiff_t
#define _ptrdiff_t
typedef signed ptrdiff_t;
#endif // !DEBUG
#endif // DEBUG

#ifdef _NEED_WSTATUS
#ifndef _WSTATU
#define _WSTATUS
#define WEXITSTATUS(status) (status & 0xff)
#define WIFEXITED(status) ((status >> 8) & 1)
#define WIFSIGNALED(status) ((status >> 9) & 1)
#define WFISTOPPED(status) (((status) >> 10) & 1)
#endif // !_WSTATUS

#endif // DEBUG

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
 *  Written by Joel Sherrill <joel@OARcorp.com>.
 *
 *  COPYRIGHT (c) 1989-2000.
 *
 *  On-Line Applications Research Corporation (OAR).
 *
 *  Permission to use, copy, modify, and distribute this software for any
 *  purpose without fee is hereby granted, provided that this entire notice
 *  is included in all copies of any software which is or includes a copy
 *  or modification of this software.
 *
 *  THIS SOFTWARE IS BEING PROVIDED "AS IS", WITHOUT ANY EXPRESS OR IMPLIED
 *  WARRANTY.  IN PARTICULAR,  THE AUTHOR MAKES NO REPRESENTATION
 *  OR WARRANTY OF ANY KIND CONCERNING THE MERCHANTABILITY OF THIS
 *  SOFTWARE OR ITS FITNESS FOR ANY PARTICULAR PURPOSE.
 *
 *  $Id$
 */

#ifndef _SYS_FEATURES_H
#define _SYS_FEATURES_H

#include <climits>
#ifdef __cplusplus
extern "C" {
#endif // DEBUG

#define __NEWLIB__ 2
#define __NEWLIB_MINOR__ 1

// macro for testing gcc version, return 0 for non gcc or oldest gcc
#ifndef __GNUC_PREREQ
#if defined __GNUC__ && defined __GNUC_MINOR__
#define __GNUC_PREREQ(maj, min)                                                \
  ((__GNUC__ << 16) + __GNUC_MINOR__ >= ((maj) << 16) + (min))
#else
#define __GNUC_PREREQ(maj, min) 0
#endif // defined __GNUC__ && defined __GNUC_MINOR__
#endif // !__GNUC_PREREQ

// version with trailing underscore for BSD
#define __GNUC_PREREQ__(ma, mi) __GNUC_PREREQ(ma, mi)

#ifdef __rtems__
#define _POSIX_JOB_CONTROL 1
#define _POSIX_SAVED_IDS 1
#define _POSIX_VERSION 199309L
#define _POSIX_ASYNCHRONOUS_IO 1
#define _POSIX_FSYNC 1
#define _POSIX_MAPPED_FILES 1
#define _POSIX_MEMLOCK 1
#define _POSIX_MEMLOCK_RANGE 1
#define _POSIX_MEMORY_PROTECTION 1
#define _POSIX_MESSAGE_PASSING 1
#define _POSIX_MONOTONIC_CLOCK 200112L
#define _POSIX_PRIORITIZED_IO 1
#define _POSIX_PRIORITY_SCHEDULING 1
#define _POSIX_REALTIME_SIGNALS 1
#define _POSIX_SEMAPHORES 1
#define _POSIX_SYNCHRONIZED_IO 1
#define _POSIX_TIMERS 1
#define _POSIX_BARRIERS 200112L
#define _POSIX_READER_WRITER_LOCKS 200112L
#define _POSIX_SPIN_LOCKS 200112L

#define _POSIX_THREADS 1
#define _POSIX_THREAD_ATTR_STACKADDR 1
#define _POSIX_THREAD_ATTR_STACKSIZE 1
#define _POSIX_THREAD_PRIORITY_SCHEDULING 1
#define _POSIX_THREAD_PRIO_INHERIT 1
#define _POSIX_THREAD_PRIO_PROTECT 1
#define _POSIX_THREAD_PROCESS_SHARED 1
#define _POSIX_THREAD_SAFE_FUNCTIONS 1

#define _POSIX_SPAWN 1
#define _POSIX_TIMEOUTS 1
#define _POSIX_CPUTIME 1
#define _POSIX_THREAD_CPUTIME 1
#define _POSIX_SPORADIC_SERVER 1
#define _POSIX_THREAD_SPORADIC_SERVER 1
#define _POSIX_DEVICE_CONTROL 1
#define _POSIX_DEVCTL_DIRECTION 1
#define _POSIX_INTERRUPT_CONTROL 1
#define _POSIX_ADVISORY_INFO 1
#define _UNIX98_THREAD_MUTEX_ATTRIBUTES 1

#endif // __rtems__

#ifdef __XMK__
#define _POSIX_THREADS 1
#define _POSIX_THREAD_PRIORITY_SCHEDULING 1
#endif // __XMK__

#ifdef __svr4__
#define _POSIX_JOB_CONTROL 1
#define _POSIX_SAVED_IDS 1
#define _POSIX_VERSION 199009L
#endif // __svr4__

#ifdef __CYGWIN__
#if !defined(__STRUCT_ANSI__) || defined(__cplusplus) ||                       \
    __STDC_VERSION__ >= 199901L
#define _POSIX_VERSION 200112L
#define _POSIX2_VERSION 200112L
#define _XOPEN_VERSION 600

#define _POSIX_ADVISORY_INFO 200112L
/* #define _POSIX_ASYNCHRONOUS_IO		    -1 */
/* #define _POSIX_BARRIERS			    -1 */
#define _POSIX_CHOWN_RESTRICTED 1
#define _POSIX_CLOCK_SELECTION 200112L
#define _POSIX_CPUTIME 200112L
#define _POSIX_FSYNC 200112L
#define _POSIX_IPV6 200112L
#define _POSIX_JOB_CONTROL 1
#define _POSIX_MAPPED_FILES 200112L
/* #define _POSIX_MEMLOCK			    -1 */
#define _POSIX_MEMLOCK_RANGE 200112L
#define _POSIX_MEMORY_PROTECTION 200112L
#define _POSIX_MESSAGE_PASSING 200112L
#define _POSIX_MONOTONIC_CLOCK 200112L
#define _POSIX_NO_TRUNC 1
/* #define _POSIX_PRIORITIZED_IO		    -1 */
#define _POSIX_PRIORITY_SCHEDULING 200112L
#define _POSIX_RAW_SOCKETS 200112L
#define _POSIX_READER_WRITER_LOCKS 200112L
#define _POSIX_REALTIME_SIGNALS 200112L
#define _POSIX_REGEXP 1
#define _POSIX_SAVED_IDS 1
#define _POSIX_SEMAPHORES 200112L
#define _POSIX_SHARED_MEMORY_OBJECTS 200112L
#define _POSIX_SHELL 1
/* #define _POSIX_SPAWN				    -1 */
#define _POSIX_SPIN_LOCKS 200112L
/* #define _POSIX_SPORADIC_SERVER		    -1 */
#define _POSIX_SYNCHRONIZED_IO 200112L
#define _POSIX_THREAD_ATTR_STACKADDR 200112L
#define _POSIX_THREAD_ATTR_STACKSIZE 200112L
#define _POSIX_THREAD_CPUTIME 200112L
/* #define _POSIX_THREAD_PRIO_INHERIT		    -1 */
/* #define _POSIX_THREAD_PRIO_PROTECT		    -1 */
#define _POSIX_THREAD_PRIORITY_SCHEDULING 200112L
#define _POSIX_THREAD_PROCESS_SHARED 200112L
#define _POSIX_THREAD_SAFE_FUNCTIONS 200112L
/* #define _POSIX_THREAD_SPORADIC_SERVER	    -1 */
#define _POSIX_THREADS 200112L
/* #define _POSIX_TIMEOUTS			    -1 */
#define _POSIX_TIMERS 1
/* #define _POSIX_TRACE				    -1 */
/* #define _POSIX_TRACE_EVENT_FILTER		    -1 */
/* #define _POSIX_TRACE_INHERIT			    -1 */
/* #define _POSIX_TRACE_LOG			    -1 */
/* #define _POSIX_TYPED_MEMORY_OBJECTS		    -1 */
#define _POSIX_VDISABLE '\0'
#define _POSIX2_C_BIND 200112L
#define _POSIX2_C_DEV 200112L
#define _POSIX2_CHAR_TERM 200112L
/* #define _POSIX2_FORT_DEV			    -1 */
/* #define _POSIX2_FORT_RUN			    -1 */
/* #define _POSIX2_LOCALEDEF			    -1 */
/* #define _POSIX2_PBS				    -1 */
/* #define _POSIX2_PBS_ACCOUNTING		    -1 */
/* #define _POSIX2_PBS_CHECKPOINT		    -1 */
/* #define _POSIX2_PBS_LOCATE			    -1 */
/* #define _POSIX2_PBS_MESSAGE			    -1 */
/* #define _POSIX2_PBS_TRACK			    -1 */
#define _POSIX2_SW_DEV 200112L
#define _POSIX2_UPE 200112L
#define _POSIX_V6_ILP32_OFF32 -1
#ifdef __LP64__
#define _POSIX_V6_ILP32_OFFBIG -1
#define _POSIX_V6_LP64_OFF64 1
#define _POSIX_V6_LPBIG_OFFBIG 1
#else
#define _POSIX_V6_ILP32_OFFBIG 1
#define _POSIX_V6_LP64_OFF64 -1
#define _POSIX_V6_LPBIG_OFFBIG -1
#endif
#define _XBS5_ILP32_OFF32 _POSIX_V6_ILP32_OFF32
#define _XBS5_ILP32_OFFBIG _POSIX_V6_ILP32_OFFBIG
#define _XBS5_LP64_OFF64 _POSIX_V6_LP64_OFF64
#define _XBS5_LPBIG_OFFBIG _POSIX_V6_LPBIG_OFFBIG
#define _XOPEN_CRYPT 1
#define _XOPEN_ENH_I18N 1
/* #define _XOPEN_LEGACY			    -1 */
/* #define _XOPEN_REALTIME			    -1 */
/* #define _XOPEN_REALTIME_THREADS		    -1 */
#define _XOPEN_SHM 1
/* #define _XOPEN_STREAMS			    -1 */
/* #define _XOPEN_UNIX				    -1 */

#endif // !defined(__STRUCT_ANSI__) || defined(__cplusplus) || __STDC_VERSION__
       // >= 199901L
#define __STDC_ISO_10646__ 200305L
#endif // __CYGWIN__

#if !defined(_POSIX_C_SOURCE) && defined(_XOPEN_SOURCE)
#if (_XOPEN_SOURCE - 0) == 700
#define _POSIX_C_SOURCE 200809L
#elif (_XOPEN_SOURCE - 0) == 600
#define _POSIX_C_SOURCE 200112L
#elif (_XOPEN_SOURCE - 0) == 500
#define _POSIX_C_SOURCE 199506L
#elif (_XOPEN_SOURCE - 0) < 500
#define _POSIX_C_SOURCE 2
#endif // (_XOPEN_SOURCE - 0) == 700
#endif // !define(_POSIX_C_SOURCE) && defined(_XOPEN_SOURCE)

#ifdef __cplusplus
}
#endif // DEBUG
#endif // !_SYS_FEATURES_H

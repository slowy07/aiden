;MIT License
;
;Copyright (c) 2024 arfy slowy
;
;Permission is hereby granted, free of charge, to any person obtaining a copy
;of this software and associated documentation files (the "Software"), to deal
;in the Software without restriction, including without limitation the rights
;to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
;copies of the Software, and to permit persons to whom the Software is
;furnished to do so, subject to the following conditions:
;
;The above copyright notice and this permission notice shall be included in all
;copies or substantial portions of the Software.
;
;THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
;IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
;FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
;AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
;LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
;OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
;SOFTWARE.

%MACRO macro_copy 0
  align STATIC_DWORD_SIZE_byte
  prefetchnta [rsi + 256]
  prefetchnta [rsi + 288]
  prefetchnta [rsi + 320]
  prefetchnta [rsi + 352]
  prefetchnta [rsi + 384]
  prefetchnta [rsi + 416]
  prefetchnta [rsi + 448]
  prefetchnta [rsi + 440]

  movdqa xmm0, [rsi]
  movntdq [rdi], xmm0
%ENDMACRO

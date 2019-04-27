# Copyright 2019 Josua Mayer <josua@solid-run.com>
# Copyright 2017-2019 Yuri Gribov
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

.data
msg_err_x0:
	.ascii "Error: value of x0 not restored!\n"
msg_err_x0_len = . - msg_err_x0
msg_err_x1:
	.ascii "Error: value of x1 not restored!\n"
msg_err_x1_len = . - msg_err_x1
msg_err_x2:
	.ascii "Error: value of x2 not restored!\n"
msg_err_x2_len = . - msg_err_x2
msg_err_x3:
	.ascii "Error: value of x3 not restored!\n"
msg_err_x3_len = . - msg_err_x3
msg_err_x4:
	.ascii "Error: value of x4 not restored!\n"
msg_err_x4_len = . - msg_err_x4
msg_err_x5:
	.ascii "Error: value of x5 not restored!\n"
msg_err_x5_len = . - msg_err_x5
msg_err_x6:
	.ascii "Error: value of x6 not restored!\n"
msg_err_x6_len = . - msg_err_x6
msg_err_x7:
	.ascii "Error: value of x7 not restored!\n"
msg_err_x7_len = . - msg_err_x7
msg_err_x8:
	.ascii "Error: value of x8 not restored!\n"
msg_err_x8_len = . - msg_err_x8
msg_err_lr:
	.ascii "Error: value of lr not restored!\n"
msg_err_lr_len = . - msg_err_lr

.text
.global main

main:
	# save return address on stack
	str lr, [sp,#-16]!

	# initialize registers with well-known constants
	mov x0, #100
	mov x1, #101
	mov x2, #102
	mov x3, #103
	mov x4, #104
	mov x5, #105
	mov x6, #106
	mov x7, #107
	mov x8, #108
	mov lr, #109

	# jump to arbitrary piece of code
	#b noop
	#b save_and_restore
	b save_and_restore_v2

	# This is where arbitrary code should return to
back:
	# check values of those registers
	# x0
	cmp x0, #100
	beq #12
	mov x0, #0
	b err
	# x1
	cmp x1, #101
	beq #12
	mov x0, #1
	b err
	cmp x2, #102
	beq #12
	mov x0, #2
	b err
	cmp x3, #103
	beq #12
	mov x0, #3
	b err
	cmp x4, #104
	beq #12
	mov x0, #4
	b err
	cmp x5, #105
	beq #12
	mov x0, #5
	b err
	cmp x6, #106
	beq #12
	mov x0, #6
	b err
	cmp x7, #107
	beq #12
	mov x0, #7
	b err
	cmp x8, #108
	beq #12
	mov x0, #8
	b err
	cmp lr, #109
	beq #12
	mov x0, #9
	b err

	# retrieve lr from stack
	ldr lr, [sp], #16

	# return 0 in 32-bit result register
	mov w0, #0
	ret

err:
	# choose error message
	# x0
	ldr x1, =msg_err_x0
	ldr x2, =msg_err_x0_len
	cmp x0, 0
	beq write
	# x1
	ldr x1, =msg_err_x1
	ldr x2, =msg_err_x1_len
	cmp x0, 1
	beq write
	# x2
	ldr x1, =msg_err_x2
	ldr x2, =msg_err_x2_len
	cmp x0, 2
	beq write
	# x3
	ldr x1, =msg_err_x3
	ldr x2, =msg_err_x3_len
	cmp x0, 3
	beq write
	# x4
	ldr x1, =msg_err_x4
	ldr x2, =msg_err_x4_len
	cmp x0, 4
	beq write
	# x5
	ldr x1, =msg_err_x5
	ldr x2, =msg_err_x5_len
	cmp x0, 5
	beq write
	# x6
	ldr x1, =msg_err_x6
	ldr x2, =msg_err_x6_len
	cmp x0, 6
	beq write
	# x7
	ldr x1, =msg_err_x7
	ldr x2, =msg_err_x7_len
	cmp x0, 7
	beq write
	# x8
	ldr x1, =msg_err_x8
	ldr x2, =msg_err_x8_len
	cmp x0, 8
	beq write
	# lr
	ldr x1, =msg_err_lr
	ldr x2, =msg_err_lr_len
	cmp x0, 9
	beq write

write:
	# write
	mov x0, #1
	mov x8, #64
	svc #0

	# restore lr from stack
	ldr lr, [sp], #16

	# return 1
	mov w0, #1
	ret

# this is a small test function that does nothing
noop:
	b back

# This is the code I want to verify
# 1. save all registers on the stack
# 2. overwrite all registers
# 3. restore all registers from the stack
# Original source: https://github.com/yugr/Implib.so
save_and_restore:
	# store
	str x0, [sp,#-16]!
	ldr x0, [sp, #16]
	str x1, [sp,#-16]!
	str x2, [sp,#-16]!
	str x3, [sp,#-16]!
	str x4, [sp,#-16]!
	str x5, [sp,#-16]!
	str x6, [sp,#-16]!
	str x7, [sp,#-16]!
	str x8, [sp,#-16]!
	str lr, [sp,#-16]!

	# overwrite all
	mov x0, #0
	mov x1, #0
	mov x2, #0
	mov x3, #0
	mov x4, #0
	mov x5, #0
	mov x6, #0
	mov x7, #0
	mov x8, #0
	mov lr, #0

	# restore
	ldr lr, [sp], #16
	ldr x8, [sp], #16
	ldr x7, [sp], #16
	ldr x6, [sp], #16
	ldr x5, [sp], #16
	ldr x4, [sp], #16
	ldr x3, [sp], #16
	ldr x2, [sp], #16
	ldr x1, [sp], #16
	ldr x0, [sp], #16

	# return
	b back

save_and_restore_v2:
	# store
	stp x0, x1, [sp, #-16]!
	stp x2, x3, [sp, #-16]!
	stp x4, x5, [sp, #-16]!
	stp x6, x7, [sp, #-16]!
	stp x8, lr, [sp, #-16]!
	ldr x0, [sp, #80]

	# overwrite
	mov x0, #0
	mov x1, #0
	mov x2, #0
	mov x3, #0
	mov x4, #0
	mov x5, #0
	mov x6, #0
	mov x7, #0
	mov x8, #0
	mov lr, #0

	# restore
	ldp x8, lr, [sp], #16
	ldp x6, x7, [sp], #16
	ldp x4, x5, [sp], #16
	ldp x2, x3, [sp], #16
	ldp x0, x1, [sp], #16

	# return
	b back

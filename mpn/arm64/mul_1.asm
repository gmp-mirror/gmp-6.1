dnl  ARM64 mpn_mul_1

dnl  Contributed to the GNU project by Torbjörn Granlund.

dnl  Copyright 2013 Free Software Foundation, Inc.

dnl  This file is part of the GNU MP Library.

dnl  The GNU MP Library is free software; you can redistribute it and/or modify
dnl  it under the terms of the GNU Lesser General Public License as published
dnl  by the Free Software Foundation; either version 3 of the License, or (at
dnl  your option) any later version.

dnl  The GNU MP Library is distributed in the hope that it will be useful, but
dnl  WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
dnl  or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public
dnl  License for more details.

dnl  You should have received a copy of the GNU Lesser General Public License
dnl  along with the GNU MP Library.  If not, see http://www.gnu.org/licenses/.

include(`../config.m4')

C	     cycles/limb
C Cortex-A53	 ?
C Cortex-A57	 ?

define(`rp', `x0')
define(`up', `x1')
define(`n',  `x2')
define(`v0', `x3')

ASM_START()
PROLOGUE(mpn_mul_1)
	ldr	x12, [up], #8
	and	x6, n, #3
	and	n, n, #-4
	cbz	x6, L(fi0)
	cmp	x6, #2
	bcc	L(fi1)
	beq	L(fi2)

L(fi3):	mul	x8, x12, v0
	umulh	x13, x12, v0
	cmn	xzr, xzr
	b	L(L3)
L(fi2):	mul	x7, x12, v0
	umulh	x5, x12, v0
	cmn	xzr, xzr
	b	L(L2)
L(fi0):	mul	x9, x12, v0
	umulh	x5, x12, v0
	sub	n, n, #4
	cmn	xzr, xzr
	b	L(L0)
L(fi1):	mul	x10, x12, v0
	umulh	x13, x12, v0
	cmn	xzr, xzr
	cbz	n, L(end)

L(top):	sub	n, n, #4
	ldr	x12, [up], #8
	mul	x6, x12, v0
	umulh	x5, x12, v0
	str	x10, [rp], #8
	adcs	x9, x6, x13
L(L0):	ldr	x12, [up], #8
	mul	x6, x12, v0
	umulh	x13, x12, v0
	str	x9, [rp] ,#8
	adcs	x8, x6, x5
L(L3):	ldr	x12, [up], #8
	mul	x6, x12, v0
	umulh	x5, x12, v0
	str	x8, [rp], #8
	adcs	x7, x6, x13
L(L2):	ldr	x12, [up], #8
	mul	x6, x12, v0
	umulh	x13, x12, v0
	str	x7, [rp], #8
	adcs	x10, x6, x5
	cbnz	n, L(top)

L(end):	str	x10, [rp]
	adc	x0, x13, xzr
	ret
EPILOGUE()

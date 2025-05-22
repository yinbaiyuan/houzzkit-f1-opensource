// SPDX-License-Identifier: GPL-2.0
/*
 * Copyright (c) 2020-2024 Rockchip Electronics Co., Ltd.
 *
 * Author: Zorro Liu <zorro.liu@rock-chips.com>
 */

	.text
	.file	"rkf_waveform.c"
	.globl	rkf_wf_input
	.p2align	2
	.type	rkf_wf_input,@function
rkf_wf_input:
	str	x30, [x18], #8
	stp	x29, x30, [sp, #-64]!
	stp	x22, x21, [sp, #32]
	adrp	x22, global_waveform
	stp	x24, x23, [sp, #16]
	mov	x29, sp
	stp	x20, x19, [sp, #48]
	ldr	x8, [x22, :lo12:global_waveform]
	cbz	x8, .LBB0_3
	mov	w0, #-16
.LBB0_2:
	ldp	x20, x19, [sp, #48]
	ldp	x22, x21, [sp, #32]
	ldp	x24, x23, [sp, #16]
	ldp	x29, x30, [sp], #64
	ldr	x30, [x18, #-8]!
	ret
.LBB0_3:
	add	x20, x0, #20
	adrp	x1, .L.str.4
	mov	x19, x0
	add	x1, x1, :lo12:.L.str.4
	mov	x0, x20
	mov	w2, #8
	bl	strncmp
	mov	w21, w0
	cbnz	w0, .LBB0_5
	mov	w2, #16
	b	.LBB0_7
.LBB0_5:
	adrp	x1, .L.str.5
	mov	x0, x20
	add	x1, x1, :lo12:.L.str.5
	mov	w2, #8
	bl	strncmp
	cbnz	w0, .LBB0_16
	mov	w2, #32
.LBB0_7:
	cmp	w21, #0
	adrp	x0, .L.str.6
	cset	w8, ne
	adrp	x9, maxpic
	add	x0, x0, :lo12:.L.str.6
	mov	x1, x20
	strb	w8, [x9, :lo12:maxpic]
	bl	_printk
	adrp	x1, .L.str.7
	add	x0, x19, #4
	add	x1, x1, :lo12:.L.str.7
	mov	w2, #12
	bl	strncmp
	cbnz	w0, .LBB0_17
	ldr	w23, [x19]
	cmp	w23, #256, lsl #12
	b.gt	.LBB0_19
	sxtw	x8, w23
	adrp	x21, crc32_table
	add	x21, x21, :lo12:crc32_table
	mov	w1, wzr
	mov	x0, x21
	mov	w2, #1024
	ldr	w20, [x19, x8]
	mov	w24, #3511
	movk	w24, #1217, lsl #16
	bl	memset
	mov	w13, #28088
	mov	w14, #14044
	mov	w15, #7022
	mov	w8, wzr
	mov	w9, wzr
	mov	w10, wzr
	mov	w11, wzr
	mov	x12, xzr
	movk	w13, #9736, lsl #16
	movk	w14, #4868, lsl #16
	movk	w15, #2434, lsl #16
	mov	w16, #-2147483648
	mov	w17, #1073741824
	mov	w0, #536870912
	mov	w1, #268435456
.LBB0_10:
	lsl	w2, w12, #24
	tst	w12, #0x40
	and	w2, w13, w2, asr #31
	eor	w3, w2, w14
	csel	w2, w2, w3, eq
	tst	w12, #0x20
	eor	w3, w2, w15
	csel	w2, w2, w3, eq
	tst	w12, #0x10
	eor	w3, w2, w24
	csel	w2, w2, w3, eq
	eor	w3, w2, w8
	lsl	w2, w2, #1
	eor	w4, w2, w24
	cmp	w3, #0
	csel	w2, w2, w4, ge
	add	w8, w8, w1
	eor	w3, w2, w9
	lsl	w2, w2, #1
	eor	w4, w2, w24
	cmp	w3, #0
	csel	w2, w2, w4, ge
	add	w9, w9, w0
	eor	w3, w2, w10
	lsl	w2, w2, #1
	eor	w4, w2, w24
	cmp	w3, #0
	csel	w2, w2, w4, ge
	add	w10, w10, w17
	eor	w3, w2, w11
	lsl	w2, w2, #1
	eor	w4, w2, w24
	cmp	w3, #0
	csel	w2, w2, w4, ge
	add	w11, w11, w16
	str	w2, [x21, x12, lsl #2]
	add	x12, x12, #1
	cmp	x12, #256
	b.ne	.LBB0_10
	mov	w2, wzr
	cbz	w23, .LBB0_14
	mov	x8, x19
.LBB0_13:
	ldrb	w9, [x8], #1
	subs	w23, w23, #1
	eor	w9, w9, w2, lsr #24
	ldr	w9, [x21, w9, uxtw #2]
	eor	w2, w9, w2, lsl #8
	b.ne	.LBB0_13
.LBB0_14:
	cmp	w20, w2
	b.ne	.LBB0_18
	mov	w0, wzr
	str	x19, [x22, :lo12:global_waveform]
	b	.LBB0_2
.LBB0_16:
	adrp	x0, .L.str
	add	x0, x0, :lo12:.L.str
	b	.LBB0_20
.LBB0_17:
	adrp	x0, .L.str.8
	add	x0, x0, :lo12:.L.str.8
	bl	_printk
	adrp	x0, .L.str.1
	add	x0, x0, :lo12:.L.str.1
	b	.LBB0_20
.LBB0_18:
	adrp	x0, .L.str.9
	mov	w1, w20
	add	x0, x0, :lo12:.L.str.9
	bl	_printk
.LBB0_19:
	adrp	x0, .L.str.2
	add	x0, x0, :lo12:.L.str.2
.LBB0_20:
	bl	_printk
	mov	w0, #-1
	b	.LBB0_2
.Lfunc_end0:
	.size	rkf_wf_input, .Lfunc_end0-rkf_wf_input

	.globl	rkf_wf_get_version
	.p2align	2
	.type	rkf_wf_get_version,@function
rkf_wf_get_version:
	adrp	x8, global_waveform
	ldr	x8, [x8, :lo12:global_waveform]
	add	x9, x8, #84
	cmp	x8, #0
	csel	x0, xzr, x9, eq
	ret
.Lfunc_end1:
	.size	rkf_wf_get_version, .Lfunc_end1-rkf_wf_get_version

	.globl	rkf_wf_get_lut
	.p2align	2
	.type	rkf_wf_get_lut,@function
rkf_wf_get_lut:
	str	x30, [x18], #8
	stp	x29, x30, [sp, #-96]!
	adrp	x8, global_waveform
	str	x27, [sp, #16]
	stp	x26, x25, [sp, #32]
	mov	x29, sp
	stp	x24, x23, [sp, #48]
	ldr	x8, [x8, :lo12:global_waveform]
	stp	x22, x21, [sp, #64]
	stp	x20, x19, [sp, #80]
	cbz	x8, .LBB2_30
	mov	x20, x0
	cbz	x0, .LBB2_31
	mov	w23, w4
	mov	w19, w2
	mov	w21, w1
	adrp	x27, need_pic
	sub	w8, w1, #8
	cmp	w8, #6
	str	w3, [x27, :lo12:need_pic]
	b.hi	.LBB2_5
	mov	w9, #121
	lsr	w9, w9, w8
	tbz	w9, #0, .LBB2_5
	adrp	x9, .Lswitch.table.rkf_wf_get_lut
	add	x9, x9, :lo12:.Lswitch.table.rkf_wf_get_lut
	ldr	w21, [x9, w8, sxtw #2]
.LBB2_5:
	adrp	x24, rkf_wf_get_lut.sftemp
	mov	w8, #26215
	movk	w8, #26214, lsl #16
	adrp	x26, rkf_wf_get_lut.stype
	ldrsw	x10, [x24, :lo12:rkf_wf_get_lut.sftemp]
	smull	x9, w19, w8
	lsr	x11, x9, #63
	asr	x9, x9, #33
	mul	x8, x10, x8
	add	w25, w9, w11
	lsr	x9, x8, #63
	asr	x8, x8, #33
	add	w8, w8, w9
	cmp	w25, w8
	b.ne	.LBB2_7
	ldr	w9, [x26, :lo12:rkf_wf_get_lut.stype]
	cmp	w9, w21
	b.eq	.LBB2_60
.LBB2_7:
	cmp	w21, #10
	b.eq	.LBB2_59
	ldr	x0, [x20, #8]
	cbz	x0, .LBB2_10
	bl	kfree
	str	xzr, [x20, #8]
.LBB2_10:
	mov	x0, x20
	mov	w1, w21
	mov	w2, w19
	bl	parse_wf_data
	tbnz	w0, #31, .LBB2_66
	mov	w22, w0
	ldr	x1, [x20, #16]
	cbz	w21, .LBB2_32
	adrp	x8, maxpic
	mov	w10, #32
	ldrb	w9, [x8, :lo12:maxpic]
	mov	w8, #16
	cmp	w9, #0
	csel	w10, w10, w8, ne
	cbz	w22, .LBB2_24
	mov	x11, xzr
	mov	x12, xzr
	lsr	w13, w10, #4
	mov	w8, w22
.LBB2_14:
	mul	w15, w10, w12
	ldr	x16, [x20, #8]
	mov	x14, xzr
	sxtw	x15, w15
	mul	x15, x15, x13
	add	x15, x16, x15, lsl #2
	mov	x16, x11
.LBB2_15:
	mul	x0, x14, x13
	mov	w17, wzr
	mov	x2, x16
	mov	x3, x10
	add	x0, x15, x0, lsl #2
.LBB2_16:
	lsr	w4, w17, #5
	and	w5, w17, #0x1e
	subs	x3, x3, #1
	add	w17, w17, #2
	ldr	w4, [x0, w4, uxtw #2]
	lsr	w4, w4, w5
	and	w4, w4, #0x3
	strb	w4, [x1, w2, uxtw]
	add	x2, x2, #1
	b.ne	.LBB2_16
	add	x14, x14, #1
	add	x16, x16, #32
	cmp	x14, x10
	b.ne	.LBB2_15
	add	x12, x12, #1
	add	x11, x11, #1024
	cmp	x12, x8
	b.ne	.LBB2_14
	ldr	w10, [x27, :lo12:need_pic]
	cmp	w10, #16
	cset	w10, eq
	and	w9, w9, w10
	cmp	w9, #1
	b.ne	.LBB2_24
	mov	w9, wzr
	mov	w10, wzr
	mov	x11, xzr
	add	x12, x1, #16
	add	x13, x1, #7
.LBB2_21:
	and	x14, x10, #0x3ffffff
	and	x15, x9, #0x7ffffff
	mov	x16, #-2
	add	x14, x12, x14, lsl #6
	add	x15, x13, x15, lsl #5
.LBB2_22:
	ldurb	w17, [x14, #-16]
	add	x16, x16, #2
	cmp	x16, #30
	sturb	w17, [x15, #-7]
	ldurb	w17, [x14, #-14]
	sturb	w17, [x15, #-6]
	ldurb	w17, [x14, #-12]
	sturb	w17, [x15, #-5]
	ldurb	w17, [x14, #-10]
	sturb	w17, [x15, #-4]
	ldurb	w17, [x14, #-8]
	sturb	w17, [x15, #-3]
	ldurb	w17, [x14, #-6]
	sturb	w17, [x15, #-2]
	ldurb	w17, [x14, #-4]
	sturb	w17, [x15, #-1]
	ldurb	w17, [x14, #-2]
	strb	w17, [x15]
	ldrb	w17, [x14]
	strb	w17, [x15, #1]
	ldrb	w17, [x14, #2]
	strb	w17, [x15, #2]
	ldrb	w17, [x14, #4]
	strb	w17, [x15, #3]
	ldrb	w17, [x14, #6]
	strb	w17, [x15, #4]
	ldrb	w17, [x14, #8]
	strb	w17, [x15, #5]
	ldrb	w17, [x14, #10]
	strb	w17, [x15, #6]
	ldrb	w17, [x14, #12]
	strb	w17, [x15, #7]
	ldrb	w17, [x14, #14]
	add	x14, x14, #64
	strb	w17, [x15, #8]
	add	x15, x15, #32
	b.lo	.LBB2_22
	add	x11, x11, #1
	add	w10, w10, #16
	add	w9, w9, #32
	cmp	x11, x8
	b.ne	.LBB2_21
.LBB2_24:
	cmp	w21, #1
	b.eq	.LBB2_33
	cmp	w21, #7
	b.ne	.LBB2_34
	ldr	x8, [x20, #16]
	cmp	w22, #1
	b.lt	.LBB2_29
	mov	w10, w22
	mov	x9, xzr
	lsl	x10, x10, #10
.LBB2_28:
	add	x11, x8, w9, sxtw
	add	x9, x9, #1024
	cmp	x10, x9
	ldrb	w12, [x11, #960]
	strb	wzr, [x11, #928]
	ldrb	w13, [x11, #30]
	strb	wzr, [x11, #958]
	strb	wzr, [x11, #992]
	strb	wzr, [x11, #1022]
	strb	wzr, [x11, #32]
	strb	w12, [x11]
	strb	w13, [x11, #990]
	strb	wzr, [x11, #62]
	b.ne	.LBB2_28
.LBB2_29:
	lsl	w9, w22, #10
	mov	w11, #1
	sub	w10, w9, #1, lsl #12
	sub	w12, w9, #3072
	sub	w9, w9, #2048
	mov	w13, #2
	add	x10, x8, w10, sxtw
	add	x12, x8, w12, sxtw
	add	x8, x8, w9, sxtw
	strb	w11, [x10, #958]
	strb	w13, [x12, #958]
	strb	w13, [x8, #958]
	b	.LBB2_58
.LBB2_30:
	mov	w0, #-19
	b	.LBB2_65
.LBB2_31:
	mov	w0, #-22
	b	.LBB2_65
.LBB2_32:
	mov	x0, x20
	mov	w2, w22
	bl	rkf_lut_init_wf_table
	b	.LBB2_58
.LBB2_33:
	ldr	x8, [x20, #16]
	mov	w9, #1
	mov	w10, #2
	strb	w9, [x8]
	strb	w9, [x8, #1024]
	strb	w9, [x8, #2048]
	strb	w9, [x8, #958]
	strb	w10, [x8, #1982]
	strb	w10, [x8, #3006]
	b	.LBB2_58
.LBB2_34:
	sub	w8, w21, #5
	cmp	w8, #1
	b.hi	.LBB2_38
	cmp	w22, #1
	b.lt	.LBB2_58
	ldr	x8, [x20, #16]
	mov	w9, w22
	cmp	w22, #1
	b.ne	.LBB2_44
	mov	x10, xzr
	b	.LBB2_56
.LBB2_38:
	sub	w8, w21, #11
	cmp	w8, #1
	b.hi	.LBB2_42
	cmp	w22, #1
	b.lt	.LBB2_58
	ldr	x8, [x20, #16]
	mov	w9, w22
	cmp	w22, #1
	b.ne	.LBB2_67
	mov	x10, xzr
	b	.LBB2_87
.LBB2_42:
	sub	w8, w21, #13
	cmp	w8, #1
	b.hi	.LBB2_58
	ldr	x0, [x20, #16]
	mov	w1, w22
	mov	w2, w23
	bl	rkf_wf_normal_fix
	b	.LBB2_58
.LBB2_44:
	sub	x12, x9, #1
	mov	x10, xzr
	and	x11, x12, #0xffffffff
	lsl	x14, x11, #10
	tst	x14, #0xffffffff00000000
	cset	w13, ne
	cmp	xzr, x12, lsr #54
	cset	w11, ne
	tbnz	w14, #31, .LBB2_56
	tbnz	w13, #0, .LBB2_56
	lsr	x13, x12, #32
	cbnz	x13, .LBB2_56
	add	x13, x8, #30
	lsl	x12, x12, #10
	add	x14, x13, x12
	cmp	x14, x13
	b.lo	.LBB2_56
	tbnz	w11, #0, .LBB2_56
	add	x13, x8, #29
	add	x14, x13, x12
	cmp	x14, x13
	b.lo	.LBB2_56
	tbnz	w11, #0, .LBB2_56
	add	x13, x8, #31
	add	x12, x13, x12
	cmp	x12, x13
	b.lo	.LBB2_56
	tbnz	w11, #0, .LBB2_56
	and	x10, x9, #0xfffffffe
	mov	w11, #1024
	mov	x12, x10
.LBB2_54:
	sub	w13, w11, #1024
	add	x14, x8, w11, sxtw
	subs	x12, x12, #2
	add	w11, w11, #2048
	add	x13, x8, w13, sxtw
	ldrb	w15, [x14, #30]
	ldrb	w16, [x13, #30]
	strb	w15, [x14, #31]
	strb	w15, [x14, #29]
	strb	w16, [x13, #31]
	strb	w16, [x13, #29]
	b.ne	.LBB2_54
	cmp	x10, x9
	b.eq	.LBB2_58
.LBB2_56:
	sub	x9, x9, x10
	lsl	w10, w10, #10
.LBB2_57:
	add	x11, x8, w10, sxtw
	subs	x9, x9, #1
	add	w10, w10, #1024
	ldrb	w12, [x11, #30]
	strb	w12, [x11, #31]
	strb	w12, [x11, #29]
	b.ne	.LBB2_57
.LBB2_58:
	ldrb	w8, [x20, #1]
	mov	w9, #26215
	movk	w9, #26214, lsl #16
	orr	w8, w22, w8, lsl #8
	str	w8, [x20]
	ldrsw	x8, [x24, :lo12:rkf_wf_get_lut.sftemp]
	str	w21, [x26, :lo12:rkf_wf_get_lut.stype]
	mul	x8, x8, x9
	lsr	x9, x8, #63
	asr	x8, x8, #33
	add	w8, w8, w9
.LBB2_59:
	cmp	w25, w8
	b.ne	.LBB2_61
.LBB2_60:
	mov	w0, wzr
	b	.LBB2_65
.LBB2_61:
	ldr	x0, [x20, #8]
	cbz	x0, .LBB2_63
	bl	kfree
	str	xzr, [x20, #8]
.LBB2_63:
	bl	epd_overlay_lut
	mov	w1, w0
	mov	x0, x20
	mov	w2, w19
	bl	parse_wf_data
	tbnz	w0, #31, .LBB2_66
	mov	w21, w0
	ldr	x1, [x20, #24]
	mov	x0, x20
	mov	w2, w21
	bl	rkf_lut_init_wf_table
	ldrb	w8, [x20]
	mov	w0, wzr
	bfi	w8, w21, #8, #24
	str	w8, [x20]
	str	w19, [x24, :lo12:rkf_wf_get_lut.sftemp]
.LBB2_65:
	ldp	x20, x19, [sp, #80]
	ldp	x22, x21, [sp, #64]
	ldp	x24, x23, [sp, #48]
	ldp	x26, x25, [sp, #32]
	ldr	x27, [sp, #16]
	ldp	x29, x30, [sp], #96
	ldr	x30, [x18, #-8]!
	ret
.LBB2_66:
	adrp	x0, .L.str.3
	add	x0, x0, :lo12:.L.str.3
	bl	_printk
	mov	w0, #-5
	b	.LBB2_65
.LBB2_67:
	sub	x12, x9, #1
	mov	x10, xzr
	and	x11, x12, #0xffffffff
	lsl	x14, x11, #10
	tst	x14, #0xffffffff00000000
	cset	w13, ne
	cmp	xzr, x12, lsr #54
	cset	w11, ne
	tbnz	w14, #31, .LBB2_87
	tbnz	w13, #0, .LBB2_87
	lsr	x13, x12, #32
	cbnz	x13, .LBB2_87
	add	x13, x8, #30
	lsl	x12, x12, #10
	add	x14, x13, x12
	cmp	x14, x13
	b.lo	.LBB2_87
	tbnz	w11, #0, .LBB2_87
	add	x13, x8, #1022
	add	x14, x13, x12
	cmp	x14, x13
	b.lo	.LBB2_87
	tbnz	w11, #0, .LBB2_87
	add	x13, x8, #1021
	add	x14, x13, x12
	cmp	x14, x13
	b.lo	.LBB2_87
	tbnz	w11, #0, .LBB2_87
	add	x13, x8, #29
	add	x14, x13, x12
	cmp	x14, x13
	b.lo	.LBB2_87
	tbnz	w11, #0, .LBB2_87
	add	x13, x8, #31
	add	x14, x13, x12
	cmp	x14, x13
	b.lo	.LBB2_87
	tbnz	w11, #0, .LBB2_87
	add	x13, x8, #989
	add	x12, x13, x12
	cmp	x12, x13
	b.lo	.LBB2_87
	tbnz	w11, #0, .LBB2_87
	and	x10, x9, #0xfffffffe
	mov	w11, #1024
	mov	x12, x10
	b	.LBB2_84
.LBB2_83:
	subs	x12, x12, #2
	add	w11, w11, #2048
	b.eq	.LBB2_86
.LBB2_84:
	sub	w14, w11, #1024
	add	x13, x8, w11, sxtw
	add	x14, x8, w14, sxtw
	ldrb	w15, [x13, #30]
	strb	wzr, [x13, #989]
	ldrb	w16, [x14, #30]
	strb	wzr, [x14, #989]
	strb	w15, [x13, #31]
	strb	w15, [x13, #29]
	strb	w16, [x14, #31]
	strb	w16, [x14, #29]
	cbz	w23, .LBB2_83
	add	x14, x14, #1021
	add	x13, x13, #1021
	strh	wzr, [x14]
	strh	wzr, [x13]
	b	.LBB2_83
.LBB2_86:
	cmp	x10, x9
	b.eq	.LBB2_58
.LBB2_87:
	sub	x9, x9, x10
	lsl	w10, w10, #10
	b	.LBB2_89
.LBB2_88:
	subs	x9, x9, #1
	add	w10, w10, #1024
	b.eq	.LBB2_58
.LBB2_89:
	add	x11, x8, w10, sxtw
	ldrb	w12, [x11, #30]
	strb	wzr, [x11, #989]
	strb	w12, [x11, #31]
	strb	w12, [x11, #29]
	cbz	w23, .LBB2_88
	add	x11, x11, #1021
	strh	wzr, [x11]
	b	.LBB2_88
.Lfunc_end2:
	.size	rkf_wf_get_lut, .Lfunc_end2-rkf_wf_get_lut

	.p2align	2
	.type	parse_wf_data,@function
parse_wf_data:
	str	x30, [x18], #8
	stp	x29, x30, [sp, #-64]!
	cmp	w1, #7
	stp	x24, x23, [sp, #16]
	stp	x22, x21, [sp, #32]
	mov	x29, sp
	stp	x20, x19, [sp, #48]
	b.hi	.LBB3_68
	adrp	x9, .LJTI3_0
	mov	w8, w1
	add	x9, x9, :lo12:.LJTI3_0
	mov	x19, x0
	adr	x10, .LBB3_2
	ldrb	w11, [x9, x8]
	add	x10, x10, x11, lsl #2
	br	x10
.LBB3_2:
	adrp	x8, global_waveform
	bic	w10, w2, w2, asr #31
	cmp	w10, #50
	mov	w11, #50
	csel	w10, w10, w11, lo
	mov	x9, xzr
	ldr	x8, [x8, :lo12:global_waveform]
	and	w10, w10, #0xff
	add	x11, x8, #148
.LBB3_3:
	cbz	x9, .LBB3_6
	sub	w12, w9, #1
	ldrb	w13, [x11, x9]
	add	x14, x8, x12
	ldrb	w14, [x14, #148]
	cmp	w13, w14
	b.lo	.LBB3_60
	cmp	w13, w10
	b.ls	.LBB3_7
	b	.LBB3_59
.LBB3_6:
	ldrb	w13, [x8, #148]
	cmp	w13, w10
	b.hi	.LBB3_59
.LBB3_7:
	add	x9, x9, #1
	cmp	x9, #51
	b.ne	.LBB3_3
	mov	x12, xzr
	b	.LBB3_60
.LBB3_9:
	adrp	x8, global_waveform
	bic	w10, w2, w2, asr #31
	cmp	w10, #50
	mov	w11, #50
	csel	w10, w10, w11, lo
	mov	x9, xzr
	ldr	x8, [x8, :lo12:global_waveform]
	and	w10, w10, #0xff
	add	x11, x8, #468
.LBB3_10:
	cbz	x9, .LBB3_13
	sub	w12, w9, #1
	ldrb	w13, [x11, x9]
	add	x14, x8, x12
	ldrb	w14, [x14, #468]
	cmp	w13, w14
	b.lo	.LBB3_70
	cmp	w13, w10
	b.ls	.LBB3_14
	b	.LBB3_69
.LBB3_13:
	ldrb	w13, [x8, #468]
	cmp	w13, w10
	b.hi	.LBB3_69
.LBB3_14:
	add	x9, x9, #1
	cmp	x9, #51
	b.ne	.LBB3_10
	mov	x12, xzr
	b	.LBB3_70
.LBB3_16:
	adrp	x8, global_waveform
	bic	w10, w2, w2, asr #31
	cmp	w10, #50
	mov	w11, #50
	csel	w10, w10, w11, lo
	mov	x9, xzr
	ldr	x8, [x8, :lo12:global_waveform]
	and	w10, w10, #0xff
	add	x11, x8, #212
.LBB3_17:
	cbz	x9, .LBB3_20
	sub	w12, w9, #1
	ldrb	w13, [x11, x9]
	add	x14, x8, x12
	ldrb	w14, [x14, #212]
	cmp	w13, w14
	b.lo	.LBB3_58
	cmp	w13, w10
	b.ls	.LBB3_21
	b	.LBB3_57
.LBB3_20:
	ldrb	w13, [x8, #212]
	cmp	w13, w10
	b.hi	.LBB3_57
.LBB3_21:
	add	x9, x9, #1
	cmp	x9, #51
	b.ne	.LBB3_17
	b	.LBB3_28
.LBB3_22:
	adrp	x8, global_waveform
	bic	w10, w2, w2, asr #31
	cmp	w10, #50
	mov	w11, #50
	csel	w10, w10, w11, lo
	mov	x9, xzr
	ldr	x8, [x8, :lo12:global_waveform]
	and	w10, w10, #0xff
	add	x11, x8, #212
.LBB3_23:
	cbz	x9, .LBB3_26
	sub	w12, w9, #1
	ldrb	w13, [x11, x9]
	add	x14, x8, x12
	ldrb	w14, [x14, #212]
	cmp	w13, w14
	b.lo	.LBB3_58
	cmp	w13, w10
	b.ls	.LBB3_27
	b	.LBB3_57
.LBB3_26:
	ldrb	w13, [x8, #212]
	cmp	w13, w10
	b.hi	.LBB3_57
.LBB3_27:
	add	x9, x9, #1
	cmp	x9, #51
	b.ne	.LBB3_23
.LBB3_28:
	mov	x12, xzr
	b	.LBB3_58
.LBB3_29:
	adrp	x8, global_waveform
	bic	w10, w2, w2, asr #31
	cmp	w10, #50
	mov	w11, #50
	csel	w10, w10, w11, lo
	mov	x9, xzr
	ldr	x8, [x8, :lo12:global_waveform]
	and	w10, w10, #0xff
	add	x11, x8, #276
.LBB3_30:
	cbz	x9, .LBB3_33
	sub	w12, w9, #1
	ldrb	w13, [x11, x9]
	add	x14, x8, x12
	ldrb	w14, [x14, #276]
	cmp	w13, w14
	b.lo	.LBB3_72
	cmp	w13, w10
	b.ls	.LBB3_34
	b	.LBB3_71
.LBB3_33:
	ldrb	w13, [x8, #276]
	cmp	w13, w10
	b.hi	.LBB3_71
.LBB3_34:
	add	x9, x9, #1
	cmp	x9, #51
	b.ne	.LBB3_30
	mov	x12, xzr
	b	.LBB3_72
.LBB3_36:
	adrp	x8, global_waveform
	bic	w10, w2, w2, asr #31
	cmp	w10, #50
	mov	w11, #50
	csel	w10, w10, w11, lo
	mov	x9, xzr
	ldr	x8, [x8, :lo12:global_waveform]
	and	w10, w10, #0xff
	add	x11, x8, #340
.LBB3_37:
	cbz	x9, .LBB3_40
	sub	w12, w9, #1
	ldrb	w13, [x11, x9]
	add	x14, x8, x12
	ldrb	w14, [x14, #340]
	cmp	w13, w14
	b.lo	.LBB3_74
	cmp	w13, w10
	b.ls	.LBB3_41
	b	.LBB3_73
.LBB3_40:
	ldrb	w13, [x8, #340]
	cmp	w13, w10
	b.hi	.LBB3_73
.LBB3_41:
	add	x9, x9, #1
	cmp	x9, #51
	b.ne	.LBB3_37
	mov	x12, xzr
	b	.LBB3_74
.LBB3_43:
	adrp	x8, global_waveform
	bic	w10, w2, w2, asr #31
	cmp	w10, #50
	mov	w11, #50
	csel	w10, w10, w11, lo
	mov	x9, xzr
	ldr	x8, [x8, :lo12:global_waveform]
	and	w10, w10, #0xff
	add	x11, x8, #404
.LBB3_44:
	cbz	x9, .LBB3_47
	sub	w12, w9, #1
	ldrb	w13, [x11, x9]
	add	x14, x8, x12
	ldrb	w14, [x14, #404]
	cmp	w13, w14
	b.lo	.LBB3_76
	cmp	w13, w10
	b.ls	.LBB3_48
	b	.LBB3_75
.LBB3_47:
	ldrb	w13, [x8, #404]
	cmp	w13, w10
	b.hi	.LBB3_75
.LBB3_48:
	add	x9, x9, #1
	cmp	x9, #51
	b.ne	.LBB3_44
	mov	x12, xzr
	b	.LBB3_76
.LBB3_50:
	adrp	x8, global_waveform
	bic	w10, w2, w2, asr #31
	cmp	w10, #50
	mov	w11, #50
	csel	w10, w10, w11, lo
	mov	x9, xzr
	ldr	x8, [x8, :lo12:global_waveform]
	and	w10, w10, #0xff
	add	x11, x8, #532
.LBB3_51:
	cbz	x9, .LBB3_54
	sub	w12, w9, #1
	ldrb	w13, [x11, x9]
	add	x14, x8, x12
	ldrb	w14, [x14, #532]
	cmp	w13, w14
	b.lo	.LBB3_78
	cmp	w13, w10
	b.ls	.LBB3_55
	b	.LBB3_77
.LBB3_54:
	ldrb	w13, [x8, #532]
	cmp	w13, w10
	b.hi	.LBB3_77
.LBB3_55:
	add	x9, x9, #1
	cmp	x9, #51
	b.ne	.LBB3_51
	mov	x12, xzr
	b	.LBB3_78
.LBB3_57:
	sub	w12, w9, #1
.LBB3_58:
	add	x9, x8, x12, lsl #2
	adrp	x10, maxpic
	ldr	w9, [x9, #852]
	b	.LBB3_79
.LBB3_59:
	sub	w12, w9, #1
.LBB3_60:
	add	x9, x8, x12, lsl #2
	mov	w1, #3520
	ldr	w9, [x9, #596]
	add	x24, x8, x9
	ldrb	w20, [x24]
	add	x23, x20, #15
	lsr	x8, x23, #2
	and	x22, x8, #0x7c
	mov	x0, x22
	bl	__kmalloc
	cbz	x0, .LBB3_68
	add	x1, x24, #4
	mov	x2, x22
	mov	x21, x0
	bl	memcpy
	lsl	w8, w23, #6
	mov	w1, #3520
	and	w0, w8, #0x7c00
	bl	__kmalloc
	cbz	x0, .LBB3_83
	cbz	w20, .LBB3_67
	lsr	w11, w23, #4
	mov	w10, #16384
	cmp	w11, #1
	mov	w12, #1365
	mov	w8, wzr
	mov	w9, wzr
	movk	w10, #21, lsl #16
	csinc	w11, w11, wzr, gt
	movk	w12, #5440, lsl #16
	mov	x13, x21
.LBB3_64:
	mov	w15, wzr
	mov	w14, wzr
	ldr	w16, [x13]
.LBB3_65:
	asr	w17, w16, w15
	add	w3, w8, w14
	and	w1, w17, #0x3
	lsl	w17, w17, #30
	add	w4, w3, #3
	add	w14, w14, #16
	mul	w2, w1, w10
	add	w15, w15, #2
	bfi	w17, w1, #12, #2
	cmp	w14, #256
	orr	w17, w17, w2
	add	w2, w3, #1
	madd	w17, w1, w12, w17
	add	w1, w3, #2
	str	w17, [x0, w2, sxtw #2]
	add	w2, w3, #4
	str	w17, [x0, w1, sxtw #2]
	add	w1, w3, #5
	str	w17, [x0, w4, sxtw #2]
	add	w4, w3, #6
	str	w17, [x0, w2, sxtw #2]
	add	w2, w3, #7
	str	w17, [x0, w1, sxtw #2]
	add	w1, w3, #8
	str	w17, [x0, w4, sxtw #2]
	add	w4, w3, #9
	str	w17, [x0, w2, sxtw #2]
	add	w2, w3, #10
	str	w17, [x0, w1, sxtw #2]
	add	w1, w3, #11
	str	w17, [x0, w4, sxtw #2]
	str	w17, [x0, w2, sxtw #2]
	add	w2, w3, #12
	str	w17, [x0, w1, sxtw #2]
	add	w1, w3, #13
	str	w17, [x0, w3, sxtw #2]
	str	w17, [x0, w2, sxtw #2]
	add	w2, w3, #14
	str	w17, [x0, w1, sxtw #2]
	add	w1, w3, #15
	str	w17, [x0, w2, sxtw #2]
	str	w17, [x0, w1, sxtw #2]
	b.ne	.LBB3_65
	add	x13, x13, #4
	add	w9, w9, #1
	add	w8, w8, w14
	cmp	w9, w11
	b.ne	.LBB3_64
.LBB3_67:
	str	x0, [x19, #8]
	mov	x0, x21
	bl	kfree
	b	.LBB3_82
.LBB3_68:
	mov	w20, #-1
	b	.LBB3_82
.LBB3_69:
	sub	w12, w9, #1
.LBB3_70:
	add	x9, x8, x12, lsl #2
	adrp	x10, maxpic
	ldr	w9, [x9, #1876]
	b	.LBB3_79
.LBB3_71:
	sub	w12, w9, #1
.LBB3_72:
	add	x9, x8, x12, lsl #2
	adrp	x10, maxpic
	ldr	w9, [x9, #1108]
	b	.LBB3_79
.LBB3_73:
	sub	w12, w9, #1
.LBB3_74:
	add	x9, x8, x12, lsl #2
	adrp	x10, maxpic
	ldr	w9, [x9, #1364]
	b	.LBB3_79
.LBB3_75:
	sub	w12, w9, #1
.LBB3_76:
	add	x9, x8, x12, lsl #2
	adrp	x10, maxpic
	ldr	w9, [x9, #1620]
	b	.LBB3_79
.LBB3_77:
	sub	w12, w9, #1
.LBB3_78:
	add	x9, x8, x12, lsl #2
	adrp	x10, maxpic
	ldr	w9, [x9, #2132]
.LBB3_79:
	ldrb	w10, [x10, :lo12:maxpic]
	add	x23, x8, x9
	mov	w8, #16
	mov	w9, #32
	mov	w1, #3520
	cmp	w10, #0
	ldrb	w20, [x23]
	csel	w8, w9, w8, ne
	umull	x9, w8, w20
	mul	x8, x9, x8
	lsr	x21, x8, #2
	mov	x0, x21
	bl	__kmalloc
	cbz	x0, .LBB3_81
	add	x1, x23, #4
	mov	x2, x21
	mov	x22, x0
	bl	memcpy
	str	x22, [x19, #8]
	b	.LBB3_82
.LBB3_81:
	mov	w20, #-1
	str	xzr, [x19, #8]
.LBB3_82:
	mov	w0, w20
	ldp	x20, x19, [sp, #48]
	ldp	x22, x21, [sp, #32]
	ldp	x24, x23, [sp, #16]
	ldp	x29, x30, [sp], #64
	ldr	x30, [x18, #-8]!
	ret
.LBB3_83:
	mov	x0, x21
	str	xzr, [x19, #8]
	bl	kfree
	mov	w20, #-1
	b	.LBB3_82
.Lfunc_end3:
	.size	parse_wf_data, .Lfunc_end3-parse_wf_data
	.section	.rodata,"a",@progbits
.LJTI3_0:
	.byte	(.LBB3_2-.LBB3_2)>>2
	.byte	(.LBB3_9-.LBB3_2)>>2
	.byte	(.LBB3_16-.LBB3_2)>>2
	.byte	(.LBB3_22-.LBB3_2)>>2
	.byte	(.LBB3_29-.LBB3_2)>>2
	.byte	(.LBB3_36-.LBB3_2)>>2
	.byte	(.LBB3_43-.LBB3_2)>>2
	.byte	(.LBB3_50-.LBB3_2)>>2

	.text
	.p2align	2
	.type	rkf_lut_init_wf_table,@function
rkf_lut_init_wf_table:
	cmp	w2, #1
	b.lt	.LBB4_5
	mov	w8, wzr
	mov	w9, wzr
	mov	x10, xzr
	mov	w11, w2
	add	x12, x1, #7
.LBB4_2:
	ldr	x15, [x0, #8]
	and	x14, x8, #0x7ffffff
	mov	x13, xzr
	add	x14, x12, x14, lsl #5
	add	x15, x15, w9, sxtw #2
.LBB4_3:
	add	x16, x15, x13
	add	x13, x13, #4
	cmp	x13, #64
	ldrb	w17, [x16]
	and	w17, w17, #0x3
	sturb	w17, [x14, #-7]
	ldrb	w17, [x16]
	ubfx	w17, w17, #2, #2
	sturb	w17, [x14, #-6]
	ldrb	w17, [x16]
	ubfx	w17, w17, #4, #2
	sturb	w17, [x14, #-5]
	ldrb	w17, [x16]
	lsr	w17, w17, #6
	sturb	w17, [x14, #-4]
	ldrb	w17, [x16, #1]
	and	w17, w17, #0x3
	sturb	w17, [x14, #-3]
	ldr	w17, [x16]
	ubfx	w17, w17, #10, #2
	sturb	w17, [x14, #-2]
	ldr	w17, [x16]
	ubfx	w17, w17, #12, #2
	sturb	w17, [x14, #-1]
	ldr	w17, [x16]
	ubfx	w17, w17, #14, #2
	strb	w17, [x14]
	ldrb	w17, [x16, #2]
	and	w17, w17, #0x3
	strb	w17, [x14, #1]
	ldr	w17, [x16]
	ubfx	w17, w17, #18, #2
	strb	w17, [x14, #2]
	ldr	w17, [x16]
	ubfx	w17, w17, #20, #2
	strb	w17, [x14, #3]
	ldr	w17, [x16]
	ubfx	w17, w17, #22, #2
	strb	w17, [x14, #4]
	ldrb	w17, [x16, #3]
	and	w17, w17, #0x3
	strb	w17, [x14, #5]
	ldr	w17, [x16]
	ubfx	w17, w17, #26, #2
	strb	w17, [x14, #6]
	ldr	w17, [x16]
	ubfx	w17, w17, #28, #2
	strb	w17, [x14, #7]
	ldr	w16, [x16]
	lsr	w16, w16, #30
	strb	w16, [x14, #8]
	add	x14, x14, #32
	b.ne	.LBB4_3
	add	x10, x10, #1
	add	w9, w9, #16
	add	w8, w8, #32
	cmp	x10, x11
	b.ne	.LBB4_2
.LBB4_5:
	ret
.Lfunc_end4:
	.size	rkf_lut_init_wf_table, .Lfunc_end4-rkf_lut_init_wf_table

	.p2align	2
	.type	rkf_wf_normal_fix,@function
rkf_wf_normal_fix:
	cmp	w1, #1
	b.lt	.LBB5_5
	mov	w9, w1
	mov	x8, xzr
	lsl	x9, x9, #10
	b	.LBB5_3
.LBB5_2:
	ldrb	w11, [x10, #30]
	add	x8, x8, #1024
	cmp	x9, x8
	strb	wzr, [x10, #958]
	strb	wzr, [x10, #1022]
	strb	w11, [x10, #31]
	strb	w11, [x10, #29]
	strb	w11, [x10, #61]
	b.eq	.LBB5_5
.LBB5_3:
	add	x10, x0, w8, sxtw
	cbz	w2, .LBB5_2
	ldrb	w11, [x10, #990]
	strb	wzr, [x10, #990]
	strb	w11, [x10, #989]
	strb	w11, [x10, #1021]
	strb	w11, [x10, #957]
	b	.LBB5_2
.LBB5_5:
	lsl	w8, w1, #10
	mov	w10, #1
	sub	w9, w8, #1, lsl #12
	sub	w11, w8, #3072
	sub	w8, w8, #2048
	mov	w12, #2
	add	x9, x0, w9, sxtw
	add	x11, x0, w11, sxtw
	add	x8, x0, w8, sxtw
	strb	w10, [x9, #991]
	strb	w10, [x9, #959]
	strb	w10, [x9, #1023]
	strb	w12, [x11, #991]
	strb	w12, [x11, #959]
	strb	w12, [x11, #1023]
	strb	w12, [x8, #991]
	strb	w12, [x8, #959]
	strb	w12, [x8, #1023]
	ret
.Lfunc_end5:
	.size	rkf_wf_normal_fix, .Lfunc_end5-rkf_wf_normal_fix

	.type	global_waveform,@object
	.local	global_waveform
	.comm	global_waveform,8,8
	.type	.L.str,@object
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"rkf: failed to check RKF file version\n"
	.size	.L.str, 39

	.type	.L.str.1,@object
.L.str.1:
	.asciz	"rkf: failed to check RKF file format\n"
	.size	.L.str.1, 38

	.type	.L.str.2,@object
.L.str.2:
	.asciz	"rkf: failed to check crc RKF waveform\n"
	.size	.L.str.2, 39

	.type	rkf_wf_get_lut.stype,@object
	.data
	.p2align	2
rkf_wf_get_lut.stype:
	.word	15
	.size	rkf_wf_get_lut.stype, 4

	.type	rkf_wf_get_lut.sftemp,@object
	.p2align	2
rkf_wf_get_lut.sftemp:
	.word	4294967295
	.size	rkf_wf_get_lut.sftemp, 4

	.type	need_pic,@object
	.p2align	2
need_pic:
	.word	16
	.size	need_pic, 4

	.type	.L.str.3,@object
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str.3:
	.asciz	"rkf waveform get frame number failed\n"
	.size	.L.str.3, 38

	.type	.L.str.4,@object
.L.str.4:
	.asciz	"rkf:v1.0"
	.size	.L.str.4, 9

	.type	maxpic,@object
	.local	maxpic
	.comm	maxpic,1,4
	.type	.L.str.5,@object
.L.str.5:
	.asciz	"rkf:v2.0"
	.size	.L.str.5, 9

	.type	.L.str.6,@object
.L.str.6:
	.asciz	"rkf: input waveform version: %s, gray level: %d\n"
	.size	.L.str.6, 49

	.type	.L.str.7,@object
.L.str.7:
	.asciz	"rkf waveform"
	.size	.L.str.7, 13

	.type	.L.str.8,@object
.L.str.8:
	.asciz	"rkf: check format failed\n"
	.size	.L.str.8, 26

	.type	.L.str.9,@object
.L.str.9:
	.asciz	"[EINK]: waveform crc err readcrc = %x crccheck = %x\n"
	.size	.L.str.9, 53

	.type	crc32_table,@object
	.local	crc32_table
	.comm	crc32_table,1024,4
	.type	.Lswitch.table.rkf_wf_get_lut,@object
	.section	.rodata,"a",@progbits
	.p2align	2
.Lswitch.table.rkf_wf_get_lut:
	.word	3
	.word	3
	.word	3
	.word	5
	.word	6
	.word	4
	.word	3
	.size	.Lswitch.table.rkf_wf_get_lut, 28

	.ident	"Android (8508608, based on r450784e) clang version 14.0.7 (https://android.googlesource.com/toolchain/llvm-project 4c603efb0cca074e9238af8b4106c30add4418f6)"
	.section	".note.GNU-stack","",@progbits
	.addrsig

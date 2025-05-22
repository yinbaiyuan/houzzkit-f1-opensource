// SPDX-License-Identifier: GPL-2.0
/*
 * Copyright (c) 2020-2024 Rockchip Electronics Co., Ltd.
 *
 * Author: Zorro Liu <zorro.liu@rock-chips.com>
 */

	.text
	.file	"ebc_dev_y8.c"

	.section	.initcall6s.init,"a",@progbits
__initcall__kmod_rkebc__465_4243_ebc_init6s:
.Ltmp0:
	.word	ebc_init-.Ltmp0
	.text



	.globl	refresh_new_image
	.p2align	2
	.type	refresh_new_image,@function
refresh_new_image:
	stp	x28, x27, [sp, #-80]!
	ldp	w9, w8, [x5, #80]
	stp	x26, x25, [sp, #16]
	stp	x24, x23, [sp, #32]
	stp	x22, x21, [sp, #48]
	add	w10, w8, #7
	cmp	w8, #0
	csel	w11, w10, w8, lt
	cmp	w9, #1
	stp	x20, x19, [sp, #64]
	b.lt	.LBB0_125
	asr	w11, w11, #3
	mov	w10, wzr
	sub	w14, w11, #1
	mov	w12, #-268435456
	mov	x13, #1030792151040
	add	x14, x14, #1
	mov	x15, #263882790666240
	mov	x16, #67553994410557440
	mov	x17, #-2305843009213693952
	mov	x5, #63050394783186944
	mov	x6, #246290604621824
	mov	x7, #962072674304
	mov	w19, #-536870912
	b	.LBB0_4
.LBB0_2:
	add	x3, x3, x14, lsl #3
.LBB0_3:
	add	w10, w10, #1
	cmp	w10, w9
	b.eq	.LBB0_125
.LBB0_4:
	cmp	w8, #8
	b.lt	.LBB0_3
	mov	w20, w11
	mov	x21, x3
.LBB0_6:
	ldr	x27, [x21], #8
	ldr	x26, [x1], #8
	ldr	x24, [x0]
	ldr	x22, [x2], #8
	cbnz	x27, .LBB0_24
	and	x27, x26, #0xf0
	cmp	w27, #240
	b.ne	.LBB0_26
	mov	x23, xzr
	mov	w25, #255
.LBB0_9:
	and	x27, x26, #0xf000
	cmp	w27, #15, lsl #12
	b.ne	.LBB0_28
	orr	x25, x25, #0xff00
.LBB0_11:
	and	x27, x26, #0xf00000
	cmp	x27, #3840, lsl #12
	b.ne	.LBB0_30
	orr	x25, x25, #0xff0000
.LBB0_13:
	and	x27, x26, #0xf0000000
	cmp	w27, w12
	b.ne	.LBB0_32
	orr	x25, x25, #0xff000000
.LBB0_15:
	and	x27, x26, #0xf000000000
	cmp	x27, x13
	b.ne	.LBB0_34
	orr	x25, x25, #0xff00000000
.LBB0_17:
	and	x27, x26, #0xf00000000000
	cmp	x27, x15
	b.ne	.LBB0_36
	orr	x25, x25, #0xff0000000000
.LBB0_19:
	and	x27, x26, #0xf0000000000000
	cmp	x27, x16
	b.ne	.LBB0_38
	orr	x25, x25, #0xff000000000000
.LBB0_21:
	lsr	x27, x26, #60
	cmp	x27, #15
	b.lo	.LBB0_40
.LBB0_22:
	orr	x25, x25, #0xff00000000000000
.LBB0_23:
	bic	x24, x24, x25
	and	x22, x25, x22
	orr	x22, x24, x22
	subs	w20, w20, #1
	str	x23, [x4], #8
	str	x22, [x0], #8
	b.ne	.LBB0_6
	b	.LBB0_2
.LBB0_24:
	ldr	x23, [x4]
	tst	x27, #0xff
	b.eq	.LBB0_57
	mov	x25, xzr
	b	.LBB0_59
.LBB0_26:
	cbnz	w27, .LBB0_43
	mov	x25, xzr
	and	x24, x24, #0xffffffffffffff00
	mov	w23, #1
	b	.LBB0_9
.LBB0_28:
	and	x24, x24, #0xffffffffffff00ff
	cbnz	w27, .LBB0_45
	orr	x23, x23, #0x100
	b	.LBB0_11
.LBB0_30:
	and	x24, x24, #0xffffffffff00ffff
	cbnz	x27, .LBB0_47
	orr	x23, x23, #0x10000
	b	.LBB0_13
.LBB0_32:
	and	x24, x24, #0xffffffff00ffffff
	cbnz	w27, .LBB0_49
	orr	x23, x23, #0x1000000
	b	.LBB0_15
.LBB0_34:
	and	x24, x24, #0xffffff00ffffffff
	cbnz	x27, .LBB0_51
	orr	x23, x23, #0x100000000
	b	.LBB0_17
.LBB0_36:
	and	x24, x24, #0xffff00ffffffffff
	cbnz	x27, .LBB0_53
	orr	x23, x23, #0x10000000000
	b	.LBB0_19
.LBB0_38:
	and	x24, x24, #0xff00ffffffffffff
	cbnz	x27, .LBB0_55
	orr	x23, x23, #0x1000000000000
	b	.LBB0_21
.LBB0_40:
	and	x26, x26, #0xf000000000000000
	cmp	x26, x17
	b.eq	.LBB0_82
	cbz	x26, .LBB0_81
.LBB0_42:
	and	x24, x24, #0xffffffffffffff
	orr	x24, x24, x26
	b	.LBB0_23
.LBB0_43:
	cmp	w27, #224
	b.ne	.LBB0_83
	and	x23, x24, #0xffffffffffffff00
	mov	x25, xzr
	orr	x24, x23, #0xf0
	mov	w23, #1
	b	.LBB0_9
.LBB0_45:
	cmp	w27, #14, lsl #12
	b.ne	.LBB0_84
	orr	x24, x24, #0xf000
	orr	x23, x23, #0x100
	b	.LBB0_11
.LBB0_47:
	cmp	x27, #3584, lsl #12
	b.ne	.LBB0_85
	orr	x24, x24, #0xf00000
	orr	x23, x23, #0x10000
	b	.LBB0_13
.LBB0_49:
	cmp	w27, w19
	b.ne	.LBB0_86
	orr	x24, x24, #0xf0000000
	orr	x23, x23, #0x1000000
	b	.LBB0_15
.LBB0_51:
	cmp	x27, x7
	b.ne	.LBB0_87
	orr	x24, x24, #0xf000000000
	orr	x23, x23, #0x100000000
	b	.LBB0_17
.LBB0_53:
	cmp	x27, x6
	b.ne	.LBB0_88
	orr	x24, x24, #0xf00000000000
	orr	x23, x23, #0x10000000000
	b	.LBB0_19
.LBB0_55:
	cmp	x27, x5
	b.ne	.LBB0_89
	orr	x24, x24, #0xf0000000000000
	orr	x23, x23, #0x1000000000000
	b	.LBB0_21
.LBB0_57:
	and	x23, x23, #0xffffffffffffff00
	and	x28, x26, #0xf0
	cmp	w28, #240
	b.ne	.LBB0_90
	mov	w25, #255
.LBB0_59:
	tst	x27, #0xff00
	b.eq	.LBB0_66
	tst	x27, #0xff0000
	b.eq	.LBB0_68
.LBB0_61:
	tst	x27, #0xff000000
	b.eq	.LBB0_70
.LBB0_62:
	tst	x27, #0xff00000000
	b.eq	.LBB0_72
.LBB0_63:
	tst	x27, #0xff0000000000
	b.eq	.LBB0_74
.LBB0_64:
	tst	x27, #0xff000000000000
	b.eq	.LBB0_76
.LBB0_65:
	lsr	x27, x27, #56
	cbnz	x27, .LBB0_23
	b	.LBB0_78
.LBB0_66:
	and	x23, x23, #0xffffffffffff00ff
	and	x28, x26, #0xf000
	cmp	w28, #15, lsl #12
	b.ne	.LBB0_92
	orr	x25, x25, #0xff00
	tst	x27, #0xff0000
	b.ne	.LBB0_61
.LBB0_68:
	and	x23, x23, #0xffffffffff00ffff
	and	x28, x26, #0xf00000
	cmp	x28, #3840, lsl #12
	b.ne	.LBB0_96
	orr	x25, x25, #0xff0000
	tst	x27, #0xff000000
	b.ne	.LBB0_62
.LBB0_70:
	and	x23, x23, #0xffffffff00ffffff
	and	x28, x26, #0xf0000000
	cmp	w28, w12
	b.ne	.LBB0_100
	orr	x25, x25, #0xff000000
	tst	x27, #0xff00000000
	b.ne	.LBB0_63
.LBB0_72:
	and	x23, x23, #0xffffff00ffffffff
	and	x28, x26, #0xf000000000
	cmp	x28, x13
	b.ne	.LBB0_104
	orr	x25, x25, #0xff00000000
	tst	x27, #0xff0000000000
	b.ne	.LBB0_64
.LBB0_74:
	and	x23, x23, #0xffff00ffffffffff
	and	x28, x26, #0xf00000000000
	cmp	x28, x15
	b.ne	.LBB0_108
	orr	x25, x25, #0xff0000000000
	tst	x27, #0xff000000000000
	b.ne	.LBB0_65
.LBB0_76:
	and	x23, x23, #0xff00ffffffffffff
	and	x28, x26, #0xf0000000000000
	cmp	x28, x16
	b.ne	.LBB0_112
	orr	x25, x25, #0xff000000000000
	lsr	x27, x27, #56
	cbnz	x27, .LBB0_23
.LBB0_78:
	and	x23, x23, #0xffffffffffffff
	lsr	x27, x26, #60
	cmp	x27, #15
	b.hs	.LBB0_22
	and	x26, x26, #0xf000000000000000
	cmp	x26, x17
	b.eq	.LBB0_82
	cbnz	x26, .LBB0_42
.LBB0_81:
	and	x24, x24, #0xffffffffffffff
	orr	x23, x23, #0x100000000000000
	b	.LBB0_23
.LBB0_82:
	mov	x26, #-1152921504606846976
	orr	x23, x23, #0x100000000000000
	bfxil	x26, x24, #0, #56
	mov	x24, x26
	b	.LBB0_23
.LBB0_83:
	and	x24, x24, #0xffffffffffffff00
	mov	x23, xzr
	mov	x25, xzr
	orr	x24, x24, x27
	b	.LBB0_9
.LBB0_84:
	orr	x24, x24, x27
	b	.LBB0_11
.LBB0_85:
	orr	x24, x24, x27
	b	.LBB0_13
.LBB0_86:
	orr	x24, x24, x27
	b	.LBB0_15
.LBB0_87:
	orr	x24, x24, x27
	b	.LBB0_17
.LBB0_88:
	orr	x24, x24, x27
	b	.LBB0_19
.LBB0_89:
	orr	x24, x24, x27
	b	.LBB0_21
.LBB0_90:
	cbnz	w28, .LBB0_116
	mov	x25, xzr
	and	x24, x24, #0xffffffffffffff00
	orr	x23, x23, #0x1
	b	.LBB0_59
.LBB0_92:
	and	x24, x24, #0xffffffffffff00ff
	cbz	w28, .LBB0_95
	cmp	w28, #14, lsl #12
	b.ne	.LBB0_118
	orr	x24, x24, #0xf000
.LBB0_95:
	orr	x23, x23, #0x100
	tst	x27, #0xff0000
	b.ne	.LBB0_61
	b	.LBB0_68
.LBB0_96:
	and	x24, x24, #0xffffffffff00ffff
	cbz	x28, .LBB0_99
	cmp	x28, #3584, lsl #12
	b.ne	.LBB0_119
	orr	x24, x24, #0xf00000
.LBB0_99:
	orr	x23, x23, #0x10000
	tst	x27, #0xff000000
	b.ne	.LBB0_62
	b	.LBB0_70
.LBB0_100:
	and	x24, x24, #0xffffffff00ffffff
	cbz	w28, .LBB0_103
	cmp	w28, w19
	b.ne	.LBB0_120
	orr	x24, x24, #0xf0000000
.LBB0_103:
	orr	x23, x23, #0x1000000
	tst	x27, #0xff00000000
	b.ne	.LBB0_63
	b	.LBB0_72
.LBB0_104:
	and	x24, x24, #0xffffff00ffffffff
	cbz	x28, .LBB0_107
	cmp	x28, x7
	b.ne	.LBB0_121
	orr	x24, x24, #0xf000000000
.LBB0_107:
	orr	x23, x23, #0x100000000
	tst	x27, #0xff0000000000
	b.ne	.LBB0_64
	b	.LBB0_74
.LBB0_108:
	and	x24, x24, #0xffff00ffffffffff
	cbz	x28, .LBB0_111
	cmp	x28, x6
	b.ne	.LBB0_122
	orr	x24, x24, #0xf00000000000
.LBB0_111:
	orr	x23, x23, #0x10000000000
	tst	x27, #0xff000000000000
	b.ne	.LBB0_65
	b	.LBB0_76
.LBB0_112:
	and	x24, x24, #0xff00ffffffffffff
	cbz	x28, .LBB0_115
	cmp	x28, x5
	b.ne	.LBB0_123
	orr	x24, x24, #0xf0000000000000
.LBB0_115:
	orr	x23, x23, #0x1000000000000
	lsr	x27, x27, #56
	cbnz	x27, .LBB0_23
	b	.LBB0_78
.LBB0_116:
	cmp	w28, #224
	b.ne	.LBB0_124
	and	x24, x24, #0xffffffffffffff00
	mov	x25, xzr
	orr	x24, x24, #0xf0
	orr	x23, x23, #0x1
	b	.LBB0_59
.LBB0_118:
	orr	x24, x24, x28
	tst	x27, #0xff0000
	b.ne	.LBB0_61
	b	.LBB0_68
.LBB0_119:
	orr	x24, x24, x28
	tst	x27, #0xff000000
	b.ne	.LBB0_62
	b	.LBB0_70
.LBB0_120:
	orr	x24, x24, x28
	tst	x27, #0xff00000000
	b.ne	.LBB0_63
	b	.LBB0_72
.LBB0_121:
	orr	x24, x24, x28
	tst	x27, #0xff0000000000
	b.ne	.LBB0_64
	b	.LBB0_74
.LBB0_122:
	orr	x24, x24, x28
	tst	x27, #0xff000000000000
	b.ne	.LBB0_65
	b	.LBB0_76
.LBB0_123:
	orr	x24, x24, x28
	lsr	x27, x27, #56
	cbnz	x27, .LBB0_23
	b	.LBB0_78
.LBB0_124:
	and	x24, x24, #0xffffffffffffff00
	mov	x25, xzr
	orr	x24, x24, x28
	b	.LBB0_59
.LBB0_125:
	ldp	x20, x19, [sp, #64]
	ldp	x22, x21, [sp, #48]
	ldp	x24, x23, [sp, #32]
	ldp	x26, x25, [sp, #16]
	ldp	x28, x27, [sp], #80
	ret
.Lfunc_end0:
	.size	refresh_new_image, .Lfunc_end0-refresh_new_image

	.globl	refresh_new_image_auto
	.p2align	2
	.type	refresh_new_image_auto,@function
refresh_new_image_auto:
	ldp	w9, w8, [x3, #80]
	add	w10, w8, #7
	cmp	w8, #0
	csel	w11, w10, w8, lt
	cmp	w9, #1
	b.lt	.LBB1_8
	mov	w10, wzr
	asr	w11, w11, #3
	mov	w12, #255
	b	.LBB1_3
.LBB1_2:
	add	w10, w10, #1
	cmp	w10, w9
	b.eq	.LBB1_8
.LBB1_3:
	cmp	w8, #8
	b.lt	.LBB1_2
	mov	w13, w11
	b	.LBB1_6
.LBB1_5:
	add	x0, x0, #8
	subs	w13, w13, #1
	b.eq	.LBB1_2
.LBB1_6:
	ldr	x14, [x1], #8
	ldr	x15, [x0]
	ldr	x16, [x2], #8
	cmp	x14, x15
	b.eq	.LBB1_5
	tst	x16, #0xff
	csel	x17, x12, xzr, eq
	tst	x16, #0xff00
	orr	x3, x17, #0xff00
	csel	x17, x3, x17, eq
	tst	x16, #0xff0000
	orr	x3, x17, #0xff0000
	csel	x17, x3, x17, eq
	tst	x16, #0xff000000
	orr	x3, x17, #0xff000000
	csel	x17, x3, x17, eq
	tst	x16, #0xff00000000
	orr	x3, x17, #0xff00000000
	csel	x17, x3, x17, eq
	tst	x16, #0xff0000000000
	orr	x3, x17, #0xff0000000000
	csel	x17, x3, x17, eq
	tst	x16, #0xff000000000000
	orr	x3, x17, #0xff000000000000
	lsr	x16, x16, #56
	csel	x17, x3, x17, eq
	cmp	x16, #0
	orr	x3, x17, #0xff00000000000000
	csel	x16, x3, x17, eq
	bic	x15, x15, x16
	and	x14, x16, x14
	orr	x14, x15, x14
	str	x14, [x0]
	b	.LBB1_5
.LBB1_8:
	ret
.Lfunc_end1:
	.size	refresh_new_image_auto, .Lfunc_end1-refresh_new_image_auto

	.section	.exit.text,"ax",@progbits
	.p2align	2
	.type	ebc_exit,@function
ebc_exit:
	str	x30, [x18], #8
	stp	x29, x30, [sp, #-16]!
	adrp	x0, ebc_driver
	mov	x29, sp
	add	x0, x0, :lo12:ebc_driver
	bl	platform_driver_unregister
	ldp	x29, x30, [sp], #16
	ldr	x30, [x18, #-8]!
	ret
.Lfunc_end2:
	.size	ebc_exit, .Lfunc_end2-ebc_exit

	.section	.init.text,"ax",@progbits
	.p2align	2
	.type	ebc_init,@function
ebc_init:
	str	x30, [x18], #8
	stp	x29, x30, [sp, #-16]!
	adrp	x0, ebc_driver
	mov	x1, xzr
	add	x0, x0, :lo12:ebc_driver
	mov	x29, sp
	bl	__platform_driver_register
	ldp	x29, x30, [sp], #16
	ldr	x30, [x18, #-8]!
	ret
.Lfunc_end3:
	.size	ebc_init, .Lfunc_end3-ebc_init

	.text
	.p2align	2
	.type	ebc_probe,@function
ebc_probe:
	sub	sp, sp, #208
	str	x30, [x18], #8
	stp	x29, x30, [sp, #112]
	adrp	x1, .L.str.1
	stp	x28, x27, [sp, #128]
	add	x29, sp, #112
	stp	x26, x25, [sp, #144]
	add	x1, x1, :lo12:.L.str.1
	stp	x24, x23, [sp, #160]
	stp	x22, x21, [sp, #176]
	stp	x20, x19, [sp, #192]
	mrs	x8, SP_EL0
	add	x19, x0, #16
	mov	x20, x0
	ldr	x8, [x8, #1584]
	mov	x0, x19
	stur	x8, [x29, #-8]
	str	xzr, [sp, #16]
	str	wzr, [sp, #12]
	str	xzr, [sp]
	bl	nvmem_cell_get
	cmn	x0, #1, lsl #12
	b.hi	.LBB4_8
	mov	x1, sp
	mov	x22, x0
	bl	nvmem_cell_read
	mov	x21, x0
	mov	x0, x22
	bl	nvmem_cell_put
	cmn	x21, #4095
	b.hs	.LBB4_9
	ldr	x8, [sp]
	cmp	x8, #2
	b.ne	.LBB4_7
	ldrb	w8, [x21]
	cmp	w8, #53
	b.ne	.LBB4_7
	ldrb	w8, [x21, #1]
	cmp	w8, #102
	b.eq	.LBB4_11
	cmp	w8, #118
	b.ne	.LBB4_7
	mov	w25, #3576
	b	.LBB4_12
.LBB4_7:
	mov	x0, x21
	bl	kfree
.LBB4_8:
	mov	w21, #-12
.LBB4_9:
	mrs	x8, SP_EL0
	ldr	x8, [x8, #1584]
	ldur	x9, [x29, #-8]
	cmp	x8, x9
	b.ne	.LBB4_53
	mov	w0, w21
	ldp	x20, x19, [sp, #192]
	ldp	x22, x21, [sp, #176]
	ldp	x24, x23, [sp, #160]
	ldp	x26, x25, [sp, #144]
	ldp	x28, x27, [sp, #128]
	ldp	x29, x30, [sp, #112]
	ldr	x30, [x18, #-8]!
	add	sp, sp, #208
	ret
.LBB4_11:
	mov	w25, #3566
.LBB4_12:
	mov	x0, x21
	bl	kfree
	mov	x0, x19
	mov	w1, #864
	mov	w2, #3520
	bl	devm_kmalloc
	cbz	x0, .LBB4_8
	adrp	x8, global_ebc
	adrp	x1, .L.str.2
	mov	x21, x0
	str	x19, [x0]
	add	x1, x1, :lo12:.L.str.2
	add	x5, sp, #24
	str	x0, [x8, :lo12:global_ebc]
	ldr	x0, [x20, #672]
	mov	x2, xzr
	mov	w3, wzr
	mov	w4, wzr
	stp	xzr, xzr, [sp, #88]
	stp	xzr, xzr, [sp, #72]
	stp	xzr, xzr, [sp, #56]
	stp	xzr, xzr, [sp, #40]
	stp	xzr, xzr, [sp, #24]
	bl	__of_parse_phandle_with_args
	cbnz	w0, .LBB4_18
	ldr	x0, [sp, #24]
	cbz	x0, .LBB4_18
	bl	of_find_device_by_node
	cbz	x0, .LBB4_17
	ldr	x8, [x0, #136]
	str	x8, [x21, #8]
	cbnz	x8, .LBB4_20
.LBB4_17:
	mov	w21, #-517
	b	.LBB4_9
.LBB4_18:
	adrp	x1, .L.str.3
	add	x1, x1, :lo12:.L.str.3
.LBB4_19:
	mov	x0, x19
	bl	_dev_err
	mov	w21, #-19
	b	.LBB4_9
.LBB4_20:
	adrp	x9, frame_done_callback
	adrp	x1, .L.str.4
	add	x9, x9, :lo12:frame_done_callback
	add	x1, x1, :lo12:.L.str.4
	add	x2, sp, #12
	str	x9, [x8, #136]
	ldr	x0, [x20, #672]
	bl	of_get_property
	ldr	w8, [sp, #12]
	asr	w9, w8, #2
	cmp	w8, #3
	str	w9, [sp, #12]
	b.hi	.LBB4_22
	adrp	x1, .L.str.5
	mov	x0, x19
	add	x1, x1, :lo12:.L.str.5
	bl	_dev_err
	mov	w21, #-22
	b	.LBB4_9
.LBB4_22:
	cmp	w8, #4
	b.lt	.LBB4_47
	adrp	x24, .L.str.9
	adrp	x26, .L.str.11
	mov	x22, x0
	mov	w23, wzr
	mov	w27, wzr
	add	x24, x24, :lo12:.L.str.9
	add	x26, x26, :lo12:.L.str.11
	b	.LBB4_25
.LBB4_24:
	ldr	w8, [sp, #12]
	add	w23, w23, #1
	mov	w27, #1
	cmp	w23, w8
	b.ge	.LBB4_40
.LBB4_25:
	add	x22, x22, #4
.LBB4_26:
	ldur	w8, [x22, #-4]
	rev	w0, w8
	bl	of_find_node_by_phandle
	cbz	x0, .LBB4_36
	bl	of_find_i2c_device_by_node
	cbz	x0, .LBB4_37
	ldr	x8, [x0, #152]
	str	x8, [x21, #16]
	cbnz	x8, .LBB4_38
	add	x28, x0, #32
	mov	x1, x24
	mov	x0, x28
	bl	devm_regulator_get
	cmn	x0, #4095
	str	x0, [x21, #24]
	b.hs	.LBB4_34
	add	x2, sp, #16
	mov	x0, x28
	mov	x1, x26
	bl	device_property_read_string
	cbnz	w0, .LBB4_35
	ldr	x0, [sp, #16]
	bl	thermal_zone_get_zone_by_name
	cmn	x0, #4095
	str	x0, [x21, #32]
	b.lo	.LBB4_24
	adrp	x1, .L.str.13
	mov	x0, x19
	add	x1, x1, :lo12:.L.str.13
	bl	_dev_err
.LBB4_33:
	ldr	w8, [sp, #12]
	add	w23, w23, #1
	add	x22, x22, #4
	cmp	w23, w8
	b.lt	.LBB4_26
	b	.LBB4_39
.LBB4_34:
	adrp	x1, .L.str.10
	mov	x0, x19
	add	x1, x1, :lo12:.L.str.10
	bl	_dev_warn
	b	.LBB4_33
.LBB4_35:
	adrp	x1, .L.str.12
	mov	x0, x19
	add	x1, x1, :lo12:.L.str.12
	bl	_dev_warn
	b	.LBB4_33
.LBB4_36:
	adrp	x1, .L.str.6
	add	x1, x1, :lo12:.L.str.6
	b	.LBB4_19
.LBB4_37:
	adrp	x1, .L.str.7
	add	x1, x1, :lo12:.L.str.7
	b	.LBB4_19
.LBB4_38:
	adrp	x1, .L.str.8
	mov	x0, x19
	add	x1, x1, :lo12:.L.str.8
	mov	w2, w23
	bl	_dev_info
	b	.LBB4_40
.LBB4_39:
	tbz	w27, #0, .LBB4_47
.LBB4_40:
	mov	x22, x21
	adrp	x1, .L.str.15
	add	x1, x1, :lo12:.L.str.15
	mov	x0, x19
	str	x19, [x22, #40]!
	ldp	x8, x9, [x22, #-32]
	str	x19, [x22, #272]
	str	w25, [x22, #816]
	stp	x8, x9, [x22, #8]
	bl	device_property_present
	tbz	w0, #0, .LBB4_42
	mov	w8, #1
	str	w8, [x21, #788]
.LBB4_42:
	mov	x0, x22
	bl	ebc_panel_probe
	cbnz	w0, .LBB4_48
	ldp	w9, w8, [x21, #116]
	mov	w11, #1
	mov	x0, x21
	mul	w10, w9, w8
	str	w8, [x21, #296]
	str	w9, [x21, #300]
	lsr	w8, w10, #2
	str	w9, [x21, #840]
	str	w11, [x21, #848]
	stp	w10, w8, [x21, #244]
	bl	ebc_buffer_manage_init
	cbnz	w0, .LBB4_49
	add	x23, x22, #176
	mov	x0, x23
	bl	ebc_lut_table_init
	cbnz	w0, .LBB4_50
	adrp	x8, nr_cpu_ids
	adrp	x0, __cpu_possible_mask
	add	x0, x0, :lo12:__cpu_possible_mask
	ldr	w1, [x8, :lo12:nr_cpu_ids]
	bl	__bitmap_weight
	str	w0, [x21, #784]
	mov	x0, x23
	bl	ebc_task_init
	cbnz	w0, .LBB4_51
	mov	x0, x23
	bl	ebc_other_init
	mov	x0, x21
	mov	x1, x22
	bl	ebc_logo_init
	mov	x0, x23
	str	x21, [x20, #136]
	bl	ebc_sysfs_init
	adrp	x1, .L.str.20
	adrp	x2, .L.str.21
	ldr	x0, [x21, #312]
	add	x1, x1, :lo12:.L.str.20
	add	x2, x2, :lo12:.L.str.21
	bl	_dev_info
	mov	w21, wzr
	b	.LBB4_9
.LBB4_47:
	adrp	x1, .L.str.14
	mov	x0, x19
	add	x1, x1, :lo12:.L.str.14
	bl	_dev_err
	mov	w21, #-517
	b	.LBB4_9
.LBB4_48:
	mov	x8, x0
	adrp	x1, .L.str.16
	mov	x21, x8
	add	x1, x1, :lo12:.L.str.16
	mov	x0, x19
	mov	w2, w21
	bl	_dev_err
	b	.LBB4_9
.LBB4_49:
	adrp	x1, .L.str.17
	mov	x23, x0
	add	x1, x1, :lo12:.L.str.17
	mov	x0, x19
	bl	_dev_err
	mov	x21, x23
	b	.LBB4_9
.LBB4_50:
	adrp	x1, .L.str.18
	mov	x24, x0
	add	x1, x1, :lo12:.L.str.18
	b	.LBB4_52
.LBB4_51:
	adrp	x1, .L.str.19
	mov	x24, x0
	add	x1, x1, :lo12:.L.str.19
.LBB4_52:
	mov	x0, x19
	bl	_dev_err
	mov	x21, x24
	b	.LBB4_9
.LBB4_53:
	bl	__stack_chk_fail
.Lfunc_end4:
	.size	ebc_probe, .Lfunc_end4-ebc_probe

	.p2align	2
	.type	ebc_remove,@function
ebc_remove:
	str	x30, [x18], #8
	stp	x29, x30, [sp, #-32]!
	str	x19, [sp, #16]
	ldr	x19, [x0, #136]
	mov	x29, sp
	ldr	x0, [x19, #800]
	cbz	x0, .LBB5_2
	bl	dma_buf_put
	str	xzr, [x19, #800]
.LBB5_2:
	ldr	x0, [x19, #808]
	cbz	x0, .LBB5_4
	bl	dma_buf_put
	str	xzr, [x19, #808]
.LBB5_4:
	ldr	x0, [x19, #816]
	cbz	x0, .LBB5_6
	bl	dma_buf_put
	str	xzr, [x19, #816]
.LBB5_6:
	ldr	x0, [x19, #824]
	cbz	x0, .LBB5_8
	bl	dma_buf_put
	str	xzr, [x19, #824]
.LBB5_8:
	ldr	x0, [x19, #832]
	cbz	x0, .LBB5_10
	bl	dma_buf_put
	str	xzr, [x19, #832]
.LBB5_10:
	adrp	x0, ebc_misc
	add	x0, x0, :lo12:ebc_misc
	bl	misc_deregister
	ldr	x19, [sp, #16]
	mov	w0, wzr
	ldp	x29, x30, [sp], #32
	ldr	x30, [x18, #-8]!
	ret
.Lfunc_end5:
	.size	ebc_remove, .Lfunc_end5-ebc_remove

	.p2align	2
	.type	frame_done_callback,@function
frame_done_callback:
	str	x30, [x18], #8
	stp	x29, x30, [sp, #-32]!
	stp	x20, x19, [sp, #16]
	adrp	x20, global_ebc
	mov	x29, sp
	ldr	x19, [x20, :lo12:global_ebc]
	ldr	w8, [x19, #456]
	cmp	w8, #1
	b.eq	.LBB6_8
	cmp	w8, #3
	b.eq	.LBB6_10
	cmp	w8, #4
	b.ne	.LBB6_14
	mov	w8, #1
	ldr	w9, [x19, #276]
	str	w8, [x19, #292]
	cbnz	w9, .LBB6_21
	ldr	w8, [x19, #280]
	cbnz	w8, .LBB6_21
	ldr	w8, [x19, #284]
	cbz	w8, .LBB6_21
	ldr	w9, [x19, #792]
	mov	x8, x19
	cmp	w9, #1
	b.ge	.LBB6_34
.LBB6_7:
	ldr	x0, [x8, #8]
	mov	w1, wzr
	mov	w2, wzr
	ldr	x8, [x0, #144]
	blr	x8
	ldr	w8, [x19, #300]
	mov	w1, wzr
	ldr	w9, [x19, #296]
	ldr	x0, [x19, #376]
	mul	w8, w9, w8
	sxtw	x2, w8
	bl	memset
	ldr	w8, [x19, #300]
	ldr	w9, [x19, #296]
	ldr	x0, [x19, #384]
	b	.LBB6_31
.LBB6_8:
	ldr	w10, [x19, #288]
	str	w8, [x19, #292]
	ldr	w9, [x19, #308]
	cbz	w10, .LBB6_16
	cbnz	w9, .LBB6_17
	b	.LBB6_15
.LBB6_10:
	ldr	w8, [x19, #308]
	cbz	w8, .LBB6_19
	ldr	w9, [x19, #792]
	mov	x8, x19
	cmp	w9, #1
	b.ge	.LBB6_32
.LBB6_12:
	ldr	x0, [x8, #8]
	mov	w1, wzr
	mov	w2, wzr
	ldr	x8, [x0, #144]
	blr	x8
.LBB6_13:
	adrp	x8, jiffies
	mov	w9, #335544320
	add	x0, x19, #704
	ldr	x8, [x8, :lo12:jiffies]
	add	x1, x8, x9
	bl	mod_timer
	str	wzr, [x19, #268]
	b	.LBB6_25
.LBB6_14:
	ldr	w8, [x19, #288]
	cbz	w8, .LBB6_22
.LBB6_15:
	adrp	x8, ebc_auto_task
	mov	w9, #1
	ldr	x0, [x8, :lo12:ebc_auto_task]
	str	w9, [x19, #268]
	bl	wake_up_process
	b	.LBB6_26
.LBB6_16:
	mov	x8, x19
	cbz	w9, .LBB6_18
.LBB6_17:
	ldr	w9, [x19, #792]
	mov	x8, x19
	cmp	w9, #1
	b.ge	.LBB6_33
.LBB6_18:
	ldr	x0, [x8, #8]
	b	.LBB6_24
.LBB6_19:
	ldr	w8, [x19, #276]
	cbnz	w8, .LBB6_21
	ldr	w8, [x19, #280]
	cbz	w8, .LBB6_28
.LBB6_21:
	adrp	x8, ebc_auto_task
	ldr	x0, [x8, :lo12:ebc_auto_task]
	bl	wake_up_process
	b	.LBB6_26
.LBB6_22:
	ldr	w8, [x19, #848]
	cbz	w8, .LBB6_15
	ldr	x0, [x19, #8]
.LBB6_24:
	ldr	x8, [x0, #144]
	mov	w1, wzr
	mov	w2, wzr
	blr	x8
	ldr	w8, [x19, #792]
	str	wzr, [x19, #268]
	cmp	w8, #1
	b.ge	.LBB6_27
.LBB6_25:
	adrp	x0, ebc_thread_wq
	mov	w1, #1
	add	x0, x0, :lo12:ebc_thread_wq
	bl	__wake_up_sync
.LBB6_26:
	ldp	x20, x19, [sp, #16]
	ldp	x29, x30, [sp], #32
	ldr	x30, [x18, #-8]!
	ret
.LBB6_27:
	adrp	x1, .L.str.26
	ldr	x0, [x19, #312]
	add	x1, x1, :lo12:.L.str.26
	bl	_dev_info
	b	.LBB6_25
.LBB6_28:
	ldr	w8, [x19, #284]
	cbz	w8, .LBB6_21
	ldr	w9, [x19, #792]
	mov	x8, x19
	cmp	w9, #1
	b.ge	.LBB6_35
.LBB6_30:
	ldr	x0, [x8, #8]
	mov	w1, wzr
	mov	w2, wzr
	ldr	x8, [x0, #144]
	blr	x8
	ldr	w8, [x19, #300]
	ldr	w9, [x19, #296]
	ldr	x0, [x19, #376]
.LBB6_31:
	mul	w8, w9, w8
	sxtw	x2, w8
	mov	w1, wzr
	bl	memset
	b	.LBB6_13
.LBB6_32:
	adrp	x1, .L.str.23
	ldr	x0, [x19, #312]
	add	x1, x1, :lo12:.L.str.23
	bl	_dev_info
	ldr	x8, [x20, :lo12:global_ebc]
	b	.LBB6_12
.LBB6_33:
	adrp	x1, .L.str.25
	ldr	x0, [x19, #312]
	add	x1, x1, :lo12:.L.str.25
	bl	_dev_info
	ldr	x8, [x20, :lo12:global_ebc]
	b	.LBB6_18
.LBB6_34:
	adrp	x1, .L.str.22
	ldr	x0, [x19, #312]
	add	x1, x1, :lo12:.L.str.22
	bl	_dev_info
	ldr	x8, [x20, :lo12:global_ebc]
	b	.LBB6_7
.LBB6_35:
	adrp	x1, .L.str.24
	ldr	x0, [x19, #312]
	add	x1, x1, :lo12:.L.str.24
	bl	_dev_info
	ldr	x8, [x20, :lo12:global_ebc]
	b	.LBB6_30
.Lfunc_end6:
	.size	frame_done_callback, .Lfunc_end6-frame_done_callback

	.p2align	2
	.type	ebc_panel_probe,@function
ebc_panel_probe:
	str	x30, [x18], #8
	stp	x29, x30, [sp, #-48]!
	mov	x2, x0
	stp	x20, x19, [sp, #32]
	adrp	x1, .L.str.27
	mov	x19, x0
	add	x1, x1, :lo12:.L.str.27
	mov	w3, #1
	ldr	x20, [x2], #76
	mov	x4, xzr
	str	x21, [sp, #16]
	mov	x29, sp
	ldr	x0, [x20, #656]
	bl	of_property_read_variable_u32_array
	tbnz	w0, #31, .LBB7_33
	add	x21, x20, #656
	adrp	x1, .L.str.28
	add	x2, x19, #80
	add	x1, x1, :lo12:.L.str.28
	mov	w3, #1
	mov	x4, xzr
	ldr	x0, [x21]
	bl	of_property_read_variable_u32_array
	tbnz	w0, #31, .LBB7_33
	adrp	x1, .L.str.29
	ldr	x0, [x21]
	add	x2, x19, #84
	add	x1, x1, :lo12:.L.str.29
	mov	w3, #1
	mov	x4, xzr
	bl	of_property_read_variable_u32_array
	tbnz	w0, #31, .LBB7_33
	adrp	x1, .L.str.30
	ldr	x0, [x21]
	add	x2, x19, #88
	add	x1, x1, :lo12:.L.str.30
	mov	w3, #1
	mov	x4, xzr
	bl	of_property_read_variable_u32_array
	tbnz	w0, #31, .LBB7_33
	adrp	x1, .L.str.31
	ldr	x0, [x21]
	add	x2, x19, #104
	add	x1, x1, :lo12:.L.str.31
	mov	w3, #1
	mov	x4, xzr
	bl	of_property_read_variable_u32_array
	tbnz	w0, #31, .LBB7_33
	adrp	x1, .L.str.32
	ldr	x0, [x21]
	add	x2, x19, #108
	add	x1, x1, :lo12:.L.str.32
	mov	w3, #1
	mov	x4, xzr
	bl	of_property_read_variable_u32_array
	tbnz	w0, #31, .LBB7_33
	adrp	x1, .L.str.33
	ldr	x0, [x21]
	add	x2, x19, #112
	add	x1, x1, :lo12:.L.str.33
	mov	w3, #1
	mov	x4, xzr
	bl	of_property_read_variable_u32_array
	tbnz	w0, #31, .LBB7_33
	adrp	x1, .L.str.34
	ldr	x0, [x21]
	add	x2, x19, #116
	add	x1, x1, :lo12:.L.str.34
	mov	w3, #1
	mov	x4, xzr
	bl	of_property_read_variable_u32_array
	tbnz	w0, #31, .LBB7_33
	adrp	x1, .L.str.35
	ldr	x0, [x21]
	add	x2, x19, #120
	add	x1, x1, :lo12:.L.str.35
	mov	w3, #1
	mov	x4, xzr
	bl	of_property_read_variable_u32_array
	tbnz	w0, #31, .LBB7_33
	adrp	x1, .L.str.36
	ldr	x0, [x21]
	add	x2, x19, #124
	add	x1, x1, :lo12:.L.str.36
	mov	w3, #1
	mov	x4, xzr
	bl	of_property_read_variable_u32_array
	tbnz	w0, #31, .LBB7_33
	adrp	x1, .L.str.37
	ldr	x0, [x21]
	add	x2, x19, #128
	add	x1, x1, :lo12:.L.str.37
	mov	w3, #1
	mov	x4, xzr
	bl	of_property_read_variable_u32_array
	tbnz	w0, #31, .LBB7_33
	adrp	x1, .L.str.38
	ldr	x0, [x21]
	add	x2, x19, #132
	add	x1, x1, :lo12:.L.str.38
	mov	w3, #1
	mov	x4, xzr
	bl	of_property_read_variable_u32_array
	tbnz	w0, #31, .LBB7_33
	adrp	x1, .L.str.39
	ldr	x0, [x21]
	add	x2, x19, #136
	add	x1, x1, :lo12:.L.str.39
	mov	w3, #1
	mov	x4, xzr
	bl	of_property_read_variable_u32_array
	tbnz	w0, #31, .LBB7_33
	adrp	x1, .L.str.40
	ldr	x0, [x21]
	add	x2, x19, #140
	add	x1, x1, :lo12:.L.str.40
	mov	w3, #1
	mov	x4, xzr
	bl	of_property_read_variable_u32_array
	tbnz	w0, #31, .LBB7_33
	adrp	x1, .L.str.41
	ldr	x0, [x21]
	add	x2, x19, #144
	add	x1, x1, :lo12:.L.str.41
	mov	w3, #1
	mov	x4, xzr
	bl	of_property_read_variable_u32_array
	tbnz	w0, #31, .LBB7_33
	add	x20, x19, #148
	adrp	x1, .L.str.42
	ldr	x0, [x21]
	add	x1, x1, :lo12:.L.str.42
	mov	x2, x20
	mov	w3, #1
	mov	x4, xzr
	bl	of_property_read_variable_u32_array
	tbz	w0, #31, .LBB7_17
	str	wzr, [x20]
.LBB7_17:
	add	x20, x19, #152
	adrp	x1, .L.str.43
	ldr	x0, [x21]
	add	x1, x1, :lo12:.L.str.43
	mov	x2, x20
	mov	w3, #1
	mov	x4, xzr
	bl	of_property_read_variable_u32_array
	tbz	w0, #31, .LBB7_19
	str	wzr, [x20]
.LBB7_19:
	add	x20, x19, #156
	adrp	x1, .L.str.44
	ldr	x0, [x21]
	add	x1, x1, :lo12:.L.str.44
	mov	x2, x20
	mov	w3, #1
	mov	x4, xzr
	bl	of_property_read_variable_u32_array
	tbz	w0, #31, .LBB7_21
	str	wzr, [x20]
.LBB7_21:
	add	x20, x19, #92
	adrp	x1, .L.str.45
	ldr	x0, [x21]
	add	x1, x1, :lo12:.L.str.45
	mov	x2, x20
	mov	w3, #1
	mov	x4, xzr
	bl	of_property_read_variable_u32_array
	tbz	w0, #31, .LBB7_23
	str	wzr, [x20]
.LBB7_23:
	add	x20, x19, #96
	adrp	x1, .L.str.46
	ldr	x0, [x21]
	add	x1, x1, :lo12:.L.str.46
	mov	x2, x20
	mov	w3, #1
	mov	x4, xzr
	bl	of_property_read_variable_u32_array
	tbz	w0, #31, .LBB7_25
	str	wzr, [x20]
.LBB7_25:
	add	x20, x19, #160
	adrp	x1, .L.str.47
	ldr	x0, [x21]
	add	x1, x1, :lo12:.L.str.47
	mov	x2, x20
	mov	w3, #1
	mov	x4, xzr
	bl	of_property_read_variable_u32_array
	tbz	w0, #31, .LBB7_27
	str	wzr, [x20]
.LBB7_27:
	add	x20, x19, #164
	adrp	x1, .L.str.48
	ldr	x0, [x21]
	add	x1, x1, :lo12:.L.str.48
	mov	x2, x20
	mov	w3, #1
	mov	x4, xzr
	bl	of_property_read_variable_u32_array
	tbz	w0, #31, .LBB7_29
	str	wzr, [x20]
.LBB7_29:
	add	x20, x19, #168
	adrp	x1, .L.str.49
	ldr	x0, [x21]
	add	x1, x1, :lo12:.L.str.49
	mov	x2, x20
	mov	w3, #1
	mov	x4, xzr
	bl	of_property_read_variable_u32_array
	tbz	w0, #31, .LBB7_31
	str	wzr, [x20]
.LBB7_31:
	add	x19, x19, #172
	adrp	x1, .L.str.50
	ldr	x0, [x21]
	add	x1, x1, :lo12:.L.str.50
	mov	x2, x19
	mov	w3, #1
	mov	x4, xzr
	bl	of_property_read_variable_u32_array
	tbnz	w0, #31, .LBB7_35
	mov	w0, wzr
	b	.LBB7_34
.LBB7_33:
	mov	w0, #-22
.LBB7_34:
	ldp	x20, x19, [sp, #32]
	ldr	x21, [sp, #16]
	ldp	x29, x30, [sp], #48
	ldr	x30, [x18, #-8]!
	ret
.LBB7_35:
	mov	w0, wzr
	str	wzr, [x19]
	b	.LBB7_34
.Lfunc_end7:
	.size	ebc_panel_probe, .Lfunc_end7-ebc_panel_probe

	.p2align	2
	.type	ebc_buffer_manage_init,@function
ebc_buffer_manage_init:
	sub	sp, sp, #208
	str	x30, [x18], #8
	stp	x29, x30, [sp, #160]
	add	x29, sp, #160
	str	x21, [sp, #176]
	stp	x20, x19, [sp, #192]
	mrs	x8, SP_EL0
	ldr	x8, [x8, #1584]
	stur	x8, [x29, #-8]
	ldr	w8, [x0, #244]
	stp	xzr, xzr, [sp, #56]
	ldr	x20, [x0]
	stp	xzr, xzr, [sp, #40]
	stp	xzr, xzr, [sp, #24]
	cmp	w8, #1280, lsl #12
	stp	xzr, xzr, [sp, #8]
	b.gt	.LBB8_23
	adrp	x1, .L.str.52
	mov	x19, x0
	ldr	x0, [x20, #656]
	add	x1, x1, :lo12:.L.str.52
	add	x5, sp, #72
	mov	x2, xzr
	mov	w3, wzr
	mov	w4, wzr
	stp	xzr, xzr, [sp, #136]
	stp	xzr, xzr, [sp, #120]
	stp	xzr, xzr, [sp, #104]
	stp	xzr, xzr, [sp, #88]
	stp	xzr, xzr, [sp, #72]
	bl	__of_parse_phandle_with_args
	mov	w21, #-19
	cbnz	w0, .LBB8_26
	ldr	x0, [sp, #72]
	cbz	x0, .LBB8_26
	add	x2, sp, #8
	mov	w1, wzr
	bl	of_address_to_resource
	cbnz	w0, .LBB8_24
	ldp	x1, x8, [sp, #8]
	mov	w9, #58720255
	str	x1, [x19, #216]
	sub	x8, x8, x1
	add	x8, x8, #1
	cmp	w8, w9
	str	w8, [x19, #240]
	b.le	.LBB8_25
	sxtw	x2, w8
	mov	x0, x20
	mov	w3, #1
	bl	devm_memremap
	str	x0, [x19, #224]
	cbz	x0, .LBB8_28
	mov	x1, x0
	ldr	x0, [x19, #216]
	ldr	w2, [x19, #240]
	mov	w3, #5242880
	mov	w4, #4
	bl	ebc_buf_init
	cbz	w0, .LBB8_8
.LBB8_7:
	mov	w21, #-12
	b	.LBB8_26
.LBB8_8:
	ldr	x0, [x19, #216]
	mov	w1, #5242880
	str	xzr, [x19, #832]
	str	xzr, [x19, #824]
	str	xzr, [x19, #816]
	str	xzr, [x19, #808]
	str	xzr, [x19, #800]
	bl	ebc_get_dma_buf
	cmn	x0, #4095
	b.hs	.LBB8_13
	ldr	x8, [x19, #216]
	str	x0, [x19, #800]
	mov	w1, #5242880
	add	x8, x8, #1280, lsl #12
	mov	x0, x8
	bl	ebc_get_dma_buf
	cmn	x0, #1, lsl #12
	b.hi	.LBB8_13
	ldr	x8, [x19, #216]
	str	x0, [x19, #808]
	mov	w1, #5242880
	add	x8, x8, #2560, lsl #12
	mov	x0, x8
	bl	ebc_get_dma_buf
	cmn	x0, #1, lsl #12
	b.hi	.LBB8_13
	ldr	x8, [x19, #216]
	str	x0, [x19, #816]
	mov	w1, #5242880
	add	x8, x8, #3840, lsl #12
	mov	x0, x8
	bl	ebc_get_dma_buf
	cmn	x0, #1, lsl #12
	b.hi	.LBB8_13
	ldr	x8, [x19, #216]
	mov	w9, #20971520
	str	x0, [x19, #824]
	mov	w1, #5242880
	add	x8, x8, x9
	mov	x0, x8
	bl	ebc_get_dma_buf
	cmn	x0, #1, lsl #12
	b.ls	.LBB8_29
.LBB8_13:
	ldr	x0, [x19, #800]
	cbz	x0, .LBB8_15
	bl	dma_buf_put
	str	xzr, [x19, #800]
.LBB8_15:
	ldr	x0, [x19, #808]
	cbz	x0, .LBB8_17
	bl	dma_buf_put
	str	xzr, [x19, #808]
.LBB8_17:
	ldr	x0, [x19, #816]
	cbz	x0, .LBB8_19
	bl	dma_buf_put
	str	xzr, [x19, #816]
.LBB8_19:
	ldr	x0, [x19, #824]
	cbz	x0, .LBB8_21
	bl	dma_buf_put
	str	xzr, [x19, #824]
.LBB8_21:
	ldr	x0, [x19, #832]
	cbz	x0, .LBB8_7
	bl	dma_buf_put
	mov	w21, #-12
	str	xzr, [x19, #832]
	b	.LBB8_26
.LBB8_23:
	adrp	x1, .L.str.51
	mov	x0, x20
	add	x1, x1, :lo12:.L.str.51
	bl	_dev_err
	mov	w21, #-19
	b	.LBB8_26
.LBB8_24:
	adrp	x1, .L.str.53
	mov	w21, w0
	add	x1, x1, :lo12:.L.str.53
	mov	x0, x20
	bl	_dev_err
	b	.LBB8_26
.LBB8_25:
	adrp	x1, .L.str.54
	mov	x0, x20
	add	x1, x1, :lo12:.L.str.54
	mov	w2, #58720256
	bl	_dev_err
	mov	w21, #-19
.LBB8_26:
	mrs	x8, SP_EL0
	ldr	x8, [x8, #1584]
	ldur	x9, [x29, #-8]
	cmp	x8, x9
	b.ne	.LBB8_30
	ldp	x20, x19, [sp, #192]
	mov	w0, w21
	ldp	x29, x30, [sp, #160]
	ldr	x21, [sp, #176]
	ldr	x30, [x18, #-8]!
	add	sp, sp, #208
	ret
.LBB8_28:
	adrp	x1, .L.str.55
	mov	x0, x20
	add	x1, x1, :lo12:.L.str.55
	bl	_dev_err
	b	.LBB8_7
.LBB8_29:
	ldp	x10, x8, [x19, #216]
	mov	w9, #20971520
	mov	w11, #26214400
	mov	w14, #28311552
	mov	w13, #2097152
	str	x0, [x19, #832]
	mov	w1, wzr
	add	x9, x8, x9
	add	x12, x8, x11
	add	x11, x10, x11
	add	x10, x10, x14
	str	x9, [x19, #232]
	add	x9, x8, x14
	stp	x10, x13, [x19, #96]
	mov	w10, #35651584
	add	x10, x8, x10
	stp	x12, x11, [x19, #64]
	stp	x13, x9, [x19, #80]
	mov	w11, #40894464
	str	x9, [x19, #400]
	mov	w9, #30408704
	add	x9, x8, x9
	mov	w13, #46137344
	add	x11, x8, x11
	add	x13, x8, x13
	stp	x9, x10, [x19, #352]
	mov	w9, #51380224
	add	x0, x8, x9
	stp	x11, x13, [x19, #368]
	ldp	w10, w9, [x19, #116]
	mov	w11, #56623104
	mov	w13, #57671680
	add	x11, x8, x11
	add	x8, x8, x13
	stp	x0, x12, [x19, #384]
	mul	w2, w9, w10
	stp	x11, x8, [x19, #336]
	bl	memset
	ldp	w8, w9, [x19, #116]
	ldr	x0, [x19, #376]
	mov	w1, wzr
	mul	w2, w9, w8
	bl	memset
	ldr	x0, [x19, #368]
	mov	w1, #240
	ldrsw	x2, [x19, #244]
	bl	memset
	mov	w21, wzr
	b	.LBB8_26
.LBB8_30:
	bl	__stack_chk_fail
.Lfunc_end8:
	.size	ebc_buffer_manage_init, .Lfunc_end8-ebc_buffer_manage_init

	.p2align	2
	.type	ebc_lut_table_init,@function
ebc_lut_table_init:
	sub	sp, sp, #208
	str	x30, [x18], #8
	stp	x29, x30, [sp, #160]
	add	x29, sp, #160
	str	x21, [sp, #176]
	adrp	x1, .L.str.56
	stp	x20, x19, [sp, #192]
	mrs	x8, SP_EL0
	ldr	x8, [x8, #1584]
	mov	x19, x0
	add	x1, x1, :lo12:.L.str.56
	add	x5, sp, #72
	mov	x2, xzr
	mov	w3, wzr
	stur	x8, [x29, #-8]
	mov	w4, wzr
	ldr	x20, [x0, #96]
	stp	xzr, xzr, [sp, #56]
	stp	xzr, xzr, [sp, #40]
	stp	xzr, xzr, [sp, #24]
	ldr	x0, [x20, #656]
	stp	xzr, xzr, [sp, #8]
	stp	xzr, xzr, [sp, #136]
	stp	xzr, xzr, [sp, #120]
	stp	xzr, xzr, [sp, #104]
	stp	xzr, xzr, [sp, #88]
	stp	xzr, xzr, [sp, #72]
	bl	__of_parse_phandle_with_args
	mov	w8, w0
	mov	w0, #-19
	cbnz	w8, .LBB9_6
	ldr	x8, [sp, #72]
	cbz	x8, .LBB9_6
	add	x2, sp, #8
	mov	x0, x8
	mov	w1, wzr
	bl	of_address_to_resource
	cbnz	w0, .LBB9_6
	ldp	x1, x8, [sp, #8]
	mov	x0, x20
	mov	w3, #1
	str	x1, [x19, #40]
	sub	x8, x8, x1
	add	x21, x8, #1
	sxtw	x2, w21
	str	w21, [x19, #48]
	bl	devm_memremap
	str	x0, [x19, #200]
	cbz	x0, .LBB9_8
	bl	epd_lut_from_mem_init
	tbnz	w0, #31, .LBB9_9
.LBB9_5:
	mov	w0, wzr
.LBB9_6:
	mrs	x8, SP_EL0
	ldr	x8, [x8, #1584]
	ldur	x9, [x29, #-8]
	cmp	x8, x9
	b.ne	.LBB9_11
	ldp	x20, x19, [sp, #192]
	ldp	x29, x30, [sp, #160]
	ldr	x21, [sp, #176]
	ldr	x30, [x18, #-8]!
	add	sp, sp, #208
	ret
.LBB9_8:
	adrp	x1, .L.str.57
	adrp	x2, .L__func__.ebc_lut_table_init
	ldr	x0, [x19, #96]
	add	x1, x1, :lo12:.L.str.57
	add	x2, x2, :lo12:.L__func__.ebc_lut_table_init
	mov	w3, #3693
	bl	_dev_err
	mov	w0, #-12
	b	.LBB9_6
.LBB9_9:
	adrp	x1, .L.str.58
	ldr	x0, [x19, #96]
	add	x1, x1, :lo12:.L.str.58
	bl	_dev_err
	ldr	x0, [x19, #96]
	mov	w2, w21
	ldr	x1, [x19, #200]
	bl	epd_lut_from_file_init
	tbz	w0, #31, .LBB9_5
	adrp	x1, .L.str.59
	ldr	x0, [x19, #96]
	add	x1, x1, :lo12:.L.str.59
	bl	_dev_err
	mov	w0, #-1
	b	.LBB9_6
.LBB9_11:
	bl	__stack_chk_fail
.Lfunc_end9:
	.size	ebc_lut_table_init, .Lfunc_end9-ebc_lut_table_init

	.p2align	2
	.type	ebc_task_init,@function
ebc_task_init:
	sub	sp, sp, #64
	str	x30, [x18], #8
	stp	x29, x30, [sp, #16]
	adrp	x3, .L.str.60
	str	x21, [sp, #32]
	mov	w9, #99
	stp	x20, x19, [sp, #48]
	mrs	x8, SP_EL0
	mov	x19, x0
	adrp	x0, ebc_auto_tast_function
	ldr	x8, [x8, #1584]
	add	x0, x0, :lo12:ebc_auto_tast_function
	add	x3, x3, :lo12:.L.str.60
	mov	x1, x19
	mov	w2, #-1
	add	x29, sp, #16
	str	x8, [sp, #8]
	str	w9, [sp]
	bl	kthread_create_on_node
	adrp	x20, ebc_auto_task
	cmn	x0, #4095
	str	x0, [x20, :lo12:ebc_auto_task]
	b.hs	.LBB10_21
	mov	x2, sp
	mov	w1, #1
	bl	sched_setscheduler_nocheck
	ldr	w8, [x19, #568]
	cmp	w8, #8
	b.lt	.LBB10_3
	adrp	x1, cpu_bit_bitmap+56
	ldr	x0, [x20, :lo12:ebc_auto_task]
	add	x1, x1, :lo12:cpu_bit_bitmap+56
	bl	set_cpus_allowed_ptr
.LBB10_3:
	ldr	x8, [x20, :lo12:ebc_auto_task]
	add	x0, x8, #64
	//APP
.Ltmp2:
	b	.Ltmp1
.Ltmp3:
	.section	.altinstructions,"a",@progbits
.Ltmp4:
	.word	.Ltmp2-.Ltmp4
.Ltmp5:
	.word	alt_cb_patch_nops-.Ltmp5
	.hword	32794
	.byte	.Ltmp3-.Ltmp2
	.byte	.Ltmp6-.Ltmp7
	.text

.Ltmp7:
.Ltmp6:

	//NO_APP
	mov	w8, #1
	//APP
	ldadd	w8, w8, [x0]
	//NO_APP
	cbz	w8, .LBB10_30
.LBB10_5:
	add	w9, w8, #1
	orr	w8, w9, w8
	tbnz	w8, #31, .LBB10_25
.LBB10_6:
	adrp	x0, ebc_auto_assist_tast_function
	adrp	x3, .L.str.62
	add	x0, x0, :lo12:ebc_auto_assist_tast_function
	add	x3, x3, :lo12:.L.str.62
	mov	x1, x19
	mov	w2, #-1
	bl	kthread_create_on_node
	adrp	x20, ebc_auto_assist_task
	cmn	x0, #4095
	str	x0, [x20, :lo12:ebc_auto_assist_task]
	b.hs	.LBB10_22
	mov	x2, sp
	mov	w1, #1
	bl	sched_setscheduler_nocheck
	ldr	w8, [x19, #568]
	cmp	w8, #8
	b.lt	.LBB10_9
	adrp	x1, cpu_bit_bitmap+64
	ldr	x0, [x20, :lo12:ebc_auto_assist_task]
	add	x1, x1, :lo12:cpu_bit_bitmap+64
	bl	set_cpus_allowed_ptr
.LBB10_9:
	ldr	x8, [x20, :lo12:ebc_auto_assist_task]
	add	x0, x8, #64
	//APP
.Ltmp9:
	b	.Ltmp8
.Ltmp10:
	.section	.altinstructions,"a",@progbits
.Ltmp11:
	.word	.Ltmp9-.Ltmp11
.Ltmp12:
	.word	alt_cb_patch_nops-.Ltmp12
	.hword	32794
	.byte	.Ltmp10-.Ltmp9
	.byte	.Ltmp13-.Ltmp14
	.text

.Ltmp14:
.Ltmp13:

	//NO_APP
	mov	w8, #1
	//APP
	ldadd	w8, w8, [x0]
	//NO_APP
	cbz	w8, .LBB10_33
.LBB10_11:
	add	w9, w8, #1
	orr	w8, w9, w8
	tbnz	w8, #31, .LBB10_26
.LBB10_12:
	adrp	x0, ebc_thread
	adrp	x3, .L.str.64
	mov	w8, #99
	add	x0, x0, :lo12:ebc_thread
	add	x3, x3, :lo12:.L.str.64
	mov	x1, x19
	mov	w2, #-1
	str	w8, [sp]
	bl	kthread_create_on_node
	mov	x20, x0
	cmn	x0, #4095
	b.hs	.LBB10_23
	mov	x0, x20
	bl	wake_up_process
	adrp	x21, ebc_task
	mov	x2, sp
	mov	x0, x20
	mov	w1, #1
	str	x20, [x21, :lo12:ebc_task]
	bl	sched_setscheduler_nocheck
	ldr	w8, [x19, #568]
	cmp	w8, #8
	b.lt	.LBB10_15
	adrp	x1, cpu_bit_bitmap+48
	ldr	x0, [x21, :lo12:ebc_task]
	add	x1, x1, :lo12:cpu_bit_bitmap+48
	bl	set_cpus_allowed_ptr
.LBB10_15:
	ldr	x8, [x21, :lo12:ebc_task]
	add	x0, x8, #64
	//APP
.Ltmp16:
	b	.Ltmp15
.Ltmp17:
	.section	.altinstructions,"a",@progbits
.Ltmp18:
	.word	.Ltmp16-.Ltmp18
.Ltmp19:
	.word	alt_cb_patch_nops-.Ltmp19
	.hword	32794
	.byte	.Ltmp17-.Ltmp16
	.byte	.Ltmp20-.Ltmp21
	.text

.Ltmp21:
.Ltmp20:

	//NO_APP
	mov	w8, #1
	//APP
	ldadd	w8, w8, [x0]
	//NO_APP
	cbz	w8, .LBB10_36
.LBB10_17:
	add	w9, w8, #1
	orr	w8, w9, w8
	tbnz	w8, #31, .LBB10_27
.LBB10_18:
	mov	w0, wzr
.LBB10_19:
	mrs	x8, SP_EL0
	ldr	x8, [x8, #1584]
	ldr	x9, [sp, #8]
	cmp	x8, x9
	b.ne	.LBB10_28
	ldp	x20, x19, [sp, #48]
	ldp	x29, x30, [sp, #16]
	ldr	x21, [sp, #32]
	ldr	x30, [x18, #-8]!
	add	sp, sp, #64
	ret
.LBB10_21:
	adrp	x1, .L.str.61
	ldr	x0, [x19, #96]
	add	x1, x1, :lo12:.L.str.61
	b	.LBB10_24
.LBB10_22:
	ldr	x0, [x19, #96]
	adrp	x1, .L.str.63
	add	x1, x1, :lo12:.L.str.63
	b	.LBB10_24
.LBB10_23:
	adrp	x8, ebc_task
	ldr	x0, [x19, #96]
	adrp	x1, .L.str.65
	add	x1, x1, :lo12:.L.str.65
	str	x20, [x8, :lo12:ebc_task]
.LBB10_24:
	bl	_dev_err
	mov	w0, #-1
	b	.LBB10_19
.LBB10_25:
	mov	w1, #1
	b	.LBB10_31
.LBB10_26:
	mov	w1, #1
	b	.LBB10_34
.LBB10_27:
	mov	w1, #1
	b	.LBB10_37
.LBB10_28:
	bl	__stack_chk_fail
.Ltmp1:
.LBB10_29:
	//APP
	// atomic_fetch_add_relaxed
	prfm	pstl1strm, [x0]
.Ltmp22:
	ldxr	w8, [x0]
	add	w9, w8, #1
	stxr	w10, w9, [x0]
	cbnz	w10, .Ltmp22

	//NO_APP
	cbnz	w8, .LBB10_5
.LBB10_30:
	mov	w1, #2
.LBB10_31:
	bl	refcount_warn_saturate
	b	.LBB10_6
.Ltmp8:
.LBB10_32:
	//APP
	// atomic_fetch_add_relaxed
	prfm	pstl1strm, [x0]
.Ltmp23:
	ldxr	w8, [x0]
	add	w9, w8, #1
	stxr	w10, w9, [x0]
	cbnz	w10, .Ltmp23

	//NO_APP
	cbnz	w8, .LBB10_11
.LBB10_33:
	mov	w1, #2
.LBB10_34:
	bl	refcount_warn_saturate
	b	.LBB10_12
.Ltmp15:
.LBB10_35:
	//APP
	// atomic_fetch_add_relaxed
	prfm	pstl1strm, [x0]
.Ltmp24:
	ldxr	w8, [x0]
	add	w9, w8, #1
	stxr	w10, w9, [x0]
	cbnz	w10, .Ltmp24

	//NO_APP
	cbnz	w8, .LBB10_17
.LBB10_36:
	mov	w1, #2
.LBB10_37:
	bl	refcount_warn_saturate
	b	.LBB10_18
.Lfunc_end10:
	.size	ebc_task_init, .Lfunc_end10-ebc_task_init

	.p2align	2
	.type	ebc_other_init,@function
ebc_other_init:
	str	x30, [x18], #8
	stp	x29, x30, [sp, #-48]!
	mov	x8, #4294967297
	add	x9, x0, #540
	stp	x20, x19, [sp, #32]
	mov	x19, x0
	str	wzr, [x0, #192]
	mov	x29, sp
	str	x8, [x9]
	ldr	w9, [x0, #640]
	mov	w8, #1
	str	xzr, [x0, #528]
	str	xzr, [x0, #88]
	cmp	w9, #3576
	str	wzr, [x0, #52]
	str	w8, [x0, #240]
	add	x8, x0, #548
	str	wzr, [x0, #68]
	cset	w9, eq
	str	wzr, [x0, #560]
	str	wzr, [x0, #576]
	adds	x0, x0, #248
	stp	x22, x21, [sp, #16]
	str	xzr, [x8]
	str	w9, [x19, #556]
	str	w9, [x19, #564]
	b.eq	.LBB11_2
	adrp	x8, .L.str.95
	stp	xzr, xzr, [x19, #424]
	add	x8, x8, :lo12:.L.str.95
	stp	xzr, xzr, [x19, #408]
	stp	xzr, xzr, [x19, #392]
	stp	xzr, xzr, [x19, #376]
	stp	xzr, xzr, [x19, #360]
	stp	xzr, xzr, [x19, #344]
	stp	xzr, xzr, [x19, #328]
	stp	xzr, xzr, [x19, #312]
	stp	xzr, xzr, [x19, #296]
	stp	xzr, xzr, [x19, #280]
	stp	xzr, xzr, [x19, #264]
	stp	x8, xzr, [x19, #248]
.LBB11_2:
	bl	wakeup_source_add
	add	x20, x19, #448
	adrp	x1, ebc_frame_control_timeout
	add	x1, x1, :lo12:ebc_frame_control_timeout
	mov	x0, x20
	mov	w2, wzr
	mov	x3, xzr
	mov	x4, xzr
	str	wzr, [x19, #440]
	bl	init_timer_key
	adrp	x21, jiffies
	mov	w22, #268435455
	mov	x0, x20
	ldr	x8, [x21, :lo12:jiffies]
	add	x1, x8, x22
	bl	mod_timer
	add	x19, x19, #488
	adrp	x1, ebc_frame_timeout
	add	x1, x1, :lo12:ebc_frame_timeout
	mov	x0, x19
	mov	w2, wzr
	mov	x3, xzr
	mov	x4, xzr
	bl	init_timer_key
	ldr	x8, [x21, :lo12:jiffies]
	mov	x0, x19
	add	x1, x8, x22
	bl	mod_timer
	ldp	x20, x19, [sp, #32]
	ldp	x22, x21, [sp, #16]
	ldp	x29, x30, [sp], #48
	ldr	x30, [x18, #-8]!
	ret
.Lfunc_end11:
	.size	ebc_other_init, .Lfunc_end11-ebc_other_init

	.p2align	2
	.type	ebc_logo_init,@function
ebc_logo_init:
	sub	sp, sp, #80
	str	x30, [x18], #8
	stp	x29, x30, [sp, #16]
	adrp	x9, saved_command_line
	stp	x24, x23, [sp, #32]
	add	x29, sp, #16
	stp	x22, x21, [sp, #48]
	stp	x20, x19, [sp, #64]
	mrs	x8, SP_EL0
	ldr	x8, [x8, #1584]
	mov	x20, x1
	adrp	x1, .L.str.97
	mov	x19, x0
	add	x1, x1, :lo12:.L.str.97
	str	x8, [sp, #8]
	ldr	x22, [x9, :lo12:saved_command_line]
	str	xzr, [sp]
	mov	x0, x22
	bl	strstr
	adrp	x1, .L.str.98
	mov	x21, x0
	add	x1, x1, :lo12:.L.str.98
	mov	x0, x22
	bl	strstr
	mov	x22, x0
	cbz	x21, .LBB12_3
	adrp	x1, .L.str.99
	add	x2, sp, #4
	add	x1, x1, :lo12:.L.str.99
	mov	x0, x21
	bl	sscanf
	ldr	w2, [sp, #4]
	ldr	x8, [x19, #216]
	cmp	x8, x2
	b.ls	.LBB12_26
	mov	x21, xzr
.LBB12_3:
	mov	w23, #1
	cbz	x22, .LBB12_28
.LBB12_4:
	adrp	x1, .L.str.102
	mov	x2, sp
	add	x1, x1, :lo12:.L.str.102
	mov	x0, x22
	bl	sscanf
	ldr	w2, [sp]
	ldr	x8, [x19, #216]
	cmp	x8, x2
	b.ls	.LBB12_31
	mov	x22, xzr
	mov	w24, #1
	cbnz	w23, .LBB12_29
.LBB12_6:
	adrp	x0, .L.str.106
	add	x0, x0, :lo12:.L.str.106
	bl	ebc_empty_buf_get
	cbz	x0, .LBB12_12
	ldp	w8, w9, [x20, #76]
	mul	w8, w9, w8
	cmp	w8, #2
	b.lo	.LBB12_10
	lsr	w8, w8, #1
	ldr	x9, [x0, #16]
	mov	x10, x21
.LBB12_9:
	ldrb	w11, [x10], #1
	subs	w8, w8, #1
	lsl	w12, w11, #4
	and	w11, w11, #0xf0
	strb	w12, [x9]
	strb	w11, [x9, #1]
	add	x9, x9, #2
	b.ne	.LBB12_9
.LBB12_10:
	mov	w8, #7
	str	xzr, [x0, #48]
	mov	w9, #1
	str	w8, [x0, #40]
	ldr	w8, [x20, #76]
	str	w8, [x0, #56]
	ldr	w8, [x20, #80]
	stp	w8, w9, [x0, #60]
.LBB12_11:
	bl	ebc_add_to_dsp_buf_list
.LBB12_12:
	tbnz	w24, #0, .LBB12_18
	adrp	x0, .L.str.106
	add	x0, x0, :lo12:.L.str.106
	bl	ebc_empty_buf_get
	cbz	x0, .LBB12_18
	ldp	w8, w9, [x20, #76]
	mul	w8, w9, w8
	cmp	w8, #2
	b.lo	.LBB12_17
	lsr	w8, w8, #1
	ldr	x9, [x0, #16]
	mov	x10, x22
.LBB12_16:
	ldrb	w11, [x10], #1
	subs	w8, w8, #1
	lsl	w12, w11, #4
	and	w11, w11, #0xf0
	strb	w12, [x9]
	strb	w11, [x9, #1]
	add	x9, x9, #2
	b.ne	.LBB12_16
.LBB12_17:
	mov	w8, #7
	str	xzr, [x0, #48]
	mov	w9, #1
	str	w8, [x0, #40]
	ldr	w8, [x20, #76]
	str	w8, [x0, #56]
	ldr	w8, [x20, #80]
	stp	w8, w9, [x0, #60]
	bl	ebc_add_to_dsp_buf_list
.LBB12_18:
	ldr	w8, [x19, #304]
	cbnz	w8, .LBB12_20
	adrp	x0, ebc_thread_wq
	mov	w8, #1
	add	x0, x0, :lo12:ebc_thread_wq
	mov	w1, #1
	str	w8, [x19, #304]
	bl	__wake_up_sync
.LBB12_20:
	cbz	x21, .LBB12_22
	mov	x0, x21
	bl	kfree
.LBB12_22:
	cbz	x22, .LBB12_24
	mov	x0, x22
	bl	kfree
.LBB12_24:
	mrs	x8, SP_EL0
	ldr	x8, [x8, #1584]
	ldr	x9, [sp, #8]
	cmp	x8, x9
	b.ne	.LBB12_37
	ldp	x20, x19, [sp, #64]
	ldp	x22, x21, [sp, #48]
	ldp	x24, x23, [sp, #32]
	ldp	x29, x30, [sp, #16]
	ldr	x30, [x18, #-8]!
	add	sp, sp, #80
	ret
.LBB12_26:
	adrp	x1, .L.str.100
	ldr	x0, [x19, #312]
	add	x1, x1, :lo12:.L.str.100
	bl	_dev_info
	ldp	w9, w8, [x20, #76]
	mov	w1, #3520
	mul	w8, w8, w9
	lsr	w0, w8, #1
	bl	__kmalloc
	cbz	x0, .LBB12_35
	ldp	w9, w8, [x20, #76]
	ldp	x11, x12, [x19, #216]
	mov	x21, x0
	ldr	w10, [sp, #4]
	mul	w8, w8, w9
	sub	x9, x10, x11
	lsr	w2, w8, #1
	add	x1, x12, x9
	bl	memcpy
	mov	w23, wzr
	cbnz	x22, .LBB12_4
.LBB12_28:
	mov	w24, #1
	cbz	w23, .LBB12_6
.LBB12_29:
	adrp	x1, .L.str.105
	ldr	x0, [x19, #312]
	add	x1, x1, :lo12:.L.str.105
	bl	_dev_info
	ldr	x0, [x19, #16]
	cbz	x0, .LBB12_33
	bl	ebc_pmic_verity_vcom
	b	.LBB12_34
.LBB12_31:
	adrp	x1, .L.str.103
	ldr	x0, [x19, #312]
	add	x1, x1, :lo12:.L.str.103
	bl	_dev_info
	ldp	w9, w8, [x20, #76]
	mov	w1, #3520
	mul	w8, w8, w9
	lsr	w0, w8, #1
	bl	__kmalloc
	cbz	x0, .LBB12_36
	ldp	w9, w8, [x20, #76]
	ldp	x11, x12, [x19, #216]
	mov	x22, x0
	ldr	w10, [sp]
	mul	w8, w8, w9
	sub	x9, x10, x11
	lsr	w2, w8, #1
	add	x1, x12, x9
	bl	memcpy
	mov	w24, wzr
	cbz	w23, .LBB12_6
	b	.LBB12_29
.LBB12_33:
	ldr	x0, [x19, #24]
	bl	ebc_regulator_verity_vcom
.LBB12_34:
	adrp	x0, .L.str.107
	add	x0, x0, :lo12:.L.str.107
	bl	ebc_empty_buf_get
	ldp	w8, w9, [x20, #76]
	mov	x23, x0
	ldr	x0, [x0, #16]
	mov	w1, #240
	mul	w2, w9, w8
	bl	memset
	mov	w8, #17
	str	xzr, [x23, #48]
	mov	w9, #1
	mov	x0, x23
	str	w8, [x23, #40]
	ldr	w8, [x20, #76]
	str	w8, [x23, #56]
	ldr	w8, [x20, #80]
	stp	w8, w9, [x23, #60]
	b	.LBB12_11
.LBB12_35:
	adrp	x1, .L.str.101
	ldr	x0, [x19, #312]
	add	x1, x1, :lo12:.L.str.101
	bl	_dev_err
	b	.LBB12_24
.LBB12_36:
	adrp	x1, .L.str.104
	ldr	x0, [x19, #312]
	add	x1, x1, :lo12:.L.str.104
	bl	_dev_err
	b	.LBB12_24
.LBB12_37:
	bl	__stack_chk_fail
.Lfunc_end12:
	.size	ebc_logo_init, .Lfunc_end12-ebc_logo_init

	.p2align	2
	.type	ebc_sysfs_init,@function
ebc_sysfs_init:
	str	x30, [x18], #8
	stp	x29, x30, [sp, #-32]!
	str	x19, [sp, #16]
	mov	x19, x0
	adrp	x0, ebc_misc
	mov	x29, sp
	add	x0, x0, :lo12:ebc_misc
	bl	misc_register
	adrp	x0, waveform_misc
	add	x0, x0, :lo12:waveform_misc
	bl	misc_register
	adrp	x1, dev_attr_waveform_version
	ldr	x0, [x19, #96]
	add	x1, x1, :lo12:dev_attr_waveform_version
	bl	device_create_file
	adrp	x1, dev_attr_pmic_name
	ldr	x0, [x19, #96]
	add	x1, x1, :lo12:dev_attr_pmic_name
	bl	device_create_file
	adrp	x1, dev_attr_pmic_temp
	ldr	x0, [x19, #96]
	add	x1, x1, :lo12:dev_attr_pmic_temp
	bl	device_create_file
	adrp	x1, dev_attr_pmic_vcom
	ldr	x0, [x19, #96]
	add	x1, x1, :lo12:dev_attr_pmic_vcom
	bl	device_create_file
	adrp	x1, dev_attr_ebc_version
	ldr	x0, [x19, #96]
	add	x1, x1, :lo12:dev_attr_ebc_version
	bl	device_create_file
	adrp	x1, dev_attr_ebc_state
	ldr	x0, [x19, #96]
	add	x1, x1, :lo12:dev_attr_ebc_state
	bl	device_create_file
	adrp	x1, dev_attr_ebc_buf_state
	ldr	x0, [x19, #96]
	add	x1, x1, :lo12:dev_attr_ebc_buf_state
	bl	device_create_file
	adrp	x1, dev_attr_auto_frame_state
	ldr	x0, [x19, #96]
	add	x1, x1, :lo12:dev_attr_auto_frame_state
	bl	device_create_file
	adrp	x1, dev_attr_ebc_debug_level
	ldr	x0, [x19, #96]
	add	x1, x1, :lo12:dev_attr_ebc_debug_level
	bl	device_create_file
	adrp	x1, dev_attr_wf_data
	ldr	x0, [x19, #96]
	add	x1, x1, :lo12:dev_attr_wf_data
	bl	device_create_file
	ldr	x19, [sp, #16]
	ldp	x29, x30, [sp], #32
	ldr	x30, [x18, #-8]!
	ret
.Lfunc_end13:
	.size	ebc_sysfs_init, .Lfunc_end13-ebc_sysfs_init

	.p2align	2
	.type	ebc_auto_tast_function,@function
ebc_auto_tast_function:
	sub	sp, sp, #112
	str	x30, [x18], #8
	adrp	x8, global_ebc
	stp	x26, x25, [sp, #48]
	stp	x22, x21, [sp, #80]
	adrp	x22, ebc_assist_finished_flag_sem
	stp	x20, x19, [sp, #96]
	adrp	x19, ebc_auto_thread_sem
	ldr	x26, [x8, :lo12:global_ebc]
	stp	x28, x27, [sp, #32]
	stp	x24, x23, [sp, #64]
	add	x19, x19, :lo12:ebc_auto_thread_sem
	mov	w25, #2
	adrp	x28, ebc_auto_assist_task
	mov	w23, #1
	add	x20, x26, #216
	add	x8, x26, #704
	mov	w21, #255
	add	x22, x22, :lo12:ebc_assist_finished_flag_sem
	stp	x29, x30, [sp, #16]
	add	x29, sp, #16
	//APP
	mrs	x27, SP_EL0
	//NO_APP
	str	x8, [sp, #8]
	b	.LBB14_3
.LBB14_1:
	bl	get_auto_image2
.LBB14_2:
	mov	x0, x19
	bl	up
	bl	schedule
.LBB14_3:
	mov	x0, x19
	bl	down
	mov	x0, x22
	bl	down
	str	w25, [x27, #48]
	//APP
	dmb	ish
	//NO_APP
	ldr	w8, [x26, #456]
	cmp	w8, #1
	b.eq	.LBB14_11
	cmp	w8, #3
	b.eq	.LBB14_16
	cmp	w8, #4
	b.ne	.LBB14_20
	ldr	w8, [x26, #292]
	cbz	w8, .LBB14_27
	ldr	w8, [x26, #276]
	str	wzr, [x26, #292]
	str	wzr, [x26, #284]
	cbnz	w8, .LBB14_9
	ldr	w8, [x26, #280]
	cbz	w8, .LBB14_38
.LBB14_9:
	mov	x8, x26
	ldrsw	x9, [x26, #112]
	mov	w10, #24
	ldrsw	x2, [x26, #248]
	mov	w3, #1
	ldr	x0, [x8, #40]!
	madd	x24, x9, x10, x8
	ldr	w10, [x26, #180]
	ldp	w8, w9, [x26, #172]
	ldr	x1, [x24, #32]
	add	w8, w9, w8
	add	w23, w8, w10
	bl	dma_sync_single_for_device
	ldr	x0, [x26, #48]
	mov	w1, wzr
	mov	w2, wzr
	mov	w3, wzr
	mov	w4, wzr
	ldr	x8, [x0, #88]
	blr	x8
	ldr	x0, [x26, #48]
	mov	w2, wzr
	ldr	w1, [x24, #32]
	ldr	x8, [x0, #96]
	blr	x8
	ldr	x0, [x26, #48]
	mov	w1, w23
	mov	w2, wzr
	mov	w23, #1
	ldr	x8, [x0, #144]
	blr	x8
	ldr	x0, [x26, #48]
	mov	w1, #1
	ldr	x8, [x0, #128]
	blr	x8
	ldr	w8, [x26, #112]
	ldr	x0, [x28, :lo12:ebc_auto_assist_task]
	sub	w8, w23, w8
	str	w8, [x26, #112]
	bl	wake_up_process
	ldrsw	x8, [x26, #112]
	mov	x5, x20
	ldp	x1, x2, [x26, #352]
	mov	w6, #2
	add	x8, x26, x8, lsl #3
	ldr	w9, [x26, #204]
	ldp	x3, x4, [x26, #376]
	ldr	x0, [x8, #392]
	cbz	w9, .LBB14_31
	bl	get_overlay_image2
	b	.LBB14_2
.LBB14_11:
	ldr	w8, [x26, #288]
	ldr	w9, [x26, #292]
	sub	w8, w8, #1
	str	w8, [x26, #288]
	cbz	w9, .LBB14_13
	mov	x24, x26
	mov	w9, #24
	mov	w3, #1
	ldr	x0, [x24, #40]!
	ldrsw	x8, [x24, #72]
	ldr	w10, [x24, #140]
	ldrsw	x2, [x24, #208]
	madd	x28, x8, x9, x24
	ldp	w8, w9, [x24, #132]
	ldr	x1, [x28, #32]
	add	w8, w9, w8
	add	w23, w8, w10
	bl	dma_sync_single_for_device
	ldr	x0, [x24, #8]
	mov	w1, wzr
	mov	w2, wzr
	mov	w3, wzr
	mov	w4, wzr
	ldr	x8, [x0, #88]
	blr	x8
	ldr	x0, [x24, #8]
	mov	w2, wzr
	ldr	w1, [x28, #32]
	adrp	x28, ebc_auto_assist_task
	ldr	x8, [x0, #96]
	blr	x8
	ldr	x0, [x24, #8]
	mov	w1, w23
	mov	w2, wzr
	mov	w23, #1
	ldr	x8, [x0, #144]
	blr	x8
	ldr	x0, [x24, #8]
	mov	w1, #1
	ldr	x8, [x0, #128]
	blr	x8
	ldr	w8, [x24, #72]
	str	wzr, [x24, #252]
	sub	w8, w23, w8
	str	w8, [x24, #72]
.LBB14_13:
	ldr	x0, [x28, :lo12:ebc_auto_assist_task]
	bl	wake_up_process
	ldr	w8, [x26, #288]
	cbz	w8, .LBB14_2
	ldrsw	x8, [x26, #112]
	mov	x3, x20
	ldp	x11, x9, [x26, #424]
	mov	w4, #2
	add	x8, x26, x8, lsl #3
	ldr	w10, [x26, #204]
	ldr	x2, [x11, #16]
	ldr	x1, [x9, #16]
	ldr	x0, [x8, #392]
	cbz	w10, .LBB14_30
	bl	direct_mode_data_change_part2
	b	.LBB14_2
.LBB14_16:
	ldr	w8, [x26, #276]
	str	wzr, [x26, #284]
	cbnz	w8, .LBB14_18
	ldr	w8, [x26, #280]
	cbz	w8, .LBB14_32
.LBB14_18:
	mov	x8, x26
	ldrsw	x9, [x26, #112]
	mov	w10, #24
	ldrsw	x2, [x26, #248]
	mov	w3, #1
	ldr	x0, [x8, #40]!
	madd	x24, x9, x10, x8
	ldr	w10, [x26, #180]
	ldp	w8, w9, [x26, #172]
	ldr	x1, [x24, #32]
	add	w8, w9, w8
	add	w23, w8, w10
	bl	dma_sync_single_for_device
	ldr	x0, [x26, #48]
	mov	w1, wzr
	mov	w2, wzr
	mov	w3, wzr
	mov	w4, wzr
	ldr	x8, [x0, #88]
	blr	x8
	ldr	x0, [x26, #48]
	mov	w2, wzr
	ldr	w1, [x24, #32]
	ldr	x8, [x0, #96]
	blr	x8
	ldr	x0, [x26, #48]
	mov	w1, w23
	mov	w2, wzr
	mov	w23, #1
	ldr	x8, [x0, #144]
	blr	x8
	ldr	x0, [x26, #48]
	mov	w1, #1
	ldr	x8, [x0, #128]
	blr	x8
	ldr	w8, [x26, #112]
	ldr	x0, [x28, :lo12:ebc_auto_assist_task]
	sub	w8, w23, w8
	str	w8, [x26, #112]
	bl	wake_up_process
	ldrsw	x8, [x26, #112]
	mov	x4, x20
	ldp	x1, x2, [x26, #352]
	mov	w5, #2
	add	x8, x26, x8, lsl #3
	ldr	w9, [x26, #204]
	ldr	x3, [x26, #376]
	ldr	x0, [x8, #392]
	cbnz	w9, .LBB14_1
	bl	get_auto_image
	b	.LBB14_2
.LBB14_20:
	ldr	x8, [x26, #432]
	mov	x24, x26
	ldr	w8, [x8, #40]
	cmp	w8, #21
	b.ne	.LBB14_24
	ldr	x0, [x24, #40]!
	ldr	w8, [x24, #800]
	mov	w3, #1
	ldr	w9, [x24, #804]
	ldrsw	x10, [x24, #72]
	ldr	w11, [x24, #140]
	add	w8, w9, w8
	mov	w9, #24
	ldrsw	x2, [x24, #208]
	madd	x28, x10, x9, x24
	ldp	w9, w10, [x24, #132]
	str	w8, [x24, #804]
	ldr	x1, [x28, #32]
	add	w8, w10, w9
	add	w23, w8, w11
	bl	dma_sync_single_for_device
	ldr	x0, [x24, #8]
	mov	w1, wzr
	mov	w2, wzr
	mov	w3, wzr
	mov	w4, wzr
	ldr	x8, [x0, #88]
	blr	x8
	ldr	x0, [x24, #8]
	mov	w2, wzr
	ldr	w1, [x28, #32]
	adrp	x28, ebc_auto_assist_task
	ldr	x8, [x0, #96]
	blr	x8
	ldr	x0, [x24, #8]
	mov	w1, w23
	mov	w2, wzr
	mov	w23, #1
	ldr	x8, [x0, #144]
	blr	x8
	ldr	x0, [x24, #8]
	mov	w1, #1
	ldr	x8, [x0, #128]
	blr	x8
	ldr	w8, [x24, #72]
	ldr	x0, [x28, :lo12:ebc_auto_assist_task]
	sub	w8, w23, w8
	str	w8, [x24, #72]
	bl	wake_up_process
	ldr	w8, [x24, #260]
	ldr	w9, [x24, #800]
	ldrb	w10, [x24, #232]
	ldr	w11, [x24, #804]
	madd	w8, w9, w10, w8
	cmp	w11, w8
	b.ge	.LBB14_29
	ldrsw	x8, [x26, #112]
	mov	x3, x20
	ldp	x11, x9, [x26, #424]
	mov	w4, #2
	add	x8, x26, x8, lsl #3
	ldr	w10, [x26, #204]
	ldr	x2, [x11, #16]
	ldr	x1, [x9, #16]
	ldr	x0, [x8, #392]
	cbz	w10, .LBB14_37
	bl	direct_mode_data_change_full2
	b	.LBB14_2
.LBB14_24:
	ldr	x0, [x24, #40]!
	ldr	w8, [x24, #248]
	mov	w10, #24
	ldrsw	x9, [x24, #72]
	mov	w3, #1
	ldr	w11, [x24, #140]
	sub	w8, w8, #1
	ldrsw	x2, [x24, #208]
	madd	x28, x9, x10, x24
	ldp	w9, w10, [x24, #132]
	str	w8, [x24, #248]
	ldr	x1, [x28, #32]
	add	w8, w10, w9
	add	w23, w8, w11
	bl	dma_sync_single_for_device
	ldr	x0, [x24, #8]
	mov	w1, wzr
	mov	w2, wzr
	mov	w3, wzr
	mov	w4, wzr
	ldr	x8, [x0, #88]
	blr	x8
	ldr	x0, [x24, #8]
	mov	w2, wzr
	ldr	w1, [x28, #32]
	adrp	x28, ebc_auto_assist_task
	ldr	x8, [x0, #96]
	blr	x8
	ldr	x0, [x24, #8]
	mov	w1, w23
	mov	w2, wzr
	mov	w23, #1
	ldr	x8, [x0, #144]
	blr	x8
	ldr	x0, [x24, #8]
	mov	w1, #1
	ldr	x8, [x0, #128]
	blr	x8
	ldr	w8, [x24, #72]
	ldr	x0, [x28, :lo12:ebc_auto_assist_task]
	sub	w8, w23, w8
	str	w8, [x24, #72]
	bl	wake_up_process
	ldr	w8, [x24, #248]
	cbz	w8, .LBB14_2
	ldrsw	x8, [x26, #112]
	mov	x3, x20
	ldp	x11, x9, [x26, #424]
	mov	w4, #2
	add	x8, x26, x8, lsl #3
	ldr	w10, [x26, #204]
	ldr	x2, [x11, #16]
	ldr	x1, [x9, #16]
	ldr	x0, [x8, #392]
	cbz	w10, .LBB14_36
	bl	direct_mode_data_change2
	b	.LBB14_2
.LBB14_27:
	mov	x0, x22
	bl	up
	ldrsw	x8, [x26, #112]
	mov	x5, x20
	ldp	x1, x2, [x26, #352]
	add	x8, x26, x8, lsl #3
	ldr	w9, [x26, #204]
	ldp	x3, x4, [x26, #376]
	ldr	x0, [x8, #392]
	cbz	w9, .LBB14_35
	bl	get_overlay_image_area2
	b	.LBB14_2
.LBB14_29:
	str	w23, [x26, #848]
	b	.LBB14_2
.LBB14_30:
	bl	direct_mode_data_change_part
	b	.LBB14_2
.LBB14_31:
	bl	get_overlay_image
	b	.LBB14_2
.LBB14_32:
	mov	x0, x22
	bl	up
	ldr	w8, [x26, #764]
	cbz	w8, .LBB14_42
.LBB14_33:
	ldrsw	x8, [x26, #112]
	mov	x4, x20
	ldp	x1, x2, [x26, #352]
	mov	w5, #1
	add	x8, x26, x8, lsl #3
	ldr	w9, [x26, #204]
	ldr	x3, [x26, #376]
	ldr	x0, [x8, #392]
	cbz	w9, .LBB14_50
	bl	get_auto_image2
	b	.LBB14_52
.LBB14_35:
	bl	get_overlay_image_area
	b	.LBB14_2
.LBB14_36:
	bl	direct_mode_data_change
	b	.LBB14_2
.LBB14_37:
	bl	direct_mode_data_change_full
	b	.LBB14_2
.LBB14_38:
	mov	x0, x22
	bl	up
	ldr	w8, [x26, #764]
	cbnz	w8, .LBB14_40
	ldr	x8, [x26, #432]
	mov	x5, x20
	ldp	x3, x4, [x26, #376]
	ldr	x0, [x26, #352]
	ldr	x1, [x26, #232]
	ldr	x2, [x8, #16]
	bl	refresh_new_image
.LBB14_40:
	ldrsw	x8, [x26, #112]
	mov	x5, x20
	ldp	x1, x2, [x26, #352]
	mov	w6, #1
	add	x8, x26, x8, lsl #3
	ldr	w9, [x26, #204]
	ldp	x3, x4, [x26, #376]
	ldr	x0, [x8, #392]
	cbz	w9, .LBB14_51
	bl	get_overlay_image2
	b	.LBB14_52
.LBB14_42:
	ldr	w8, [x26, #300]
	ldr	w9, [x26, #296]
	add	w10, w8, #7
	cmp	w8, #0
	csel	w13, w10, w8, lt
	cmp	w9, #1
	b.lt	.LBB14_33
	ldr	x12, [x26, #432]
	mov	w10, wzr
	ldr	x11, [x26, #376]
	asr	w13, w13, #3
	ldr	x14, [x26, #352]
	ldr	x12, [x12, #16]
	b	.LBB14_45
.LBB14_44:
	add	w10, w10, #1
	cmp	w10, w9
	b.eq	.LBB14_33
.LBB14_45:
	cmp	w8, #8
	b.lt	.LBB14_44
	mov	w15, w13
	b	.LBB14_48
.LBB14_47:
	add	x14, x14, #8
	subs	w15, w15, #1
	b.eq	.LBB14_44
.LBB14_48:
	ldr	x16, [x12], #8
	ldr	x17, [x14]
	ldr	x0, [x11], #8
	cmp	x16, x17
	b.eq	.LBB14_47
	tst	x0, #0xff
	csel	x1, x21, xzr, eq
	tst	x0, #0xff00
	orr	x2, x1, #0xff00
	csel	x1, x2, x1, eq
	tst	x0, #0xff0000
	orr	x2, x1, #0xff0000
	csel	x1, x2, x1, eq
	tst	x0, #0xff000000
	orr	x2, x1, #0xff000000
	csel	x1, x2, x1, eq
	tst	x0, #0xff00000000
	orr	x2, x1, #0xff00000000
	csel	x1, x2, x1, eq
	tst	x0, #0xff0000000000
	orr	x2, x1, #0xff0000000000
	csel	x1, x2, x1, eq
	tst	x0, #0xff000000000000
	orr	x2, x1, #0xff000000000000
	lsr	x0, x0, #56
	csel	x1, x2, x1, eq
	cmp	x0, #0
	orr	x2, x1, #0xff00000000000000
	csel	x0, x2, x1, eq
	bic	x17, x17, x0
	and	x16, x0, x16
	orr	x16, x17, x16
	str	x16, [x14]
	b	.LBB14_47
.LBB14_50:
	bl	get_auto_image
	b	.LBB14_52
.LBB14_51:
	bl	get_overlay_image
.LBB14_52:
	adrp	x8, jiffies
	str	w23, [x26, #284]
	ldr	x8, [x8, :lo12:jiffies]
	ldr	x0, [sp, #8]
	add	x1, x8, #1
	bl	mod_timer
	b	.LBB14_2
.Lfunc_end14:
	.size	ebc_auto_tast_function, .Lfunc_end14-ebc_auto_tast_function

	.p2align	2
	.type	ebc_auto_assist_tast_function,@function
ebc_auto_assist_tast_function:
	str	x30, [x18], #8
	stp	x29, x30, [sp, #-64]!
	adrp	x8, global_ebc
	stp	x22, x21, [sp, #32]
	stp	x20, x19, [sp, #48]
	adrp	x19, ebc_auto_assist_thread_sem
	adrp	x21, ebc_assist_finished_flag_sem
	stp	x24, x23, [sp, #16]
	ldr	x22, [x8, :lo12:global_ebc]
	add	x19, x19, :lo12:ebc_auto_assist_thread_sem
	mov	w23, #2
	add	x21, x21, :lo12:ebc_assist_finished_flag_sem
	mov	x29, sp
	//APP
	mrs	x24, SP_EL0
	//NO_APP
	add	x20, x22, #216
	b	.LBB15_4
.LBB15_1:
	ldrsw	x8, [x22, #112]
	mov	x4, x20
	ldp	x1, x2, [x22, #352]
	mov	w5, #3
	add	x8, x22, x8, lsl #3
	ldr	w9, [x22, #204]
	ldr	x3, [x22, #376]
	ldr	x0, [x8, #392]
	cbz	w9, .LBB15_19
	bl	get_auto_image2
.LBB15_3:
	mov	x0, x21
	bl	up
	mov	x0, x19
	bl	up
	bl	schedule
.LBB15_4:
	mov	x0, x19
	bl	down
	str	w23, [x24, #48]
	//APP
	dmb	ish
	//NO_APP
	ldr	w8, [x22, #456]
	cmp	w8, #1
	b.eq	.LBB15_9
	cmp	w8, #3
	b.eq	.LBB15_1
	cmp	w8, #4
	b.ne	.LBB15_12
	ldrsw	x8, [x22, #112]
	mov	x5, x20
	ldp	x1, x2, [x22, #352]
	mov	w6, #3
	add	x8, x22, x8, lsl #3
	ldr	w9, [x22, #204]
	ldp	x3, x4, [x22, #376]
	ldr	x0, [x8, #392]
	cbz	w9, .LBB15_20
	bl	get_overlay_image2
	b	.LBB15_3
.LBB15_9:
	ldr	w8, [x22, #288]
	cbz	w8, .LBB15_3
	ldrsw	x8, [x22, #112]
	mov	x3, x20
	ldp	x11, x9, [x22, #424]
	mov	w4, #3
	add	x8, x22, x8, lsl #3
	ldr	w10, [x22, #204]
	ldr	x2, [x11, #16]
	ldr	x1, [x9, #16]
	ldr	x0, [x8, #392]
	cbz	w10, .LBB15_21
	bl	direct_mode_data_change_part2
	b	.LBB15_3
.LBB15_12:
	ldr	x8, [x22, #432]
	ldr	w9, [x8, #40]
	cmp	w9, #21
	b.ne	.LBB15_16
	ldr	w9, [x22, #300]
	ldr	w10, [x22, #840]
	ldrb	w11, [x22, #272]
	ldr	w12, [x22, #844]
	madd	w9, w10, w11, w9
	cmp	w12, w9
	b.ge	.LBB15_3
	ldrsw	x9, [x22, #112]
	mov	x3, x20
	ldr	x11, [x22, #424]
	mov	w4, #3
	ldr	w10, [x22, #204]
	add	x9, x22, x9, lsl #3
	ldr	x1, [x8, #16]
	ldr	x2, [x11, #16]
	ldr	x0, [x9, #392]
	cbz	w10, .LBB15_23
	bl	direct_mode_data_change_full2
	b	.LBB15_3
.LBB15_16:
	ldr	w9, [x22, #288]
	cbz	w9, .LBB15_3
	ldrsw	x9, [x22, #112]
	mov	x3, x20
	ldr	x11, [x22, #424]
	mov	w4, #3
	ldr	w10, [x22, #204]
	add	x9, x22, x9, lsl #3
	ldr	x1, [x8, #16]
	ldr	x2, [x11, #16]
	ldr	x0, [x9, #392]
	cbz	w10, .LBB15_22
	bl	direct_mode_data_change2
	b	.LBB15_3
.LBB15_19:
	bl	get_auto_image
	b	.LBB15_3
.LBB15_20:
	bl	get_overlay_image
	b	.LBB15_3
.LBB15_21:
	bl	direct_mode_data_change_part
	b	.LBB15_3
.LBB15_22:
	bl	direct_mode_data_change
	b	.LBB15_3
.LBB15_23:
	bl	direct_mode_data_change_full
	b	.LBB15_3
.Lfunc_end15:
	.size	ebc_auto_assist_tast_function, .Lfunc_end15-ebc_auto_assist_tast_function

	.p2align	2
	.type	ebc_thread,@function
ebc_thread:
	sub	sp, sp, #192
	str	x30, [x18], #8
	adrp	x8, global_ebc
	stp	x20, x19, [sp, #176]
	stp	x28, x27, [sp, #112]
	adrp	x27, ebc_thread_wq
	adrp	x28, .L.str.66
	stp	x26, x25, [sp, #128]
	ldr	x20, [x8, :lo12:global_ebc]
	stp	x24, x23, [sp, #144]
	stp	x22, x21, [sp, #160]
	mov	w25, #1
	add	x27, x27, :lo12:ebc_thread_wq
	mov	w23, #-268435456
	add	x9, x20, #216
	add	x8, x20, #312
	add	x10, x20, #792
	mov	x24, #1030792151040
	mov	x22, #263882790666240
	mov	x21, #67553994410557440
	stp	x8, x9, [sp, #8]
	add	x8, x20, #268
	add	x28, x28, :lo12:.L.str.66
	stp	x29, x30, [sp, #96]
	add	x29, sp, #96
	stp	x10, x8, [sp, #40]
	add	x8, x20, #664
	str	x8, [sp]
	add	x8, x20, #704
	str	x8, [sp, #32]
	b	.LBB16_3
.LBB16_1:
	str	w25, [x20, #660]
.LBB16_2:
	ldr	x8, [x20, #432]
	str	x8, [x20, #424]
.LBB16_3:
	bl	ebc_osd_buf_get
	cbz	x0, .LBB16_8
	mov	x26, x0
	ldr	w8, [x20, #744]
	cbnz	w8, .LBB16_6
	ldr	w8, [x20, #748]
	cbz	w8, .LBB16_24
.LBB16_6:
	ldr	x8, [sp, #40]
	ldr	w8, [x8]
	cmp	w8, #1
	b.ge	.LBB16_60
.LBB16_7:
	mov	x0, x26
	bl	ebc_buf_release
	b	.LBB16_3
.LBB16_8:
	ldr	w8, [x20, #760]
	str	wzr, [x20, #308]
	cbz	w8, .LBB16_11
	ldr	w8, [x20, #756]
	cbnz	w8, .LBB16_11
	ldr	w8, [x20, #764]
	cbz	w8, .LBB16_19
.LBB16_11:
	bl	ebc_dsp_buf_get
	cbz	x0, .LBB16_19
	ldr	w2, [x0, #40]
	mov	x26, x0
	cmp	w2, #21
	b.ne	.LBB16_21
.LBB16_13:
	ldr	w8, [x20, #660]
	cbnz	w8, .LBB16_15
	str	x26, [x20, #424]
	ldr	w2, [x26, #40]
.LBB16_15:
	cmp	w2, #23
	b.hi	.LBB16_358
	lsl	w8, w25, w2
	tst	w8, #0x1ff80
	b.ne	.LBB16_26
	mov	w9, #124
	movk	w9, #34, lsl #16
	tst	w8, w9
	b.eq	.LBB16_161
	mov	w19, #1
	b	.LBB16_27
.LBB16_19:
	ldr	w8, [x20, #304]
	cbz	w8, .LBB16_33
	str	wzr, [x20, #304]
	b	.LBB16_3
.LBB16_21:
	ldr	w9, [x20, #752]
	ldr	w8, [x20, #456]
	cbz	w9, .LBB16_58
	cmp	w8, #1
	b.eq	.LBB16_150
	cmp	w8, #2
	b.eq	.LBB16_153
	b	.LBB16_154
.LBB16_24:
	ldr	w8, [x20, #456]
	cmp	w8, #1
	b.eq	.LBB16_61
	cmp	w8, #2
	b.eq	.LBB16_64
	b	.LBB16_65
.LBB16_26:
	mov	w19, wzr
.LBB16_27:
	ldr	x8, [sp, #48]
	ldr	w8, [x8]
	cbz	w8, .LBB16_43
	ldr	x8, [sp, #40]
	ldr	w8, [x8]
	cmp	w8, #1
	b.ge	.LBB16_321
.LBB16_29:
	sub	x0, x29, #40
	mov	w1, wzr
	stp	xzr, xzr, [x29, #-16]
	stp	xzr, xzr, [x29, #-32]
	stur	xzr, [x29, #-40]
	bl	init_wait_entry
.LBB16_30:
	sub	x1, x29, #40
	mov	x0, x27
	mov	w2, #1
	bl	prepare_to_wait_event
	ldr	x8, [sp, #48]
	ldr	w8, [x8]
	cbz	w8, .LBB16_41
	cbnz	x0, .LBB16_42
	bl	schedule
	b	.LBB16_30
.LBB16_33:
	sub	x0, x29, #40
	mov	w1, wzr
	stp	xzr, xzr, [x29, #-16]
	stp	xzr, xzr, [x29, #-32]
	stur	xzr, [x29, #-40]
	bl	init_wait_entry
	sub	x1, x29, #40
	mov	x0, x27
	mov	w2, #1
	bl	prepare_to_wait_event
	ldr	w8, [x20, #304]
	cbz	w8, .LBB16_146
.LBB16_34:
	sub	x1, x29, #40
	mov	x0, x27
	bl	finish_wait
	ldr	w8, [x20, #304]
	cbnz	w8, .LBB16_3
.LBB16_35:
	ldr	x8, [sp, #48]
	ldr	w8, [x8]
	cmp	w8, #1
	b.ne	.LBB16_172
	sub	x0, x29, #40
	mov	w1, wzr
	stp	xzr, xzr, [x29, #-16]
	stp	xzr, xzr, [x29, #-32]
	stur	xzr, [x29, #-40]
	bl	init_wait_entry
.LBB16_37:
	sub	x1, x29, #40
	mov	x0, x27
	mov	w2, #1
	bl	prepare_to_wait_event
	ldr	x8, [sp, #48]
	ldr	w8, [x8]
	cbz	w8, .LBB16_180
	ldr	w8, [x20, #304]
	cbnz	w8, .LBB16_180
	cbnz	x0, .LBB16_181
	bl	schedule
	b	.LBB16_37
.LBB16_41:
	sub	x1, x29, #40
	mov	x0, x27
	bl	finish_wait
.LBB16_42:
	ldr	x8, [sp, #40]
	ldr	w8, [x8]
	cmp	w8, #1
	b.ge	.LBB16_322
.LBB16_43:
	ldr	w8, [x20, #456]
	sub	w8, w8, #3
	cmp	w8, #1
	b.hi	.LBB16_45
	ldr	x8, [x20, #424]
	str	wzr, [x20, #768]
	str	wzr, [x20, #776]
	ldr	x1, [x20, #360]
	ldrsw	x2, [x20, #244]
	ldr	x0, [x8, #16]
	bl	memcpy
.LBB16_45:
	ldr	w8, [x26, #40]
	cmp	w8, #11
	b.hi	.LBB16_211
	lsl	w8, w25, w8
	mov	w9, #2124
	tst	w8, w9
	b.eq	.LBB16_51
	ldr	w8, [x20, #244]
	add	w9, w8, #7
	cmp	w8, #0
	csel	w9, w9, w8, lt
	cmp	w8, #8
	b.lt	.LBB16_178
	ldr	x8, [x20, #424]
	asr	w9, w9, #3
	ldr	x10, [x26, #16]
	ldr	x8, [x8, #16]
.LBB16_49:
	ldr	x11, [x10]
	ldr	x12, [x8]
	cmp	x11, x12
	b.ne	.LBB16_211
	add	x8, x8, #8
	add	x10, x10, #8
	subs	w9, w9, #1
	b.ne	.LBB16_49
	b	.LBB16_178
.LBB16_51:
	tst	w8, #0x180
	b.eq	.LBB16_211
	ldr	w8, [x20, #780]
	ldr	w9, [x20, #244]
	cbz	w8, .LBB16_174
	add	w8, w9, #7
	cmp	w9, #0
	csel	w11, w8, w9, lt
	cmp	w9, #8
	b.lt	.LBB16_178
	mov	w10, #50
	mov	w12, #34079
	movk	w12, #20971, lsl #16
	mov	w8, wzr
	mul	w9, w9, w10
	ldr	x10, [x20, #424]
	asr	w11, w11, #3
	smull	x9, w9, w12
	lsr	x12, x9, #63
	asr	x13, x9, #40
	ldr	x9, [x10, #16]
	add	w10, w13, w12
	ldr	x12, [x26, #16]
.LBB16_55:
	ldr	x13, [x12]
	ldr	x14, [x9]
	cmp	x13, x14
	cinc	w8, w8, ne
	cmp	w8, w10
	b.gt	.LBB16_209
	add	x9, x9, #8
	add	x12, x12, #8
	subs	w11, w11, #1
	b.ne	.LBB16_55
	cbnz	w8, .LBB16_211
	b	.LBB16_178
.LBB16_58:
	cmp	w8, #4
	b.ne	.LBB16_13
	ldr	x8, [sp, #48]
	ldr	w8, [x8]
	cbnz	w8, .LBB16_154
	b	.LBB16_13
.LBB16_60:
	ldr	x8, [sp, #8]
	mov	x1, x28
	ldr	x0, [x8]
	bl	_dev_info
	b	.LBB16_7
.LBB16_61:
	ldr	w2, [x20, #288]
	cbz	w2, .LBB16_64
	ldr	x8, [sp, #40]
	ldr	w8, [x8]
	cmp	w8, #1
	b.ge	.LBB16_342
.LBB16_63:
	str	wzr, [x20, #288]
	b	.LBB16_65
.LBB16_64:
	ldr	x8, [x20, #424]
	ldr	x0, [x20, #360]
	ldrsw	x2, [x20, #244]
	ldr	x1, [x8, #16]
	bl	memcpy
	ldr	x8, [x20, #432]
	ldr	x0, [x20, #352]
	ldrsw	x2, [x20, #244]
	ldr	x1, [x8, #16]
	bl	memcpy
.LBB16_65:
	mov	w8, #4
	str	x26, [x20, #448]
	ldr	w9, [x20, #300]
	str	w8, [x20, #456]
	ldp	w10, w8, [x26, #48]
	ldp	w12, w14, [x26, #56]
	add	w11, w10, #7
	cmp	w10, #0
	add	w13, w12, #7
	csel	w11, w11, w10, lt
	cmp	w12, #0
	add	w10, w9, #7
	csel	w12, w13, w12, lt
	cmp	w9, #0
	asr	w15, w12, #3
	csel	w12, w10, w9, lt
	ldr	w10, [x20, #296]
	add	w9, w15, #1
	asr	w13, w12, #3
	sub	w16, w13, #1
	cmp	w9, w13
	csinc	w9, w16, w15, ge
	sub	w15, w10, #1
	cmp	w14, w10
	csel	w10, w14, w15, lt
	cmp	w8, w10
	b.le	.LBB16_70
.LBB16_66:
	ldr	x8, [sp, #48]
	ldr	w8, [x8]
	cbz	w8, .LBB16_144
	adrp	x8, ebc_auto_task
	ldr	x0, [x8, :lo12:ebc_auto_task]
	bl	wake_up_process
	ldr	x0, [x20, #440]
	cbz	x0, .LBB16_69
.LBB16_68:
	bl	ebc_buf_release
.LBB16_69:
	ldr	x8, [x20, #448]
	str	x8, [x20, #440]
	b	.LBB16_3
.LBB16_70:
	ldr	x14, [x20, #432]
	mul	w13, w13, w8
	ldp	x16, x15, [x20, #376]
	sxtw	x13, w13
	asr	w11, w11, #3
	ldr	x14, [x14, #16]
	lsl	x0, x13, #3
	ldr	x17, [x26, #16]
	sbfx	x2, x12, #3, #29
	ldr	x1, [x20, #352]
	add	x13, x16, x0
	add	x12, x15, x0
	add	x14, x14, x0
	add	x15, x17, x0
	sxtw	x17, w11
	add	x16, x1, x0
	add	w0, w9, #1
	sxtw	x0, w0
	lsl	x1, x2, #3
	b	.LBB16_72
.LBB16_71:
	add	w8, w8, #1
	add	x12, x12, x1
	add	x13, x13, x1
	add	x14, x14, x1
	add	x15, x15, x1
	add	x16, x16, x1
	cmp	w8, w10
	b.gt	.LBB16_66
.LBB16_72:
	cmp	w11, w9
	b.gt	.LBB16_71
	mov	x2, x17
	b	.LBB16_76
.LBB16_74:
	orr	x6, x6, #0xff00000000000000
.LBB16_75:
	bic	x5, x5, x6
	and	x6, x6, x26
	add	x2, x2, #1
	orr	x5, x5, x6
	cmp	x0, x2
	str	x4, [x12, x3]
	str	x5, [x16, x3]
	b.eq	.LBB16_71
.LBB16_76:
	lsl	x3, x2, #3
	ldr	x19, [x13, x3]
	ldr	x5, [x16, x3]
	ldr	x7, [x15, x3]
	ldr	x4, [x12, x3]
	tst	x19, #0xff
	b.eq	.LBB16_78
	mov	x6, xzr
	b	.LBB16_80
.LBB16_78:
	and	x4, x4, #0xffffffffffffff00
	and	x26, x7, #0xf0
	cmp	w26, #240
	b.ne	.LBB16_103
	mov	w6, #255
.LBB16_80:
	tst	x19, #0xff00
	b.ne	.LBB16_83
	and	x4, x4, #0xffffffffffff00ff
	and	x26, x7, #0xf000
	cmp	w26, #15, lsl #12
	b.ne	.LBB16_105
	orr	x6, x6, #0xff00
.LBB16_83:
	ldr	x26, [x14, x3]
	tst	x19, #0xff0000
	b.eq	.LBB16_89
	tst	x19, #0xff000000
	b.eq	.LBB16_91
.LBB16_85:
	tst	x19, #0xff00000000
	b.eq	.LBB16_93
.LBB16_86:
	tst	x19, #0xff0000000000
	b.eq	.LBB16_95
.LBB16_87:
	tst	x19, #0xff000000000000
	b.eq	.LBB16_97
.LBB16_88:
	lsr	x19, x19, #56
	cbnz	x19, .LBB16_75
	b	.LBB16_99
.LBB16_89:
	and	x4, x4, #0xffffffffff00ffff
	and	x30, x7, #0xf00000
	cmp	x30, #3840, lsl #12
	b.ne	.LBB16_107
	orr	x6, x6, #0xff0000
	tst	x19, #0xff000000
	b.ne	.LBB16_85
.LBB16_91:
	and	x4, x4, #0xffffffff00ffffff
	and	x30, x7, #0xf0000000
	cmp	w30, w23
	b.ne	.LBB16_111
	orr	x6, x6, #0xff000000
	tst	x19, #0xff00000000
	b.ne	.LBB16_86
.LBB16_93:
	and	x4, x4, #0xffffff00ffffffff
	and	x30, x7, #0xf000000000
	cmp	x30, x24
	b.ne	.LBB16_113
	orr	x6, x6, #0xff00000000
	tst	x19, #0xff0000000000
	b.ne	.LBB16_87
.LBB16_95:
	and	x4, x4, #0xffff00ffffffffff
	and	x30, x7, #0xf00000000000
	cmp	x30, x22
	b.ne	.LBB16_115
	orr	x6, x6, #0xff0000000000
	tst	x19, #0xff000000000000
	b.ne	.LBB16_88
.LBB16_97:
	and	x4, x4, #0xff00ffffffffffff
	and	x30, x7, #0xf0000000000000
	cmp	x30, x21
	b.ne	.LBB16_117
	orr	x6, x6, #0xff000000000000
	lsr	x19, x19, #56
	cbnz	x19, .LBB16_75
.LBB16_99:
	and	x4, x4, #0xffffffffffffff
	lsr	x19, x7, #60
	cmp	x19, #15
	b.hs	.LBB16_74
	and	x7, x7, #0xf000000000000000
	mov	x19, #-2305843009213693952
	cmp	x7, x19
	b.eq	.LBB16_131
	and	x5, x5, #0xffffffffffffff
	cbnz	x7, .LBB16_132
	orr	x4, x4, #0x100000000000000
	b	.LBB16_75
.LBB16_103:
	cbnz	w26, .LBB16_119
	mov	x6, xzr
	and	x5, x5, #0xffffffffffffff00
	orr	x4, x4, #0x1
	b	.LBB16_80
.LBB16_105:
	and	x5, x5, #0xffffffffffff00ff
	cbnz	w26, .LBB16_121
	orr	x4, x4, #0x100
	b	.LBB16_83
.LBB16_107:
	and	x5, x5, #0xffffffffff00ffff
	cbz	x30, .LBB16_110
	cmp	x30, #3584, lsl #12
	b.ne	.LBB16_133
	orr	x5, x5, #0xf00000
.LBB16_110:
	orr	x4, x4, #0x10000
	tst	x19, #0xff000000
	b.ne	.LBB16_85
	b	.LBB16_91
.LBB16_111:
	cbnz	w30, .LBB16_123
	and	x5, x5, #0xffffffff00ffffff
	orr	x4, x4, #0x1000000
	tst	x19, #0xff00000000
	b.ne	.LBB16_86
	b	.LBB16_93
.LBB16_113:
	cbnz	x30, .LBB16_125
	and	x5, x5, #0xffffff00ffffffff
	orr	x4, x4, #0x100000000
	tst	x19, #0xff0000000000
	b.ne	.LBB16_87
	b	.LBB16_95
.LBB16_115:
	cbnz	x30, .LBB16_127
	and	x5, x5, #0xffff00ffffffffff
	orr	x4, x4, #0x10000000000
	tst	x19, #0xff000000000000
	b.ne	.LBB16_88
	b	.LBB16_97
.LBB16_117:
	cbnz	x30, .LBB16_129
	and	x5, x5, #0xff00ffffffffffff
	orr	x4, x4, #0x1000000000000
	lsr	x19, x19, #56
	cbnz	x19, .LBB16_75
	b	.LBB16_99
.LBB16_119:
	cmp	w26, #224
	b.ne	.LBB16_134
	and	x5, x5, #0xffffffffffffff00
	mov	x6, xzr
	orr	x5, x5, #0xf0
	orr	x4, x4, #0x1
	b	.LBB16_80
.LBB16_121:
	cmp	w26, #14, lsl #12
	b.ne	.LBB16_135
	orr	x5, x5, #0xf000
	orr	x4, x4, #0x100
	b	.LBB16_83
.LBB16_123:
	and	x5, x5, #0xffffffff00ffffff
	mov	w27, #-536870912
	cmp	w30, w27
	b.ne	.LBB16_136
	orr	x5, x5, #0xf0000000
	orr	x4, x4, #0x1000000
	b	.LBB16_137
.LBB16_125:
	and	x5, x5, #0xffffff00ffffffff
	mov	x28, #962072674304
	cmp	x30, x28
	b.ne	.LBB16_138
	orr	x5, x5, #0xf000000000
	orr	x4, x4, #0x100000000
	b	.LBB16_139
.LBB16_127:
	and	x5, x5, #0xffff00ffffffffff
	mov	x28, #246290604621824
	cmp	x30, x28
	b.ne	.LBB16_140
	orr	x5, x5, #0xf00000000000
	orr	x4, x4, #0x10000000000
	b	.LBB16_141
.LBB16_129:
	and	x5, x5, #0xff00ffffffffffff
	mov	x28, #63050394783186944
	cmp	x30, x28
	b.ne	.LBB16_142
	orr	x5, x5, #0xf0000000000000
	orr	x4, x4, #0x1000000000000
	b	.LBB16_143
.LBB16_131:
	mov	x7, #-1152921504606846976
	orr	x4, x4, #0x100000000000000
	bfxil	x7, x5, #0, #56
	mov	x5, x7
	b	.LBB16_75
.LBB16_132:
	orr	x5, x5, x7
	b	.LBB16_75
.LBB16_133:
	orr	x5, x5, x30
	tst	x19, #0xff000000
	b.ne	.LBB16_85
	b	.LBB16_91
.LBB16_134:
	and	x5, x5, #0xffffffffffffff00
	mov	x6, xzr
	orr	x5, x26, x5
	b	.LBB16_80
.LBB16_135:
	orr	x5, x5, x26
	b	.LBB16_83
.LBB16_136:
	orr	x5, x5, x30
.LBB16_137:
	adrp	x27, ebc_thread_wq
	add	x27, x27, :lo12:ebc_thread_wq
	tst	x19, #0xff00000000
	b.ne	.LBB16_86
	b	.LBB16_93
.LBB16_138:
	orr	x5, x5, x30
.LBB16_139:
	adrp	x28, .L.str.66
	add	x28, x28, :lo12:.L.str.66
	tst	x19, #0xff0000000000
	b.ne	.LBB16_87
	b	.LBB16_95
.LBB16_140:
	orr	x5, x5, x30
.LBB16_141:
	adrp	x28, .L.str.66
	add	x28, x28, :lo12:.L.str.66
	tst	x19, #0xff000000000000
	b.ne	.LBB16_88
	b	.LBB16_97
.LBB16_142:
	orr	x5, x5, x30
.LBB16_143:
	adrp	x28, .L.str.66
	add	x28, x28, :lo12:.L.str.66
	lsr	x19, x19, #56
	cbnz	x19, .LBB16_75
	b	.LBB16_99
.LBB16_144:
	mov	x0, x20
	mov	w1, #1
	str	w25, [x20, #268]
	bl	ebc_power_set
	mov	x0, x20
	mov	w1, #1
	mov	w2, wzr
	bl	ebc_lut_update
	ldr	w9, [x20, #792]
	ldr	w8, [x20, #320]
	cmp	w9, #1
	strh	w8, [x20, #272]
	b.ge	.LBB16_335
.LBB16_145:
	mov	x0, x20
	bl	ebc_frame_start
	ldr	x0, [x20, #440]
	cbnz	x0, .LBB16_68
	b	.LBB16_69
.LBB16_146:
	mov	w8, #13
.LBB16_147:
	cbnz	x0, .LBB16_35
	mov	x0, x8
	bl	schedule_timeout
	mov	x19, x0
	sub	x1, x29, #40
	mov	x0, x27
	mov	w2, #1
	bl	prepare_to_wait_event
	ldr	w9, [x20, #304]
	cmp	x19, #0
	ccmp	w9, #0, #4, eq
	csinc	x8, x19, xzr, eq
	cbnz	w9, .LBB16_34
	cbnz	x8, .LBB16_147
	b	.LBB16_34
.LBB16_150:
	ldr	w2, [x20, #288]
	cbz	w2, .LBB16_153
	ldr	x8, [sp, #40]
	ldr	w8, [x8]
	cmp	w8, #1
	b.ge	.LBB16_345
.LBB16_152:
	str	wzr, [x20, #288]
	b	.LBB16_154
.LBB16_153:
	ldr	x8, [x20, #424]
	ldr	x0, [x20, #360]
	ldrsw	x2, [x20, #244]
	ldr	x1, [x8, #16]
	bl	memcpy
	ldr	x8, [x20, #432]
	ldr	x0, [x20, #352]
	ldrsw	x2, [x20, #244]
	ldr	x1, [x8, #16]
	bl	memcpy
.LBB16_154:
	ldr	x8, [x20, #432]
	ldr	w9, [x26, #40]
	ldr	w8, [x8, #40]
	cmp	w9, w8
	b.eq	.LBB16_166
	ldr	x8, [sp, #48]
	ldr	w8, [x8]
	cbz	w8, .LBB16_166
	ldr	x8, [sp, #40]
	ldr	w8, [x8]
	cmp	w8, #1
	b.ge	.LBB16_338
.LBB16_157:
	sub	x0, x29, #40
	mov	w1, wzr
	stp	xzr, xzr, [x29, #-16]
	stp	xzr, xzr, [x29, #-32]
	stur	xzr, [x29, #-40]
	bl	init_wait_entry
.LBB16_158:
	sub	x1, x29, #40
	mov	x0, x27
	mov	w2, #1
	bl	prepare_to_wait_event
	ldr	x8, [sp, #48]
	ldr	w8, [x8]
	cbz	w8, .LBB16_164
	cbnz	x0, .LBB16_165
	bl	schedule
	b	.LBB16_158
.LBB16_161:
	mov	w9, #1
	movk	w9, #192, lsl #16
	tst	w8, w9
	b.eq	.LBB16_358
	ldr	w8, [x20, #456]
	str	x26, [x20, #432]
	sub	w9, w8, #1
	cmp	w9, #2
	b.hs	.LBB16_188
	ldr	x8, [x20, #424]
	ldr	x0, [x20, #360]
	ldrsw	x2, [x20, #244]
	ldr	x1, [x8, #16]
	bl	memcpy
	b	.LBB16_326
.LBB16_164:
	sub	x1, x29, #40
	mov	x0, x27
	bl	finish_wait
.LBB16_165:
	ldr	x8, [sp, #40]
	ldr	w8, [x8]
	cmp	w8, #1
	b.ge	.LBB16_339
.LBB16_166:
	mov	w8, #4
	str	x26, [x20, #432]
	ldp	x3, x4, [x20, #376]
	str	w8, [x20, #456]
	ldr	x0, [x20, #352]
	ldr	x1, [x20, #232]
	ldr	x2, [x26, #16]
	ldr	x5, [sp, #16]
	bl	refresh_new_image
	ldr	w8, [x20, #268]
	cbnz	w8, .LBB16_197
	mov	x0, x20
	mov	w1, #1
	str	w25, [x20, #268]
	bl	ebc_power_set
	ldr	w1, [x26, #40]
	mov	x0, x20
	mov	w2, wzr
	bl	ebc_lut_update
	ldr	w9, [x20, #792]
	ldr	w8, [x20, #320]
	cmp	w9, #1
	strh	w8, [x20, #272]
	b.ge	.LBB16_336
.LBB16_168:
	ldp	x4, x0, [x20, #384]
	ldp	x1, x2, [x20, #352]
	ldr	w8, [x20, #204]
	ldr	x3, [x20, #376]
	cbz	w8, .LBB16_185
	ldr	x5, [sp, #16]
	mov	w6, #1
	bl	get_overlay_image2
	ldr	w8, [x20, #276]
	cbz	w8, .LBB16_186
.LBB16_170:
	ldp	x1, x2, [x20, #352]
	ldp	x3, x4, [x20, #376]
	ldr	w8, [x20, #204]
	ldr	x0, [x20, #400]
	cbz	w8, .LBB16_195
	ldr	x5, [sp, #16]
	mov	w6, #1
	bl	get_overlay_image2
	b	.LBB16_196
.LBB16_172:
	bl	ebc_get_dsp_list_enum_num
	cbnz	w0, .LBB16_3
	bl	ebc_get_osd_list_enum_num
	cbnz	w0, .LBB16_3
	b	.LBB16_330
.LBB16_174:
	add	w8, w9, #7
	cmp	w9, #0
	csel	w10, w8, w9, lt
	cmp	w9, #8
	b.lt	.LBB16_178
	ldr	x8, [x20, #424]
	asr	w9, w10, #3
	ldr	x10, [x26, #16]
	ldr	x8, [x8, #16]
.LBB16_176:
	ldr	x11, [x10]
	ldr	x12, [x8]
	cmp	x11, x12
	b.ne	.LBB16_211
	add	x8, x8, #8
	add	x10, x10, #8
	subs	w9, w9, #1
	b.ne	.LBB16_176
.LBB16_178:
	ldr	x8, [sp, #40]
	ldr	w8, [x8]
	cmp	w8, #1
	b.ge	.LBB16_323
.LBB16_179:
	str	x26, [x20, #432]
	b	.LBB16_355
.LBB16_180:
	sub	x1, x29, #40
	mov	x0, x27
	bl	finish_wait
.LBB16_181:
	bl	ebc_get_dsp_list_enum_num
	cbnz	w0, .LBB16_3
	bl	ebc_get_osd_list_enum_num
	cbnz	w0, .LBB16_3
	ldr	x8, [sp, #48]
	ldr	w8, [x8]
	cbz	w8, .LBB16_330
	ldr	w8, [x20, #304]
	cbnz	w8, .LBB16_341
	b	.LBB16_331
.LBB16_185:
	ldr	x5, [sp, #16]
	mov	w6, #1
	bl	get_overlay_image
	ldr	w8, [x20, #276]
	cbnz	w8, .LBB16_170
.LBB16_186:
	ldr	w8, [x20, #792]
	str	wzr, [x20, #268]
	str	w25, [x20, #756]
	cmp	w8, #1
	b.lt	.LBB16_197
	ldr	x8, [sp, #8]
	adrp	x1, .L.str.94
	adrp	x2, .L__func__.ebc_overlay_bg_frame_start
	add	x1, x1, :lo12:.L.str.94
	add	x2, x2, :lo12:.L__func__.ebc_overlay_bg_frame_start
	ldr	x0, [x8]
	bl	_dev_info
	b	.LBB16_197
.LBB16_188:
	cmp	w8, #4
	b.ne	.LBB16_202
	ldr	x8, [sp, #48]
	ldr	w8, [x8]
	cbz	w8, .LBB16_202
	ldr	x8, [sp, #40]
	ldr	w8, [x8]
	cmp	w8, #1
	b.ge	.LBB16_361
.LBB16_191:
	sub	x0, x29, #40
	mov	w1, wzr
	stp	xzr, xzr, [x29, #-16]
	stp	xzr, xzr, [x29, #-32]
	stur	xzr, [x29, #-40]
	bl	init_wait_entry
.LBB16_192:
	sub	x1, x29, #40
	mov	x0, x27
	mov	w2, #1
	bl	prepare_to_wait_event
	ldr	x8, [sp, #48]
	ldr	w8, [x8]
	cbz	w8, .LBB16_324
	cbnz	x0, .LBB16_325
	bl	schedule
	b	.LBB16_192
.LBB16_195:
	ldr	x5, [sp, #16]
	mov	w6, #1
	bl	get_overlay_image
.LBB16_196:
	ldp	w8, w9, [x20, #172]
	ldr	w10, [x20, #180]
	mov	w3, #1
	ldr	x0, [x20, #40]
	str	wzr, [x20, #112]
	ldr	x1, [x20, #72]
	ldrsw	x2, [x20, #248]
	add	w8, w9, w8
	add	w19, w8, w10
	bl	dma_sync_single_for_device
	ldr	x0, [x20, #48]
	mov	w1, wzr
	mov	w2, wzr
	mov	w3, wzr
	mov	w4, wzr
	ldr	x8, [x0, #88]
	blr	x8
	ldr	x0, [x20, #48]
	mov	w2, wzr
	ldr	w1, [x20, #72]
	ldr	x8, [x0, #96]
	blr	x8
	ldr	x0, [x20, #48]
	mov	w1, w19
	mov	w2, wzr
	ldr	x8, [x0, #144]
	blr	x8
	ldr	x0, [x20, #48]
	mov	w1, #1
	ldr	x8, [x0, #128]
	blr	x8
	ldr	w8, [x20, #112]
	sub	w8, w25, w8
	str	w8, [x20, #112]
.LBB16_197:
	ldr	x8, [x20, #432]
	ldr	w8, [x8, #40]
	cmp	w8, #23
	b.hi	.LBB16_199
	mov	w9, #1
	lsl	w8, w25, w8
	movk	w9, #192, lsl #16
	tst	w8, w9
	b.ne	.LBB16_355
.LBB16_199:
	ldr	x8, [sp, #48]
	ldr	w8, [x8]
	cbz	w8, .LBB16_355
	ldr	w8, [x20, #792]
	str	wzr, [x20, #756]
	cmp	w8, #1
	b.ge	.LBB16_346
.LBB16_201:
	adrp	x8, jiffies
	ldr	x19, [x8, :lo12:jiffies]
	ldrb	w8, [x20, #272]
	add	w8, w8, w8, lsl #1
	lsl	w0, w8, #2
	bl	__msecs_to_jiffies
	add	x1, x0, x19
	ldr	x0, [sp]
	b	.LBB16_354
.LBB16_202:
	ldr	x8, [x20, #424]
	ldr	w9, [x26, #40]
	ldr	w8, [x8, #40]
	cmp	w9, w8
	b.eq	.LBB16_313
	ldr	x8, [sp, #48]
	ldr	w8, [x8]
	cbz	w8, .LBB16_313
	ldr	x8, [sp, #40]
	ldr	w8, [x8]
	cmp	w8, #1
	b.ge	.LBB16_363
.LBB16_205:
	sub	x0, x29, #40
	mov	w1, wzr
	stp	xzr, xzr, [x29, #-16]
	stp	xzr, xzr, [x29, #-32]
	stur	xzr, [x29, #-40]
	bl	init_wait_entry
.LBB16_206:
	sub	x1, x29, #40
	mov	x0, x27
	mov	w2, #1
	bl	prepare_to_wait_event
	ldr	x8, [sp, #48]
	ldr	w8, [x8]
	cbz	w8, .LBB16_324
	cbnz	x0, .LBB16_325
	bl	schedule
	b	.LBB16_206
.LBB16_209:
	ldr	x8, [sp, #40]
	ldr	w8, [x8]
	cmp	w8, #1
	b.ge	.LBB16_359
.LBB16_210:
	mov	w19, #1
.LBB16_211:
	ldr	w8, [x20, #772]
	cbz	w8, .LBB16_216
	ldr	w8, [x26, #40]
	sub	w8, w8, #12
	cmp	w8, #2
	b.hi	.LBB16_216
	ldr	w8, [x20, #776]
	cbz	w8, .LBB16_217
	ldr	w8, [x20, #768]
	cbz	w8, .LBB16_218
.LBB16_215:
	ldr	x8, [x20, #424]
	ldr	x1, [x20, #360]
	ldr	x0, [x8, #16]
	b	.LBB16_220
.LBB16_216:
	str	wzr, [x20, #776]
	str	wzr, [x20, #768]
	b	.LBB16_221
.LBB16_217:
	ldr	x0, [x20, #368]
	mov	w1, #248
	ldrsw	x2, [x20, #244]
	bl	memset
	str	w25, [x20, #776]
	ldr	w8, [x20, #768]
	cbnz	w8, .LBB16_215
.LBB16_218:
	ldr	w8, [x26, #40]
	and	w8, w8, #0xfffffffe
	cmp	w8, #12
	b.ne	.LBB16_221
	ldr	x8, [x20, #424]
	ldr	x0, [x20, #360]
	ldr	x1, [x8, #16]
.LBB16_220:
	ldrsw	x2, [x20, #244]
	bl	memcpy
.LBB16_221:
	cmp	w19, #0
	mov	x0, x20
	cinc	w8, w25, ne
	mov	w1, #1
	cset	w19, ne
	str	w8, [sp, #28]
	bl	ebc_power_set
	str	x26, [x20, #432]
	ldr	w1, [x26, #40]
	cmp	w1, #12
	b.eq	.LBB16_226
	cmp	w1, #14
	b.eq	.LBB16_228
	cmp	w1, #13
	b.ne	.LBB16_230
	ldr	w8, [x20, #772]
	cbz	w8, .LBB16_230
	mov	x0, x20
	mov	w1, #13
	mov	w2, w19
	bl	ebc_lut_update
	ldr	w8, [x20, #320]
	ubfx	w8, w8, #1, #7
	sub	w9, w8, #1
	cmp	w8, #8
	mov	w8, #7
	csel	w8, w8, w9, hi
	mov	w9, #2
	strb	w9, [x20, #272]
	str	w8, [x20, #852]
	b	.LBB16_232
.LBB16_226:
	ldr	w8, [x20, #772]
	cbz	w8, .LBB16_230
	mov	x0, x20
	mov	w1, #12
	mov	w2, w19
	bl	ebc_lut_update
	ldrb	w8, [x20, #320]
	str	w25, [x20, #852]
	lsr	w8, w8, #1
	strb	w8, [x20, #272]
	b	.LBB16_232
.LBB16_228:
	ldr	w8, [x20, #772]
	cbz	w8, .LBB16_230
	mov	x0, x20
	mov	w1, #12
	mov	w2, w19
	bl	ebc_lut_update
	ldr	w8, [x20, #320]
	str	wzr, [x20, #852]
	strb	w8, [x20, #272]
	b	.LBB16_232
.LBB16_230:
	mov	x0, x20
	mov	w2, w19
	bl	ebc_lut_update
.LBB16_231:
	ldr	w8, [x20, #320]
	strb	w8, [x20, #272]
.LBB16_232:
	ldr	x8, [sp, #40]
	ldr	w8, [x8]
	cmp	w8, #1
	b.ge	.LBB16_290
.LBB16_233:
	ldr	w8, [sp, #28]
	mov	x0, x20
	str	w25, [x20, #268]
	str	w8, [x20, #456]
	bl	ebc_frame_start
	adrp	x8, jiffies
	ldr	x8, [x8, :lo12:jiffies]
	ldr	x0, [sp, #32]
	add	x1, x8, #750
	bl	mod_timer
	ldr	w10, [x26, #40]
	sub	w8, w10, #12
	cmp	w8, #2
	b.hi	.LBB16_260
	ldr	w8, [x20, #772]
	cbz	w8, .LBB16_260
	ldr	w8, [x20, #776]
	cbz	w8, .LBB16_260
	ldr	x8, [sp, #40]
	ldr	w8, [x8]
	cmp	w8, #1
	b.ge	.LBB16_299
.LBB16_237:
	ldr	w8, [x20, #300]
	and	w11, w10, #0xfffffffe
	ldr	w9, [x20, #296]
	cmp	w11, #12
	ldr	x10, [x20, #368]
	b.ne	.LBB16_248
	cmp	w9, #1
	b.lt	.LBB16_258
	ldr	x15, [x20, #432]
	mov	w12, wzr
	mov	w11, wzr
	mov	w13, wzr
	ldr	x14, [x20, #360]
	ldr	x15, [x15, #16]
	ldr	w16, [x20, #852]
	b	.LBB16_241
.LBB16_240:
	add	w13, w13, #1
	add	w12, w12, w8
	cmp	w13, w9
	b.eq	.LBB16_259
.LBB16_241:
	cmp	w8, #1
	b.lt	.LBB16_240
	mov	w0, w12
	mov	x17, x8
	b	.LBB16_245
.LBB16_243:
	strb	w25, [x10, x0]
.LBB16_244:
	subs	x17, x17, #1
	add	w0, w0, #1
	b.eq	.LBB16_240
.LBB16_245:
	sxtw	x0, w0
	ldrb	w1, [x15, x0]
	ldrb	w2, [x14, x0]
	cmp	w2, w1
	b.eq	.LBB16_244
	cbz	w16, .LBB16_243
	and	w3, w2, #0xf
	sub	w4, w2, #1
	cmp	w3, #1
	csel	w4, w1, w4, eq
	csinc	w5, w11, wzr, eq
	cmp	w16, w3
	and	w3, w2, #0xf0
	csinc	w2, w1, w2, le
	csinc	w11, w11, wzr, le
	cmp	w3, w1
	csel	w11, w5, w11, eq
	csel	w1, w4, w2, eq
	strb	w1, [x14, x0]
	b	.LBB16_243
.LBB16_248:
	cmp	w9, #1
	b.lt	.LBB16_258
	ldp	x14, x15, [x20, #424]
	mov	w12, wzr
	mov	w11, wzr
	mov	w13, wzr
	ldr	w16, [x20, #852]
	ldr	x14, [x14, #16]
	ldr	x15, [x15, #16]
	b	.LBB16_251
.LBB16_250:
	add	w13, w13, #1
	add	w12, w12, w8
	cmp	w13, w9
	b.eq	.LBB16_259
.LBB16_251:
	cmp	w8, #1
	b.lt	.LBB16_250
	mov	w0, w12
	mov	x17, x8
	b	.LBB16_255
.LBB16_253:
	strb	w25, [x10, x0]
.LBB16_254:
	subs	x17, x17, #1
	add	w0, w0, #1
	b.eq	.LBB16_250
.LBB16_255:
	sxtw	x0, w0
	ldrb	w1, [x15, x0]
	ldrb	w2, [x14, x0]
	cmp	w2, w1
	b.eq	.LBB16_254
	cbz	w16, .LBB16_253
	and	w3, w2, #0xf
	sub	w4, w2, #1
	cmp	w3, #1
	csel	w4, w1, w4, eq
	csinc	w5, w11, wzr, eq
	cmp	w16, w3
	and	w3, w2, #0xf0
	csinc	w2, w1, w2, le
	csinc	w11, w11, wzr, le
	cmp	w3, w1
	csel	w11, w5, w11, eq
	csel	w1, w4, w2, eq
	strb	w1, [x14, x0]
	b	.LBB16_253
.LBB16_258:
	mov	w11, wzr
.LBB16_259:
	str	w11, [x20, #768]
.LBB16_260:
	ldr	x8, [sp, #48]
	ldr	w9, [x8]
	ldr	x8, [sp, #40]
	ldr	w8, [x8]
	cbz	w9, .LBB16_267
	cmp	w8, #1
	b.ge	.LBB16_295
.LBB16_262:
	sub	x0, x29, #40
	mov	w1, wzr
	stp	xzr, xzr, [x29, #-16]
	stp	xzr, xzr, [x29, #-32]
	stur	xzr, [x29, #-40]
	bl	init_wait_entry
.LBB16_263:
	sub	x1, x29, #40
	mov	x0, x27
	mov	w2, #1
	bl	prepare_to_wait_event
	ldr	x8, [sp, #48]
	ldr	w8, [x8]
	cbz	w8, .LBB16_266
	cbnz	x0, .LBB16_268
	bl	schedule
	b	.LBB16_263
.LBB16_266:
	sub	x1, x29, #40
	mov	x0, x27
	bl	finish_wait
	b	.LBB16_268
.LBB16_267:
	tbz	w8, #31, .LBB16_297
.LBB16_268:
	ldr	w8, [x20, #288]
	cbnz	w8, .LBB16_300
	ldr	w8, [x26, #40]
	sub	w8, w8, #12
	cmp	w8, #2
	b.hi	.LBB16_353
	bl	ebc_get_dsp_list_enum_num
	cbnz	w0, .LBB16_353
	ldr	w8, [x20, #772]
	cbz	w8, .LBB16_353
	ldr	w8, [x20, #768]
	cbz	w8, .LBB16_279
	ldr	w8, [x20, #304]
	cbnz	w8, .LBB16_276
	sub	x0, x29, #40
	mov	w1, wzr
	stp	xzr, xzr, [x29, #-16]
	stp	xzr, xzr, [x29, #-32]
	stur	xzr, [x29, #-40]
	bl	init_wait_entry
	sub	x1, x29, #40
	mov	x0, x27
	mov	w2, #1
	bl	prepare_to_wait_event
	ldr	w8, [x20, #304]
	cbz	w8, .LBB16_286
.LBB16_275:
	sub	x1, x29, #40
	mov	x0, x27
	bl	finish_wait
.LBB16_276:
	bl	ebc_get_dsp_list_enum_num
	cbnz	w0, .LBB16_353
	ldr	x8, [sp, #40]
	ldr	w8, [x8]
	cmp	w8, #1
	b.ge	.LBB16_296
.LBB16_278:
	ldr	x8, [x20, #424]
	ldr	x1, [x20, #360]
	ldrsw	x2, [x20, #244]
	ldr	x0, [x8, #16]
	bl	memcpy
	b	.LBB16_232
.LBB16_279:
	ldr	w8, [x20, #776]
	cbz	w8, .LBB16_353
	ldr	w8, [x20, #304]
	cbnz	w8, .LBB16_283
	sub	x0, x29, #40
	mov	w1, wzr
	stp	xzr, xzr, [x29, #-16]
	stp	xzr, xzr, [x29, #-32]
	stur	xzr, [x29, #-40]
	bl	init_wait_entry
	sub	x1, x29, #40
	mov	x0, x27
	mov	w2, #1
	bl	prepare_to_wait_event
	ldr	w8, [x20, #304]
	cbz	w8, .LBB16_291
.LBB16_282:
	sub	x1, x29, #40
	mov	x0, x27
	bl	finish_wait
.LBB16_283:
	bl	ebc_get_dsp_list_enum_num
	cbnz	w0, .LBB16_353
	ldr	x8, [sp, #40]
	ldr	w8, [x8]
	cmp	w8, #1
	b.ge	.LBB16_298
.LBB16_285:
	ldr	x8, [x20, #432]
	ldr	w0, [x20, #300]
	ldr	w1, [x20, #296]
	ldr	x2, [x20, #368]
	ldr	x3, [x8, #16]
	bl	update_repair_buf_ghost
	ldr	x8, [x20, #424]
	ldr	x1, [x20, #368]
	ldrsw	x2, [x20, #244]
	ldr	x0, [x8, #16]
	bl	memcpy
	str	wzr, [x20, #776]
	ldr	w8, [x26, #40]
	and	w8, w8, #0xfffffffe
	cmp	w8, #12
	b.eq	.LBB16_231
	b	.LBB16_232
.LBB16_286:
	mov	w8, #3
.LBB16_287:
	cbnz	x0, .LBB16_276
	mov	x0, x8
	bl	schedule_timeout
	mov	x19, x0
	sub	x1, x29, #40
	mov	x0, x27
	mov	w2, #1
	bl	prepare_to_wait_event
	ldr	w9, [x20, #304]
	cmp	x19, #0
	ccmp	w9, #0, #4, eq
	csinc	x8, x19, xzr, eq
	cbnz	w9, .LBB16_275
	cbnz	x8, .LBB16_287
	b	.LBB16_275
.LBB16_290:
	ldr	x8, [x20, #432]
	adrp	x1, .L.str.76
	ldr	x0, [x20, #312]
	add	x1, x1, :lo12:.L.str.76
	ldrb	w3, [x20, #272]
	ldr	w2, [x8, #40]
	bl	_dev_info
	b	.LBB16_233
.LBB16_291:
	mov	w8, #3
.LBB16_292:
	cbnz	x0, .LBB16_283
	mov	x0, x8
	bl	schedule_timeout
	mov	x19, x0
	sub	x1, x29, #40
	mov	x0, x27
	mov	w2, #1
	bl	prepare_to_wait_event
	ldr	w9, [x20, #304]
	cmp	x19, #0
	ccmp	w9, #0, #4, eq
	csinc	x8, x19, xzr, eq
	cbnz	w9, .LBB16_282
	cbnz	x8, .LBB16_292
	b	.LBB16_282
.LBB16_295:
	ldr	x8, [sp, #8]
	adrp	x1, .L.str.78
	add	x1, x1, :lo12:.L.str.78
	ldr	x0, [x8]
	bl	_dev_info
	ldr	x8, [sp, #48]
	ldr	w8, [x8]
	cbnz	w8, .LBB16_262
	b	.LBB16_268
.LBB16_296:
	ldr	x8, [sp, #8]
	adrp	x1, .L.str.82
	add	x1, x1, :lo12:.L.str.82
	ldr	x0, [x8]
	bl	_dev_info
	b	.LBB16_278
.LBB16_297:
	ldr	x8, [sp, #8]
	adrp	x1, .L.str.79
	add	x1, x1, :lo12:.L.str.79
	ldr	x0, [x8]
	bl	_dev_info
	b	.LBB16_268
.LBB16_298:
	ldr	x8, [sp, #8]
	adrp	x1, .L.str.83
	add	x1, x1, :lo12:.L.str.83
	ldr	x0, [x8]
	bl	_dev_info
	b	.LBB16_285
.LBB16_299:
	ldr	x8, [sp, #8]
	adrp	x1, .L.str.77
	add	x1, x1, :lo12:.L.str.77
	ldr	x0, [x8]
	bl	_dev_info
	ldr	w10, [x26, #40]
	b	.LBB16_237
.LBB16_300:
	ldr	x8, [sp, #40]
	ldr	w8, [x8]
	cmp	w8, #1
	b.ge	.LBB16_347
	ldr	w8, [x20, #772]
	cbz	w8, .LBB16_348
.LBB16_302:
	ldr	w8, [x26, #40]
	sub	w8, w8, #12
	cmp	w8, #2
	b.hi	.LBB16_348
	ldr	x8, [sp, #40]
	ldr	w8, [x8]
	cmp	w8, #1
	b.ge	.LBB16_362
	ldr	w8, [x20, #776]
	cbz	w8, .LBB16_306
.LBB16_305:
	ldr	x8, [x20, #432]
	ldr	w0, [x20, #300]
	ldr	w1, [x20, #296]
	ldr	x2, [x20, #368]
	ldr	x3, [x8, #16]
	bl	update_repair_buf_ghost
.LBB16_306:
	ldr	w8, [x20, #244]
	ldr	x1, [x20, #368]
	cmp	w8, #1
	b.lt	.LBB16_343
	ldr	x9, [x20, #352]
	b	.LBB16_310
.LBB16_308:
	strb	w10, [x1]
.LBB16_309:
	subs	x8, x8, #1
	add	x1, x1, #1
	add	x9, x9, #1
	b.eq	.LBB16_337
.LBB16_310:
	ldrb	w11, [x1]
	ldrb	w10, [x9]
	cmp	w11, #248
	b.eq	.LBB16_308
	cmp	w11, #1
	b.ne	.LBB16_309
	mvn	w10, w10
	and	w10, w10, #0xfffffff0
	b	.LBB16_308
.LBB16_313:
	ldr	w8, [x20, #300]
	ldr	w9, [x20, #296]
	add	w10, w8, #7
	cmp	w8, #0
	csel	w13, w10, w8, lt
	cmp	w9, #1
	b.lt	.LBB16_327
	mov	w10, wzr
	ldr	x11, [x20, #376]
	ldr	x12, [x26, #16]
	asr	w13, w13, #3
	ldr	x14, [x20, #352]
	b	.LBB16_316
.LBB16_315:
	add	w10, w10, #1
	cmp	w10, w9
	b.eq	.LBB16_327
.LBB16_316:
	cmp	w8, #8
	b.lt	.LBB16_315
	mov	w15, w13
	b	.LBB16_319
.LBB16_318:
	add	x14, x14, #8
	subs	w15, w15, #1
	b.eq	.LBB16_315
.LBB16_319:
	ldr	x16, [x12], #8
	ldr	x17, [x14]
	ldr	x0, [x11], #8
	cmp	x16, x17
	b.eq	.LBB16_318
	tst	x0, #0xff
	mov	w1, #255
	csel	x1, x1, xzr, eq
	tst	x0, #0xff00
	orr	x2, x1, #0xff00
	csel	x1, x2, x1, eq
	tst	x0, #0xff0000
	orr	x2, x1, #0xff0000
	csel	x1, x2, x1, eq
	tst	x0, #0xff000000
	orr	x2, x1, #0xff000000
	csel	x1, x2, x1, eq
	tst	x0, #0xff00000000
	orr	x2, x1, #0xff00000000
	csel	x1, x2, x1, eq
	tst	x0, #0xff0000000000
	orr	x2, x1, #0xff0000000000
	csel	x1, x2, x1, eq
	tst	x0, #0xff000000000000
	orr	x2, x1, #0xff000000000000
	lsr	x0, x0, #56
	csel	x1, x2, x1, eq
	cmp	x0, #0
	orr	x2, x1, #0xff00000000000000
	csel	x0, x2, x1, eq
	bic	x17, x17, x0
	and	x16, x0, x16
	orr	x16, x17, x16
	str	x16, [x14]
	b	.LBB16_318
.LBB16_321:
	ldr	x8, [sp, #8]
	adrp	x1, .L.str.69
	add	x1, x1, :lo12:.L.str.69
	ldr	x0, [x8]
	bl	_dev_info
	ldr	x8, [sp, #48]
	ldr	w8, [x8]
	cbnz	w8, .LBB16_29
	b	.LBB16_42
.LBB16_322:
	ldr	x8, [sp, #8]
	adrp	x1, .L.str.70
	add	x1, x1, :lo12:.L.str.70
	ldr	x0, [x8]
	bl	_dev_info
	b	.LBB16_43
.LBB16_323:
	ldr	x8, [sp, #8]
	adrp	x1, .L.str.74
	add	x1, x1, :lo12:.L.str.74
	ldr	x0, [x8]
	bl	_dev_info
	b	.LBB16_179
.LBB16_324:
	sub	x1, x29, #40
	mov	x0, x27
	bl	finish_wait
.LBB16_325:
	ldr	x8, [sp, #40]
	ldr	w8, [x8]
	cmp	w8, #1
	b.ge	.LBB16_360
.LBB16_326:
	ldr	x8, [x20, #432]
	ldr	x0, [x20, #352]
	ldrsw	x2, [x20, #244]
	ldr	x1, [x8, #16]
	bl	memcpy
.LBB16_327:
	ldr	w8, [x20, #268]
	mov	w9, #3
	str	w9, [x20, #456]
	cbnz	w8, .LBB16_355
	mov	x0, x20
	mov	w1, #1
	str	w25, [x20, #268]
	bl	ebc_power_set
	ldr	w1, [x26, #40]
	mov	x0, x20
	mov	w2, wzr
	bl	ebc_lut_update
	ldr	w9, [x20, #792]
	ldr	w8, [x20, #320]
	cmp	w9, #1
	strh	w8, [x20, #272]
	b.ge	.LBB16_357
.LBB16_329:
	mov	x0, x20
	bl	ebc_frame_start
	b	.LBB16_355
.LBB16_330:
	mov	x0, x20
	mov	w1, wzr
	bl	ebc_power_set
	ldr	w8, [x20, #304]
	cbnz	w8, .LBB16_341
.LBB16_331:
	sub	x0, x29, #40
	mov	w1, wzr
	stp	xzr, xzr, [x29, #-16]
	stp	xzr, xzr, [x29, #-32]
	stur	xzr, [x29, #-40]
	bl	init_wait_entry
.LBB16_332:
	sub	x1, x29, #40
	mov	x0, x27
	mov	w2, #1
	bl	prepare_to_wait_event
	ldr	w8, [x20, #304]
	cbnz	w8, .LBB16_340
	cbnz	x0, .LBB16_341
	bl	schedule
	b	.LBB16_332
.LBB16_335:
	ldr	x9, [sp, #8]
	adrp	x1, .L.str.68
	and	w2, w8, #0xff
	ubfx	w3, w8, #8, #8
	add	x1, x1, :lo12:.L.str.68
	ldr	x0, [x9]
	bl	_dev_info
	b	.LBB16_145
.LBB16_336:
	ldr	x9, [x20, #432]
	adrp	x1, .L.str.71
	ldr	x0, [x20, #312]
	and	w3, w8, #0xff
	add	x1, x1, :lo12:.L.str.71
	ldr	w2, [x9, #40]
	bl	_dev_info
	b	.LBB16_168
.LBB16_337:
	ldr	x1, [x20, #368]
	ldr	w8, [x20, #244]
	b	.LBB16_344
.LBB16_338:
	ldr	x8, [sp, #8]
	adrp	x1, .L.str.69
	add	x1, x1, :lo12:.L.str.69
	ldr	x0, [x8]
	bl	_dev_info
	ldr	x8, [sp, #48]
	ldr	w8, [x8]
	cbnz	w8, .LBB16_157
	b	.LBB16_165
.LBB16_339:
	ldr	x8, [sp, #8]
	adrp	x1, .L.str.70
	add	x1, x1, :lo12:.L.str.70
	ldr	x0, [x8]
	bl	_dev_info
	b	.LBB16_166
.LBB16_340:
	sub	x1, x29, #40
	mov	x0, x27
	bl	finish_wait
.LBB16_341:
	str	wzr, [x20, #304]
	b	.LBB16_3
.LBB16_342:
	ldr	x8, [sp, #8]
	adrp	x1, .L.str.67
	add	x1, x1, :lo12:.L.str.67
	ldr	x0, [x8]
	bl	_dev_info
	b	.LBB16_63
.LBB16_343:
.LBB16_344:
	ldr	x0, [x20, #360]
	sxtw	x2, w8
	bl	memcpy
	ldr	x8, [x20, #432]
	ldr	x0, [x20, #352]
	ldrsw	x2, [x20, #244]
	ldr	x1, [x8, #16]
	bl	memcpy
	str	wzr, [x20, #776]
	str	wzr, [x20, #768]
	b	.LBB16_353
.LBB16_345:
	ldr	x8, [sp, #8]
	adrp	x1, .L.str.67
	add	x1, x1, :lo12:.L.str.67
	ldr	x0, [x8]
	bl	_dev_info
	b	.LBB16_152
.LBB16_346:
	ldr	x8, [sp, #8]
	adrp	x1, .L.str.72
	add	x1, x1, :lo12:.L.str.72
	ldr	x0, [x8]
	bl	_dev_info
	b	.LBB16_201
.LBB16_347:
	ldr	x8, [sp, #8]
	adrp	x1, .L.str.80
	add	x1, x1, :lo12:.L.str.80
	ldr	x0, [x8]
	bl	_dev_info
	ldr	w8, [x20, #772]
	cbnz	w8, .LBB16_302
.LBB16_348:
	ldr	x8, [x20, #424]
	ldr	x0, [x20, #360]
	ldrsw	x2, [x20, #244]
	ldr	x1, [x8, #16]
	bl	memcpy
	ldr	x8, [x20, #432]
	ldr	x0, [x20, #352]
	ldrsw	x2, [x20, #244]
	ldr	x1, [x8, #16]
	bl	memcpy
	ldr	w8, [x20, #244]
	cmp	w8, #1
	b.lt	.LBB16_353
	ldrb	w11, [x20, #272]
	ldrb	w12, [x20, #288]
	ldr	x9, [x20, #376]
	sub	w11, w11, w12
	ldp	x12, x10, [x20, #352]
	b	.LBB16_351
.LBB16_350:
	add	x9, x9, #1
	add	x10, x10, #1
	add	x12, x12, #1
	subs	w8, w8, #1
	b.eq	.LBB16_353
.LBB16_351:
	ldrb	w13, [x10]
	ldrb	w14, [x12]
	cmp	w13, w14
	b.eq	.LBB16_350
	strb	w11, [x9]
	b	.LBB16_350
.LBB16_353:
	adrp	x8, jiffies
	mov	w9, #335544320
	ldr	x8, [x8, :lo12:jiffies]
	ldr	x0, [sp, #32]
	add	x1, x8, x9
.LBB16_354:
	bl	mod_timer
.LBB16_355:
	ldr	w8, [x20, #660]
	cbz	w8, .LBB16_1
	ldr	x0, [x20, #424]
	bl	ebc_buf_release
	b	.LBB16_2
.LBB16_357:
	ldr	x9, [sp, #8]
	adrp	x1, .L.str.73
	and	w2, w8, #0xff
	add	x1, x1, :lo12:.L.str.73
	ldr	x0, [x9]
	bl	_dev_info
	b	.LBB16_329
.LBB16_358:
	ldr	x8, [sp, #8]
	adrp	x1, .L.str.84
	add	x1, x1, :lo12:.L.str.84
	ldr	x0, [x8]
	bl	_dev_err
	b	.LBB16_7
.LBB16_359:
	ldr	x8, [sp, #8]
	adrp	x1, .L.str.75
	add	x1, x1, :lo12:.L.str.75
	ldr	x0, [x8]
	bl	_dev_info
	b	.LBB16_210
.LBB16_360:
	ldr	x8, [sp, #8]
	adrp	x1, .L.str.70
	add	x1, x1, :lo12:.L.str.70
	ldr	x0, [x8]
	bl	_dev_info
	b	.LBB16_326
.LBB16_361:
	ldr	x8, [sp, #8]
	adrp	x1, .L.str.69
	add	x1, x1, :lo12:.L.str.69
	ldr	x0, [x8]
	bl	_dev_info
	ldr	x8, [sp, #48]
	ldr	w8, [x8]
	cbnz	w8, .LBB16_191
	b	.LBB16_325
.LBB16_362:
	ldr	x8, [sp, #8]
	adrp	x1, .L.str.81
	add	x1, x1, :lo12:.L.str.81
	ldr	x0, [x8]
	bl	_dev_info
	ldr	w8, [x20, #776]
	cbnz	w8, .LBB16_305
	b	.LBB16_306
.LBB16_363:
	ldr	x8, [sp, #8]
	adrp	x1, .L.str.69
	add	x1, x1, :lo12:.L.str.69
	ldr	x0, [x8]
	bl	_dev_info
	ldr	x8, [sp, #48]
	ldr	w8, [x8]
	cbnz	w8, .LBB16_205
	b	.LBB16_325
.Lfunc_end16:
	.size	ebc_thread, .Lfunc_end16-ebc_thread

	.p2align	2
	.type	get_overlay_image2,@function
get_overlay_image2:
	sub	sp, sp, #128
	str	x30, [x18], #8
	adrp	x8, global_ebc
	stp	x26, x25, [sp, #64]
	stp	x29, x30, [sp, #32]
	add	x29, sp, #32
	stp	x24, x23, [sp, #80]
	mov	x23, x2
	ldr	x8, [x8, :lo12:global_ebc]
	stp	x22, x21, [sp, #96]
	stp	x20, x19, [sp, #112]
	mov	x19, x5
	mov	x22, x4
	mov	x21, x3
	ldp	w25, w10, [x8, #116]
	mov	x24, x1
	cmp	w6, #3
	stp	x28, x27, [sp, #48]
	stur	x0, [x29, #-8]
	lsr	w20, w25, #3
	b.eq	.LBB17_3
	add	x8, x19, #60
	cmp	w6, #2
	str	x8, [sp, #8]
	b.ne	.LBB17_4
	cmp	w10, #0
	mov	w27, wzr
	cinc	w8, w10, lt
	asr	w10, w8, #1
	b	.LBB17_5
.LBB17_3:
	cmp	w10, #0
	cinc	w8, w10, lt
	asr	w27, w8, #1
	mul	w8, w27, w20
	mul	w9, w27, w25
	sbfiz	x8, x8, #3, #32
	add	x21, x21, x9
	add	x24, x24, x8
	add	x23, x23, x8
	add	x22, x22, x9
	add	x8, x19, #64
	str	x8, [sp, #8]
	b	.LBB17_5
.LBB17_4:
	mov	w27, wzr
.LBB17_5:
	lsr	w26, w25, #2
	subs	w8, w10, w27
	ldur	x9, [x29, #-8]
	mov	w1, wzr
	mul	w28, w27, w26
	stur	w10, [x29, #-12]
	mul	w8, w8, w26
	add	x0, x9, w28, sxtw
	sxtw	x2, w8
	bl	memset
	ldur	w11, [x29, #-12]
	mov	w2, wzr
	cmp	w11, w27
	b.le	.LBB17_59
	cmp	w20, #1
	mov	w2, wzr
	csinc	w9, w20, wzr, hi
	lsl	w8, w26, #1
	lsl	x9, x9, #3
	mov	w10, #56
	b	.LBB17_10
.LBB17_7:
	add	x12, x24, x11
	add	x13, x23, x11
	add	x24, x12, x17
	add	x12, x22, x11
	add	x11, x21, x11
	add	x23, x13, x17
	add	x22, x12, x17
	add	x21, x11, x17
.LBB17_8:
	ldur	w11, [x29, #-12]
.LBB17_9:
	add	w27, w27, #2
	add	w28, w28, w8
	cmp	w27, w11
	b.ge	.LBB17_59
.LBB17_10:
	cmp	w25, #8
	b.lo	.LBB17_9
	ldur	x12, [x29, #-8]
	mov	x11, xzr
	add	x12, x12, w28, sxtw
	mov	x13, x12
	b	.LBB17_15
.LBB17_12:
	str	x14, [x23, x11]
.LBB17_13:
	mov	w2, #1
	str	w16, [x13]
.LBB17_14:
	add	x13, x13, #4
	add	x11, x11, #8
	cmp	x9, x11
	b.eq	.LBB17_34
.LBB17_15:
	ldr	x15, [x24, x11]
	ldr	x14, [x23, x11]
	cmp	x15, x14
	b.eq	.LBB17_14
	eor	x0, x14, x15
	tst	x0, #0xff
	b.eq	.LBB17_18
	ldrb	w16, [x22, x11]
	lsl	w2, w14, #2
	ldrb	w1, [x21, x11]
	and	x2, x2, #0x3e0
	bfxil	x2, x15, #3, #5
	mov	x3, x14
	bfxil	x3, x15, #0, #8
	add	x17, x19, x16, lsl #3
	cmp	w16, #0
	cinc	x16, x10, ne
	add	w4, w1, #1
	ldr	x17, [x17, #120]
	ldrb	w16, [x19, x16]
	add	x17, x17, x1, lsl #10
	cmp	w16, w4, uxtb
	ldrb	w16, [x17, x2]
	cset	w17, eq
	csel	x14, x3, x14, eq
	csinc	w1, wzr, w1, eq
	strb	w1, [x21, x11]
	b	.LBB17_19
.LBB17_18:
	mov	w16, wzr
	mov	w17, wzr
.LBB17_19:
	add	x1, x21, x11
	tst	x0, #0xff00
	b.eq	.LBB17_21
	add	x2, x22, x11
	ldrb	w4, [x1, #1]
	lsr	x5, x14, #6
	lsr	x6, x15, #8
	and	x5, x5, #0x3e0
	ldrb	w2, [x2, #1]
	bfxil	x5, x15, #11, #5
	add	x3, x19, x2, lsl #3
	cmp	w2, #0
	cinc	x2, x10, ne
	ldr	x3, [x3, #120]
	ldrb	w2, [x19, x2]
	add	x3, x3, x4, lsl #10
	ldrb	w3, [x3, x5]
	add	w5, w4, #1
	cmp	w2, w5, uxtb
	mov	x2, x14
	bfi	x2, x6, #8, #8
	cset	w5, eq
	csinc	w4, wzr, w4, eq
	orr	w17, w5, w17
	orr	w16, w16, w3, lsl #4
	csel	x14, x2, x14, eq
	strb	w4, [x1, #1]
.LBB17_21:
	tst	x0, #0xff0000
	b.eq	.LBB17_23
	add	x2, x22, x11
	ldrb	w4, [x1, #2]
	lsr	x5, x14, #14
	lsr	x6, x15, #16
	and	x5, x5, #0x3e0
	ldrb	w2, [x2, #2]
	bfxil	x5, x15, #19, #5
	add	x3, x19, x2, lsl #3
	cmp	w2, #0
	cinc	x2, x10, ne
	ldr	x3, [x3, #120]
	ldrb	w2, [x19, x2]
	add	x3, x3, x4, lsl #10
	ldrb	w3, [x3, x5]
	add	w5, w4, #1
	cmp	w2, w5, uxtb
	mov	x2, x14
	bfi	x2, x6, #16, #8
	cset	w5, eq
	csinc	w4, wzr, w4, eq
	orr	w17, w5, w17
	orr	w16, w16, w3, lsl #8
	csel	x14, x2, x14, eq
	strb	w4, [x1, #2]
.LBB17_23:
	add	x1, x21, x11
	tst	x0, #0xff000000
	b.eq	.LBB17_25
	add	x2, x22, x11
	ldrb	w4, [x1, #3]
	lsr	x5, x14, #22
	lsr	x6, x15, #24
	and	x5, x5, #0x3e0
	ldrb	w2, [x2, #3]
	bfxil	x5, x15, #27, #5
	add	x3, x19, x2, lsl #3
	cmp	w2, #0
	cinc	x2, x10, ne
	ldr	x3, [x3, #120]
	ldrb	w2, [x19, x2]
	add	x3, x3, x4, lsl #10
	ldrb	w3, [x3, x5]
	add	w5, w4, #1
	cmp	w2, w5, uxtb
	mov	x2, x14
	bfi	x2, x6, #24, #8
	cset	w5, eq
	csinc	w4, wzr, w4, eq
	orr	w17, w5, w17
	orr	w16, w16, w3, lsl #12
	csel	x14, x2, x14, eq
	strb	w4, [x1, #3]
.LBB17_25:
	tst	x0, #0xff00000000
	b.eq	.LBB17_27
	add	x2, x22, x11
	ldrb	w4, [x1, #4]
	lsr	x5, x14, #30
	lsr	x6, x15, #32
	and	x5, x5, #0x3e0
	ldrb	w2, [x2, #4]
	bfxil	x5, x15, #35, #5
	add	x3, x19, x2, lsl #3
	cmp	w2, #0
	cinc	x2, x10, ne
	ldr	x3, [x3, #120]
	ldrb	w2, [x19, x2]
	add	x3, x3, x4, lsl #10
	ldrb	w3, [x3, x5]
	add	w5, w4, #1
	cmp	w2, w5, uxtb
	mov	x2, x14
	bfi	x2, x6, #32, #8
	cset	w5, eq
	csinc	w4, wzr, w4, eq
	orr	w17, w5, w17
	orr	w16, w16, w3, lsl #16
	csel	x14, x2, x14, eq
	strb	w4, [x1, #4]
.LBB17_27:
	add	x1, x21, x11
	tst	x0, #0xff0000000000
	b.eq	.LBB17_29
	add	x2, x22, x11
	ldrb	w4, [x1, #5]
	lsr	x5, x14, #38
	lsr	x6, x15, #40
	and	x5, x5, #0x3e0
	ldrb	w2, [x2, #5]
	bfxil	x5, x15, #43, #5
	add	x3, x19, x2, lsl #3
	cmp	w2, #0
	cinc	x2, x10, ne
	ldr	x3, [x3, #120]
	ldrb	w2, [x19, x2]
	add	x3, x3, x4, lsl #10
	ldrb	w3, [x3, x5]
	add	w5, w4, #1
	cmp	w2, w5, uxtb
	mov	x2, x14
	bfi	x2, x6, #40, #8
	cset	w5, eq
	csinc	w4, wzr, w4, eq
	orr	w17, w5, w17
	orr	w16, w16, w3, lsl #20
	csel	x14, x2, x14, eq
	strb	w4, [x1, #5]
.LBB17_29:
	tst	x0, #0xff000000000000
	b.eq	.LBB17_31
	add	x2, x22, x11
	ldrb	w4, [x1, #6]
	lsr	x5, x14, #46
	lsr	x6, x15, #48
	and	x5, x5, #0x3e0
	ldrb	w2, [x2, #6]
	bfxil	x5, x15, #51, #5
	add	x3, x19, x2, lsl #3
	cmp	w2, #0
	cinc	x2, x10, ne
	ldr	x3, [x3, #120]
	ldrb	w2, [x19, x2]
	add	x3, x3, x4, lsl #10
	ldrb	w3, [x3, x5]
	add	w5, w4, #1
	cmp	w2, w5, uxtb
	mov	x2, x14
	bfi	x2, x6, #48, #8
	cset	w5, eq
	csinc	w4, wzr, w4, eq
	orr	w17, w5, w17
	orr	w16, w16, w3, lsl #24
	csel	x14, x2, x14, eq
	strb	w4, [x1, #6]
.LBB17_31:
	lsr	x0, x0, #56
	cbnz	x0, .LBB17_33
	cbnz	w17, .LBB17_12
	b	.LBB17_13
.LBB17_33:
	add	x0, x22, x11
	add	x1, x21, x11
	lsr	x4, x14, #54
	and	x4, x4, #0x3e0
	ldrb	w0, [x0, #7]
	bfxil	x4, x15, #59, #5
	bfxil	x15, x14, #0, #56
	add	x2, x19, x0, lsl #3
	cmp	w0, #0
	ldrb	w0, [x1, #7]
	cinc	x3, x10, ne
	ldr	x2, [x2, #120]
	ldrb	w3, [x19, x3]
	add	x2, x2, x0, lsl #10
	ldrb	w2, [x2, x4]
	add	w4, w0, #1
	cmp	w3, w4, uxtb
	cset	w3, eq
	csinc	w0, wzr, w0, eq
	orr	w17, w3, w17
	csel	x14, x15, x14, eq
	orr	w16, w16, w2, lsl #28
	strb	w0, [x1, #7]
	tbnz	w17, #0, .LBB17_12
	b	.LBB17_13
.LBB17_34:
	add	x13, x24, x11
	add	x14, x23, x11
	add	x15, x22, x11
	add	x16, x21, x11
	cmp	w25, #8
	b.hs	.LBB17_36
	mov	x22, x15
	mov	x21, x16
	mov	x23, x14
	mov	x24, x13
	b	.LBB17_8
.LBB17_36:
	mov	x17, xzr
	b	.LBB17_40
.LBB17_37:
	str	x0, [x14, x17]
.LBB17_38:
	ldr	w0, [x12]
	orr	w0, w0, w2
	mov	w2, #1
	str	w0, [x12]
.LBB17_39:
	add	x12, x12, #4
	add	x17, x17, #8
	cmp	x9, x17
	b.eq	.LBB17_7
.LBB17_40:
	ldr	x1, [x13, x17]
	ldr	x0, [x14, x17]
	cmp	x1, x0
	b.eq	.LBB17_39
	eor	x4, x0, x1
	tst	x4, #0xff
	b.eq	.LBB17_43
	ldrb	w2, [x15, x17]
	lsl	w6, w0, #2
	ldrb	w5, [x16, x17]
	mov	x7, x0
	bfxil	x7, x1, #0, #8
	add	x3, x19, x2, lsl #3
	cmp	w2, #0
	ldr	x2, [x3, #120]
	and	x3, x6, #0x3e0
	cinc	x6, x10, ne
	bfxil	x3, x1, #3, #5
	add	x2, x2, x5, lsl #10
	ldrb	w6, [x19, x6]
	ldrb	w2, [x2, x3]
	add	w3, w5, #1
	cmp	w6, w3, uxtb
	cset	w3, eq
	lsl	w2, w2, #2
	csel	x0, x7, x0, eq
	csinc	w5, wzr, w5, eq
	strb	w5, [x16, x17]
	b	.LBB17_44
.LBB17_43:
	mov	w3, wzr
	mov	w2, wzr
.LBB17_44:
	add	x5, x16, x17
	tst	x4, #0xff00
	b.eq	.LBB17_46
	add	x6, x15, x17
	ldrb	w20, [x5, #1]
	lsr	x26, x0, #6
	lsr	x30, x1, #8
	and	x26, x26, #0x3e0
	ldrb	w6, [x6, #1]
	bfxil	x26, x1, #11, #5
	add	x7, x19, x6, lsl #3
	cmp	w6, #0
	cinc	x6, x10, ne
	ldr	x7, [x7, #120]
	ldrb	w6, [x19, x6]
	add	x7, x7, x20, lsl #10
	ldrb	w7, [x7, x26]
	add	w26, w20, #1
	cmp	w6, w26, uxtb
	mov	x6, x0
	bfi	x6, x30, #8, #8
	cset	w26, eq
	csinc	w20, wzr, w20, eq
	csel	x0, x6, x0, eq
	orr	w2, w2, w7, lsl #6
	orr	w3, w26, w3
	strb	w20, [x5, #1]
.LBB17_46:
	tst	x4, #0xff0000
	b.eq	.LBB17_48
	add	x6, x15, x17
	ldrb	w20, [x5, #2]
	lsr	x26, x0, #14
	lsr	x30, x1, #16
	and	x26, x26, #0x3e0
	ldrb	w6, [x6, #2]
	bfxil	x26, x1, #19, #5
	add	x7, x19, x6, lsl #3
	cmp	w6, #0
	cinc	x6, x10, ne
	ldr	x7, [x7, #120]
	ldrb	w6, [x19, x6]
	add	x7, x7, x20, lsl #10
	ldrb	w7, [x7, x26]
	add	w26, w20, #1
	cmp	w6, w26, uxtb
	mov	x6, x0
	bfi	x6, x30, #16, #8
	cset	w26, eq
	csinc	w20, wzr, w20, eq
	csel	x0, x6, x0, eq
	orr	w2, w2, w7, lsl #10
	orr	w3, w26, w3
	strb	w20, [x5, #2]
.LBB17_48:
	add	x5, x16, x17
	tst	x4, #0xff000000
	b.eq	.LBB17_50
	add	x6, x15, x17
	ldrb	w20, [x5, #3]
	lsr	x26, x0, #22
	lsr	x30, x1, #24
	and	x26, x26, #0x3e0
	ldrb	w6, [x6, #3]
	bfxil	x26, x1, #27, #5
	add	x7, x19, x6, lsl #3
	cmp	w6, #0
	cinc	x6, x10, ne
	ldr	x7, [x7, #120]
	ldrb	w6, [x19, x6]
	add	x7, x7, x20, lsl #10
	ldrb	w7, [x7, x26]
	add	w26, w20, #1
	cmp	w6, w26, uxtb
	mov	x6, x0
	bfi	x6, x30, #24, #8
	cset	w26, eq
	csinc	w20, wzr, w20, eq
	csel	x0, x6, x0, eq
	orr	w2, w2, w7, lsl #14
	orr	w3, w26, w3
	strb	w20, [x5, #3]
.LBB17_50:
	tst	x4, #0xff00000000
	b.eq	.LBB17_52
	add	x6, x15, x17
	ldrb	w20, [x5, #4]
	lsr	x26, x0, #30
	lsr	x30, x1, #32
	and	x26, x26, #0x3e0
	ldrb	w6, [x6, #4]
	bfxil	x26, x1, #35, #5
	add	x7, x19, x6, lsl #3
	cmp	w6, #0
	cinc	x6, x10, ne
	ldr	x7, [x7, #120]
	ldrb	w6, [x19, x6]
	add	x7, x7, x20, lsl #10
	ldrb	w7, [x7, x26]
	add	w26, w20, #1
	cmp	w6, w26, uxtb
	mov	x6, x0
	bfi	x6, x30, #32, #8
	cset	w26, eq
	csinc	w20, wzr, w20, eq
	csel	x0, x6, x0, eq
	orr	w2, w2, w7, lsl #18
	orr	w3, w26, w3
	strb	w20, [x5, #4]
.LBB17_52:
	add	x5, x16, x17
	tst	x4, #0xff0000000000
	b.eq	.LBB17_54
	add	x6, x15, x17
	ldrb	w20, [x5, #5]
	lsr	x26, x0, #38
	lsr	x30, x1, #40
	and	x26, x26, #0x3e0
	ldrb	w6, [x6, #5]
	bfxil	x26, x1, #43, #5
	add	x7, x19, x6, lsl #3
	cmp	w6, #0
	cinc	x6, x10, ne
	ldr	x7, [x7, #120]
	ldrb	w6, [x19, x6]
	add	x7, x7, x20, lsl #10
	ldrb	w7, [x7, x26]
	add	w26, w20, #1
	cmp	w6, w26, uxtb
	mov	x6, x0
	bfi	x6, x30, #40, #8
	cset	w26, eq
	csinc	w20, wzr, w20, eq
	csel	x0, x6, x0, eq
	orr	w2, w2, w7, lsl #22
	orr	w3, w26, w3
	strb	w20, [x5, #5]
.LBB17_54:
	tst	x4, #0xff000000000000
	b.eq	.LBB17_56
	add	x6, x15, x17
	ldrb	w20, [x5, #6]
	lsr	x26, x0, #46
	lsr	x30, x1, #48
	and	x26, x26, #0x3e0
	ldrb	w6, [x6, #6]
	bfxil	x26, x1, #51, #5
	add	x7, x19, x6, lsl #3
	cmp	w6, #0
	cinc	x6, x10, ne
	ldr	x7, [x7, #120]
	ldrb	w6, [x19, x6]
	add	x7, x7, x20, lsl #10
	ldrb	w7, [x7, x26]
	add	w26, w20, #1
	cmp	w6, w26, uxtb
	mov	x6, x0
	bfi	x6, x30, #48, #8
	cset	w26, eq
	csinc	w20, wzr, w20, eq
	csel	x0, x6, x0, eq
	orr	w2, w2, w7, lsl #26
	orr	w3, w26, w3
	strb	w20, [x5, #6]
.LBB17_56:
	lsr	x4, x4, #56
	cbnz	x4, .LBB17_58
	cbnz	w3, .LBB17_37
	b	.LBB17_38
.LBB17_58:
	add	x4, x15, x17
	add	x5, x16, x17
	lsr	x20, x0, #54
	and	x20, x20, #0x3e0
	ldrb	w4, [x4, #7]
	bfxil	x20, x1, #59, #5
	bfxil	x1, x0, #0, #56
	add	x6, x19, x4, lsl #3
	cmp	w4, #0
	ldrb	w4, [x5, #7]
	cinc	x7, x10, ne
	ldr	x6, [x6, #120]
	ldrb	w7, [x19, x7]
	add	x6, x6, x4, lsl #10
	ldrb	w6, [x6, x20]
	add	w20, w4, #1
	cmp	w7, w20, uxtb
	cset	w7, eq
	csinc	w4, wzr, w4, eq
	orr	w3, w7, w3
	csel	x0, x1, x0, eq
	orr	w2, w2, w6, lsl #30
	strb	w4, [x5, #7]
	tbnz	w3, #0, .LBB17_37
	b	.LBB17_38
.LBB17_59:
	ldr	x8, [sp, #8]
	ldp	x20, x19, [sp, #112]
	ldp	x22, x21, [sp, #96]
	str	w2, [x8]
	ldp	x24, x23, [sp, #80]
	ldp	x26, x25, [sp, #64]
	ldp	x28, x27, [sp, #48]
	ldp	x29, x30, [sp, #32]
	ldr	x30, [x18, #-8]!
	add	sp, sp, #128
	ret
.Lfunc_end17:
	.size	get_overlay_image2, .Lfunc_end17-get_overlay_image2

	.p2align	2
	.type	get_overlay_image,@function
get_overlay_image:
	sub	sp, sp, #112
	str	x30, [x18], #8
	adrp	x8, global_ebc
	stp	x28, x27, [sp, #32]
	stp	x24, x23, [sp, #64]
	mov	x23, x1
	stp	x22, x21, [sp, #80]
	mov	x21, x3
	ldr	x27, [x8, :lo12:global_ebc]
	stp	x20, x19, [sp, #96]
	mov	x19, x5
	mov	x20, x4
	mov	x22, x2
	mov	x24, x0
	ldp	w11, w8, [x27, #116]
	cmp	w6, #3
	stp	x29, x30, [sp, #16]
	stp	x26, x25, [sp, #48]
	add	x29, sp, #16
	lsr	w12, w11, #3
	b.eq	.LBB18_3
	add	x9, x19, #60
	cmp	w6, #2
	str	x9, [sp, #8]
	b.ne	.LBB18_4
	cmp	w8, #0
	mov	w26, wzr
	cinc	w9, w8, lt
	asr	w28, w9, #1
	b	.LBB18_6
.LBB18_3:
	cmp	w8, #0
	cinc	w9, w8, lt
	asr	w26, w9, #1
	mul	w9, w26, w12
	mul	w10, w26, w11
	sbfiz	x9, x9, #3, #32
	add	x21, x21, x10
	add	x20, x20, x10
	add	x23, x23, x9
	add	x22, x22, x9
	add	x9, x19, #64
	str	x9, [sp, #8]
	b	.LBB18_5
.LBB18_4:
	mov	w26, wzr
.LBB18_5:
	mov	w28, w8
.LBB18_6:
	ldr	w9, [x27, #196]
	lsr	w25, w11, #2
	stp	w12, w11, [sp]
	cbz	w9, .LBB18_36
	sub	w8, w8, w28
	sub	w9, w28, w26
	mov	w1, wzr
	mul	w8, w8, w25
	mul	w9, w9, w25
	add	x0, x24, x8
	sxtw	x2, w9
	bl	memset
	ldr	w8, [x27, #120]
	mvn	w9, w26
	add	w8, w8, w9
	mul	w8, w8, w25
	neg	w25, w25
	add	x24, x24, x8
	cmp	w28, w26
	b.le	.LBB18_37
.LBB18_8:
	ldp	w9, w7, [sp]
	mov	w16, wzr
	sxtw	x8, w25
	mov	w11, #56
	cmp	w9, #1
	csinc	w10, w9, wzr, hi
	add	x9, x24, #1
	lsl	x10, x10, #3
	b	.LBB18_11
.LBB18_9:
	add	x20, x20, x12
	add	x23, x23, x12
	add	x22, x22, x12
	add	x21, x21, x12
.LBB18_10:
	add	w26, w26, #1
	add	x9, x9, x8
	cmp	w26, w28
	b.eq	.LBB18_38
.LBB18_11:
	cmp	w7, #8
	b.lo	.LBB18_10
	mov	x12, xzr
	mov	x13, x9
	b	.LBB18_16
.LBB18_13:
	str	x14, [x22, x12]
.LBB18_14:
	mov	w16, #1
	strb	w0, [x13]
.LBB18_15:
	add	x12, x12, #8
	add	x13, x13, #2
	cmp	x10, x12
	b.eq	.LBB18_9
.LBB18_16:
	ldr	x15, [x23, x12]
	ldr	x14, [x22, x12]
	cmp	x15, x14
	b.eq	.LBB18_15
	eor	x16, x14, x15
	tst	x16, #0xff
	b.eq	.LBB18_19
	ldrb	w17, [x20, x12]
	lsl	w2, w14, #2
	ldrb	w1, [x21, x12]
	and	x2, x2, #0x3e0
	bfxil	x2, x15, #3, #5
	mov	x3, x14
	bfxil	x3, x15, #0, #8
	add	x0, x19, x17, lsl #3
	cmp	w17, #0
	cinc	x17, x11, ne
	add	w4, w1, #1
	ldr	x0, [x0, #120]
	ldrb	w17, [x19, x17]
	add	x0, x0, x1, lsl #10
	cmp	w17, w4, uxtb
	ldrb	w0, [x0, x2]
	cset	w17, eq
	csel	x14, x3, x14, eq
	csinc	w1, wzr, w1, eq
	strb	w1, [x21, x12]
	b	.LBB18_20
.LBB18_19:
	mov	w0, wzr
	mov	w17, wzr
.LBB18_20:
	add	x1, x21, x12
	tst	x16, #0xff00
	b.eq	.LBB18_22
	add	x2, x20, x12
	ldrb	w4, [x1, #1]
	lsr	x5, x14, #6
	lsr	x6, x15, #8
	and	x5, x5, #0x3e0
	ldrb	w2, [x2, #1]
	bfxil	x5, x15, #11, #5
	add	x3, x19, x2, lsl #3
	cmp	w2, #0
	cinc	x2, x11, ne
	ldr	x3, [x3, #120]
	ldrb	w2, [x19, x2]
	add	x3, x3, x4, lsl #10
	ldrb	w3, [x3, x5]
	add	w5, w4, #1
	cmp	w2, w5, uxtb
	mov	x2, x14
	bfi	x2, x6, #8, #8
	cset	w5, eq
	csinc	w4, wzr, w4, eq
	orr	w17, w5, w17
	orr	w0, w0, w3, lsl #2
	csel	x14, x2, x14, eq
	strb	w4, [x1, #1]
.LBB18_22:
	tst	x16, #0xff0000
	b.eq	.LBB18_24
	add	x2, x20, x12
	ldrb	w4, [x1, #2]
	lsr	x5, x14, #14
	lsr	x6, x15, #16
	and	x5, x5, #0x3e0
	ldrb	w2, [x2, #2]
	bfxil	x5, x15, #19, #5
	add	x3, x19, x2, lsl #3
	cmp	w2, #0
	cinc	x2, x11, ne
	ldr	x3, [x3, #120]
	ldrb	w2, [x19, x2]
	add	x3, x3, x4, lsl #10
	ldrb	w3, [x3, x5]
	add	w5, w4, #1
	cmp	w2, w5, uxtb
	mov	x2, x14
	bfi	x2, x6, #16, #8
	cset	w5, eq
	csinc	w4, wzr, w4, eq
	orr	w17, w5, w17
	orr	w0, w0, w3, lsl #4
	csel	x14, x2, x14, eq
	strb	w4, [x1, #2]
.LBB18_24:
	add	x1, x21, x12
	tst	x16, #0xff000000
	b.eq	.LBB18_26
	add	x2, x20, x12
	ldrb	w4, [x1, #3]
	lsr	x5, x14, #22
	lsr	x6, x15, #24
	and	x5, x5, #0x3e0
	ldrb	w2, [x2, #3]
	bfxil	x5, x15, #27, #5
	add	x3, x19, x2, lsl #3
	cmp	w2, #0
	cinc	x2, x11, ne
	ldr	x3, [x3, #120]
	ldrb	w2, [x19, x2]
	add	x3, x3, x4, lsl #10
	ldrb	w3, [x3, x5]
	add	w5, w4, #1
	cmp	w2, w5, uxtb
	mov	x2, x14
	bfi	x2, x6, #24, #8
	cset	w5, eq
	csinc	w4, wzr, w4, eq
	orr	w17, w5, w17
	orr	w0, w0, w3, lsl #6
	csel	x14, x2, x14, eq
	strb	w4, [x1, #3]
.LBB18_26:
	tst	x16, #0xff00000000
	sturb	w0, [x13, #-1]
	b.eq	.LBB18_28
	add	x0, x20, x12
	ldrb	w3, [x1, #4]
	lsr	x4, x14, #30
	lsr	x5, x15, #32
	and	x4, x4, #0x3e0
	ldrb	w0, [x0, #4]
	bfxil	x4, x15, #35, #5
	add	w6, w3, #1
	cmp	w0, #0
	add	x2, x19, x0, lsl #3
	cinc	x0, x11, ne
	ldr	x2, [x2, #120]
	ldrb	w0, [x19, x0]
	add	x2, x2, x3, lsl #10
	cmp	w0, w6, uxtb
	mov	x6, x14
	ldrb	w0, [x2, x4]
	cset	w2, eq
	bfi	x6, x5, #32, #8
	csinc	w3, wzr, w3, eq
	orr	w17, w2, w17
	csel	x14, x6, x14, eq
	strb	w3, [x1, #4]
	b	.LBB18_29
.LBB18_28:
	mov	w0, wzr
.LBB18_29:
	add	x1, x21, x12
	tst	x16, #0xff0000000000
	b.eq	.LBB18_31
	add	x2, x20, x12
	ldrb	w4, [x1, #5]
	lsr	x5, x14, #38
	lsr	x6, x15, #40
	and	x5, x5, #0x3e0
	ldrb	w2, [x2, #5]
	bfxil	x5, x15, #43, #5
	add	x3, x19, x2, lsl #3
	cmp	w2, #0
	cinc	x2, x11, ne
	ldr	x3, [x3, #120]
	ldrb	w2, [x19, x2]
	add	x3, x3, x4, lsl #10
	ldrb	w3, [x3, x5]
	add	w5, w4, #1
	cmp	w2, w5, uxtb
	mov	x2, x14
	bfi	x2, x6, #40, #8
	cset	w5, eq
	csinc	w4, wzr, w4, eq
	orr	w17, w5, w17
	orr	w0, w0, w3, lsl #2
	csel	x14, x2, x14, eq
	strb	w4, [x1, #5]
.LBB18_31:
	tst	x16, #0xff000000000000
	b.eq	.LBB18_33
	add	x2, x20, x12
	ldrb	w4, [x1, #6]
	lsr	x5, x14, #46
	lsr	x6, x15, #48
	and	x5, x5, #0x3e0
	ldrb	w2, [x2, #6]
	bfxil	x5, x15, #51, #5
	add	x3, x19, x2, lsl #3
	cmp	w2, #0
	cinc	x2, x11, ne
	ldr	x3, [x3, #120]
	ldrb	w2, [x19, x2]
	add	x3, x3, x4, lsl #10
	ldrb	w3, [x3, x5]
	add	w5, w4, #1
	cmp	w2, w5, uxtb
	mov	x2, x14
	bfi	x2, x6, #48, #8
	cset	w5, eq
	csinc	w4, wzr, w4, eq
	orr	w17, w5, w17
	orr	w0, w0, w3, lsl #4
	csel	x14, x2, x14, eq
	strb	w4, [x1, #6]
.LBB18_33:
	lsr	x16, x16, #56
	cbnz	x16, .LBB18_35
	cbnz	w17, .LBB18_13
	b	.LBB18_14
.LBB18_35:
	add	x16, x20, x12
	add	x1, x21, x12
	lsr	x4, x14, #54
	and	x4, x4, #0x3e0
	ldrb	w16, [x16, #7]
	bfxil	x4, x15, #59, #5
	bfxil	x15, x14, #0, #56
	add	x2, x19, x16, lsl #3
	cmp	w16, #0
	ldrb	w16, [x1, #7]
	cinc	x3, x11, ne
	ldr	x2, [x2, #120]
	ldrb	w3, [x19, x3]
	add	x2, x2, x16, lsl #10
	ldrb	w2, [x2, x4]
	add	w4, w16, #1
	cmp	w3, w4, uxtb
	cset	w3, eq
	csinc	w16, wzr, w16, eq
	orr	w17, w3, w17
	csel	x14, x15, x14, eq
	orr	w0, w0, w2, lsl #6
	strb	w16, [x1, #7]
	tbnz	w17, #0, .LBB18_13
	b	.LBB18_14
.LBB18_36:
	sub	w8, w28, w26
	mul	w9, w26, w25
	mov	w1, wzr
	mul	w8, w8, w25
	add	x24, x24, w9, sxtw
	sxtw	x2, w8
	mov	x0, x24
	bl	memset
	cmp	w28, w26
	b.gt	.LBB18_8
.LBB18_37:
	mov	w16, wzr
.LBB18_38:
	ldr	x8, [sp, #8]
	ldp	x20, x19, [sp, #96]
	ldp	x22, x21, [sp, #80]
	str	w16, [x8]
	ldp	x24, x23, [sp, #64]
	ldp	x26, x25, [sp, #48]
	ldp	x28, x27, [sp, #32]
	ldp	x29, x30, [sp, #16]
	ldr	x30, [x18, #-8]!
	add	sp, sp, #112
	ret
.Lfunc_end18:
	.size	get_overlay_image, .Lfunc_end18-get_overlay_image

	.p2align	2
	.type	get_overlay_image_area2,@function
get_overlay_image_area2:
	sub	sp, sp, #160
	str	x30, [x18], #8
	ldr	x9, [x5, #232]
	stp	x29, x30, [sp, #64]
	ldp	w11, w10, [x5, #80]
	stp	x28, x27, [sp, #80]
	ldp	w12, w8, [x9, #48]
	ldp	w13, w14, [x9, #56]
	add	w15, w10, #7
	stp	x26, x25, [sp, #96]
	stp	x24, x23, [sp, #112]
	add	w9, w12, #7
	cmp	w12, #0
	csel	w12, w9, w12, lt
	add	w9, w13, #7
	cmp	w13, #0
	stp	x22, x21, [sp, #128]
	csel	w9, w9, w13, lt
	cmp	w10, #0
	asr	w13, w9, #3
	csel	w9, w15, w10, lt
	add	w10, w13, #1
	asr	w9, w9, #3
	sub	w15, w9, #1
	cmp	w10, w9
	csinc	w10, w15, w13, ge
	sub	w13, w11, #1
	cmp	w14, w11
	stp	x20, x19, [sp, #144]
	csel	w11, w14, w13, lt
	stp	x3, x0, [sp, #48]
	cmp	w8, w11
	b.le	.LBB19_2
.LBB19_1:
	ldp	x20, x19, [sp, #144]
	ldp	x22, x21, [sp, #128]
	ldp	x24, x23, [sp, #112]
	ldp	x26, x25, [sp, #96]
	ldp	x28, x27, [sp, #80]
	ldp	x29, x30, [sp, #64]
	ldr	x30, [x18, #-8]!
	add	sp, sp, #160
	ret
.LBB19_2:
	adrp	x13, global_ebc
	add	w15, w10, #1
	sxtw	x17, w15
	mov	w6, #1
	ldr	x14, [x13, :lo12:global_ebc]
	asr	w13, w12, #3
	sbfiz	x15, x13, #3, #32
	sxtw	x16, w13
	add	x0, x1, x15
	add	x15, x2, x15
	ldr	w12, [x14, #116]
	str	x14, [sp, #40]
	mul	w14, w8, w9
	sbfiz	x3, x13, #2, #32
	str	x15, [sp, #16]
	lsl	w15, w13, #3
	mul	w12, w12, w8
	stp	x0, x3, [sp, #24]
	str	w15, [sp, #12]
	ldr	x15, [sp, #56]
	lsr	w12, w12, #2
	add	x4, x15, x12
	sub	x12, x17, x16
	str	x12, [sp]
	b	.LBB19_4
.LBB19_3:
	add	w8, w8, #1
	add	w14, w14, w9
	cmp	w8, w11
	b.gt	.LBB19_1
.LBB19_4:
	tbnz	w8, #0, .LBB19_6
	ldr	x12, [sp, #40]
	ldr	x15, [sp, #56]
	ldr	w12, [x12, #116]
	mul	w12, w12, w8
	lsr	w12, w12, #2
	add	x4, x15, x12
.LBB19_6:
	cmp	w13, w10
	b.gt	.LBB19_3
	ldr	x15, [sp, #24]
	sbfiz	x12, x14, #3, #32
	ldr	w16, [x5, #84]
	mov	w21, #4
	mov	w22, #8
	mov	w23, #12
	add	x7, x15, x12
	ldr	x15, [sp, #16]
	mov	w25, #16
	mov	w26, #20
	mov	w27, #24
	mov	w28, #28
	add	x19, x15, x12
	and	w12, w8, #0x1
	lsl	w20, w12, #1
	mul	w16, w16, w8
	ldr	x15, [sp, #48]
	bfi	w21, w12, #1, #1
	bfi	w22, w12, #1, #1
	bfi	w23, w12, #1, #1
	bfi	w25, w12, #1, #1
	bfi	w26, w12, #1, #1
	bfi	w27, w12, #1, #1
	bfi	w28, w12, #1, #1
	ldr	x12, [sp, #32]
	add	x24, x15, w16, sxtw
	ldr	x30, [sp]
	ldr	w1, [sp, #12]
	add	x29, x4, x12
	b	.LBB19_10
.LBB19_8:
	ldr	w12, [x29]
	orr	w12, w12, w17
	str	w12, [x29]
.LBB19_9:
	add	x7, x7, #8
	add	x19, x19, #8
	add	x29, x29, #4
	add	w1, w1, #8
	subs	x30, x30, #1
	b.eq	.LBB19_3
.LBB19_10:
	ldr	x3, [x7]
	ldr	x16, [x19]
	cmp	x3, x16
	b.eq	.LBB19_9
	add	x0, x24, w1, sxtw
	str	w6, [x5, #60]
	eor	x12, x16, x3
	and	x15, x12, #0xff
	ldrb	w17, [x0]
	cmp	x15, #0
	ccmp	w17, #0, #0, ne
	b.eq	.LBB19_13
	mov	w17, wzr
	tst	x12, #0xff00
	b.ne	.LBB19_14
	b	.LBB19_16
.LBB19_13:
	lsl	w15, w16, #2
	ldr	x17, [x5, #120]
	and	x15, x15, #0x3e0
	bfxil	x15, x3, #3, #5
	ldrb	w15, [x17, x15]
	strb	w6, [x0]
	lsl	w17, w15, w20
	tst	x12, #0xff00
	b.eq	.LBB19_16
.LBB19_14:
	ldrb	w15, [x0, #1]
	cbnz	w15, .LBB19_16
	lsr	x15, x16, #6
	ldr	x2, [x5, #120]
	and	x15, x15, #0x3e0
	bfxil	x15, x3, #11, #5
	ldrb	w15, [x2, x15]
	strb	w6, [x0, #1]
	lsl	w15, w15, w21
	orr	w17, w15, w17
.LBB19_16:
	tst	x12, #0xff0000
	b.eq	.LBB19_19
	ldrb	w15, [x0, #2]
	cbnz	w15, .LBB19_19
	lsr	x15, x16, #14
	ldr	x2, [x5, #120]
	and	x15, x15, #0x3e0
	bfxil	x15, x3, #19, #5
	ldrb	w15, [x2, x15]
	strb	w6, [x0, #2]
	lsl	w15, w15, w22
	orr	w17, w15, w17
.LBB19_19:
	tst	x12, #0xff000000
	b.eq	.LBB19_22
	ldrb	w15, [x0, #3]
	cbnz	w15, .LBB19_22
	lsr	x15, x16, #22
	ldr	x2, [x5, #120]
	and	x15, x15, #0x3e0
	bfxil	x15, x3, #27, #5
	ldrb	w15, [x2, x15]
	strb	w6, [x0, #3]
	lsl	w15, w15, w23
	orr	w17, w15, w17
.LBB19_22:
	tst	x12, #0xff00000000
	b.eq	.LBB19_25
	ldrb	w15, [x0, #4]
	cbnz	w15, .LBB19_25
	lsr	x15, x16, #30
	ldr	x2, [x5, #120]
	and	x15, x15, #0x3e0
	bfxil	x15, x3, #35, #5
	ldrb	w15, [x2, x15]
	strb	w6, [x0, #4]
	lsl	w15, w15, w25
	orr	w17, w15, w17
.LBB19_25:
	tst	x12, #0xff0000000000
	b.eq	.LBB19_28
	ldrb	w15, [x0, #5]
	cbnz	w15, .LBB19_28
	lsr	x15, x16, #38
	ldr	x2, [x5, #120]
	and	x15, x15, #0x3e0
	bfxil	x15, x3, #43, #5
	ldrb	w15, [x2, x15]
	strb	w6, [x0, #5]
	lsl	w15, w15, w26
	orr	w17, w15, w17
.LBB19_28:
	tst	x12, #0xff000000000000
	b.eq	.LBB19_31
	ldrb	w15, [x0, #6]
	cbnz	w15, .LBB19_31
	lsr	x15, x16, #46
	ldr	x2, [x5, #120]
	and	x15, x15, #0x3e0
	bfxil	x15, x3, #51, #5
	ldrb	w15, [x2, x15]
	strb	w6, [x0, #6]
	lsl	w15, w15, w27
	orr	w17, w15, w17
.LBB19_31:
	lsr	x12, x12, #56
	cbz	x12, .LBB19_8
	ldrb	w12, [x0, #7]
	cbnz	w12, .LBB19_8
	lsr	x12, x16, #54
	ldr	x15, [x5, #120]
	and	x12, x12, #0x3e0
	bfxil	x12, x3, #59, #5
	ldrb	w12, [x15, x12]
	strb	w6, [x0, #7]
	lsl	w12, w12, w28
	orr	w17, w12, w17
	b	.LBB19_8
.Lfunc_end19:
	.size	get_overlay_image_area2, .Lfunc_end19-get_overlay_image_area2

	.p2align	2
	.type	get_overlay_image_area,@function
get_overlay_image_area:
	sub	sp, sp, #144
	str	x30, [x18], #8
	ldr	x9, [x5, #232]
	stp	x29, x30, [sp, #48]
	ldp	w11, w10, [x5, #80]
	stp	x28, x27, [sp, #64]
	ldp	w12, w8, [x9, #48]
	ldp	w13, w14, [x9, #56]
	add	w15, w10, #7
	stp	x26, x25, [sp, #80]
	stp	x24, x23, [sp, #96]
	add	w9, w12, #7
	cmp	w12, #0
	csel	w12, w9, w12, lt
	add	w9, w13, #7
	cmp	w13, #0
	stp	x22, x21, [sp, #112]
	csel	w9, w9, w13, lt
	cmp	w10, #0
	asr	w13, w9, #3
	csel	w9, w15, w10, lt
	add	w10, w13, #1
	asr	w9, w9, #3
	sub	w15, w9, #1
	cmp	w10, w9
	csinc	w10, w15, w13, ge
	sub	w13, w11, #1
	cmp	w14, w11
	stp	x20, x19, [sp, #128]
	csel	w11, w14, w13, lt
	stp	x3, x4, [sp, #32]
	cmp	w8, w11
	str	x0, [sp, #24]
	b.le	.LBB20_2
.LBB20_1:
	ldp	x20, x19, [sp, #128]
	ldp	x22, x21, [sp, #112]
	ldp	x24, x23, [sp, #96]
	ldp	x26, x25, [sp, #80]
	ldp	x28, x27, [sp, #64]
	ldp	x29, x30, [sp, #48]
	ldr	x30, [x18, #-8]!
	add	sp, sp, #144
	ret
.LBB20_2:
	adrp	x14, global_ebc
	asr	w12, w12, #3
	lsl	w16, w12, #3
	add	w15, w10, #1
	mul	w13, w8, w9
	sxtw	x0, w12
	ldr	x14, [x14, :lo12:global_ebc]
	sxtw	x15, w15
	sbfiz	x3, x12, #3, #32
	str	w16, [sp, #20]
	lsl	w16, w12, #1
	add	x17, x1, x3
	add	x1, x2, x3
	ldr	w2, [x14, #196]
	sub	x6, x15, x0
	mov	w7, #1
	str	x17, [sp, #8]
	b	.LBB20_4
.LBB20_3:
	add	w8, w8, #1
	add	w13, w13, w9
	cmp	w8, w11
	b.gt	.LBB20_1
.LBB20_4:
	cbz	w2, .LBB20_6
	ldp	w0, w15, [x14, #116]
	mvn	w3, w8
	add	w15, w15, w3
	cmp	w12, w10
	b.gt	.LBB20_3
	b	.LBB20_7
.LBB20_6:
	ldr	w15, [x14, #116]
	mov	w0, w8
	cmp	w12, w10
	b.gt	.LBB20_3
.LBB20_7:
	ldr	x17, [sp, #8]
	sbfiz	x4, x13, #3, #32
	ldr	w3, [x5, #84]
	mul	w15, w15, w0
	mov	x19, x6
	add	x21, x1, x4
	add	x20, x17, x4
	ldr	x17, [sp, #24]
	mul	w0, w3, w8
	mov	w25, w16
	ldr	w26, [sp, #20]
	add	x22, x17, x15, lsr #2
	ldr	x17, [sp, #32]
	sxtw	x15, w0
	add	x23, x17, x15
	ldr	x17, [sp, #40]
	add	x24, x17, x15
	b	.LBB20_10
.LBB20_8:
	strb	w0, [x27, #1]
.LBB20_9:
	add	w26, w26, #8
	add	w25, w25, #2
	add	x20, x20, #8
	add	x21, x21, #8
	subs	x19, x19, #1
	b.eq	.LBB20_3
.LBB20_10:
	ldr	x28, [x20]
	ldr	x29, [x21]
	cmp	x28, x29
	b.eq	.LBB20_9
	add	x27, x22, w25, sxtw
	sxtw	x15, w26
	add	x30, x23, x15
	add	x15, x24, x15
	eor	x4, x29, x28
	ldrb	w3, [x27]
	tst	x4, #0xff
	str	w7, [x5, #60]
	b.eq	.LBB20_14
	ldrb	w0, [x30]
	cbnz	w0, .LBB20_14
	ldrb	w0, [x15]
	lsl	w17, w29, #2
	and	x17, x17, #0x3e0
	bfxil	x17, x28, #3, #5
	add	x0, x5, x0, lsl #3
	ldr	x0, [x0, #120]
	ldrb	w17, [x0, x17]
	strb	w7, [x30]
	orr	w3, w17, w3
.LBB20_14:
	tst	x4, #0xff00
	b.eq	.LBB20_17
	ldrb	w17, [x30, #1]
	cbnz	w17, .LBB20_17
	ldrb	w17, [x15, #1]
	lsr	x0, x29, #6
	and	x0, x0, #0x3e0
	bfxil	x0, x28, #11, #5
	add	x17, x5, x17, lsl #3
	ldr	x17, [x17, #120]
	ldrb	w17, [x17, x0]
	strb	w7, [x30, #1]
	orr	w3, w3, w17, lsl #2
.LBB20_17:
	tst	x4, #0xff0000
	b.eq	.LBB20_20
	ldrb	w17, [x30, #2]
	cbnz	w17, .LBB20_20
	ldrb	w17, [x15, #2]
	lsr	x0, x29, #14
	and	x0, x0, #0x3e0
	bfxil	x0, x28, #19, #5
	add	x17, x5, x17, lsl #3
	ldr	x17, [x17, #120]
	ldrb	w17, [x17, x0]
	strb	w7, [x30, #2]
	orr	w3, w3, w17, lsl #4
.LBB20_20:
	tst	x4, #0xff000000
	b.eq	.LBB20_23
	ldrb	w17, [x30, #3]
	cbnz	w17, .LBB20_23
	ldrb	w17, [x15, #3]
	lsr	x0, x29, #22
	and	x0, x0, #0x3e0
	bfxil	x0, x28, #27, #5
	add	x17, x5, x17, lsl #3
	ldr	x17, [x17, #120]
	ldrb	w17, [x17, x0]
	strb	w7, [x30, #3]
	orr	w3, w3, w17, lsl #6
.LBB20_23:
	ldrb	w0, [x27, #1]
	tst	x4, #0xff00000000
	strb	w3, [x27]
	b.eq	.LBB20_26
	ldrb	w17, [x30, #4]
	cbnz	w17, .LBB20_26
	ldrb	w17, [x15, #4]
	lsr	x3, x29, #30
	and	x3, x3, #0x3e0
	bfxil	x3, x28, #35, #5
	add	x17, x5, x17, lsl #3
	ldr	x17, [x17, #120]
	ldrb	w17, [x17, x3]
	strb	w7, [x30, #4]
	orr	w0, w17, w0
.LBB20_26:
	tst	x4, #0xff0000000000
	b.eq	.LBB20_29
	ldrb	w17, [x30, #5]
	cbnz	w17, .LBB20_29
	ldrb	w17, [x15, #5]
	lsr	x3, x29, #38
	and	x3, x3, #0x3e0
	bfxil	x3, x28, #43, #5
	add	x17, x5, x17, lsl #3
	ldr	x17, [x17, #120]
	ldrb	w17, [x17, x3]
	strb	w7, [x30, #5]
	orr	w0, w0, w17, lsl #2
.LBB20_29:
	tst	x4, #0xff000000000000
	b.eq	.LBB20_32
	ldrb	w17, [x30, #6]
	cbnz	w17, .LBB20_32
	ldrb	w17, [x15, #6]
	lsr	x3, x29, #46
	and	x3, x3, #0x3e0
	bfxil	x3, x28, #51, #5
	add	x17, x5, x17, lsl #3
	ldr	x17, [x17, #120]
	ldrb	w17, [x17, x3]
	strb	w7, [x30, #6]
	orr	w0, w0, w17, lsl #4
.LBB20_32:
	lsr	x17, x4, #56
	cbz	x17, .LBB20_8
	ldrb	w17, [x30, #7]
	cbnz	w17, .LBB20_8
	ldrb	w15, [x15, #7]
	lsr	x17, x29, #54
	and	x17, x17, #0x3e0
	bfxil	x17, x28, #59, #5
	add	x15, x5, x15, lsl #3
	ldr	x15, [x15, #120]
	ldrb	w15, [x15, x17]
	strb	w7, [x30, #7]
	orr	w0, w0, w15, lsl #6
	b	.LBB20_8
.Lfunc_end20:
	.size	get_overlay_image_area, .Lfunc_end20-get_overlay_image_area

	.p2align	2
	.type	get_auto_image2,@function
get_auto_image2:
	sub	sp, sp, #144
	str	x30, [x18], #8
	adrp	x8, global_ebc
	stp	x26, x25, [sp, #80]
	stp	x24, x23, [sp, #96]
	cmp	w5, #3
	stp	x29, x30, [sp, #48]
	add	x29, sp, #48
	ldr	x8, [x8, :lo12:global_ebc]
	stp	x22, x21, [sp, #112]
	stp	x20, x19, [sp, #128]
	mov	x19, x4
	mov	x20, x3
	mov	x21, x2
	ldp	w23, w25, [x8, #116]
	mov	x22, x1
	stp	x28, x27, [sp, #64]
	stur	x0, [x29, #-8]
	str	x8, [sp, #24]
	lsr	w24, w23, #3
	b.eq	.LBB21_3
	add	x8, x19, #60
	cmp	w5, #2
	str	x8, [sp, #8]
	b.ne	.LBB21_4
	cmp	w25, #0
	mov	w27, wzr
	cinc	w8, w25, lt
	asr	w25, w8, #1
	b	.LBB21_5
.LBB21_3:
	cmp	w25, #0
	cinc	w8, w25, lt
	asr	w27, w8, #1
	mul	w8, w27, w24
	mul	w9, w27, w23
	sbfiz	x8, x8, #3, #32
	add	x22, x22, x8
	add	x21, x21, x8
	add	x20, x20, x9
	add	x8, x19, #64
	str	x8, [sp, #8]
	b	.LBB21_5
.LBB21_4:
	mov	w27, wzr
.LBB21_5:
	subs	w8, w25, w27
	mul	w9, w27, w23
	ldur	x10, [x29, #-8]
	mov	w1, wzr
	mul	w8, w8, w23
	lsr	w9, w9, #2
	add	x0, x10, x9
	lsr	w2, w8, #2
	bl	memset
	mov	w8, wzr
	cmp	w25, w27
	b.le	.LBB21_19
	cmp	w24, #1
	mov	w8, wzr
	csinc	w9, w24, wzr, hi
	stur	w23, [x29, #-12]
	lsl	x24, x9, #3
	str	x9, [sp, #16]
	b	.LBB21_9
.LBB21_7:
	add	x22, x22, x23
	add	x21, x21, x23
	add	x20, x20, x23
	ldur	w23, [x29, #-12]
.LBB21_8:
	add	w27, w27, #2
	cmp	w27, w25
	b.ge	.LBB21_19
.LBB21_9:
	cmp	w23, #8
	b.lo	.LBB21_8
	ldp	x26, x9, [sp, #16]
	ldr	w9, [x9, #116]
	mul	w28, w9, w27
	ldur	x9, [x29, #-8]
	add	x23, x9, x28, lsr #2
	b	.LBB21_12
.LBB21_11:
	add	x21, x21, #8
	add	x22, x22, #8
	add	x20, x20, #8
	add	x23, x23, #4
	subs	x26, x26, #1
	b.eq	.LBB21_14
.LBB21_12:
	ldr	x9, [x22]
	ldr	x10, [x21]
	cmp	x9, x10
	b.eq	.LBB21_11
	mov	x0, x22
	mov	x1, x21
	mov	x2, x20
	mov	x3, x19
	mov	w4, wzr
	bl	get_one_auto_image2
	mov	w8, #1
	str	w0, [x23]
	b	.LBB21_11
.LBB21_14:
	ldur	w23, [x29, #-12]
	cmp	w23, #8
	b.lo	.LBB21_8
	ldur	x9, [x29, #-8]
	mov	x23, xzr
	add	x26, x9, x28, lsr #2
	b	.LBB21_17
.LBB21_16:
	add	x26, x26, #4
	add	x23, x23, #8
	cmp	x24, x23
	b.eq	.LBB21_7
.LBB21_17:
	add	x0, x22, x23
	add	x1, x21, x23
	ldr	x9, [x0]
	ldr	x10, [x1]
	cmp	x9, x10
	b.eq	.LBB21_16
	add	x2, x20, x23
	mov	x3, x19
	mov	w4, #2
	bl	get_one_auto_image2
	ldr	w8, [x26]
	orr	w9, w8, w0
	mov	w8, #1
	str	w9, [x26]
	b	.LBB21_16
.LBB21_19:
	ldr	x9, [sp, #8]
	ldp	x20, x19, [sp, #128]
	ldp	x22, x21, [sp, #112]
	str	w8, [x9]
	ldp	x24, x23, [sp, #96]
	ldp	x26, x25, [sp, #80]
	ldp	x28, x27, [sp, #64]
	ldp	x29, x30, [sp, #48]
	ldr	x30, [x18, #-8]!
	add	sp, sp, #144
	ret
.Lfunc_end21:
	.size	get_auto_image2, .Lfunc_end21-get_auto_image2

	.p2align	2
	.type	get_auto_image,@function
get_auto_image:
	stp	x26, x25, [sp, #-64]!
	adrp	x8, global_ebc
	cmp	w5, #3
	stp	x24, x23, [sp, #16]
	stp	x22, x21, [sp, #32]
	ldr	x8, [x8, :lo12:global_ebc]
	stp	x20, x19, [sp, #48]
	ldp	w9, w10, [x8, #116]
	lsr	w15, w9, #3
	b.eq	.LBB22_3
	add	x11, x4, #60
	cmp	w5, #2
	b.ne	.LBB22_6
	cmp	w10, #0
	mov	w12, wzr
	cinc	w10, w10, lt
	asr	w10, w10, #1
	cmp	w12, w10
	b.ge	.LBB22_4
	b	.LBB22_7
.LBB22_3:
	cmp	w10, #0
	cinc	w11, w10, lt
	asr	w12, w11, #1
	mul	w11, w12, w15
	mul	w13, w12, w9
	sbfiz	x11, x11, #3, #32
	add	x1, x1, x11
	add	x2, x2, x11
	add	x3, x3, x13
	add	x11, x4, #64
	cmp	w12, w10
	b.lt	.LBB22_7
.LBB22_4:
	mov	w19, wzr
.LBB22_5:
	str	w19, [x11]
	ldp	x20, x19, [sp, #48]
	ldp	x22, x21, [sp, #32]
	ldp	x24, x23, [sp, #16]
	ldp	x26, x25, [sp], #64
	ret
.LBB22_6:
	mov	w12, wzr
	cmp	w12, w10
	b.ge	.LBB22_4
.LBB22_7:
	cmp	w15, #1
	mov	w19, wzr
	ldrb	w13, [x4, #56]
	csinc	w15, w15, wzr, hi
	ldr	w14, [x8, #196]
	add	x16, x0, #1
	b	.LBB22_10
.LBB22_8:
	add	x3, x3, x17
	add	x1, x1, x17
	add	x2, x2, x17
.LBB22_9:
	add	w12, w12, #1
	cmp	w12, w10
	b.eq	.LBB22_5
.LBB22_10:
	cbz	w14, .LBB22_12
	ldp	w5, w17, [x8, #116]
	mvn	w0, w12
	add	w0, w17, w0
	cmp	w9, #8
	b.lo	.LBB22_9
	b	.LBB22_13
.LBB22_12:
	ldr	w0, [x8, #116]
	mov	w5, w12
	cmp	w9, #8
	b.lo	.LBB22_9
.LBB22_13:
	mul	w0, w0, w5
	mov	x17, xzr
	mov	w5, w15
	lsr	w0, w0, #2
	add	x0, x16, x0
	b	.LBB22_16
.LBB22_14:
	sturh	wzr, [x0, #-1]
.LBB22_15:
	add	x17, x17, #8
	add	x0, x0, #2
	subs	w5, w5, #1
	b.eq	.LBB22_8
.LBB22_16:
	ldr	x7, [x1, x17]
	ldr	x6, [x2, x17]
	cmp	x7, x6
	b.eq	.LBB22_14
	eor	x19, x6, x7
	tst	x19, #0xff
	b.eq	.LBB22_19
	ldrb	w21, [x3, x17]
	lsl	w22, w6, #2
	ldr	x20, [x4, #120]
	and	x22, x22, #0x3e0
	bfxil	x22, x7, #3, #5
	mov	x23, x6
	bfxil	x23, x7, #0, #8
	add	x20, x20, x21, lsl #10
	add	w24, w21, #1
	cmp	w13, w24, uxtb
	ldrb	w20, [x20, x22]
	csel	x6, x23, x6, eq
	csinc	w21, wzr, w21, eq
	strb	w21, [x3, x17]
	b	.LBB22_20
.LBB22_19:
	mov	w20, wzr
.LBB22_20:
	add	x21, x3, x17
	tst	x19, #0xff00
	b.eq	.LBB22_22
	ldrb	w22, [x21, #1]
	lsr	x23, x6, #6
	ldr	x24, [x4, #120]
	and	x23, x23, #0x3e0
	bfxil	x23, x7, #11, #5
	add	w25, w22, #1
	add	x24, x24, x22, lsl #10
	cmp	w13, w25, uxtb
	mov	x25, x6
	csinc	w22, wzr, w22, eq
	ldrb	w23, [x24, x23]
	lsr	x24, x7, #8
	strb	w22, [x21, #1]
	bfi	x25, x24, #8, #8
	orr	w20, w20, w23, lsl #2
	csel	x6, x25, x6, eq
.LBB22_22:
	tst	x19, #0xff0000
	b.eq	.LBB22_24
	ldrb	w22, [x21, #2]
	lsr	x23, x6, #14
	ldr	x24, [x4, #120]
	and	x23, x23, #0x3e0
	bfxil	x23, x7, #19, #5
	add	w25, w22, #1
	add	x24, x24, x22, lsl #10
	cmp	w13, w25, uxtb
	mov	x25, x6
	csinc	w22, wzr, w22, eq
	ldrb	w23, [x24, x23]
	lsr	x24, x7, #16
	strb	w22, [x21, #2]
	bfi	x25, x24, #16, #8
	orr	w20, w20, w23, lsl #4
	csel	x6, x25, x6, eq
.LBB22_24:
	add	x21, x3, x17
	tst	x19, #0xff000000
	b.eq	.LBB22_26
	ldrb	w22, [x21, #3]
	lsr	x23, x6, #22
	ldr	x24, [x4, #120]
	and	x23, x23, #0x3e0
	bfxil	x23, x7, #27, #5
	add	w25, w22, #1
	add	x24, x24, x22, lsl #10
	cmp	w13, w25, uxtb
	mov	x25, x6
	csinc	w22, wzr, w22, eq
	ldrb	w23, [x24, x23]
	lsr	x24, x7, #24
	strb	w22, [x21, #3]
	bfi	x25, x24, #24, #8
	orr	w20, w20, w23, lsl #6
	csel	x6, x25, x6, eq
.LBB22_26:
	tst	x19, #0xff00000000
	sturb	w20, [x0, #-1]
	b.eq	.LBB22_28
	ldrb	w22, [x21, #4]
	lsr	x20, x6, #30
	ldr	x23, [x4, #120]
	and	x20, x20, #0x3e0
	bfxil	x20, x7, #35, #5
	lsr	x24, x7, #32
	mov	x25, x6
	add	w26, w22, #1
	add	x23, x23, x22, lsl #10
	cmp	w13, w26, uxtb
	bfi	x25, x24, #32, #8
	csinc	w22, wzr, w22, eq
	ldrb	w20, [x23, x20]
	csel	x6, x25, x6, eq
	strb	w22, [x21, #4]
	b	.LBB22_29
.LBB22_28:
	mov	w20, wzr
.LBB22_29:
	add	x21, x3, x17
	tst	x19, #0xff0000000000
	b.eq	.LBB22_31
	ldrb	w22, [x21, #5]
	lsr	x23, x6, #38
	ldr	x24, [x4, #120]
	and	x23, x23, #0x3e0
	bfxil	x23, x7, #43, #5
	add	w25, w22, #1
	add	x24, x24, x22, lsl #10
	cmp	w13, w25, uxtb
	mov	x25, x6
	csinc	w22, wzr, w22, eq
	ldrb	w23, [x24, x23]
	lsr	x24, x7, #40
	strb	w22, [x21, #5]
	bfi	x25, x24, #40, #8
	orr	w20, w20, w23, lsl #2
	csel	x6, x25, x6, eq
.LBB22_31:
	tst	x19, #0xff000000000000
	b.eq	.LBB22_33
	ldrb	w22, [x21, #6]
	lsr	x23, x6, #46
	ldr	x24, [x4, #120]
	and	x23, x23, #0x3e0
	bfxil	x23, x7, #51, #5
	add	w25, w22, #1
	add	x24, x24, x22, lsl #10
	cmp	w13, w25, uxtb
	mov	x25, x6
	csinc	w22, wzr, w22, eq
	ldrb	w23, [x24, x23]
	lsr	x24, x7, #48
	strb	w22, [x21, #6]
	bfi	x25, x24, #48, #8
	orr	w20, w20, w23, lsl #4
	csel	x6, x25, x6, eq
.LBB22_33:
	lsr	x19, x19, #56
	cbz	x19, .LBB22_35
	add	x19, x3, x17
	ldr	x22, [x4, #120]
	lsr	x23, x6, #54
	and	x23, x23, #0x3e0
	ldrb	w21, [x19, #7]
	bfxil	x23, x7, #59, #5
	bfxil	x7, x6, #0, #56
	add	x22, x22, x21, lsl #10
	ldrb	w22, [x22, x23]
	add	w23, w21, #1
	cmp	w13, w23, uxtb
	csinc	w21, wzr, w21, eq
	csel	x6, x7, x6, eq
	orr	w20, w20, w22, lsl #6
	strb	w21, [x19, #7]
.LBB22_35:
	mov	w19, #1
	str	x6, [x2, x17]
	strb	w20, [x0]
	b	.LBB22_15
.Lfunc_end22:
	.size	get_auto_image, .Lfunc_end22-get_auto_image

	.p2align	2
	.type	direct_mode_data_change_part2,@function
direct_mode_data_change_part2:
	sub	sp, sp, #112
	str	x30, [x18], #8
	adrp	x8, global_ebc
	stp	x24, x23, [sp, #64]
	stp	x22, x21, [sp, #80]
	cmp	w4, #3
	stp	x20, x19, [sp, #96]
	mov	x19, x2
	ldr	x8, [x8, :lo12:global_ebc]
	mov	x20, x1
	stp	x29, x30, [sp, #16]
	add	x29, sp, #16
	stp	x28, x27, [sp, #32]
	ldp	w22, w23, [x8, #116]
	stp	x26, x25, [sp, #48]
	str	x0, [sp, #8]
	lsr	w9, w22, #3
	str	w9, [sp, #4]
	b.eq	.LBB23_3
	cmp	w4, #2
	b.ne	.LBB23_4
	cmp	w23, #0
	mov	w24, wzr
	cinc	w8, w23, lt
	asr	w23, w8, #1
	b	.LBB23_5
.LBB23_3:
	cmp	w23, #0
	cinc	w8, w23, lt
	asr	w24, w8, #1
	mul	w8, w24, w9
	sbfiz	x8, x8, #3, #32
	add	x20, x20, x8
	add	x19, x19, x8
	b	.LBB23_5
.LBB23_4:
	mov	w24, wzr
.LBB23_5:
	lsr	w27, w22, #2
	subs	w8, w23, w24
	ldr	x9, [sp, #8]
	mov	w1, wzr
	mul	w25, w24, w27
	ldrb	w26, [x3, #56]
	mul	w8, w8, w27
	ldr	w21, [x3, #72]
	ldr	x28, [x3, #120]
	add	x0, x9, w25, sxtw
	sxtw	x2, w8
	bl	memset
	cmp	w23, w24
	b.le	.LBB23_25
	ldr	w9, [sp, #4]
	sub	w8, w26, w21
	lsl	w11, w8, #10
	lsl	w8, w27, #1
	mov	w12, #12
	mov	w13, #3
	cmp	w9, #1
	add	x11, x28, w11, sxtw
	csinc	w9, w9, wzr, hi
	lsl	x10, x9, #3
	b	.LBB23_9
.LBB23_7:
	add	x20, x20, x15
	add	x19, x19, x15
.LBB23_8:
	add	w24, w24, #2
	add	w25, w25, w8
	cmp	w24, w23
	b.ge	.LBB23_25
.LBB23_9:
	cmp	w22, #8
	b.lo	.LBB23_8
	ldr	x14, [sp, #8]
	mov	x15, x9
	add	x14, x14, w25, sxtw
	mov	x16, x14
	b	.LBB23_14
.LBB23_11:
	tst	x0, #0xff
	lsr	x7, x1, #22
	csel	w3, wzr, w13, eq
	tst	x0, #0xff00
	orr	w4, w3, #0x30
	and	x7, x7, #0x3e0
	csel	w3, w3, w4, eq
	tst	x0, #0xff0000
	orr	w4, w3, #0x300
	lsl	w2, w1, #2
	csel	w3, w3, w4, eq
	tst	x0, #0xff000000
	orr	w4, w3, #0x3000
	lsr	x5, x1, #6
	csel	w3, w3, w4, eq
	tst	x0, #0xff00000000
	orr	w4, w3, #0x30000
	bfxil	x7, x17, #27, #5
	csel	w3, w3, w4, eq
	tst	x0, #0xff0000000000
	orr	w4, w3, #0x300000
	and	x2, x2, #0x3e0
	and	x5, x5, #0x3e0
	lsr	x6, x1, #14
	csel	w3, w3, w4, eq
	bfxil	x2, x17, #3, #5
	bfxil	x5, x17, #11, #5
	and	x4, x6, #0x3e0
	orr	w6, w3, #0x3000000
	tst	x0, #0xff000000000000
	bfxil	x4, x17, #19, #5
	csel	w3, w3, w6, eq
	ldrb	w6, [x11, x7]
	lsr	x7, x1, #30
	and	x7, x7, #0x3e0
	lsr	x21, x1, #38
	ldrb	w2, [x11, x2]
	bfxil	x7, x17, #35, #5
	ldrb	w5, [x11, x5]
	and	x21, x21, #0x3e0
	lsr	x26, x1, #46
	ldrb	w4, [x11, x4]
	bfxil	x21, x17, #43, #5
	and	x26, x26, #0x3e0
	lsr	x1, x1, #54
	bfxil	x26, x17, #51, #5
	and	x1, x1, #0x3e0
	orr	w2, w2, w5, lsl #4
	bfxil	x1, x17, #59, #5
	ldrb	w17, [x11, x7]
	ldrb	w5, [x11, x21]
	orr	w2, w2, w4, lsl #8
	ldrb	w4, [x11, x26]
	orr	w2, w2, w6, lsl #12
	ldrb	w1, [x11, x1]
	lsr	x0, x0, #56
	orr	w17, w2, w17, lsl #16
	cmp	x0, #0
	orr	w17, w17, w5, lsl #20
	orr	w0, w3, #0x30000000
	orr	w17, w17, w4, lsl #24
	csel	w0, w3, w0, eq
	orr	w17, w17, w1, lsl #28
	and	w17, w17, w0
.LBB23_12:
	str	w17, [x16]
.LBB23_13:
	add	x16, x16, #4
	subs	x15, x15, #1
	b.eq	.LBB23_17
.LBB23_14:
	ldr	x17, [x20], #8
	ldr	x1, [x19], #8
	cmp	x17, x1
	b.eq	.LBB23_13
	eor	x0, x1, x17
	cbnz	x0, .LBB23_11
	mov	w17, wzr
	b	.LBB23_12
.LBB23_17:
	cmp	w22, #8
	b.lo	.LBB23_8
	mov	x15, xzr
	b	.LBB23_22
.LBB23_19:
	tst	x17, #0xff
	lsr	x2, x0, #6
	csel	w3, wzr, w12, eq
	tst	x17, #0xff00
	orr	w4, w3, #0xc0
	lsl	w1, w0, #2
	csel	w3, w3, w4, eq
	tst	x17, #0xff0000
	orr	w4, w3, #0xc00
	and	x2, x2, #0x3e0
	csel	w3, w3, w4, eq
	tst	x17, #0xff000000
	orr	w4, w3, #0xc000
	lsr	x5, x0, #14
	csel	w3, w3, w4, eq
	tst	x17, #0xff00000000
	orr	w4, w3, #0xc0000
	and	x1, x1, #0x3e0
	csel	w3, w3, w4, eq
	tst	x17, #0xff0000000000
	orr	w4, w3, #0xc00000
	bfxil	x2, x16, #11, #5
	csel	w3, w3, w4, eq
	tst	x17, #0xff000000000000
	orr	w4, w3, #0xc000000
	and	x5, x5, #0x3e0
	bfxil	x1, x16, #3, #5
	csel	w3, w3, w4, eq
	lsr	x4, x0, #22
	bfxil	x5, x16, #19, #5
	and	x4, x4, #0x3e0
	lsr	x6, x0, #30
	ldrb	w2, [x11, x2]
	bfxil	x4, x16, #27, #5
	and	x6, x6, #0x3e0
	lsr	x7, x0, #38
	ldrb	w1, [x11, x1]
	bfxil	x6, x16, #35, #5
	and	x7, x7, #0x3e0
	lsr	x21, x0, #46
	lsr	x0, x0, #54
	ldrb	w5, [x11, x5]
	bfxil	x7, x16, #43, #5
	and	x21, x21, #0x3e0
	and	x0, x0, #0x3e0
	bfxil	x21, x16, #51, #5
	bfxil	x0, x16, #59, #5
	ldrb	w16, [x11, x4]
	lsl	w2, w2, #6
	ldrb	w4, [x11, x6]
	orr	w1, w2, w1, lsl #2
	ldrb	w2, [x11, x7]
	orr	w1, w1, w5, lsl #10
	ldrb	w5, [x11, x21]
	orr	w16, w1, w16, lsl #14
	ldrb	w0, [x11, x0]
	orr	w16, w16, w4, lsl #18
	lsr	x17, x17, #56
	orr	w16, w16, w2, lsl #22
	cmp	x17, #0
	orr	w17, w3, #0xc0000000
	orr	w16, w16, w5, lsl #26
	csel	w17, w3, w17, eq
	orr	w16, w16, w0, lsl #30
	and	w16, w16, w17
.LBB23_20:
	ldr	w17, [x14]
	orr	w16, w17, w16
	str	w16, [x14]
.LBB23_21:
	add	x14, x14, #4
	add	x15, x15, #8
	cmp	x10, x15
	b.eq	.LBB23_7
.LBB23_22:
	ldr	x16, [x20, x15]
	ldr	x0, [x19, x15]
	cmp	x16, x0
	b.eq	.LBB23_21
	eor	x17, x0, x16
	cbnz	x17, .LBB23_19
	mov	w16, wzr
	b	.LBB23_20
.LBB23_25:
	ldp	x20, x19, [sp, #96]
	ldp	x22, x21, [sp, #80]
	ldp	x24, x23, [sp, #64]
	ldp	x26, x25, [sp, #48]
	ldp	x28, x27, [sp, #32]
	ldp	x29, x30, [sp, #16]
	ldr	x30, [x18, #-8]!
	add	sp, sp, #112
	ret
.Lfunc_end23:
	.size	direct_mode_data_change_part2, .Lfunc_end23-direct_mode_data_change_part2

	.p2align	2
	.type	direct_mode_data_change_part,@function
direct_mode_data_change_part:
	sub	sp, sp, #112
	str	x30, [x18], #8
	adrp	x8, global_ebc
	stp	x26, x25, [sp, #48]
	stp	x22, x21, [sp, #80]
	mov	x21, x0
	stp	x29, x30, [sp, #16]
	add	x29, sp, #16
	ldr	x26, [x8, :lo12:global_ebc]
	stp	x20, x19, [sp, #96]
	mov	x19, x2
	mov	x20, x1
	cmp	w4, #3
	stp	x28, x27, [sp, #32]
	ldp	w22, w8, [x26, #116]
	stp	x24, x23, [sp, #64]
	lsr	w10, w22, #3
	stur	w10, [x29, #-4]
	b.eq	.LBB24_3
	cmp	w4, #2
	b.ne	.LBB24_4
	cmp	w8, #0
	mov	w23, wzr
	cinc	w9, w8, lt
	asr	w24, w9, #1
	b	.LBB24_6
.LBB24_3:
	cmp	w8, #0
	cinc	w9, w8, lt
	asr	w23, w9, #1
	mul	w9, w23, w10
	sbfiz	x9, x9, #3, #32
	add	x20, x20, x9
	add	x19, x19, x9
	b	.LBB24_5
.LBB24_4:
	mov	w23, wzr
.LBB24_5:
	mov	w24, w8
.LBB24_6:
	ldrb	w28, [x3, #56]
	lsr	w25, w22, #2
	ldr	w27, [x3, #72]
	ldr	w9, [x26, #196]
	ldr	x10, [x3, #120]
	str	x10, [sp]
	cbz	w9, .LBB24_8
	sub	w8, w8, w24
	sub	w9, w24, w23
	mov	w1, wzr
	mul	w8, w8, w25
	mul	w9, w9, w25
	add	x0, x21, x8
	sxtw	x2, w9
	bl	memset
	ldr	w8, [x26, #120]
	mvn	w9, w23
	add	w8, w8, w9
	mul	w8, w8, w25
	neg	w25, w25
	add	x21, x21, x8
	cmp	w24, w23
	b.gt	.LBB24_9
	b	.LBB24_19
.LBB24_8:
	sub	w8, w24, w23
	mul	w9, w23, w25
	mov	w1, wzr
	mul	w8, w8, w25
	add	x21, x21, w9, sxtw
	sxtw	x2, w8
	mov	x0, x21
	bl	memset
	cmp	w24, w23
	b.le	.LBB24_19
.LBB24_9:
	ldur	w10, [x29, #-4]
	sub	w8, w28, w27
	ldr	x11, [sp]
	lsl	w9, w8, #10
	sxtw	x8, w25
	cmp	w10, #1
	csinc	w10, w10, wzr, hi
	add	x9, x11, w9, sxtw
	lsl	x10, x10, #1
	mov	w11, #3
	b	.LBB24_11
.LBB24_10:
	add	w23, w23, #1
	add	x21, x21, x8
	cmp	w23, w24
	b.eq	.LBB24_19
.LBB24_11:
	cmp	w22, #8
	b.lo	.LBB24_10
	mov	x12, xzr
	b	.LBB24_16
.LBB24_13:
	tst	x14, #0xff
	lsr	x3, x15, #22
	csel	w17, wzr, w11, eq
	tst	x14, #0xff00
	orr	w0, w17, #0xc
	and	x3, x3, #0x3e0
	csel	w17, w17, w0, eq
	tst	x14, #0xff0000
	orr	w0, w17, #0x30
	lsl	w16, w15, #2
	csel	w17, w17, w0, eq
	tst	x14, #0xff000000
	orr	w0, w17, #0xc0
	lsr	x1, x15, #6
	csel	w17, w17, w0, eq
	tst	x14, #0xff00000000
	orr	w0, w17, #0x300
	bfxil	x3, x13, #27, #5
	csel	w17, w17, w0, eq
	tst	x14, #0xff0000000000
	orr	w0, w17, #0xc00
	and	x16, x16, #0x3e0
	and	x1, x1, #0x3e0
	lsr	x2, x15, #14
	csel	w17, w17, w0, eq
	bfxil	x16, x13, #3, #5
	bfxil	x1, x13, #11, #5
	and	x0, x2, #0x3e0
	orr	w2, w17, #0x3000
	tst	x14, #0xff000000000000
	bfxil	x0, x13, #19, #5
	csel	w17, w17, w2, eq
	ldrb	w2, [x9, x3]
	lsr	x3, x15, #30
	and	x3, x3, #0x3e0
	lsr	x4, x15, #38
	ldrb	w16, [x9, x16]
	bfxil	x3, x13, #35, #5
	ldrb	w1, [x9, x1]
	and	x4, x4, #0x3e0
	lsr	x5, x15, #46
	ldrb	w0, [x9, x0]
	bfxil	x4, x13, #43, #5
	and	x5, x5, #0x3e0
	lsr	x15, x15, #54
	bfxil	x5, x13, #51, #5
	and	x15, x15, #0x3e0
	orr	w16, w16, w1, lsl #2
	bfxil	x15, x13, #59, #5
	ldrb	w13, [x9, x3]
	ldrb	w1, [x9, x4]
	orr	w16, w16, w0, lsl #4
	ldrb	w0, [x9, x5]
	orr	w16, w16, w2, lsl #6
	ldrb	w15, [x9, x15]
	lsr	x14, x14, #56
	orr	w13, w16, w13, lsl #8
	cmp	x14, #0
	orr	w13, w13, w1, lsl #10
	orr	w14, w17, #0xffffc000
	orr	w13, w13, w0, lsl #12
	csel	w14, w17, w14, eq
	orr	w13, w13, w15, lsl #14
	and	w13, w13, w14
.LBB24_14:
	strh	w13, [x21, x12]
.LBB24_15:
	add	x12, x12, #2
	cmp	x10, x12
	b.eq	.LBB24_10
.LBB24_16:
	ldr	x13, [x20], #8
	ldr	x15, [x19], #8
	cmp	x13, x15
	b.eq	.LBB24_15
	eor	x14, x15, x13
	cbnz	x14, .LBB24_13
	mov	w13, wzr
	b	.LBB24_14
.LBB24_19:
	ldp	x20, x19, [sp, #96]
	ldp	x22, x21, [sp, #80]
	ldp	x24, x23, [sp, #64]
	ldp	x26, x25, [sp, #48]
	ldp	x28, x27, [sp, #32]
	ldp	x29, x30, [sp, #16]
	ldr	x30, [x18, #-8]!
	add	sp, sp, #112
	ret
.Lfunc_end24:
	.size	direct_mode_data_change_part, .Lfunc_end24-direct_mode_data_change_part

	.p2align	2
	.type	direct_mode_data_change_full2,@function
direct_mode_data_change_full2:
	stp	x28, x27, [sp, #-80]!
	adrp	x8, global_ebc
	ldr	w10, [x3, #628]
	ldr	w11, [x3, #624]
	stp	x26, x25, [sp, #16]
	stp	x24, x23, [sp, #32]
	ldr	x9, [x8, :lo12:global_ebc]
	add	w12, w10, #7
	cmp	w10, #0
	stp	x22, x21, [sp, #48]
	csel	w14, w12, w10, lt
	cmp	w11, #0
	ldp	w8, w16, [x9, #116]
	add	w9, w11, #7
	stp	x20, x19, [sp, #64]
	csel	w13, w9, w11, lt
	cmp	w16, #0
	lsr	w15, w8, #3
	cinc	w9, w16, lt
	cmp	w16, #0
	asr	w11, w9, #1
	cinc	w9, w16, lt
	cmp	w4, #2
	asr	w9, w9, #1
	mul	w10, w11, w15
	csel	w17, w16, w9, ne
	csel	w12, wzr, wzr, ne
	cmp	w4, #3
	sbfiz	x9, x10, #3, #32
	csel	w11, w11, w12, eq
	add	x10, x1, x9
	add	x9, x2, x9
	csel	x9, x9, x2, eq
	csel	x10, x10, x1, eq
	csel	w12, w16, w17, eq
	cmp	w11, w12
	b.ge	.LBB25_16
	ldrb	w16, [x3, #56]
	asr	w13, w13, #3
	asr	w2, w14, #3
	lsr	w1, w8, #2
	cmp	w15, #1
	sxtw	x14, w2
	msub	w17, w13, w16, w2
	csinc	w15, w15, wzr, hi
	mul	w16, w11, w1
	lsl	w1, w1, #1
	sub	w2, w2, #1
	bic	w17, w17, w17, asr #31
	b	.LBB25_4
.LBB25_2:
	sub	x10, x10, x5
	sub	x9, x9, x5
.LBB25_3:
	add	w11, w11, #2
	add	w16, w16, w1
	cmp	w11, w12
	b.ge	.LBB25_16
.LBB25_4:
	cmp	w8, #8
	b.lo	.LBB25_3
	mov	x5, xzr
	add	x4, x0, w16, sxtw
	mov	w6, w2
	b	.LBB25_7
.LBB25_6:
	str	w20, [x4, x5, lsl #2]
	add	x5, x5, #1
	sub	w6, w6, #1
	cmp	x15, x5
	b.eq	.LBB25_10
.LBB25_7:
	mov	w20, wzr
	cmp	x5, x17
	ldr	x7, [x10], #8
	ldr	x19, [x9], #8
	b.lo	.LBB25_6
	cmp	x5, x14
	b.ge	.LBB25_6
	sdiv	w20, w6, w13
	ldr	x21, [x3, #120]
	lsl	w22, w19, #2
	lsr	x23, x19, #6
	and	x22, x22, #0x3e0
	and	x23, x23, #0x3e0
	lsr	x24, x19, #14
	lsr	x25, x19, #22
	and	x24, x24, #0x3e0
	bfxil	x22, x7, #3, #5
	bfxil	x23, x7, #11, #5
	bfxil	x24, x7, #19, #5
	lsl	w20, w20, #10
	lsr	x26, x19, #38
	and	x26, x26, #0x3e0
	lsr	x27, x19, #46
	add	x20, x21, w20, sxtw
	and	x21, x25, #0x3e0
	lsr	x25, x19, #30
	bfxil	x21, x7, #27, #5
	and	x25, x25, #0x3e0
	ldrb	w22, [x20, x22]
	ldrb	w23, [x20, x23]
	bfxil	x25, x7, #35, #5
	ldrb	w24, [x20, x24]
	bfxil	x26, x7, #43, #5
	and	x27, x27, #0x3e0
	lsr	x19, x19, #54
	ldrb	w21, [x20, x21]
	bfxil	x27, x7, #51, #5
	and	x19, x19, #0x3e0
	orr	w22, w22, w23, lsl #4
	bfxil	x19, x7, #59, #5
	ldrb	w7, [x20, x25]
	ldrb	w23, [x20, x26]
	orr	w22, w22, w24, lsl #8
	ldrb	w24, [x20, x27]
	orr	w21, w22, w21, lsl #12
	ldrb	w19, [x20, x19]
	orr	w7, w21, w7, lsl #16
	orr	w7, w7, w23, lsl #20
	orr	w7, w7, w24, lsl #24
	orr	w20, w7, w19, lsl #28
	b	.LBB25_6
.LBB25_10:
	cmp	w8, #8
	b.lo	.LBB25_3
	mov	x5, xzr
	mov	x6, xzr
	mov	w7, w2
	b	.LBB25_13
.LBB25_12:
	str	w19, [x4, x6, lsl #2]
	add	x6, x6, #1
	sub	w7, w7, #1
	sub	x5, x5, #8
	cmp	x15, x6
	b.eq	.LBB25_2
.LBB25_13:
	mov	w19, wzr
	cmp	x6, x17
	b.lo	.LBB25_12
	cmp	x6, x14
	b.ge	.LBB25_12
	lsl	x19, x6, #3
	sdiv	w20, w7, w13
	ldr	x22, [x3, #120]
	ldr	x21, [x9, x19]
	ldr	x19, [x10, x19]
	lsl	w20, w20, #10
	lsl	w23, w21, #2
	lsr	x24, x21, #6
	add	x20, x22, w20, sxtw
	and	x22, x23, #0x3e0
	and	x23, x24, #0x3e0
	lsr	x25, x21, #14
	bfxil	x23, x19, #11, #5
	lsr	x26, x21, #22
	and	x24, x25, #0x3e0
	bfxil	x22, x19, #3, #5
	lsr	x27, x21, #30
	and	x25, x26, #0x3e0
	bfxil	x24, x19, #19, #5
	lsr	x28, x21, #38
	and	x26, x27, #0x3e0
	bfxil	x25, x19, #27, #5
	ldrb	w23, [x20, x23]
	bfxil	x26, x19, #35, #5
	ldrb	w22, [x20, x22]
	and	x27, x28, #0x3e0
	lsr	x28, x21, #46
	lsr	x21, x21, #54
	ldrb	w24, [x20, x24]
	bfxil	x27, x19, #43, #5
	and	x28, x28, #0x3e0
	and	x21, x21, #0x3e0
	bfxil	x28, x19, #51, #5
	bfxil	x21, x19, #59, #5
	ldrb	w19, [x20, x25]
	lsl	w23, w23, #6
	ldrb	w25, [x20, x26]
	orr	w22, w23, w22, lsl #2
	ldrb	w23, [x20, x27]
	orr	w22, w22, w24, lsl #10
	ldrb	w24, [x20, x28]
	orr	w19, w22, w19, lsl #14
	ldrb	w20, [x20, x21]
	orr	w19, w19, w25, lsl #18
	orr	w19, w19, w23, lsl #22
	orr	w19, w19, w24, lsl #26
	orr	w19, w19, w20, lsl #30
	b	.LBB25_12
.LBB25_16:
	ldp	x20, x19, [sp, #64]
	ldp	x22, x21, [sp, #48]
	ldp	x24, x23, [sp, #32]
	ldp	x26, x25, [sp, #16]
	ldp	x28, x27, [sp], #80
	ret
.Lfunc_end25:
	.size	direct_mode_data_change_full2, .Lfunc_end25-direct_mode_data_change_full2

	.p2align	2
	.type	direct_mode_data_change_full,@function
direct_mode_data_change_full:
	str	x25, [sp, #-64]!
	adrp	x8, global_ebc
	ldr	w9, [x3, #628]
	ldr	w10, [x3, #624]
	stp	x24, x23, [sp, #16]
	stp	x22, x21, [sp, #32]
	ldr	x13, [x8, :lo12:global_ebc]
	add	w8, w9, #7
	cmp	w9, #0
	stp	x20, x19, [sp, #48]
	csel	w12, w8, w9, lt
	add	w9, w10, #7
	ldp	w8, w14, [x13, #116]
	cmp	w10, #0
	csel	w11, w9, w10, lt
	cmp	w4, #3
	lsr	w16, w8, #3
	b.eq	.LBB26_3
	cmp	w4, #2
	b.ne	.LBB26_4
	cmp	w14, #0
	mov	w9, wzr
	cinc	w10, w14, lt
	asr	w10, w10, #1
	b	.LBB26_6
.LBB26_3:
	cmp	w14, #0
	cinc	w9, w14, lt
	asr	w9, w9, #1
	mul	w10, w9, w16
	sbfiz	x10, x10, #3, #32
	add	x1, x1, x10
	add	x2, x2, x10
	b	.LBB26_5
.LBB26_4:
	mov	w9, wzr
.LBB26_5:
	mov	w10, w14
.LBB26_6:
	lsr	w15, w8, #2
	mvn	w17, w9
	ldr	w13, [x13, #196]
	add	w14, w14, w17
	mul	w17, w9, w15
	mul	w14, w14, w15
	sxtw	x17, w17
	cmp	w13, #0
	csel	x13, x17, x14, eq
	cneg	w14, w15, ne
	cmp	w9, w10
	b.ge	.LBB26_15
	ldrb	w15, [x3, #56]
	asr	w11, w11, #3
	asr	w17, w12, #3
	cmp	w16, #1
	sxtw	x12, w14
	add	x13, x0, x13
	msub	w15, w11, w15, w17
	sxtw	x14, w17
	csinc	w16, w16, wzr, hi
	sub	w17, w17, #1
	bic	w15, w15, w15, asr #31
	b	.LBB26_9
.LBB26_8:
	add	w9, w9, #1
	add	x13, x13, x12
	cmp	w9, w10
	b.eq	.LBB26_15
.LBB26_9:
	cmp	w8, #8
	b.lo	.LBB26_8
	mov	x0, xzr
	mov	w4, w17
	b	.LBB26_12
.LBB26_11:
	strh	w7, [x13, x0, lsl #1]
	add	x0, x0, #1
	sub	w4, w4, #1
	cmp	x16, x0
	b.eq	.LBB26_8
.LBB26_12:
	mov	w7, wzr
	cmp	x0, x15
	ldr	x5, [x1], #8
	ldr	x6, [x2], #8
	b.lo	.LBB26_11
	cmp	x0, x14
	b.ge	.LBB26_11
	sdiv	w7, w4, w11
	ldr	x19, [x3, #120]
	lsl	w20, w6, #2
	lsr	x21, x6, #6
	and	x20, x20, #0x3e0
	and	x21, x21, #0x3e0
	lsr	x22, x6, #14
	lsr	x23, x6, #22
	and	x22, x22, #0x3e0
	bfxil	x20, x5, #3, #5
	bfxil	x21, x5, #11, #5
	bfxil	x22, x5, #19, #5
	lsl	w7, w7, #10
	lsr	x24, x6, #38
	and	x24, x24, #0x3e0
	lsr	x25, x6, #46
	add	x7, x19, w7, sxtw
	and	x19, x23, #0x3e0
	lsr	x23, x6, #30
	bfxil	x19, x5, #27, #5
	and	x23, x23, #0x3e0
	ldrb	w20, [x7, x20]
	ldrb	w21, [x7, x21]
	bfxil	x23, x5, #35, #5
	ldrb	w22, [x7, x22]
	bfxil	x24, x5, #43, #5
	and	x25, x25, #0x3e0
	lsr	x6, x6, #54
	ldrb	w19, [x7, x19]
	bfxil	x25, x5, #51, #5
	and	x6, x6, #0x3e0
	orr	w20, w20, w21, lsl #2
	bfxil	x6, x5, #59, #5
	ldrb	w5, [x7, x23]
	ldrb	w21, [x7, x24]
	orr	w20, w20, w22, lsl #4
	ldrb	w22, [x7, x25]
	orr	w19, w20, w19, lsl #6
	ldrb	w6, [x7, x6]
	orr	w5, w19, w5, lsl #8
	orr	w5, w5, w21, lsl #10
	orr	w5, w5, w22, lsl #12
	orr	w7, w5, w6, lsl #14
	b	.LBB26_11
.LBB26_15:
	ldp	x20, x19, [sp, #48]
	ldp	x22, x21, [sp, #32]
	ldp	x24, x23, [sp, #16]
	ldr	x25, [sp], #64
	ret
.Lfunc_end26:
	.size	direct_mode_data_change_full, .Lfunc_end26-direct_mode_data_change_full

	.p2align	2
	.type	direct_mode_data_change2,@function
direct_mode_data_change2:
	str	x23, [sp, #-48]!
	adrp	x8, global_ebc
	stp	x22, x21, [sp, #16]
	stp	x20, x19, [sp, #32]
	ldr	x8, [x8, :lo12:global_ebc]
	ldp	w8, w11, [x8, #116]
	cmp	w11, #0
	lsr	w13, w8, #3
	cinc	w9, w11, lt
	cmp	w11, #0
	asr	w9, w9, #1
	cinc	w10, w11, lt
	cmp	w4, #2
	asr	w10, w10, #1
	mul	w12, w9, w13
	csel	w14, wzr, wzr, ne
	csel	w15, w11, w10, ne
	cmp	w4, #3
	sbfiz	x10, x12, #3, #32
	csel	w9, w9, w14, eq
	add	x12, x2, x10
	add	x14, x1, x10
	csel	x10, x12, x2, eq
	csel	w11, w11, w15, eq
	csel	x12, x14, x1, eq
	cmp	w9, w11
	b.ge	.LBB27_10
	ldrb	w14, [x3, #56]
	lsr	w17, w8, #2
	ldr	w15, [x3, #72]
	cmp	w13, #1
	ldr	x16, [x3, #120]
	csinc	w13, w13, wzr, hi
	sub	w14, w14, w15
	lsl	w15, w14, #10
	mul	w14, w9, w17
	add	x15, x16, w15, sxtw
	lsl	w16, w17, #1
	lsl	x17, x13, #3
	b	.LBB27_3
.LBB27_2:
	add	w9, w9, #2
	add	w14, w14, w16
	cmp	w9, w11
	b.ge	.LBB27_10
.LBB27_3:
	cmp	w8, #8
	b.lo	.LBB27_2
	add	x1, x0, w14, sxtw
	mov	x2, x13
	mov	x3, x1
.LBB27_5:
	ldr	x4, [x10], #8
	ldr	x5, [x12], #8
	subs	x2, x2, #1
	lsl	w6, w4, #2
	lsr	x7, x4, #6
	lsr	x19, x4, #14
	and	x6, x6, #0x3e0
	and	x7, x7, #0x3e0
	lsr	x20, x4, #22
	bfxil	x6, x5, #3, #5
	and	x19, x19, #0x3e0
	bfxil	x7, x5, #11, #5
	and	x20, x20, #0x3e0
	bfxil	x19, x5, #19, #5
	lsr	x21, x4, #30
	bfxil	x20, x5, #27, #5
	and	x21, x21, #0x3e0
	lsr	x22, x4, #38
	ldrb	w6, [x15, x6]
	ldrb	w7, [x15, x7]
	bfxil	x21, x5, #35, #5
	and	x22, x22, #0x3e0
	lsr	x23, x4, #46
	ldrb	w19, [x15, x19]
	bfxil	x22, x5, #43, #5
	and	x23, x23, #0x3e0
	lsr	x4, x4, #54
	ldrb	w20, [x15, x20]
	bfxil	x23, x5, #51, #5
	and	x4, x4, #0x3e0
	orr	w6, w6, w7, lsl #4
	bfxil	x4, x5, #59, #5
	ldrb	w5, [x15, x21]
	ldrb	w7, [x15, x22]
	orr	w6, w6, w19, lsl #8
	ldrb	w19, [x15, x23]
	orr	w6, w6, w20, lsl #12
	ldrb	w4, [x15, x4]
	orr	w5, w6, w5, lsl #16
	orr	w5, w5, w7, lsl #20
	orr	w5, w5, w19, lsl #24
	orr	w4, w5, w4, lsl #28
	str	w4, [x3], #4
	b.ne	.LBB27_5
	cmp	w8, #8
	b.lo	.LBB27_2
	mov	x2, xzr
.LBB27_8:
	ldr	x3, [x10, x2]
	ldr	x4, [x12, x2]
	add	x2, x2, #8
	cmp	x17, x2
	lsr	x6, x3, #6
	lsl	w5, w3, #2
	and	x6, x6, #0x3e0
	lsr	x7, x3, #14
	and	x5, x5, #0x3e0
	bfxil	x6, x4, #11, #5
	lsr	x19, x3, #22
	bfxil	x5, x4, #3, #5
	and	x7, x7, #0x3e0
	lsr	x20, x3, #30
	bfxil	x7, x4, #19, #5
	and	x19, x19, #0x3e0
	lsr	x21, x3, #38
	and	x20, x20, #0x3e0
	ldrb	w6, [x15, x6]
	bfxil	x19, x4, #27, #5
	ldrb	w5, [x15, x5]
	bfxil	x20, x4, #35, #5
	and	x21, x21, #0x3e0
	lsr	x22, x3, #46
	lsr	x3, x3, #54
	ldrb	w7, [x15, x7]
	bfxil	x21, x4, #43, #5
	and	x22, x22, #0x3e0
	and	x3, x3, #0x3e0
	bfxil	x22, x4, #51, #5
	bfxil	x3, x4, #59, #5
	ldrb	w4, [x15, x19]
	lsl	w6, w6, #6
	ldrb	w19, [x15, x20]
	orr	w5, w6, w5, lsl #2
	ldrb	w6, [x15, x21]
	orr	w5, w5, w7, lsl #10
	ldrb	w7, [x15, x22]
	orr	w4, w5, w4, lsl #14
	ldrb	w3, [x15, x3]
	orr	w4, w4, w19, lsl #18
	ldr	w5, [x1]
	orr	w4, w4, w6, lsl #22
	orr	w4, w4, w7, lsl #26
	orr	w4, w4, w5
	orr	w3, w4, w3, lsl #30
	str	w3, [x1], #4
	b.ne	.LBB27_8
	add	x12, x12, x2
	add	x10, x10, x2
	b	.LBB27_2
.LBB27_10:
	ldp	x20, x19, [sp, #32]
	ldp	x22, x21, [sp, #16]
	ldr	x23, [sp], #48
	ret
.Lfunc_end27:
	.size	direct_mode_data_change2, .Lfunc_end27-direct_mode_data_change2

	.p2align	2
	.type	direct_mode_data_change,@function
direct_mode_data_change:
	str	x19, [sp, #-16]!
	adrp	x8, global_ebc
	ldr	x9, [x8, :lo12:global_ebc]
	ldp	w8, w11, [x9, #116]
	ldr	w13, [x9, #196]
	cmp	w11, #0
	lsr	w14, w8, #3
	cinc	w9, w11, lt
	cmp	w11, #0
	asr	w9, w9, #1
	cinc	w10, w11, lt
	cmp	w4, #2
	asr	w10, w10, #1
	mul	w15, w9, w14
	csel	w12, wzr, wzr, ne
	csel	w10, w11, w10, ne
	cmp	w4, #3
	csel	w9, w9, w12, eq
	sbfiz	x12, x15, #3, #32
	mvn	w15, w9
	add	x17, x1, x12
	add	x12, x2, x12
	lsr	w16, w8, #2
	csel	w10, w11, w10, eq
	add	w15, w11, w15
	csel	x11, x12, x2, eq
	csel	x12, x17, x1, eq
	neg	w17, w8, lsr #2
	cmp	w13, #0
	csel	w15, w9, w15, eq
	csel	w13, w16, w17, eq
	cmp	w9, w10
	b.ge	.LBB28_6
	ldrb	w16, [x3, #56]
	mul	w15, w15, w8
	ldr	w17, [x3, #72]
	cmp	w14, #1
	ldr	x1, [x3, #120]
	lsr	w15, w15, #2
	sxtw	x13, w13
	add	x15, x0, x15
	sub	w16, w16, w17
	csinc	w17, w14, wzr, hi
	lsl	w16, w16, #10
	add	x14, x1, w16, sxtw
	lsl	x16, x17, #1
	b	.LBB28_3
.LBB28_2:
	add	w9, w9, #1
	add	x15, x15, x13
	cmp	w9, w10
	b.eq	.LBB28_6
.LBB28_3:
	cmp	w8, #8
	b.lo	.LBB28_2
	mov	x17, xzr
.LBB28_5:
	ldr	x0, [x11], #8
	ldr	x1, [x12], #8
	lsl	w2, w0, #2
	lsr	x3, x0, #6
	lsr	x4, x0, #14
	and	x2, x2, #0x3e0
	and	x3, x3, #0x3e0
	lsr	x5, x0, #22
	bfxil	x2, x1, #3, #5
	and	x4, x4, #0x3e0
	bfxil	x3, x1, #11, #5
	and	x5, x5, #0x3e0
	bfxil	x4, x1, #19, #5
	lsr	x6, x0, #30
	bfxil	x5, x1, #27, #5
	and	x6, x6, #0x3e0
	lsr	x7, x0, #38
	ldrb	w2, [x14, x2]
	ldrb	w3, [x14, x3]
	bfxil	x6, x1, #35, #5
	and	x7, x7, #0x3e0
	lsr	x19, x0, #46
	ldrb	w4, [x14, x4]
	bfxil	x7, x1, #43, #5
	and	x19, x19, #0x3e0
	lsr	x0, x0, #54
	ldrb	w5, [x14, x5]
	bfxil	x19, x1, #51, #5
	and	x0, x0, #0x3e0
	orr	w2, w2, w3, lsl #2
	bfxil	x0, x1, #59, #5
	ldrb	w1, [x14, x6]
	ldrb	w3, [x14, x7]
	orr	w2, w2, w4, lsl #4
	ldrb	w4, [x14, x19]
	orr	w2, w2, w5, lsl #6
	ldrb	w0, [x14, x0]
	orr	w1, w2, w1, lsl #8
	orr	w1, w1, w3, lsl #10
	orr	w1, w1, w4, lsl #12
	orr	w0, w1, w0, lsl #14
	strh	w0, [x15, x17]
	add	x17, x17, #2
	cmp	x16, x17
	b.ne	.LBB28_5
	b	.LBB28_2
.LBB28_6:
	ldr	x19, [sp], #16
	ret
.Lfunc_end28:
	.size	direct_mode_data_change, .Lfunc_end28-direct_mode_data_change

	.p2align	2
	.type	get_one_auto_image2,@function
get_one_auto_image2:
	ldr	x9, [x0]
	ldr	x8, [x1]
	ldrb	w10, [x3, #56]
	eor	x11, x8, x9
	tst	x11, #0xff
	b.eq	.LBB29_16
	ldrb	w12, [x2]
	lsl	w13, w8, #2
	ldr	x14, [x3, #120]
	and	x13, x13, #0x3e0
	bfxil	x13, x9, #3, #5
	mov	x15, x8
	bfxil	x15, x9, #0, #8
	add	x14, x14, x12, lsl #10
	ldrb	w13, [x14, x13]
	add	w14, w12, #1
	cmp	w10, w14, uxtb
	csinc	w12, wzr, w12, eq
	csel	x8, x15, x8, eq
	lsl	w0, w13, w4
	strb	w12, [x2]
	tst	x11, #0xff00
	b.eq	.LBB29_3
.LBB29_2:
	ldrb	w12, [x2, #1]
	lsr	x13, x8, #6
	ldr	x14, [x3, #120]
	and	x13, x13, #0x3e0
	bfxil	x13, x9, #11, #5
	lsr	x15, x9, #8
	add	w16, w12, #1
	add	x14, x14, x12, lsl #10
	cmp	w10, w16, uxtb
	csinc	w12, wzr, w12, eq
	ldrb	w13, [x14, x13]
	add	w14, w4, #4
	strb	w12, [x2, #1]
	lsl	w13, w13, w14
	mov	x14, x8
	bfi	x14, x15, #8, #8
	orr	w0, w13, w0
	csel	x8, x14, x8, eq
.LBB29_3:
	tst	x11, #0xff0000
	b.eq	.LBB29_5
	ldrb	w12, [x2, #2]
	lsr	x13, x8, #14
	ldr	x14, [x3, #120]
	and	x13, x13, #0x3e0
	bfxil	x13, x9, #19, #5
	lsr	x15, x9, #16
	add	w16, w12, #1
	add	x14, x14, x12, lsl #10
	cmp	w10, w16, uxtb
	csinc	w12, wzr, w12, eq
	ldrb	w13, [x14, x13]
	add	w14, w4, #8
	strb	w12, [x2, #2]
	lsl	w13, w13, w14
	mov	x14, x8
	bfi	x14, x15, #16, #8
	orr	w0, w13, w0
	csel	x8, x14, x8, eq
.LBB29_5:
	tst	x11, #0xff000000
	b.eq	.LBB29_7
	ldrb	w12, [x2, #3]
	lsr	x13, x8, #22
	ldr	x14, [x3, #120]
	and	x13, x13, #0x3e0
	bfxil	x13, x9, #27, #5
	lsr	x15, x9, #24
	add	w16, w12, #1
	add	x14, x14, x12, lsl #10
	cmp	w10, w16, uxtb
	csinc	w12, wzr, w12, eq
	ldrb	w13, [x14, x13]
	add	w14, w4, #12
	strb	w12, [x2, #3]
	lsl	w13, w13, w14
	mov	x14, x8
	bfi	x14, x15, #24, #8
	orr	w0, w13, w0
	csel	x8, x14, x8, eq
.LBB29_7:
	tst	x11, #0xff00000000
	b.eq	.LBB29_9
	ldrb	w12, [x2, #4]
	lsr	x13, x8, #30
	ldr	x14, [x3, #120]
	and	x13, x13, #0x3e0
	bfxil	x13, x9, #35, #5
	lsr	x15, x9, #32
	add	w16, w12, #1
	add	x14, x14, x12, lsl #10
	cmp	w10, w16, uxtb
	csinc	w12, wzr, w12, eq
	ldrb	w13, [x14, x13]
	add	w14, w4, #16
	strb	w12, [x2, #4]
	lsl	w13, w13, w14
	mov	x14, x8
	bfi	x14, x15, #32, #8
	orr	w0, w13, w0
	csel	x8, x14, x8, eq
.LBB29_9:
	tst	x11, #0xff0000000000
	b.eq	.LBB29_11
	ldrb	w12, [x2, #5]
	lsr	x13, x8, #38
	ldr	x14, [x3, #120]
	and	x13, x13, #0x3e0
	bfxil	x13, x9, #43, #5
	lsr	x15, x9, #40
	add	w16, w12, #1
	add	x14, x14, x12, lsl #10
	cmp	w10, w16, uxtb
	csinc	w12, wzr, w12, eq
	ldrb	w13, [x14, x13]
	add	w14, w4, #20
	strb	w12, [x2, #5]
	lsl	w13, w13, w14
	mov	x14, x8
	bfi	x14, x15, #40, #8
	orr	w0, w13, w0
	csel	x8, x14, x8, eq
.LBB29_11:
	tst	x11, #0xff000000000000
	b.eq	.LBB29_13
	ldrb	w12, [x2, #6]
	lsr	x13, x8, #46
	ldr	x14, [x3, #120]
	and	x13, x13, #0x3e0
	bfxil	x13, x9, #51, #5
	lsr	x15, x9, #48
	add	w16, w12, #1
	add	x14, x14, x12, lsl #10
	cmp	w10, w16, uxtb
	csinc	w12, wzr, w12, eq
	ldrb	w13, [x14, x13]
	add	w14, w4, #24
	strb	w12, [x2, #6]
	lsl	w13, w13, w14
	mov	x14, x8
	bfi	x14, x15, #48, #8
	orr	w0, w13, w0
	csel	x8, x14, x8, eq
.LBB29_13:
	lsr	x11, x11, #56
	cbz	x11, .LBB29_15
	ldrb	w11, [x2, #7]
	lsr	x12, x8, #54
	ldr	x13, [x3, #120]
	and	x12, x12, #0x3e0
	bfxil	x12, x9, #59, #5
	bfxil	x9, x8, #0, #56
	add	w14, w11, #1
	add	x13, x13, x11, lsl #10
	cmp	w10, w14, uxtb
	csinc	w11, wzr, w11, eq
	csel	x8, x9, x8, eq
	ldrb	w12, [x13, x12]
	add	w13, w4, #28
	strb	w11, [x2, #7]
	lsl	w10, w12, w13
	orr	w0, w10, w0
.LBB29_15:
	str	x8, [x1]
	ret
.LBB29_16:
	mov	w0, wzr
	tst	x11, #0xff00
	b.ne	.LBB29_2
	b	.LBB29_3
.Lfunc_end29:
	.size	get_one_auto_image2, .Lfunc_end29-get_one_auto_image2

	.p2align	2
	.type	ebc_power_set,@function
ebc_power_set:
	str	x30, [x18], #8
	stp	x29, x30, [sp, #-32]!
	ldr	w8, [x0, #408]
	stp	x20, x19, [sp, #16]
	mov	x29, sp
	cmp	w8, w1
	b.eq	.LBB30_17
	mov	x19, x0
	ldr	w8, [x0, #788]
	cmp	w1, #1
	b.ne	.LBB30_8
	cbz	w8, .LBB30_4
	mov	w0, #1
	bl	ebc_notify
.LBB30_4:
	ldr	w8, [x19, #656]
	cbnz	w8, .LBB30_6
	mov	w8, #1
	add	x0, x19, #464
	str	w8, [x19, #656]
	bl	__pm_stay_awake
.LBB30_6:
	mov	w8, #1
	ldr	x0, [x19, #16]
	str	w8, [x19, #408]
	cbz	x0, .LBB30_15
	ldr	x8, [x0, #32]
	mov	w1, #1
	blr	x8
	mov	w20, wzr
	b	.LBB30_16
.LBB30_8:
	cbz	w8, .LBB30_10
	mov	x0, xzr
	bl	ebc_notify
.LBB30_10:
	ldr	x0, [x19, #8]
	str	wzr, [x19, #408]
	ldr	x8, [x0, #80]
	blr	x8
	ldr	x0, [x19, #16]
	cbz	x0, .LBB30_18
	ldr	x8, [x0, #32]
	mov	w1, wzr
	blr	x8
	mov	w20, wzr
	ldr	w8, [x19, #656]
	cbz	w8, .LBB30_13
.LBB30_12:
	add	x0, x19, #464
	str	wzr, [x19, #656]
	bl	__pm_relax
.LBB30_13:
	ldr	w8, [x19, #792]
	cmp	w8, #1
	b.lt	.LBB30_17
	adrp	x1, .L.str.86
	ldr	x0, [x19, #312]
	add	x1, x1, :lo12:.L.str.86
	b	.LBB30_20
.LBB30_15:
	ldr	x0, [x19, #24]
	bl	regulator_enable
	mov	w20, w0
.LBB30_16:
	ldr	x0, [x19, #8]
	add	x1, x19, #40
	ldr	x8, [x0, #72]
	blr	x8
	ldr	w8, [x19, #792]
	cmp	w8, #1
	b.ge	.LBB30_19
.LBB30_17:
	ldp	x20, x19, [sp, #16]
	ldp	x29, x30, [sp], #32
	ldr	x30, [x18, #-8]!
	ret
.LBB30_18:
	ldr	x0, [x19, #24]
	bl	regulator_disable
	mov	w20, w0
	ldr	w8, [x19, #656]
	cbnz	w8, .LBB30_12
	b	.LBB30_13
.LBB30_19:
	ldr	x0, [x19, #312]
	adrp	x1, .L.str.85
	add	x1, x1, :lo12:.L.str.85
.LBB30_20:
	mov	w2, w20
	bl	_dev_info
	b	.LBB30_17
.Lfunc_end30:
	.size	ebc_power_set, .Lfunc_end30-ebc_power_set

	.p2align	2
	.type	ebc_lut_update,@function
ebc_lut_update:
	sub	sp, sp, #64
	str	x30, [x18], #8
	stp	x29, x30, [sp, #16]
	add	x29, sp, #16
	str	x21, [sp, #32]
	mov	w21, w1
	stp	x20, x19, [sp, #48]
	mrs	x8, SP_EL0
	ldr	x8, [x8, #1584]
	mov	w20, w2
	mov	x19, x0
	str	x8, [sp, #8]
	mov	w8, #25
	ldr	x0, [x0, #16]
	str	w8, [sp, #4]
	cbz	x0, .LBB31_7
	ldr	x8, [x0, #56]
	add	x1, sp, #4
	blr	x8
	mov	w2, w0
	cbz	w2, .LBB31_8
.LBB31_2:
	mov	w8, #25
	ldr	w9, [x19, #792]
	str	w8, [sp, #4]
	tbz	w9, #31, .LBB31_31
.LBB31_3:
	ldr	w8, [x19, #792]
	cmp	w8, #1
	b.ge	.LBB31_18
	cmp	w21, #23
	b.hi	.LBB31_6
.LBB31_5:
	adrp	x9, .LJTI31_0
	mov	w8, w21
	add	x9, x9, :lo12:.LJTI31_0
	mov	w1, wzr
	adr	x10, .LBB31_6
	ldrb	w11, [x9, x8]
	add	x10, x10, x11, lsl #2
	br	x10
.LBB31_6:
	mov	w1, #3
	b	.LBB31_27
.LBB31_7:
	ldr	x0, [x19, #32]
	add	x1, sp, #4
	bl	thermal_zone_get_temp
	ldrsw	x8, [sp, #4]
	mov	w9, #19923
	movk	w9, #4194, lsl #16
	mov	w2, w0
	mul	x8, x8, x9
	lsr	x9, x8, #32
	lsr	x8, x8, #63
	add	w8, w8, w9, asr #6
	str	w8, [sp, #4]
	cbnz	w2, .LBB31_2
.LBB31_8:
	ldr	w2, [sp, #4]
	tbnz	w2, #31, .LBB31_12
	cmp	w2, #51
	b.lo	.LBB31_3
	ldr	w8, [x19, #792]
	tbz	w8, #31, .LBB31_33
.LBB31_11:
	mov	w8, #50
	str	w8, [sp, #4]
	b	.LBB31_3
.LBB31_12:
	ldr	w8, [x19, #792]
	tbz	w8, #31, .LBB31_32
.LBB31_13:
	mov	w8, #25
	str	w8, [sp, #4]
	b	.LBB31_3
.LBB31_14:
	mov	w1, #1
	b	.LBB31_27
.LBB31_15:
	mov	w1, #8
	b	.LBB31_27
.LBB31_16:
	mov	w1, #7
	b	.LBB31_27
.LBB31_17:
	mov	w1, #2
	b	.LBB31_27
.LBB31_18:
	adrp	x1, .L.str.90
	ldr	x0, [x19, #312]
	ldr	w2, [sp, #4]
	add	x1, x1, :lo12:.L.str.90
	bl	_dev_info
	cmp	w21, #23
	b.ls	.LBB31_5
	b	.LBB31_6
.LBB31_19:
	mov	w1, #10
	b	.LBB31_27
.LBB31_20:
	mov	w1, #4
	b	.LBB31_27
.LBB31_21:
	mov	w1, #5
	b	.LBB31_27
.LBB31_22:
	mov	w1, #6
	b	.LBB31_27
.LBB31_23:
	ldr	w8, [x19, #780]
	mov	w9, #3
	cmp	w8, #0
	mov	w8, #14
	csel	w1, w9, w8, eq
	b	.LBB31_27
.LBB31_24:
	ldr	w8, [x19, #780]
	mov	w9, #4
	cmp	w8, #0
	mov	w8, #13
	csel	w1, w9, w8, eq
	b	.LBB31_27
.LBB31_25:
	ldr	w20, [x19, #192]
	mov	w1, #11
	b	.LBB31_27
.LBB31_26:
	ldr	w20, [x19, #192]
	mov	w1, #12
.LBB31_27:
	add	x0, x19, #320
	ldr	w2, [sp, #4]
	mov	w3, #32
	mov	w4, w20
	bl	epd_lut_get
	cbnz	w0, .LBB31_30
.LBB31_28:
	mrs	x8, SP_EL0
	ldr	x8, [x8, #1584]
	ldr	x9, [sp, #8]
	cmp	x8, x9
	b.ne	.LBB31_34
	ldp	x20, x19, [sp, #48]
	ldp	x29, x30, [sp, #16]
	ldr	x21, [sp, #32]
	ldr	x30, [x18, #-8]!
	add	sp, sp, #64
	ret
.LBB31_30:
	adrp	x1, .L.str.91
	ldr	x0, [x19, #312]
	add	x1, x1, :lo12:.L.str.91
	bl	_dev_err
	b	.LBB31_28
.LBB31_31:
	adrp	x1, .L.str.89
	ldr	x0, [x19, #312]
	add	x1, x1, :lo12:.L.str.89
	bl	_dev_info
	b	.LBB31_3
.LBB31_32:
	adrp	x1, .L.str.87
	ldr	x0, [x19, #312]
	add	x1, x1, :lo12:.L.str.87
	bl	_dev_info
	b	.LBB31_13
.LBB31_33:
	adrp	x1, .L.str.88
	ldr	x0, [x19, #312]
	add	x1, x1, :lo12:.L.str.88
	bl	_dev_info
	b	.LBB31_11
.LBB31_34:
	bl	__stack_chk_fail
.Lfunc_end31:
	.size	ebc_lut_update, .Lfunc_end31-ebc_lut_update
	.section	.rodata,"a",@progbits
.LJTI31_0:
	.byte	(.LBB31_6-.LBB31_6)>>2
	.byte	(.LBB31_19-.LBB31_6)>>2
	.byte	(.LBB31_6-.LBB31_6)>>2
	.byte	(.LBB31_20-.LBB31_6)>>2
	.byte	(.LBB31_21-.LBB31_6)>>2
	.byte	(.LBB31_22-.LBB31_6)>>2
	.byte	(.LBB31_15-.LBB31_6)>>2
	.byte	(.LBB31_23-.LBB31_6)>>2
	.byte	(.LBB31_24-.LBB31_6)>>2
	.byte	(.LBB31_25-.LBB31_6)>>2
	.byte	(.LBB31_26-.LBB31_6)>>2
	.byte	(.LBB31_15-.LBB31_6)>>2
	.byte	(.LBB31_16-.LBB31_6)>>2
	.byte	(.LBB31_16-.LBB31_6)>>2
	.byte	(.LBB31_14-.LBB31_6)>>2
	.byte	(.LBB31_17-.LBB31_6)>>2
	.byte	(.LBB31_14-.LBB31_6)>>2
	.byte	(.LBB31_27-.LBB31_6)>>2
	.byte	(.LBB31_6-.LBB31_6)>>2
	.byte	(.LBB31_6-.LBB31_6)>>2
	.byte	(.LBB31_6-.LBB31_6)>>2
	.byte	(.LBB31_6-.LBB31_6)>>2
	.byte	(.LBB31_14-.LBB31_6)>>2
	.byte	(.LBB31_17-.LBB31_6)>>2

	.text
	.p2align	2
	.type	ebc_frame_start,@function
ebc_frame_start:
	str	x30, [x18], #8
	stp	x29, x30, [sp, #-48]!
	ldr	w8, [x0, #456]
	stp	x20, x19, [sp, #32]
	mov	x19, x0
	add	x20, x0, #216
	stp	x22, x21, [sp, #16]
	mov	x29, sp
	cmp	w8, #1
	b.eq	.LBB32_7
	cmp	w8, #3
	b.eq	.LBB32_9
	cmp	w8, #4
	b.ne	.LBB32_13
	ldr	x0, [x19, #392]
	mov	w1, wzr
	ldrsw	x2, [x19, #248]
	bl	memset
	ldp	x4, x0, [x19, #384]
	mov	x5, x20
	ldp	x1, x2, [x19, #352]
	ldr	w8, [x19, #204]
	ldr	x3, [x19, #376]
	cbz	w8, .LBB32_18
	bl	get_overlay_image_area2
	ldr	w8, [x19, #276]
	cbz	w8, .LBB32_19
.LBB32_5:
	ldp	w8, w9, [x19, #172]
	ldr	w10, [x19, #180]
	mov	w3, #1
	ldr	x0, [x19, #40]
	str	wzr, [x19, #112]
	ldr	x1, [x19, #72]
	mov	w22, #1
	ldrsw	x2, [x19, #248]
	add	w8, w9, w8
	add	w21, w8, w10
	bl	dma_sync_single_for_device
	ldr	x0, [x19, #48]
	mov	w1, wzr
	mov	w2, wzr
	mov	w3, wzr
	mov	w4, wzr
	ldr	x8, [x0, #88]
	blr	x8
	ldr	x0, [x19, #48]
	mov	w2, wzr
	ldr	w1, [x19, #72]
	ldr	x8, [x0, #96]
	blr	x8
	ldr	x0, [x19, #48]
	mov	w1, w21
	mov	w2, wzr
	ldr	x8, [x0, #144]
	blr	x8
	ldr	x0, [x19, #48]
	mov	w1, #1
	ldr	x8, [x0, #128]
	blr	x8
	ldr	w8, [x19, #112]
	mov	w1, wzr
	ldr	x0, [x19, #400]
	ldrsw	x2, [x19, #248]
	sub	w8, w22, w8
	str	w8, [x19, #112]
	bl	memset
	ldp	x1, x2, [x19, #352]
	mov	x5, x20
	ldp	x3, x4, [x19, #376]
	ldr	w8, [x19, #204]
	ldr	x0, [x19, #400]
	cbz	w8, .LBB32_26
	bl	get_overlay_image_area2
	b	.LBB32_37
.LBB32_7:
	ldp	x11, x10, [x19, #424]
	mov	x3, x20
	mov	w4, #1
	ldrb	w8, [x19, #272]
	ldr	w9, [x19, #204]
	ldr	x0, [x19, #392]
	str	w8, [x19, #288]
	ldr	x1, [x10, #16]
	ldr	x2, [x11, #16]
	cbz	w9, .LBB32_21
	bl	direct_mode_data_change_part2
	b	.LBB32_22
.LBB32_9:
	ldp	x1, x2, [x19, #352]
	mov	x4, x20
	mov	w5, #1
	ldr	w8, [x19, #204]
	ldr	x0, [x19, #392]
	ldr	x3, [x19, #376]
	cbz	w8, .LBB32_23
	bl	get_auto_image2
	ldr	w8, [x19, #276]
	cbz	w8, .LBB32_24
.LBB32_11:
	ldp	x1, x2, [x19, #352]
	mov	x4, x20
	mov	w5, #1
	ldr	w8, [x19, #204]
	ldr	x0, [x19, #400]
	ldr	x3, [x19, #376]
	cbz	w8, .LBB32_27
	bl	get_auto_image2
	b	.LBB32_36
.LBB32_13:
	ldr	x8, [x19, #432]
	ldr	w9, [x8, #40]
	cmp	w9, #21
	b.ne	.LBB32_16
	ldr	w9, [x19, #840]
	str	wzr, [x19, #848]
	ldr	x11, [x19, #424]
	mov	x3, x20
	ldr	w10, [x19, #204]
	mov	w4, #1
	str	w9, [x19, #844]
	ldr	x0, [x19, #392]
	ldr	x1, [x8, #16]
	ldr	x2, [x11, #16]
	cbz	w10, .LBB32_28
	bl	direct_mode_data_change_full2
	b	.LBB32_29
.LBB32_16:
	ldrb	w9, [x19, #272]
	mov	x3, x20
	ldr	x11, [x19, #424]
	mov	w4, #1
	ldr	w10, [x19, #204]
	str	w9, [x19, #288]
	ldr	x0, [x19, #392]
	ldr	x1, [x8, #16]
	ldr	x2, [x11, #16]
	cbz	w10, .LBB32_31
	bl	direct_mode_data_change2
	b	.LBB32_32
.LBB32_18:
	bl	get_overlay_image_area
	ldr	w8, [x19, #276]
	cbnz	w8, .LBB32_5
.LBB32_19:
	ldr	w8, [x19, #792]
	cmp	w8, #1
	b.lt	.LBB32_25
	adrp	x1, .L.str.92
	adrp	x2, .L__func__.ebc_frame_start
	ldr	x0, [x19, #312]
	add	x1, x1, :lo12:.L.str.92
	b	.LBB32_39
.LBB32_21:
	bl	direct_mode_data_change_part
.LBB32_22:
	ldp	w8, w9, [x19, #172]
	ldr	w10, [x19, #180]
	mov	w3, #1
	ldr	x0, [x19, #40]
	str	wzr, [x19, #112]
	ldr	x1, [x19, #72]
	mov	w21, #1
	ldrsw	x2, [x19, #248]
	add	w8, w9, w8
	add	w20, w8, w10
	bl	dma_sync_single_for_device
	ldr	x0, [x19, #48]
	mov	w1, wzr
	mov	w2, wzr
	mov	w3, wzr
	mov	w4, wzr
	ldr	x8, [x0, #88]
	blr	x8
	ldr	x0, [x19, #48]
	mov	w2, wzr
	ldr	w1, [x19, #72]
	ldr	x8, [x0, #96]
	blr	x8
	ldr	x0, [x19, #48]
	mov	w1, w20
	mov	w2, wzr
	ldr	x8, [x0, #144]
	blr	x8
	ldr	x0, [x19, #48]
	mov	w1, #1
	ldr	x8, [x0, #128]
	blr	x8
	ldr	w8, [x19, #112]
	adrp	x9, ebc_auto_task
	sub	w8, w21, w8
	ldr	x0, [x9, :lo12:ebc_auto_task]
	str	w8, [x19, #112]
	bl	wake_up_process
	b	.LBB32_37
.LBB32_23:
	bl	get_auto_image
	ldr	w8, [x19, #276]
	cbnz	w8, .LBB32_11
.LBB32_24:
	ldr	w8, [x19, #792]
	cmp	w8, #1
	b.ge	.LBB32_38
.LBB32_25:
	str	wzr, [x19, #268]
	b	.LBB32_37
.LBB32_26:
	bl	get_overlay_image_area
	b	.LBB32_37
.LBB32_27:
	bl	get_auto_image
	b	.LBB32_36
.LBB32_28:
	bl	direct_mode_data_change_full
.LBB32_29:
	ldr	w8, [x19, #840]
	mov	x3, x20
	ldr	w9, [x19, #844]
	mov	w4, #1
	ldr	w10, [x19, #204]
	ldr	x0, [x19, #400]
	add	w8, w9, w8
	ldp	x11, x9, [x19, #424]
	str	w8, [x19, #844]
	ldr	x2, [x11, #16]
	ldr	x1, [x9, #16]
	cbz	w10, .LBB32_34
	bl	direct_mode_data_change_full2
	b	.LBB32_36
.LBB32_31:
	bl	direct_mode_data_change
.LBB32_32:
	ldr	w8, [x19, #288]
	mov	x3, x20
	ldp	x11, x10, [x19, #424]
	mov	w4, #1
	sub	w8, w8, #1
	ldr	w9, [x19, #204]
	ldr	x0, [x19, #400]
	str	w8, [x19, #288]
	ldr	x1, [x10, #16]
	ldr	x2, [x11, #16]
	cbz	w9, .LBB32_35
	bl	direct_mode_data_change2
	b	.LBB32_36
.LBB32_34:
	bl	direct_mode_data_change_full
	b	.LBB32_36
.LBB32_35:
	bl	direct_mode_data_change
.LBB32_36:
	ldp	w8, w9, [x19, #172]
	ldr	w10, [x19, #180]
	mov	w3, #1
	ldr	x0, [x19, #40]
	str	wzr, [x19, #112]
	ldr	x1, [x19, #72]
	mov	w21, #1
	ldrsw	x2, [x19, #248]
	add	w8, w9, w8
	add	w20, w8, w10
	bl	dma_sync_single_for_device
	ldr	x0, [x19, #48]
	mov	w1, wzr
	mov	w2, wzr
	mov	w3, wzr
	mov	w4, wzr
	ldr	x8, [x0, #88]
	blr	x8
	ldr	x0, [x19, #48]
	mov	w2, wzr
	ldr	w1, [x19, #72]
	ldr	x8, [x0, #96]
	blr	x8
	ldr	x0, [x19, #48]
	mov	w1, w20
	mov	w2, wzr
	ldr	x8, [x0, #144]
	blr	x8
	ldr	x0, [x19, #48]
	mov	w1, #1
	ldr	x8, [x0, #128]
	blr	x8
	ldr	w8, [x19, #112]
	sub	w8, w21, w8
	str	w8, [x19, #112]
.LBB32_37:
	ldp	x20, x19, [sp, #32]
	ldp	x22, x21, [sp, #16]
	ldp	x29, x30, [sp], #48
	ldr	x30, [x18, #-8]!
	ret
.LBB32_38:
	adrp	x1, .L.str.93
	adrp	x2, .L__func__.ebc_frame_start
	ldr	x0, [x19, #312]
	add	x1, x1, :lo12:.L.str.93
.LBB32_39:
	add	x2, x2, :lo12:.L__func__.ebc_frame_start
	bl	_dev_info
	b	.LBB32_25
.Lfunc_end32:
	.size	ebc_frame_start, .Lfunc_end32-ebc_frame_start

	.p2align	2
	.type	update_repair_buf_ghost,@function
update_repair_buf_ghost:
	sub	w8, w1, #1
	cmp	w8, #2
	b.lt	.LBB33_19
	mov	w10, w0
	lsl	w12, w0, #1
	sub	w11, w0, #1
	mov	x9, xzr
	orr	x12, x12, #0x1
	sub	x13, x11, #1
	mov	w14, #1
	mov	w15, #232
	mov	x16, x10
	b	.LBB33_3
.LBB33_2:
	add	w14, w14, #1
	add	x16, x16, x10
	add	x12, x12, x10
	add	x9, x9, x10
	cmp	w14, w8
	b.eq	.LBB33_19
.LBB33_3:
	cmp	w11, #2
	b.lt	.LBB33_2
	mov	x17, xzr
	b	.LBB33_6
.LBB33_5:
	add	x17, x17, #1
	cmp	x13, x17
	b.eq	.LBB33_2
.LBB33_6:
	add	w0, w16, w17
	add	w0, w0, #1
	sxtw	x0, w0
	ldrb	w1, [x3, x0]
	ldrb	w0, [x2, x0]
	cmp	w1, #240
	ccmp	w0, #1, #0, eq
	b.ne	.LBB33_5
	add	w0, w9, w17
	add	w0, w0, #1
	sxtw	x0, w0
	ldrb	w1, [x2, x0]
	cmp	w1, #248
	b.ne	.LBB33_10
	ldrb	w1, [x3, x0]
	cmp	w1, #240
	b.ne	.LBB33_10
	strb	w15, [x2, x0]
.LBB33_10:
	add	w0, w12, w17
	sxtw	x0, w0
	ldrb	w1, [x2, x0]
	cmp	w1, #248
	b.ne	.LBB33_13
	ldrb	w1, [x3, x0]
	cmp	w1, #240
	b.ne	.LBB33_13
	strb	w15, [x2, x0]
.LBB33_13:
	add	w0, w16, w17
	sxtw	x0, w0
	ldrb	w1, [x2, x0]
	cmp	w1, #248
	b.ne	.LBB33_16
	ldrb	w1, [x3, x0]
	cmp	w1, #240
	b.ne	.LBB33_16
	strb	w15, [x2, x0]
.LBB33_16:
	add	w0, w16, w17
	add	w0, w0, #2
	sxtw	x0, w0
	ldrb	w1, [x2, x0]
	cmp	w1, #248
	b.ne	.LBB33_5
	ldrb	w1, [x3, x0]
	cmp	w1, #240
	b.ne	.LBB33_5
	strb	w15, [x2, x0]
	b	.LBB33_5
.LBB33_19:
	ret
.Lfunc_end33:
	.size	update_repair_buf_ghost, .Lfunc_end33-update_repair_buf_ghost

	.p2align	2
	.type	ebc_frame_control_timeout,@function
ebc_frame_control_timeout:
	str	x30, [x18], #8
	stp	x29, x30, [sp, #-16]!
	adrp	x8, global_ebc
	mov	w10, #1
	mov	x29, sp
	ldr	x8, [x8, :lo12:global_ebc]
	ldr	w9, [x8, #792]
	str	w10, [x8, #756]
	cmp	w9, #1
	b.ge	.LBB34_2
.LBB34_1:
	ldp	x29, x30, [sp], #16
	ldr	x30, [x18, #-8]!
	ret
.LBB34_2:
	adrp	x1, .L.str.96
	ldr	x0, [x8, #312]
	add	x1, x1, :lo12:.L.str.96
	bl	_dev_info
	b	.LBB34_1
.Lfunc_end34:
	.size	ebc_frame_control_timeout, .Lfunc_end34-ebc_frame_control_timeout

	.p2align	2
	.type	ebc_frame_timeout,@function
ebc_frame_timeout:
	str	x30, [x18], #8
	stp	x29, x30, [sp, #-16]!
	mov	x29, sp
	bl	frame_done_callback
	ldp	x29, x30, [sp], #16
	ldr	x30, [x18, #-8]!
	ret
.Lfunc_end35:
	.size	ebc_frame_timeout, .Lfunc_end35-ebc_frame_timeout

	.p2align	2
	.type	ebc_io_ctl,@function
ebc_io_ctl:
	sub	sp, sp, #160
	str	x30, [x18], #8
	stp	x29, x30, [sp, #96]
	add	x29, sp, #96
	str	x23, [sp, #112]
	stp	x22, x21, [sp, #128]
	stp	x20, x19, [sp, #144]
	mrs	x8, SP_EL0
	ldr	x8, [x8, #1584]
	stur	x8, [x29, #-8]
	adrp	x8, global_ebc
	ldr	x22, [x0, #200]
	str	wzr, [sp, #80]
	stp	xzr, xzr, [sp, #64]
	ldr	x21, [x8, :lo12:global_ebc]
	sub	w8, w1, #7, lsl #12
	cmp	w8, #24
	stp	xzr, xzr, [sp, #48]
	stp	xzr, xzr, [sp, #32]
	stp	xzr, xzr, [sp, #16]
	b.hi	.LBB36_53
	adrp	x9, .LJTI36_0
	mov	x19, x2
	add	x9, x9, :lo12:.LJTI36_0
	mov	x20, xzr
	adr	x10, .LBB36_2
	ldrb	w11, [x9, x8]
	add	x10, x10, x11, lsl #2
	br	x10
.LBB36_2:
	cbz	x19, .LBB36_27
	cmp	w8, #23
	b.hi	.LBB36_53
	adrp	x9, .LJTI36_1
	mov	x20, xzr
	add	x9, x9, :lo12:.LJTI36_1
	adr	x10, .LBB36_5
	ldrb	w11, [x9, x8]
	add	x10, x10, x11, lsl #2
	br	x10
.LBB36_5:
	add	x0, sp, #16
	mov	x1, x19
	mov	w2, #68
	add	x20, sp, #16
	bl	_copy_from_user
	cbnz	w0, .LBB36_46
	add	x0, x20, #48
	bl	ebc_empty_buf_get
	cbz	x0, .LBB36_50
	ldr	x23, [x0, #8]
	mov	x20, x0
	bl	ebc_phy_buf_base_get
	mov	w10, #26215
	sub	x8, x23, x0
	ldp	w11, w9, [x21, #116]
	movk	w10, #26214, lsl #16
	str	wzr, [sp, #60]
	str	w8, [sp, #16]
	add	x1, sp, #16
	smull	x10, w8, w10
	ldr	w8, [x21, #192]
	stp	w9, w11, [sp, #24]
	mov	x0, x19
	lsr	x9, x10, #63
	asr	x10, x10, #53
	add	w9, w10, w9
	str	w8, [sp, #32]
	mov	w2, #68
	ldr	w8, [x22, w9, sxtw #2]
	str	w8, [sp, #80]
	bl	_copy_to_user
	cbz	w0, .LBB36_54
	mov	x0, x20
	bl	ebc_buf_release
	mov	x0, #-14
	b	.LBB36_56
.LBB36_9:
	mov	w8, #1
	ldr	w9, [x21, #792]
	str	w8, [x21, #752]
	tbnz	w9, #31, .LBB36_54
	adrp	x1, .L.str.112
	ldr	x0, [x21, #312]
	add	x1, x1, :lo12:.L.str.112
	bl	_dev_info
	b	.LBB36_54
.LBB36_11:
	ldr	w8, [x21, #792]
	str	wzr, [x21, #752]
	tbnz	w8, #31, .LBB36_54
	adrp	x1, .L.str.113
	ldr	x0, [x21, #312]
	add	x1, x1, :lo12:.L.str.113
	bl	_dev_info
	b	.LBB36_54
.LBB36_13:
	mov	w8, #1
	ldr	w9, [x21, #792]
	str	w8, [x21, #760]
	tbnz	w9, #31, .LBB36_54
	adrp	x1, .L.str.110
	ldr	x0, [x21, #312]
	add	x1, x1, :lo12:.L.str.110
	bl	_dev_info
	b	.LBB36_54
.LBB36_15:
	ldr	w8, [x21, #792]
	str	wzr, [x21, #760]
	tbnz	w8, #31, .LBB36_54
	adrp	x1, .L.str.111
	ldr	x0, [x21, #312]
	add	x1, x1, :lo12:.L.str.111
	bl	_dev_info
	b	.LBB36_54
.LBB36_17:
	bl	ebc_drop_one_dsp_buf
	cbnz	w0, .LBB36_46
	b	.LBB36_54
.LBB36_18:
	ldr	w8, [x21, #792]
	tbz	w8, #31, .LBB36_58
.LBB36_19:
	mov	w0, #2
	bl	ebc_notify
	mov	w8, #1
	mov	x20, xzr
	str	w8, [x21, #744]
	str	w8, [x21, #764]
	b	.LBB36_55
.LBB36_20:
	ldr	w8, [x21, #792]
	tbz	w8, #31, .LBB36_59
	ldr	w8, [x21, #744]
	cbz	w8, .LBB36_23
.LBB36_22:
	mov	w0, #3
	bl	ebc_notify
.LBB36_23:
	mov	x20, xzr
	str	wzr, [x21, #744]
	str	wzr, [x21, #764]
	b	.LBB36_55
.LBB36_24:
	add	x0, sp, #12
	mov	x1, x19
	mov	w2, #4
	str	wzr, [sp, #12]
	bl	_copy_from_user
	mov	x20, x0
	cbnz	w20, .LBB36_46
	ldr	w8, [x21, #792]
	tbz	w8, #31, .LBB36_60
.LBB36_26:
	ldr	w8, [sp, #12]
	and	w9, w8, #0xfffffff8
	cmp	w8, #8
	mov	w8, #8
	csel	w8, w8, w9, lt
	str	w8, [x21, #840]
	b	.LBB36_55
.LBB36_27:
	adrp	x1, .L.str.109
	adrp	x2, .L__func__.ebc_io_ctl
	ldr	x0, [x21, #312]
	add	x1, x1, :lo12:.L.str.109
	add	x2, x2, :lo12:.L__func__.ebc_io_ctl
	bl	_dev_err
	mov	x0, #-14
	b	.LBB36_56
.LBB36_28:
	add	x0, sp, #16
	mov	x1, x19
	mov	w2, #68
	bl	_copy_from_user
	cbnz	x0, .LBB36_46
	bl	ebc_phy_buf_base_get
	ldrsw	x8, [sp, #16]
	add	x0, x0, x8
	bl	ebc_find_buf_by_phy_addr
	cbz	x0, .LBB36_54
	ldr	w8, [sp, #20]
	ldr	w9, [sp, #36]
	ldr	x10, [sp, #40]
	str	w8, [x0, #40]
	ldr	w8, [sp, #60]
	str	w9, [x0, #48]
	ldr	w9, [sp, #48]
	stur	x10, [x0, #52]
	stp	w9, w8, [x0, #60]
	bl	ebc_add_to_dsp_buf_list
	b	.LBB36_39
.LBB36_31:
	ldp	w8, w9, [x21, #116]
	ldr	w10, [x21, #192]
	add	x1, sp, #16
	mov	x0, x19
	mov	w2, #68
	str	wzr, [sp, #60]
	stp	w9, w8, [sp, #24]
	ldp	w11, w8, [x21, #132]
	str	w10, [sp, #32]
	stp	w11, w8, [sp, #52]
	bl	_copy_to_user
	cbz	x0, .LBB36_54
	adrp	x1, .L.str.114
	ldr	x0, [x21, #312]
	add	x1, x1, :lo12:.L.str.114
	bl	_dev_err
	b	.LBB36_46
.LBB36_33:
	bl	ebc_empty_osd_buf_get
	cbz	x0, .LBB36_50
	ldr	x20, [x0, #8]
	bl	ebc_phy_buf_base_get
	mov	w10, #26215
	sub	x8, x20, x0
	ldp	w11, w9, [x21, #116]
	movk	w10, #26214, lsl #16
	str	wzr, [sp, #60]
	str	w8, [sp, #16]
	add	x1, sp, #16
	smull	x10, w8, w10
	ldr	w8, [x21, #192]
	stp	w9, w11, [sp, #24]
	mov	x0, x19
	lsr	x9, x10, #63
	asr	x10, x10, #53
	add	w9, w10, w9
	str	w8, [sp, #32]
	mov	w2, #68
	ldr	w8, [x22, w9, sxtw #2]
	str	w8, [sp, #80]
	b	.LBB36_49
.LBB36_35:
	add	x0, sp, #16
	mov	x1, x19
	mov	w2, #68
	bl	_copy_from_user
	cbnz	x0, .LBB36_46
	bl	ebc_osd_buf_clone
	cbz	x0, .LBB36_54
	ldr	w8, [sp, #20]
	ldr	w9, [sp, #36]
	ldr	x10, [sp, #40]
	ldr	w11, [sp, #48]
	str	w8, [x0, #40]
	str	w9, [x0, #48]
	stur	x10, [x0, #52]
	str	w11, [x0, #60]
	bl	ebc_add_to_osd_buf_list
	ldr	w8, [x21, #308]
	cbnz	w8, .LBB36_39
	mov	w8, #1
	str	w8, [x21, #308]
.LBB36_39:
	ldr	w8, [x21, #304]
	cbnz	w8, .LBB36_54
	adrp	x0, ebc_thread_wq
	mov	w8, #1
	add	x0, x0, :lo12:ebc_thread_wq
	mov	w1, #1
	str	w8, [x21, #304]
	bl	__wake_up_sync
	b	.LBB36_54
.LBB36_41:
	add	x1, x21, #752
	b	.LBB36_48
.LBB36_42:
	mov	w8, #1
	add	x1, sp, #12
	str	w8, [sp, #12]
	b	.LBB36_48
.LBB36_43:
	add	x1, x21, #656
	b	.LBB36_48
.LBB36_44:
	ldr	w8, [x21, #856]
	str	wzr, [sp, #12]
	cmp	w8, #3576
	b.ne	.LBB36_54
	add	x0, sp, #12
	mov	x1, x19
	mov	w2, #4
	bl	_copy_from_user
	cbz	w0, .LBB36_51
.LBB36_46:
	mov	x0, #-14
	b	.LBB36_56
.LBB36_47:
	add	x1, x21, #780
.LBB36_48:
	mov	x0, x19
	mov	w2, #4
.LBB36_49:
	bl	_copy_to_user
	mov	x20, x0
	b	.LBB36_55
.LBB36_50:
	mov	x0, #-1
	b	.LBB36_56
.LBB36_51:
	ldr	w8, [x21, #792]
	tbz	w8, #31, .LBB36_61
.LBB36_52:
	ldr	w8, [sp, #12]
	str	w8, [x21, #772]
	b	.LBB36_54
.LBB36_53:
	adrp	x1, .L.str.119
	adrp	x2, .L__func__.ebc_io_ctl
	ldr	x0, [x21, #312]
	add	x1, x1, :lo12:.L.str.119
	add	x2, x2, :lo12:.L__func__.ebc_io_ctl
	bl	_dev_err
.LBB36_54:
	mov	x20, xzr
.LBB36_55:
	sxtw	x0, w20
.LBB36_56:
	mrs	x8, SP_EL0
	ldr	x8, [x8, #1584]
	ldur	x9, [x29, #-8]
	cmp	x8, x9
	b.ne	.LBB36_62
	ldp	x20, x19, [sp, #144]
	ldp	x22, x21, [sp, #128]
	ldp	x29, x30, [sp, #96]
	ldr	x23, [sp, #112]
	ldr	x30, [x18, #-8]!
	add	sp, sp, #160
	ret
.LBB36_58:
	adrp	x1, .L.str.115
	ldr	x0, [x21, #312]
	add	x1, x1, :lo12:.L.str.115
	bl	_dev_info
	b	.LBB36_19
.LBB36_59:
	adrp	x1, .L.str.116
	ldr	x0, [x21, #312]
	add	x1, x1, :lo12:.L.str.116
	bl	_dev_info
	ldr	w8, [x21, #744]
	cbnz	w8, .LBB36_22
	b	.LBB36_23
.LBB36_60:
	adrp	x1, .L.str.118
	ldr	x0, [x21, #312]
	ldr	w2, [sp, #12]
	add	x1, x1, :lo12:.L.str.118
	bl	_dev_info
	b	.LBB36_26
.LBB36_61:
	adrp	x1, .L.str.117
	ldr	x0, [x21, #312]
	ldr	w2, [sp, #12]
	add	x1, x1, :lo12:.L.str.117
	bl	_dev_info
	b	.LBB36_52
.LBB36_62:
	bl	__stack_chk_fail
.Lfunc_end36:
	.size	ebc_io_ctl, .Lfunc_end36-ebc_io_ctl
	.section	.rodata,"a",@progbits
.LJTI36_0:
	.byte	(.LBB36_2-.LBB36_2)>>2
	.byte	(.LBB36_2-.LBB36_2)>>2
	.byte	(.LBB36_2-.LBB36_2)>>2
	.byte	(.LBB36_2-.LBB36_2)>>2
	.byte	(.LBB36_9-.LBB36_2)>>2
	.byte	(.LBB36_11-.LBB36_2)>>2
	.byte	(.LBB36_2-.LBB36_2)>>2
	.byte	(.LBB36_2-.LBB36_2)>>2
	.byte	(.LBB36_55-.LBB36_2)>>2
	.byte	(.LBB36_2-.LBB36_2)>>2
	.byte	(.LBB36_2-.LBB36_2)>>2
	.byte	(.LBB36_2-.LBB36_2)>>2
	.byte	(.LBB36_13-.LBB36_2)>>2
	.byte	(.LBB36_15-.LBB36_2)>>2
	.byte	(.LBB36_55-.LBB36_2)>>2
	.byte	(.LBB36_55-.LBB36_2)>>2
	.byte	(.LBB36_2-.LBB36_2)>>2
	.byte	(.LBB36_17-.LBB36_2)>>2
	.byte	(.LBB36_2-.LBB36_2)>>2
	.byte	(.LBB36_18-.LBB36_2)>>2
	.byte	(.LBB36_20-.LBB36_2)>>2
	.byte	(.LBB36_2-.LBB36_2)>>2
	.byte	(.LBB36_53-.LBB36_2)>>2
	.byte	(.LBB36_2-.LBB36_2)>>2
	.byte	(.LBB36_24-.LBB36_2)>>2
.LJTI36_1:
	.byte	(.LBB36_5-.LBB36_5)>>2
	.byte	(.LBB36_28-.LBB36_5)>>2
	.byte	(.LBB36_31-.LBB36_5)>>2
	.byte	(.LBB36_55-.LBB36_5)>>2
	.byte	(.LBB36_9-.LBB36_5)>>2
	.byte	(.LBB36_11-.LBB36_5)>>2
	.byte	(.LBB36_33-.LBB36_5)>>2
	.byte	(.LBB36_35-.LBB36_5)>>2
	.byte	(.LBB36_55-.LBB36_5)>>2
	.byte	(.LBB36_55-.LBB36_5)>>2
	.byte	(.LBB36_55-.LBB36_5)>>2
	.byte	(.LBB36_41-.LBB36_5)>>2
	.byte	(.LBB36_13-.LBB36_5)>>2
	.byte	(.LBB36_15-.LBB36_5)>>2
	.byte	(.LBB36_55-.LBB36_5)>>2
	.byte	(.LBB36_55-.LBB36_5)>>2
	.byte	(.LBB36_42-.LBB36_5)>>2
	.byte	(.LBB36_17-.LBB36_5)>>2
	.byte	(.LBB36_43-.LBB36_5)>>2
	.byte	(.LBB36_18-.LBB36_5)>>2
	.byte	(.LBB36_20-.LBB36_5)>>2
	.byte	(.LBB36_44-.LBB36_5)>>2
	.byte	(.LBB36_53-.LBB36_5)>>2
	.byte	(.LBB36_47-.LBB36_5)>>2

	.text
	.p2align	2
	.type	ebc_mmap,@function
ebc_mmap:
	str	x30, [x18], #8
	stp	x29, x30, [sp, #-48]!
	str	x21, [sp, #16]
	mov	x29, sp
	stp	x20, x19, [sp, #32]
	mov	x19, x1
	bl	ebc_phy_buf_base_get
	ldr	x8, [x19, #16]
	mov	x20, x0
	ldr	w21, [x8, #152]
	ldr	w8, [x19, #40]
	cmp	w8, w21
	b.eq	.LBB37_2
	ldr	x0, [x19, #48]
	bl	down_write
	str	w21, [x19, #40]
	ldr	x0, [x19, #48]
	bl	up_write
.LBB37_2:
	ldp	x4, x8, [x19, #24]
	mov	w10, #16384
	lsr	x2, x20, #12
	ldp	x1, x9, [x19]
	movk	w10, #1028, lsl #16
	mov	x0, x19
	orr	x8, x8, x10
	sub	x3, x9, x1
	str	x8, [x19, #32]
	bl	remap_pfn_range
	ldp	x20, x19, [sp, #32]
	mov	w8, #-11
	cmp	w0, #0
	ldr	x21, [sp, #16]
	csel	w0, wzr, w8, eq
	ldp	x29, x30, [sp], #48
	ldr	x30, [x18, #-8]!
	ret
.Lfunc_end37:
	.size	ebc_mmap, .Lfunc_end37-ebc_mmap

	.p2align	2
	.type	ebc_open,@function
ebc_open:
	str	x30, [x18], #8
	stp	x29, x30, [sp, #-64]!
	adrp	x9, kmalloc_caches+48
	adrp	x8, global_ebc
	stp	x20, x19, [sp, #48]
	mov	x19, x1
	mov	w1, #3520
	mov	w2, #20
	ldr	x0, [x9, :lo12:kmalloc_caches+48]
	stp	x22, x21, [sp, #32]
	ldr	x22, [x8, :lo12:global_ebc]
	str	x23, [sp, #16]
	mov	x29, sp
	bl	kmalloc_trace
	cbz	x0, .LBB38_7
	mov	x20, x0
	mov	x21, xzr
	add	x22, x22, #800
	mov	w23, #1
.LBB38_2:
	ldr	x0, [x22, x21, lsl #3]
	ldr	x8, [x0, #8]
	//APP
.Ltmp26:
	b	.Ltmp25
.Ltmp27:
	.section	.altinstructions,"a",@progbits
.Ltmp28:
	.word	.Ltmp26-.Ltmp28
.Ltmp29:
	.word	alt_cb_patch_nops-.Ltmp29
	.hword	32794
	.byte	.Ltmp27-.Ltmp26
	.byte	.Ltmp30-.Ltmp31
	.text

.Ltmp31:
.Ltmp30:

	//NO_APP
	add	x8, x8, #56
	//APP
	stadd	x23, [x8]

	//NO_APP
.LBB38_4:
	mov	w1, #524288
	bl	dma_buf_fd
	str	w0, [x20, x21, lsl #2]
	add	x21, x21, #1
	cmp	x21, #5
	b.ne	.LBB38_2
	b	.LBB38_6
.Ltmp25:
.LBB38_5:
	add	x8, x8, #56
	//APP
	// atomic64_add
	prfm	pstl1strm, [x8]
.Ltmp32:
	ldxr	x9, [x8]
	add	x9, x9, #1
	stxr	w10, x9, [x8]
	cbnz	w10, .Ltmp32
	//NO_APP
	b	.LBB38_4
.LBB38_6:
	mov	w0, wzr
	str	x20, [x19, #200]
	str	xzr, [x19, #104]
	b	.LBB38_8
.LBB38_7:
	mov	w0, #-12
.LBB38_8:
	ldp	x20, x19, [sp, #48]
	ldp	x22, x21, [sp, #32]
	ldr	x23, [sp, #16]
	ldp	x29, x30, [sp], #64
	ldr	x30, [x18, #-8]!
	ret
.Lfunc_end38:
	.size	ebc_open, .Lfunc_end38-ebc_open

	.p2align	2
	.type	ebc_release,@function
ebc_release:
	str	x30, [x18], #8
	stp	x29, x30, [sp, #-16]!
	ldr	x0, [x1, #200]
	mov	x29, sp
	bl	kfree
	mov	w0, wzr
	ldp	x29, x30, [sp], #16
	ldr	x30, [x18, #-8]!
	ret
.Lfunc_end39:
	.size	ebc_release, .Lfunc_end39-ebc_release

	.p2align	2
	.type	_copy_to_user,@function
_copy_to_user:
	str	x30, [x18], #8
	stp	x29, x30, [sp, #-16]!
	//APP
	mrs	x8, SP_EL0
	//NO_APP
	ldrb	w9, [x8, #70]
	mov	x29, sp
	tbnz	w9, #5, .LBB40_2
	ldr	x10, [x8]
	mov	x9, x0
	tbz	w10, #26, .LBB40_3
.LBB40_2:
	lsl	x9, x0, #8
	and	x9, x0, x9, asr #8
.LBB40_3:
	mov	x10, #549755813888
	sub	x10, x10, x2
	cmp	x10, x9
	b.lo	.LBB40_18
	//APP
.Ltmp34:
	b	.Ltmp33
.Ltmp35:
	.section	.altinstructions,"a",@progbits
.Ltmp36:
	.word	.Ltmp34-.Ltmp36
.Ltmp37:
	.word	alt_cb_patch_nops-.Ltmp37
	.hword	32769
	.byte	.Ltmp35-.Ltmp34
	.byte	.Ltmp38-.Ltmp39
	.text

.Ltmp39:
.Ltmp38:

	//NO_APP
	//APP
.Ltmp41:
	nop
.Ltmp42:
	.section	.altinstructions,"a",@progbits
.Ltmp43:
	.word	.Ltmp41-.Ltmp43
.Ltmp45:
	.word	.Ltmp44-.Ltmp45
	.hword	29
	.byte	.Ltmp42-.Ltmp41
	.byte	.Ltmp46-.Ltmp44
	.text

	.text	1
.Ltmp44:
	b	.Ltmp40
.Ltmp46:
.Ltmp47:
.org (.Ltmp47-(.Ltmp46-.Ltmp44))+(.Ltmp42-.Ltmp41), 0
.Ltmp48:
.org (.Ltmp48-(.Ltmp42-.Ltmp41))+(.Ltmp46-.Ltmp44), 0
	.text


	//NO_APP
.LBB40_6:
	//APP
.Ltmp49:
	mrs	x9, DAIF
.Ltmp50:
	.section	.altinstructions,"a",@progbits
.Ltmp51:
	.word	.Ltmp49-.Ltmp51
.Ltmp53:
	.word	.Ltmp52-.Ltmp53
	.hword	24
	.byte	.Ltmp50-.Ltmp49
	.byte	.Ltmp54-.Ltmp52
	.text

	.text	1
.Ltmp52:
.set .L__gpr_num_x0, 0
.set .L__gpr_num_w0, 0
.set .L__gpr_num_x1, 1
.set .L__gpr_num_w1, 1
.set .L__gpr_num_x2, 2
.set .L__gpr_num_w2, 2
.set .L__gpr_num_x3, 3
.set .L__gpr_num_w3, 3
.set .L__gpr_num_x4, 4
.set .L__gpr_num_w4, 4
.set .L__gpr_num_x5, 5
.set .L__gpr_num_w5, 5
.set .L__gpr_num_x6, 6
.set .L__gpr_num_w6, 6
.set .L__gpr_num_x7, 7
.set .L__gpr_num_w7, 7
.set .L__gpr_num_x8, 8
.set .L__gpr_num_w8, 8
.set .L__gpr_num_x9, 9
.set .L__gpr_num_w9, 9
.set .L__gpr_num_x10, 10
.set .L__gpr_num_w10, 10
.set .L__gpr_num_x11, 11
.set .L__gpr_num_w11, 11
.set .L__gpr_num_x12, 12
.set .L__gpr_num_w12, 12
.set .L__gpr_num_x13, 13
.set .L__gpr_num_w13, 13
.set .L__gpr_num_x14, 14
.set .L__gpr_num_w14, 14
.set .L__gpr_num_x15, 15
.set .L__gpr_num_w15, 15
.set .L__gpr_num_x16, 16
.set .L__gpr_num_w16, 16
.set .L__gpr_num_x17, 17
.set .L__gpr_num_w17, 17
.set .L__gpr_num_x18, 18
.set .L__gpr_num_w18, 18
.set .L__gpr_num_x19, 19
.set .L__gpr_num_w19, 19
.set .L__gpr_num_x20, 20
.set .L__gpr_num_w20, 20
.set .L__gpr_num_x21, 21
.set .L__gpr_num_w21, 21
.set .L__gpr_num_x22, 22
.set .L__gpr_num_w22, 22
.set .L__gpr_num_x23, 23
.set .L__gpr_num_w23, 23
.set .L__gpr_num_x24, 24
.set .L__gpr_num_w24, 24
.set .L__gpr_num_x25, 25
.set .L__gpr_num_w25, 25
.set .L__gpr_num_x26, 26
.set .L__gpr_num_w26, 26
.set .L__gpr_num_x27, 27
.set .L__gpr_num_w27, 27
.set .L__gpr_num_x28, 28
.set .L__gpr_num_w28, 28
.set .L__gpr_num_x29, 29
.set .L__gpr_num_w29, 29
.set .L__gpr_num_x30, 30
.set .L__gpr_num_w30, 30

.set .L__gpr_num_xzr, 31
.set .L__gpr_num_wzr, 31

	.inst	0xd5384609


.Ltmp54:
.Ltmp55:
.org (.Ltmp55-(.Ltmp54-.Ltmp52))+(.Ltmp50-.Ltmp49), 0
.Ltmp56:
.org (.Ltmp56-(.Ltmp50-.Ltmp49))+(.Ltmp54-.Ltmp52), 0
	.text


	//NO_APP
	//APP
.Ltmp57:
	and	w10, w9, #0x80
.Ltmp58:
	.section	.altinstructions,"a",@progbits
.Ltmp59:
	.word	.Ltmp57-.Ltmp59
.Ltmp61:
	.word	.Ltmp60-.Ltmp61
	.hword	24
	.byte	.Ltmp58-.Ltmp57
	.byte	.Ltmp62-.Ltmp60
	.text

	.text	1
.Ltmp60:
	eor	w10, w9, #0xe0
.Ltmp62:
.Ltmp63:
.org (.Ltmp63-(.Ltmp62-.Ltmp60))+(.Ltmp58-.Ltmp57), 0
.Ltmp64:
.org (.Ltmp64-(.Ltmp58-.Ltmp57))+(.Ltmp62-.Ltmp60), 0
	.text


	//NO_APP
	cbnz	w10, .LBB40_10
	//APP
.Ltmp66:
	nop
	.section	__jump_table,"aw",@progbits
	.p2align	3
.Ltmp67:
	.word	.Ltmp66-.Ltmp67
.Ltmp68:
	.word	.Ltmp65-.Ltmp68
.Ltmp69:
	.xword	gic_nonsecure_priorities-.Ltmp69
	.text


	//NO_APP
	mov	w10, #96
.LBB40_9:
	//APP
.Ltmp70:
	msr	DAIFSet, #3	// arch_local_irq_disable
.Ltmp71:
	.section	.altinstructions,"a",@progbits
.Ltmp72:
	.word	.Ltmp70-.Ltmp72
.Ltmp74:
	.word	.Ltmp73-.Ltmp74
	.hword	24
	.byte	.Ltmp71-.Ltmp70
	.byte	.Ltmp75-.Ltmp73
	.text

	.text	1
.Ltmp73:
.set .L__gpr_num_x0, 0
.set .L__gpr_num_w0, 0
.set .L__gpr_num_x1, 1
.set .L__gpr_num_w1, 1
.set .L__gpr_num_x2, 2
.set .L__gpr_num_w2, 2
.set .L__gpr_num_x3, 3
.set .L__gpr_num_w3, 3
.set .L__gpr_num_x4, 4
.set .L__gpr_num_w4, 4
.set .L__gpr_num_x5, 5
.set .L__gpr_num_w5, 5
.set .L__gpr_num_x6, 6
.set .L__gpr_num_w6, 6
.set .L__gpr_num_x7, 7
.set .L__gpr_num_w7, 7
.set .L__gpr_num_x8, 8
.set .L__gpr_num_w8, 8
.set .L__gpr_num_x9, 9
.set .L__gpr_num_w9, 9
.set .L__gpr_num_x10, 10
.set .L__gpr_num_w10, 10
.set .L__gpr_num_x11, 11
.set .L__gpr_num_w11, 11
.set .L__gpr_num_x12, 12
.set .L__gpr_num_w12, 12
.set .L__gpr_num_x13, 13
.set .L__gpr_num_w13, 13
.set .L__gpr_num_x14, 14
.set .L__gpr_num_w14, 14
.set .L__gpr_num_x15, 15
.set .L__gpr_num_w15, 15
.set .L__gpr_num_x16, 16
.set .L__gpr_num_w16, 16
.set .L__gpr_num_x17, 17
.set .L__gpr_num_w17, 17
.set .L__gpr_num_x18, 18
.set .L__gpr_num_w18, 18
.set .L__gpr_num_x19, 19
.set .L__gpr_num_w19, 19
.set .L__gpr_num_x20, 20
.set .L__gpr_num_w20, 20
.set .L__gpr_num_x21, 21
.set .L__gpr_num_w21, 21
.set .L__gpr_num_x22, 22
.set .L__gpr_num_w22, 22
.set .L__gpr_num_x23, 23
.set .L__gpr_num_w23, 23
.set .L__gpr_num_x24, 24
.set .L__gpr_num_w24, 24
.set .L__gpr_num_x25, 25
.set .L__gpr_num_w25, 25
.set .L__gpr_num_x26, 26
.set .L__gpr_num_w26, 26
.set .L__gpr_num_x27, 27
.set .L__gpr_num_w27, 27
.set .L__gpr_num_x28, 28
.set .L__gpr_num_w28, 28
.set .L__gpr_num_x29, 29
.set .L__gpr_num_w29, 29
.set .L__gpr_num_x30, 30
.set .L__gpr_num_w30, 30

.set .L__gpr_num_xzr, 31
.set .L__gpr_num_wzr, 31

	.inst	0xd518460a


.Ltmp75:
.Ltmp76:
.org (.Ltmp76-(.Ltmp75-.Ltmp73))+(.Ltmp71-.Ltmp70), 0
.Ltmp77:
.org (.Ltmp77-(.Ltmp71-.Ltmp70))+(.Ltmp75-.Ltmp73), 0
	.text


	//NO_APP
.LBB40_10:
	ldr	x8, [x8, #8]
	//APP
	mrs	x10, TTBR1_EL1
	//NO_APP
	mov	x11, x8
	bfxil	x11, x10, #0, #48
	//APP
	msr	TTBR1_EL1, x11
	//NO_APP
	//APP
	isb
	//NO_APP
	//APP
	msr	TTBR0_EL1, x8
	//NO_APP
	//APP
	isb
	//NO_APP
	//APP
.Ltmp78:
	msr	DAIF, x9
.Ltmp79:
	.section	.altinstructions,"a",@progbits
.Ltmp80:
	.word	.Ltmp78-.Ltmp80
.Ltmp82:
	.word	.Ltmp81-.Ltmp82
	.hword	24
	.byte	.Ltmp79-.Ltmp78
	.byte	.Ltmp83-.Ltmp81
	.text

	.text	1
.Ltmp81:
.set .L__gpr_num_x0, 0
.set .L__gpr_num_w0, 0
.set .L__gpr_num_x1, 1
.set .L__gpr_num_w1, 1
.set .L__gpr_num_x2, 2
.set .L__gpr_num_w2, 2
.set .L__gpr_num_x3, 3
.set .L__gpr_num_w3, 3
.set .L__gpr_num_x4, 4
.set .L__gpr_num_w4, 4
.set .L__gpr_num_x5, 5
.set .L__gpr_num_w5, 5
.set .L__gpr_num_x6, 6
.set .L__gpr_num_w6, 6
.set .L__gpr_num_x7, 7
.set .L__gpr_num_w7, 7
.set .L__gpr_num_x8, 8
.set .L__gpr_num_w8, 8
.set .L__gpr_num_x9, 9
.set .L__gpr_num_w9, 9
.set .L__gpr_num_x10, 10
.set .L__gpr_num_w10, 10
.set .L__gpr_num_x11, 11
.set .L__gpr_num_w11, 11
.set .L__gpr_num_x12, 12
.set .L__gpr_num_w12, 12
.set .L__gpr_num_x13, 13
.set .L__gpr_num_w13, 13
.set .L__gpr_num_x14, 14
.set .L__gpr_num_w14, 14
.set .L__gpr_num_x15, 15
.set .L__gpr_num_w15, 15
.set .L__gpr_num_x16, 16
.set .L__gpr_num_w16, 16
.set .L__gpr_num_x17, 17
.set .L__gpr_num_w17, 17
.set .L__gpr_num_x18, 18
.set .L__gpr_num_w18, 18
.set .L__gpr_num_x19, 19
.set .L__gpr_num_w19, 19
.set .L__gpr_num_x20, 20
.set .L__gpr_num_w20, 20
.set .L__gpr_num_x21, 21
.set .L__gpr_num_w21, 21
.set .L__gpr_num_x22, 22
.set .L__gpr_num_w22, 22
.set .L__gpr_num_x23, 23
.set .L__gpr_num_w23, 23
.set .L__gpr_num_x24, 24
.set .L__gpr_num_w24, 24
.set .L__gpr_num_x25, 25
.set .L__gpr_num_w25, 25
.set .L__gpr_num_x26, 26
.set .L__gpr_num_w26, 26
.set .L__gpr_num_x27, 27
.set .L__gpr_num_w27, 27
.set .L__gpr_num_x28, 28
.set .L__gpr_num_w28, 28
.set .L__gpr_num_x29, 29
.set .L__gpr_num_w29, 29
.set .L__gpr_num_x30, 30
.set .L__gpr_num_w30, 30

.set .L__gpr_num_xzr, 31
.set .L__gpr_num_wzr, 31

	.inst	0xd5184609


.Ltmp83:
.Ltmp84:
.org (.Ltmp84-(.Ltmp83-.Ltmp81))+(.Ltmp79-.Ltmp78), 0
.Ltmp85:
.org (.Ltmp85-(.Ltmp79-.Ltmp78))+(.Ltmp83-.Ltmp81), 0
	.text


	//NO_APP
	//APP
.Ltmp87:
	nop
	.section	__jump_table,"aw",@progbits
	.p2align	3
.Ltmp88:
	.word	.Ltmp87-.Ltmp88
.Ltmp89:
	.word	.Ltmp86-.Ltmp89
.Ltmp90:
	.xword	gic_pmr_sync-.Ltmp90
	.text


	//NO_APP
.Ltmp40:
.LBB40_11:
	//APP
	and	x0, x0, #0xff7fffffffffffff

	//NO_APP
	bl	__arch_copy_to_user
	mov	x2, x0
	//APP
.Ltmp92:
	b	.Ltmp91
.Ltmp93:
	.section	.altinstructions,"a",@progbits
.Ltmp94:
	.word	.Ltmp92-.Ltmp94
.Ltmp95:
	.word	alt_cb_patch_nops-.Ltmp95
	.hword	32769
	.byte	.Ltmp93-.Ltmp92
	.byte	.Ltmp96-.Ltmp97
	.text

.Ltmp97:
.Ltmp96:

	//NO_APP
	//APP
.Ltmp99:
	nop
.Ltmp100:
	.section	.altinstructions,"a",@progbits
.Ltmp101:
	.word	.Ltmp99-.Ltmp101
.Ltmp103:
	.word	.Ltmp102-.Ltmp103
	.hword	29
	.byte	.Ltmp100-.Ltmp99
	.byte	.Ltmp104-.Ltmp102
	.text

	.text	1
.Ltmp102:
	b	.Ltmp98
.Ltmp104:
.Ltmp105:
.org (.Ltmp105-(.Ltmp104-.Ltmp102))+(.Ltmp100-.Ltmp99), 0
.Ltmp106:
.org (.Ltmp106-(.Ltmp100-.Ltmp99))+(.Ltmp104-.Ltmp102), 0
	.text


	//NO_APP
.LBB40_13:
	//APP
.Ltmp107:
	mrs	x8, DAIF
.Ltmp108:
	.section	.altinstructions,"a",@progbits
.Ltmp109:
	.word	.Ltmp107-.Ltmp109
.Ltmp111:
	.word	.Ltmp110-.Ltmp111
	.hword	24
	.byte	.Ltmp108-.Ltmp107
	.byte	.Ltmp112-.Ltmp110
	.text

	.text	1
.Ltmp110:
.set .L__gpr_num_x0, 0
.set .L__gpr_num_w0, 0
.set .L__gpr_num_x1, 1
.set .L__gpr_num_w1, 1
.set .L__gpr_num_x2, 2
.set .L__gpr_num_w2, 2
.set .L__gpr_num_x3, 3
.set .L__gpr_num_w3, 3
.set .L__gpr_num_x4, 4
.set .L__gpr_num_w4, 4
.set .L__gpr_num_x5, 5
.set .L__gpr_num_w5, 5
.set .L__gpr_num_x6, 6
.set .L__gpr_num_w6, 6
.set .L__gpr_num_x7, 7
.set .L__gpr_num_w7, 7
.set .L__gpr_num_x8, 8
.set .L__gpr_num_w8, 8
.set .L__gpr_num_x9, 9
.set .L__gpr_num_w9, 9
.set .L__gpr_num_x10, 10
.set .L__gpr_num_w10, 10
.set .L__gpr_num_x11, 11
.set .L__gpr_num_w11, 11
.set .L__gpr_num_x12, 12
.set .L__gpr_num_w12, 12
.set .L__gpr_num_x13, 13
.set .L__gpr_num_w13, 13
.set .L__gpr_num_x14, 14
.set .L__gpr_num_w14, 14
.set .L__gpr_num_x15, 15
.set .L__gpr_num_w15, 15
.set .L__gpr_num_x16, 16
.set .L__gpr_num_w16, 16
.set .L__gpr_num_x17, 17
.set .L__gpr_num_w17, 17
.set .L__gpr_num_x18, 18
.set .L__gpr_num_w18, 18
.set .L__gpr_num_x19, 19
.set .L__gpr_num_w19, 19
.set .L__gpr_num_x20, 20
.set .L__gpr_num_w20, 20
.set .L__gpr_num_x21, 21
.set .L__gpr_num_w21, 21
.set .L__gpr_num_x22, 22
.set .L__gpr_num_w22, 22
.set .L__gpr_num_x23, 23
.set .L__gpr_num_w23, 23
.set .L__gpr_num_x24, 24
.set .L__gpr_num_w24, 24
.set .L__gpr_num_x25, 25
.set .L__gpr_num_w25, 25
.set .L__gpr_num_x26, 26
.set .L__gpr_num_w26, 26
.set .L__gpr_num_x27, 27
.set .L__gpr_num_w27, 27
.set .L__gpr_num_x28, 28
.set .L__gpr_num_w28, 28
.set .L__gpr_num_x29, 29
.set .L__gpr_num_w29, 29
.set .L__gpr_num_x30, 30
.set .L__gpr_num_w30, 30

.set .L__gpr_num_xzr, 31
.set .L__gpr_num_wzr, 31

	.inst	0xd5384608


.Ltmp112:
.Ltmp113:
.org (.Ltmp113-(.Ltmp112-.Ltmp110))+(.Ltmp108-.Ltmp107), 0
.Ltmp114:
.org (.Ltmp114-(.Ltmp108-.Ltmp107))+(.Ltmp112-.Ltmp110), 0
	.text


	//NO_APP
	//APP
.Ltmp115:
	and	w9, w8, #0x80
.Ltmp116:
	.section	.altinstructions,"a",@progbits
.Ltmp117:
	.word	.Ltmp115-.Ltmp117
.Ltmp119:
	.word	.Ltmp118-.Ltmp119
	.hword	24
	.byte	.Ltmp116-.Ltmp115
	.byte	.Ltmp120-.Ltmp118
	.text

	.text	1
.Ltmp118:
	eor	w9, w8, #0xe0
.Ltmp120:
.Ltmp121:
.org (.Ltmp121-(.Ltmp120-.Ltmp118))+(.Ltmp116-.Ltmp115), 0
.Ltmp122:
.org (.Ltmp122-(.Ltmp116-.Ltmp115))+(.Ltmp120-.Ltmp118), 0
	.text


	//NO_APP
	cbnz	w9, .LBB40_17
	//APP
.Ltmp124:
	nop
	.section	__jump_table,"aw",@progbits
	.p2align	3
.Ltmp125:
	.word	.Ltmp124-.Ltmp125
.Ltmp126:
	.word	.Ltmp123-.Ltmp126
.Ltmp127:
	.xword	gic_nonsecure_priorities-.Ltmp127
	.text


	//NO_APP
	mov	w9, #96
.LBB40_16:
	//APP
.Ltmp128:
	msr	DAIFSet, #3	// arch_local_irq_disable
.Ltmp129:
	.section	.altinstructions,"a",@progbits
.Ltmp130:
	.word	.Ltmp128-.Ltmp130
.Ltmp132:
	.word	.Ltmp131-.Ltmp132
	.hword	24
	.byte	.Ltmp129-.Ltmp128
	.byte	.Ltmp133-.Ltmp131
	.text

	.text	1
.Ltmp131:
.set .L__gpr_num_x0, 0
.set .L__gpr_num_w0, 0
.set .L__gpr_num_x1, 1
.set .L__gpr_num_w1, 1
.set .L__gpr_num_x2, 2
.set .L__gpr_num_w2, 2
.set .L__gpr_num_x3, 3
.set .L__gpr_num_w3, 3
.set .L__gpr_num_x4, 4
.set .L__gpr_num_w4, 4
.set .L__gpr_num_x5, 5
.set .L__gpr_num_w5, 5
.set .L__gpr_num_x6, 6
.set .L__gpr_num_w6, 6
.set .L__gpr_num_x7, 7
.set .L__gpr_num_w7, 7
.set .L__gpr_num_x8, 8
.set .L__gpr_num_w8, 8
.set .L__gpr_num_x9, 9
.set .L__gpr_num_w9, 9
.set .L__gpr_num_x10, 10
.set .L__gpr_num_w10, 10
.set .L__gpr_num_x11, 11
.set .L__gpr_num_w11, 11
.set .L__gpr_num_x12, 12
.set .L__gpr_num_w12, 12
.set .L__gpr_num_x13, 13
.set .L__gpr_num_w13, 13
.set .L__gpr_num_x14, 14
.set .L__gpr_num_w14, 14
.set .L__gpr_num_x15, 15
.set .L__gpr_num_w15, 15
.set .L__gpr_num_x16, 16
.set .L__gpr_num_w16, 16
.set .L__gpr_num_x17, 17
.set .L__gpr_num_w17, 17
.set .L__gpr_num_x18, 18
.set .L__gpr_num_w18, 18
.set .L__gpr_num_x19, 19
.set .L__gpr_num_w19, 19
.set .L__gpr_num_x20, 20
.set .L__gpr_num_w20, 20
.set .L__gpr_num_x21, 21
.set .L__gpr_num_w21, 21
.set .L__gpr_num_x22, 22
.set .L__gpr_num_w22, 22
.set .L__gpr_num_x23, 23
.set .L__gpr_num_w23, 23
.set .L__gpr_num_x24, 24
.set .L__gpr_num_w24, 24
.set .L__gpr_num_x25, 25
.set .L__gpr_num_w25, 25
.set .L__gpr_num_x26, 26
.set .L__gpr_num_w26, 26
.set .L__gpr_num_x27, 27
.set .L__gpr_num_w27, 27
.set .L__gpr_num_x28, 28
.set .L__gpr_num_w28, 28
.set .L__gpr_num_x29, 29
.set .L__gpr_num_w29, 29
.set .L__gpr_num_x30, 30
.set .L__gpr_num_w30, 30

.set .L__gpr_num_xzr, 31
.set .L__gpr_num_wzr, 31

	.inst	0xd5184609


.Ltmp133:
.Ltmp134:
.org (.Ltmp134-(.Ltmp133-.Ltmp131))+(.Ltmp129-.Ltmp128), 0
.Ltmp135:
.org (.Ltmp135-(.Ltmp129-.Ltmp128))+(.Ltmp133-.Ltmp131), 0
	.text


	//NO_APP
.LBB40_17:
	//APP
	mrs	x9, TTBR1_EL1
	//NO_APP
	and	x9, x9, #0xffffffffffff
	sub	x10, x9, #1, lsl #12
	//APP
	msr	TTBR0_EL1, x10
	//NO_APP
	//APP
	isb
	//NO_APP
	//APP
	msr	TTBR1_EL1, x9
	//NO_APP
	//APP
	isb
	//NO_APP
	//APP
.Ltmp136:
	msr	DAIF, x8
.Ltmp137:
	.section	.altinstructions,"a",@progbits
.Ltmp138:
	.word	.Ltmp136-.Ltmp138
.Ltmp140:
	.word	.Ltmp139-.Ltmp140
	.hword	24
	.byte	.Ltmp137-.Ltmp136
	.byte	.Ltmp141-.Ltmp139
	.text

	.text	1
.Ltmp139:
.set .L__gpr_num_x0, 0
.set .L__gpr_num_w0, 0
.set .L__gpr_num_x1, 1
.set .L__gpr_num_w1, 1
.set .L__gpr_num_x2, 2
.set .L__gpr_num_w2, 2
.set .L__gpr_num_x3, 3
.set .L__gpr_num_w3, 3
.set .L__gpr_num_x4, 4
.set .L__gpr_num_w4, 4
.set .L__gpr_num_x5, 5
.set .L__gpr_num_w5, 5
.set .L__gpr_num_x6, 6
.set .L__gpr_num_w6, 6
.set .L__gpr_num_x7, 7
.set .L__gpr_num_w7, 7
.set .L__gpr_num_x8, 8
.set .L__gpr_num_w8, 8
.set .L__gpr_num_x9, 9
.set .L__gpr_num_w9, 9
.set .L__gpr_num_x10, 10
.set .L__gpr_num_w10, 10
.set .L__gpr_num_x11, 11
.set .L__gpr_num_w11, 11
.set .L__gpr_num_x12, 12
.set .L__gpr_num_w12, 12
.set .L__gpr_num_x13, 13
.set .L__gpr_num_w13, 13
.set .L__gpr_num_x14, 14
.set .L__gpr_num_w14, 14
.set .L__gpr_num_x15, 15
.set .L__gpr_num_w15, 15
.set .L__gpr_num_x16, 16
.set .L__gpr_num_w16, 16
.set .L__gpr_num_x17, 17
.set .L__gpr_num_w17, 17
.set .L__gpr_num_x18, 18
.set .L__gpr_num_w18, 18
.set .L__gpr_num_x19, 19
.set .L__gpr_num_w19, 19
.set .L__gpr_num_x20, 20
.set .L__gpr_num_w20, 20
.set .L__gpr_num_x21, 21
.set .L__gpr_num_w21, 21
.set .L__gpr_num_x22, 22
.set .L__gpr_num_w22, 22
.set .L__gpr_num_x23, 23
.set .L__gpr_num_w23, 23
.set .L__gpr_num_x24, 24
.set .L__gpr_num_w24, 24
.set .L__gpr_num_x25, 25
.set .L__gpr_num_w25, 25
.set .L__gpr_num_x26, 26
.set .L__gpr_num_w26, 26
.set .L__gpr_num_x27, 27
.set .L__gpr_num_w27, 27
.set .L__gpr_num_x28, 28
.set .L__gpr_num_w28, 28
.set .L__gpr_num_x29, 29
.set .L__gpr_num_w29, 29
.set .L__gpr_num_x30, 30
.set .L__gpr_num_w30, 30

.set .L__gpr_num_xzr, 31
.set .L__gpr_num_wzr, 31

	.inst	0xd5184608


.Ltmp141:
.Ltmp142:
.org (.Ltmp142-(.Ltmp141-.Ltmp139))+(.Ltmp137-.Ltmp136), 0
.Ltmp143:
.org (.Ltmp143-(.Ltmp137-.Ltmp136))+(.Ltmp141-.Ltmp139), 0
	.text


	//NO_APP
	//APP
.Ltmp145:
	nop
	.section	__jump_table,"aw",@progbits
	.p2align	3
.Ltmp146:
	.word	.Ltmp145-.Ltmp146
.Ltmp147:
	.word	.Ltmp144-.Ltmp147
.Ltmp148:
	.xword	gic_pmr_sync-.Ltmp148
	.text


	//NO_APP
.Ltmp98:
.LBB40_18:
	mov	x0, x2
	ldp	x29, x30, [sp], #16
	ldr	x30, [x18, #-8]!
	ret
.Ltmp33:
.LBB40_19:
	adrp	x9, cpu_hwcaps
	ldr	x9, [x9, :lo12:cpu_hwcaps]
	tbnz	w9, #29, .LBB40_11
	b	.LBB40_6
.Ltmp86:
.LBB40_20:
	//APP
	dsb	sy
	//NO_APP
	b	.LBB40_11
.Ltmp91:
.LBB40_21:
	adrp	x8, cpu_hwcaps
	ldr	x8, [x8, :lo12:cpu_hwcaps]
	tbnz	w8, #29, .LBB40_18
	b	.LBB40_13
.Ltmp144:
.LBB40_22:
	//APP
	dsb	sy
	//NO_APP
	b	.LBB40_18
.Ltmp65:
.LBB40_23:
	mov	w10, #160
	b	.LBB40_9
.Ltmp123:
.LBB40_24:
	mov	w9, #160
	b	.LBB40_16
.Lfunc_end40:
	.size	_copy_to_user, .Lfunc_end40-_copy_to_user

	.p2align	2
	.type	_copy_from_user,@function
_copy_from_user:
	str	x30, [x18], #8
	stp	x29, x30, [sp, #-48]!
	stp	x20, x19, [sp, #32]
	mov	x19, x2
	//APP
	mrs	x8, SP_EL0
	//NO_APP
	ldrb	w9, [x8, #70]
	mov	x20, x0
	str	x21, [sp, #16]
	mov	x29, sp
	tbnz	w9, #5, .LBB41_2
	ldr	x10, [x8]
	mov	x9, x1
	tbz	w10, #26, .LBB41_3
.LBB41_2:
	lsl	x9, x1, #8
	and	x9, x1, x9, asr #8
.LBB41_3:
	mov	x10, #549755813888
	mov	x21, x19
	sub	x10, x10, x19
	cmp	x10, x9
	b.lo	.LBB41_18
	//APP
.Ltmp150:
	b	.Ltmp149
.Ltmp151:
	.section	.altinstructions,"a",@progbits
.Ltmp152:
	.word	.Ltmp150-.Ltmp152
.Ltmp153:
	.word	alt_cb_patch_nops-.Ltmp153
	.hword	32769
	.byte	.Ltmp151-.Ltmp150
	.byte	.Ltmp154-.Ltmp155
	.text

.Ltmp155:
.Ltmp154:

	//NO_APP
	//APP
.Ltmp157:
	nop
.Ltmp158:
	.section	.altinstructions,"a",@progbits
.Ltmp159:
	.word	.Ltmp157-.Ltmp159
.Ltmp161:
	.word	.Ltmp160-.Ltmp161
	.hword	29
	.byte	.Ltmp158-.Ltmp157
	.byte	.Ltmp162-.Ltmp160
	.text

	.text	1
.Ltmp160:
	b	.Ltmp156
.Ltmp162:
.Ltmp163:
.org (.Ltmp163-(.Ltmp162-.Ltmp160))+(.Ltmp158-.Ltmp157), 0
.Ltmp164:
.org (.Ltmp164-(.Ltmp158-.Ltmp157))+(.Ltmp162-.Ltmp160), 0
	.text


	//NO_APP
.LBB41_6:
	//APP
.Ltmp165:
	mrs	x9, DAIF
.Ltmp166:
	.section	.altinstructions,"a",@progbits
.Ltmp167:
	.word	.Ltmp165-.Ltmp167
.Ltmp169:
	.word	.Ltmp168-.Ltmp169
	.hword	24
	.byte	.Ltmp166-.Ltmp165
	.byte	.Ltmp170-.Ltmp168
	.text

	.text	1
.Ltmp168:
.set .L__gpr_num_x0, 0
.set .L__gpr_num_w0, 0
.set .L__gpr_num_x1, 1
.set .L__gpr_num_w1, 1
.set .L__gpr_num_x2, 2
.set .L__gpr_num_w2, 2
.set .L__gpr_num_x3, 3
.set .L__gpr_num_w3, 3
.set .L__gpr_num_x4, 4
.set .L__gpr_num_w4, 4
.set .L__gpr_num_x5, 5
.set .L__gpr_num_w5, 5
.set .L__gpr_num_x6, 6
.set .L__gpr_num_w6, 6
.set .L__gpr_num_x7, 7
.set .L__gpr_num_w7, 7
.set .L__gpr_num_x8, 8
.set .L__gpr_num_w8, 8
.set .L__gpr_num_x9, 9
.set .L__gpr_num_w9, 9
.set .L__gpr_num_x10, 10
.set .L__gpr_num_w10, 10
.set .L__gpr_num_x11, 11
.set .L__gpr_num_w11, 11
.set .L__gpr_num_x12, 12
.set .L__gpr_num_w12, 12
.set .L__gpr_num_x13, 13
.set .L__gpr_num_w13, 13
.set .L__gpr_num_x14, 14
.set .L__gpr_num_w14, 14
.set .L__gpr_num_x15, 15
.set .L__gpr_num_w15, 15
.set .L__gpr_num_x16, 16
.set .L__gpr_num_w16, 16
.set .L__gpr_num_x17, 17
.set .L__gpr_num_w17, 17
.set .L__gpr_num_x18, 18
.set .L__gpr_num_w18, 18
.set .L__gpr_num_x19, 19
.set .L__gpr_num_w19, 19
.set .L__gpr_num_x20, 20
.set .L__gpr_num_w20, 20
.set .L__gpr_num_x21, 21
.set .L__gpr_num_w21, 21
.set .L__gpr_num_x22, 22
.set .L__gpr_num_w22, 22
.set .L__gpr_num_x23, 23
.set .L__gpr_num_w23, 23
.set .L__gpr_num_x24, 24
.set .L__gpr_num_w24, 24
.set .L__gpr_num_x25, 25
.set .L__gpr_num_w25, 25
.set .L__gpr_num_x26, 26
.set .L__gpr_num_w26, 26
.set .L__gpr_num_x27, 27
.set .L__gpr_num_w27, 27
.set .L__gpr_num_x28, 28
.set .L__gpr_num_w28, 28
.set .L__gpr_num_x29, 29
.set .L__gpr_num_w29, 29
.set .L__gpr_num_x30, 30
.set .L__gpr_num_w30, 30

.set .L__gpr_num_xzr, 31
.set .L__gpr_num_wzr, 31

	.inst	0xd5384609


.Ltmp170:
.Ltmp171:
.org (.Ltmp171-(.Ltmp170-.Ltmp168))+(.Ltmp166-.Ltmp165), 0
.Ltmp172:
.org (.Ltmp172-(.Ltmp166-.Ltmp165))+(.Ltmp170-.Ltmp168), 0
	.text


	//NO_APP
	//APP
.Ltmp173:
	and	w10, w9, #0x80
.Ltmp174:
	.section	.altinstructions,"a",@progbits
.Ltmp175:
	.word	.Ltmp173-.Ltmp175
.Ltmp177:
	.word	.Ltmp176-.Ltmp177
	.hword	24
	.byte	.Ltmp174-.Ltmp173
	.byte	.Ltmp178-.Ltmp176
	.text

	.text	1
.Ltmp176:
	eor	w10, w9, #0xe0
.Ltmp178:
.Ltmp179:
.org (.Ltmp179-(.Ltmp178-.Ltmp176))+(.Ltmp174-.Ltmp173), 0
.Ltmp180:
.org (.Ltmp180-(.Ltmp174-.Ltmp173))+(.Ltmp178-.Ltmp176), 0
	.text


	//NO_APP
	cbnz	w10, .LBB41_10
	//APP
.Ltmp182:
	nop
	.section	__jump_table,"aw",@progbits
	.p2align	3
.Ltmp183:
	.word	.Ltmp182-.Ltmp183
.Ltmp184:
	.word	.Ltmp181-.Ltmp184
.Ltmp185:
	.xword	gic_nonsecure_priorities-.Ltmp185
	.text


	//NO_APP
	mov	w10, #96
.LBB41_9:
	//APP
.Ltmp186:
	msr	DAIFSet, #3	// arch_local_irq_disable
.Ltmp187:
	.section	.altinstructions,"a",@progbits
.Ltmp188:
	.word	.Ltmp186-.Ltmp188
.Ltmp190:
	.word	.Ltmp189-.Ltmp190
	.hword	24
	.byte	.Ltmp187-.Ltmp186
	.byte	.Ltmp191-.Ltmp189
	.text

	.text	1
.Ltmp189:
.set .L__gpr_num_x0, 0
.set .L__gpr_num_w0, 0
.set .L__gpr_num_x1, 1
.set .L__gpr_num_w1, 1
.set .L__gpr_num_x2, 2
.set .L__gpr_num_w2, 2
.set .L__gpr_num_x3, 3
.set .L__gpr_num_w3, 3
.set .L__gpr_num_x4, 4
.set .L__gpr_num_w4, 4
.set .L__gpr_num_x5, 5
.set .L__gpr_num_w5, 5
.set .L__gpr_num_x6, 6
.set .L__gpr_num_w6, 6
.set .L__gpr_num_x7, 7
.set .L__gpr_num_w7, 7
.set .L__gpr_num_x8, 8
.set .L__gpr_num_w8, 8
.set .L__gpr_num_x9, 9
.set .L__gpr_num_w9, 9
.set .L__gpr_num_x10, 10
.set .L__gpr_num_w10, 10
.set .L__gpr_num_x11, 11
.set .L__gpr_num_w11, 11
.set .L__gpr_num_x12, 12
.set .L__gpr_num_w12, 12
.set .L__gpr_num_x13, 13
.set .L__gpr_num_w13, 13
.set .L__gpr_num_x14, 14
.set .L__gpr_num_w14, 14
.set .L__gpr_num_x15, 15
.set .L__gpr_num_w15, 15
.set .L__gpr_num_x16, 16
.set .L__gpr_num_w16, 16
.set .L__gpr_num_x17, 17
.set .L__gpr_num_w17, 17
.set .L__gpr_num_x18, 18
.set .L__gpr_num_w18, 18
.set .L__gpr_num_x19, 19
.set .L__gpr_num_w19, 19
.set .L__gpr_num_x20, 20
.set .L__gpr_num_w20, 20
.set .L__gpr_num_x21, 21
.set .L__gpr_num_w21, 21
.set .L__gpr_num_x22, 22
.set .L__gpr_num_w22, 22
.set .L__gpr_num_x23, 23
.set .L__gpr_num_w23, 23
.set .L__gpr_num_x24, 24
.set .L__gpr_num_w24, 24
.set .L__gpr_num_x25, 25
.set .L__gpr_num_w25, 25
.set .L__gpr_num_x26, 26
.set .L__gpr_num_w26, 26
.set .L__gpr_num_x27, 27
.set .L__gpr_num_w27, 27
.set .L__gpr_num_x28, 28
.set .L__gpr_num_w28, 28
.set .L__gpr_num_x29, 29
.set .L__gpr_num_w29, 29
.set .L__gpr_num_x30, 30
.set .L__gpr_num_w30, 30

.set .L__gpr_num_xzr, 31
.set .L__gpr_num_wzr, 31

	.inst	0xd518460a


.Ltmp191:
.Ltmp192:
.org (.Ltmp192-(.Ltmp191-.Ltmp189))+(.Ltmp187-.Ltmp186), 0
.Ltmp193:
.org (.Ltmp193-(.Ltmp187-.Ltmp186))+(.Ltmp191-.Ltmp189), 0
	.text


	//NO_APP
.LBB41_10:
	ldr	x8, [x8, #8]
	//APP
	mrs	x10, TTBR1_EL1
	//NO_APP
	mov	x11, x8
	bfxil	x11, x10, #0, #48
	//APP
	msr	TTBR1_EL1, x11
	//NO_APP
	//APP
	isb
	//NO_APP
	//APP
	msr	TTBR0_EL1, x8
	//NO_APP
	//APP
	isb
	//NO_APP
	//APP
.Ltmp194:
	msr	DAIF, x9
.Ltmp195:
	.section	.altinstructions,"a",@progbits
.Ltmp196:
	.word	.Ltmp194-.Ltmp196
.Ltmp198:
	.word	.Ltmp197-.Ltmp198
	.hword	24
	.byte	.Ltmp195-.Ltmp194
	.byte	.Ltmp199-.Ltmp197
	.text

	.text	1
.Ltmp197:
.set .L__gpr_num_x0, 0
.set .L__gpr_num_w0, 0
.set .L__gpr_num_x1, 1
.set .L__gpr_num_w1, 1
.set .L__gpr_num_x2, 2
.set .L__gpr_num_w2, 2
.set .L__gpr_num_x3, 3
.set .L__gpr_num_w3, 3
.set .L__gpr_num_x4, 4
.set .L__gpr_num_w4, 4
.set .L__gpr_num_x5, 5
.set .L__gpr_num_w5, 5
.set .L__gpr_num_x6, 6
.set .L__gpr_num_w6, 6
.set .L__gpr_num_x7, 7
.set .L__gpr_num_w7, 7
.set .L__gpr_num_x8, 8
.set .L__gpr_num_w8, 8
.set .L__gpr_num_x9, 9
.set .L__gpr_num_w9, 9
.set .L__gpr_num_x10, 10
.set .L__gpr_num_w10, 10
.set .L__gpr_num_x11, 11
.set .L__gpr_num_w11, 11
.set .L__gpr_num_x12, 12
.set .L__gpr_num_w12, 12
.set .L__gpr_num_x13, 13
.set .L__gpr_num_w13, 13
.set .L__gpr_num_x14, 14
.set .L__gpr_num_w14, 14
.set .L__gpr_num_x15, 15
.set .L__gpr_num_w15, 15
.set .L__gpr_num_x16, 16
.set .L__gpr_num_w16, 16
.set .L__gpr_num_x17, 17
.set .L__gpr_num_w17, 17
.set .L__gpr_num_x18, 18
.set .L__gpr_num_w18, 18
.set .L__gpr_num_x19, 19
.set .L__gpr_num_w19, 19
.set .L__gpr_num_x20, 20
.set .L__gpr_num_w20, 20
.set .L__gpr_num_x21, 21
.set .L__gpr_num_w21, 21
.set .L__gpr_num_x22, 22
.set .L__gpr_num_w22, 22
.set .L__gpr_num_x23, 23
.set .L__gpr_num_w23, 23
.set .L__gpr_num_x24, 24
.set .L__gpr_num_w24, 24
.set .L__gpr_num_x25, 25
.set .L__gpr_num_w25, 25
.set .L__gpr_num_x26, 26
.set .L__gpr_num_w26, 26
.set .L__gpr_num_x27, 27
.set .L__gpr_num_w27, 27
.set .L__gpr_num_x28, 28
.set .L__gpr_num_w28, 28
.set .L__gpr_num_x29, 29
.set .L__gpr_num_w29, 29
.set .L__gpr_num_x30, 30
.set .L__gpr_num_w30, 30

.set .L__gpr_num_xzr, 31
.set .L__gpr_num_wzr, 31

	.inst	0xd5184609


.Ltmp199:
.Ltmp200:
.org (.Ltmp200-(.Ltmp199-.Ltmp197))+(.Ltmp195-.Ltmp194), 0
.Ltmp201:
.org (.Ltmp201-(.Ltmp195-.Ltmp194))+(.Ltmp199-.Ltmp197), 0
	.text


	//NO_APP
	//APP
.Ltmp203:
	nop
	.section	__jump_table,"aw",@progbits
	.p2align	3
.Ltmp204:
	.word	.Ltmp203-.Ltmp204
.Ltmp205:
	.word	.Ltmp202-.Ltmp205
.Ltmp206:
	.xword	gic_pmr_sync-.Ltmp206
	.text


	//NO_APP
.Ltmp156:
.LBB41_11:
	//APP
	and	x1, x1, #0xff7fffffffffffff

	//NO_APP
	mov	x0, x20
	mov	x2, x19
	bl	__arch_copy_from_user
	mov	x21, x0
	//APP
.Ltmp208:
	b	.Ltmp207
.Ltmp209:
	.section	.altinstructions,"a",@progbits
.Ltmp210:
	.word	.Ltmp208-.Ltmp210
.Ltmp211:
	.word	alt_cb_patch_nops-.Ltmp211
	.hword	32769
	.byte	.Ltmp209-.Ltmp208
	.byte	.Ltmp212-.Ltmp213
	.text

.Ltmp213:
.Ltmp212:

	//NO_APP
	//APP
.Ltmp215:
	nop
.Ltmp216:
	.section	.altinstructions,"a",@progbits
.Ltmp217:
	.word	.Ltmp215-.Ltmp217
.Ltmp219:
	.word	.Ltmp218-.Ltmp219
	.hword	29
	.byte	.Ltmp216-.Ltmp215
	.byte	.Ltmp220-.Ltmp218
	.text

	.text	1
.Ltmp218:
	b	.Ltmp214
.Ltmp220:
.Ltmp221:
.org (.Ltmp221-(.Ltmp220-.Ltmp218))+(.Ltmp216-.Ltmp215), 0
.Ltmp222:
.org (.Ltmp222-(.Ltmp216-.Ltmp215))+(.Ltmp220-.Ltmp218), 0
	.text


	//NO_APP
.LBB41_13:
	//APP
.Ltmp223:
	mrs	x8, DAIF
.Ltmp224:
	.section	.altinstructions,"a",@progbits
.Ltmp225:
	.word	.Ltmp223-.Ltmp225
.Ltmp227:
	.word	.Ltmp226-.Ltmp227
	.hword	24
	.byte	.Ltmp224-.Ltmp223
	.byte	.Ltmp228-.Ltmp226
	.text

	.text	1
.Ltmp226:
.set .L__gpr_num_x0, 0
.set .L__gpr_num_w0, 0
.set .L__gpr_num_x1, 1
.set .L__gpr_num_w1, 1
.set .L__gpr_num_x2, 2
.set .L__gpr_num_w2, 2
.set .L__gpr_num_x3, 3
.set .L__gpr_num_w3, 3
.set .L__gpr_num_x4, 4
.set .L__gpr_num_w4, 4
.set .L__gpr_num_x5, 5
.set .L__gpr_num_w5, 5
.set .L__gpr_num_x6, 6
.set .L__gpr_num_w6, 6
.set .L__gpr_num_x7, 7
.set .L__gpr_num_w7, 7
.set .L__gpr_num_x8, 8
.set .L__gpr_num_w8, 8
.set .L__gpr_num_x9, 9
.set .L__gpr_num_w9, 9
.set .L__gpr_num_x10, 10
.set .L__gpr_num_w10, 10
.set .L__gpr_num_x11, 11
.set .L__gpr_num_w11, 11
.set .L__gpr_num_x12, 12
.set .L__gpr_num_w12, 12
.set .L__gpr_num_x13, 13
.set .L__gpr_num_w13, 13
.set .L__gpr_num_x14, 14
.set .L__gpr_num_w14, 14
.set .L__gpr_num_x15, 15
.set .L__gpr_num_w15, 15
.set .L__gpr_num_x16, 16
.set .L__gpr_num_w16, 16
.set .L__gpr_num_x17, 17
.set .L__gpr_num_w17, 17
.set .L__gpr_num_x18, 18
.set .L__gpr_num_w18, 18
.set .L__gpr_num_x19, 19
.set .L__gpr_num_w19, 19
.set .L__gpr_num_x20, 20
.set .L__gpr_num_w20, 20
.set .L__gpr_num_x21, 21
.set .L__gpr_num_w21, 21
.set .L__gpr_num_x22, 22
.set .L__gpr_num_w22, 22
.set .L__gpr_num_x23, 23
.set .L__gpr_num_w23, 23
.set .L__gpr_num_x24, 24
.set .L__gpr_num_w24, 24
.set .L__gpr_num_x25, 25
.set .L__gpr_num_w25, 25
.set .L__gpr_num_x26, 26
.set .L__gpr_num_w26, 26
.set .L__gpr_num_x27, 27
.set .L__gpr_num_w27, 27
.set .L__gpr_num_x28, 28
.set .L__gpr_num_w28, 28
.set .L__gpr_num_x29, 29
.set .L__gpr_num_w29, 29
.set .L__gpr_num_x30, 30
.set .L__gpr_num_w30, 30

.set .L__gpr_num_xzr, 31
.set .L__gpr_num_wzr, 31

	.inst	0xd5384608


.Ltmp228:
.Ltmp229:
.org (.Ltmp229-(.Ltmp228-.Ltmp226))+(.Ltmp224-.Ltmp223), 0
.Ltmp230:
.org (.Ltmp230-(.Ltmp224-.Ltmp223))+(.Ltmp228-.Ltmp226), 0
	.text


	//NO_APP
	//APP
.Ltmp231:
	and	w9, w8, #0x80
.Ltmp232:
	.section	.altinstructions,"a",@progbits
.Ltmp233:
	.word	.Ltmp231-.Ltmp233
.Ltmp235:
	.word	.Ltmp234-.Ltmp235
	.hword	24
	.byte	.Ltmp232-.Ltmp231
	.byte	.Ltmp236-.Ltmp234
	.text

	.text	1
.Ltmp234:
	eor	w9, w8, #0xe0
.Ltmp236:
.Ltmp237:
.org (.Ltmp237-(.Ltmp236-.Ltmp234))+(.Ltmp232-.Ltmp231), 0
.Ltmp238:
.org (.Ltmp238-(.Ltmp232-.Ltmp231))+(.Ltmp236-.Ltmp234), 0
	.text


	//NO_APP
	cbnz	w9, .LBB41_17
	//APP
.Ltmp240:
	nop
	.section	__jump_table,"aw",@progbits
	.p2align	3
.Ltmp241:
	.word	.Ltmp240-.Ltmp241
.Ltmp242:
	.word	.Ltmp239-.Ltmp242
.Ltmp243:
	.xword	gic_nonsecure_priorities-.Ltmp243
	.text


	//NO_APP
	mov	w9, #96
.LBB41_16:
	//APP
.Ltmp244:
	msr	DAIFSet, #3	// arch_local_irq_disable
.Ltmp245:
	.section	.altinstructions,"a",@progbits
.Ltmp246:
	.word	.Ltmp244-.Ltmp246
.Ltmp248:
	.word	.Ltmp247-.Ltmp248
	.hword	24
	.byte	.Ltmp245-.Ltmp244
	.byte	.Ltmp249-.Ltmp247
	.text

	.text	1
.Ltmp247:
.set .L__gpr_num_x0, 0
.set .L__gpr_num_w0, 0
.set .L__gpr_num_x1, 1
.set .L__gpr_num_w1, 1
.set .L__gpr_num_x2, 2
.set .L__gpr_num_w2, 2
.set .L__gpr_num_x3, 3
.set .L__gpr_num_w3, 3
.set .L__gpr_num_x4, 4
.set .L__gpr_num_w4, 4
.set .L__gpr_num_x5, 5
.set .L__gpr_num_w5, 5
.set .L__gpr_num_x6, 6
.set .L__gpr_num_w6, 6
.set .L__gpr_num_x7, 7
.set .L__gpr_num_w7, 7
.set .L__gpr_num_x8, 8
.set .L__gpr_num_w8, 8
.set .L__gpr_num_x9, 9
.set .L__gpr_num_w9, 9
.set .L__gpr_num_x10, 10
.set .L__gpr_num_w10, 10
.set .L__gpr_num_x11, 11
.set .L__gpr_num_w11, 11
.set .L__gpr_num_x12, 12
.set .L__gpr_num_w12, 12
.set .L__gpr_num_x13, 13
.set .L__gpr_num_w13, 13
.set .L__gpr_num_x14, 14
.set .L__gpr_num_w14, 14
.set .L__gpr_num_x15, 15
.set .L__gpr_num_w15, 15
.set .L__gpr_num_x16, 16
.set .L__gpr_num_w16, 16
.set .L__gpr_num_x17, 17
.set .L__gpr_num_w17, 17
.set .L__gpr_num_x18, 18
.set .L__gpr_num_w18, 18
.set .L__gpr_num_x19, 19
.set .L__gpr_num_w19, 19
.set .L__gpr_num_x20, 20
.set .L__gpr_num_w20, 20
.set .L__gpr_num_x21, 21
.set .L__gpr_num_w21, 21
.set .L__gpr_num_x22, 22
.set .L__gpr_num_w22, 22
.set .L__gpr_num_x23, 23
.set .L__gpr_num_w23, 23
.set .L__gpr_num_x24, 24
.set .L__gpr_num_w24, 24
.set .L__gpr_num_x25, 25
.set .L__gpr_num_w25, 25
.set .L__gpr_num_x26, 26
.set .L__gpr_num_w26, 26
.set .L__gpr_num_x27, 27
.set .L__gpr_num_w27, 27
.set .L__gpr_num_x28, 28
.set .L__gpr_num_w28, 28
.set .L__gpr_num_x29, 29
.set .L__gpr_num_w29, 29
.set .L__gpr_num_x30, 30
.set .L__gpr_num_w30, 30

.set .L__gpr_num_xzr, 31
.set .L__gpr_num_wzr, 31

	.inst	0xd5184609


.Ltmp249:
.Ltmp250:
.org (.Ltmp250-(.Ltmp249-.Ltmp247))+(.Ltmp245-.Ltmp244), 0
.Ltmp251:
.org (.Ltmp251-(.Ltmp245-.Ltmp244))+(.Ltmp249-.Ltmp247), 0
	.text


	//NO_APP
.LBB41_17:
	//APP
	mrs	x9, TTBR1_EL1
	//NO_APP
	and	x9, x9, #0xffffffffffff
	sub	x10, x9, #1, lsl #12
	//APP
	msr	TTBR0_EL1, x10
	//NO_APP
	//APP
	isb
	//NO_APP
	//APP
	msr	TTBR1_EL1, x9
	//NO_APP
	//APP
	isb
	//NO_APP
	//APP
.Ltmp252:
	msr	DAIF, x8
.Ltmp253:
	.section	.altinstructions,"a",@progbits
.Ltmp254:
	.word	.Ltmp252-.Ltmp254
.Ltmp256:
	.word	.Ltmp255-.Ltmp256
	.hword	24
	.byte	.Ltmp253-.Ltmp252
	.byte	.Ltmp257-.Ltmp255
	.text

	.text	1
.Ltmp255:
.set .L__gpr_num_x0, 0
.set .L__gpr_num_w0, 0
.set .L__gpr_num_x1, 1
.set .L__gpr_num_w1, 1
.set .L__gpr_num_x2, 2
.set .L__gpr_num_w2, 2
.set .L__gpr_num_x3, 3
.set .L__gpr_num_w3, 3
.set .L__gpr_num_x4, 4
.set .L__gpr_num_w4, 4
.set .L__gpr_num_x5, 5
.set .L__gpr_num_w5, 5
.set .L__gpr_num_x6, 6
.set .L__gpr_num_w6, 6
.set .L__gpr_num_x7, 7
.set .L__gpr_num_w7, 7
.set .L__gpr_num_x8, 8
.set .L__gpr_num_w8, 8
.set .L__gpr_num_x9, 9
.set .L__gpr_num_w9, 9
.set .L__gpr_num_x10, 10
.set .L__gpr_num_w10, 10
.set .L__gpr_num_x11, 11
.set .L__gpr_num_w11, 11
.set .L__gpr_num_x12, 12
.set .L__gpr_num_w12, 12
.set .L__gpr_num_x13, 13
.set .L__gpr_num_w13, 13
.set .L__gpr_num_x14, 14
.set .L__gpr_num_w14, 14
.set .L__gpr_num_x15, 15
.set .L__gpr_num_w15, 15
.set .L__gpr_num_x16, 16
.set .L__gpr_num_w16, 16
.set .L__gpr_num_x17, 17
.set .L__gpr_num_w17, 17
.set .L__gpr_num_x18, 18
.set .L__gpr_num_w18, 18
.set .L__gpr_num_x19, 19
.set .L__gpr_num_w19, 19
.set .L__gpr_num_x20, 20
.set .L__gpr_num_w20, 20
.set .L__gpr_num_x21, 21
.set .L__gpr_num_w21, 21
.set .L__gpr_num_x22, 22
.set .L__gpr_num_w22, 22
.set .L__gpr_num_x23, 23
.set .L__gpr_num_w23, 23
.set .L__gpr_num_x24, 24
.set .L__gpr_num_w24, 24
.set .L__gpr_num_x25, 25
.set .L__gpr_num_w25, 25
.set .L__gpr_num_x26, 26
.set .L__gpr_num_w26, 26
.set .L__gpr_num_x27, 27
.set .L__gpr_num_w27, 27
.set .L__gpr_num_x28, 28
.set .L__gpr_num_w28, 28
.set .L__gpr_num_x29, 29
.set .L__gpr_num_w29, 29
.set .L__gpr_num_x30, 30
.set .L__gpr_num_w30, 30

.set .L__gpr_num_xzr, 31
.set .L__gpr_num_wzr, 31

	.inst	0xd5184608


.Ltmp257:
.Ltmp258:
.org (.Ltmp258-(.Ltmp257-.Ltmp255))+(.Ltmp253-.Ltmp252), 0
.Ltmp259:
.org (.Ltmp259-(.Ltmp253-.Ltmp252))+(.Ltmp257-.Ltmp255), 0
	.text


	//NO_APP
	//APP
.Ltmp261:
	nop
	.section	__jump_table,"aw",@progbits
	.p2align	3
.Ltmp262:
	.word	.Ltmp261-.Ltmp262
.Ltmp263:
	.word	.Ltmp260-.Ltmp263
.Ltmp264:
	.xword	gic_pmr_sync-.Ltmp264
	.text


	//NO_APP
.Ltmp214:
.LBB41_18:
	cbnz	x21, .LBB41_20
.LBB41_19:
	ldp	x20, x19, [sp, #32]
	mov	x0, x21
	ldr	x21, [sp, #16]
	ldp	x29, x30, [sp], #48
	ldr	x30, [x18, #-8]!
	ret
.LBB41_20:
	sub	x8, x19, x21
	mov	w1, wzr
	add	x0, x20, x8
	mov	x2, x21
	bl	memset
	b	.LBB41_19
.Ltmp149:
.LBB41_21:
	adrp	x9, cpu_hwcaps
	ldr	x9, [x9, :lo12:cpu_hwcaps]
	tbnz	w9, #29, .LBB41_11
	b	.LBB41_6
.Ltmp202:
.LBB41_22:
	//APP
	dsb	sy
	//NO_APP
	b	.LBB41_11
.Ltmp207:
.LBB41_23:
	adrp	x8, cpu_hwcaps
	ldr	x8, [x8, :lo12:cpu_hwcaps]
	tbnz	w8, #29, .LBB41_18
	b	.LBB41_13
.Ltmp260:
.LBB41_24:
	//APP
	dsb	sy
	//NO_APP
	b	.LBB41_18
.Ltmp181:
.LBB41_25:
	mov	w10, #160
	b	.LBB41_9
.Ltmp239:
.LBB41_26:
	mov	w9, #160
	b	.LBB41_16
.Lfunc_end41:
	.size	_copy_from_user, .Lfunc_end41-_copy_from_user

	.p2align	2
	.type	waveform_mmap,@function
waveform_mmap:
	str	x30, [x18], #8
	stp	x29, x30, [sp, #-48]!
	adrp	x8, global_ebc
	ldr	x9, [x1, #16]
	str	x21, [sp, #16]
	mov	x29, sp
	stp	x20, x19, [sp, #32]
	mov	x19, x1
	ldr	x8, [x8, :lo12:global_ebc]
	ldr	w21, [x9, #152]
	ldr	w9, [x1, #40]
	ldr	x20, [x8, #256]
	cmp	w9, w21
	b.eq	.LBB42_2
	ldr	x0, [x19, #48]
	bl	down_write
	str	w21, [x19, #40]
	ldr	x0, [x19, #48]
	bl	up_write
.LBB42_2:
	ldp	x4, x8, [x19, #24]
	mov	w10, #16384
	lsr	x2, x20, #12
	ldp	x1, x9, [x19]
	movk	w10, #1028, lsl #16
	mov	x0, x19
	orr	x8, x8, x10
	sub	x3, x9, x1
	str	x8, [x19, #32]
	bl	remap_pfn_range
	ldp	x20, x19, [sp, #32]
	mov	w8, #-11
	cmp	w0, #0
	ldr	x21, [sp, #16]
	csel	w0, wzr, w8, eq
	ldp	x29, x30, [sp], #48
	ldr	x30, [x18, #-8]!
	ret
.Lfunc_end42:
	.size	waveform_mmap, .Lfunc_end42-waveform_mmap

	.p2align	2
	.type	waveform_open,@function
waveform_open:
	mov	w0, wzr
	str	xzr, [x1, #104]
	ret
.Lfunc_end43:
	.size	waveform_open, .Lfunc_end43-waveform_open

	.p2align	2
	.type	waveform_version_read,@function
waveform_version_read:
	str	x30, [x18], #8
	stp	x29, x30, [sp, #-32]!
	str	x19, [sp, #16]
	mov	x29, sp
	mov	x19, x2
	bl	epd_lut_get_wf_version
	adrp	x1, .L.str.123
	mov	x2, x0
	add	x1, x1, :lo12:.L.str.123
	mov	x0, x19
	bl	sprintf
	ldr	x19, [sp, #16]
	sxtw	x0, w0
	ldp	x29, x30, [sp], #32
	ldr	x30, [x18, #-8]!
	ret
.Lfunc_end44:
	.size	waveform_version_read, .Lfunc_end44-waveform_version_read

	.p2align	2
	.type	pmic_name_read,@function
pmic_name_read:
	str	x30, [x18], #8
	stp	x29, x30, [sp, #-16]!
	adrp	x8, global_ebc
	adrp	x1, .L.str.123
	mov	x0, x2
	add	x1, x1, :lo12:.L.str.123
	mov	x29, sp
	ldr	x8, [x8, :lo12:global_ebc]
	ldr	x8, [x8, #16]
	add	x2, x8, #8
	bl	sprintf
	sxtw	x0, w0
	ldp	x29, x30, [sp], #16
	ldr	x30, [x18, #-8]!
	ret
.Lfunc_end45:
	.size	pmic_name_read, .Lfunc_end45-pmic_name_read

	.p2align	2
	.type	pmic_temp_read,@function
pmic_temp_read:
	sub	sp, sp, #48
	str	x30, [x18], #8
	stp	x29, x30, [sp, #16]
	adrp	x9, global_ebc
	str	x19, [sp, #32]
	mrs	x8, SP_EL0
	ldr	x8, [x8, #1584]
	mov	x19, x2
	add	x29, sp, #16
	str	x8, [sp, #8]
	ldr	x8, [x9, :lo12:global_ebc]
	str	wzr, [sp, #4]
	ldr	x0, [x8, #16]
	cbz	x0, .LBB46_2
	ldr	x8, [x0, #56]
	add	x1, sp, #4
	blr	x8
	b	.LBB46_3
.LBB46_2:
	ldr	x0, [x8, #32]
	add	x1, sp, #4
	bl	thermal_zone_get_temp
.LBB46_3:
	adrp	x1, .L.str.126
	ldr	w2, [sp, #4]
	add	x1, x1, :lo12:.L.str.126
	mov	x0, x19
	bl	sprintf
	mrs	x8, SP_EL0
	ldr	x8, [x8, #1584]
	ldr	x9, [sp, #8]
	cmp	x8, x9
	b.ne	.LBB46_5
	ldp	x29, x30, [sp, #16]
	sxtw	x0, w0
	ldr	x19, [sp, #32]
	ldr	x30, [x18, #-8]!
	add	sp, sp, #48
	ret
.LBB46_5:
	bl	__stack_chk_fail
.Lfunc_end46:
	.size	pmic_temp_read, .Lfunc_end46-pmic_temp_read

	.p2align	2
	.type	pmic_vcom_read,@function
pmic_vcom_read:
	str	x30, [x18], #8
	stp	x29, x30, [sp, #-32]!
	adrp	x8, global_ebc
	str	x19, [sp, #16]
	mov	x19, x2
	mov	x29, sp
	ldr	x8, [x8, :lo12:global_ebc]
	ldr	x0, [x8, #16]
	cbz	x0, .LBB47_2
	ldr	x8, [x0, #64]
	blr	x8
	mov	w2, w0
	b	.LBB47_3
.LBB47_2:
	ldr	x0, [x8, #24]
	bl	regulator_get_voltage
	mov	w8, #19923
	movk	w8, #4194, lsl #16
	smull	x8, w0, w8
	lsr	x9, x8, #63
	asr	x8, x8, #38
	add	w2, w8, w9
.LBB47_3:
	adrp	x1, .L.str.126
	mov	x0, x19
	add	x1, x1, :lo12:.L.str.126
	bl	sprintf
	ldr	x19, [sp, #16]
	sxtw	x0, w0
	ldp	x29, x30, [sp], #32
	ldr	x30, [x18, #-8]!
	ret
.Lfunc_end47:
	.size	pmic_vcom_read, .Lfunc_end47-pmic_vcom_read

	.p2align	2
	.type	pmic_vcom_write,@function
pmic_vcom_write:
	sub	sp, sp, #64
	str	x30, [x18], #8
	stp	x29, x30, [sp, #16]
	adrp	x9, global_ebc
	str	x21, [sp, #32]
	mov	w1, wzr
	stp	x20, x19, [sp, #48]
	mrs	x8, SP_EL0
	ldr	x8, [x8, #1584]
	mov	x20, x2
	add	x2, sp, #4
	mov	x0, x20
	add	x29, sp, #16
	mov	x19, x3
	str	x8, [sp, #8]
	ldr	x21, [x9, :lo12:global_ebc]
	str	wzr, [sp, #4]
	bl	kstrtouint
	cbnz	w0, .LBB48_5
	ldr	x0, [x21, #16]
	cbz	x0, .LBB48_3
	ldr	w1, [sp, #4]
	bl	ebc_pmic_set_vcom
	cbz	w0, .LBB48_7
	b	.LBB48_4
.LBB48_3:
	ldr	x0, [x21, #24]
	ldr	w1, [sp, #4]
	bl	ebc_regulator_set_vcom
	cbz	w0, .LBB48_7
.LBB48_4:
	adrp	x1, .L.str.129
	ldr	x0, [x21]
	add	x1, x1, :lo12:.L.str.129
	bl	_dev_err
	b	.LBB48_6
.LBB48_5:
	adrp	x1, .L.str.128
	ldr	x0, [x21]
	add	x1, x1, :lo12:.L.str.128
	mov	x2, x20
	bl	_dev_err
.LBB48_6:
	mov	x19, #-1
.LBB48_7:
	mrs	x8, SP_EL0
	ldr	x8, [x8, #1584]
	ldr	x9, [sp, #8]
	cmp	x8, x9
	b.ne	.LBB48_9
	mov	x0, x19
	ldr	x21, [sp, #32]
	ldp	x20, x19, [sp, #48]
	ldp	x29, x30, [sp, #16]
	ldr	x30, [x18, #-8]!
	add	sp, sp, #64
	ret
.LBB48_9:
	bl	__stack_chk_fail
.Lfunc_end48:
	.size	pmic_vcom_write, .Lfunc_end48-pmic_vcom_write

	.p2align	2
	.type	ebc_version_read,@function
ebc_version_read:
	str	x30, [x18], #8
	stp	x29, x30, [sp, #-16]!
	mov	x0, x2
	adrp	x1, .L.str.123
	adrp	x2, .L.str.21
	add	x1, x1, :lo12:.L.str.123
	add	x2, x2, :lo12:.L.str.21
	mov	x29, sp
	bl	sprintf
	sxtw	x0, w0
	ldp	x29, x30, [sp], #16
	ldr	x30, [x18, #-8]!
	ret
.Lfunc_end49:
	.size	ebc_version_read, .Lfunc_end49-ebc_version_read

	.p2align	2
	.type	ebc_state_read,@function
ebc_state_read:
	str	x30, [x18], #8
	stp	x29, x30, [sp, #-16]!
	adrp	x8, global_ebc
	adrp	x1, .L.str.126
	mov	x0, x2
	add	x1, x1, :lo12:.L.str.126
	mov	x29, sp
	ldr	x8, [x8, :lo12:global_ebc]
	ldr	w2, [x8, #656]
	bl	sprintf
	sxtw	x0, w0
	ldp	x29, x30, [sp], #16
	ldr	x30, [x18, #-8]!
	ret
.Lfunc_end50:
	.size	ebc_state_read, .Lfunc_end50-ebc_state_read

	.p2align	2
	.type	ebc_buf_state_read,@function
ebc_buf_state_read:
	str	x30, [x18], #8
	stp	x29, x30, [sp, #-16]!
	mov	x0, x2
	mov	x29, sp
	bl	ebc_buf_state_show
	sxtw	x0, w0
	ldp	x29, x30, [sp], #16
	ldr	x30, [x18, #-8]!
	ret
.Lfunc_end51:
	.size	ebc_buf_state_read, .Lfunc_end51-ebc_buf_state_read

	.p2align	2
	.type	auto_frame_state_read,@function
auto_frame_state_read:
	str	x30, [x18], #8
	stp	x29, x30, [sp, #-16]!
	adrp	x8, global_ebc
	mov	x29, sp
	ldr	x8, [x8, :lo12:global_ebc]
	ldp	w10, w9, [x8, #116]
	mul	w9, w10, w9
	cbz	w9, .LBB52_4
	ldr	x11, [x8, #376]
	mov	w10, wzr
.LBB52_2:
	ldrb	w8, [x11, w10, sxtw]
	cbnz	w8, .LBB52_5
	add	w10, w10, #1
	cmp	w9, w10
	b.ne	.LBB52_2
.LBB52_4:
	mov	w8, #2608
	mov	w0, #2
	strb	wzr, [x2, #2]
	strh	w8, [x2]
	b	.LBB52_6
.LBB52_5:
	adrp	x1, .L.str.126
	mov	x0, x2
	add	x1, x1, :lo12:.L.str.126
	mov	w2, w8
	bl	sprintf
	sxtw	x0, w0
.LBB52_6:
	ldp	x29, x30, [sp], #16
	ldr	x30, [x18, #-8]!
	ret
.Lfunc_end52:
	.size	auto_frame_state_read, .Lfunc_end52-auto_frame_state_read

	.p2align	2
	.type	ebc_debug_level_read,@function
ebc_debug_level_read:
	str	x30, [x18], #8
	stp	x29, x30, [sp, #-16]!
	adrp	x8, global_ebc
	adrp	x1, .L.str.126
	mov	x0, x2
	add	x1, x1, :lo12:.L.str.126
	mov	x29, sp
	ldr	x8, [x8, :lo12:global_ebc]
	ldr	w2, [x8, #792]
	bl	sprintf
	sxtw	x0, w0
	ldp	x29, x30, [sp], #16
	ldr	x30, [x18, #-8]!
	ret
.Lfunc_end53:
	.size	ebc_debug_level_read, .Lfunc_end53-ebc_debug_level_read

	.p2align	2
	.type	ebc_debug_level_write,@function
ebc_debug_level_write:
	sub	sp, sp, #64
	str	x30, [x18], #8
	stp	x29, x30, [sp, #16]
	adrp	x9, global_ebc
	str	x21, [sp, #32]
	mov	w1, wzr
	stp	x20, x19, [sp, #48]
	mrs	x8, SP_EL0
	ldr	x8, [x8, #1584]
	mov	x20, x2
	add	x2, sp, #4
	mov	x0, x20
	add	x29, sp, #16
	mov	x19, x3
	str	x8, [sp, #8]
	ldr	x21, [x9, :lo12:global_ebc]
	str	wzr, [sp, #4]
	bl	kstrtouint
	cbnz	w0, .LBB54_4
	ldr	w8, [sp, #4]
	str	w8, [x21, #792]
.LBB54_2:
	mrs	x8, SP_EL0
	ldr	x8, [x8, #1584]
	ldr	x9, [sp, #8]
	cmp	x8, x9
	b.ne	.LBB54_5
	mov	x0, x19
	ldr	x21, [sp, #32]
	ldp	x20, x19, [sp, #48]
	ldp	x29, x30, [sp, #16]
	ldr	x30, [x18, #-8]!
	add	sp, sp, #64
	ret
.LBB54_4:
	adrp	x1, .L.str.128
	ldr	x0, [x21, #312]
	add	x1, x1, :lo12:.L.str.128
	mov	x2, x20
	bl	_dev_err
	mov	x19, #-1
	b	.LBB54_2
.LBB54_5:
	bl	__stack_chk_fail
.Lfunc_end54:
	.size	ebc_debug_level_write, .Lfunc_end54-ebc_debug_level_write

	.p2align	2
	.type	wf_data_write,@function
wf_data_write:
	str	x30, [x18], #8
	stp	x29, x30, [sp, #-96]!
	adrp	x8, global_ebc
	adrp	x1, .L.str.137
	mov	x0, x2
	add	x1, x1, :lo12:.L.str.137
	stp	x26, x25, [sp, #32]
	mov	x29, sp
	ldr	x8, [x8, :lo12:global_ebc]
	stp	x20, x19, [sp, #80]
	stp	x28, x27, [sp, #16]
	mov	x19, x3
	stp	x24, x23, [sp, #48]
	ldr	x25, [x8, #336]
	stp	x22, x21, [sp, #64]
	ldrb	w20, [x8, #320]
	bl	strstr
	cbnz	x0, .LBB55_2
.LBB55_1:
	mov	x0, x19
	ldp	x20, x19, [sp, #80]
	ldp	x22, x21, [sp, #64]
	ldp	x24, x23, [sp, #48]
	ldp	x26, x25, [sp, #32]
	ldp	x28, x27, [sp, #16]
	ldp	x29, x30, [sp], #96
	ldr	x30, [x18, #-8]!
	ret
.LBB55_2:
	adrp	x0, .L.str.138
	mov	w1, w20
	add	x0, x0, :lo12:.L.str.138
	bl	_printk
	adrp	x22, .L.str.139
	adrp	x23, .L.str.140
	mov	x21, xzr
	add	x22, x22, :lo12:.L.str.139
	add	x23, x23, :lo12:.L.str.140
.LBB55_3:
	mov	x24, xzr
	mov	x26, x25
.LBB55_4:
	mov	x0, x22
	mov	w1, w24
	mov	w2, w21
	bl	_printk
	cbz	w20, .LBB55_7
	mov	x27, x20
	mov	x28, x26
.LBB55_6:
	ldrb	w1, [x28]
	mov	x0, x23
	bl	_printk
	add	x28, x28, #1024
	subs	x27, x27, #1
	b.ne	.LBB55_6
.LBB55_7:
	add	x24, x24, #1
	add	x26, x26, #32
	cmp	x24, #32
	b.ne	.LBB55_4
	add	x21, x21, #1
	add	x25, x25, #1
	cmp	x21, #32
	b.ne	.LBB55_3
	b	.LBB55_1
.Lfunc_end55:
	.size	wf_data_write, .Lfunc_end55-wf_data_write

	.p2align	2
	.type	ebc_suspend,@function
ebc_suspend:
	str	x30, [x18], #8
	stp	x29, x30, [sp, #-32]!
	str	x19, [sp, #16]
	ldr	x19, [x0, #120]
	mov	w1, wzr
	mov	x29, sp
	mov	x0, x19
	bl	ebc_power_set
	mov	w8, #1
	ldr	x0, [x19, #16]
	str	w8, [x19, #748]
	cbz	x0, .LBB56_2
	ldr	x8, [x0, #40]
	blr	x8
.LBB56_2:
	adrp	x1, .L.str.141
	ldr	x0, [x19, #312]
	add	x1, x1, :lo12:.L.str.141
	bl	_dev_info
	ldr	x19, [sp, #16]
	mov	w0, wzr
	ldp	x29, x30, [sp], #32
	ldr	x30, [x18, #-8]!
	ret
.Lfunc_end56:
	.size	ebc_suspend, .Lfunc_end56-ebc_suspend

	.p2align	2
	.type	ebc_resume,@function
ebc_resume:
	str	x30, [x18], #8
	stp	x29, x30, [sp, #-32]!
	str	x19, [sp, #16]
	ldr	x19, [x0, #120]
	mov	x29, sp
	ldr	x0, [x19, #16]
	cbz	x0, .LBB57_2
	ldr	x8, [x0, #48]
	blr	x8
.LBB57_2:
	adrp	x1, .L.str.142
	ldr	x0, [x19, #312]
	add	x1, x1, :lo12:.L.str.142
	str	wzr, [x19, #748]
	bl	_dev_info
	ldr	x19, [sp, #16]
	mov	w0, wzr
	ldp	x29, x30, [sp], #32
	ldr	x30, [x18, #-8]!
	ret
.Lfunc_end57:
	.size	ebc_resume, .Lfunc_end57-ebc_resume

	.type	ebc_driver,@object
	.data
	.p2align	3
ebc_driver:
	.xword	ebc_probe
	.xword	ebc_remove
	.xword	0
	.xword	0
	.xword	0
	.xword	0
	.xword	.L.str
	.xword	0
	.xword	0
	.xword	0
	.byte	0
	.zero	3
	.word	0
	.xword	ebc_match
	.xword	0
	.xword	0
	.xword	0
	.xword	0
	.xword	0
	.xword	0
	.xword	0
	.xword	0
	.xword	0
	.xword	ebc_pm
	.xword	0
	.xword	0
	.xword	0
	.byte	0
	.byte	0
	.zero	6
	.size	ebc_driver, 208

	.type	__UNIQUE_ID___addressable_ebc_init466,@object
	.section	.discard.addressable,"aw",@progbits
	.p2align	3
__UNIQUE_ID___addressable_ebc_init466:
	.xword	ebc_init
	.size	__UNIQUE_ID___addressable_ebc_init466, 8

	.type	__exitcall_ebc_exit,@object
	.section	.exitcall.exit,"aw",@progbits
	.p2align	3
__exitcall_ebc_exit:
	.xword	ebc_exit
	.size	__exitcall_ebc_exit, 8

	.type	__UNIQUE_ID_author467,@object
	.section	.modinfo,"a",@progbits
__UNIQUE_ID_author467:
	.asciz	"rkebc.author=Zorro Liu <zorro.liu@rock-chips.com>"
	.size	__UNIQUE_ID_author467, 50

	.type	__UNIQUE_ID_description468,@object
__UNIQUE_ID_description468:
	.asciz	"rkebc.description=ROCKCHIP EBC Driver"
	.size	__UNIQUE_ID_description468, 38

	.type	__UNIQUE_ID_file469,@object
__UNIQUE_ID_file469:
	.asciz	"rkebc.file=$EBC_DEV_PATH/rkebc"
	.size	__UNIQUE_ID_file469, 31

	.type	__UNIQUE_ID_license470,@object
__UNIQUE_ID_license470:
	.asciz	"rkebc.license=GPL v2"
	.size	__UNIQUE_ID_license470, 21

	.type	.L.str,@object
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"ebc-dev"
	.size	.L.str, 8

	.type	ebc_match,@object
	.section	.rodata,"a",@progbits
	.p2align	3
ebc_match:
	.zero	32
	.zero	32
	.asciz	"rockchip,ebc-dev\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000"
	.xword	0
	.zero	200
	.size	ebc_match, 400

	.type	ebc_pm,@object
	.p2align	3
ebc_pm:
	.xword	0
	.xword	0
	.xword	ebc_suspend
	.xword	ebc_resume
	.xword	0
	.xword	0
	.xword	0
	.xword	0
	.xword	0
	.xword	0
	.xword	0
	.xword	0
	.xword	0
	.xword	0
	.xword	0
	.xword	0
	.xword	0
	.xword	0
	.xword	0
	.xword	0
	.xword	0
	.xword	0
	.xword	0
	.size	ebc_pm, 184

	.type	.L.str.1,@object
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str.1:
	.asciz	"cpu-code"
	.size	.L.str.1, 9

	.type	global_ebc,@object
	.local	global_ebc
	.comm	global_ebc,8,8
	.type	.L.str.2,@object
.L.str.2:
	.asciz	"ebc_tcon"
	.size	.L.str.2, 9

	.type	.L.str.3,@object
.L.str.3:
	.asciz	"not find ebc tcon\n"
	.size	.L.str.3, 19

	.type	.L.str.4,@object
.L.str.4:
	.asciz	"pmic"
	.size	.L.str.4, 5

	.type	.L.str.5,@object
.L.str.5:
	.asciz	"wrong pmics number\n"
	.size	.L.str.5, 20

	.type	.L.str.6,@object
.L.str.6:
	.asciz	"not find pmic node\n"
	.size	.L.str.6, 20

	.type	.L.str.7,@object
.L.str.7:
	.asciz	"not find pmic i2c client\n"
	.size	.L.str.7, 26

	.type	.L.str.8,@object
.L.str.8:
	.asciz	"use pmic%d\n"
	.size	.L.str.8, 12

	.type	.L.str.9,@object
.L.str.9:
	.asciz	"vcom"
	.size	.L.str.9, 5

	.type	.L.str.10,@object
.L.str.10:
	.asciz	"Failed to get vcom regulator\n"
	.size	.L.str.10, 30

	.type	.L.str.11,@object
.L.str.11:
	.asciz	"thermal-zone"
	.size	.L.str.11, 13

	.type	.L.str.12,@object
.L.str.12:
	.asciz	"Failed to get thermal zone name\n"
	.size	.L.str.12, 33

	.type	.L.str.13,@object
.L.str.13:
	.asciz	"Failed to get thermal device\n"
	.size	.L.str.13, 30

	.type	.L.str.14,@object
.L.str.14:
	.asciz	"Get PMIC deivce failed\n"
	.size	.L.str.14, 24

	.type	.L.str.15,@object
.L.str.15:
	.asciz	"ebc-dmc-notify-enable"
	.size	.L.str.15, 22

	.type	.L.str.16,@object
.L.str.16:
	.asciz	"failed to probe panel: %d\n"
	.size	.L.str.16, 27

	.type	.L.str.17,@object
.L.str.17:
	.asciz	"buffer manage init failed\n"
	.size	.L.str.17, 27

	.type	.L.str.18,@object
.L.str.18:
	.asciz	"lut table init failed\n"
	.size	.L.str.18, 23

	.type	.L.str.19,@object
.L.str.19:
	.asciz	"task init failed\n"
	.size	.L.str.19, 18

	.type	.L.str.20,@object
.L.str.20:
	.asciz	"rockchip ebc driver %s probe success\n"
	.size	.L.str.20, 38

	.type	.L.str.21,@object
.L.str.21:
	.asciz	"7.02_y8"
	.size	.L.str.21, 8

	.type	ebc_auto_task,@object
	.local	ebc_auto_task
	.comm	ebc_auto_task,8,8
	.type	.L.str.22,@object
.L.str.22:
	.asciz	"overlay frame done\n"
	.size	.L.str.22, 20

	.type	ebc_thread_wq,@object
	.data
	.p2align	3
ebc_thread_wq:
	.zero	4
	.zero	4
	.xword	ebc_thread_wq+8
	.xword	ebc_thread_wq+8
	.size	ebc_thread_wq, 24

	.type	.L.str.23,@object
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str.23:
	.asciz	"auto task break\n"
	.size	.L.str.23, 17

	.type	.L.str.24,@object
.L.str.24:
	.asciz	"auto frame done\n"
	.size	.L.str.24, 17

	.type	.L.str.25,@object
.L.str.25:
	.asciz	"part task break\n"
	.size	.L.str.25, 17

	.type	.L.str.26,@object
.L.str.26:
	.asciz	"frame done\n"
	.size	.L.str.26, 12

	.type	.L.str.27,@object
.L.str.27:
	.asciz	"panel,width"
	.size	.L.str.27, 12

	.type	.L.str.28,@object
.L.str.28:
	.asciz	"panel,height"
	.size	.L.str.28, 13

	.type	.L.str.29,@object
.L.str.29:
	.asciz	"panel,vir_width"
	.size	.L.str.29, 16

	.type	.L.str.30,@object
.L.str.30:
	.asciz	"panel,vir_height"
	.size	.L.str.30, 17

	.type	.L.str.31,@object
.L.str.31:
	.asciz	"panel,sdck"
	.size	.L.str.31, 11

	.type	.L.str.32,@object
.L.str.32:
	.asciz	"panel,lsl"
	.size	.L.str.32, 10

	.type	.L.str.33,@object
.L.str.33:
	.asciz	"panel,lbl"
	.size	.L.str.33, 10

	.type	.L.str.34,@object
.L.str.34:
	.asciz	"panel,ldl"
	.size	.L.str.34, 10

	.type	.L.str.35,@object
.L.str.35:
	.asciz	"panel,lel"
	.size	.L.str.35, 10

	.type	.L.str.36,@object
.L.str.36:
	.asciz	"panel,gdck-sta"
	.size	.L.str.36, 15

	.type	.L.str.37,@object
.L.str.37:
	.asciz	"panel,lgonl"
	.size	.L.str.37, 12

	.type	.L.str.38,@object
.L.str.38:
	.asciz	"panel,fsl"
	.size	.L.str.38, 10

	.type	.L.str.39,@object
.L.str.39:
	.asciz	"panel,fbl"
	.size	.L.str.39, 10

	.type	.L.str.40,@object
.L.str.40:
	.asciz	"panel,fdl"
	.size	.L.str.40, 10

	.type	.L.str.41,@object
.L.str.41:
	.asciz	"panel,fel"
	.size	.L.str.41, 10

	.type	.L.str.42,@object
.L.str.42:
	.asciz	"panel,panel_16bit"
	.size	.L.str.42, 18

	.type	.L.str.43,@object
.L.str.43:
	.asciz	"panel,panel_color"
	.size	.L.str.43, 18

	.type	.L.str.44,@object
.L.str.44:
	.asciz	"panel,mirror"
	.size	.L.str.44, 13

	.type	.L.str.45,@object
.L.str.45:
	.asciz	"panel,width-mm"
	.size	.L.str.45, 15

	.type	.L.str.46,@object
.L.str.46:
	.asciz	"panel,height-mm"
	.size	.L.str.46, 16

	.type	.L.str.47,@object
.L.str.47:
	.asciz	"panel,disable_logo"
	.size	.L.str.47, 19

	.type	.L.str.48,@object
.L.str.48:
	.asciz	"panel,rearrange"
	.size	.L.str.48, 16

	.type	.L.str.49,@object
.L.str.49:
	.asciz	"panel,sdoe_mode"
	.size	.L.str.49, 16

	.type	.L.str.50,@object
.L.str.50:
	.asciz	"panel,sdce_width"
	.size	.L.str.50, 17

	.type	.L.str.51,@object
.L.str.51:
	.asciz	"too large resolution, not support\n"
	.size	.L.str.51, 35

	.type	.L.str.52,@object
.L.str.52:
	.asciz	"memory-region"
	.size	.L.str.52, 14

	.type	.L.str.53,@object
.L.str.53:
	.asciz	"Couldn't address to resource for reserved memory\n"
	.size	.L.str.53, 50

	.type	.L.str.54,@object
.L.str.54:
	.asciz	"reserved memory not enough, need 0x%x\n"
	.size	.L.str.54, 39

	.type	.L.str.55,@object
.L.str.55:
	.asciz	"Couldn't remap for reserved memory\n"
	.size	.L.str.55, 36

	.type	.L.str.56,@object
.L.str.56:
	.asciz	"waveform-region"
	.size	.L.str.56, 16

	.type	.L.str.57,@object
.L.str.57:
	.asciz	"%s:%d: failed to get mem from reserved\n"
	.size	.L.str.57, 40

	.type	.L__func__.ebc_lut_table_init,@object
.L__func__.ebc_lut_table_init:
	.asciz	"ebc_lut_table_init"
	.size	.L__func__.ebc_lut_table_init, 19

	.type	.L.str.58,@object
.L.str.58:
	.asciz	"Failed to read waveform from mem, we use waveform file from kernel file instead\n"
	.size	.L.str.58, 81

	.type	.L.str.59,@object
.L.str.59:
	.asciz	"Failed to read waveform file from kernel, no waveform!!!\n"
	.size	.L.str.59, 58

	.type	.L.str.60,@object
.L.str.60:
	.asciz	"ebc_task"
	.size	.L.str.60, 9

	.type	.L.str.61,@object
.L.str.61:
	.asciz	"failed to create ebc_task thread\n"
	.size	.L.str.61, 34

	.type	.L.str.62,@object
.L.str.62:
	.asciz	"ebc_taskup"
	.size	.L.str.62, 11

	.type	ebc_auto_assist_task,@object
	.local	ebc_auto_assist_task
	.comm	ebc_auto_assist_task,8,8
	.type	.L.str.63,@object
.L.str.63:
	.asciz	"failed to create ebc_taskup thread\n"
	.size	.L.str.63, 36

	.type	.L.str.64,@object
.L.str.64:
	.asciz	"ebc_thread"
	.size	.L.str.64, 11

	.type	ebc_task,@object
	.local	ebc_task
	.comm	ebc_task,8,8
	.type	.L.str.65,@object
.L.str.65:
	.asciz	"failed to run ebc thread\n"
	.size	.L.str.65, 26

	.type	ebc_auto_thread_sem,@object
	.data
	.p2align	3
ebc_auto_thread_sem:
	.zero	4
	.word	1
	.xword	ebc_auto_thread_sem+8
	.xword	ebc_auto_thread_sem+8
	.size	ebc_auto_thread_sem, 24

	.type	ebc_assist_finished_flag_sem,@object
	.p2align	3
ebc_assist_finished_flag_sem:
	.zero	4
	.word	1
	.xword	ebc_assist_finished_flag_sem+8
	.xword	ebc_assist_finished_flag_sem+8
	.size	ebc_assist_finished_flag_sem, 24

	.type	ebc_auto_assist_thread_sem,@object
	.p2align	3
ebc_auto_assist_thread_sem:
	.zero	4
	.word	1
	.xword	ebc_auto_assist_thread_sem+8
	.xword	ebc_auto_assist_thread_sem+8
	.size	ebc_auto_assist_thread_sem, 24

	.type	.L.str.66,@object
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str.66:
	.asciz	"ebc suspend, drop osd buf\n"
	.size	.L.str.66, 27

	.type	.L.str.67,@object
.L.str.67:
	.asciz	"break from part work, frame left = %d\n"
	.size	.L.str.67, 39

	.type	.L.str.68,@object
.L.str.68:
	.asciz	"overlay mode start, frame_total=%d, bw_frame = %d\n"
	.size	.L.str.68, 51

	.type	.L.str.69,@object
.L.str.69:
	.asciz	"ebc is busy now, waiting prev mode end...\n"
	.size	.L.str.69, 43

	.type	.L.str.70,@object
.L.str.70:
	.asciz	"prev refresh mode end\n"
	.size	.L.str.70, 23

	.type	.L.str.71,@object
.L.str.71:
	.asciz	"frame start under overlay, mode = %d, framecount = %d\n"
	.size	.L.str.71, 55

	.type	.L.str.72,@object
.L.str.72:
	.asciz	"control bg update under overlay mode, overlay_bg_update=0\n"
	.size	.L.str.72, 59

	.type	.L.str.73,@object
.L.str.73:
	.asciz	"auto mode start, frame_total=%d\n"
	.size	.L.str.73, 33

	.type	.L.str.74,@object
.L.str.74:
	.asciz	"check_part_mode==0, no need refresh\n"
	.size	.L.str.74, 37

	.type	.L.str.75,@object
.L.str.75:
	.asciz	"check_diff_percent==2, full refresh\n"
	.size	.L.str.75, 37

	.type	.L.str.76,@object
.L.str.76:
	.asciz	"frame start, mode = %d, framecount = %d\n"
	.size	.L.str.76, 41

	.type	.L.str.77,@object
.L.str.77:
	.asciz	"update repair buf\n"
	.size	.L.str.77, 19

	.type	.L.str.78,@object
.L.str.78:
	.asciz	"waiting frame done\n"
	.size	.L.str.78, 20

	.type	.L.str.79,@object
.L.str.79:
	.asciz	"----update repair buf timeout----\n"
	.size	.L.str.79, 35

	.type	.L.str.80,@object
.L.str.80:
	.asciz	"break from part work, do something before turn to overlay work\n"
	.size	.L.str.80, 64

	.type	.L.str.81,@object
.L.str.81:
	.asciz	"quick mode repair buf\n"
	.size	.L.str.81, 23

	.type	.L.str.82,@object
.L.str.82:
	.asciz	"no buffer, do repair..........\n"
	.size	.L.str.82, 32

	.type	.L.str.83,@object
.L.str.83:
	.asciz	"no buffer, do ghost remove..........\n"
	.size	.L.str.83, 38

	.type	.L.str.84,@object
.L.str.84:
	.asciz	"ebc buffer mode %d error!!!\n"
	.size	.L.str.84, 29

	.type	.L.str.85,@object
.L.str.85:
	.asciz	"ebc hw power on res:%d\n"
	.size	.L.str.85, 24

	.type	.L.str.86,@object
.L.str.86:
	.asciz	"ebc hw power off res:%d\n"
	.size	.L.str.86, 25

	.type	.L.str.87,@object
.L.str.87:
	.asciz	"temperature = %d, out of range0~50 ,use 25 \n"
	.size	.L.str.87, 45

	.type	.L.str.88,@object
.L.str.88:
	.asciz	"temperature = %d, out of range0~50 ,use 50 \n"
	.size	.L.str.88, 45

	.type	.L.str.89,@object
.L.str.89:
	.asciz	"ebc_pmic_read_temp failed, ret = %d, use 25 \n"
	.size	.L.str.89, 46

	.type	.L.str.90,@object
.L.str.90:
	.asciz	"lut update use temperature = %d\n"
	.size	.L.str.90, 33

	.type	.L.str.91,@object
.L.str.91:
	.asciz	"get lut data failed\n"
	.size	.L.str.91, 21

	.type	.L.str.92,@object
.L.str.92:
	.asciz	"%s: overlay no need to update\n"
	.size	.L.str.92, 31

	.type	.L__func__.ebc_frame_start,@object
.L__func__.ebc_frame_start:
	.asciz	"ebc_frame_start"
	.size	.L__func__.ebc_frame_start, 16

	.type	.L.str.93,@object
.L.str.93:
	.asciz	"%s: auto no need to update\n"
	.size	.L.str.93, 28

	.type	.L.str.94,@object
.L.str.94:
	.asciz	"%s: overlay bg no need to update, overlay_bg_update=1\n"
	.size	.L.str.94, 55

	.type	.L__func__.ebc_overlay_bg_frame_start,@object
.L__func__.ebc_overlay_bg_frame_start:
	.asciz	"ebc_overlay_bg_frame_start"
	.size	.L__func__.ebc_overlay_bg_frame_start, 27

	.type	.L.str.95,@object
.L.str.95:
	.asciz	"ebc"
	.size	.L.str.95, 4

	.type	.L.str.96,@object
.L.str.96:
	.asciz	"ebc_frame_control_timeout, overlay_bg_update=1\n"
	.size	.L.str.96, 48

	.type	.L.str.97,@object
.L.str.97:
	.asciz	"ulogo_addr="
	.size	.L.str.97, 12

	.type	.L.str.98,@object
.L.str.98:
	.asciz	"klogo_addr="
	.size	.L.str.98, 12

	.type	.L.str.99,@object
.L.str.99:
	.asciz	"ulogo_addr=0x%x"
	.size	.L.str.99, 16

	.type	.L.str.100,@object
.L.str.100:
	.asciz	"have ulogo display, ulogo addr = 0x%x\n"
	.size	.L.str.100, 39

	.type	.L.str.101,@object
.L.str.101:
	.asciz	"malloc ulogo buffer failed\n"
	.size	.L.str.101, 28

	.type	.L.str.102,@object
.L.str.102:
	.asciz	"klogo_addr=0x%x"
	.size	.L.str.102, 16

	.type	.L.str.103,@object
.L.str.103:
	.asciz	"need show klogo, klogo addr = 0x%x\n"
	.size	.L.str.103, 36

	.type	.L.str.104,@object
.L.str.104:
	.asciz	"malloc klogo buffer failed\n"
	.size	.L.str.104, 28

	.type	.L.str.105,@object
.L.str.105:
	.asciz	"no uboot logo, panel init\n"
	.size	.L.str.105, 27

	.type	.L.str.106,@object
.L.str.106:
	.asciz	"ebc_dev_logo"
	.size	.L.str.106, 13

	.type	.L.str.107,@object
.L.str.107:
	.asciz	"ebc_dev_reset"
	.size	.L.str.107, 14

	.type	ebc_misc,@object
	.data
	.p2align	3
ebc_misc:
	.word	243
	.zero	4
	.xword	.L.str.95
	.xword	ebc_ops
	.zero	16
	.xword	0
	.xword	0
	.xword	0
	.xword	0
	.hword	0
	.zero	6
	.size	ebc_misc, 80

	.type	waveform_misc,@object
	.p2align	3
waveform_misc:
	.word	244
	.zero	4
	.xword	.L.str.120
	.xword	waveform_ops
	.zero	16
	.xword	0
	.xword	0
	.xword	0
	.xword	0
	.hword	0
	.zero	6
	.size	waveform_misc, 80

	.type	dev_attr_waveform_version,@object
	.p2align	3
dev_attr_waveform_version:
	.xword	.L.str.122
	.hword	292
	.zero	6
	.xword	waveform_version_read
	.xword	0
	.size	dev_attr_waveform_version, 32

	.type	dev_attr_pmic_name,@object
	.p2align	3
dev_attr_pmic_name:
	.xword	.L.str.124
	.hword	292
	.zero	6
	.xword	pmic_name_read
	.xword	0
	.size	dev_attr_pmic_name, 32

	.type	dev_attr_pmic_temp,@object
	.p2align	3
dev_attr_pmic_temp:
	.xword	.L.str.125
	.hword	292
	.zero	6
	.xword	pmic_temp_read
	.xword	0
	.size	dev_attr_pmic_temp, 32

	.type	dev_attr_pmic_vcom,@object
	.p2align	3
dev_attr_pmic_vcom:
	.xword	.L.str.127
	.hword	420
	.zero	6
	.xword	pmic_vcom_read
	.xword	pmic_vcom_write
	.size	dev_attr_pmic_vcom, 32

	.type	dev_attr_ebc_version,@object
	.p2align	3
dev_attr_ebc_version:
	.xword	.L.str.130
	.hword	292
	.zero	6
	.xword	ebc_version_read
	.xword	0
	.size	dev_attr_ebc_version, 32

	.type	dev_attr_ebc_state,@object
	.p2align	3
dev_attr_ebc_state:
	.xword	.L.str.131
	.hword	292
	.zero	6
	.xword	ebc_state_read
	.xword	0
	.size	dev_attr_ebc_state, 32

	.type	dev_attr_ebc_buf_state,@object
	.p2align	3
dev_attr_ebc_buf_state:
	.xword	.L.str.132
	.hword	292
	.zero	6
	.xword	ebc_buf_state_read
	.xword	0
	.size	dev_attr_ebc_buf_state, 32

	.type	dev_attr_auto_frame_state,@object
	.p2align	3
dev_attr_auto_frame_state:
	.xword	.L.str.133
	.hword	292
	.zero	6
	.xword	auto_frame_state_read
	.xword	0
	.size	dev_attr_auto_frame_state, 32

	.type	dev_attr_ebc_debug_level,@object
	.p2align	3
dev_attr_ebc_debug_level:
	.xword	.L.str.135
	.hword	420
	.zero	6
	.xword	ebc_debug_level_read
	.xword	ebc_debug_level_write
	.size	dev_attr_ebc_debug_level, 32

	.type	dev_attr_wf_data,@object
	.p2align	3
dev_attr_wf_data:
	.xword	.L.str.136
	.hword	128
	.zero	6
	.xword	0
	.xword	wf_data_write
	.size	dev_attr_wf_data, 32

	.type	ebc_ops,@object
	.section	.rodata,"a",@progbits
	.p2align	3
ebc_ops:
	.xword	0
	.xword	0
	.xword	0
	.xword	0
	.xword	0
	.xword	0
	.xword	0
	.xword	0
	.xword	0
	.xword	0
	.xword	ebc_io_ctl
	.xword	ebc_io_ctl
	.xword	ebc_mmap
	.xword	0
	.xword	ebc_open
	.xword	0
	.xword	ebc_release
	.xword	0
	.xword	0
	.xword	0
	.xword	0
	.xword	0
	.xword	0
	.xword	0
	.xword	0
	.xword	0
	.xword	0
	.xword	0
	.xword	0
	.xword	0
	.xword	0
	.xword	0
	.xword	0
	.xword	0
	.size	ebc_ops, 272

	.type	.L.str.109,@object
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str.109:
	.asciz	"%s: argp NULL\n"
	.size	.L.str.109, 15

	.type	.L__func__.ebc_io_ctl,@object
.L__func__.ebc_io_ctl:
	.asciz	"ebc_io_ctl"
	.size	.L__func__.ebc_io_ctl, 11

	.type	.L.str.110,@object
.L.str.110:
	.asciz	"enable bg control\n"
	.size	.L.str.110, 19

	.type	.L.str.111,@object
.L.str.111:
	.asciz	"disable bg control\n"
	.size	.L.str.111, 20

	.type	.L.str.112,@object
.L.str.112:
	.asciz	"enable ebc overlay, you can use osd buf to show something over the system display\n"
	.size	.L.str.112, 83

	.type	.L.str.113,@object
.L.str.113:
	.asciz	"disable ebc overlay\n"
	.size	.L.str.113, 21

	.type	.L.str.114,@object
.L.str.114:
	.asciz	"EBC_GET_BUFFER_INFO failed\n"
	.size	.L.str.114, 28

	.type	.L.str.115,@object
.L.str.115:
	.asciz	"EBC_FB_BLANK\n"
	.size	.L.str.115, 14

	.type	.L.str.116,@object
.L.str.116:
	.asciz	"EBC_FB_UNBLANK\n"
	.size	.L.str.116, 16

	.type	.L.str.117,@object
.L.str.117:
	.asciz	"EBC_ENABLE_REPAIR = %d\n"
	.size	.L.str.117, 24

	.type	.L.str.118,@object
.L.str.118:
	.asciz	"EBC_SET_FULL_REFRESH_WIDTH = %d\n"
	.size	.L.str.118, 33

	.type	.L.str.119,@object
.L.str.119:
	.asciz	"%s: unknown cmd\n"
	.size	.L.str.119, 17

	.type	.L.str.120,@object
.L.str.120:
	.asciz	"waveform"
	.size	.L.str.120, 9

	.type	waveform_ops,@object
	.section	.rodata,"a",@progbits
	.p2align	3
waveform_ops:
	.xword	0
	.xword	0
	.xword	0
	.xword	0
	.xword	0
	.xword	0
	.xword	0
	.xword	0
	.xword	0
	.xword	0
	.xword	0
	.xword	0
	.xword	waveform_mmap
	.xword	0
	.xword	waveform_open
	.xword	0
	.xword	0
	.xword	0
	.xword	0
	.xword	0
	.xword	0
	.xword	0
	.xword	0
	.xword	0
	.xword	0
	.xword	0
	.xword	0
	.xword	0
	.xword	0
	.xword	0
	.xword	0
	.xword	0
	.xword	0
	.xword	0
	.size	waveform_ops, 272

	.type	.L.str.122,@object
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str.122:
	.asciz	"waveform_version"
	.size	.L.str.122, 17

	.type	.L.str.123,@object
.L.str.123:
	.asciz	"%s\n"
	.size	.L.str.123, 4

	.type	.L.str.124,@object
.L.str.124:
	.asciz	"pmic_name"
	.size	.L.str.124, 10

	.type	.L.str.125,@object
.L.str.125:
	.asciz	"pmic_temp"
	.size	.L.str.125, 10

	.type	.L.str.126,@object
.L.str.126:
	.asciz	"%d\n"
	.size	.L.str.126, 4

	.type	.L.str.127,@object
.L.str.127:
	.asciz	"pmic_vcom"
	.size	.L.str.127, 10

	.type	.L.str.128,@object
.L.str.128:
	.asciz	"invalid value = %s\n"
	.size	.L.str.128, 20

	.type	.L.str.129,@object
.L.str.129:
	.asciz	"set vcom value failed\n"
	.size	.L.str.129, 23

	.type	.L.str.130,@object
.L.str.130:
	.asciz	"ebc_version"
	.size	.L.str.130, 12

	.type	.L.str.131,@object
.L.str.131:
	.asciz	"ebc_state"
	.size	.L.str.131, 10

	.type	.L.str.132,@object
.L.str.132:
	.asciz	"ebc_buf_state"
	.size	.L.str.132, 14

	.type	.L.str.133,@object
.L.str.133:
	.asciz	"auto_frame_state"
	.size	.L.str.133, 17

	.type	.L.str.134,@object
.L.str.134:
	.asciz	"0\n"
	.size	.L.str.134, 3

	.type	.L.str.135,@object
.L.str.135:
	.asciz	"ebc_debug_level"
	.size	.L.str.135, 16

	.type	.L.str.136,@object
.L.str.136:
	.asciz	"wf_data"
	.size	.L.str.136, 8

	.type	.L.str.137,@object
.L.str.137:
	.asciz	"603893"
	.size	.L.str.137, 7

	.type	.L.str.138,@object
.L.str.138:
	.asciz	"lutdata: %d frames\n"
	.size	.L.str.138, 20

	.type	.L.str.139,@object
.L.str.139:
	.asciz	"[%d-->%d]: \n"
	.size	.L.str.139, 13

	.type	.L.str.140,@object
.L.str.140:
	.asciz	"\001c\0017%d, "
	.size	.L.str.140, 9

	.type	.L.str.141,@object
.L.str.141:
	.asciz	"device suspend\n"
	.size	.L.str.141, 16

	.type	.L.str.142,@object
.L.str.142:
	.asciz	"device resume\n"
	.size	.L.str.142, 15

	.ident	"Android (8508608, based on r450784e) clang version 14.0.7 (https://android.googlesource.com/toolchain/llvm-project 4c603efb0cca074e9238af8b4106c30add4418f6)"
	.section	".note.GNU-stack","",@progbits
	.addrsig
	.addrsig_sym ebc_exit
	.addrsig_sym ebc_init
	.addrsig_sym ebc_probe
	.addrsig_sym ebc_remove
	.addrsig_sym frame_done_callback
	.addrsig_sym ebc_auto_tast_function
	.addrsig_sym ebc_auto_assist_tast_function
	.addrsig_sym ebc_thread
	.addrsig_sym ebc_frame_control_timeout
	.addrsig_sym ebc_frame_timeout
	.addrsig_sym ebc_io_ctl
	.addrsig_sym ebc_mmap
	.addrsig_sym ebc_open
	.addrsig_sym ebc_release
	.addrsig_sym waveform_mmap
	.addrsig_sym waveform_open
	.addrsig_sym waveform_version_read
	.addrsig_sym pmic_name_read
	.addrsig_sym pmic_temp_read
	.addrsig_sym pmic_vcom_read
	.addrsig_sym pmic_vcom_write
	.addrsig_sym ebc_version_read
	.addrsig_sym ebc_state_read
	.addrsig_sym ebc_buf_state_read
	.addrsig_sym auto_frame_state_read
	.addrsig_sym ebc_debug_level_read
	.addrsig_sym ebc_debug_level_write
	.addrsig_sym wf_data_write
	.addrsig_sym ebc_suspend
	.addrsig_sym ebc_resume
	.addrsig_sym ebc_driver
	.addrsig_sym __UNIQUE_ID___addressable_ebc_init466
	.addrsig_sym __exitcall_ebc_exit
	.addrsig_sym __UNIQUE_ID_author467
	.addrsig_sym __UNIQUE_ID_description468
	.addrsig_sym __UNIQUE_ID_file469
	.addrsig_sym __UNIQUE_ID_license470
	.addrsig_sym ebc_match
	.addrsig_sym ebc_pm
	.addrsig_sym __cpu_possible_mask
	.addrsig_sym jiffies
	.addrsig_sym ebc_thread_wq
	.addrsig_sym ebc_auto_thread_sem
	.addrsig_sym ebc_assist_finished_flag_sem
	.addrsig_sym cpu_bit_bitmap
	.addrsig_sym ebc_auto_assist_thread_sem
	.addrsig_sym ebc_misc
	.addrsig_sym waveform_misc
	.addrsig_sym dev_attr_waveform_version
	.addrsig_sym dev_attr_pmic_name
	.addrsig_sym dev_attr_pmic_temp
	.addrsig_sym dev_attr_pmic_vcom
	.addrsig_sym dev_attr_ebc_version
	.addrsig_sym dev_attr_ebc_state
	.addrsig_sym dev_attr_ebc_buf_state
	.addrsig_sym dev_attr_auto_frame_state
	.addrsig_sym dev_attr_ebc_debug_level
	.addrsig_sym dev_attr_wf_data
	.addrsig_sym ebc_ops
	.addrsig_sym cpu_hwcaps
	.addrsig_sym gic_nonsecure_priorities
	.addrsig_sym gic_pmr_sync
	.addrsig_sym waveform_ops

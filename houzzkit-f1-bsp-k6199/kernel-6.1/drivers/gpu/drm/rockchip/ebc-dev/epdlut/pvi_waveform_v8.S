// SPDX-License-Identifier: GPL-2.0
/*
 * Copyright (c) 2020-2024 Rockchip Electronics Co., Ltd.
 *
 * Author: Zorro Liu <zorro.liu@rock-chips.com>
 */

	.text
	.file	"pvi_waveform.c"
	.globl	pvi_wf_get_lut
	.p2align	2
	.type	pvi_wf_get_lut,@function
pvi_wf_get_lut:
	str	x30, [x18], #8
	stp	x29, x30, [sp, #-96]!
	stp	x26, x25, [sp, #32]
	adrp	x25, global_waveform
	stp	x28, x27, [sp, #16]
	mov	x29, sp
	stp	x24, x23, [sp, #48]
	ldr	x8, [x25, :lo12:global_waveform]
	stp	x22, x21, [sp, #64]
	stp	x20, x19, [sp, #80]
	cbz	x8, .LBB0_12
	mov	w21, w4
	mov	w19, w2
	mov	w22, w1
	mov	x20, x0
	cbnz	x0, .LBB0_3
	mov	w9, #16
	ldr	x9, [x9]
	cbz	x9, .LBB0_13
.LBB0_3:
	adrp	x24, pvi_wf_get_lut.sftemp
	mov	w9, #21846
	movk	w9, #21845, lsl #16
	adrp	x27, pvi_wf_get_lut.stype
	adrp	x28, pvi_wf_get_lut.fix
	ldrsw	x10, [x24, :lo12:pvi_wf_get_lut.sftemp]
	smull	x11, w19, w9
	mul	x9, x10, x9
	lsr	x10, x11, #63
	lsr	x11, x11, #32
	lsr	x12, x9, #63
	lsr	x9, x9, #32
	add	w26, w11, w10
	add	w10, w9, w12
	cmp	w26, w10
	b.ne	.LBB0_6
	ldr	w9, [x27, :lo12:pvi_wf_get_lut.stype]
	cmp	w9, w22
	b.ne	.LBB0_6
	ldr	w9, [x28, :lo12:pvi_wf_get_lut.fix]
	cmp	w9, w21
	b.eq	.LBB0_67
.LBB0_6:
	adrp	x11, need_pic
	subs	w9, w22, #10
	str	w3, [x11, :lo12:need_pic]
	b.eq	.LBB0_66
	ldr	x11, [x20, #16]
	adrp	x12, waveformdata
	ldrb	w10, [x8, #38]
	str	x11, [x12, :lo12:waveformdata]
	cbz	w10, .LBB0_14
	mov	x11, xzr
	add	x12, x8, #48
.LBB0_9:
	ldrb	w13, [x12, x11]
	cmp	w13, w19
	b.ge	.LBB0_15
	add	x11, x11, #1
	cmp	x10, x11
	b.ne	.LBB0_9
	mov	w12, #-1
	mov	w11, w10
	b	.LBB0_16
.LBB0_12:
	mov	w0, #-19
	b	.LBB0_93
.LBB0_13:
	mov	w0, #-22
	b	.LBB0_93
.LBB0_14:
	mov	w11, wzr
	mov	w12, #-1
	b	.LBB0_16
.LBB0_15:
	mov	w12, w11
.LBB0_16:
	sub	w13, w11, #1
	cmp	w11, w10
	csel	w23, w13, w12, eq
	cmp	w22, #15
	b.hs	.LBB0_50
	cmp	w9, #5
	b.hs	.LBB0_19
	adrp	x10, .Lswitch.table.pvi_wf_get_lut.7
	add	x10, x10, :lo12:.Lswitch.table.pvi_wf_get_lut.7
	ldr	x9, [x10, w9, sxtw #3]
	b	.LBB0_20
.LBB0_19:
	mov	w9, w22
.LBB0_20:
	ldrb	w10, [x8, #16]
	sub	w8, w10, #9
	cmp	w8, #75
	b.hi	.LBB0_23
	adrp	x10, .LJTI0_0
	add	x10, x10, :lo12:.LJTI0_0
	adr	x11, .LBB0_22
	ldrb	w12, [x10, x8]
	add	x11, x11, x12, lsl #2
	adrp	x8, pvi_mode_table
	add	x8, x8, :lo12:pvi_mode_table
	br	x11
.LBB0_22:
	adrp	x8, pvi_mode_table+30
	add	x8, x8, :lo12:pvi_mode_table+30
	b	.LBB0_31
.LBB0_23:
	cmp	w10, #114
	b.ne	.LBB0_25
	adrp	x8, pvi_mode_table+70
	add	x8, x8, :lo12:pvi_mode_table+70
	b	.LBB0_31
.LBB0_25:
	adrp	x8, pvi_mode_table+80
	add	x8, x8, :lo12:pvi_mode_table+80
	b	.LBB0_31
.LBB0_26:
	adrp	x8, pvi_mode_table+10
	add	x8, x8, :lo12:pvi_mode_table+10
	b	.LBB0_31
.LBB0_27:
	adrp	x8, pvi_mode_table+20
	add	x8, x8, :lo12:pvi_mode_table+20
	b	.LBB0_31
.LBB0_28:
	adrp	x8, pvi_mode_table+40
	add	x8, x8, :lo12:pvi_mode_table+40
	b	.LBB0_31
.LBB0_29:
	adrp	x8, pvi_mode_table+50
	add	x8, x8, :lo12:pvi_mode_table+50
	b	.LBB0_31
.LBB0_30:
	adrp	x8, pvi_mode_table+60
	add	x8, x8, :lo12:pvi_mode_table+60
.LBB0_31:
	ldrb	w0, [x8, x9]
.LBB0_32:
	mov	w1, w23
	bl	get_wf_frm_num
	tbnz	w0, #31, .LBB0_94
	mov	w23, w0
	cmp	w22, #1
	b.eq	.LBB0_39
	cmp	w22, #7
	b.ne	.LBB0_40
	ldr	x8, [x20, #16]
	cbz	w23, .LBB0_38
	mov	w10, w23
	mov	x9, xzr
	lsl	x10, x10, #10
.LBB0_37:
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
	b.ne	.LBB0_37
.LBB0_38:
	lsl	w9, w23, #10
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
	b	.LBB0_65
.LBB0_39:
	ldr	x8, [x20, #16]
	mov	w9, #1
	mov	w10, #2
	strb	w9, [x8]
	strb	w9, [x8, #1024]
	strb	w9, [x8, #2048]
	strb	w9, [x8, #958]
	strb	w10, [x8, #1982]
	strb	w10, [x8, #3006]
	b	.LBB0_65
.LBB0_40:
	sub	w8, w22, #5
	cmp	w8, #1
	b.hi	.LBB0_44
	cbz	w23, .LBB0_65
	ldr	x8, [x20, #16]
	mov	w9, w23
	cmp	w23, #1
	b.ne	.LBB0_51
	mov	x10, xzr
	b	.LBB0_63
.LBB0_44:
	sub	w8, w22, #11
	cmp	w8, #1
	b.hi	.LBB0_48
	cbz	w23, .LBB0_65
	ldr	x8, [x20, #16]
	mov	w9, w23
	cmp	w23, #1
	b.ne	.LBB0_96
	mov	x10, xzr
	b	.LBB0_116
.LBB0_48:
	sub	w8, w22, #13
	cmp	w8, #1
	b.hi	.LBB0_65
	ldr	x0, [x20, #16]
	mov	w1, w23
	mov	w2, w21
	bl	pvi_wf_normal_fix
	b	.LBB0_65
.LBB0_50:
	adrp	x0, .L.str.3
	add	x0, x0, :lo12:.L.str.3
	bl	_printk
	mov	w0, #255
	b	.LBB0_32
.LBB0_51:
	sub	x12, x9, #1
	mov	x10, xzr
	and	x11, x12, #0xffffffff
	lsl	x14, x11, #10
	tst	x14, #0xffffffff00000000
	cset	w13, ne
	cmp	xzr, x12, lsr #54
	cset	w11, ne
	tbnz	w14, #31, .LBB0_63
	tbnz	w13, #0, .LBB0_63
	lsr	x13, x12, #32
	cbnz	x13, .LBB0_63
	add	x13, x8, #30
	lsl	x12, x12, #10
	add	x14, x13, x12
	cmp	x14, x13
	b.lo	.LBB0_63
	tbnz	w11, #0, .LBB0_63
	add	x13, x8, #29
	add	x14, x13, x12
	cmp	x14, x13
	b.lo	.LBB0_63
	tbnz	w11, #0, .LBB0_63
	add	x13, x8, #31
	add	x12, x13, x12
	cmp	x12, x13
	b.lo	.LBB0_63
	tbnz	w11, #0, .LBB0_63
	and	x10, x9, #0xfffffffe
	mov	w11, #1024
	mov	x12, x10
.LBB0_61:
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
	b.ne	.LBB0_61
	cmp	x10, x9
	b.eq	.LBB0_65
.LBB0_63:
	sub	x9, x9, x10
	lsl	w10, w10, #10
.LBB0_64:
	add	x11, x8, w10, sxtw
	subs	x9, x9, #1
	add	w10, w10, #1024
	ldrb	w12, [x11, #30]
	strb	w12, [x11, #31]
	strb	w12, [x11, #29]
	b.ne	.LBB0_64
.LBB0_65:
	ldrb	w8, [x20, #1]
	mov	w9, #21846
	movk	w9, #21845, lsl #16
	orr	w8, w23, w8, lsl #8
	str	w8, [x20]
	ldrsw	x8, [x24, :lo12:pvi_wf_get_lut.sftemp]
	str	w22, [x27, :lo12:pvi_wf_get_lut.stype]
	str	w21, [x28, :lo12:pvi_wf_get_lut.fix]
	mul	x8, x8, x9
	lsr	x9, x8, #63
	lsr	x8, x8, #32
	add	w10, w8, w9
.LBB0_66:
	cmp	w26, w10
	b.ne	.LBB0_68
.LBB0_67:
	mov	w0, wzr
	b	.LBB0_93
.LBB0_68:
	ldr	x8, [x20, #24]
	adrp	x9, waveformdata
	str	x8, [x9, :lo12:waveformdata]
	bl	epd_overlay_lut
	ldr	x8, [x25, :lo12:global_waveform]
	ldrb	w9, [x8, #38]
	cbz	w9, .LBB0_73
	mov	x10, xzr
	add	x11, x8, #48
.LBB0_70:
	ldrb	w12, [x11, x10]
	cmp	w12, w19
	b.ge	.LBB0_74
	add	x10, x10, #1
	cmp	x9, x10
	b.ne	.LBB0_70
	mov	w11, #-1
	mov	w10, w9
	b	.LBB0_75
.LBB0_73:
	mov	w10, wzr
	mov	w11, #-1
	b	.LBB0_75
.LBB0_74:
	mov	w11, w10
.LBB0_75:
	sub	w12, w10, #1
	cmp	w10, w9
	csel	w21, w12, w11, eq
	cmp	w0, #15
	b.hs	.LBB0_95
	sub	w9, w0, #10
	cmp	w9, #5
	b.hs	.LBB0_78
	adrp	x10, .Lswitch.table.pvi_wf_get_lut.7
	add	x10, x10, :lo12:.Lswitch.table.pvi_wf_get_lut.7
	ldr	x9, [x10, w9, sxtw #3]
	b	.LBB0_79
.LBB0_78:
	mov	w9, w0
.LBB0_79:
	ldrb	w10, [x8, #16]
	sub	w8, w10, #9
	cmp	w8, #75
	b.hi	.LBB0_82
	adrp	x10, .LJTI0_1
	add	x10, x10, :lo12:.LJTI0_1
	adr	x11, .LBB0_81
	ldrb	w12, [x10, x8]
	add	x11, x11, x12, lsl #2
	adrp	x8, pvi_mode_table
	add	x8, x8, :lo12:pvi_mode_table
	br	x11
.LBB0_81:
	adrp	x8, pvi_mode_table+30
	add	x8, x8, :lo12:pvi_mode_table+30
	b	.LBB0_90
.LBB0_82:
	cmp	w10, #114
	b.ne	.LBB0_84
	adrp	x8, pvi_mode_table+70
	add	x8, x8, :lo12:pvi_mode_table+70
	b	.LBB0_90
.LBB0_84:
	adrp	x8, pvi_mode_table+80
	add	x8, x8, :lo12:pvi_mode_table+80
	b	.LBB0_90
.LBB0_85:
	adrp	x8, pvi_mode_table+10
	add	x8, x8, :lo12:pvi_mode_table+10
	b	.LBB0_90
.LBB0_86:
	adrp	x8, pvi_mode_table+20
	add	x8, x8, :lo12:pvi_mode_table+20
	b	.LBB0_90
.LBB0_87:
	adrp	x8, pvi_mode_table+40
	add	x8, x8, :lo12:pvi_mode_table+40
	b	.LBB0_90
.LBB0_88:
	adrp	x8, pvi_mode_table+50
	add	x8, x8, :lo12:pvi_mode_table+50
	b	.LBB0_90
.LBB0_89:
	adrp	x8, pvi_mode_table+60
	add	x8, x8, :lo12:pvi_mode_table+60
.LBB0_90:
	ldrb	w0, [x8, x9]
.LBB0_91:
	mov	w1, w21
	bl	get_wf_frm_num
	tbnz	w0, #31, .LBB0_94
	ldrb	w8, [x20]
	bfi	w8, w0, #8, #24
	mov	w0, wzr
	str	w8, [x20]
	str	w19, [x24, :lo12:pvi_wf_get_lut.sftemp]
.LBB0_93:
	ldp	x20, x19, [sp, #80]
	ldp	x22, x21, [sp, #64]
	ldp	x24, x23, [sp, #48]
	ldp	x26, x25, [sp, #32]
	ldp	x28, x27, [sp, #16]
	ldp	x29, x30, [sp], #96
	ldr	x30, [x18, #-8]!
	ret
.LBB0_94:
	adrp	x0, .L.str
	add	x0, x0, :lo12:.L.str
	bl	_printk
	mov	w0, #-5
	b	.LBB0_93
.LBB0_95:
	adrp	x0, .L.str.3
	add	x0, x0, :lo12:.L.str.3
	bl	_printk
	mov	w0, #255
	b	.LBB0_91
.LBB0_96:
	sub	x12, x9, #1
	mov	x10, xzr
	and	x11, x12, #0xffffffff
	lsl	x14, x11, #10
	tst	x14, #0xffffffff00000000
	cset	w13, ne
	cmp	xzr, x12, lsr #54
	cset	w11, ne
	tbnz	w14, #31, .LBB0_116
	tbnz	w13, #0, .LBB0_116
	lsr	x13, x12, #32
	cbnz	x13, .LBB0_116
	add	x13, x8, #30
	lsl	x12, x12, #10
	add	x14, x13, x12
	cmp	x14, x13
	b.lo	.LBB0_116
	tbnz	w11, #0, .LBB0_116
	add	x13, x8, #1022
	add	x14, x13, x12
	cmp	x14, x13
	b.lo	.LBB0_116
	tbnz	w11, #0, .LBB0_116
	add	x13, x8, #1021
	add	x14, x13, x12
	cmp	x14, x13
	b.lo	.LBB0_116
	tbnz	w11, #0, .LBB0_116
	add	x13, x8, #29
	add	x14, x13, x12
	cmp	x14, x13
	b.lo	.LBB0_116
	tbnz	w11, #0, .LBB0_116
	add	x13, x8, #31
	add	x14, x13, x12
	cmp	x14, x13
	b.lo	.LBB0_116
	tbnz	w11, #0, .LBB0_116
	add	x13, x8, #989
	add	x12, x13, x12
	cmp	x12, x13
	b.lo	.LBB0_116
	tbnz	w11, #0, .LBB0_116
	and	x10, x9, #0xfffffffe
	mov	w11, #1024
	mov	x12, x10
	b	.LBB0_113
.LBB0_112:
	subs	x12, x12, #2
	add	w11, w11, #2048
	b.eq	.LBB0_115
.LBB0_113:
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
	cbz	w21, .LBB0_112
	add	x14, x14, #1021
	add	x13, x13, #1021
	strh	wzr, [x14]
	strh	wzr, [x13]
	b	.LBB0_112
.LBB0_115:
	cmp	x10, x9
	b.eq	.LBB0_65
.LBB0_116:
	sub	x9, x9, x10
	lsl	w10, w10, #10
	b	.LBB0_118
.LBB0_117:
	subs	x9, x9, #1
	add	w10, w10, #1024
	b.eq	.LBB0_65
.LBB0_118:
	add	x11, x8, w10, sxtw
	ldrb	w12, [x11, #30]
	strb	wzr, [x11, #989]
	strb	w12, [x11, #31]
	strb	w12, [x11, #29]
	cbz	w21, .LBB0_117
	add	x11, x11, #1021
	strh	wzr, [x11]
	b	.LBB0_117
.Lfunc_end0:
	.size	pvi_wf_get_lut, .Lfunc_end0-pvi_wf_get_lut
	.section	.rodata,"a",@progbits
.LJTI0_0:
	.byte	(.LBB0_31-.LBB0_22)>>2
	.byte	(.LBB0_25-.LBB0_22)>>2
	.byte	(.LBB0_25-.LBB0_22)>>2
	.byte	(.LBB0_25-.LBB0_22)>>2
	.byte	(.LBB0_25-.LBB0_22)>>2
	.byte	(.LBB0_25-.LBB0_22)>>2
	.byte	(.LBB0_25-.LBB0_22)>>2
	.byte	(.LBB0_25-.LBB0_22)>>2
	.byte	(.LBB0_25-.LBB0_22)>>2
	.byte	(.LBB0_26-.LBB0_22)>>2
	.byte	(.LBB0_25-.LBB0_22)>>2
	.byte	(.LBB0_25-.LBB0_22)>>2
	.byte	(.LBB0_25-.LBB0_22)>>2
	.byte	(.LBB0_27-.LBB0_22)>>2
	.byte	(.LBB0_25-.LBB0_22)>>2
	.byte	(.LBB0_25-.LBB0_22)>>2
	.byte	(.LBB0_22-.LBB0_22)>>2
	.byte	(.LBB0_25-.LBB0_22)>>2
	.byte	(.LBB0_25-.LBB0_22)>>2
	.byte	(.LBB0_25-.LBB0_22)>>2
	.byte	(.LBB0_25-.LBB0_22)>>2
	.byte	(.LBB0_25-.LBB0_22)>>2
	.byte	(.LBB0_25-.LBB0_22)>>2
	.byte	(.LBB0_25-.LBB0_22)>>2
	.byte	(.LBB0_25-.LBB0_22)>>2
	.byte	(.LBB0_25-.LBB0_22)>>2
	.byte	(.LBB0_28-.LBB0_22)>>2
	.byte	(.LBB0_25-.LBB0_22)>>2
	.byte	(.LBB0_25-.LBB0_22)>>2
	.byte	(.LBB0_25-.LBB0_22)>>2
	.byte	(.LBB0_25-.LBB0_22)>>2
	.byte	(.LBB0_25-.LBB0_22)>>2
	.byte	(.LBB0_25-.LBB0_22)>>2
	.byte	(.LBB0_25-.LBB0_22)>>2
	.byte	(.LBB0_25-.LBB0_22)>>2
	.byte	(.LBB0_25-.LBB0_22)>>2
	.byte	(.LBB0_25-.LBB0_22)>>2
	.byte	(.LBB0_25-.LBB0_22)>>2
	.byte	(.LBB0_25-.LBB0_22)>>2
	.byte	(.LBB0_25-.LBB0_22)>>2
	.byte	(.LBB0_25-.LBB0_22)>>2
	.byte	(.LBB0_25-.LBB0_22)>>2
	.byte	(.LBB0_25-.LBB0_22)>>2
	.byte	(.LBB0_25-.LBB0_22)>>2
	.byte	(.LBB0_25-.LBB0_22)>>2
	.byte	(.LBB0_25-.LBB0_22)>>2
	.byte	(.LBB0_25-.LBB0_22)>>2
	.byte	(.LBB0_25-.LBB0_22)>>2
	.byte	(.LBB0_25-.LBB0_22)>>2
	.byte	(.LBB0_25-.LBB0_22)>>2
	.byte	(.LBB0_25-.LBB0_22)>>2
	.byte	(.LBB0_25-.LBB0_22)>>2
	.byte	(.LBB0_25-.LBB0_22)>>2
	.byte	(.LBB0_25-.LBB0_22)>>2
	.byte	(.LBB0_25-.LBB0_22)>>2
	.byte	(.LBB0_25-.LBB0_22)>>2
	.byte	(.LBB0_25-.LBB0_22)>>2
	.byte	(.LBB0_25-.LBB0_22)>>2
	.byte	(.LBB0_22-.LBB0_22)>>2
	.byte	(.LBB0_25-.LBB0_22)>>2
	.byte	(.LBB0_25-.LBB0_22)>>2
	.byte	(.LBB0_25-.LBB0_22)>>2
	.byte	(.LBB0_25-.LBB0_22)>>2
	.byte	(.LBB0_29-.LBB0_22)>>2
	.byte	(.LBB0_25-.LBB0_22)>>2
	.byte	(.LBB0_25-.LBB0_22)>>2
	.byte	(.LBB0_25-.LBB0_22)>>2
	.byte	(.LBB0_25-.LBB0_22)>>2
	.byte	(.LBB0_25-.LBB0_22)>>2
	.byte	(.LBB0_25-.LBB0_22)>>2
	.byte	(.LBB0_25-.LBB0_22)>>2
	.byte	(.LBB0_25-.LBB0_22)>>2
	.byte	(.LBB0_25-.LBB0_22)>>2
	.byte	(.LBB0_25-.LBB0_22)>>2
	.byte	(.LBB0_25-.LBB0_22)>>2
	.byte	(.LBB0_30-.LBB0_22)>>2
.LJTI0_1:
	.byte	(.LBB0_90-.LBB0_81)>>2
	.byte	(.LBB0_84-.LBB0_81)>>2
	.byte	(.LBB0_84-.LBB0_81)>>2
	.byte	(.LBB0_84-.LBB0_81)>>2
	.byte	(.LBB0_84-.LBB0_81)>>2
	.byte	(.LBB0_84-.LBB0_81)>>2
	.byte	(.LBB0_84-.LBB0_81)>>2
	.byte	(.LBB0_84-.LBB0_81)>>2
	.byte	(.LBB0_84-.LBB0_81)>>2
	.byte	(.LBB0_85-.LBB0_81)>>2
	.byte	(.LBB0_84-.LBB0_81)>>2
	.byte	(.LBB0_84-.LBB0_81)>>2
	.byte	(.LBB0_84-.LBB0_81)>>2
	.byte	(.LBB0_86-.LBB0_81)>>2
	.byte	(.LBB0_84-.LBB0_81)>>2
	.byte	(.LBB0_84-.LBB0_81)>>2
	.byte	(.LBB0_81-.LBB0_81)>>2
	.byte	(.LBB0_84-.LBB0_81)>>2
	.byte	(.LBB0_84-.LBB0_81)>>2
	.byte	(.LBB0_84-.LBB0_81)>>2
	.byte	(.LBB0_84-.LBB0_81)>>2
	.byte	(.LBB0_84-.LBB0_81)>>2
	.byte	(.LBB0_84-.LBB0_81)>>2
	.byte	(.LBB0_84-.LBB0_81)>>2
	.byte	(.LBB0_84-.LBB0_81)>>2
	.byte	(.LBB0_84-.LBB0_81)>>2
	.byte	(.LBB0_87-.LBB0_81)>>2
	.byte	(.LBB0_84-.LBB0_81)>>2
	.byte	(.LBB0_84-.LBB0_81)>>2
	.byte	(.LBB0_84-.LBB0_81)>>2
	.byte	(.LBB0_84-.LBB0_81)>>2
	.byte	(.LBB0_84-.LBB0_81)>>2
	.byte	(.LBB0_84-.LBB0_81)>>2
	.byte	(.LBB0_84-.LBB0_81)>>2
	.byte	(.LBB0_84-.LBB0_81)>>2
	.byte	(.LBB0_84-.LBB0_81)>>2
	.byte	(.LBB0_84-.LBB0_81)>>2
	.byte	(.LBB0_84-.LBB0_81)>>2
	.byte	(.LBB0_84-.LBB0_81)>>2
	.byte	(.LBB0_84-.LBB0_81)>>2
	.byte	(.LBB0_84-.LBB0_81)>>2
	.byte	(.LBB0_84-.LBB0_81)>>2
	.byte	(.LBB0_84-.LBB0_81)>>2
	.byte	(.LBB0_84-.LBB0_81)>>2
	.byte	(.LBB0_84-.LBB0_81)>>2
	.byte	(.LBB0_84-.LBB0_81)>>2
	.byte	(.LBB0_84-.LBB0_81)>>2
	.byte	(.LBB0_84-.LBB0_81)>>2
	.byte	(.LBB0_84-.LBB0_81)>>2
	.byte	(.LBB0_84-.LBB0_81)>>2
	.byte	(.LBB0_84-.LBB0_81)>>2
	.byte	(.LBB0_84-.LBB0_81)>>2
	.byte	(.LBB0_84-.LBB0_81)>>2
	.byte	(.LBB0_84-.LBB0_81)>>2
	.byte	(.LBB0_84-.LBB0_81)>>2
	.byte	(.LBB0_84-.LBB0_81)>>2
	.byte	(.LBB0_84-.LBB0_81)>>2
	.byte	(.LBB0_84-.LBB0_81)>>2
	.byte	(.LBB0_81-.LBB0_81)>>2
	.byte	(.LBB0_84-.LBB0_81)>>2
	.byte	(.LBB0_84-.LBB0_81)>>2
	.byte	(.LBB0_84-.LBB0_81)>>2
	.byte	(.LBB0_84-.LBB0_81)>>2
	.byte	(.LBB0_88-.LBB0_81)>>2
	.byte	(.LBB0_84-.LBB0_81)>>2
	.byte	(.LBB0_84-.LBB0_81)>>2
	.byte	(.LBB0_84-.LBB0_81)>>2
	.byte	(.LBB0_84-.LBB0_81)>>2
	.byte	(.LBB0_84-.LBB0_81)>>2
	.byte	(.LBB0_84-.LBB0_81)>>2
	.byte	(.LBB0_84-.LBB0_81)>>2
	.byte	(.LBB0_84-.LBB0_81)>>2
	.byte	(.LBB0_84-.LBB0_81)>>2
	.byte	(.LBB0_84-.LBB0_81)>>2
	.byte	(.LBB0_84-.LBB0_81)>>2
	.byte	(.LBB0_89-.LBB0_81)>>2

	.text
	.p2align	2
	.type	get_wf_frm_num,@function
get_wf_frm_num:
	str	x30, [x18], #8
	stp	x29, x30, [sp, #-64]!
	adrp	x8, global_waveform
	lsl	w9, w0, #2
	stp	x24, x23, [sp, #16]
	mov	x29, sp
	stp	x22, x21, [sp, #32]
	ldr	x14, [x8, :lo12:global_waveform]
	stp	x20, x19, [sp, #48]
	ldrb	w8, [x14, #32]
	add	x8, x14, x8
	add	x8, x8, x9
	ldrb	w9, [x8]
	ldrb	w10, [x8, #1]
	ldrb	w11, [x8, #2]
	ldrb	w12, [x8, #3]
	add	w9, w10, w9
	add	w9, w9, w11
	cmp	w12, w9, uxtb
	b.ne	.LBB1_26
	ldr	w8, [x8]
	lsl	w9, w1, #2
	and	x8, x8, #0xffffff
	add	x8, x14, x8
	add	x9, x8, w9, sxtw
	ldrb	w8, [x9]
	ldrb	w10, [x9, #1]
	ldrb	w11, [x9, #2]
	ldrb	w12, [x9, #3]
	add	w8, w10, w8
	add	w8, w8, w11
	cmp	w12, w8, uxtb
	b.ne	.LBB1_27
	adrp	x20, waveformdata
	ldr	x10, [x20, :lo12:waveformdata]
	cbz	x10, .LBB1_29
	adrp	x21, need_pic
	adrp	x22, maxpic
	ldr	w15, [x9]
	mov	w16, #5
	mov	w0, #32
	mov	w13, wzr
	ldr	w8, [x21, :lo12:need_pic]
	mov	w11, wzr
	ldrb	w9, [x22, :lo12:maxpic]
	and	x15, x15, #0xffffff
	add	x14, x14, x15
	mov	w19, wzr
	cmp	w8, #32
	mov	w12, wzr
	cset	w17, eq
	bics	w15, w17, w9
	mov	w17, #16
	cinc	w16, w16, ne
	cmp	w9, #0
	csel	w17, w0, w17, ne
	mov	w0, #1
	b	.LBB1_6
.LBB1_4:
	mov	w0, #1
.LBB1_5:
	add	w11, w11, #1
	cmp	w19, #254
	b.hi	.LBB1_18
.LBB1_6:
	ldrb	w3, [x14, w11, uxtw]
	cmp	w3, #252
	b.eq	.LBB1_11
	cmp	w3, #255
	b.eq	.LBB1_19
	tbnz	w0, #0, .LBB1_12
.LBB1_9:
	add	w0, w13, #1
	lsl	w1, w12, w15
	lsl	w2, w13, w16
	add	w1, w1, w19, lsl #10
	lsl	w0, w0, w16
	add	w2, w1, w2
	add	w0, w1, w0
	and	w4, w3, #0x3
	ubfx	w5, w3, #2, #2
	strb	w4, [x10, w2, uxtw]
	add	w2, w13, #2
	strb	w5, [x10, w0, uxtw]
	add	w0, w13, #3
	lsl	w2, w2, w16
	lsl	w0, w0, w16
	add	w2, w1, w2
	add	w0, w1, w0
	ubfx	w4, w3, #4, #2
	lsr	w1, w3, #6
	add	w13, w13, #4
	strb	w4, [x10, w2, uxtw]
	cmp	w13, w17
	strb	w1, [x10, w0, uxtw]
	mov	w0, wzr
	b.lo	.LBB1_5
	add	w1, w12, #1
	mov	w13, wzr
	cmp	w1, w17
	csinc	w12, wzr, w12, hs
	cinc	w19, w19, hs
	b	.LBB1_5
.LBB1_11:
	add	w11, w11, #1
	ldrb	w3, [x14, w11, uxtw]
	tbnz	w0, #0, .LBB1_9
.LBB1_12:
	add	w0, w13, #1
	lsl	w1, w12, w15
	lsl	w2, w13, w16
	add	w4, w1, w19, lsl #10
	lsl	w1, w0, w16
	add	w2, w4, w2
	add	w5, w4, w1
	and	w0, w3, #0x3
	ubfx	w1, w3, #2, #2
	strb	w0, [x10, w2, uxtw]
	add	w2, w13, #2
	strb	w1, [x10, w5, uxtw]
	add	w5, w13, #3
	lsl	w2, w2, w16
	lsl	w5, w5, w16
	add	w6, w4, w2
	ubfx	w2, w3, #4, #2
	add	w4, w4, w5
	lsr	w3, w3, #6
	add	w13, w13, #4
	cmp	w13, w17
	strb	w2, [x10, w6, uxtw]
	strb	w3, [x10, w4, uxtw]
	b.lo	.LBB1_14
	add	w4, w12, #1
	mov	w13, wzr
	cmp	w4, w17
	csinc	w12, wzr, w12, hs
	cinc	w19, w19, hs
.LBB1_14:
	add	w11, w11, #1
	ldrb	w4, [x14, w11, uxtw]
	cbnz	w4, .LBB1_16
	b	.LBB1_4
.LBB1_15:
	sub	w4, w4, #1
	tst	w4, #0xff
	b.eq	.LBB1_4
.LBB1_16:
	add	w5, w13, #1
	lsl	w6, w12, w15
	add	w23, w13, #2
	add	w24, w13, #3
	lsl	w7, w13, w16
	add	w6, w6, w19, lsl #10
	lsl	w5, w5, w16
	lsl	w23, w23, w16
	lsl	w24, w24, w16
	add	w7, w6, w7
	add	w5, w6, w5
	add	w23, w6, w23
	add	w6, w6, w24
	add	w13, w13, #4
	cmp	w13, w17
	strb	w0, [x10, w7, uxtw]
	strb	w1, [x10, w5, uxtw]
	strb	w2, [x10, w23, uxtw]
	strb	w3, [x10, w6, uxtw]
	b.lo	.LBB1_15
	add	w5, w12, #1
	mov	w13, wzr
	cmp	w5, w17
	csinc	w12, wzr, w12, hs
	cinc	w19, w19, hs
	b	.LBB1_15
.LBB1_18:
	adrp	x0, .L.str.6
	add	x0, x0, :lo12:.L.str.6
	bl	_printk
	ldrb	w9, [x22, :lo12:maxpic]
	ldr	w8, [x21, :lo12:need_pic]
.LBB1_19:
	cbz	w9, .LBB1_31
	cmp	w8, #16
	b.ne	.LBB1_31
	cbz	w19, .LBB1_31
	ldr	x11, [x20, :lo12:waveformdata]
	mov	w8, wzr
	mov	w9, wzr
	add	x10, x11, #16
	add	x11, x11, #7
.LBB1_23:
	mov	w13, w8
	mov	x14, #-2
	add	x12, x10, x13
	and	x13, x13, #0xffffffe0
	add	x13, x11, x13
.LBB1_24:
	ldurb	w15, [x12, #-16]
	add	x14, x14, #2
	cmp	x14, #30
	sturb	w15, [x13, #-7]
	ldurb	w15, [x12, #-14]
	sturb	w15, [x13, #-6]
	ldurb	w15, [x12, #-12]
	sturb	w15, [x13, #-5]
	ldurb	w15, [x12, #-10]
	sturb	w15, [x13, #-4]
	ldurb	w15, [x12, #-8]
	sturb	w15, [x13, #-3]
	ldurb	w15, [x12, #-6]
	sturb	w15, [x13, #-2]
	ldurb	w15, [x12, #-4]
	sturb	w15, [x13, #-1]
	ldurb	w15, [x12, #-2]
	strb	w15, [x13]
	ldrb	w15, [x12]
	strb	w15, [x13, #1]
	ldrb	w15, [x12, #2]
	strb	w15, [x13, #2]
	ldrb	w15, [x12, #4]
	strb	w15, [x13, #3]
	ldrb	w15, [x12, #6]
	strb	w15, [x13, #4]
	ldrb	w15, [x12, #8]
	strb	w15, [x13, #5]
	ldrb	w15, [x12, #10]
	strb	w15, [x13, #6]
	ldrb	w15, [x12, #12]
	strb	w15, [x13, #7]
	ldrb	w15, [x12, #14]
	add	x12, x12, #64
	strb	w15, [x13, #8]
	add	x13, x13, #32
	b.lo	.LBB1_24
	add	w9, w9, #1
	add	w8, w8, #1024
	cmp	w19, w9, uxtb
	b.hi	.LBB1_23
	b	.LBB1_31
.LBB1_26:
	adrp	x0, .L.str.4
	adrp	x1, .L__func__.get_wf_frm_num
	add	x0, x0, :lo12:.L.str.4
	add	x1, x1, :lo12:.L__func__.get_wf_frm_num
	mov	w2, #229
	b	.LBB1_28
.LBB1_27:
	adrp	x0, .L.str.4
	adrp	x1, .L__func__.get_wf_frm_num
	add	x0, x0, :lo12:.L.str.4
	add	x1, x1, :lo12:.L__func__.get_wf_frm_num
	mov	w2, #236
.LBB1_28:
	bl	_printk
	b	.LBB1_30
.LBB1_29:
	adrp	x0, .L.str.5
	add	x0, x0, :lo12:.L.str.5
	bl	_printk
.LBB1_30:
	mov	w19, #-22
.LBB1_31:
	mov	w0, w19
	ldp	x20, x19, [sp, #48]
	ldp	x22, x21, [sp, #32]
	ldp	x24, x23, [sp, #16]
	ldp	x29, x30, [sp], #64
	ldr	x30, [x18, #-8]!
	ret
.Lfunc_end1:
	.size	get_wf_frm_num, .Lfunc_end1-get_wf_frm_num

	.p2align	2
	.type	pvi_wf_normal_fix,@function
pvi_wf_normal_fix:
	cmp	w1, #1
	b.lt	.LBB2_5
	mov	w9, w1
	mov	x8, xzr
	lsl	x9, x9, #10
	b	.LBB2_3
.LBB2_2:
	ldrb	w11, [x10, #30]
	add	x8, x8, #1024
	cmp	x9, x8
	strb	wzr, [x10, #958]
	strb	wzr, [x10, #1022]
	strb	w11, [x10, #31]
	strb	w11, [x10, #29]
	strb	w11, [x10, #61]
	b.eq	.LBB2_5
.LBB2_3:
	add	x10, x0, w8, sxtw
	cbz	w2, .LBB2_2
	ldrb	w11, [x10, #990]
	strb	wzr, [x10, #990]
	strb	w11, [x10, #989]
	strb	w11, [x10, #1021]
	strb	w11, [x10, #957]
	b	.LBB2_2
.LBB2_5:
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
.Lfunc_end2:
	.size	pvi_wf_normal_fix, .Lfunc_end2-pvi_wf_normal_fix

	.globl	pvi_wf_input
	.p2align	2
	.type	pvi_wf_input,@function
pvi_wf_input:
	str	x30, [x18], #8
	stp	x29, x30, [sp, #-32]!
	stp	x20, x19, [sp, #16]
	adrp	x20, global_waveform
	mov	x29, sp
	ldr	x8, [x20, :lo12:global_waveform]
	cbz	x8, .LBB3_3
	mov	w0, #-16
.LBB3_2:
	ldp	x20, x19, [sp, #16]
	ldp	x29, x30, [sp], #32
	ldr	x30, [x18, #-8]!
	ret
.LBB3_3:
	mov	x19, x0
	ldrb	w1, [x0, #16]
	adrp	x0, .L.str.1
	add	x0, x0, :lo12:.L.str.1
	bl	_printk
	ldrb	w1, [x19, #16]
	sub	w8, w1, #9
	cmp	w8, #105
	b.hi	.LBB3_7
	adrp	x9, .LJTI3_0
	add	x9, x9, :lo12:.LJTI3_0
	adr	x10, .LBB3_5
	ldrb	w11, [x9, x8]
	add	x10, x10, x11, lsl #2
	br	x10
.LBB3_5:
	adrp	x8, maxpic
	mov	w9, #1
	strb	w9, [x8, :lo12:maxpic]
.LBB3_6:
	mov	w0, wzr
	str	x19, [x20, :lo12:global_waveform]
	b	.LBB3_2
.LBB3_7:
	adrp	x0, .L.str.2
	ldrb	w2, [x19, #22]
	add	x0, x0, :lo12:.L.str.2
	bl	_printk
	mov	w0, #-8
	b	.LBB3_2
.Lfunc_end3:
	.size	pvi_wf_input, .Lfunc_end3-pvi_wf_input
	.section	.rodata,"a",@progbits
.LJTI3_0:
	.byte	(.LBB3_6-.LBB3_5)>>2
	.byte	(.LBB3_7-.LBB3_5)>>2
	.byte	(.LBB3_7-.LBB3_5)>>2
	.byte	(.LBB3_7-.LBB3_5)>>2
	.byte	(.LBB3_7-.LBB3_5)>>2
	.byte	(.LBB3_7-.LBB3_5)>>2
	.byte	(.LBB3_7-.LBB3_5)>>2
	.byte	(.LBB3_7-.LBB3_5)>>2
	.byte	(.LBB3_7-.LBB3_5)>>2
	.byte	(.LBB3_6-.LBB3_5)>>2
	.byte	(.LBB3_7-.LBB3_5)>>2
	.byte	(.LBB3_7-.LBB3_5)>>2
	.byte	(.LBB3_7-.LBB3_5)>>2
	.byte	(.LBB3_5-.LBB3_5)>>2
	.byte	(.LBB3_7-.LBB3_5)>>2
	.byte	(.LBB3_5-.LBB3_5)>>2
	.byte	(.LBB3_5-.LBB3_5)>>2
	.byte	(.LBB3_7-.LBB3_5)>>2
	.byte	(.LBB3_7-.LBB3_5)>>2
	.byte	(.LBB3_7-.LBB3_5)>>2
	.byte	(.LBB3_7-.LBB3_5)>>2
	.byte	(.LBB3_7-.LBB3_5)>>2
	.byte	(.LBB3_7-.LBB3_5)>>2
	.byte	(.LBB3_5-.LBB3_5)>>2
	.byte	(.LBB3_7-.LBB3_5)>>2
	.byte	(.LBB3_7-.LBB3_5)>>2
	.byte	(.LBB3_6-.LBB3_5)>>2
	.byte	(.LBB3_7-.LBB3_5)>>2
	.byte	(.LBB3_7-.LBB3_5)>>2
	.byte	(.LBB3_7-.LBB3_5)>>2
	.byte	(.LBB3_7-.LBB3_5)>>2
	.byte	(.LBB3_7-.LBB3_5)>>2
	.byte	(.LBB3_7-.LBB3_5)>>2
	.byte	(.LBB3_7-.LBB3_5)>>2
	.byte	(.LBB3_7-.LBB3_5)>>2
	.byte	(.LBB3_7-.LBB3_5)>>2
	.byte	(.LBB3_7-.LBB3_5)>>2
	.byte	(.LBB3_7-.LBB3_5)>>2
	.byte	(.LBB3_7-.LBB3_5)>>2
	.byte	(.LBB3_7-.LBB3_5)>>2
	.byte	(.LBB3_7-.LBB3_5)>>2
	.byte	(.LBB3_7-.LBB3_5)>>2
	.byte	(.LBB3_7-.LBB3_5)>>2
	.byte	(.LBB3_7-.LBB3_5)>>2
	.byte	(.LBB3_7-.LBB3_5)>>2
	.byte	(.LBB3_7-.LBB3_5)>>2
	.byte	(.LBB3_7-.LBB3_5)>>2
	.byte	(.LBB3_7-.LBB3_5)>>2
	.byte	(.LBB3_7-.LBB3_5)>>2
	.byte	(.LBB3_7-.LBB3_5)>>2
	.byte	(.LBB3_7-.LBB3_5)>>2
	.byte	(.LBB3_7-.LBB3_5)>>2
	.byte	(.LBB3_7-.LBB3_5)>>2
	.byte	(.LBB3_7-.LBB3_5)>>2
	.byte	(.LBB3_7-.LBB3_5)>>2
	.byte	(.LBB3_7-.LBB3_5)>>2
	.byte	(.LBB3_7-.LBB3_5)>>2
	.byte	(.LBB3_7-.LBB3_5)>>2
	.byte	(.LBB3_5-.LBB3_5)>>2
	.byte	(.LBB3_7-.LBB3_5)>>2
	.byte	(.LBB3_7-.LBB3_5)>>2
	.byte	(.LBB3_7-.LBB3_5)>>2
	.byte	(.LBB3_7-.LBB3_5)>>2
	.byte	(.LBB3_5-.LBB3_5)>>2
	.byte	(.LBB3_7-.LBB3_5)>>2
	.byte	(.LBB3_7-.LBB3_5)>>2
	.byte	(.LBB3_7-.LBB3_5)>>2
	.byte	(.LBB3_7-.LBB3_5)>>2
	.byte	(.LBB3_7-.LBB3_5)>>2
	.byte	(.LBB3_7-.LBB3_5)>>2
	.byte	(.LBB3_7-.LBB3_5)>>2
	.byte	(.LBB3_7-.LBB3_5)>>2
	.byte	(.LBB3_7-.LBB3_5)>>2
	.byte	(.LBB3_7-.LBB3_5)>>2
	.byte	(.LBB3_7-.LBB3_5)>>2
	.byte	(.LBB3_6-.LBB3_5)>>2
	.byte	(.LBB3_7-.LBB3_5)>>2
	.byte	(.LBB3_7-.LBB3_5)>>2
	.byte	(.LBB3_7-.LBB3_5)>>2
	.byte	(.LBB3_7-.LBB3_5)>>2
	.byte	(.LBB3_7-.LBB3_5)>>2
	.byte	(.LBB3_7-.LBB3_5)>>2
	.byte	(.LBB3_7-.LBB3_5)>>2
	.byte	(.LBB3_7-.LBB3_5)>>2
	.byte	(.LBB3_7-.LBB3_5)>>2
	.byte	(.LBB3_7-.LBB3_5)>>2
	.byte	(.LBB3_7-.LBB3_5)>>2
	.byte	(.LBB3_7-.LBB3_5)>>2
	.byte	(.LBB3_7-.LBB3_5)>>2
	.byte	(.LBB3_7-.LBB3_5)>>2
	.byte	(.LBB3_7-.LBB3_5)>>2
	.byte	(.LBB3_7-.LBB3_5)>>2
	.byte	(.LBB3_7-.LBB3_5)>>2
	.byte	(.LBB3_7-.LBB3_5)>>2
	.byte	(.LBB3_7-.LBB3_5)>>2
	.byte	(.LBB3_7-.LBB3_5)>>2
	.byte	(.LBB3_7-.LBB3_5)>>2
	.byte	(.LBB3_7-.LBB3_5)>>2
	.byte	(.LBB3_7-.LBB3_5)>>2
	.byte	(.LBB3_7-.LBB3_5)>>2
	.byte	(.LBB3_7-.LBB3_5)>>2
	.byte	(.LBB3_7-.LBB3_5)>>2
	.byte	(.LBB3_7-.LBB3_5)>>2
	.byte	(.LBB3_7-.LBB3_5)>>2
	.byte	(.LBB3_7-.LBB3_5)>>2
	.byte	(.LBB3_5-.LBB3_5)>>2

	.text
	.globl	pvi_wf_get_version
	.p2align	2
	.type	pvi_wf_get_version,@function
pvi_wf_get_version:
	adrp	x8, global_waveform
	ldr	x8, [x8, :lo12:global_waveform]
	cbz	x8, .LBB4_2
	adrp	x0, pvi_wf_get_version.spi_id_buffer
	ldur	x9, [x8, #73]
	ldr	x10, [x8, #88]
	add	x0, x0, :lo12:pvi_wf_get_version.spi_id_buffer
	ldur	x11, [x8, #81]
	ldur	x8, [x8, #65]
	stur	x10, [x0, #23]
	stp	x9, x11, [x0, #8]
	str	x8, [x0]
	strb	wzr, [x0, #31]
	ret
.LBB4_2:
	mov	x0, xzr
	ret
.Lfunc_end4:
	.size	pvi_wf_get_version, .Lfunc_end4-pvi_wf_get_version

	.type	pvi_mode_table,@object
	.section	.rodata,"a",@progbits
	.globl	pvi_mode_table
pvi_mode_table:
	.asciz	"\000\001\001\002\003\003\003\004\003"
	.asciz	"\000\001\007\003\003\005\006\004\005"
	.asciz	"\000\001\001\002\003\004\004\006\005"
	.asciz	"\000\001\007\002\003\004\005\006\004"
	.asciz	"\000\001\005\002\003\003\003\004\003"
	.asciz	"\000\001\001\002\003\004\004\006\004"
	.asciz	"\000\001\001\002\003\004\004\005\004"
	.asciz	"\000\001\001\002\003\004\013\006\n"
	.asciz	"\000\001\001\002\003\004\005\006\004"
	.size	pvi_mode_table, 90

	.type	pvi_wf_get_lut.stype,@object
	.data
	.p2align	2
pvi_wf_get_lut.stype:
	.word	15
	.size	pvi_wf_get_lut.stype, 4

	.type	pvi_wf_get_lut.sftemp,@object
	.p2align	2
pvi_wf_get_lut.sftemp:
	.word	4294967295
	.size	pvi_wf_get_lut.sftemp, 4

	.type	pvi_wf_get_lut.fix,@object
	.local	pvi_wf_get_lut.fix
	.comm	pvi_wf_get_lut.fix,4,4
	.type	global_waveform,@object
	.local	global_waveform
	.comm	global_waveform,8,8
	.type	need_pic,@object
	.p2align	2
need_pic:
	.word	16
	.size	need_pic, 4

	.type	waveformdata,@object
	.local	waveformdata
	.comm	waveformdata,8,8
	.type	.L.str,@object
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"pvi waveform get frame number failed\n"
	.size	.L.str, 38

	.type	.L.str.1,@object
.L.str.1:
	.asciz	"pvi : input waveform version 0x%x\n"
	.size	.L.str.1, 35

	.type	maxpic,@object
	.local	maxpic
	.comm	maxpic,1,4
	.type	.L.str.2,@object
.L.str.2:
	.asciz	"pvi : Unknow waveform version 0x%x, 0x%x, may be wrong waveform file\n"
	.size	.L.str.2, 70

	.type	pvi_wf_get_version.spi_id_buffer,@object
	.local	pvi_wf_get_version.spi_id_buffer
	.comm	pvi_wf_get_version.spi_id_buffer,32,1
	.type	.L.str.3,@object
.L.str.3:
	.asciz	"pvi: unspport PVI waveform type"
	.size	.L.str.3, 32

	.type	.L.str.4,@object
.L.str.4:
	.asciz	"pvi: %s %d check error\n"
	.size	.L.str.4, 24

	.type	.L__func__.get_wf_frm_num,@object
.L__func__.get_wf_frm_num:
	.asciz	"get_wf_frm_num"
	.size	.L__func__.get_wf_frm_num, 15

	.type	.L.str.5,@object
.L.str.5:
	.asciz	"waveformdata is NULL\n"
	.size	.L.str.5, 22

	.type	.L.str.6,@object
.L.str.6:
	.asciz	"pvi: decodec waveform error, framenum err\n"
	.size	.L.str.6, 43

	.type	.Lswitch.table.pvi_wf_get_lut.7,@object
	.section	.rodata,"a",@progbits
	.p2align	3
.Lswitch.table.pvi_wf_get_lut.7:
	.xword	3
	.xword	5
	.xword	6
	.xword	4
	.xword	3
	.size	.Lswitch.table.pvi_wf_get_lut.7, 40

	.ident	"Android (8508608, based on r450784e) clang version 14.0.7 (https://android.googlesource.com/toolchain/llvm-project 4c603efb0cca074e9238af8b4106c30add4418f6)"
	.section	".note.GNU-stack","",@progbits
	.addrsig
	.addrsig_sym pvi_wf_get_version.spi_id_buffer

b_math_template
			.block
			jsr	push
			jsr	pop
			rts
			.bend

b_pr_ax_str	.block
			jsr	push
			jsr	b_axout
			jsr	pop
			rts
			.bend


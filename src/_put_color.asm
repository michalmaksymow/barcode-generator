# Puts colors of one character value on barcode line, starting at specified address
#
# Arguments: 	$a0 (address at which character value bars should be put) [byte array address]
# 		$a1 (character value) [int]
#
# Returns:	void

_put_color:
# $t0 -> points at currently processed pixel
# $t1 -> points at current bar in charcodes array
# $t2 -> state (0 = insert black bar, 1 = insert white)
# $t3 -> state (0 = narrow, 1 = wide)
# $t5 -> auxiliary
# $t6 -> auxiliary
# $t7 -> auxiliary
# $t8 -> narrow bar size
# $t9 -> wide bar size
	move	$t0, $a0
	lw	$t8, size_px	# Save size of narrow bar in $t8
	li	$t7, 3
	mult	$t8, $t7	# Multiply narrow_bar * 3 to get size of wide bar
	mflo	$t9		# Save size of wide bar in $t9
	# Setup offset in charcodes array
	la	$t1, char_codes
	li	$t7, 9
	mult	$a1, $t7	# Calculate offest on array
	mflo	$t7
	add	$t1, $t1, $t7	# $t1 points to first bar of computed character
	# Setup outer loop
	li	$t2, 1		# Set state to place black bar
	li	$t6, 9		# j = 9
__put_color_nextbar: # Outer loop
	beqz	$t6, __put_color_fin
	lbu	$t3, ($t1)	# Check if bar should be narrow or wide
	beqz 	$t3, __put_color_narrow
# inner loop
__put_color_wide:	
	move 	$t7, $t9	# $t7 = i = narrow_bar
__put_color_wide_loop:
	beqz	$t7, __put_color_nextbar_fin
	# Set pixel color
	beqz 	$t2, __put_color_wide_empty
	# Put black px
	li	$t5, 0
	sb	$t5, ($t0)
	addiu	$t0, $t0, 1
	sb	$t5, ($t0)
	addiu	$t0, $t0, 1
	sb	$t5, ($t0)
	addiu	$t0, $t0, 1
	subiu  	$t7, $t7, 1	# --i
	b, __put_color_wide_loop
__put_color_wide_empty:
	addiu	$t0, $t0, 3	# Go to next pixel
	subiu  	$t7, $t7, 1	# --i
	b, __put_color_wide_loop
# end inner loop	
# inner loop
__put_color_narrow:
	move 	$t7, $t8	# $t7 = i = narrow_bar
__put_color_narrow_loop:
	beqz	$t7, __put_color_nextbar_fin
	# Set pixel color
	beqz 	$t2, __put_color_narrow_empty
	# Put black px (3 consecutive bytes)
	li	$t5, 0
	sb	$t5, ($t0)
	addiu	$t0, $t0, 1
	sb	$t5, ($t0)
	addiu	$t0, $t0, 1
	sb	$t5, ($t0)
	addiu	$t0, $t0, 1
	subiu  	$t7, $t7, 1	# --i
	b, __put_color_narrow_loop
__put_color_narrow_empty:
	addiu	$t0, $t0, 3	# Go to next pixel (skip 3 bytes)
	subiu  	$t7, $t7, 1	# --i
	b, __put_color_narrow_loop
# end inner loop
__put_color_nextbar_fin:
	sub	$t6, $t6, 1	# --j
	addiu	$t1, $t1, 1	# Go to next bar
	# Change state
	beqz 	$t2, __put_color_changestate
	li	$t2, 0
	b	__put_color_nextbar
__put_color_changestate:
	li	$t2, 1
	b	__put_color_nextbar
__put_color_fin:
	jr	$ra

# Computes barcode's expected final width
#
# Arguments: 	$a0: (address of an encoded string) [byte array address]
#		$a1: (size of narrow bar) [int]
#
# Returns:	$v0: (size of barcode) [int]

_compute_width:
# $t0 -> points at byte of a encoded string
# $t1 -> narrow bar size in px
# $t2 -> wide bar size (= narrow bar * 3)
# $t3 -> current calculated char value
# $t4 -> char width
# $t7 -> auxiliary
	li	$v0, 0		# Initialize $v0 to zero (default return value)
	move	$t0, $a0	# Move address of %a0 to %t0
	# Setup bar sizes (narrow and wide)
	move	$t1, $a1	# Move value of %a1 to %t1
	li	$t7, 3		# Set $t7 to 3
	mult	$t1, $t7	# Multiplies narrow_bar*3
	mflo	$t2		# Sets content of $t2 to lower product register (I assume that higher will not be used)
	# Setup char width: 3 x wide + 6 x narrow
	li 	$t4, 0
	li	$t7, 3
	mult	$t2, $t7	# Multiplies wide_bar*3
	mflo	$t7
	add	$t4, $t4, $t7
	li	$t7, 6
	mult	$t1, $t7	# Multiplies narrow_bar*6
	mflo	$t7
	add	$t4, $t4, $t7
	# Add start character to result with a narrow space
	add	$v0, $v0, $t4
	add	$v0, $v0, $t1
__compute_width_nextchar:
	# Move to next character
	addiu	$t0, $t0, 1	# Move pointer $t0 by 0 (to next byte)
	lbu	$t3, ($t0)	# Copy character to $t3 (first eight effective bits)
	beq 	$t3, 43, __compute_width_fin	# Go to finish branch if read char valuse is 43 (stop character)
	add	$v0, $v0, $t4	# Add character width to result
	add	$v0, $v0, $t1	# Add space between the bars (one narrow space)
	b	__compute_width_nextchar
__compute_width_fin:
	add	$v0, $v0, $t4	# Add stop character to result
	# Return
	jr	$ra

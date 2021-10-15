# Computes (Code39) checksum of a given string
#
# Arguments: 	$a0: (address of a string used in computation)
#
# Returns:	$v0: (checksum) [int]

_compute_checksum:
	move	$t0, $a0	# Set address of first char of string to $t0
	li	$v0, 0		# Set return value to zero (temporary)
__compute_checksum_nextchar:	# Next character of a string loop (outer loop)
	lbu	$t1, ($t0)	# Copy character to $t1 (first eight effective bits)
	bltu	$t1, ' ', __compute_checksum_fin	# Go to fin branch if read char is less then ' ' whitespace (probably some null terminating character)
	la	$t2, values	# Load address of values array to $t2
	li 	$t7, 0		# Current values array offset
__compute_checksum_sv:		# Search char value loop (inner loop)
	lbu   	$t3, ($t2)	# Load char stored at $t2 to $t3
	beq	$t1, $t3, __compute_checksum_found
	addiu	$t2, $t2, 1	# Move pointer by 1 (to next char)
	add 	$t7, $t7, 1	# Increment value
	b	__compute_checksum_sv
__compute_checksum_found:
	add	$v0, $v0, $t7	# $v0 += $t7
	addiu	$t0, $t0, 1	# Move pointer $t0 by 1 (to next char)
	b	__compute_checksum_nextchar
__compute_checksum_fin:
	jr	$ra		# Jump back to PC to continue exec

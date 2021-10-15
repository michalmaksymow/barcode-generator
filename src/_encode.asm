# Encodes provided string with Code39 values
#
# Arguments: 	$a0: (address of a string to be encoded)
#		$a1: (address of output byte array)
#
# Returns:	void

_encode:	
# $t0 -> points at char of a string being encoded
# $t1 -> points at byte of encoded values array
# $t2 -> stores value of a char that is currently encoded
# $t3 -> points at char of values array
# $t4 -> stores offset of values array
# $t5 -> stores value of char that the encoded char is currently compared to
# $t6 -> stores intermediate values
	move	$t0, $a0	# Set address of first char of string to $t0
	move	$t1, $a1	# Set address of first byte of output to $t1
	# Push start character
	li	$t3, 43
	sb 	$t3, ($t1)	# Add star symbol, which is * (43 encoded)
	addiu	$t1, $t1, 1	# Move pointer $t1 by 1 (to next byte)
	# String encoding
__encode_nextchar:
	lbu	$t2, ($t0)	# Copy character to $t2 (first eight effective bits)
	bltu	$t2, ' ', __encode_fin	# Go to finish branch if read char is less then ' ' whitespace (probably some null terminating character)
	la	$t3, values	# Load address of values array to $t2
	li 	$t4, 0		# Current values array offset
__encode_sv: 			# Search value (inner loop)
	lbu   	$t5, ($t3)	# Load char stored at $t3 to $t5
	beq	$t2, $t5, __encode_found
	addiu	$t3, $t3, 1	# Move pointer $t3 by 1 (to next char)
	add 	$t4, $t4, 1	# Increment offset value
	b	__encode_sv
__encode_found:
	sb 	$t4, ($t1)	# Stores encoded symbol value at specified address
	addiu	$t0, $t0, 1	# Move pointer $t0 by 1 (to next char)
	addiu	$t1, $t1, 1	# Move pointer $t1 by 1 (to next byte)
	b	__encode_nextchar
__encode_fin:
	# Push checksymbol value
	lbu	$t6, checksymbol	# Load checksum value
	sb 	$t6, ($t1)	# Store checksum value at given address
	addiu	$t1, $t1, 1	# Move pointer $t1 by 1 (to next byte)
	# Push stop symbol
	li	$t6, 43
	sb 	$t6, ($t1)	# Add star symbol, which is * (43 encoded)
	# End procedure
	jr	$ra		

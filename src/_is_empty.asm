# Checks if a string is empty
#
# Arguments: 	$a0: (address of a buffer in which the string is saved) 
#
# Returns:	$v0 (1 [true] if string is empty) [int] 

_is_empty:
	move	$t0, $a0	# Set address of first char of string to $t0
	lbu	$t1, ($t0)	# Copy first character to $t1 (first eight effective bits)
	bne 	$t1, '\n', __is_empty_false	# If first character is not equal to \n go to branch and return 0 (false)
	li 	$v0, 1		# Set return value to 1 (true)
	jr	$ra		# Jump back to PC to continue exec
__is_empty_false:
	li 	$v0, 0		# Set return value to 0 (false)
	jr	$ra		# Jump back to PC to continue exec

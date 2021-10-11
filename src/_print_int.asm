#
# Prints out a specified integer
#
# Arguments: 	$a0: (integer to be printed)
#
# Returns:	void
#
_print_int:
	li	$v0, 1		# System call for print_integer
	syscall
	jr	$ra		# Jump back to PC to continue exec

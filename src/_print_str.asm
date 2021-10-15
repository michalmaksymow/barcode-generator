# Prints out a specified string
#
# Arguments: 	$a0: (address of a string to be printed)
#
# Returns:	void

_print_str:
	li 	$v0, 4		# System call for print_string
	syscall
	jr	$ra		# Jump back to PC to continue exec

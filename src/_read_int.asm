# Reads an integer from input
#
# Arguments: 	none
#
# Returns:	$v0 (read integer) [int]

_read_int:
	li 	$v0, 5		# System call for read_integer and store read integer at $v0
	syscall
	jr	$ra		# Jump back to PC to continue exec

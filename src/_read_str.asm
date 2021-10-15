# Reads a string from input
#
# Arguments: 	$a0: (address of a buffer in which read string will be saved) 
#		$a1: (maximum number of characters to be read) [int]
#
# Returns:	void

_read_str:
	li 	$v0, 8		# System call for read_string
	syscall
	jr	$ra		# Jump back to PC to continue exec

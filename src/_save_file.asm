# Saves content to a file
#
# Arguments:	$a0: (filename) [string address]
#		$a1: (address of output buffer) [byte array address]
#		$a2: (number of characters to write) [int]
#
# Returns:	none

_save_file:
	move	$t0, $a0	# Save filename in $t0
	move	$t1, $a1	# Save address of input buffer in $t1
	move 	$t2, $a2	# Save number of characters to read in $t3
	# Open file
	move 	$a0, $t0	# Set name of the file
	li	$a1, 1		# Set flag: write
	li	$a2, 0		# Set mode
	li	$v0, 13		# Set open_file for syscall
	syscall
	move	$t3, $v0	# Store file descriptor in $t3
	bltz	$t3, cannot_open_write
	# Write file
	move	$a0, $t3	
	move	$a1, $t1
	move	$a2, $t2
	li	$v0, 15		# Set write_file for syscall
	syscall
	bltz	$t3, error_writing
	# Close file
	move 	$a0, $t3	# Set file descriptor
	li	$v0, 16		# Set close_file for syscall
	syscall
	# Return
	jr	$ra

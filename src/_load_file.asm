# Load contents of a file
#
# Arguments:	$a0: (filename) [string address]
#		$a1: (address of input buffer) [byte array address]
#		$a2: (number of characters to read) [int]
#
# Returns:	none

_load_file:
# $t0 -> Stores filename address
# $t1 -> Stores address of input buffer
# $t2 -> Stores number of characters to read
# $t3 -> Stores file descriptor
	move	$t0, $a0	# Save filename in $t0
	move	$t1, $a1	# Save address of input buffer in $t1
	move 	$t2, $a2	# Save number of characters to read in $t3
	# Open file
	move 	$a0, $t0	# Set name of the file
	li	$a1, 0		# Set flag: read
	li	$a2, 0		# Set mode
	li	$v0, 13		# Set open_file for syscall
	syscall
	move	$t3, $v0	# Store file descriptor in $t3
	bltz 	$t3, cannot_read	# Display error if the file could not be opened
	# Read file
	move	$a0, $t3	
	move	$a1, $t1
	move	$a2, $t2
	li	$v0, 14		# Set read_file for syscall
	syscall
	bne 	$v0, $t2, error_reading	# Display error if read less characters than supposed
	# Close file
	move 	$a0, $t3	# Set file descriptor
	li	$v0, 16		# Set close_file for syscall
	syscall
	# Return
	jr	$ra

# Returns true (1) if $a0 <= $a1 
#
# Arguments: 	$a0: (first number) [int]
#		$a1: (second number) [int]
#
# Returns:	$v0: ($a0 <= $a1 ? 1 : 0) [int]

_less_or_equal:
	move	$t0, $a0 	# Copy value
	move	$t1, $a1	# Copy value
	ble 	$t0, $t1, __less_or_equal_true	# Return true
	li	$v0, 0		# Initialise return value
	jr	$ra
__less_or_equal_true:
	li	$v0, 1
	jr	$ra

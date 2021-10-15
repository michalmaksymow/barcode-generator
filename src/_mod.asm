# Computes remainder of division 
#
# Arguments: 	$a0: (dividend) [int]
#		$a1: (divisor)	[int]
#
# Returns:	$v0: (remainder of division - dividend mod divisor) [int]

_mod:
	div 	$a0, $a1	# Divide $a0 by $a1
	mfhi	$v0		# Copy value of high register to $v0 (return value)
	jr	$ra		# Jump back to PC to continue execcution

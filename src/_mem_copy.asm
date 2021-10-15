# Copies specified amount of bytes from one adrress to another
#
# Arguments: 	$a0: (address of bytes to copy) [byte array address]
#		$a1: (destination address) [byte arrray address]
#		$a2: (amount of bytes to copy) [int]
#
# Returns:	void

_mem_copy:
	move	$t0, $a0
	move	$t1, $a1
	move	$t2, $a2	# $t2 = i
__mem_copy_loop:
	beqz	$t2, __mem_copy_fin
	lbu	$t3, ($t0)
	sb	$t3, ($t1)
	addiu	$t0, $t0, 1	# Increment pointer
	addiu	$t1, $t1, 1	# Increment pointer
	subiu 	$t2, $t2, 1	# --i
	b	__mem_copy_loop
__mem_copy_fin:
	jr	$ra

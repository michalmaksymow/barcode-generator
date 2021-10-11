#
# Initialises color of each pixel of one barcode line (600 x 1 px)
#
# Arguments: 	$a0: (line colors) [byte array address]
#
# Returns:	void
#
_init_line:
# $t0 -> points at a line pixel
# $t6 -> auxiliary 
# $t7 -> auxiliary
	move	$t0, $a0
	# Initialise pixels to 255 (white)
	li	$t7, 450	# i
	li	$t6, 0xFFFFFFFF	# Initialise 4 bytes to 0xFF (more efficient than initialisation one-by-one)
__init_line_init:	# for loop 450 times
	beqz 	$t7, __init_line_fin
	sw	$t6, ($t0)	# Store 0xFFFFFFFF at pointer
	addiu	$t0, $t0, 4	# Move pointer by 4 bytes
	subiu 	$t7, $t7, 1	# --i
	b	__init_line_init
__init_line_fin:
	jr	$ra

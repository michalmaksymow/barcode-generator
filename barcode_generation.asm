.data
size_px:	.word 	0	# Width of narrowest bar (in pixels)
input:		.space 	82	# Text to be encoded
checksum:	.word	0	# Used to calculate check symbol (check_symbol = checksum % 43)
checksymbol:	.word	0	# Checksymbol value
encoded:	.space	84	# Code 39 encoded Character Codes values with start, stop and check symbols appended
fullsize:	.word	0	# Width of generated barcode (to check if it will fit)

.include "messages.asm"
.include "values.asm"
.include "character_codes.asm"

.text
main:
	# Display prompt about size
	la	$a0, prompt1	# Set argument for _print_str procedure
	jal 	_print_str	# Call _read_str procedure
	
	# Read integer from input
	jal 	_read_int	# Call _read_str procedure
	
	# If provided size is lesser or equal to zero, go to invalid_size branch
	blez 	$v0, invalid_size
	
	# Save read integer in memory
	sw	$v0, size_px	# Store contents of $v0 to 'size_px' variable
	
	# Output read integer to confirm to user
	la 	$a0, out1	# Set address of 'out1' string to be displayed
	jal 	_print_str
	lw	$a0, size_px	# Set value of word 'size_px' to be displayed
	jal 	_print_int

	# Display second prompt (about text input)
	la	$a0, prompt2	# Set string address for printing
	jal 	_print_str
	
	# Read string from input
	la 	$a0, input	# Set address of string buffer
	li	$a1, 80		# Set maximum number of characters
	jal	_read_str
	
	# Check correctness of input string
	# 1. Check if longer than zero characters
 	la 	$a0, input	# Set address of string buffer
	jal	_is_empty
	bgtz 	$v0, invalid_string_1	# Output message about empty string
	#2. Check if each characters is correct and can be encoded
	la 	$a0, input	# Set address of string buffer
	jal	_check_incorrect
	bgtz 	$v0, invalid_string_2	# Output message about incorrect character in string

	# Output read string to confirm to user
	la 	$a0, out2	# Set address of 'out2' string to be displayed
	jal 	_print_str
	la 	$a0, input	# Set address of 'out2' string to be displayed
	jal 	_print_str

	# Compute checksum
	la 	$a0, input	# Set address of string buffer
	jal	_compute_checksum
	sw	$v0, checksum	# Store contents of $v0 to 'checksum' variable
	
	# Output checksum
	la 	$a0, out3	# Set address of 'out3' string to be displayed
	jal 	_print_str	
	lw	$a0, checksum	# Set value of word 'checksum' to be displayed
	jal 	_print_int
	
	# Compute checksymbol value (checksum % 43)
	lw	$a0, checksum	# Load word from checksum to $a0
	li	$a1, 43		# Set value of $a1 to 43
	jal 	_mod
	sw	$v0, checksymbol	# Save returned value on checksymbol
	
	# Output checksymbol value
	la 	$a0, out4	# Set address of 'out4' string to be displayed
	jal 	_print_str
	lw	$a0, checksymbol
	jal	_print_int

# "Should have encoded first and then just sum up to get checksum"
# ~ Michal 
	# Encode string
	la	$a0, input
	la	$a1, encoded
	jal 	_encode
	
	# Compute generated barcode width (check if it will fit fixed 600x50 size)
	la	$a0, encoded
	lw 	$a1, size_px
	jal	_compute_width
	sw	$v0, fullsize
	
# TODO: 
# 1. Transform each char in the string to a numerical value -- DONE
# 2. Compute width in pixels & Check if it will fit the 600x50
# 3. Start bmp generation
	
	# Go to exit of program
	b 	exit




# =================================================================================== PROCEDURES

# Computes barcode width
#
# Arguments: 	$a0: (address of an encoded string) [byte array address]
#		$a1: (size of narrow bar) [int]
#
# Returns:	$v0: (size of barcode) [int]
_compute_width:
# $t0 -> points at byte of a encoded string
# $t1 -> narrow bar size in px
# $t2 -> wide bar size (= narrow bar * 3)
# $t3 -> current encoded char value
# $t7 -> auxiliary

	# Setup initial return value 
	li	$v0, 0
	# Setup bar sizeds (narrow and wide)
	move	$t0, $a0	# Move address of %a0 to %t0
	move	$t1, $a1	# Move value of %a1 to %t1
	li	$t7, 3		# Set $t7 to 3
	mult	$t1, $t7	# Multiplies narrow_bar*3
	mflo	$t2		# Sets content of $t2 to lower product register (I assume that higher will not be used)
	
	# Add "*" to the width and one narrow space (3 x wide + 7 x narrow)
	
	
	
	lbu	$t3, ($t0)	# Copy character to $t2 (first eight effective bits)
	
	jr	$ra



.include "_encode.asm"
.include "_mod.asm"
.include "_compute_checksum.asm"
.include "_print_str.asm"
.include "_print_int.asm"
.include "_read_str.asm"
.include "_read_int.asm"
.include "_is_empty.asm"
.include "_check_incorrect.asm"

#  =================================================================================== ERROR INFORMATION BRANCHES

# Inform about incorrect input size and exit
invalid_size:
	la	$a0, err1	# Set string address for printing
	jal 	_print_str
	b	exit		# Go to exit of program
# Inform about incorrect input string and exit
invalid_string_1:
	la	$a0, err2	# Set string address for printing
	jal 	_print_str
	b	exit		# Go to exit of program
invalid_string_2:
	la	$a0, err3	# Set string address for printing
	jal 	_print_str
	b	exit		# Go to exit of program
	
# =================================================================================== EXIT
	
exit:
	# Terminate program
	li	$v0, 10			# Set function number for terminate_execution
	syscall

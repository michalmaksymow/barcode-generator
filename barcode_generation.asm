.data
size_px:	.word 	0	# Width of narrowest bar (in pixels)
input:		.space 	82	# Text to be encoded
checksum:	.word	0	# Used to calculate check symbol (check_symbol = checksum % 43)
checksymbol:	.word	0	# Checksymbol value
encoded:	.space	84	# Code 39 encoded Character Codes values with start, stop and check symbols appended
width:		.word	0	# Width of generated barcode (to check if it will fit)
line:		.space	1800	# Colors on one line of the barcode
image:		.space	90122	# 600 x 50 .bmp image

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

	# Should have encoded first and then just sum up to get checksum"
	# ~ Michal 
	# Encode string
	la	$a0, input
	la	$a1, encoded
	jal 	_encode
	
	# Compute generated barcode width
	la	$a0, encoded
	lw 	$a1, size_px
	jal	_compute_width
	sw	$v0, width
	
	# Print information about expected barcode width
	la 	$a0, out5	# Set address of 'out5' string to be displayed
	jal 	_print_str
	lw	$a0, width	# Set value of 'width' word to be displayed
	jal	_print_int
	
	# Check if it will fit fixed 600x50 size
	lw	$a0, width
	li	$a1, 600
	jal	_less_or_equal
	beqz 	$v0, invalid_width
	
	# Initialise barcode line to white (each pixel to 0xFF) 
	la	$a0, line
	jal	_init_line
	# Now, whole pixel line is initialised to white, so
	# it is time start to put each character bars pixels
	
# Paint one barcode line
# $s0 -> points to currently processed char
# $s1 -> points to currently processed pixel
# $s6 -> stores size of one painted char in bytes(px*3) - (3 * wide_bar + 6 * narrow_bar)*3
# $s7 -> stores size of one space between chars in bytes (narrow space)*3
	li	$s6, 0
	lw	$t0, size_px	# $t0 = narrow_bar
	li 	$t1, 6		
	mult	$t0, $t1
	mflo	$t2		# $t2 = 6 * narrow_bar
	add	$s6, $s6, $t2	# $s6 = 6 * narrow_bar
	li 	$t1, 3
	mult	$t0, $t1
	mflo	$t0		# $t0 = wide_bar
	mult	$t0, $t1	
	mflo	$t2		# $t2 = 3 * wide_bar
	add	$s6, $s6, $t2	# $s6 = 3 * wide_bar + 6 * narrow_bar
	mult	$s6, $t1
	mflo	$s6		# (3 * wide_bar + 6 * narrow_bar)*3
	lw	$t0, size_px
	li	$t1, 3
	mult	$t0, $t1
	mflo	$s7
	
	la 	$s0, encoded	# Point to currently processed char
	la	$s1, line	# Point to currently processed pixel
	# Put 43 '*' (start character) bars colors
	lbu	$t0, ($s0)	# Load value of currently processed char to pass as argument to a function
	move	$a0, $s1	
	move 	$a1, $t0
	jal	_put_color
	addiu 	$s0, $s0, 1	# Move pointer to process next character 
	add	$s1, $s1, $s6	# Move currently processed pixel by one character
	add	$s1, $s1, $s7	# Move currently processed pixel by one narrow space
nextchar_loop:
	lbu	$t0, ($s0)
	beq	$t0, 43, nextchar_loop_fin
	move	$a0, $s1	
	move 	$a1, $t0
	jal	_put_color
	addiu 	$s0, $s0, 1	# Move pointer to process next character 
	add	$s1, $s1, $s6	# Move currently processed pixel by one character
	add	$s1, $s1, $s7	# Move currently processed pixel by one narrow space
	b	nextchar_loop
nextchar_loop_fin:
	# Put 43 '*' (stop character) bars colors
	move	$a0, $s1	
	move 	$a1, $t0
	jal	_put_color
	# Barcode line painted
	
	# Load a BMP from a sample file
	la	$a0, loadname
	la	$a1, image
	li	$a2, 90122
	jal 	_load_file
	
	# Copy painted line on each row of BMP
	la	$s0, line
	la	$s1, image
	addiu	$s1, $s1, 122	# Offset bmp pointer to first pixel
	
	li	$s2, 50
copy_line:
	beqz	$s2, copy_line_fin
	move	$a0, $s0
	move	$a1, $s1
	li	$a2, 1800
	jal	_mem_copy
	addiu	$s1, $s1, 1800
	subiu 	$s2, $s2, 1
	b	copy_line
copy_line_fin:
	
	# Save file
	la	$a0, filename
	la	$a1, image
	li	$a2, 90122
	jal 	_save_file
	
	# Go to the exit of the program
	b 	exit


# =================================================================================== PROCEDURES

.include "_save_file.asm"	
.include "_mem_copy.asm"
.include "_load_file.asm"
.include "_put_color.asm"
.include "_init_line.asm"
.include "_less_or_equal.asm"
.include "_compute_width.asm"
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
# Inform about incorrect width
invalid_width:
	la	$a0, err4	# Set string address for printing
	jal 	_print_str
	b	exit		# Go to exit of program

# File errors
cannot_read:
	la	$a0, err5	# Set string address for printing
	jal 	_print_str
	b	exit		# Go to exit of program
error_reading:
	la	$a0, err6	# Set string address for printing
	jal 	_print_str
	b	exit		# Go to exit of program
	
cannot_open_write:
	la	$a0, err7	# Set string address for printing
	jal 	_print_str
	b	exit		# Go to exit of program
error_writing:
	la	$a0, err8	# Set string address for printing
	jal 	_print_str
	b	exit		# Go to exit of program
# =================================================================================== EXIT
	
exit:
	# Terminate program
	li	$v0, 10			# Set function number for terminate_execution
	syscall

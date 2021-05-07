.data
size_px:	.word 0
input:		.space 82
prompt1:	.asciiz	"Please provide width of narrowest bar (in pixels) >"
prompt2:	.asciiz "\nPlease provide the text to be encoded >"

out1:		.asciiz "Choosen size (in px) >"
out2:		.asciiz "Text to be encoded >"
out3:		.asciiz "Encoding text..."

err1:		.asciiz "Invalid size (less then or equal to zero)!"
err2:		.asciiz "Invalid input string! (empty string)"
err3:		.asciiz "Invalid input string! (contains a character that cannot be encoded)"

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

	# Inform about beginning of encoding process
	la 	$a0, out3	# Set address of 'out2' string to be displayed
	jal 	_print_str
	
	# Go to exit of program
	b 	exit


	
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

	
exit:
	# Terminate program
	li	$v0, 10			# Set function number for terminate_execution
	syscall

# =================================================================================== PROCEDURES

# Prints out a specified string
# Arguments: 	$a0: (address of a string to be printed)
# Returns:	void
_print_str:
	li 	$v0, 4		# System call for print_string
	syscall
	jr	$ra		# Jump back to PC to continue exec
	
	
# Prints out a specified integer
# Arguments: 	$a0: (integer to be printed)
# Returns:	void
_print_int:
	li	$v0, 1		# System call for print_integer
	syscall
	jr	$ra		# Jump back to PC to continue exec


# Reads a string from input
# Arguments: 	$a0: (address of a buffer in which read string will be saved) 
#		$a1: (maximum number of characters to be read) [int]
# Returns:	void
_read_str:
	li 	$v0, 8		# System call for read_string
	syscall
	jr	$ra		# Jump back to PC to continue exec
	
	
# Reads an int from input
# Arguments: 	none()
# Returns:	$v0 (read integer) [int]
_read_int:
	li 	$v0, 5		# System call for read_integer and store read integer at $v0
	syscall
	jr	$ra		# Jump back to PC to continue exec
	
	
# Checks if a string is empty
# Arguments: 	$a0: (address of a buffer in which the string is saved) 
# Returns:	$v0 (1 [true] if string is empty) [int] 
_is_empty:
	move	$t0, $a0	# Set address of first char of string to $t0
	lbu	$t1, ($t0)	# Copy first character to $t1 (first eight effective bits)
	bne 	$t1, '\n', __is_empty_false	# If first character is not equal to \n go to branch and return 0 (false)
	li 	$v0, 1		# Set return value to 1 (true)
	jr	$ra		# Jump back to PC to continue exec
__is_empty_false:
	li 	$v0, 0		# Set return value to 0 (false)
	jr	$ra		# Jump back to PC to continue exec
	

# Checks if a string contains any characters that cannot be encoded in Code39
# Accepted chars: 0-9, A-Z (uppercase), -, ., [whitespace], $, /, +, %
# Arguments: 	$a0: (address of a buffer in which the string is saved)
# Returns:	$v0 (1 [true] if string is incorrect) [int] 
_check_incorrect:
	move	$t0, $a0	# Set address of first char of string to $t0
	li 	$v0, 0		# Set default return value to 0 (false)
__check_incorrect_nextchar:
	lbu	$t1, ($t0)	# Copy first character to $t1 (first eight effective bits)
	bltu	$t1, ' ', __check_incorrect_fin		# Go to branch if read char is less then ' ' whitespace (probably some null terminating character)
	beq 	$t1, ' ', __check_incorrect_nochange	# If char is [whitespace] then continue loop
	bltu	$t1, '$', __check_incorrect_true	# Go to branch if read char is non-encodeable
	bleu 	$t1, '%', __check_incorrect_nochange	# If char is $ or % then continue loop
	bltu	$t1, '+', __check_incorrect_true	# Go to branch if read char is non-encodeable
	beq 	$t1, '+', __check_incorrect_nochange	# If char is [whitespace] then continue loop
	bltu	$t1, '-', __check_incorrect_true	# Go to branch if read char is non-encodeable
	bleu 	$t1, '9', __check_incorrect_nochange	# If char is - or . or / or 0-9 then continue loop
	bltu	$t1, 'A', __check_incorrect_true	# Go to branch if read char is non-encodeable
	bleu 	$t1, 'Z', __check_incorrect_nochange	# If char is A-Z then continue loop
	bgtu 	$t1, 'Z', __check_incorrect_true	# Go to branch if read char is non-encodeable
__check_incorrect_nochange:
	addiu	$t0, $t0, 1	# Move pointer by 1 (to next char)
	b	__check_incorrect_nextchar		# Goes to beginning of the loop
__check_incorrect_true:
	li 	$v0, 1		# Set return value to 1 (true)
__check_incorrect_fin:
	jr	$ra		# Jump back to PC to continue exec
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
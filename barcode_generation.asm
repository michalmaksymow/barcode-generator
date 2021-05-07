.data
size_px:	.word 0
input:		.space 82
prompt1:	.asciiz	"Please provide width of narrowest bar (in pixels) >"
prompt2:	.asciiz "\nPlease provide the text to be encoded >"

out1:		.asciiz "Choosen size (in px) >"
out2:		.asciiz "Text to be encoded >"
out3:		.asciiz "Encoding text..."

err1:		.asciiz "Invalid size (less then or equal to zero)!"

.text
main:
	# Display prompt about size
	la	$a0, prompt1
	jal 	_print_str
	
	# Read integer from input
	li 	$v0, 5		# System call for read_integer and store read integer at $v0
	syscall
	
	# If provided size is lesser or equal to zero, go to invalid_size branch
	blez $v0, invalid_size
	
	# Save read integer in memory
	sw	$v0, size_px	# Store contents of $v0 to 'size_px' variable
	
	# Output read integer to confirm to user
	la 	$a0, out1	# Set address of 'out1' string to be displayed
	jal 	_print_str
	lw	$a0, size_px	# Set value of word 'size_px' to be displayed
	li	$v0, 1		# System call for print_integer
	syscall

	# Display second prompt (about text input)
	la	$a0, prompt2	# Set string address for printing
	jal 	_print_str
	
	# Read string from input
	la 	$a0, input	# Set address of string buffer
	li	$a1, 80		# Set maximum number of characters
	jal	_read_str
	
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

	
	
# Inform about incorrect input and exit
invalid_size:
	la	$a0, err1	# Set string address for printing
	li 	$v0, 4		# System call for print_string
	syscall
	b	exit
	
exit:
	# Terminate program
	li	$v0, 10			# Set function number for terminate_execution
	syscall



# Prints out a specified string
# Arguments: 	$a0: (address of a string to be printed)
_print_str:
	li 	$v0, 4		# System call for print_string
	syscall
	jr	$ra		# Jump back to PC to continue exec

# Prints out a specified string
# Arguments: 	$a0: (address of a buffer in which read string will be saved) 
#		$a1: (maximum number of characters to be read) [int]
_read_str:
	li 	$v0, 8		# System call for read_string
	syscall
	jr	$ra		# Jump back to PC to continue exec
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
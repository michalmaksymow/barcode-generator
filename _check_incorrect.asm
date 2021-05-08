#	
# Checks if a string contains any characters that cannot be encoded in Code39
# Accepted chars: 0-9, A-Z (uppercase), -, ., [whitespace], $, /, +, %
#
# Arguments: 	$a0: (address of a buffer in which the string is saved)
#
# Returns:	$v0: (1 [true] if string is incorrect) [int] 
#
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

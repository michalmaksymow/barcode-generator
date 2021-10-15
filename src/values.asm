# This byte array stores Code39 encodable characters 
# in order that shows each character value.
# Ex. "$" character has value 39 in Code39, therefore
# it's offset is 39

values:		.byte 	'0' '1' '2' '3' '4' '5' '6' '7' '8' '9'
			'A' 'B' 'C' 'D' 'E' 'F' 'G' 'H' 'I' 'J'
			'K' 'L' 'M' 'N' 'O' 'P' 'Q' 'R' 'S' 'T'
			'U' 'V' 'W' 'X' 'Y' 'Z' '-' '.' ' ' '$'
			'/' '+' '%' '*'

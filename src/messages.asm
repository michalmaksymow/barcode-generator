# This file contains important elements of program's data section.
# It was moved to this file in order not to flood the main with text.

prompt1:	.asciiz	"Please provide width of narrowest bar (in pixels) >"
prompt2:	.asciiz "\nPlease provide the text to be encoded >"

out1:		.asciiz "Choosen size (in px) >"
out2:		.asciiz "Text to be encoded >"
out3:		.asciiz "Checksum >"
out4:		.asciiz "\nChecksymbol value >"
out5:		.asciiz "\nBarcode width [px] >"

err1:		.asciiz "Invalid size (less then or equal to zero)!"
err2:		.asciiz "Invalid input string! (empty string)"
err3:		.asciiz "Invalid input string! (contains a character that cannot be encoded)"
err4:		.asciiz "\nInvalid barcode width! (will not fit 600x50px)"
err5:		.asciiz "\nCannot read file 'prepared.bmp'!"
err6:		.asciiz "\nInvalid amount of chracters read!"
err7:		.asciiz "\nCannot open 'output.bmp' for write!"
err8:		.asciiz "\nInvalid amount of characters written!"

loadname:	.asciiz "util/prepared.bmp"
filename:	.asciiz "out/output.bmp"

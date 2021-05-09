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

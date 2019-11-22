							.text
							.global VGA_clear_charbuff_ASM
							.global VGA_clear_pixelbuff_ASM
							.global VGA_write_char_ASM
							.global VGA_write_byte_ASM
							.global VGA_draw_point_ASM
							// TODO: relevant memory locations for VGA


VGA_clear_charbuff_ASM:		// should set all the valid memory locations in the character buffer to 0
							// TODO

VGA_clear_pixelbuff_ASM:	// should set all the valid memory locations in the pixel buffer to 0
							// TODO

VGA_write_char_ASM:			// should store the value of the third input at the memory location calculated from the first two inputs
							// should check if first two inputs are valid
							// i.e., that 0 <= x <= 79 and 0 <= y <= 59
							// TODO

VGA_write_byte_ASM:			// should display two characters showing the hex representation of the third input
							// should check for valid inputs, taking into account that it needs to display two characters
							// TODO

VGA_draw_point_ASM:			// should work very similarly to VGA_write_char_ASM
							// TODO

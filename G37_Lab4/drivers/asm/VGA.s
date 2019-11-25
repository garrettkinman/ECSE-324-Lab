							.text
							
							.equ VGA_PIXEL_BUF_BASE, 0xC8000000	// base memory address for pixel buffer
							.equ VGA_CHAR_BUF_BASE, 0xC9000000	// base memory address for char buffer
							.equ X_offset_char, 0x00000001		// memory offset for x direction for char buffer
							.equ Y_offset_char, 0x00000080		// memory offset for y direction for char buffer
							.equ X_offset_pixel, 0x00000001		// memory offset for x direction for pixel buffer
							.equ Y_offset_pixel, 0x00000400		// memory offset for y direction for pixel buffer
							.equ pixel_end_X, 0x0000013F		// memory address associated with the "end" of x pixels
							.equ pixel_end_Y, 0xC803BE7E		// memory address associated with the "end" of y pixels

							.global VGA_clear_charbuff_ASM
							.global VGA_clear_pixelbuff_ASM
							.global VGA_write_char_ASM
							.global VGA_write_byte_ASM
							.global VGA_draw_point_ASM
							// TODO: relevant memory locations for VGA


VGA_clear_charbuff_ASM:		// should set all the valid memory locations in the character buffer to 0
							// TODO
							PUSH {R0-LR}					// push system state
							MOV R2, #0					// R2 is the x counter, initialized to 0
							MOV R3, #0					// R3 is the y counter, initialized to 0
							LDR R4, =VGA_CHAR_BUF_BASE	// R4 holds char buffer base address
							LDR R5, =X_offset_char		// R5 holds char x offset
							LDR R6, =Y_offset_char		// R6 holds char y offset
							MOV R0, #0					// R0 holds the value 0
							BL CHAR_LOOP_X				// branch to the nested loops
							POP {R0-LR}					// pop system state
							BX LR						// return

CHAR_LOOP_X:				CMP R2, #79					// check if reached end of row
							BXGT LR						// if so, branch back
							
														// else...
							MUL R7, R2, R5				// multiply the x offset by the x counter, hold in R7
							PUSH {LR}					// push system state
							BL CHAR_LOOP_Y:				// and go do stuff for all the y positions in this row
							POP {LR}					// pop system state
							
							ADD R2, R2, #1				// increment the x counter
							MOV R3, #0					// reset y counter to 0
							B CHAR_LOOP_X				// branch back to top of CHAR_LOOP_X

CHAR_LOOP_Y:				// TODO
							CMP R3, #59					// check if reached end of column
							BXGT LR						// if so, return to the rows

														// else...
							MUL R8, R3, R6				// multiply y offset by y counter, hold in R8
							ADD R9, R7, R8				// add x and y parts of the total offset, hold in R9
							ADD R10, R4, R9				// add the total offset to the base adddress, hold in R10

							
							

							// else, increase the y offset
							

VGA_clear_pixelbuff_ASM:	// should set all the valid memory locations in the pixel buffer to 0
							// TODO
							PUSH {R4-R12}				// push system state
							MOV R2, #0					// ?
							LDR R3, =VGA_PIXEL_BUF_BASE	// R3 holds pixel buffer base address
							MOV R0, #0

PIXEL_LOOP_X:				// TODO

PIXEL_LOOP_Y:				// TODO

VGA_write_char_ASM:			// should store the value of the third input at the memory location calculated from the first two inputs
							// should check if first two inputs are valid
							// i.e., that 0 <= x <= 79 and 0 <= y <= 59
							// TODO

VGA_write_byte_ASM:			// should display two characters showing the hex representation of the third input
							// should check for valid inputs, taking into account that it needs to display two characters
							// TODO

VGA_draw_point_ASM:			// should work very similarly to VGA_write_char_ASM
							// TODO

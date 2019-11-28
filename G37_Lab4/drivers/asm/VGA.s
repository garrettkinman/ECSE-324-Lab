							.text
							
							.equ VGA_PIXEL_BUF_BASE, 0xC8000000	// base memory address for pixel buffer
							.equ VGA_CHAR_BUF_BASE, 0xC9000000	// base memory address for char buffer
							.equ X_offset_char, 0x00000001		// memory offset for x direction for char buffer
							.equ Y_offset_char, 0x00000080		// memory offset for y direction for char buffer
							.equ X_offset_pixel, 0x00000001		// memory offset for x direction for pixel buffer
							.equ Y_offset_pixel, 0x00000400		// memory offset for y direction for pixel buffer

							.global VGA_clear_charbuff_ASM
							.global VGA_clear_pixelbuff_ASM
							.global VGA_write_char_ASM
							.global VGA_write_byte_ASM
							.global VGA_draw_point_ASM


VGA_clear_charbuff_ASM:		PUSH {LR}				// push system state
							MOV R0, #0					// R0 holds the value 0
							MOV R2, #0					// R2 is the x counter, initialized to 0
							MOV R3, #0					// R3 is the y counter, initialized to 0
							LDR R4, =VGA_CHAR_BUF_BASE	// R4 holds char buffer base address
							LDR R5, =X_offset_char		// R5 holds char x offset
							LDR R6, =Y_offset_char		// R6 holds char y offset
							BL BEGIN_CHAR_LOOP_X		// branch to the nested loops

							POP {LR}					// pop system state
							BX LR						// return

BEGIN_CHAR_LOOP_X:			PUSH {LR}					// push system state

CHAR_LOOP_X:				CMP R2, #79					// check if reached end of row
							POPGT {LR}					// if so, pop system state
							BXGT LR						// if so, branch back
							
														// else...
							MUL R7, R2, R5				// multiply the x offset by the x counter, hold in R7
							BL BEGIN_CHAR_LOOP_Y		// and go do stuff for all the y positions in this row
							
							ADD R2, R2, #1				// increment the x counter
							MOV R3, #0					// reset y counter to 0
							B CHAR_LOOP_X				// branch back to top of CHAR_LOOP_X

BEGIN_CHAR_LOOP_Y:			PUSH {LR}					// push system state

CHAR_LOOP_Y:				CMP R3, #59					// check if reached end of column
							POPGT {LR}					// if so, pop system state
							BXGT LR						// if so, return to the rows

														// else...
							MUL R8, R3, R6				// multiply y offset by y counter, hold in R8
							ADD R9, R7, R8				// add x and y parts of the total offset, hold in R9
							ADD R10, R4, R9				// add the total offset to the base adddress, hold in R10

							STRB R0, [R10]				// store 0 at the address for the current position in the char buff

							ADD R3, R3, #1				// increment the y counter
							B CHAR_LOOP_Y				// branch back to top of CHAR_LOOP_Y

VGA_clear_pixelbuff_ASM:	// should set all the valid memory locations in the pixel buffer to 0
							PUSH {LR}					// push system state
							MOV R0, #0					// R0 holds the value 0
							MOV R2, #0					// R2 is the x counter, initialized to 0
							MOV R3, #0					// R3 is the y counter, initialized to 0
							LDR R4, =VGA_PIXEL_BUF_BASE	// R4 holds pixel buffer base address
							LDR R5, =X_offset_pixel		// R5 holds char x offset
							LDR R6, =Y_offset_pixel		// R6 holds char y offset
							BL BEGIN_PIXEL_LOOP_X		// branch to the nested loops

							POP {LR}					// pop system state
							BX LR						// return

BEGIN_PIXEL_LOOP_X:			PUSH {LR}					// push system state

PIXEL_LOOP_X:				CMP R2, #329				// check if reached end of row
							POPGT {LR}					// if so, pop system state
							BXGT LR						// if so, branch back

														// else...
							MUL R7, R2, R5				// multiply the x offset by the x counter, hold in R7
							BL BEGIN_PIXEL_LOOP_Y		// and go do stuff for all the y positions in this row
							
							ADD R2, R2, #1				// increment the x counter
							MOV R3, #0					// reset y counter to 0
							B PIXEL_LOOP_X				// branch back to top of PIXEL_LOOP_X

BEGIN_PIXEL_LOOP_Y:			PUSH {LR}					// push system state

PIXEL_LOOP_Y:				CMP R3, #239				// check if reached end of column
							POPGT {LR}					// pop system state
							BXGT LR						// if so, return to the rows

														// else...
							MUL R8, R3, R6				// multiply y offset by y counter, hold in R8
							ADD R9, R7, R8				// add x and y parts of the total offset, hold in R9
							ADD R10, R4, R9				// add the total offset to the base adddress, hold in R10

							STRH R0, [R10]				// store 0 at the address for the current position in the char buff

							ADD R3, R3, #1				// increment the y counter
							B PIXEL_LOOP_Y				// branch back to top of PIXEL_LOOP_Y

VGA_write_char_ASM:			PUSH {LR}				// push system state
							CMP R0, #79					// check if x coord is valid (i.e., <=79)
							BGT DONE_WRITE_CHAR		// if not, done
							CMP R1, #59					// check if y coord is valid (i.e., <=59)
							BGT DONE_WRITE_CHAR			// if not, done

							LDR R3, =VGA_CHAR_BUF_BASE	// R3 holds char buffer base address
							ADD R3, R3, R0				// add the x offset
							//LSL R1, R1, #7
							ADD R3, R3, R1, LSL #7		// add the y offset
							STRB R2, [R3]				// write the char to the coord address

							B DONE_WRITE_CHAR			// done

DONE_WRITE_CHAR:			POP {R3-LR}					// pop system state
							BX LR						// return	

VGA_write_byte_ASM:			// should display two characters showing the hex representation of the third input
							// should check for valid inputs, taking into account that it needs to display two characters
							// TODO
							PUSH {R3-LR}				// push system state
							CMP R0, #78					// check if x coord is valid (i.e., <=78; not 79, because second char has to fit, too)
							BGT DONE_WRITE_BYTE			// if not, done
							CMP R1, #59					// check if y coord is valid (i.e., <=59)
							BGT DONE_WRITE_BYTE			// if not, done
	
							LDR R3, =VGA_CHAR_BUF_BASE	// R3 holds char buffer base address
							ADD R3, R3, R0				// add the x offset
							// LSL R1, R1, #7
							ADD R3, R3, R1, LSL #7		// add the y offset

							LSR R4, R2, #4				// get most significant hex in R4					
							LSL R6, R4, #4				// get least significant hex in R5
							SUB R5, R2, R6				// the least significant hex in R5
	
							CMP R4, #9
							ADDGT R4, R4, #7
							CMP R5, #9	
							ADDGT R5, R5, #7
							ADD R4, R4, #48
							ADD R5, R5, #48
	
							STRB R4, [R3]				// store the first character in the char buffer
							ADD R3, R3, #1				// next position in char buffer
							STRB R5, [R3]				// stor the second character in the char buffer

							B DONE_WRITE_BYTE			// done

DONE_WRITE_BYTE:			POP {R3-LR}					// pop system state
							BX LR						// return

VGA_draw_point_ASM:			LDR R3, =319
							CMP R0, #0
							BXLT LR
							CMP R1, #0
							BXLT LR
							CMP R0, R3
							BXGT LR
							CMP R1, #239
							BXGT LR
	
							LDR R3, =VGA_PIXEL_BUF_BASE
							ADD R3, R3, R0, LSL #1
							ADD R3, R3, R1, LSL #10
							STRH R2, [R3]
							BX LR

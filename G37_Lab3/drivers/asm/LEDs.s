					.text
					.equ LEDR_BASE, 0xFF200000
					.global read_LEDs_ASM
					.global write_LEDs_ASM

read_LEDs_ASM:		LDR R1, =LEDR_BASE				// R1 points to where LED info is kept
					LDR R0, [R1]					// R0 holds LED info
					BX LR							// return
					
write_LEDs_ASM:		LDR R1, =L_BASE					// R1 points to where LED info is kept
					STR R0, [R1]					// store value at R0 to where LED info is kept
					BX LR							// return
					.end
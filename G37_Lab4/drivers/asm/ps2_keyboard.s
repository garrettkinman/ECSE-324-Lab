					.text
					.global read_PS2_data_ASM

read_PS2_data_ASM:
					MOV R3, R0
					PUSH {R4-R12} //saves the state of the system
					LDR R1, =0xFF200100 //load the ps/2 data register address into R1
					LDRB R4, [R1]
					//LDRB R2, [R1,#1] //load RVALID into R2
		    
					MOV R5, #0x80
					AND R2, R4, R5
					CMP R2, #0 //check to see if RVALID is 1
					MOVEQ R0, #0 //if it is the subroutine returns 0
					POPEQ {R4-R12}
					BXEQ LR      //and branches back to the loop
					STRB R4, [R3] //otherwise, the data is read and placed at the address indicated by the pointer
					MOV R0, #1    //then the subroutine returns 1
					POP {R4-R12}
					BX LR
			.text
			.global _start

_start:		LDR R4, =RESULT		// R4 points to the result location
			
			// set up parameters
			LDR R1, [R4, #4]	// R1 holds the number of elements in the list
			ADD R0, R4, #8		// R0 points to the first number
			BL MIN				// call MIN subroutine

DONE:		B DONE				// infinite loop!

MIN:		PUSH {FP, LR}		// push program state to stack
			LDR R2, [R0]		// R2 holds the first number in the list, i.e., R2 = current_min
			B LOOP				// go to loop

LOOP:		SUBS R1, R1, #1		// decrement the loop counter
			BEQ END_MIN			// if counter is zero, exit loop
			ADD R0, R0, #4		// R0 points to next number in list
			LDR R3, [R0]		// R3 holds the next number in list
			CMP R2, R3			// compare current and next numbers in list
			BLE LOOP			// if next is not smaller than current_min, back to top of loop
			MOV R2, R3			// else, update current_min

END_MIN:	MOV R0, R2			// place current_min in R0 for the return
			POP {FP, LR}		// retrieve state from stack
			BX LR				// return

RESULT:		.word 0				// memory assigned for result location
N:			.word 3				// number of entries in the list
NUMBERS:	.word 1, 12, 5		// the list data
			.end

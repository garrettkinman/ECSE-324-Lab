			.text
			.global _start

_start:
			LDR R4, =RESULT		// R4 points to the result location
			LDR R2, [R4, #4]	// R2 holds the number of elements in the list
			ADD R3, R4, #8		// R3 points to the first number
			LDR R0, [R3]		// R0 holds the first number in the list, i.e., RO = current max
			LDR R5, [R3]		// R5 holds the first number in the list, i.e., R5 = current min
			
LOOP:		SUBS R2, R2, #1		// decrement the loop count
			BEQ DONE			// end loop if counter has reached 0
			ADD R3, R3, #4		// else, R3 points to next number in the list
			LDR R1, [R3]		// R1 holds the next number in the list

			CMP R0, R1			// check if current num is greater than current max
			BGE MIN				// if not, branch to check min
			MOV R0, R1			// else, update current max
			B LOOP				// if greater than current max, it won't be less than current min,
								// so branch back to top of loop
MIN:
			CMP R5, R1			// check current num is smaller than current min
			BLE LOOP			// if no, branch back to the loop
			MOV R5, R1			// if yes, update the current min

			B LOOP				// branch back to top of loop

DONE:		SUBS R0, R0, R5		// subtract min from max to find range
			STR R0, [R4]		// store the result to the memory location

END:		B END				// infinite loop!

RESULT:		.word	0			// memory assigned for result location
N: 			.word	7			// number of entries in the list			
NUMBERS:	.word	2, 9, 13, -100	// the list data
			.word	1, 8, 2

			.text
			.global _start

_start:		LDR R4, =RESULT			// R4 points to result location
			LDR R2, [R4, #4]		// R2 holds number of entries in the list
			ADD R3, R4, #8			// R3 points to the first number in the list

LOOP:		SUBS R2, R2, #1			// decrement the loop count
			BLT DONE				// end loop if counter has reached 0
			LDR R0, [R3]			// R0 holds the current number in the list
			ADD R3, R3, #4			// R3 points to next number in the list
			PUSH {R0}				// push current number in list to stack
			B LOOP					// branch back to top of loop

DONE:		POP {R1}				// pop into R1
			POP {R2}				// pop into R2
			POP {R3}				// pop into R3

END:		B END					// infinite loop!

RESULT:		.word 0					// memory assigned for result location
N:			.word 3					// number of entries in the list
NUMBERS:	.word 2, 3, 4			// the list data

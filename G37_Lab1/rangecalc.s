			.text
			.global _start

_start:
			LDR R4, =RESULT			// R4 points to the result location
			LDR R2, [R4, #4]		// R2 holds the number of elements in the list
			ADD R3, R4, #8			// R3 points to the first number
			LDR R0, [R3]			// R0 holds the first number in the list, RO = cur_MAX
			LDR R5, [R3]			// TODO comments

LOOP:		SUBS R2, R2, #1			// decrement the loop counter
			.text
			.global _start

_start:		LDR R4, =RESULT		// R4 points to the result location
			LDR R1, [R4, #4]	// R1 holds the number of elements in the list
			













RESULT:		.word 0				// memory assigned for result location
N:			.word 4				// number of entries in the list
NUMBERS:	.word 1, 12, 4, 5	// the list data
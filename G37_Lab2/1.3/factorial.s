				.text
				.global _start

_start:			LDR R4, =RESULT		// R4 points to result location
				LDR R1, [R4, #4]	// R1 holds number to take factorial of
				MOV R0, #1			// initialize the factorial
			
				BL FACTORIAL		// call factorial function
				STR R0, [R4]		// store factorial result to result location

END:			B END 				// infinite loop!			

FACTORIAL:		PUSH {FP, LR}		// push program state to stack 
			
				CMP R1, #2			// if less than 2, return
				BLT END_FACTORIAL	//if 1, then we return 1

				MUL R0, R1			// else, multiply
				SUB R1, R1, #1		// decrement number to factorialize
				BL FACTORIAL		// recursively call the function

END_FACTORIAL:	
				POP {FP, LR}		// pop state info
				BX LR				// branch back


RESULT:		.word	0			//memory assigned for result location
N:			.word	6			// number to take factorial of

		        .text
		        .global _start

_start:		  	LDR R0, =MAX		// R0 holds address of max 
		        LDR R1, =MIN		// R1 holds address of min
		        LDR R2, [R1, #4]	// R2 holds value of n
		        LDR R3, [R1, #8]	// R3 holds value of m
		        ADD R4, R1, #12		// R4 holds address of Num 1 (this is just an arbitrary name)
		        ADD R5, R1, #16 	// R5 holds address of Num 2 (this is just an arbitrary name)

		        ADD R6, R2, R3		// R6 holds counter, initializes to n + m
		        SUB R7, R7, R7		// initializes sum to 0

FINDSUM:		// this part calculates the sum of all the n + m numbers
				LDR R8, [R4]		// R8 holds value of Num 1
		        ADD R7, R7, R8		// add value of Num 1 to sum
		        ADD R4, R4, #4		// Num 1 points to next number
		        SUBS R6, R6, #1		// decrement counter by 1
		        BEQ REINITIALIZE	// if counter equals 0, exit loop
		        B FINDSUM			// else, continue

REINITIALIZE:	// this part resets initialization after finding sum
				// used for reiterating through numbers
				ADD R4, R1, #12		// R4 holds address of Num 1 (this is just an arbitrary name)
		        SUB R6, R6, R6		// reset R6 (i.e., the counter) to 0
		        ADD R6, R2, R3		// reset counter R6 to n + m
		        LDR R9, [R4]		// R9 holds value from Num 1

		        LDR R3, [R0]		// R3 holds value of max
		        LDR R4, [R1]		// R4 holds value of min

LOOP:			// this part loops through all the possible values of X * (S - X)
				SUBS R6, R6, #1		// decrement counter
		        BEQ DONE			// if counter equals 0, exit loop
		        LDR R10, [R5]		// R10 holds value of Num 2
		        ADD R5, R5, #4		// Num 2 points to next number
			
		        ADD R11, R9, R10 	// set Xsum to X1 + X2
		        SUB R12, R7, R11 	// set Ysum to S - Xsum
		        MUL R2, R11, R12	// Result is (Xsum * Ysum)
			
		        CMP R3, R2			// compare result and max
		        BLE UPDATEMAX		// if result is greater than max, update max
				CMP R4, R2			// else, compare result and min
				BGE UPDATEMIN		// if result is less than min, update min
				B LOOP				// branch back to top of loop

UPDATEMAX:		MOV R3, R2			// update max
				B LOOP				// branch back to loop

UPDATEMIN:		MOV R4, R2			// update min
		        B LOOP				// branch back to loop
			
DONE:		    STR R3, [R0]		// store max
		        STR R4, [R1]		// store min
		 
END:		    B END				// infinite loop!

MAX:		    .word	0			// memory assigned for max location (value of smallest 32 bit integer)
MIN:		    .word	2147483647	// memory assigned for min location (value of biggest 32 bit integer)
N: 		      	.word	2			
M:		      	.word	2			
NUMBERS:	  	.word	1, 2, 3, 4	// the list data

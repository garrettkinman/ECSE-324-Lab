		        .text
		        .global _start

_start:		  LDR R0, =MAX		// Address of Max 
		        LDR R1, =MIN		// Address of Min
		        LDR R2, [R1, #4]	// Value of n
		        LDR R3, [R1, #8]	// Value of m
		        ADD R4, R1, #12		// Address of num 1 (Pointer 1)
		        ADD R5, R1, #16 	// Address of num 2 (Pointer 2)

		        ADD R6, R2, R3		// Counter initialized to n + m
		        SUB R7, R7, R7		// Initialize sum to 0

FINDSUM:			 
		        LDR R8, [R4]		// Get value of Pointer 1
		        ADD R7, R7, R8		// Add value of pointer 1 to sum
		        ADD R4, R4, #4		// Updater Pointer 1 to point to next number
		        SUBS R6, R6, #1		// Decrement Counter by 1
		        BEQ RESET		// Exit loop
		        B FINDSUM

RESET:
		        ADD R4, R1, #12		// Address of num 1 (Pointer 1)
		        SUB R6, R6, R6		// Reset R6
		        ADD R6, R2, R3		// Counter is n+m
		        LDR R9, [R4]		// Get X1 value from pointer 1

		        LDR R3, [R0]		// Obtain Value of Max
		        LDR R4, [R1]		// Obtain Value of Min

LOOP:
		        SUBS R6, R6, #1		// Decrement counter
		        BEQ DONE		// Exit if counter = 0
		        LDR R10, [R5]		// Get X2 value from pointer 2
		        ADD R5, R5, #4		// Move pointer 2 forward to point to next number
			
		        // Computation
		        ADD R11, R9, R10 	// Init Xsum to X1 + X2
		        SUB R12, R7, R11 	// Init Ysum to Sum - Xsum
		        MUL R2, R11, R12	// Result is (Xsum * Ysum)
			
		        // Comparison
		        CMP R3, R2		// Compare Result & Max	
		        BLE UPDATEMAX		// If Result > Max, Update Max
		        B CHECKMIN		// Else Check Min

UPDATEMAX:	MOV R3, R2

CHECKMIN: 	CMP R4, R2		// Compare Result & Min
		        BGE UPDATEMIN		// If Result < min, Update Min
		        B LOOP			// Else Back to loop

UPDATEMIN:	MOV R4, R2
		        B LOOP			
			
DONE:		    STR R3, [R0]		// Store Max
		        STR R4, [R1]		// Store Min
		 
END:		    B END			// infinite loop!

MAX:		    .word	0		// memory assigned for max location (value of smallest 32 bit integer)
MIN:		    .word	2147483647	// memory assigned for min location (value of biggest 32 bit integer)
N: 		      .word	2			
M:		      .word	2			
NUMBERS:	  .word	3, 6, 5, 9	// the list data

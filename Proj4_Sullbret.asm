TITLE Program Template     (template.asm)

; Author: Brett Sullivan 
; Last Modified: 7-31-23
; OSU email address: Sullbret@oregonstate.edu
; Course number/section:   CS271 Section 400
; Project Number: 4                Due Date: 7-30-23
; Description: This program prompts the user for an amount of prime numbers to be shown. After prompt, program
; checks every number in a loop to see if it's prime. If it is, prime number is printed, ten on each line. 
; uses 4 procedures with 2 sub-procs to handle everything 

INCLUDE Irvine32.inc


LOWERBOUNDS = 1
UPPERBOUNDS = 200

.data

	intro		BYTE	"Welcome to the Prime Numbers Program, by Brett Sullivan",13,10,0
	goodbye		BYTE	"Thanks for stopping by, results certified by b_rabbit " ,13,10,0
	prompt1		BYTE	"Enter the amount of prime numbers you would like to see within [1,200] range: ",0
	error		BYTE	"That is not within 1-200 range, try again..." ,13,10,0
	extraC		BYTE	"EC: Output columns have been aligned" ,13,10,0
	check2		BYTE	" is prime is working! ",0
	remainder	BYTE	" remainder is: ",0
	amountP		DWORD	?
	divisor 	DWORD   ?
	primeN		DWORD   0
	currentN    DWORD   ?	;preserves EAX
	lineJump	DWORD   0	
	spaces		BYTE	"	",0
	


.code
main PROC

   CALL  introduction
   CALL  getData					;validate as a sub proc 
   CALL  showPrimes					;isPrime sub proc 
   CALL  farewell 

	Invoke ExitProcess,0			; exit to operating system
main ENDP

; -- introduction --
; Procedure to introduce the program.
; preconditions: rules1 and rules2 are strings that describe the program and rules.
; postconditions: EDX changed
; receives: ???
; returns: ???
introduction PROC

  MOV    EDX, OFFSET intro
  CALL   WriteString

  MOV    EDX, OFFSET extraC
  CALL   WriteString
  RET

introduction ENDP

; -- getData --
; Gets value from the user (amountP). must be within 1-200, checked with validate code.
; preconditions: prompt1 is string, a and b exist
; postconditions: EAX, EDX changed
; receives: none
; returns: user input values for global variable amountP
getData PROC
  MOV    EDX, OFFSET prompt1
  CALL   WriteString				;"Enter the amount of prime numbers you would like to see within [1,200] range: "
  CALL   ReadDec					; amount into EAX
  MOV    amountP, EAX				; value from user put into amountP
  CALL	 validate
  

  

  RET
getData ENDP

; -- validate, sub proc called only from getData proc --
; Procedure to validate user input is in range.
; preconditions: range has been given by user.
; postconditions: EDX changed if not in range 
; receives: ???
; returns: ???
validate PROC

  CMP	 amountP, LOWERBOUNDS
  JL	 _errorMessage
  CMP	 amountP, UPPERBOUNDS
  JG	 _errorMessage

  RET

_errorMessage:
  MOV    EDX, OFFSET error
  CALL   WriteString
  CALL	 getData 

validate ENDP


; -- showPrimes --
; Procedure to run loop, max based on user given value.Calls Sub Proc isPrime 
; preconditions: valid range has been given to run loop for primes.
; postconditions: EDX changed, loop updates registers EAX, ECX. 
; receives: ???
; returns: ???
showPrimes PROC

  MOV    ECX, amountP			;moves user input value into ECX for loop count 
  MOV	 EAX, 2					;starts at 2 

  _loopy:
  MOV	 currentN, EAX			;preserves EAX
  MOV    divisor, EAX

  CALL   isPrime				;calls subproc for each iteration of EAX to check for prime 
  CMP    primeN, 1
  JE     _printPrime
  MOV	 EAX, currentN			;moves current number back into EAX after subproc call 

  INC	 EAX
  CMP	 ECX, 0
  JG	 _loopy					
  
  _printPrime:					;label is jumped to if 1 is in prime1, then EAX is printed 
  MOV    EDX, OFFSET spaces
  CALL   WriteString
  MOV	 EAX, currentN
  CALL	 WriteDec
  INC	 EAX
  INC	 lineJump				;iterates lineJump variable for each prime
  CMP    lineJump,10			;once 10 primes are printed jumps to newline Label, prints new line and resets variable
  JE     _newLine
  LOOP	 _loopy
   
  JMP	 _finish2				;Once loop is done calls finish label to return from Proc 

  _newLine:						;creates a new line for every 10 numbers
  CALL	 CrLf
  MOV    lineJump, 0
  LOOP	 _loopy

  _finish2:

  RET

showPrimes ENDP


; -- isPrime, showPrimes Sub Proc --
; Procedure to check each value for primes, .
; preconditions: valid range has been given to run loop for primes, loop started in showPrimes proc.
; postconditions: EDX changed, primeN updated
; receives: ???
; returns: ???
isPrime PROC	

_checkRem:

  MOV	 EAX, currentN
  DEC	 divisor				;decrements EBX by 1 
  CMP    divisor,1
  JZ	 _primeConfirmed		;if divisor is 0, prime is confirmed and jumps
  MOV    EBX, divisor

  XOR    EDX, EDX				;clears EDX
  DIV	 EBX

  CMP	 EDX, 0					;updated, compares remainder to 0, if 0 we know it is not prime and jumps out of sub proc
  JE     _notPrime	
  JMP    _checkRem
  

  _primeConfirmed:				;moves 1 into prime once confirmed 
  MOV	primeN, 1
  JMP   _finish 	

  _notPrime:
  MOV	primeN, 0
  JMP   _finish 	

  _finish:
  RET
isPrime ENDP





; -- farewell --
; Procedure to end the program.
; preconditions: valid range has been given to run loop for primes, previous Procs have all been called.
; postconditions: EDX changed
; receives: ???
; returns: ???
farewell PROC
  CALL	 CrLf
  MOV    EDX, OFFSET goodbye
  CALL   WriteString
  RET

farewell ENDP

END main

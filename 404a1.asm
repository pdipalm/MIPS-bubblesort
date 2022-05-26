.globl main

.data
LEN: .word 9
col: .word 7, 9, 4, 3, 8, 1, 6, 2, 5
prompt1: .asciiz "Enter 0 to sort in descending order.\nAny number different than zero will sort in ascending order.\n"
prompt2: .asciiz "Before Sort:\n"
prompt3: .asciiz "\n\nAfter Sort:\n"
prompt4: .asciiz "\n"

.text
	main:	la $s0, col	 					#s0 stores ptr to array start
			la $s1, col	 					#s1 will move from array start
			li $t0, 1	 					#t0 stores bubble counter
			lw $t3, LEN	 					#load length into t3
			addi $t5, $t3, -1				#len-1
			
			
			li $v0, 4        				#system call code for print_str
			la $a0, prompt1  				#address of string to print
			syscall          				#print the string
			li $v0, 5	 					#system call for scan int
			syscall		 					#scan int
			move $t1, $v0	 				#scanned int moved to t1
			li $v0, 4        				#system call code for print_str
			la $a0, prompt2  				#address of string to print
			syscall          				#print the string
        	
			jal printd						#jump and link print data
			j loop							#jump over reset
			
    reset:	la $s1, 0($s0)					#return to index 0 and go right back to loop
      		beq $t0, $zero, endloop
      		li $t0, 0
      		li $t4, 0	 					#array counter										       
											#if no bubbles, closeloop
	loop:	beq $t4, $t5, reset				#if len is reached, reset indexes
       		lw $t8, 0($s1)					#load element 1
       		lw $t9, 4($s1)					#load element 2
       		beqz $t1, asc					#t1's value was inputted by the user
    dsc:	bgt $t8, $t9, swap				#if t8>t9, swap
       		j cleanup
	asc:	blt $t8, $t9, swap				#if t8<t9, swap
       		j cleanup
    swap:	sw $t8 4($s1)					#swap positons of t8 and t9 (pointed to by s1)
       		sw $t9 0($s1)
       		addi $t0, $t0, 1				#increment swap counter
 cleanup:	addi $t4, $t4, 1				#t4+=1
    		addi $s1, $s1, 4				#s1+=4, going to next word in array
    		j loop
  
 endloop:	la $s1, 0($s0)					#reset array pointer
			li $v0, 4        				#system call code for print_str
        	la $a0, prompt3  				#address of string to print
        	syscall							
        	jal printd						#printd is used form many spots
     		li $v0, 4        				#system call code for print_str
        	la $a0, prompt4  				#address of string to print
        	syscall	
			li $v0, 10						
    		syscall
        	
  printd: 	li $s2 , 0		        		#sentinal for loop
			loopPD: bge $s2, $t3, exitPD	#goto exit if s2>=t3
        	lw $t2, 0($s1) 		            #load address
        	
        	li      $v0, 1      			#print int
    		move    $a0, $t2				#a0, int to print
    		syscall
    		
    		li      $a0, 32					#print char ' '
    		li      $v0, 11  
    		syscall
    		
    		addi $s1, $s1, 4				#increment array ptr
    		addi $s2, $s2, 1				#add 1 to sentinel
    		
    		j loopPD						#loop again
    		
	exitPD:	la $s1, col						#reset s1 to array start (we can do this becuase printd is not called inside the main loop of the program)
    		jr $ra							#jump return (either to print before or after sort)
    		
        	
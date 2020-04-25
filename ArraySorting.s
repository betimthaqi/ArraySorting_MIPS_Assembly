.text

.globl main

	
main:
    jal popullovektorin
	
	jal unazaKalimit

	# komanda per me pefundu programin
	li $v0, 10
	syscall


popullovektorin:
	# mesazhi per me marr nr e anetareve ne vektor, n
	li $v0, 4
	la $a0, Msg1
	syscall
	
	# ketu jam duke e marr n
	li $v0, 5
	syscall
	move $t7, $v0
	
	# mesazhi i dyte per me i shtyp anetaret nje nga nje
	li $v0, 4
	la $a0, Msg2
	syscall
	
	la $a1, Array($t1)

	while1:
	# nese t3 = t7 exit
	beq $t3, $t7, exit1 
	# tash me i marr antaret e vektorit
	li $v0,5    
    syscall
    sw $v0, Array($t1)
	# rritet per 4 bit se osht counteri i arrayt 
	addi $t1, $t1, 4
	# rritet per 1, indexi
	addi $t3, $t3, 1
	
	j while1
	
	exit1:	
	# mesazhi me tregu qe unaza ka perfundu
	li $v0, 4
	la $a0, Msg3
	syscall
	
	# e kom qit array ne t0
	la $t0, Array

	jr $ra
	

unazaKalimit:
	# krijohet hapsira ne stack pointer
    addi $sp,$sp,-4
	sw $ra,0($sp)
	
    jal unazaVlerave
	li $t2, 0 
	
	print:
    beq $t2, $t7, exit      
    # marrja elementit prej array
	lw $a0, 0($t0)   
	# printimi integerit
    li $v0, 1
	syscall
	# printimi i hapsires mes antareve
    li $v0, 4
	la $a0, Space
	syscall
	# rritja indexit per 4 bit
    addiu $t0, $t0, 4       
	# rritja per 1, e i-se	
    addiu $t2, $t2, 1 
	
    j print
	
	exit:
	# printimi i newLine 
    li $v0, 4
	la $a0, newLine
	syscall
	
	# merret prej stack vendoset ne return adres
	lw $ra,0($sp)
	add $sp,$sp,4
	
	jr $ra

unazaVlerave:     
	# shift left logical, njejt si me shumzu me 4
    sll $t7, $t7, 2
    # indexi i = 0
	li $v0, 0              	 
	
	loop:
	# if (i < n) => $t3 = 1
    slt $t3, $v0, $t1 
    beq $t3, $zero, end   
    # if (i == 0)
	bne $v0, $zero, krahasimi  
    addiu $v0, $v0, 4          
	
	krahasimi:
	# $s2 = &array[i]
    addu $t2, $t0, $v0  
    # $t4 = array[i-1]
	lw $t4, -4($t2)         
	# $t5 = array[i]
	lw $t5, 0($t2)          
    # ndrro nese (array[i] < array[i-1])
	blt $t5, $t4, ndrrimi   
    # i = i + 1
	addiu $v0, $v0, 4          
    j loop
	
	ndrrimi:
	# ndrrimi vlerave array[i] me array[i-1]
    sw $t4, 0($t2)         
    sw $t5, -4($t2)
	# i--
    addiu $v0, $v0, -4         
    j loop
	
	end:
	srl $t7, $t7, 2
	         
	jr $ra	
	

.data
	Msg1: .asciiz "Shenoni numrin e anetareve te vektorit (max 5.) "
	Msg2: .asciiz "Shtyp antaret nje nga nje\n"
	Msg3: .asciiz "Unaza per vektor perfundon, keta jan anetaret: "
	Array: .space 20
	Space: .asciiz " "
	newLine: .asciiz "\n"
	

######################################################################
## Fichero: Vectores.asm
## Descripción: Programa que...
## Fecha última modificación: 

## Autores: 
## Asignatura: E.C. 1º grado
## Grupo de Prácticas:
## Grupo de Teoría:
## Práctica: 3
## Ejercicio: 3
######################################################################

.text


main:		
	#Lee la variable N
	lw $a0, N
	
	#Adaptación de N
	addi $a0, $a0, 18
	
	#Inicializa el bucle for
	addi $t0, $0, 0
	
	#Comprobación del bucle
for: 	beq $a0, $t0, done	
	
	#Lectura de A(i)
	lw $a1, A($t0)
	
	#Lectura de B(i)
	lw $a2, B($t0)
	
	#"Multiplicación" por 4 de B(i)
	add $a2, $a2, $a2
	add $a2, $a2, $a2
	# sll $a2, $a2, 2 
	
	#Suma 
	add $a3, $a2, $a1
	
	#Escritura en C(i)
	sw $a3, C($t0)
	
	#Operación del bucle
	addi $t0, $t0, 4
	
	#Salto a la comparación
	j for
	
	#Bucle infinito
done:	j done	



.data # Comienzo de seccion de memoria de datos
A: 2,4,6,8,10,12
B: -1,-5,4,10,1,-5
C: .space 24 #.space reserva el espacio determinado en bytes.
N: .word 6
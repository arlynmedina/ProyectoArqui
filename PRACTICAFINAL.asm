.eqv discos 3
.data
    start: #debemos tener en memoria donde empieza el stack 0X1001000
.text
# Función principal
main:
	#inicializacion
    addi s0,zero,discos #numero de discos, es decir, n
    add a7,a7,s0 #registro donde guardamos n y nunca lo movemos
    lui s1, %hi(start) #guardamos los primeros 3 de la direccion
    addi s1,s1 %lo(start) #en s1 tenemos la direccion de memoria de la torre inicial
      
    slli s5 s0 2 #en s5 multiplicamos N * 4    
     
    add s2 s1 s5 #en s2 guardamos la direccion de memoria de la segunda torre auxiliar    
    add s3 s2 s5 #en s3 guardamos la direccion de memoria de la tercera torre destino

    #rellenamos nuestra torre
    addi t2,s0,0 #indice que tiene el mismo valor de n para nuestro for para llenar la torre origen
    
fill:     
	addi s1 s1 4 #Se agrega un nuevo espacio a la memoria     
	sw t2 -4(s1) #Se escribe el disco uno antes de donde se agrego el espacio de memoria     
	addi t2 t2 -1 #Se le resta uno al numero del disco     
	blt zero t2 fill #Se vuelve a llamar la funcion en caso de que t0 siga siendo mayor a 0
	
    #acomodamos nuestro apuntador de la torre 1 ya que debe de apuntar a la base
    slli s5 a7 2 #guardamos la cantidad de lugares que vamos a bajar el pointer, n*4 niveles a bajar
    sub s1,s1,s5 #restamos al pointer de la torre 1 con lo que acabamos de calcular
    
    # Llamada a la función torresDeHanoi
    jal torresDeHanoi

    # Llamada a la función exit
    jal exit

# Función recursiva para las Torres de Hanoi
torresDeHanoi:
    #caso base
    addi t1,zero,1  # 1
    beq s0, t1, fin    # Si n == 1, salir de la función, de lo contrario continuamos
    
	#push al stack de ra,n,origen,auxiliar,destino
    addi sp, sp, -20 #movemos el puntero 5 posiciones
    sw ra,0(sp) #ra
    sw s0,4(sp) #n
    sw s1,8(sp) #origen
    sw s2,12(sp) #auxiliar
    sw s3,16(sp) #destino

    # Modificacion de argumentos
        
    #primero hacemos el swap de torres
    #queremos swapear nuestra torre auxiliar(s2) con la destino (s3)
    add t3,s2,x0 #guardamos torre auxiliar en un temporal
    add s2,s3,x0 # s2=s3
    add s3,t3,x0 # s3=t(s2)
    
    #Decrementamos la n
    addi s0,s0,-1 #n-1
    
    #nuestra primera llamada recursiva
    jal torresDeHanoi
    
    #pop
    lw ra,0(sp) #ra
    lw s0,4(sp) #n
    lw s1,8(sp) #origen
    lw s2,12(sp) #auxiliar
    lw s3,16(sp) #destino
    addi sp, sp, 20 #regresamos el puntero 5 posiciones
    
    #movimiento de discos
    
    #calculamos ambos offsets de los discos para moverlos
    #LA FORMULA PARA CALCULAR LOS OFFSETS ES: torre + 4*(a7-s0)
    
    #OFFSET DE NUESTRA TORRE 1 (S1)
    sub t2,a7,s0 #a7-s0=1
    slli a2,t2,2 #guardamos en a2 el resultado de 4*(a7-s0)
    add a3,s1,a2 #guardamos en a3 el resultado final de s1 + 4*(a7-s0)
    
    #OFFSET DE NUESTRA TORRE 3 (S3)
    sub t4,a7,s0 #a7-s0
    slli t5,t4,2 #guardamos el resultado de 4*(a7-s0)
    add t6,s3,t5 #guardamos el resultado final de s3 + 4*(a7-s0)
    
    #movemos los discos con sus respectivos offsets (de s1 a s3)
    lw a4,0(a3) #sacamos el disco de la torre 1 con su respectivo offset y lo guardamos en a4
    sw x0,0(a3) #escribimos 0 en la posicion del disco que recien sacamos para leer
    sw a4,0(t6) #guardamos el valor de a4 en nuestra torre 3 con su respectivo offset
    
    #segundo push al stack de ra,n,origen,auxiliar,destino
    addi sp, sp, -20 #movemos el puntero 5 posiciones
    sw ra,0(sp) #ra
    sw s0,4(sp) #n
    sw s1,8(sp) #origen
    sw s2,12(sp) #auxiliar
    sw s3,16(sp) #destino

    # segunda Modificacion de argumentos
    #primero hacemos el swap de torres
    #queremos swapear la torre origen(s1) con la auxiliar(s2)
    add t3,s1,x0 #guardamos torre s1(origen) en un temporal, entonces temporal tiene el valor de s1
    add s1,s2,x0 # s1=s2
    add s2,t3,x0 # s2=t
    
    #Decrementamos la n
    addi s0,s0,-1 #n-1
    
    #nuestra segunda llamada recursiva
    jal torresDeHanoi
    
    #pop
    lw ra,0(sp) #ra
    lw s0,4(sp) #n
    lw s1,8(sp) #origen
    lw s2,12(sp) #auxiliar
    lw s3,16(sp) #destino
    addi sp, sp, 20 #regresamos el puntero 5 posiciones
    
    jalr ra
    
fin:
    #calculamos el offset del caso base (siempre del 1)
    #OFFSET DE NUESTRA TORRE 1 (S1)
    sub t2,a7,s0 #a7-s0=1
    slli a2,t2,2 #guardamos en a2 el resultado de 4*(a7-s0)
    add a3,s1,a2 #guardamos en a3 el resultado final de s1 + 4*(a7-s0)
    
    #OFFSET DE NUESTRA TORRE 3 (S3)
    sub t4,a7,s0 #a7-s0
    slli t5,t4,2 #guardamos el resultado de 4*(a7-s0)
    add t6,s3,t5 #guardamos el resultado final de s3 + 4*(a7-s0)
    
    #movemos los discos con sus respectivos offsets (de s1 a s3)
    lw a4,0(a3) #sacamos el disco de la torre 1 con su respectivo offset y lo guardamos en a4
    sw x0,0(a3) #escribimos 0 en la posicion del disco que recien sacamos para leer
    sw a4,0(t6) #guardamos el valor de a4 en nuestra torre 3 con su respectivo offset
    jalr ra
    
# Función exit
exit:
    add x0,x0,x0 #nop
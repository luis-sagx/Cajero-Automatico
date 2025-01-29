org 100h
lea dx, mensajeIngreso
mov ah, 09h
int 21h  
call ingresarNumero
    
call calcularNumero
    
call saltoLinea        
lea dx, mensaje
mov ah, 09h
int 21h
call mostrarNumero
ret

num1 dw 0
mill db 0
centenas db 0
decenas db 0
unidades db 0 
mensajeIngreso db 'Ingrese un numero de 4 cifras: $'       
mensaje db 'El numero es: $'

ingresarNumero PROC
    call leerDigito
    mov mill, al
    
    call leerDigito
    mov centenas, al
    
    call leerDigito
    mov decenas, al
    
    call leerDigito
    mov unidades, al
    
    ret
ingresarNumero ENDP
          
leerDigito PROC
    mov ah, 1
    int 21h
    sub al, 48    
    ret
leerDigito ENDP

calcularNumero PROC
    ; Calcular millares
    xor ax, ax
    mov al, mill
    mov bx, 1000
    mul bx        ; ax = mill * 1000
    mov bx, ax    ; guardar resultado en bx
    
    ; Agregar centenas
    xor ax, ax
    mov al, centenas
    mov cx, 100
    mul cx        ; ax = centenas * 100
    add bx, ax    ; bx += (centenas * 100)
    
    ; Agregar decenas
    xor ax, ax
    mov al, decenas
    mov cl, 10
    mul cl        ; ax = decenas * 10
    add bx, ax    ; bx += (decenas * 10)
    
    ; Agregar unidades
    xor ax, ax
    mov al, unidades
    add bx, ax    ; bx += unidades
    
    mov num1, bx  ; guardar resultado final
    ret
calcularNumero ENDP
           
mostrarNumero PROC
    mov ax, num1  ; cargar número completo
    
    ; Mostrar millar
    mov dx, 0     ; Limpiar dx para división
    mov bx, 1000
    div bx        ; dx:ax / 1000
    push dx       ; Guardar resto
    mov dl, al    ; Mover cociente a dl
    call mostrarDigito
    
    ; Mostrar centena
    pop ax        ; Recuperar resto
    mov dx, 0     ; Limpiar dx para división
    mov bx, 100
    div bx        ; ax / 100
    push dx       ; Guardar resto
    mov dl, al    ; Mover cociente a dl
    call mostrarDigito
    
    ; Mostrar decena
    pop ax        ; Recuperar resto
    mov dx, 0     ; Limpiar dx para división
    mov bx, 10
    div bx        ; ax / 10
    push dx       ; Guardar resto
    mov dl, al    ; Mover cociente a dl
    call mostrarDigito
    
    ; Mostrar unidad
    pop dx        ; Recuperar último resto
    call mostrarDigito
    
    ret
mostrarNumero ENDP
       
mostrarDigito PROC
    add dl, 48
    mov ah, 2
    int 21h
    ret
mostrarDigito ENDP
          
saltoLinea PROC 
    mov dl, 10
    mov ah, 2
    int 21h
    
    mov dl, 13
    mov ah, 2
    int 21h
    ret
saltoLinea ENDP
org 100h

inicio:
    mov ah, 09h
    lea dx, mensaje
    int 21h

menu:
    mov ah, 09h
    lea dx, opciones
    int 21h
    
    mov ah, 01h
    int 21h
    sub al, '0'
    mov bl, al
    
    cmp bl, 1
    je consultar_saldo
    cmp bl, 2
    je deposito
    cmp bl, 3
    je retiro
    cmp bl, 4
    je salir
    jmp menu

consultar_saldo:
    call mostrar_saldo
    jmp menu

deposito:
    call realizar_deposito
    jmp menu

retiro:
    call realizar_retiro
    jmp menu

salir:
    mov ah, 4ch
    int 21h

mostrar_saldo proc
    call saltolinea
    mov ah, 09h
    lea dx, msg_saldo_actual
    int 21h
    call mostrarnumero
    call saltolinea
    ret
mostrar_saldo endp

; procedimiento principal para realizar depósito
realizar_deposito proc
    call saltolinea
    mov ah, 09h
    lea dx, mensajeingreso
    int 21h
    
    call ingresarnumero
    call calcularnumero
    
    mov ax, monto
    add saldo, ax
    
    call saltolinea
    mov ah, 09h
    lea dx, msg_deposito_exitoso
    int 21h
    
    call saltolinea
    call mostrar_saldo
    ret
realizar_deposito endp

realizar_retiro proc
    mov ah, 09h
    lea dx, msg_retiro
    int 21h
    ret
realizar_retiro endp

ingresarnumero proc
    call leerdigito
    mov mill, al
    
    call leerdigito
    mov centenas, al
    
    call leerdigito
    mov decenas, al
    
    call leerdigito
    mov unidades, al
    
    ret
ingresarnumero endp
          
leerdigito proc
    mov ah, 1
    int 21h
    sub al, 48    
    ret
leerdigito endp

; calcula el número final a partir de los dígitos ingresados
calcularnumero proc
    xor ax, ax
    mov al, mill
    mov bx, 1000
    mul bx
    mov bx, ax
    
    xor ax, ax
    mov al, centenas
    mov cx, 100
    mul cx
    add bx, ax
    
    xor ax, ax
    mov al, decenas
    mov cl, 10
    mul cl
    add bx, ax
    
    xor ax, ax
    mov al, unidades
    add bx, ax
    
    mov monto, bx
    ret
calcularnumero endp
           
mostrarnumero proc
    mov ax, saldo
    
    mov dx, 0
    mov bx, 1000
    div bx
    push dx
    mov dl, al
    call mostrardigito
    
    pop ax
    mov dx, 0
    mov bx, 100
    div bx
    push dx
    mov dl, al
    call mostrardigito
    
    pop ax
    mov dx, 0
    mov bx, 10
    div bx
    push dx
    mov dl, al
    call mostrardigito
    
    pop dx
    call mostrardigito
    
    ret
mostrarnumero endp
       
mostrardigito proc
    add dl, 48
    mov ah, 2
    int 21h
    ret
mostrardigito endp
          
saltolinea proc 
    mov dl, 10
    mov ah, 2
    int 21h
    
    mov dl, 13
    mov ah, 2
    int 21h
    ret
saltolinea endp

mensaje db 'bienvenido al cajero automatico', 10, 13, '$'
opciones db '1. consultar saldo', 10, 13, '2. deposito', 10, 13, '3. retiro', 10, 13, '4. salir', 10, 13, 'seleccione una opcion: $'
msg_saldo db 'opcion consultar saldo seleccionada.$'
msg_deposito db 'opcion deposito seleccionada.$'
msg_retiro db 'opcion retiro seleccionada.$'
msg_saldo_actual db 'su saldo actual es: $'
msg_deposito_exitoso db 'deposito realizado exitosamente!$'

monto dw 0
saldo dw 5000
mill db 0
centenas db 0
decenas db 0
unidades db 0 
mensajeingreso db 'ingrese el monto a depositar (4 cifras): $'
mensaje_numero db 'el numero es: $'

end inicio
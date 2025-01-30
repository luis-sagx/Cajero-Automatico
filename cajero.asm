org 100h

main proc
    ; Inicializar el programa
    mov ah, 09h
    lea dx, mensaje
    int 21h
    call menu_principal
    ret
main endp

menu_principal proc
    mov ah, 09h
    lea dx, opciones
    int 21h
    
    mov ah, 01h
    int 21h
    sub al, '0'
    mov bl, al
    
    cmp bl, 1
    je opcion_consultar
    cmp bl, 2
    je opcion_deposito
    cmp bl, 3
    je opcion_retiro
    cmp bl, 4
    je opcion_salir
    jmp menu_principal
    ret
menu_principal endp

opcion_consultar proc
    call mostrar_saldo
    jmp menu_principal
    ret
opcion_consultar endp

opcion_deposito proc
    call realizar_deposito
    jmp menu_principal
    ret
opcion_deposito endp

opcion_retiro proc
    call mostrar_menu_retiro
    jmp menu_principal
    ret
opcion_retiro endp

mostrar_menu_retiro proc
    call saltoLinea
    mov ah, 09h
    lea dx, menu_retiro
    int 21h
    
    mov ah, 01h
    int 21h
    sub al, '0'
    
    cmp al, 1
    je retiro_10
    cmp al, 2
    je retiro_20
    cmp al, 3
    je retiro_50
    cmp al, 4
    je retiro_100
    cmp al, 5
    je retiro_personalizado
    ret

retiro_10:
    mov monto, 10
    jmp hacer_retiro
retiro_20:
    mov monto, 20
    jmp hacer_retiro
retiro_50:
    mov monto, 50
    jmp hacer_retiro
retiro_100:
    mov monto, 100
    jmp hacer_retiro
retiro_personalizado:
    call saltolinea
    mov ah, 09h
    lea dx, msg_ingreso_monto
    int 21h
    call ingresarnumero
    call calcularnumero
hacer_retiro:
    call realizar_retiro
    ret
mostrar_menu_retiro endp

opcion_salir proc
    mov ah, 4ch
    int 21h
    ret
opcion_salir endp

mostrar_saldo proc
    call saltolinea
    mov ah, 09h
    lea dx, msg_saldo_actual
    int 21h
    call mostrarnumero
    call saltolinea
    ret
mostrar_saldo endp

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
    call saltoLinea
    mov ah, 09h
    lea dx, msg_retiro
    int 21h  
             
    call saltoLinea
    mov ax, saldo
    cmp ax, monto
    jl saldo_insuficiente
    sub ax, monto
    mov saldo, ax
    lea dx, mensajeExito
    mov ah, 09h
    int 21h
    call mostrar_saldo 
    call saltoLinea
    jmp fin_retiro
    
saldo_insuficiente:
    lea dx, mensajeError
    mov ah, 09h
    int 21h  
    call saltoLinea
    
fin_retiro:
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

; Variables y mensajes
mensaje db 'bienvenido al cajero automatico', 10, 13, '$'
opciones db '1. consultar saldo', 10, 13, '2. deposito', 10, 13, '3. retiro', 10, 13, '4. salir', 10, 13, 'seleccione una opcion: $'
menu_retiro db '1. Retirar 10 dolares', 10, 13, '2. Retirar 20 dolares', 10, 13, '3. Retirar 50 dolares', 10, 13, '4. Retirar 100 dolares', 10, 13, '5. Otro monto', 10, 13, 'Seleccione una opcion: $'
msg_saldo db 'opcion consultar saldo seleccionada.$'
msg_deposito db 'opcion deposito seleccionada.$'
msg_retiro db 'opcion retiro seleccionada.$'
msg_saldo_actual db 'su saldo actual es: $'
msg_deposito_exitoso db 'deposito realizado exitosamente!$'
mensajeExito db 'Retiro exitoso. Nuevo saldo: $'
mensajeError db 'Saldo insuficiente.$'
mensajeFinal db 'Operacion finalizada.$'
msg_ingreso_monto db 'Ingrese el monto a retirar (4 cifras): $'
monto dw 0
saldo dw 5000
mill db 0
centenas db 0
decenas db 0
unidades db 0 
mensajeingreso db 'ingrese el monto a depositar (4 cifras): $'
mensaje_numero db 'el numero es: $'

end main
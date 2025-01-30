org 100h

call bienvenida
call menu_principal
ret

bienvenida PROC
    mov ah, 09h
    lea dx, msg1
    int 21h
    mov ah, 09h
    lea dx, msg2
    int 21h
    mov ah, 09h
    lea dx, msg3
    int 21h
    mov ah, 09h
    lea dx, msg4
    int 21h 
    ret
bienvenida ENDP

menu_principal PROC
    mov ah, 09h
    lea dx, opciones
    int 21h
    
    mov ah, 01h
    int 21h
    sub al, 48
    mov bl, al
    
    cmp bl, 1
    je opcion_consultar
    cmp bl, 2
    je opcion_deposito
    cmp bl, 3
    je opcion_retiro
    cmp bl, 4
    ret
    jmp menu_principal
    ret
menu_principal ENDP

opcion_consultar PROC
    call mostrar_saldo
    jmp menu_principal
    ret
opcion_consultar ENDP

opcion_deposito PROC
    call realizar_deposito
    jmp menu_principal
    ret
opcion_deposito ENDP

opcion_retiro PROC
    call mostrar_menu_retiro
    jmp menu_principal
    ret
opcion_retiro ENDP

mostrar_menu_retiro PROC
    call saltoLinea
    mov ah, 09h
    lea dx, menu_retiro
    int 21h
    
    mov ah, 01h
    int 21h
    sub al, 48
    
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
mostrar_menu_retiro ENDP

mostrar_saldo PROC
    call saltolinea
    mov ah, 09h
    lea dx, msg_saldo_actual
    int 21h
    call mostrarnumero
    call saltolinea
    ret
mostrar_saldo ENDP

realizar_deposito PROC
    call saltolinea
    mov ah, 09h
    lea dx, mensajeingreso
    int 21h
    
    call ingresarnumero
    call calcularnumero
    
    mov bx, saldo
    
    mov ax, saldo
    add ax, monto
    
    cmp ax, 9999
    jg deposito_muy_alto
       
    mov saldo, ax
    
    call saltolinea
    mov ah, 09h
    lea dx, msg_deposito_exitoso
    int 21h
    jmp fin_deposito
    
deposito_muy_alto:
   
    mov saldo, bx
    
    call saltolinea
    mov ah, 09h
    lea dx, msg_deposito_invalido 
    int 21h
    
fin_deposito:
    call saltolinea
    call mostrar_saldo
    ret
realizar_deposito ENDP

realizar_retiro PROC  
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
realizar_retiro ENDP

ingresarnumero PROC
    mov mill, 0
    mov centenas, 0
    mov decenas, 0
    mov unidades, 0
    
    mov ah, 1
    int 21h
    
    cmp al, 13    ;Enter
    je fin_ingreso
    
    sub al, 48
    mov unidades, al
    
    mov ah, 1
    int 21h
    cmp al, 13
    je mover_digitos_1
    
    sub al, 48
    mov bl, unidades
    mov decenas, bl
    mov unidades, al
    
    mov ah, 1
    int 21h
    cmp al, 13
    je mover_digitos_2
    
    sub al, 48
    mov bl, decenas
    mov centenas, bl
    mov bl, unidades
    mov decenas, bl
    mov unidades, al
    
    mov ah, 1
    int 21h
    cmp al, 13
    je mover_digitos_3
    
    sub al, 48
    mov bl, centenas
    mov mill, bl
    mov bl, decenas
    mov centenas, bl
    mov bl, unidades
    mov decenas, bl
    mov unidades, al
    
    jmp fin_ingreso
    
mover_digitos_1:; Un solo digito ingresado
    ret
    
mover_digitos_2:; Dos digitos ingresados
    ret
    
mover_digitos_3:; Tres digitos ingresados
    ret
    
fin_ingreso:
    ret
ingresarnumero ENDP
          
leerdigito PROC
    mov ah, 1
    int 21h
    sub al, 48    
    ret
leerdigito ENDP

calcularnumero PROC
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
calcularnumero ENDP
           
mostrarnumero PROC
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
mostrarnumero ENDP
       
mostrardigito PROC
    add dl, 48
    mov ah, 2
    int 21h
    ret
mostrardigito ENDP
          
saltolinea PROC 
    mov dl, 10
    mov ah, 2
    int 21h
    
    mov dl, 13
    mov ah, 2
    int 21h
    ret
saltolinea ENDP

msg1 db '+----------------------------------+', 10, 13, '$'
msg2 db '|       Bienvenido al Cajero       |', 10, 13, '$'
msg3 db '|           Automatico             |', 10, 13, '$'
msg4 db '+----------------------------------+', 10, 13, '$'

monto dw ?
saldo dw 4000
mill db ?
centenas db ?
decenas db ?
unidades db ? 

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
msg_ingreso_monto db 'Ingrese el monto a retirar: $'
mensajeingreso db 'ingrese el monto a depositar: $'
msg_deposito_invalido db 'El deposito no puede realizarse. El monto resultante seria muy elevado.$'
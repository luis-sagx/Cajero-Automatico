ORG 100h

INICIO:
    MOV AH, 09h   ; Mostrar mensaje de bienvenida
    LEA DX, MENSAJE
    INT 21h

MENU:
    MOV AH, 09h   ; Mostrar men�
    LEA DX, OPCIONES
    INT 21h
    
    MOV AH, 01h   ; Leer opci�n del usuario
    INT 21h
    SUB AL, '0'   ; Convertir de ASCII a n�mero
    MOV BL, AL    ; Guardar opci�n en BL
    
    CMP BL, 1     ; Comparar con opci�n 1 (Consultar Saldo)
    JE CONSULTAR_SALDO
    CMP BL, 2     ; Comparar con opci�n 2 (Dep�sito)
    JE DEPOSITO
    CMP BL, 3     ; Comparar con opci�n 3 (Retiro)
    JE RETIRO
    CMP BL, 4     ; Comparar con opci�n 4 (Salir)
    JE SALIR
    JMP MENU      ; Si no es una opci�n v�lida, volver al men�

CONSULTAR_SALDO:
    CALL MOSTRAR_SALDO
    JMP MENU

DEPOSITO:
    CALL REALIZAR_DEPOSITO
    JMP MENU

RETIRO:
    CALL REALIZAR_RETIRO
    JMP MENU

SALIR:
    MOV AH, 4Ch   ; Salir del programa
    INT 21h

; Procedimientos vac�os para cada opci�n
MOSTRAR_SALDO PROC
    MOV AH, 09h
    LEA DX, MSG_SALDO
    INT 21h
    RET
MOSTRAR_SALDO ENDP

REALIZAR_DEPOSITO PROC
    MOV AH, 09h
    LEA DX, MSG_DEPOSITO
    INT 21h
    RET
REALIZAR_DEPOSITO ENDP

REALIZAR_RETIRO PROC
    MOV AH, 09h
    LEA DX, MSG_RETIRO
    INT 21h
    RET
REALIZAR_RETIRO ENDP

; Mensajes
MENSAJE DB 'Bienvenido al cajero automatico', 10, 13, '$'
OPCIONES DB '1. Consultar Saldo', 10, 13, '2. Deposito', 10, 13, '3. Retiro', 10, 13, '4. Salir', 10, 13, 'Seleccione una opcion: $'
MSG_SALDO DB 'Opcion Consultar Saldo seleccionada.$'
MSG_DEPOSITO DB 'Opcion Deposito seleccionada.$'
MSG_RETIRO DB 'Opcion Retiro seleccionada.$'

END INICIO

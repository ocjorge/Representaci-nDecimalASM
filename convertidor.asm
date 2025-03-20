; Programa para convertir de binario a hexadecimal
; Para compilar: nasm -f elf32 convertidor.asm -o convertidor.o
; Para enlazar: ld -m elf_i386 convertidor.o -o convertidor

section .data
    mensaje1 db 'Ingrese un numero binario: ', 0
    len_mensaje1 equ $ - mensaje1
    mensaje2 db 10, 'El numero hexadecimal es: ', 0
    len_mensaje2 equ $ - mensaje2
    nueva_linea db 10, 0

section .bss
    binario resb 33    ; Espacio para almacenar el número binario (hasta 32 bits + null)
    buffer resb 1      ; Buffer temporal para lectura de caracteres

section .text
    global _start

_start:
    ; Mostrar mensaje de entrada
    mov eax, 4          ; syscall write
    mov ebx, 1          ; stdout
    mov ecx, mensaje1   ; mensaje
    mov edx, len_mensaje1 ; longitud
    int 80h

    ; Leer número binario
    xor esi, esi        ; Inicializar índice en 0
leer_binario:
    ; Leer un carácter
    mov eax, 3          ; syscall read
    mov ebx, 0          ; stdin
    mov ecx, buffer     ; buffer para almacenar el carácter
    mov edx, 1          ; leer 1 byte
    int 80h
    
    ; Verificar si se leyó algún carácter
    test eax, eax
    jz fin_lectura
    
    ; Obtener el carácter leído
    mov al, [buffer]
    
    ; Verificar si es Enter (fin de entrada)
    cmp al, 10
    je fin_lectura
    
    ; Verificar si es '0' o '1'
    cmp al, '0'
    jb leer_binario     ; Ignorar si es menor que '0'
    cmp al, '1'
    ja leer_binario     ; Ignorar si es mayor que '1'
    
    ; Almacenar en el arreglo
    mov [binario + esi], al
    inc esi
    
    ; Asegurarse de no exceder el búfer
    cmp esi, 32
    jl leer_binario
    
fin_lectura:
    ; Añadir terminador nulo
    mov byte [binario + esi], 0
    
    ; Imprimir mensaje de resultado
    mov eax, 4
    mov ebx, 1
    mov ecx, mensaje2
    mov edx, len_mensaje2
    int 80h
    
    ; Convertir e imprimir
    call convertir_a_hex
    
    ; Imprimir nueva línea
    mov eax, 4
    mov ebx, 1
    mov ecx, nueva_linea
    mov edx, 1
    int 80h
    
    ; Salir
    mov eax, 1
    xor ebx, ebx
    int 80h

; Subrutina para convertir binario a hexadecimal
convertir_a_hex:
    xor esi, esi        ; Índice para recorrer la cadena binaria
    xor ebx, ebx        ; Contador de bits procesados
    xor ecx, ecx        ; Valor acumulado para el dígito hexadecimal
    
procesar_digitos:
    ; Verificar si hemos llegado al final de la cadena
    cmp byte [binario + esi], 0
    je imprimir_ultimo_digito
    
    ; Convertir ASCII a valor binario
    movzx eax, byte [binario + esi]
    sub al, '0'
    
    ; Agregar bit al acumulador
    shl ecx, 1
    or ecx, eax
    
    ; Incrementar contador de bits
    inc ebx
    
    ; Verificar si tenemos 4 bits (un dígito hexadecimal)
    cmp ebx, 4
    je imprimir_digito_hex
    
    ; Avanzar al siguiente bit
    inc esi
    jmp procesar_digitos
    
imprimir_digito_hex:
    ; Guardar registros importantes
    push esi
    
    ; Preparar para imprimir el dígito hex
    mov al, cl
    call imprimir_hex_digito
    
    ; Restaurar registros
    pop esi
    
    ; Reiniciar contador y acumulador
    xor ebx, ebx
    xor ecx, ecx
    
    ; Avanzar al siguiente bit
    inc esi
    jmp procesar_digitos
    
imprimir_ultimo_digito:
    ; Verificar si hay bits pendientes
    test ebx, ebx
    jz fin_conversion
    
    ; Imprimir los bits restantes como dígito hex
    mov al, cl
    call imprimir_hex_digito
    
fin_conversion:
    ret

; Subrutina para imprimir un dígito hexadecimal (en AL)
imprimir_hex_digito:
    ; Convertir valor a carácter ASCII
    cmp al, 10
    jb digito_decimal
    
    ; Es una letra (A-F)
    add al, 'A' - 10
    jmp imprimir_caracter
    
digito_decimal:
    ; Es un número (0-9)
    add al, '0'
    
imprimir_caracter:
    ; Guardar el carácter en el buffer
    mov [buffer], al
    
    ; Imprimir el carácter
    push eax
    push ebx
    push ecx
    push edx
    
    mov eax, 4          ; syscall write
    mov ebx, 1          ; stdout
    mov ecx, buffer     ; carácter a imprimir
    mov edx, 1          ; 1 byte
    int 80h
    
    pop edx
    pop ecx
    pop ebx
    pop eax
    
    ret
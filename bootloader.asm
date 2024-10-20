org 0x7c00      ; Establecer origen en 0x7C00

bits 16         ; Modo real de 16 bits

start:
    jmp main     ; Saltar al código principal

; Sección de datos
hello_msg db "Bienvenido al bootloader de ASIR", 0
prompt_msg db "Escribe un caracter: ", 0
echo_msg db "has escrito el caracter...: ", 0
newline db 0x0D, 0x0A, 0  ; Terminador nulo de CR LF (retorno de carro y salto de línea)
char db 0x00, 0            ; Almacenamiento del carácter

main:
    ; Configurar el segmento de datos para que coincida con el segmento de código
    push cs
    pop ds

    ; Imprimir un mensaje de bienvenida
    mov si, hello_msg
    call print_string

    ; Mover el cursor a la siguiente línea
    mov si, newline
    call print_string

input_loop:
    ; Imprimir un mensaje de solicitud
    mov si, prompt_msg
    call print_string

    ; Leer un carácter del teclado
    call read_char

    ; Mover el cursor a la siguiente línea
    mov si, newline
    call print_string

    ; Imprimir el carácter que se ingresó
    mov si, echo_msg
    call print_string

    ; Cargar el carácter de nuevo en AL y imprimirlo
    mov al, [char]
    call print_char

    ; Mover el cursor a la siguiente línea
    mov si, newline
    call print_string

    ; Volver al mensaje de solicitud
    jmp input_loop

; Imprimir una cadena terminada en nulo
print_string:
    lodsb              ; Cargar el siguiente carácter en AL
    or al, al          ; Comprobar si es terminador nulo
    jz end_print_string ; Si es nulo, fin de la cadena
    call print_char    ; Imprimir el carácter en AL
    jmp print_string   ; Repetir para el siguiente carácter
end_print_string:
    ret

; Imprimir un carácter en AL
print_char:
    mov ah, 0x0E       ; Función teletipo del BIOS
    int 0x10           ; Llamar a la interrupción del BIOS
    ret

; Leer un carácter del teclado y almacenarlo
read_char:
    mov ah, 0x01       ; Comprobar si hay una tecla presionada (no bloqueante)
    int 0x16
    jz read_char       ; Si no hay tecla presionada, volver a intentar
    mov [char], al     ; Almacenar el carácter
    ret

; Rellenar el bootloader hasta 510 bytes
times 510-($-$$) db 0
dw 0xAA55             ; Firma de arranque en los bytes 511-512

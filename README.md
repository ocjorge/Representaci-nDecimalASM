# Conversor de Binario a Hexadecimal

## Descripción
Este programa en lenguaje ensamblador permite convertir números en formato binario a su representación hexadecimal equivalente. El programa acepta entradas binarias de hasta 32 bits, las procesa en grupos de 4 bits (un dígito hexadecimal) y muestra el resultado en formato hexadecimal.

## Características
- Interfaz sencilla basada en consola
- Validación de entrada (solo acepta 0s y 1s)
- Capacidad para manejar números binarios de hasta 32 bits
- Salida en formato hexadecimal estándar

## Requisitos
- NASM (Netwide Assembler) o MASM (Microsoft Macro Assembler), dependiendo de la versión
- Sistema operativo compatible con x86 (para la versión NASM) o DOS/Windows (para la versión MASM)
- Enlazador LD para la versión NASM o LINK para la versión MASM

## Instalación

### Para la versión NASM (Linux/Unix)
1. Instala NASM si no está instalado:
   ```
   sudo apt-get install nasm   # Para distribuciones basadas en Debian/Ubuntu
   ```

2. Compila el programa:
   ```
   nasm -f elf32 convertidor.asm -o convertidor.o
   ```

3. Enlaza el objeto compilado:
   ```
   ld -m elf_i386 convertidor.o -o convertidor
   ```

4. Ejecuta el programa:
   ```
   ./convertidor
   ```

### Para la versión MASM (DOS/Windows)
1. Asegúrate de tener MASM instalado o utiliza DOSBox con MASM configurado.

2. Compila el programa:
   ```
   ml convertidor.asm
   ```
   
   O si estás usando versiones antiguas:
   ```
   masm convertidor.asm;
   link convertidor.obj;
   ```

3. Ejecuta el programa:
   ```
   convertidor.exe
   ```

## Uso
1. Ejecuta el programa.
2. Cuando veas el mensaje "Ingrese un numero binario:", introduce un número binario (solo 0s y 1s).
3. Presiona Enter para confirmar.
4. El programa mostrará el mensaje "El numero hexadecimal es:" seguido del número hexadecimal equivalente.

## Limitaciones
- El programa acepta números binarios de hasta 32 bits.
- Números mayores a 32 bits serán truncados.
- No maneja notación de complemento a dos ni números negativos explícitamente.

## Ejemplo de uso
```
Ingrese un numero binario: 1010
El numero hexadecimal es: A

Ingrese un numero binario: 11111111
El numero hexadecimal es: FF

Ingrese un numero binario: 1010101010101010
El numero hexadecimal es: AAAA
```

## Estructura del código
- **section .data**: Contiene las variables y mensajes del programa.
- **section .bss**: Reserva espacio para la entrada binaria y buffers temporales.
- **section .text**: Contiene el código ejecutable del programa.
  - **_start**: Punto de entrada del programa.
  - **convertir_a_hex**: Subrutina para convertir binario a hexadecimal.
  - **imprimir_hex_digito**: Subrutina para imprimir un dígito hexadecimal.

## Notas técnicas
- El proceso de conversión agrupa los bits de entrada en conjuntos de 4 bits.
- Cada grupo de 4 bits se convierte a un dígito hexadecimal (0-9, A-F).
- Si el número de bits no es múltiplo de 4, se completan los bits faltantes con ceros.

## Licencia
Este software es de dominio público y puede ser utilizado, modificado y distribuido libremente.

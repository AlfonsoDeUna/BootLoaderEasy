# Easy Boot Loader
ejemplo para mis clasees de un Boot Loader para Linux. El objetivo es entender como arrancan los sistemas operativos

Para probar el bootloader:

**Compilación:**
Utiliza NASM para ensamblar el código:

```bash
nasm -f bin -o bootloader.bin tu_bootloader.asm
```

**Ejecución:**
Ejecuta el bootloader en un emulador como QEMU:

```bash
qemu-system-x86_64 -drive format=raw,file=bootloader.bin
```

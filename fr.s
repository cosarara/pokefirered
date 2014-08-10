
.text
.globl _start

_start:
b 0x08000204

header:
.incbin "FR.ro.gba",4,0x200

real_start:
mov	r0, #18

end:
// here is automatically added an incbin for the rest of the ROM


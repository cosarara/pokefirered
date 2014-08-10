
.text
.globl _start

_start:
b 0x08000204

header:
.incbin "FR.ro.gba",4,0x200

real_start:
mov	r0, #0x12
msr	CPSR_fc, r0 // No idea what this means
ldr	sp, [pc, #40]	// 0x23c
mov	r0, #31
msr	CPSR_fc, r0
ldr	sp, [pc, #24]	// 0x238
ldr	r1, [pc, #28]	// 0x240
add	r0, pc, #32
str	r0, [r1]
ldr	r1, [pc, #20]	// 0x244
mov	lr, pc
bx	r1 // And we go to 080003a4
.incbin "FR.ro.gba",0x234,0x170

.align 2
.thumb
push {r4-r7,lr}
mov r7, r8
push {r7}

//end:
// here is automatically added an incbin for the rest of the ROM


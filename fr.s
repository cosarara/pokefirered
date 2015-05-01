
// t_ means the function is thumb (pretty much always I see)
// All this will be split in smaller files once we know what each thing is

.text
.globl _start
.arm

_start:
b 0x08000204

header:
.incbin "FR.ro.gba",4,0x200

real_start: // 204
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
tmain:
//080003a4
push {r4-r7,lr}
mov r7, r8
push {r7}
movs	r0, #255	// 0xff
bl	t_swi_1 // 0x081e3b80
movs	r1, #160	// 0xa0
lsl	r1, r1, #19
ldr	r2, [pc, #160]	// [$08000458] (=$00007fff)
add	r0, r2, #0
strh	r0, [r1, #0] // r1 is 05000000
bl	t_968
// Game Pack waitstate control
ldr	r1, [pc, #156]	// [$0800045c] (=$04000204)
ldr	r2, [pc, #156]	// [$08000460] (=$00004014)
add	r0, r2, #0
strh	r0, [r1, #0]
bl	t_5c0
bl	0x8000688
bl	0x81dd034
bl	0x8000598
bl	0x80f86c4
bl	0x804bfe4
bl	t_4c4
bl	0x8071938
bl	0x8000bfc
bl	0x8001028
ldr	r0, [pc, #116]	// [$08000464] (=$02000000)
movs	r1, #224	// 0xe0
lsl	r1, r1, #9
bl	0x8002b80
bl	0x80f79c8
ldr	r0, [pc, #104]	// [$08000468] (=$03003530)
movs	r4, #0
strb	r4, [r0, #0]
ldr	r0, [pc, #104]	// [$0800046c] (=$03005ecc)
strb	r4, [r0, #0]
bl	0x80f50f4
bl	0x81e37a8
ldr	r0, [pc, #96]	// [$08000470] (=$030030e4)
strb	r4, [r0, #0]
ldr	r7, [pc, #96]	// [$08000474] (=$030030f0)
movs	r1, #0
mov	r8, r1
add	r6, r0, #0

// Until here it was all setup

tmain_reentry: // Main loop? - 41a
bl	t_check_input
ldr	r0, [pc, #72]	// [$08000468] (=$03003530)

ldrb	r0, [r0, #0]
cmp	r0, #0

// Changing this to a b doesn't seem to do anything?
bne	tmain_label1

// 426
ldrh	r1, [r7, #40]	// 0x28
movs	r0, #1
and	r0, r1
cmp	r0, #0
beq	tmain_label1

// We come here every time we press A - 430
movs	r0, #14
and	r0, r1
cmp	r0, #14
bne	tmain_label1

// We never pass through here, it seems - 438
bl	0x81e09d4
bl	0x81e08f8
bl	0x80008d8

tmain_label1: // 444
bl	t_582e0 // Doesn't seem essential
cmp	r0, #1
bne	t_478 // exit 1 - used like all the time

// Is this really needed? Game works with b up here ^
strb	r0, [r6, #0]
bl	t_4b0
movs	r0, #0
strb	r0, [r6, #0]
b	t_49e // exit 2 - only used once, later 49e is called
	          // from somewhere else
// 08000458

.word 0x00007fff
.word 0x04000204
.word 0x00004014
.word 0x02000000
.word 0x03003530
.word 0x03005ecc
.word 0x030030e4
.word 0x030030f0

t_478:
ldr	r5, [pc, #48]	// (0x4ac) 0x030030e4
movs	r0, #0
strb	r0, [r5, #0]
bl	t_4b0 // White screen withou this; important
// We can actually b tmain_reentry here (+nop) - game too fast though
//b tmain_reentry
bl	0x8058274 // Game seems to do fine without this
add	r4, r0, #0
cmp	r4, #1
bne	t_49e // We could actually call tmain_reentry here (game too fast tho)
movs	r0, #0
strh	r0, [r7, #46]	// 0x2e
bl	0x8007350 // Game seems to do fine without this
strb	r4, [r5, #0]
bl	t_4b0 // Game seems to do fine without this here
mov	r2, r8
strb	r2, [r5, #0]

t_49e:
bl	0x805486c // Dunno what is breaking without this - seems to run fine
bl	0x807194c // Likewise
bl	0x8000890 // Game runs too fast or too slow at different moments
	          // if this is commented - nice find!
//nop
//nop
b	tmain_reentry

.word 0x030030e4

t_4b0:
push	{lr}
bl	0x800b178 // Game doesn't break without this
lsl	r0, r0, #24
cmp	r0, #0
bne	t_4b0_earylyret // Blank screen if it's made a b
bl	t_510 // This one is needed - blank screen else
t_4b0_earylyret: // 0x80004c0
pop	{r0}
bx	r0

// 080004c4
t_4c4:
push	{r4, lr}
ldr	r0, [pc, #44]	// [$080004f4] (=$030030f0)
movs	r4, #0
str	r4, [r0, #32]
str	r4, [r0, #36]	// 0x24
str	r4, [r0, #0]
ldr	r0, [pc, #36]	// [$080004f8] (=$080ec821) // set state to copyright message
bl	t_544
// 4d6
ldr	r0, [pc, #36]	// [$080004fc] (=$0300500c)
ldr	r1, [pc, #36]	// [$08000500] (=$02024588)
str	r1, [r0, #0]
ldr	r2, [pc, #36]	// [$08000504] (=$03005008)
ldr	r0, [pc, #40]	// [$08000508] (=$0202552c)
str	r0, [r2, #0]
movs	r0, #242	// 0xf2
lsl	r0, r0, #4
add	r1, r1, r0
str	r4, [r1, #0]
ldr	r0, [pc, #32]	// [$0800050c] (=$03005e88)
strb	r4, [r0, #0]
pop	{r4}
pop	{r0}
bx	r0

.incbin "FR.ro.gba",0x4f4,0x1c

// Gamemodes:
// 080ec820 - Copyright

t_510:
// Change gamestate
	push	{r4, lr}
	bl	0x80f5118 // Not essential
	cmp	r0, #0
	bne	t_510_earlyret
	bl	0x813b870 // Not essential
	lsl	r0, r0, #24
	cmp	r0, #0
	bne	t_510_earlyret
	ldr	r4, [pc, #24]	// [$08000540] (=$030030f0)
	ldr	r0, [r4, #0] // Callback which is always 0 ;P
	cmp	r0, #0
	beq	t_510_jumpover // Essential
	bl	0x81e3ba8 // Not essential - bx r0
t_510_jumpover: // 0x530
	ldr	r0, [r4, #4] // 030030f4 (gamestate register)
	cmp	r0, #0
	beq	t_510_earlyret
	bl	0x81e3ba8 // Essential - just bx r0 (080ec820 thumb in the tested case)
t_510_earlyret: // 0x53a
	pop	{r4}
	pop	{r0}
	bx	r0

.word 0x030030f0

// 544
t_544:
ldr	r1, [pc, #12]	// [$08000554] (=$030030f0)
str	r0, [r1, #4] // <-- here we set the gamestate
movs	r0, #135	// 0x87
lsl	r0, r0, #3
add	r1, r1, r0
movs	r0, #0
strb	r0, [r1, #0]
bx	lr

// 08000554

.incbin "FR.ro.gba",0x554,0x44

// 08000598

t_598:
push	{lr}
movs	r0, #4
bl	0x8000ac4
movs	r1, #255	// 0xff
and	r1, r0 // Why???
movs	r2, #150	// 0x96
lsl	r2, r2, #8
add	r0, r2, #0
orr	r1, r0
movs	r0, #32
orr	r1, r0
movs	r0, #4
bl	0x8000a38
movs	r0, #4
bl	0x8000b68
pop	{r0}
bx	r0

// 080005c0
t_5c0:
/*
0300352c = 5
030030e0 = 0x28
(030030f0 + 2c,2e,30,28,2a) = 0
*/
ldr	r1, [pc, #24]	// [$080005dc] (=$0300352c)
movs	r0, #5
strh	r0, [r1, #0]
ldr	r1, [pc, #24]	// [$080005e0] (=$030030e0)
movs	r0, #40	// 0x28
strh	r0, [r1, #0]
ldr	r1, [pc, #20]	// [$080005e4] (=$030030f0)
movs	r0, #0
strh	r0, [r1, #44]	// 0x2c
strh	r0, [r1, #46]	// 0x2e
strh	r0, [r1, #48]	// 0x30
strh	r0, [r1, #40]	// 0x28
strh	r0, [r1, #42]	// 0x2a
bx	lr

.incbin "FR.ro.gba",0x5dc,0xc

// 5e8
t_check_input:
push	{lr}
// Key input register
ldr	r0, [pc, #56]	// [$08000624] (=$04000130)
ldrh	r1, [r0, #0]
// last 6 bits not used, XOR with 0x3ff (AND would be ok as well, but 0 means pressed)
ldr	r2, [pc, #56]	// [$08000628] (=$000003ff)
add	r0, r2, #0
add	r3, r0, #0
eor	r3, r1

ldr	r1, [pc, #52]	// [$0800062c] (=$030030f0)
ldrh	r2, [r1, #40]	// 0x28
add	r0, r3, #0
bic	r0, r2 // bit clear - rN = rN && ~rM
strh	r0, [r1, #42]	// 0x2a
strh	r0, [r1, #46]	// 0x2e
strh	r0, [r1, #48]	// 0x30
add	r2, r1, #0
cmp	r3, #0
beq	0x8000634
ldrh	r0, [r2, #44]	// 0x2c
cmp	r0, r3
bne	0x8000634
ldrh	r0, [r2, #50]	// 0x32
sub	r0, #1
strh	r0, [r2, #50]	// 0x32
lsl	r0, r0, #16
cmp	r0, #0
bne	0x800063a
strh	r3, [r2, #48]	// 0x30
ldr	r0, [pc, #16]	// (0x630)
b	0x8000636
.hword 0000
.word 0x04000130
.word 0x000003ff
.word 0x030030f0

.incbin "FR.ro.gba",0x630,0x58

t_688:
/* Copies 13 (14?) bytes from 081e9f28 to 03003540
Also, sets up a DMA transfer:
040000d4 = 08000248 - DMA 3 src
040000d8 = 03003580 - DMA 3 dst
040000dc = 84000200 - DMA 3 Word Count
03007ffc = 03003580
04000208 = 1 - Interrupt master enable
*/
push	{r4, r5, lr}
ldr	r5, [pc, #72]	// [$080006d4] (=$08000248)
ldr	r4, [pc, #72]	// [$080006d8] (=$03003580)
ldr	r3, [pc, #76]	// [$080006dc] (=$081e9f28)
ldr	r2, [pc, #76]	// [$080006e0] (=$03003540)

movs	r1, #13
t_688_loop:
	ldmia	r3!, {r0} // Writes [r3] at 0 and adds 4 to r3
	stmia	r2!, {r0}
	sub	r1, #1
	cmp	r1, #0
	bge	t_688_loop
// 69e
ldr	r0, [pc, #68]	// [$080006e4] (=$040000d4)
str	r5, [r0, #0]
str	r4, [r0, #4]
ldr	r1, [pc, #64]	// [$080006e8] (=$84000200)
str	r1, [r0, #8]
ldr	r0, [r0, #8]
ldr	r0, [pc, #64]	// [$080006ec] (=$03007ffc)
str	r4, [r0, #0]
movs	r0, #0
bl	r0_in_30fc // writes r0 to 030030fc
movs	r0, #0 // Not needed
bl	t_700 // writes r0 to 03003100
movs	r0, #0 // Not needed
bl	0x8000718 // writes r0 to 03003108
ldr	r1, [pc, #44]	// [$080006f0] (=$04000208)
movs	r0, #1
strh	r0, [r1, #0]
movs	r0, #1 // Not needed
bl	0x8000b68
pop	{r4, r5}
pop	{r0}
bx	r0

.incbin "FR.ro.gba",0x6d2,0x22

// 80006f4
r0_in_30fc:
// Stores r0 in 030030fc
ldr	r1, [pc, #4]	// [$080006fc] (=$030030f0)
str	r0, [r1, #0xc]
bx	lr
.hword 0000
.word 0x030030f0

t_700:
ldr	r1, [pc, #4]	// (0x708)
str	r0, [r1, #0x10]
bx	lr
.hword 0000
.word 0x030030f0

t_70c:
ldr	r1, [pc, #4]	// (0x714)
str	r0, [r1, #0x14]
bx	lr
.hword 0000
.word 0x030030f0

t_718:
ldr	r1, [pc, #4]	// (0x720)
str	r0, [r1, #0x18]
bx	lr
.hword 0000
.word 0x030030f0

t_724:
push	{r4, r5, lr}
ldr	r0, [pc, #12]	// (0x734)
ldrb	r0, [r0, #0]
cmp	r0, #0
beq	0x8000738
bl	0x80fba38
b	0x8000744

.word 0x03003f3c

.incbin "FR.ro.gba",0x738,0x230

// 08000968
t_968:
/* This functions zeroes 03000000-03000095,
   030000c0-030000c2, and ORs 03000060-+95 with FF
   */
push	{r4, r5, r6, r7, lr}
mov	r7, r8
push	{r7}
movs	r2, #0
ldr	r7, [pc, #56]	// [$080009ac] (=$030000c0)
ldr	r0, [pc, #60]	// [$080009b0] (=$030000c1)
mov	r12, r0
ldr	r1, [pc, #60]	// [$080009b4] (=$030000c2)
mov	r8, r1
ldr	r6, [pc, #60]	// [$080009b8] (=$03000000)
movs	r5, #0
ldr	r4, [pc, #60]	// [$080009bc] (=$03000060)
movs	r3, #255	// 0xff

// r2 0 -> 0x5f
t_968_loop:
	add	r0, r2, r6 // 03000000 + r2
	strb	r5, [r0, #0] // zero that byte
	add	r1, r2, r4 // 03000060 + r2

	// weird
	ldrb	r0, [r1, #0]
	orr	r0, r3 // Why don't just write 0xFF?
	strb	r0, [r1, #0]

	add	r2, #1
	cmp	r2, #95	// 0x5f
	ble	t_968_loop
// 8000994
movs	r0, #0
strb	r0, [r7, #0]
mov	r1, r12
strb	r0, [r1, #0]
movs	r0, #0
mov	r1, r8
strh	r0, [r1, #0]
pop	{r3}
mov	r8, r3
pop	{r4, r5, r6, r7}
pop	{r0}
bx	r0

.incbin "FR.ro.gba",0x9AC,0x1bc

t_b68:
/*
Reads 030000c2, ORs it with lsld and lsrd r0, and puts it back.
Writes 1 in 030000c1. Calls b34, reads 030000c2 again, calls bc0.
*/
push	{r4, lr}
// Does this actually do something?
lsl	r0, r0, #16
lsr	r0, r0, #16
ldr	r4, [pc, #28]	// [$08000b8c] (=$030000c2)
ldrh	r1, [r4, #0]
orr	r0, r1
strh	r0, [r4, #0]
ldr	r1, [pc, #24]	// [$08000b90] (=$030000c1)
movs	r0, #1
strb	r0, [r1, #0]
bl	0x8000b34
ldrh	r0, [r4, #0]
bl	0x8000bc0
pop	{r4}
pop	{r0}
bx	r0

.incbin "FR.ro.gba",0xb8c,0x6794

t_7320:
// Copy 0x400 bytes from 03003128 to 07000000 (OAM)
push	{lr}
ldr	r2, [pc, #32]	// [$08007344] (=$030030f0)
ldr	r1, [pc, #32]	// [$08007348] (=$00000439)
add	r0, r2, r1 // [03003529]
ldrb	r1, [r0, #0]
movs	r0, #1
and	r0, r1
cmp	r0, #0 // If ([03003529] & 1) != 0: return
bne	t_7340 // early ret
add	r0, r2, #0
add	r0, #56	// 0x38;  =03003128
movs	r1, #224	// 0xe0
lsl	r1, r1, #19 // = 07000000
ldr	r2, [pc, #16]	// (0x734c)
// r0 source, r1 dest, r2 options: wc 0x100, datasize 32bit
bl	0x81e3b64 // SWI 11 - CpuSet
t_7340:
pop	{r0}
bx	r0
.word 0x030030f0
.word 0x439
.word 0x04000100 // not the timer, swi 0bh options

.incbin "FR.ro.gba",0x7350,0x2c0

t_7610:
push	{r4, r5, r6, r7, lr}
ldr	r0, [pc, #76]	// [$08007660] (=$02021840)
ldrb	r0, [r0, #0]
cmp	r0, #0
beq	t_7658 // Can be b
movs	r4, #0
ldr	r1, [pc, #68]	// (0x7664)
ldrb	r0, [r1, #0]
cmp	r0, #0
beq	0x8007652
ldr	r6, [pc, #64]	// (0x7668)
add	r7, r6, #4
add	r5, r1, #0
lsl	r1, r4, #1
add	r1, r1, r4
lsl	r1, r1, #2
add	r2, r1, r6
ldr	r0, [r2, #0]
add	r1, r1, r7
ldr	r1, [r1, #0]
ldrh	r2, [r2, #8]
lsr	r2, r2, #1
bl	0x81e3b64
ldrb	r1, [r5, #0]
sub	r1, #1
strb	r1, [r5, #0]
add	r0, r4, #1
lsl	r0, r0, #24
lsr	r4, r0, #24
lsl	r1, r1, #24
cmp	r1, #0
bne	0x800762a
ldr	r1, [pc, #12]	// (0x7660)
movs	r0, #0
strb	r0, [r1, #0]
t_7658:
pop	{r4, r5, r6, r7}
pop	{r0}
bx	r0

.incbin "FR.ro.gba",0x765e,0x196e

t_8fcc:
// msgbox-related
push	{r4, r5, lr}
add	r4, r0, #0
add	r5, r1, #0
t_8fd2: // <-- re-entry
ldrb	r2, [r5, #0]
add	r5, #1
add	r0, r2, #0
sub	r0, #250	// 0xfa
cmp	r0, #5
bhi	t_90a6
lsl	r0, r0, #2
ldr	r1, [pc, #4]	// [$08008fe8] (=$08008fec)
add	r0, r0, r1
ldr	r0, [r0, #0]
mov	pc, r0
// At first, r0 is t_90a6, then changes to t_90ac where there
// is a proper return

.word 0x08008fec

.incbin "FR.ro.gba",0x8fec,0xba

t_90a6:
strb	r2, [r4, #0]
add	r4, #1
b	t_8fd2

t_90ac:
movs	r0, #255	// 0xff
strb	r0, [r4, #0]
add	r0, r4, #0
pop	{r4, r5}
pop	{r1}
bx	r1

.incbin "FR.ro.gba",0x90b8,0x4f228

// 0x582e0
t_582e0:
/* This function is kinda important, because it's called
   all the time*/
push	{lr}
bl	0x805833c
cmp	r0, #1
bls	0x8058304
bl	0x805642c
cmp	r0, #1
bne	0x8058304
bl	0x800a00c
cmp	r0, #1
bne	0x8058304
ldr	r0, [pc, #12]	// (0x58308)
ldr	r1, [r0, #0]
ldr	r0, [pc, #12]	// (0x5830c)
cmp	r1, r0
beq	0x8058310
movs	r0, #0
b	0x8058312
lsr	r4, r0, #26
lsl	r0, r0, #12
ldrb	r5, [r5, #23]
lsr	r5, r0, #32
movs	r0, #1
pop	{r1}
bx	r1

.incbin "FR.ro.gba",0x58316,0x180d6

t_703ec:
// Copies from a source to 0x020371f8 and 0x020375f8
// Takes: r0 source, r1 offset?, r2 wc*2?
// This function does weird shit shifting regs aound...
push	{r4, r5, r6, lr}
add	r6, r0, #0
add	r4, r1, #0
add	r5, r2, #0
lsl	r4, r4, #16
lsl	r5, r5, #16
lsr	r4, r4, #15
ldr	r1, [pc, #32]	// (0x7041c) 0x020371f8
add	r1, r4, r1
lsr	r5, r5, #17
add	r2, r5, #0
// Copy 0x10 halfwords from R00=08402260 to R01=020371f8
bl	0x81e3b64 // SWI 0B
ldr	r0, [pc, #24]	// (0x70420) 0x020375f8
add	r4, r4, r0
add	r0, r6, #0
add	r1, r4, #0
add	r2, r5, #0
// Copy 0x10 halfwords from R00=08402260 to R01=020375f8
bl	0x81e3b64 // SWI 0B
pop	{r4, r5, r6}
pop	{r0}
bx	r0

.hword 0000
.word 0x020371f8
.word 0x020375f8

.incbin "FR.ro.gba",0x70424,0x50

t_70474:
push	{r4, r5, lr}
ldr	r4, [pc, #68]	// [$080704bc] (=$02037ab8)
ldrb	r1, [r4, #8]
movs	r5, #128	// 0x80
add	r0, r5, #0
and	r0, r1
lsl	r0, r0, #24
lsr	r3, r0, #24
cmp	r3, #0
bne	t_704b6 // NE, can't be b
ldr	r1, [pc, #52]	// [$080704c0] (=$020375f8)
movs	r2, #160	// 0xa0
lsl	r2, r2, #19
// DMA
ldr	r0, [pc, #52]	// [$080704c4] (=$040000d4)
// SRC =020375f8
str	r1, [r0, #0]
// DEST =05000000
str	r2, [r0, #4]
ldr	r1, [pc, #48]	// [$080704c8] (=$80000200)
// WC
str	r1, [r0, #8]
ldr	r0, [r0, #8]
ldr	r0, [pc, #48]	// [$080704cc] (=$02037ac8)
str	r3, [r0, #0]
ldrb	r1, [r4, #9]
movs	r0, #3
and	r0, r1
cmp	r0, #2
bne	t_704b6 // Can be b, can be nop, NE
ldrb	r1, [r4, #7]
add	r0, r5, #0
and	r0, r1
cmp	r0, #0
beq	t_704b6 // Can be b, can be nop, NE
bl	0x807141c // NE
t_704b6:
pop	{r4, r5}
pop	{r0}
bx	r0

.word 0x2037ab8
.word 0x20375f8
.word 0x40000d4
.word 0x80000200
.word 0x2037ac8

t_704d0:
push	{lr}
ldr	r0, [pc, #12]	// (0x704e0)
ldr	r0, [r0, #0]
cmp	r0, #0
beq	t_704e4
movs	r0, #255	// 0xff
b	t_7051c_earlyret
.hword 0000
.word 0x02037ac8

t_704e4:
ldr	r0, [pc, #16]	// (0x704f8)
ldrb	r0, [r0, #9]
movs	r1, #3
and	r1, r0
cmp	r1, #0
bne	t_704fc
bl	0x8070b8c
b	t_7050a
.hword 0000
.word 0x02037ab8

t_704fc:
cmp	r1, #1
bne	t_70506
bl	0x8070eec
b	t_7050a

t_70506:
bl	0x8071300

t_7050a:
lsl	r0, r0, #24
lsr	r3, r0, #24
ldr	r2, [pc, #16]	// (0x70520)
ldr	r0, [pc, #16]	// (0x70524)
ldr	r0, [r0, #0]
movs	r1, #0
orr	r0, r1
str	r0, [r2, #0]
add	r0, r3, #0
t_7051c_earlyret:
pop	{r1}
bx	r1
.word 0x02037ac8
.word 0x02037ab8

.incbin "FR.ro.gba",0x70528,0x7050

t_77578:
push	{r4, r5, lr}
bl	t_775a8
lsl	r0, r0, #24
lsr	r0, r0, #24
cmp	r0, #16
beq	t_7759c // return
ldr	r5, [pc, #28]	// (0x775a4)
lsl	r4, r0, #2
add	r4, r4, r0
lsl	r4, r4, #3
add	r4, r4, r5
ldr	r1, [r4, #0] // Read 03005090
bl	0x81e3bac // bx r1
ldrb	r0, [r4, #6]
cmp	r0, #255	// 0xff
bne	0x8077588
t_7759c:
pop	{r4, r5}
pop	{r0}
bx	r0
.hword 0000
.word 0x3005090

t_775a8:
push	{lr}
movs	r2, #0
ldr	r0, [pc, #48]	// (0x775e0)
ldrb	r1, [r0, #4]
add	r3, r0, #0
cmp	r1, #1
bne	t_775bc
ldrb	r0, [r3, #5]
cmp	r0, #254	// 0xfe
beq	t_775da
// loop
t_775bc:
add	r0, r2, #1
lsl	r0, r0, #24
lsr	r2, r0, #24
cmp	r2, #15
bhi	t_775da // Return
lsl	r0, r2, #2
add	r0, r0, r2
lsl	r0, r0, #3
add	r1, r0, r3
ldrb	r0, [r1, #4]
cmp	r0, #1
bne	t_775bc
ldrb	r0, [r1, #5]
cmp	r0, #254	// 0xfe
bne	t_775bc
t_775da:
add	r0, r2, #0
pop	{r1}
bx	r1

.word 0x3005090

.incbin "FR.ro.gba",0x775e4,0x1330

t_78914: // 78915 5th gamestate
push	{r4, r5, r6, lr}
sub	sp, #12
ldr	r0, [pc, #20]	// (0x78930)
movs	r1, #135	// 0x87
lsl	r1, r1, #3
add	r0, r0, r1
ldrb	r6, [r0, #0]
cmp	r6, #1
beq	0x80789f0
cmp	r6, #1
bgt	t_78934
cmp	r6, #0
beq	0x8078946
b	0x807893a
.word 0x30030f0

t_78934:
cmp	r6, #2
bne	0x807893a
b	0x8078ac0 // exit
ldr	r0, [pc, #148]	// (0x789d0)
movs	r1, #135	// 0x87
lsl	r1, r1, #3
add	r0, r0, r1
movs	r1, #0
strb	r1, [r0, #0]
movs	r0, #0
bl	0x80006f4
bl	0x8000558
ldr	r0, [pc, #128]	// (0x789d4)
movs	r1, #224	// 0xe0
lsl	r1, r1, #9
bl	0x8002b80
bl	0x80773bc
bl	0x8006b10
bl	0x80088f0
bl	0x8070528
bl	0x8078b34
add	r1, sp, #4
movs	r0, #0
strh	r0, [r1, #0]
ldr	r1, [pc, #96]	// (0x789d8)
add	r0, sp, #4
str	r0, [r1, #0]
movs	r0, #192	// 0xc0
lsl	r0, r0, #19
str	r0, [r1, #4]
ldr	r0, [pc, #88]	// (0x789dc)
str	r0, [r1, #8]
ldr	r0, [r1, #8]
movs	r2, #0
str	r2, [sp, #8]
add	r0, sp, #8
str	r0, [r1, #0]
movs	r0, #224	// 0xe0
lsl	r0, r0, #19
str	r0, [r1, #4]
ldr	r0, [pc, #72]	// (0x789e0)
str	r0, [r1, #8]
ldr	r0, [r1, #8]
add	r0, sp, #4
strh	r2, [r0, #0]
str	r0, [r1, #0]
movs	r0, #160	// 0xa0
lsl	r0, r0, #19
str	r0, [r1, #4]
ldr	r0, [pc, #60]	// (0x789e4)
str	r0, [r1, #8]
ldr	r0, [r1, #8]
movs	r0, #0
bl	0x8001618
ldr	r1, [pc, #52]	// (0x789e8)
movs	r0, #0
movs	r2, #4
bl	0x8001658
movs	r1, #130	// 0x82
lsl	r1, r1, #5
movs	r0, #0
bl	0x8000af4
ldr	r1, [pc, #36]	// (0x789ec)
movs	r0, #255	// 0xff
strb	r0, [r1, #0]
b	0x8078b18

.incbin "FR.ro.gba",0x789ce,0xf2

t_78ac0:
bl	0x80f682c
lsl	r0, r0, #24
cmp	r0, #0
bne	0x8078b26
ldr	r0, [pc, #52]	// (0x8078b00)
movs	r1, #16
movs	r2, #0
bl	0x80714d4
ldr	r0, [pc, #44]	// (0x8078b04)
movs	r1, #4
bl	0x807741c
ldr	r0, [pc, #40]	// (0x8078b08)
movs	r1, #2
bl	0x807741c
ldr	r1, [pc, #36]	// (0x78b0c)
strb	r0, [r1, #0]
ldr	r0, [pc, #36]	// (0x78b10)
bl	0x80006f4
ldr	r0, [pc, #36]	// (0x78b14)
bl	t_544
movs	r0, #139	// 0x8b
lsl	r0, r0, #1
bl	0x81dd0f4
b	0x8078b26
.hword 0
.word 0xffff
.word 0x8078c25
.word 0x8078bed
.word 0x2037f30
.word 0x8078bb5
.word 0x8078b9d // next gamestate

.incbin "FR.ro.gba",0x78b18,0x73a8c

t_ec5a4: // ec5a5
push	{lr}
bl	0x8007320 // Copy shit to OAM
bl	0x8007610 // Not too important
bl	0x8070474 // Palettes
pop	{r0}
bx	r0

.hword 0000

// 2nd gamestate
t_ec5b8:
push	{lr}
bl	t_704d0 // more or less essential - r0 must be set to 0
lsl	r0, r0, #24
cmp	r0, #0
bne	t_ec5ca_earlyret
ldr	r0, [pc, #8]	// (0xec5d0) next gamestate
bl	t_544
t_ec5ca_earlyret:
pop	{r0}
bx	r0
.hword 0000
.word 0x080ec871

t_ec5d4:
push	{r4, r5, r6, lr}
// I wish I knew what this is supposed to achieve
add	r3, r0, #0
add	r4, r1, #0
add	r5, r2, #0
lsl	r3, r3, #16
lsr	r3, r3, #16
lsl	r4, r4, #16
lsr	r4, r4, #16
lsl	r5, r5, #16
lsr	r5, r5, #16
ldr	r0, [pc, #36]	// (0xec610) 0x08402280
movs	r6, #192	// 0xc0
lsl	r6, r6, #19 // r6 = 0x6000000, VRAM
add	r3, r3, r6 // r3 and r1 as well cos why not
add	r1, r3, #0
bl	t_swi_12
ldr	r0, [pc, #28]	// (0xec614) 0x084024e4
// r1 = r4 = 06003800
add	r4, r4, r6
add	r1, r4, #0
bl	t_swi_12
ldr	r0, [pc, #20]	// (0xec618) 0x08402260
add	r1, r5, #0
movs	r2, #32
bl	t_703ec
pop	{r4, r5, r6}
pop	{r0}
bx	r0
.word 0x08402280 // Copyright compressed graphic
.word 0x084024e4 // The tilemap, I guess
.word 0x08402260

.incbin "FR.ro.gba",0xec61c,0x10

t_ec62c:
push	{r4, r5, r6, lr}
sub	sp, #12
ldr	r0, [pc, #24]	// [$080ec64c] (=$030030f0)
movs	r1, #135	// 0x87
lsl	r1, r1, #3
add	r5, r0, r1 // r5 will be 03003528
ldrb	r4, [r5, #0] // The loop index, goes up
cmp	r4, #140	// 0x8c
bne	t_ec640 // Essential, could be made b
b	0x80ec778

t_ec640:
cmp	r4, #140	// 0x8c
bgt	t_ec650 // If removed it loops at the copyright screen
cmp	r4, #0
beq	t_ec65e // Blank screen if removed
b	0x80ec732 // Working without this
.hword 0000 // just alignment I think
.word 0x030030f0

t_ec650:
cmp	r4, #141	// 0x8d
bne	t_ec656 // Also loop on first screen
b	0x80ec7a4 // Doesn't seem to be needed

// Now this starts to become a fucking mess
t_ec656:
cmp	r4, #142	// 0x8e
bne	t_ec65c // loops if it's made b, not needed
// Exit point
b	0x80ec808 // @ ec65a

t_ec65c:
b	0x80ec732 // @ ec65c

t_ec65e:
// Oh my god
// This works even if all the calls marked as NE are replaced by
// nops, so no idea what they do.
// There is one of them which makes the star yellow in the titlescreen
movs	r0, #0
bl	r0_in_30fc // NE
movs	r0, #80	// 0x50
movs	r1, #0
bl	0x8000a38 // NE
movs	r0, #82	// 0x52
movs	r1, #0
bl	0x8000a38 // NE
movs	r0, #84	// 0x54
movs	r1, #0
bl	0x8000a38 // NE
movs	r1, #160	// 0xa0
lsl	r1, r1, #19
ldr	r2, [pc, #200]	// [$080ec74c] (=$00007fff)
add	r0, r2, #0
strh	r0, [r1, #0]
movs	r0, #0
movs	r1, #0
bl	0x8000a38 // NE
movs	r0, #16
movs	r1, #0
bl	0x8000a38 // NE
movs	r0, #18
movs	r1, #0
bl	0x8000a38 // NE
add	r0, sp, #4
strh	r4, [r0, #0]
//DMA
ldr	r1, [pc, #172]	// [$080ec750] (=$040000d4)
str	r0, [r1, #0]
movs	r0, #192	// 0xc0
lsl	r0, r0, #19
str	r0, [r1, #4]
ldr	r0, [pc, #164]	// [$080ec754] (=$8100c000)
str	r0, [r1, #8]
ldr	r0, [r1, #8]
str	r4, [sp, #8]
add	r0, sp, #8
str	r0, [r1, #0]
movs	r0, #224	// 0xe0
lsl	r0, r0, #19
str	r0, [r1, #4]
ldr	r0, [pc, #152]	// [$080ec758] (=$85000100)
str	r0, [r1, #8]
ldr	r0, [r1, #8]
add	r0, sp, #4
strh	r4, [r0, #0]
str	r0, [r1, #0]
ldr	r0, [pc, #144]	// [$080ec75c] (=$05000002)
str	r0, [r1, #4]
ldr	r0, [pc, #144]	// [$080ec760] (=$810001ff)
str	r0, [r1, #8]
ldr	r0, [r1, #8]
bl	0x8070528 // NE
movs	r1, #224	// 0xe0
lsl	r1, r1, #6
movs	r0, #0
movs	r2, #0
bl	0x80ec5d4 // Draws the copyright screen
bl	0x8087e64 // NE
bl	0x80773bc // NE
bl	0x8006b10 // NE
bl	0x80088f0 // NE - star appears black without it
movs	r0, #1
neg	r0, r0
ldr	r1, [pc, #104]	// [$080ec764] (=$0000ffff)
str	r1, [sp, #0]
movs	r1, #0
movs	r2, #16
movs	r3, #0
bl	0x8070588 // NE
movs	r1, #224	// 0xe0
lsl	r1, r1, #3
movs	r0, #8
bl	0x8000a38 // NE
movs	r0, #1
bl	0x8000b68 // NE
ldr	r0, [pc, #80]	// [$080ec768] (=$080ec5a5)
bl	r0_in_30fc // Essential
movs	r1, #160	// 0xa0
lsl	r1, r1, #1
movs	r0, #0
bl	0x8000a38 // NE
ldr	r0, [pc, #68]	// [$080ec76c] (=$080ec61d)
bl	0x8000718 // NE
ldr	r0, [pc, #64]	// [$080ec770] (=$0203aad4)
bl	0x81dbe5c // NE - this one is long
bl	t_704d0 // NE
ldr	r0, [pc, #60]	// [$080ec774] (=$030030f0)
movs	r1, #135	// 0x87
lsl	r1, r1, #3
add	r0, r0, r1
ldrb	r1, [r0, #0]
add	r1, #1
strb	r1, [r0, #0]
ldr	r0, [pc, #40]	// [$080ec770] (=$0203aad4)
bl	0x81dbd48 // NE
b	t_ec812

.word 0x7fff
.word 0x040000d4
.word 0x8100c000
.word 0x85000100
.word 0x05000002
.word 0x810001ff
.word 0xffff
.word 0x080ec5a5
.word 0x080ec61d
.word 0x0203aad4
.word 0x030030f0

.incbin "FR.ro.gba",0xec778,0x90

t_ec808: // Set next gamestate
bl	0x800b388
ldr	r0, [pc, #12]	// (0xec81c) =0x080ec5b9
bl	t_544

t_ec812:
movs	r0, #1
add	sp, #12
pop	{r4, r5, r6}
pop	{r1}
bx	r1
.word 0x080ec5b9 // ec5b8 thumb

// 80ec820 -- copyright gamestate?

// This is called through a callback, and follows like this:
// ec820 -> ec62c -> ec640 -> ec650 -> ec656 -> ec65c
//              \         \                  -> ec808 -- ec812
//               -(opt)-----> ec65e ----------------------^
// It loops 140 (0x8c) times and then exits through ec650->ec808
// The real stuff is done in ec65e - although the only
// really important call in there just sets a callback to 080ec5a5
// in 030030fc
// The stack subtracted 12 in 62c and fixed in ec812

t_ec820:
push	{lr}
bl	t_ec62c // Essential
lsl	r0, r0, #24
cmp	r0, #0
bne	t_ec820_ret // Can be b, rest is not essential
bl	0x8054a28
bl	0x80d9750
movs	r0, #0
bl	0x80da4fc
ldr	r0, [pc, #32]	// (0xec85c)
ldrh	r0, [r0, #0]
cmp	r0, #0
beq	0x80ec846
cmp	r0, #2
bne	0x80ec84a
bl	0x8054a18
ldr	r0, [pc, #20]	// (0xec860)
ldr	r0, [r0, #0]
ldrb	r0, [r0, #21]
lsl	r0, r0, #31
lsr	r0, r0, #31
bl	0x81de7d4
t_ec820_ret: // ec858
pop	{r0}
bx	r0

.word 0x030053a0 // ec85c
.word 0x0300500c // ec860

.incbin "FR.ro.gba",0xec864,0xc

t_ec870: // 3rd gamestate
push	{r4, lr}
sub	sp, #12
ldr	r0, [pc, #20]	// (0xec88c)
movs	r1, #135	// 0x87
lsl	r1, r1, #3
add	r0, r0, r1
ldrb	r4, [r0, #0]
cmp	r4, #1
beq	0x80ec944
cmp	r4, #1
bgt	t_ec890 // exit
cmp	r4, #0
beq	0x80ec8a0
b	0x80ec894
.word 0x030030f0

t_ec890:
cmp	r4, #2
beq	t_ec988
ldr	r0, [pc, #144]	// (0xec928)
movs	r1, #135	// 0x87
lsl	r1, r1, #3
add	r0, r0, r1
movs	r1, #0
strb	r1, [r0, #0]
movs	r0, #0
bl	0x80006f4
movs	r0, #0
movs	r1, #0
bl	0x8000a38
ldr	r0, [pc, #124]	// (0xec92c)
movs	r1, #224	// 0xe0
lsl	r1, r1, #9
bl	0x8002b80
bl	0x80773bc
bl	0x8006b10
bl	0x8070528
bl	0x80f6808
bl	0x80eca00
add	r1, sp, #4
movs	r0, #0
strh	r0, [r1, #0]
ldr	r1, [pc, #92]	// (0xec930)
add	r0, sp, #4
str	r0, [r1, #0]
movs	r0, #192	// 0xc0
lsl	r0, r0, #19
str	r0, [r1, #4]
ldr	r0, [pc, #84]	// (0xec934)
str	r0, [r1, #8]
ldr	r0, [r1, #8]
movs	r2, #0
str	r2, [sp, #8]
add	r0, sp, #8
str	r0, [r1, #0]
movs	r0, #224	// 0xe0
lsl	r0, r0, #19
str	r0, [r1, #4]
ldr	r0, [pc, #68]	// (0xec938)
str	r0, [r1, #8]
ldr	r0, [r1, #8]
add	r0, sp, #4
strh	r2, [r0, #0]
str	r0, [r1, #0]
movs	r0, #160	// 0xa0
lsl	r0, r0, #19
str	r0, [r1, #4]
ldr	r0, [pc, #52]	// (0xec93c)
str	r0, [r1, #8]
ldr	r0, [r1, #8]
movs	r2, #128	// 0x80
lsl	r2, r2, #3
movs	r0, #0
movs	r1, #0
bl	0x8070424
movs	r0, #0
bl	0x8001618
ldr	r1, [pc, #32]	// (0xec940)
movs	r0, #0
movs	r2, #2
bl	0x8001658
b	0x80ec9b8
.word 0x30030f0
.word 0x2000000
.word 0x40000d4
.word 0x8100c000
.word 0x85000100
.word 0x81000200
.word 0x840bb80

t_ec944:
ldr	r0, [pc, #48]	// (0xec978)
movs	r1, #0
movs	r2, #32
bl	0x80703ec
ldr	r1, [pc, #44]	// (0xec97c)
movs	r0, #0
str	r0, [sp, #0]
movs	r0, #3
movs	r2, #0
movs	r3, #0
bl	0x80f6878
ldr	r1, [pc, #32]	// (0xec980)
str	r4, [sp, #0]
movs	r0, #3
movs	r2, #0
movs	r3, #0
bl	0x80f6878
ldr	r0, [pc, #20]	// (0xec984)
movs	r1, #208	// 0xd0
movs	r2, #32
bl	0x80703ec
b	0x80ec9b8
.word 0x8402630
.word 0x8402650
.word 0x8402668
.word 0x840270c

t_ec988:
bl	0x80f682c
lsl	r0, r0, #24
cmp	r0, #0
bne	0x80ec9c6
bl	t_eca70 // Sets a callback
movs	r0, #1
neg	r0, r0
movs	r1, #16
movs	r2, #0
bl	0x80714d4
ldr	r0, [pc, #12]	// (0xec9b0)
bl	t_544
ldr	r0, [pc, #8]	// (0xec9b4)
bl	0x80006f4
b	0x80ec9c6

.word 0x80ec9d5 // Next gamestate (4th)
.word 0x80ec9ed

t_ec9b8:
ldr	r1, [pc, #20]	// (0xec9d0)
movs	r0, #135	// 0x87
lsl	r0, r0, #3
add	r1, r1, r0
ldrb	r0, [r1, #0]
add	r0, #1
strb	r0, [r1, #0]
add	sp, #12
pop	{r4}
pop	{r0}
bx	r0

.hword 0000
.word 0x030030f0

t_ec9d4: // 4th gamestate
push	{lr}
// black screen if not done
bl	t_77578

// drawing the star, and making little stars disappear
bl	0x8006b5c

// needed for all stars
bl	0x8006ba8

// In this case, needed for animation after title
bl	t_704d0

pop	{r0}
bx	r0

.hword 0000

t_ec9ec:
push	{lr}
bl	0x8007320
bl	0x8007610
bl	0x8070474
pop	{r0}
bx	r0

.incbin "FR.ro.gba",0xec9fe,0x72

t_eca70:
push	{r4, lr}
ldr	r0, [pc, #40]	// (0xeca9c)
bl	0x8002b9c
add	r4, r0, #0
ldr	r1, [pc, #36]	// (0xecaa0)
bl	0x80ecaa8
ldr	r0, [pc, #32]	// (0xecaa4)
movs	r1, #3
bl	0x807741c // !!
strb	r0, [r4, #5]
ldrb	r0, [r4, #5]
movs	r1, #0
add	r2, r4, #0
bl	0x80776e8
pop	{r4}
pop	{r0}
bx	r0

.hword 0000
.word 0x28bc
.word 0x80ecaf1 // callback
.word 0x80ecab1 // will be written to 03005090 and called later

.incbin "FR.ro.gba",0xecaa8,0x8

t_ecab0: // ecab1
// calls callbacks
push	{r4, lr}
lsl	r0, r0, #24
lsr	r0, r0, #24
movs	r1, #0
bl	0x8077720 // Essential
add	r4, r0, #0 // r4 is now 02000010
ldr	r0, [pc, #40]	// (0xecae8)
ldrh	r1, [r0, #46]	// 0x2e
movs	r0, #13
and	r0, r1
cmp	r0, #0
beq	t_ecad8
ldr	r0, [r4, #0]
ldr	r1, [pc, #28]	// (0xecaec)
cmp	r0, r1
beq	t_ecad8
add	r0, r4, #0
bl	0x80ecaa8 // Not essential
t_ecad8:
ldr	r1, [r4, #0] // ecaf1 is in 2000010
add	r0, r4, #0
bl	0x81e3bac // bx r1
pop	{r4}
pop	{r0}
bx	r0
.hword 0000
.word 0x30030f0
.word 0x80edbe9

t_ecaf0:
push	{r4, r5, lr}
sub	sp, #12
add	r5, r0, #0
ldrb	r0, [r5, #4]
cmp	r0, #0
beq	0x80ecb02
cmp	r0, #1
beq	0x80ecb78 // exit
b	0x80ecb8a

.incbin "FR.ro.gba",0xecb02,0x76

t_ecb78:
bl	0x8001960
lsl	r0, r0, #24
cmp	r0, #0
bne	0x80ecb8a
ldr	r1, [pc, #16]	// (0xecb94)
add	r0, r5, #0
bl	0x80ecaa8 // write to r5
add	sp, #12
pop	{r4, r5}
pop	{r0}
bx	r0
.hword 0
.word 0x80ecb99 // callback, exit

t_ecb98:
push	{r4, r5, lr}
add	r4, r0, #0
ldrb	r5, [r4, #4]
cmp	r5, #1
beq	0x80ecbe2
cmp	r5, #1
bgt	0x80ecbac // exit
cmp	r5, #0
beq	0x80ecbb2
b	0x80ecc32

t_ecbac:
cmp	r5, #2
beq	0x80ecbfc // exit
b	0x80ecc32

t_ecbb2:
movs	r1, #128	// 0x80
lsl	r1, r1, #7
movs	r0, #0
bl	0x8000af4
movs	r1, #252	// 0xfc
lsl	r1, r1, #6
movs	r0, #72	// 0x48
bl	0x8000a38
movs	r0, #74	// 0x4a
movs	r1, #0
bl	0x8000a38
movs	r0, #66	// 0x42
movs	r1, #240	// 0xf0
bl	0x8000a38
movs	r0, #70	// 0x46
movs	r1, #0
bl	0x8000a38
strh	r5, [r4, #18]
b	0x80ecbf4
movs	r0, #3
bl	0x80019bc
movs	r0, #1
neg	r0, r0
movs	r1, #0
movs	r2, #0
bl	0x80714d4
ldrb	r0, [r4, #4]
add	r0, #1
strb	r0, [r4, #4]
b	0x80ecc32

t_ecbfc:
ldrh	r0, [r4, #18]
add	r0, #8
strh	r0, [r4, #18]
lsl	r0, r0, #16
lsr	r0, r0, #16
cmp	r0, #47	// 0x2f
bls	0x80ecc0e
movs	r0, #48	// 0x30
strh	r0, [r4, #18]
ldrh	r0, [r4, #18]
movs	r1, #80	// 0x50
sub	r1, r1, r0
lsl	r1, r1, #8
add	r0, #80	// 0x50
orr	r1, r0
lsl	r1, r1, #16
lsr	r1, r1, #16
movs	r0, #70	// 0x46
bl	0x8000a38
ldrh	r0, [r4, #18]
cmp	r0, #48	// 0x30
bne	0x80ecc32
ldr	r1, [pc, #12]	// (0xecc38)
add	r0, r4, #0
bl	0x80ecaa8
pop	{r4, r5}
pop	{r0}
bx	r0

.word 0x80ecc3d // callback, exit

t_ecc3c:
push	{r4, r5, lr}
add	r4, r0, #0
ldrb	r5, [r4, #4]
cmp	r5, #1
beq	0x80ecc68
cmp	r5, #1
bgt	0x80ecc50 // exit
cmp	r5, #0
beq	0x80ecc56
b	0x80ecc9c

t_ecc50:
cmp	r5, #2
beq	0x80ecc86 // exit
b	0x80ecc9c

t_ecc56:
ldr	r0, [pc, #12]	// (0xecc64)
bl	0x80722cc
bl	0x80edc40
strh	r5, [r4, #18]
b	0x80ecc7e

.word 0x141

t_ecc68:
ldrh	r0, [r4, #18]
add	r0, #1
strh	r0, [r4, #18]
lsl	r0, r0, #16
lsr	r0, r0, #16
cmp	r0, #30
bne	0x80ecc9c
bl	0x80eddf0
movs	r0, #0
strh	r0, [r4, #18]
ldrb	r0, [r4, #4]
add	r0, #1
strb	r0, [r4, #4]
b	0x80ecc9c

t_ecc86:
ldrh	r0, [r4, #18]
add	r0, #1
strh	r0, [r4, #18]
lsl	r0, r0, #16
lsr	r0, r0, #16
cmp	r0, #90	// 0x5a
bne	0x80ecc9c
ldr	r1, [pc, #12]	// (0xecca4)
add	r0, r4, #0
bl	0x80ecaa8
pop	{r4, r5}
pop	{r0}
bx	r0

.hword 0000
.word 0x80ecca9 // callback, exit

t_ecca8:
push	{r4, r5, lr}
sub	sp, #8
add	r4, r0, #0
ldrb	r0, [r4, #4]
cmp	r0, #5
bhi	0x80ecd54
lsl	r0, r0, #2
ldr	r1, [pc, #8]	// (0xeccc0)
add	r0, r0, r1
ldr	r0, [r0, #0]
mov	pc, r0

// Will jump to:
// eccdc first time
// then many times to 080ecce6
// then 080eccf6
// 080ecd18
// 080ecd20 many times
// 080ecd3e many times
// (until game freak animation ends)

.hword 0000
.word 0x80eccc4
.word 0x80eccdc

.incbin "FR.ro.gba",0xeccc8,0x14

t_eccdc:
bl	0x80eded8
movs	r0, #0
strh	r0, [r4, #18]
b	0x80ecd36

.incbin "FR.ro.gba",0xecce6,0x58

t_ecd3e:
ldrh	r0, [r4, #18]
add	r0, #1
strh	r0, [r4, #18]
lsl	r0, r0, #16
lsr	r0, r0, #16
cmp	r0, #50	// 0x32
bls	0x80ecd54
ldr	r1, [pc, #12]	// (0xecd5c)
add	r0, r4, #0
bl	0x80ecaa8
add	sp, #8
pop	{r4, r5}
pop	{r0}
bx	r0
.word 0x80ecd61 // callback, exit

t_ecd60:
push	{r4, r5, r6, lr}
sub	sp, #8
add	r6, r0, #0
ldrb	r0, [r6, #4]
cmp	r0, #7
bls	0x80ecd6e // exit
b	0x80ece96

t_ecd6e:
lsl	r0, r0, #2
ldr	r1, [pc, #4]	// (0xecd78)
add	r0, r0, r1
ldr	r0, [r0, #0]
mov	pc, r0
.word 0x80ecd7c
// first 080ecd9c
// then 080ecdc4
// 080ecdcc many times while logo fades in
// 080ece10
// 080ece26 many times to wait
// 080ece52 many times to fade out
// 080ece64
// 080ece78 many times (0x15 times?)
// (exit there)

.incbin "FR.ro.gba",0xecd7c,0xfc

t_ece78:
ldrh	r0, [r6, #18]
add	r0, #1
strh	r0, [r6, #18]
lsl	r0, r0, #16
lsr	r0, r0, #16
cmp	r0, #20
bls	0x80ece96
movs	r0, #80	// 0x50
movs	r1, #0
bl	0x8000a38
ldr	r1, [pc, #16]	// (0xecea0)
add	r0, r6, #0
bl	0x80ecaa8
add	sp, #8
pop	{r4, r5, r6}
pop	{r0}
bx	r0
.hword 0000
.word 0x080ecea5 // callback, exit

t_ecea4: // ecea5
push	{r4, r5, lr}
sub	sp, #4
add	r5, r0, #0
ldrb	r0, [r5, #4]
cmp	r0, #5
bls	0x80eceb2 // exit
b	0x80ed094

t_eceb2: // 1st animation after game freak
lsl	r0, r0, #2
ldr	r1, [pc, #4]	// (0xecebc)
add	r0, r0, r1
ldr	r0, [r0, #0]
mov	pc, r0
.word 0x80ecec0
.word 0x80eced8
.word 0x80ecf64
.word 0x80ecfa4
.word 0x80ecfd8 // many times
.word 0x80ed000 // many times
.word 0x80ed064 // never?

.incbin "FR.ro.gba",0xeced8,0x128

t_ed000:
ldrh	r0, [r5, #18]
add	r0, #1
strh	r0, [r5, #18]
lsl	r0, r0, #16
lsr	r0, r0, #16
cmp	r0, #20
bne	t_ed01a
ldr	r0, [pc, #68]	// (0x80ed054)
movs	r1, #0
bl	0x807741c
bl	0x80ed118

t_ed01a:
ldrh	r0, [r5, #18]
cmp	r0, #29
bls	0x80ed094
movs	r0, #2
neg	r0, r0
ldr	r2, [pc, #48]	// (0x80ed058)
movs	r1, #16
bl	0x80714d4
ldr	r0, [pc, #44]	// (0x80ed05c)
bl	0x8077688
lsl	r0, r0, #24
lsr	r0, r0, #24
bl	0x8077508
ldr	r0, [pc, #24]	// (0x80ed054)
bl	0x8077688
lsl	r0, r0, #24
lsr	r0, r0, #24
bl	0x8077508
ldr	r1, [pc, #20]	// (0x80ed060)
add	r0, r5, #0
bl	0x80ecaa8
b	0x80ed094

.hword 0
.word 0x80ed141
.word 0x7fff
.word 0x80ed0ad
.word 0x80ed189 // callback, exit

.incbin "FR.ro.gba",0xed064,0x124

t_ed188: // first part of battle scene
push	{r4, r5, r6, r7, lr}
mov	r7, r8
push	{r7}
sub	sp, #4
add	r7, r0, #0
ldrb	r0, [r7, #4]
cmp	r0, #6
bls	0x80ed19a
b	0x80ed3f6
lsl	r0, r0, #2
ldr	r1, [pc, #4]	// (0xed1a4)
add	r0, r0, r1
ldr	r0, [r0, #0]
mov	pc, r0 // 1a2

.word 0x80ed1a8
.word 0x80ed1c4
.word 0x80ed214
.word 0x80ed32c
.word 0x80ed350 // many times, fade in
.word 0x80ed360 // many, keep moving
.word 0x80ed3bc // load close up scene, but withut hiding the small sprites
.word 0x80ed3d2 // many, hide small sprites, then parallax camera effect

.incbin "FR.ro.gba",0xed1c4,0x20e

t_ed3d2:
ldrh	r0, [r7, #18]
add	r0, #1
strh	r0, [r7, #18]
lsl	r0, r0, #16
lsr	r0, r0, #16
cmp	r0, #59	// 0x3b
bls	0x80ed3f6
ldr	r0, [pc, #32]	// (0x80ed404)
bl	0x8077688
lsl	r0, r0, #24
lsr	r0, r0, #24
bl	0x8077508
ldr	r1, [pc, #24]	// (0x80ed408)
add	r0, r7, #0
bl	0x80ecaa8
add	sp, #4
pop	{r3}
mov	r8, r3
pop	{r4, r5, r6, r7}
pop	{r0}
bx	r0
.hword 0
.word 0x80ed429
.word 0x80ed4c1 // callback, exit

.incbin "FR.ro.gba",0xed40c,0xb4

t_ed4c0:
push	{r4, r5, lr}
sub	sp, #4
add	r5, r0, #0
ldrb	r4, [r5, #4]
cmp	r4, #1
beq	0x80ed59c
cmp	r4, #1
bgt	0x80ed4d6
cmp	r4, #0
beq	0x80ed4e4
b	0x80ed68a

t_ed4d6:
cmp	r4, #2
bne	0x80ed4dc
b	0x80ed5fc

t_ed4dc:
cmp	r4, #3
bne	0x80ed4e2
b	0x80ed658

.incbin "FR.ro.gba",0xed4e2,0x176

t_ed658:
ldrh	r0, [r5, #18]
add	r0, #1
strh	r0, [r5, #18]
lsl	r0, r0, #16
lsr	r0, r0, #16
cmp	r0, #16
bne	0x80ed66c
add	r0, r5, #0
bl	0x80ed7d4
add	r0, r5, #0
bl	0x80ee5c8
cmp	r0, #0
bne	0x80ed68a
ldr	r0, [pc, #28]	// (0x80ed694)
bl	0x8077650
lsl	r0, r0, #24
cmp	r0, #0
bne	0x80ed68a
ldr	r1, [pc, #20]	// (0x80ed698)
add	r0, r5, #0
bl	0x80ecaa8
add	sp, #4
pop	{r4, r5}
pop	{r0}
bx	r0
.hword 0
.word 0x80ee201
.word 0x80ed899 // callback, exit

.incbin "FR.ro.gba",0xed69c,0x1fc

t_ed898: // ed899
// Second part of intro battle (the awesome part)
push	{r4, r5, lr}
sub	sp, #8
add	r4, r0, #0
ldrb	r0, [r4, #4]
cmp	r0, #15
bls	0x80ed8a6
b	0x80eda98
lsl	r0, r0, #2
ldr	r1, [pc, #4]	// (0x80ed8b0)
add	r0, r0, r1
ldr	r0, [r0, #0]
mov	pc, r0

.word 0x80ed8b4
.word 0x80ed8f4
.word 0x80ed8f8 // many, parallax
.word 0x80ed910 // many, nidowhatever sprite animation
.word 0x80ed918 // many, nido calms down and more parallax
.word 0x80ed936 // many, gengar raises hand and backpedals
.word 0x80ed946 // many, gengar attacks, nido dodges
.word 0x80ed95e // many, more parallax
.word 0x80ed97c // many, nido jumps
.word 0x80ed998 // many, nido jumps back
.word 0x80ed9a0 // many, moar parallax
.word 0x80ed9ba
.word 0x80ed9d2
.word 0x80ed9dc // many, even more parallax scroll, then nido jumps with white bg fade out
.word 0x80eda1c // many, zoom
.word 0x80eda5c // zoom and black fade out
.word 0x80eda7c // many in black screen, exit

.incbin "FR.ro.gba",0xed8f4,0x188

t_eda7c:
ldrh	r0, [r4, #18]
add	r0, #1
strh	r0, [r4, #18]
lsl	r0, r0, #16
lsr	r0, r0, #16
cmp	r0, #60	// 0x3c
bls	0x80edac4
ldr	r1, [pc, #8]	// (0xeda94)
add	r0, r4, #0
bl	0x80ecaa8
b	0x80edac4
.word 0x80edbe9 // callback, exit

.incbin "FR.ro.gba",0xeda98,0x150

t_edbe8:
	push	{r4, lr}
	add	r4, r0, #0
	ldrb	r0, [r4, #4]
	cmp	r0, #0
	beq	t_edbf8
	cmp	r0, #1
	beq	t_edc0c
	b	t_edc34
t_edbf8:
	movs	r2, #128	// 0x8080
	lsl	r2, r2, #3
	movs	r0, #0
	movs	r1, #0
	bl	0x8070424
	ldrb	r0, [r4, #4]
	add	r0, #1
	strb	r0, [r4, #4]
	b	t_edc34
t_edc0c:
	bl	0x80f682c
	lsl	r0, r0, #24
	cmp	r0, #0
	bne	t_edc34
	ldrb	r0, [r4, #5]
	bl	0x8077508
	add	r0, r4, #0
	bl	0x8002bc4
	movs	r0, #2
	bl	0x8000b94
	movs	r0, #0
	bl	0x8000700
	ldr	r0, [pc, #12]	// (0xedc3c)
	bl	t_544 // change gamestate
t_edc34:
pop	{r4}
pop	{r0}
bx	r0

.hword 0
.word 0x8078915 // 5th gamestate

.incbin "FR.ro.gba",0xedc40,0x40ed0

t_tutorial_and_intro: // 0812eb10 0812eb11
push	{lr}
bl	t_77578 // Black screen if not here
bl	0x8002de8 // Prof. will not speak else
bl	0x8006b5c // Pokeball stays else
bl	0x8006ba8 // No pokemon out of pokeball else
bl	0x80704d0 // Black screen else
pop	{r0}
bx	r0

.incbin "FR.ro.gba",0x12eb2a,0xb502e

t_swi_0A:
// 1e3b58
swi 0xA // ArcTan2
bx lr

t_swi_0E:
// 1e3b5c
swi 0xE // BgAffineSet
bx lr

t_swi_0C:
// 1e3b60
swi 0xC // CpuFastSet
bx lr

t_swi_0B:
// 1e3b64
swi 0xB // CpuSet
bx lr

t_swi_06:
// 1e3b68
swi 6 // HALT
bx lr

t_swi_12:
// 1e3b6c
swi 0x12 // LZ77UnCompVram
bx lr

t_swi_11:
// 1e3b6e
swi 0x11 // LZ77UnCompVram
bx lr

t_swi_25:
// 1e3b70
movs r1, #1 // 16bit, MultiPlay mode (default, slow, up to three slaves)
swi 0x25 // MultiBoot
bx lr

.hword 0000

t_swi_0F:
// 1e3b7c
swi 0xF // ObjAffineSet
bx lr

t_swi_1:
// 0x1e3b80
swi 1 // RegisterRamReset
bx lr

//end:
// here is automatically added an incbin for the rest of the ROM


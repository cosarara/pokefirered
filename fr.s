
// t_ means the function is thumb (pretty much always I see)

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

ldrh	r1, [r7, #40]	// 0x28
movs	r0, #1
and	r0, r1
cmp	r0, #0
beq	tmain_label1

// We come here every time we press A
movs	r0, #14
and	r0, r1
cmp	r0, #14
bne	tmain_label1

// We never pass through here, it seems
bl	0x81e09d4
bl	0x81e08f8
bl	0x80008d8

tmain_label1:
bl	t_582e0 // Doesn't seem essential
cmp	r0, #1
bne	t_478 // exit 1 - used like all the time

// Is this really needed? Game works with b up here ^
strb	r0, [r6, #0]
bl	0x80004b0
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
bl	0x80004b0 // White screen withou this; important
// We can actually b tmain_reentry here (+nop) - game too fast though
bl	0x8058274 // Game seems to do fine without this
add	r4, r0, #0
cmp	r4, #1
bne	t_49e // White screen withou this; important
movs	r0, #0
strh	r0, [r7, #46]	// 0x2e
bl	0x8007350 // Game seems to do fine without this
strb	r4, [r5, #0]
bl	0x80004b0 // Game seems to do fine without this
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
bl	0x8000510 // This one is needed - blank screen else
t_4b0_earylyret: // 0x80004c0
pop	{r0}
bx	r0

// 080004c4
t_4c4:
push	{r4, lr}
ldr	r0, [pc, #44]	// (0x4f4)
movs	r4, #0
str	r4, [r0, #32]
str	r4, [r0, #36]	// 0x24
str	r4, [r0, #0]
ldr	r0, [pc, #36]	// (0x4f8)
bl	t_544
ldr	r0, [pc, #36]	// (0x4fc)
ldr	r1, [pc, #36]	// (0x500)
str	r1, [r0, #0]
ldr	r2, [pc, #36]	// (0x504)
ldr	r0, [pc, #40]	// (0x508)
str	r0, [r2, #0]
movs	r0, #242	// 0xf2
lsl	r0, r0, #4
add	r1, r1, r0
str	r4, [r1, #0]
ldr	r0, [pc, #32]	// (0x50c)
strb	r4, [r0, #0]
pop	{r4}
pop	{r0}
bx	r0

.incbin "FR.ro.gba",0x4f4,0x1c

t_510:
// Screen-related
	push	{r4, lr}
	bl	0x80f5118 // Not essential
	cmp	r0, #0
	bne	t_510_earlyret
	bl	0x813b870 // Not essential
	lsl	r0, r0, #24
	cmp	r0, #0
	bne	t_510_earlyret
	ldr	r4, [pc, #24]	// [$08000540] (=$030030f0)
	ldr	r0, [r4, #0] // Oh my, a callback
	cmp	r0, #0
	beq	t_510_jumpover // Essential
	bl	0x81e3ba8 // Not essential
t_510_jumpover: // 0x530
	ldr	r0, [r4, #4]
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
ldr	r1, [pc, #12]	// (0x554)
str	r0, [r1, #4]
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
ldr	r0, [pc, #56]	// [$08000624] (=$04000130)
ldrh	r1, [r0, #0]
ldr	r2, [pc, #56]	// [$08000628] (=$000003ff)
add	r0, r2, #0
add	r3, r0, #0
eor	r3, r1
ldr	r1, [pc, #52]	// [$0800062c] (=$030030f0)
ldrh	r2, [r1, #40]	// 0x28
add	r0, r3, #0
bic	r0, r2
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

.incbin "FR.ro.gba",0x622,0x66

t_688:
/* Copies 13 (14?) bytes from 081e9f28 to 03003540
Also, makes a DMA transfer:
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
bl	0x80006f4 // writes r0 to 030030fc
movs	r0, #0 // Not needed
bl	0x8000700 // writes r0 to 03003100
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


.incbin "FR.ro.gba",0x6d2,0x296

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

.incbin "FR.ro.gba",0xb8c,0x57754

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
// 58316


.incbin "FR.ro.gba",0x58316,0x94316

t_ec62c:
push	{r4, r5, r6, lr}
sub	sp, #12
ldr	r0, [pc, #24]	// (0xec64c)
movs	r1, #135	// 0x87
lsl	r1, r1, #3
add	r5, r0, r1
ldrb	r4, [r5, #0]
cmp	r4, #140	// 0x8c
bne	0x80ec640 // Essential, could be made b
b	0x80ec778


// Now this starts to become a fucking mess
t_ec640:
cmp	r4, #140	// 0x8c
bgt	t_ec650 // If removed it loops at the copyright screen
cmp	r4, #0
beq	0x80ec65e // Blank screen if removed
b	0x80ec732 // Working without this
//movs	r0, r0
.hword 0000 // gas would assemble it as an add r0, r0, #0
add	r0, #240	// 0xf0
lsl	r0, r0, #12

t_ec650:
cmp	r4, #141	// 0x8d
bne	0x80ec656 // Also loop on first screen
b	0x80ec7a4 // Doesn't seem needed

.incbin "FR.ro.gba",0xec656,0x1ca

// 80ec820
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

.incbin "FR.ro.gba",0xec864,0xf731c

t_swi_1:
// 0x1e3b80
swi 1 // RegisterRamReset
bx lr

//end:
// here is automatically added an incbin for the rest of the ROM


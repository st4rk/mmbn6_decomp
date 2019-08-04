/*
 * crt0 is mainly used to initialize the enveriorment used by the game
 * the code is usually written in ARM mode
 */


.arm

.org 0x080000D0

_init:
	MOV             R0, #0x12
	MSR             CPSR_cf, R0
	LDR             SP, [dword_80001EC]
	MOV             R0, #0x13
	MSR             CPSR_cf, R0
	LDR             SP, [dword_80001F0]
	MOV             R0, #0x1F
	MSR             CPSR_cf, R0
	LDR             SP, [dword_80001F4]
	LDR             R0, [dword_80001F8]
	LDR             R1, [dword_80001FC]
	STR             R1, [R0]
	LDR             R0, [dword_8000200]
	LDR             R1, [dword_8000204]
	STR             R1, [R0]
	MOV             R0, #0x3000000
	MOV             R1, #0x7E00
	BL              memset
	MOV             R0, #0x2000000
	MOV             R1, #0x40000
	BL              memset
	MOV             R0, #0x6000000
	MOV             R1, #0x18000
	BL              memset
	MOV             R0, #0x7000000
	MOV             R1, #0x400
	BL              memset
	MOV             R0, #0x5000000
	MOV             R1, #0x400
	BL              memset
	LDR             R0, [dword_8000208]
	LDR             R1, [dword_800020C]
	LDR             R2, [dword_8000210]
	BL              memcpy
	LDR             R0, [dword_8000214]
	MOV             LR, PC
	BX              R0      //; init_g_struct_unk_1_in_ewram
	LDR             R0, [dword_8000218]
	MOV             LR, PC
	BX              R0      //; copy_unk_data_after_g_struct
	LDR             R0, [dword_800021C]
	MOV             LR, PC
	BX              R0      //; sub_800023C
	LDR             R0, [dword_8000220]
	MOV             R1, #0
	STRB            R1, [R0]
	LDR             R0, [dword_8000224]
	MOV             R1, #1
	STR             R1, [R0]
	LDR             R0, [dword_8000228]
	MOV             R1, #0
	STR             R1, [R0]
	LDR             R0, [dword_800022C]
	MOV             R1, #8
	STRH            R1, [R0]
	LDR             R0, [dword_8000230]
	LDR             R1, [dword_8000234]
	STRH            R1, [R0]
	LDR             R0, [dword_8000238]
	BX              R0    //  ; sub_80002BC
    B 0x08000000

//; void *__fastcall memset(void *dst, unsigned int value)
memset:                                 // ; CODE XREF: _init+44↑p
                                        //; _init+50↑p ...
    MOV             R2, #0

loc_80001C8:                ///            ; CODE XREF: memset+C↓j
    SUBS            R1, R1, #4
    STR             R2, [R0,R1]
    BNE             loc_80001C8
    BX              LR

memcpy:

    SUBS            R2, R2, #4
    LDR             R3, [R0,R2]
    STR             R3, [R1,R2]
    BNE             memcpy
    BX              LR
; End of function memcpy

.pool
dword_80001EC:
   .word 0x3007F60           //; DATA XREF: _init+8↑r
dword_80001F0:
   .word 0x3007FE0 //          ; DATA XREF: _init+14↑r
dword_80001F4:
   .word 0x3007E00   //        ; DATA XREF: _init+20↑r
dword_80001F8:
   .word 0x3007FFC     //      ; DATA XREF: _init+24↑r
dword_80001FC:
   .word 0x3005B00       //    ; DATA XREF: _init+28↑r
dword_8000200:
   .word 0x4000204         //  ; DATA XREF: _init+30↑r
dword_8000204:
   .word 0x45B4             // ; DATA XREF: _init+34↑r
dword_8000208:
   .word 0x81D6000          // ; DATA XREF: _init+78↑r
dword_800020C:
   .word 0x3005B00  //         ; DATA XREF: _init+7C↑r
dword_8000210:
   .word 0x1ED0       //       ; DATA XREF: _init+80↑r
dword_8000214:
   .word 0x8006BC1      //     ; DATA XREF: _init+88↑r
dword_8000218:
   .word 0x8006C23        //   ; DATA XREF: _init+94↑r
dword_800021C:
   .word 0x800023D          // ; DATA XREF: _init+A0↑r
dword_8000220:
   .word 0x20081B0   //        ; DATA XREF: _init+AC↑r
dword_8000224:
   .word 0x2009930     //      ; DATA XREF: _init+B8↑r
dword_8000228:
   .word 0x200A870       //    ; DATA XREF: _init+C4↑r
dword_800022C:
   .word 0x4000004        //   ; DATA XREF: _init+D0↑r
dword_8000230:
   .word 0x4000132          // ; DATA XREF: _init+DC↑r
dword_8000234:
   .word 0x83FF            //  ; DATA XREF: _init+E0↑r
dword_8000238:
   .word 0x80002BD          // ; DATA XREF: _init+E8↑r


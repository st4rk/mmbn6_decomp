.include "core.inc"
.include "io.inc"

.org 0x080002BC

.thumb

main:                                    ; CODE XREF: _init+EC↑j
	; game engine initialization
    BL              engine_init
    BL              engine_init_rng
    BL              engine_clear_200AD04
    BL              capcom_logo_reset_struct_and_set_state

main_loop:                               ; CODE XREF: main+84↓j
    BL              engine_wait_vblank
    BL              engine_vblank_unk_1
    BL              engine_m4a_execute_list
    BL              fptr_200A888_80019A0__
    BL              engine_conf_lcd_io_for_rendering
    BL              engine_update_OAM_from_IWRAM
    BL              sub_8000A44
    BL              engine_update_iwram_palettes_and_unk
    BL              engine_update_BG_OBJ_bank1_from_IWRAM
    BL              engine_update_BG_OBJ_bank2_from_IWRAM
    BL              sub_800289C
    BL              engine_update_VRAM_bank_E000
    BL              engine_update_hid

    ; increment global timer 
    MOV             R0, R10
    LDR             R0, [R0,#0x24]
    LDRH            R1, [R0]
    ADD             R1, #1
    STRH            R1, [R0]

    ; game engine main jump table
    ; R1 will be the current state that we will execute
    BL              sub_8000E10
    LDR             R0, [main_game_jump_table_]
    MOV             R1, R10
    LDR             R1, [R1]
    LDRB            R1, [R1]
    LDR             R0, [R0,R1] ; R1 = index for the menu
    MOV             LR, PC
    BX              R0

    BL              engine_rng_update_seed
    BL              sub_800A732
    BEQ             loc_800032A
    BL              engine_fade_effect_routine

loc_800032A:                             ; CODE XREF: main+68↑j
    BL              sub_803FE88
    BL              fptr_200A888_8001994
    BL              sub_8001B94

    LDR             R0, [off_8000344]
    MOV             LR, PC
    BX              R0      ; dword_3006814
    BL              sub_8000454
    B               main_loop


.pool

off_8000344:
	.word 0x3006814+1     ; DATA XREF: main+7A↑r
main_game_jump_table_:
	.word main_game_jump_table ; DATA XREF: main+52↑r
main_game_jump_table:
	.word start_screen_state_machine+1
	.word in_game_state_machine+1
	.word jack_in_state_machine+1
	.word 0x8038AD0+1
	.word capcom_logo_state_machine+1 ; This is the state machine algo used to renderer the capcom logo when we boot the game
	.word 0x803FB10+1
	.word 0x8039578+1
	.word 0x803CB7A+1
	.word 0x803CCAA+1
	.word 0x813FE84+1
	.word game_start_state_machine+1
	.word game_shop_state_machine+1
	.word 0x8048FA4+1
	.word 0x804B0C8+1
	.word 0x813A088+1
	.word 0x0
	.word 0x0
	.word 0x81411E4+1
	.word 0x81297D4+1
	.word 0x8049DD4+1
	.word 0x804A362+1

; void __cdecl engine_vblank_unk_1()
engine_vblank_unk_1:                     ; CODE XREF: main+14↑p
                PUSH            {LR}

loc_80003A2:                             ; CODE XREF: engine_vblank_unk_1+16↓j
                LDR             R0, [DISPSTAT_]
                MOV             R2, #1

wait_for_vblank:                         ; CODE XREF: engine_vblank_unk_1+A↓j
                LDRH            R1, [R0]
                TST             R1, R2
                BEQ             wait_for_vblank
                LDR             R0, [off_80003C4]
                LDR             R2, [R0]
                LDR             R1, [off_80003C8]
                LDR             R1, [R1]
                CMP             R2, R1
                BLT             loc_80003A2
                MOV             R1, #0
                STR             R1, [R0]
                POP             {PC}
; End of function engine_vblank_unk_1

.pool
    .word 0x2009CC0
off_80003C4:
    .word 0x200A870       ; DATA XREF: engine_vblank_unk_1+C↑r
off_80003C8:
    .word 0x2009930       ; DATA XREF: engine_vblank_unk_1+10↑r
DISPSTAT_:
    .word DISPSTAT            ; DATA XREF: engine_vblank_unk_1:loc_80003A2↑r

engine_wait_vblank:                      ; CODE XREF: main:main_loop↑p
                PUSH            {LR}
                LDR             R0, [DISPSTAT_2]
                MOV             R2, #1

loc_80003D6:                             ; CODE XREF: engine_wait_vblank:loc_80003DA↓j
                LDRH            R1, [R0]
                TST             R1, R2

loc_80003DA:
                BNE             loc_80003D6
                POP             {PC}
; End of function engine_wait_vblank

.pool

DISPSTAT_2:
    .word DISPSTAT            ; DATA XREF: engine_wait_vblank+2↑r



engine_update_hid:                       ; CODE XREF: main+40↑p
                MOV             R7, R10
                LDR             R0, [R7,#4]
                LDRB            R7, [R0,#0x13]
                ADD             R7, #1
                CMP             R7, #4
                BLE             loc_80003F2
                MOV             R7, #0

loc_80003F2:                             ; CODE XREF: engine_update_hid+A↑j
                STRB            R7, [R0,#0x13]
                LDR             R4, [KEYINPUT_]
                LDRH            R4, [R4]
                MVN             R4, R4
                LDRH            R5, [R0]
                STRH            R5, [R0,#6]
                LDR             R3, [dword_8000450]
                STRH            R4, [R0]
                MOV             R6, R4
                AND             R6, R5
                MOV             R1, #8
                MOV             R3, #0

loc_800040A:                             ; CODE XREF: engine_update_hid+5A↓j
                MOV             R2, #1
                LSL             R2, R3
                AND             R2, R6
                BEQ             loc_800042A
                LDRB            R2, [R0,R1]
                CMP             R2, #0x10
                BGE             loc_8000430
                ADD             R2, #1
                STRB            R2, [R0,R1]
                CMP             R2, #1
                BEQ             loc_8000438

loc_8000420:                             ; CODE XREF: engine_update_hid+52↓j
                MOV             R2, #1
                LSL             R2, R3
                MVN             R2, R2
                AND             R6, R2
                B               loc_8000438
; ---------------------------------------------------------------------------

loc_800042A:                             ; CODE XREF: engine_update_hid+2C↑j
                MOV             R2, #0
                STRB            R2, [R0,R1]
                B               loc_8000438
; ---------------------------------------------------------------------------

loc_8000430:                             ; CODE XREF: engine_update_hid+32↑j
                LDRB            R7, [R0,#0x13]
                CMP             R7, #0
                BEQ             loc_8000438
                B               loc_8000420
; ---------------------------------------------------------------------------

loc_8000438:                             ; CODE XREF: engine_update_hid+3A↑j
                                        ; engine_update_hid+44↑j ...
                ADD             R3, #1
                ADD             R1, #1
                CMP             R1, #0x12
                BLT             loc_800040A
                STRH            R6, [R0,#4]
                MVN             R5, R5
                AND             R4, R5
                STRH            R4, [R0,#2]
                MOV             PC, LR
; End of function engine_update_hid

.pool

KEYINPUT_:
    .word KEYINPUT        ; DATA XREF: engine_update_hid+10↑r
dword_8000450:
    .word 0x3FF               ; DATA XREF: engine_update_hid+1A↑r


; void __fastcall engine_reboot_to_capcom_logo()
engine_reboot_to_capcom_logo:            ; CODE XREF: main+80↑p
                PUSH            {R4-R7,LR}
                BL              is_fade_effect_enabled
                BEQ             locret_80004A2
                BL              is_200BC55_set
                BNE             locret_80004A2
                MOV             R7, R10
                LDR             R0, [R7]
                LDRB            R0, [R0]
                CMP             R0, #0x10
                BEQ             locret_80004A2
                LDR             R0, [R7,#4]
                LDRH            R2, [R0,#2]
                LDRH            R0, [R0]
                LDR             R1, [R7]
                ADD             R1, #4
                LDRB            R4, [R1]
                SUB             R4, #1
                CMP             R4, #0
                BGT             loc_80004A0
                MOV             R4, #0
                MOV             R3, #0xF
                AND             R0, R3
                CMP             R0, R3
                BNE             loc_80004A0
                AND             R2, R3
                TST             R2, R2
                BEQ             loc_80004A0
                PUSH            {R1}
                BL              sub_800023C
                BL              engine_init
                BL              engine_clear_200AD04
                POP             {R1}
                MOV             R4, #0xA

loc_80004A0:                             ; CODE XREF: engine_reboot_to_capcom_logo+28↑j
                                        ; engine_reboot_to_capcom_logo+32↑j ...
                STRB            R4, [R1]

locret_80004A2:                          ; CODE XREF: engine_reboot_to_capcom_logo+6↑j
                                        ; engine_reboot_to_capcom_logo+C↑j ...
                POP             {R4-R7,PC}
; End of function engine_reboot_to_capcom_logo

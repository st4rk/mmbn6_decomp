.include "core.inc"

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
    BL              sub_80003E4

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

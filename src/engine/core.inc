; game engine functions to be disas

engine_init equ 0x080004A4
engine_init_rng equ 0x08001514
engine_clear_200AD04 equ 0x0803F49C 
engine_wait_vblank equ 0x080003D0
engine_vblank_unk_1 equ 0x080003A0
engine_m4a_execute_list equ 0x080007BE
fptr_200A888_80019A0__ equ 0x080019A0
engine_conf_lcd_io_for_rendering equ 0x0800172C 
engine_update_OAM_from_IWRAM equ 0x0802FE0C
sub_8000A44 equ 0x8000A44
engine_update_iwram_palettes_and_unk equ 0x80023E0
engine_update_BG_OBJ_bank1_from_IWRAM equ 0x8001808
engine_update_BG_OBJ_bank2_from_IWRAM equ 0x8002650
sub_800289C equ 0x800289C
engine_update_VRAM_bank_E000 equ 0x80015D0
sub_80003E4 equ 0x80003E4
engine_rng_update_seed equ 0x800154C
sub_800A732 equ 0x800A732
engine_fade_effect_routine equ 0x800630A
sub_803FE88 equ 0x803FE88
fptr_200A888_8001994 equ 0x08001994
sub_8001B94 equ 0x8001B94 
sub_8000454 equ 0x8000454
sub_8000E10 equ 0x8000E10

; variable, structures, object and whatever
in_game_state_machine equ 0x080050EC
jack_in_state_machine equ 0x080341B6
game_start_state_machine equ 0x08121550
game_shop_state_machine equ 0x08046CC8

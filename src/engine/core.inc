
engine_regenerate_rng equ 0x0800151C
engine_set_background_configuration equ 0x080015FC
engine_configure_display_controller equ 0x08001778
engine_reset_display_bg_0123_x_y_offset equ 0x08001788
engine_reset_display_mosaic_size equ 0x080017A0

engine_render_setup_fade_effect_struct equ 0x08006270
engine_setup_gfx_anim_unk equ 0x8002354

engine_update_oam_30068E8 equ 0x0802FE28

engine_init equ 0x080004A4
engine_init_rng equ 0x08001514
engine_clear_200AD04 equ 0x0803F49C 
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

engine_rng_update_seed equ 0x800154C
sub_800A732 equ 0x800A732
engine_fade_effect_routine equ 0x800630A
sub_803FE88 equ 0x803FE88
fptr_200A888_8001994 equ 0x08001994
sub_8001B94 equ 0x8001B94 
sub_8000454 equ 0x8000454
sub_8000E10 equ 0x8000E10
sub_800023C equ 0x800023C

;----------------------------------------
;      debug code found in the game
;----------------------------------------

engine_reset_charblock equ 0x080017AA
engine_reset_vram_bank_E000 equ 0x0800183C
debug_draw_text equ 0x080049FC
debug_draw_text_init equ 0x80049E0
debug_update_text_render equ 0x8004B28


;----------------------------------------
;   	   sound engnine
;----------------------------------------

m4a_push_into_index_63h equ 0x08000630
m4a_push_into_list equ 0x0800061E
m4a_choose_track_number equ 0x080005F2
m4a_play_sound_effect_channel_80005cc equ 0x80005CC
engine_m4a_play_track_channel_number equ 0x080005F2
engine_m4a_8000784 equ 0x08000784

;----------------------------------------
;           fade effect 
;----------------------------------------

is_fade_effect_enabled equ 0x080062F8
is_200BC55_set equ 0x0813F3EC

;----------------------------------------
;  variables/globals/structure/objects
;----------------------------------------

in_game_state_machine equ 0x080050EC
jack_in_state_machine equ 0x080341B6
game_start_state_machine equ 0x08121550
game_shop_state_machine equ 0x08046CC8

g_main_title_screen_dec_timer_and_update_state equ 0x0803E938



s_start_screen equ 0x0200AD10

;start_screen_state_setup equ 0x0802F574
;start_screen_state_conf_disp_and_title equ 0x0802F60C
;start_screen_state_main_title_state_machine equ 0x0802F63C
;start_screen_state_end equ 0x0802F756

start_screen_unk_0803FA16 equ 0x0803FA16
start_screen_unk_803F80C equ 0x0803F80C
start_screen_get_title_icons_info equ 0x08000EE4
start_screen_always_eq_valid equ 0x0803E904
start_screen_load_gfx equ 0x0802FCC0


start_screen_main_title_update_oam equ 0x0802FB10


; title screen sub state machine
;start_screen_main_title_setup equ 0x0802F668 
;start_screen_main_title_wait_fade_out equ 0x0802F6A4
;start_screen_main_title_show equ 0x0802F6B2 
;start_screen_main_title_option_select equ 0x0802F704
;start_screen_main_title_reboot_or_next_state equ 0x0802F710


title_screen_load_gregar_title_gfx equ 0x0802FD3C

start_screen_main_title_m4a_800068a equ 0x0800068A
g_main_title_screen_is_press_start_showing equ 0x0803E8FC

start_screen_unused_1 equ 0x0802FD54
main_title_check_button_new_game equ 0x0802F7E8 
main_title_press_start_blink equ 0x0802F88E

title_screen_handle_hid equ 0x0802F81C
title_screen_update_oam_and_draw_icons equ 0x0802F8D8
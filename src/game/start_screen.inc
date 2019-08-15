; function to be disas

start_screen_unk_0803FA16 equ 0x0803FA16
start_screen_unk_803F80C equ 0x0803F80C
start_screen_get_title_icons_info equ 0x08000EE4

start_screen_main_title_update_oam equ 0x0802FB10

title_screen_load_gregar_title_gfx equ 0x0802FD3C

start_screen_main_title_m4a_800068a equ 0x0800068A

start_screen_unused_1 equ 0x0802FD54
main_title_check_button_new_game equ 0x0802F7E8 
main_title_press_start_blink equ 0x0802F88E

title_screen_handle_hid equ 0x0802F81C
title_screen_update_oam_and_draw_icons equ 0x0802F8D8

read_200AD04_and_test equ 0x0803F4F8 
set_200AD06_to_78h equ 0x0803F4E0

; structure, variable etc
s_start_screen equ 0x0200AD10
g_main_title_screen_timer equ 0x0200B1A3
g_main_title_screen_state equ 0x0200B1A0
byte_200B1A2 equ 0x0200B1A2
byte_200B1A1 equ 0x0200B1A1
byte_200AD04 equ 0x0200AD04
word_200AD06 equ 0x0200AD06


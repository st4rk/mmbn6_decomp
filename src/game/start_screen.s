.include "start_screen.inc"


.thumb

; TODO: reverse 0x803E94C
; TODO: reverse 0x803E9F0
; TODO: EWRAM and IWRAM assembly files

.org 0x0803E90C

g_main_title_update_global:              ; CODE XREF: start_screen_state_machine+2↑p
                                        ; capcom_logo_state_machine+E↑p
                PUSH            {R4,LR}
                LDR             R4, [g_main_title_screen_state]
                LDRB            R0, [R4]
                CMP             R0, #1
                BEQ             loc_803E920
                CMP             R0, #2
                BEQ             loc_803E92C
                BL              g_main_title_screen_dec_timer_and_update_state
                B               locret_803E930

loc_803E920:                             ; CODE XREF: g_main_title_update_global+8↑j
                BL              0x803E94C
                BNE             locret_803E930
                MOV             R0, #2
                STRB            R0, [R4]
                B               locret_803E930
; ---------------------------------------------------------------------------

loc_803E92C:                             ; CODE XREF: g_main_title_update_global+C↑j
                BL              0x803E9F0

locret_803E930:                          ; CODE XREF: g_main_title_update_global+12↑j
                                        ; g_main_title_update_global+18↑j ...
                POP             {R4,PC}

.pool

g_main_title_screen_state:
	.word 0x0200B1A0


.org 0x0802F544

; void __fastcall start_screen_state_machine()
start_screen_state_machine:              ; DATA XREF: ROM:main_game_jump_table↑o
                PUSH            {R4-R7,LR}
                BL              g_main_title_update_global
                LDR             R5, [start_screen_structure]
                LDR             R0, [start_screen_jmp_table_]
                LDRB            R1, [R5]
                LDR             R0, [R0,R1] ; s_start_screen->state (field 0x0)
                MOV             LR, PC
                BX              R0
                BL              engine_regenerate_rng
                POP             {R4-R7,PC}


.pool
start_screen_jmp_table_:
	.word start_screen_jmp_table
                                        ; DATA XREF: start_screen_state_machine+8↑r
; void *start_screen_jmp_table[5]
start_screen_jmp_table:
	.word start_screen_state_setup+1
	.word start_screen_state_conf_disp_and_title+1
	.word start_screen_state_main_title_state_machine+1
	.word start_screen_state_end+1 ; We prepare to go to the next state
                                        ; in this case "in game". We will go
                                        ; to this state either via new game
                                        ; or via continue. So we have to initialize
                                        ; the game by two different ways.
; void *off_802F570
start_screen_structure:
	.word s_start_screen                ; DATA XREF: capcom_logo_go_to_start_screen+2↑r
                                        ; start_screen_state_machine+6↑r


start_screen_state_setup:                ; DATA XREF: ROM:start_screen_jmp_table↑o
                PUSH            {LR}
                MOV             R0, #0xB ; background_id
                BL              engine_set_background_configuration ; goes through a background configuration list
                                        ; and set the expected background configuration
                                        ; into lcd_bg_io_conf_200AC40
                LDR             R0, [start_screen_end_disp_data_] ; data
                BL              engine_configure_display_controller
                BL              engine_reset_display_bg_0123_x_y_offset ; init field8->fields partially to 0x0
                BL              engine_reset_display_mosaic_size
                BL              start_screen_load_gfx
                MOV             R0, #0xC ; index
                MOV             R1, #0xFF ; fade_cnt
                BL              engine_render_setup_fade_effect_struct
                BL              engine_m4a_8000784
                LDR             R0, [title_screen_greigar_anim]
                BL              engine_setup_gfx_anim_unk
                MOV             R0, #4
                STRB            R0, [R5]    ; 0x4 is the next state
                MOV             R0, #0
                STRB            R0, [R5,#2] ; no continue (we will check for it in the following functions)
                BL              start_screen_unk_0803FA16
                BL              start_screen_unk_803F80C
                BNE             loc_802F5BE
                MOV             R0, #1
                STRB            R0, [R5,#2]
                BL              start_screen_get_title_icons_info
                STRB            R0, [R5,#0xC] ; total achievements 
                STRH            R1, [R5,#0xA] ; flags for achievements, used to know which icon to draw

loc_802F5BE:                             ; CODE XREF: start_screen_state_setup+3C↑j
                LDRB            R0, [R5,#2]
                TST             R0, R0
                BNE             loc_802F5D4
                MOV             R6, #0
                MOV             R7, #1
                BL              start_screen_always_eq_valid
                BEQ             loc_802F5E2
                MOV             R0, #0
                MOV             R7, #2
                B               loc_802F5E2
; ---------------------------------------------------------------------------

loc_802F5D4:                             ; CODE XREF: start_screen_state_setup+4E↑j
                MOV             R6, #1
                MOV             R7, #2
                BL              start_screen_always_eq_valid
                BEQ             loc_802F5E2
                MOV             R6, #1
                MOV             R7, #3

loc_802F5E2:                             ; CODE XREF: start_screen_state_setup+58↑j
                                        ; start_screen_state_setup+5E↑j ...
                STRB            R6, [R5,#8]
                STRB            R7, [R5,#9]
                MOV             R0, #0
                STRB            R0, [R5,#3]
                POP             {PC}


.pool

title_screen_greigar_anim:
	.word title_screen_greigar_anim_         ; DATA XREF: start_screen_state_setup+26↑r
title_screen_greigar_anim_:    
	.word 0x802F350       ; DATA XREF: start_screen_state_setup+26↑o
    .word 0x802F3A0
    .word 0x802F3F0
    .word 0x802F440
    .word 0x802F490
    .word 0x802F4E0
    .word 0xFFFFFFFF

start_screen_state_conf_disp_and_title:  ; DATA XREF: ROM:0802F564↑o
                PUSH            {LR}
                LDR             R0, [start_screen_state_conf_fptr_]
                LDRB            R1, [R5,#1]
                LDR             R0, [R0,R1]
                MOV             LR, PC
                BX              R0
                POP             {PC}

.pool

start_screen_state_conf_fptr_:
	.word start_screen_state_conf_fptr
                                        ; DATA XREF: start_screen_state_conf_disp_and_title+2↑r
start_screen_state_conf_fptr:
	.word start_screen_init_disp_and_set_next_state+1

; void __cdecl start_screen_init_disp_and_set_next_state()
start_screen_init_disp_and_set_next_state:
                                        ; DATA XREF: ROM:start_screen_state_conf_fptr↑o
                PUSH            {LR}
                LDR             R0, [start_screen_disp_data_] ; data
                BL              engine_configure_display_controller
                MOV             R0, #8
                STRB            R0, [R5]
                MOV             R0, #0
                STRB            R0, [R5,#1]
                POP             {PC}

.pool

; int dword_802F638
start_screen_disp_data_:
	.word 0x1741              ; DATA XREF: start_screen_init_disp_and_set_next_state+2↑r

start_screen_state_main_title_state_machine: ; DATA XREF: ROM:0802F568↑o
                PUSH            {LR}
                LDR             R0, [start_screen_main_title_jmp_tbl_]
                LDRB            R1, [R5,#1]
                LDR             R0, [R0,R1]
                MOV             LR, PC
                BX              R0
                BL              start_screen_main_title_update_oam
                POP             {PC}

.pool

start_screen_main_title_jmp_tbl_:
    .word start_screen_main_title_jmp_tbl
                                        ; DATA XREF: start_screen_state_main_title_state_machine+2↑r
start_screen_main_title_jmp_tbl: 
	.word start_screen_main_title_setup+1
    .word start_screen_main_title_wait_fade_out+1
    .word start_screen_main_title_show+1
    .word start_screen_main_title_option_select+1
    .word start_screen_main_title_reboot_or_next_state+1 ; There are two situations for arriving here
                                        ; 1. Player didn't press anything and we ran
                                        ; out time(main_title_timer) so we need to
                                        ; reset and go back to CAPCOM screen.
                                        ; 2. Player select continue or new game so
                                        ; we need to go to the next state in start
                                        ; screen (not main title)

; void __fastcall start_screen_main_title_setup()
start_screen_main_title_setup:           ; DATA XREF: ROM:start_screen_main_title_jmp_tbl↑o
                PUSH            {LR}
                MOV             R0, #0
                STRB            R0, [R5,#0xE]
                STRB            R0, [R5,#0xF]
                LDR             R0, [title_screen_timer]
                STRH            R0, [R5,#4]
                MOV             R0, #1  ; track number
                BL              engine_m4a_play_track_channel_number
                MOV             R0, #0xA ; background_id
                BL              engine_set_background_configuration ; goes through a background configuration list
                                        ; and set the expected background configuration
                                        ; into lcd_bg_io_conf_200AC40
                LDR             R0, [title_screen_disp_conf] ; data
                BL              engine_configure_display_controller
                MOV             R0, #0
                STRB            R0, [R5,#6]
                BL              title_screen_load_gregar_title_gfx
                MOV             R0, #8  ; index
                MOV             R1, #0x10 ; fade_cnt
                BL              engine_render_setup_fade_effect_struct
                MOV             R0, #4
                STRB            R0, [R5,#1]
                POP             {PC}


.pool

title_screen_timer:  
	.word 0xA46               ; DATA XREF: start_screen_main_title_setup+8↑r
; int dword_802F6A0
title_screen_disp_conf:
	.word 0x1340              ; DATA XREF: start_screen_main_title_setup+18↑r

; void __cdecl start_screen_main_title_wait_fade_out()
start_screen_main_title_wait_fade_out:   ; DATA XREF: ROM:0802F658↑o
                PUSH            {R4,LR}
                BL              is_fade_effect_enabled
                BEQ             locret_802F6B0
                MOV             R0, #8
                STRB            R0, [R5,#1]

locret_802F6B0:                          ; CODE XREF: start_screen_main_title_wait_fade_out+6↑j
                POP             {R4,PC}


start_screen_main_title_show:            ; DATA XREF: ROM:0802F65C↑o
                PUSH            {R4,LR}
                LDRH            R0, [R5,#4]
                CMP             R0, #0
                BGT             loc_802F6C8
                MOV             R0, #0x10
                STRB            R0, [R5,#1]
                MOV             R0, #0xC ; index
                MOV             R1, #0x10 ; fade_cnt
                BL              engine_render_setup_fade_effect_struct
                B               locret_802F6FA
; ---------------------------------------------------------------------------

loc_802F6C8:                             ; CODE XREF: start_screen_main_title_show+6↑j
                SUB             R0, #1
                STRH            R0, [R5,#4]
                LDR             R1, [title_screen_show_timer_1]
                CMP             R0, R1
                BNE             loc_802F6E0
                PUSH            {R0,R5}
                MOV             R0, #0x1F
                MOV             R1, #0x10
                BL              start_screen_main_title_m4a_800068a
                POP             {R0,R5}
                B               locret_802F6FA
; ---------------------------------------------------------------------------

loc_802F6E0:                             ; CODE XREF: start_screen_main_title_show+1E↑j
                LDRH            R0, [R5,#4]
                LDR             R1, [title_screen_show_timer_2]
                CMP             R0, R1
                BGE             locret_802F6FA
                BL              g_main_title_screen_is_press_start_showing
                BNE             locret_802F6FA
                BL              start_screen_unused_1
                BL              main_title_check_button_new_game
                BL              main_title_press_start_blink

locret_802F6FA:                          ; CODE XREF: start_screen_main_title_show+14↑j
                                        ; start_screen_main_title_show+2C↑j ...
                POP             {R4,PC}

.pool

title_screen_show_timer_1:
	.word 0x12C               ; DATA XREF: start_screen_main_title_show+1A↑r
title_screen_show_timer_2:
    .word 0xA0A               ; DATA XREF: start_screen_main_title_show+30↑r

start_screen_main_title_option_select:
	PUSH               {LR}
	BL 				   title_screen_handle_hid
	BL                 title_screen_update_oam_and_draw_icons
	POP                {LR}

; There are two situations for arriving here
; 1. Player didn't press anything and we ran
; out time(main_title_timer) so we need to
; reset and go back to CAPCOM screen.
; 2. Player select continue or new game so
; we need to go to the next state in start
; screen (not main title)

start_screen_main_title_reboot_or_next_state: ; DATA XREF: ROM:0802F664↑o
                PUSH            {LR}
                LDRH            R0, [R5,#4]
                CMP             R0, #0
                BLE             loc_802F71C
                BL              title_screen_update_oam_and_draw_icons

loc_802F71C:                             ; CODE XREF: start_screen_main_title_reboot_or_next_state+6↑j
                BL              is_fade_effect_enabled
                BEQ             locret_802F754
                LDRH            R0, [R5,#4]
                CMP             R0, #0
                BLE             loc_802F72E
                MOV             R0, #0xC
                STRH            R0, [R5]
                B               locret_802F754
; ---------------------------------------------------------------------------

loc_802F72E:                             ; CODE XREF: start_screen_main_title_reboot_or_next_state+16↑j
                BL              reset_20094C0
                BL              reset_20097A0
                BL              capcom_logo_reset_struct_and_set_state_
                BL              engine_interrupt_handle_and_serial_control_unk
                BL              reset_200BC50
                BL              engine_clear_200AD04
                MOV             R0, #0
                BL              0x803F684 ; TODO: reversed it
                BL              set_200AD06_to_78h_0
                BL              main_title_screen_init_gState_and_timer

locret_802F754:                          ; CODE XREF: start_screen_main_title_reboot_or_next_state+10↑j
                                        ; start_screen_main_title_reboot_or_next_state+1C↑j
                POP             {PC}

; We prepare to go to the next state
; in this case "in game". We will go
; to this state either via new game
; or via continue. So we have to initialize
; the game by two different ways.

start_screen_state_end:                  ; DATA XREF: ROM:0802F56C↑o
                PUSH            {LR}
                MOV             R7, R10
                LDR             R0, [R7]
                MOV             R1, #4
                STRB            R1, [R0]
                LDR             R0, [start_screen_end_disp_data_] ; data
                BL              engine_configure_display_controller
                BL              reset_200BC50
                LDRB            R0, [R5,#8]
                CMP             R0, #0
                BEQ             loc_802F776
                CMP             R0, #1
                BEQ             loc_802F79A
                B               loc_802F7B6
; ---------------------------------------------------------------------------

loc_802F776:                             ; CODE XREF: start_screen_state_end+18↑j
                BL              0x800260C
                BL              in_game_world_init_struct_and_unk_1
                BL              in_game_world_init_struct_and_unk_2
                BL              engine_interrupt_handle_and_serial_control_unk
                BL              0x814B194
                LDRB            R0, [R5,#2]
                TST             R0, R0
                BEQ             locret_802F7E0
                MOV             R0, #0x17
                MOV             R1, #4
                BL              0x802F110
                B               locret_802F7E0
; ---------------------------------------------------------------------------

loc_802F79A:                            ; CODE XREF: start_screen_state_end+1C↑j
                LDRB            R0, [R5,#2]
                TST             R0, R0
                BEQ             loc_802F7B6
                BL              in_game_world_init_struct_and_unk_2
                MOV             R0, #0x17
                MOV             R1, #4
                BL              0x802F110
                BL              engine_interrupt_handle_and_serial_control_unk
                BL              0x814B194
                B               locret_802F7E0
; ---------------------------------------------------------------------------

loc_802F7B6:                            ; CODE XREF: start_screen_state_end+1E↑j
                                        ; start_screen_state_end+48↑j
                MOV             R0, #0
                BL              0x813F6EC
                BL              in_game_world_init_struct_and_unk_2
                BL              0x8039544
                BL              0x803EB80
                MOV             R0, #0xC
                BL              0x803EA44
                LDRB            R0, [R5,#2]
                TST             R0, R0
                BEQ             loc_802F7DC
                MOV             R0, #0x17
                MOV             R1, #4
                BL              0x802F110

loc_802F7DC:                            ; CODE XREF: start_screen_state_end+7C↑j
                BL              engine_interrupt_handle_and_serial_control_unk

locret_802F7E0:                          ; CODE XREF: start_screen_state_end+38↑j
                                        ; start_screen_state_end+42↑j ...
                POP             {PC}

.pool

start_screen_end_disp_data_:
	.word 0x1140              ; DATA XREF: start_screen_state_setup+8↑r
                                        ; start_screen_state_end+A↑r

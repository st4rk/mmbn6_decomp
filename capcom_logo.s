.include "global.inc"
.include "capcom_logo.inc"

.thumb

.org 0x080005F2


; create a s_m4a_sound_node and push it into the list
; I believe it's used to play sound/music, I haven't digged deep
; the first argument R0 is the index in the list, it needs to be a value
; around 0x0 ~ 0x20
; r0 = index
; r1 = toolkit
; r2 = ?? (the data that will be played? I need to brekapoitn and check)
; r3 = pointer to function that will dispatch the node
capcom_logo_sounds_setup_80005F2:        ; CODE XREF: capcom_logo_state_setup+3C↓p
  PUSH            {R1-R7,LR}
  MOV             R7, R10
  LDR             R7, [R7,#0x3C]
  STRB            R0, [R7,#0xF]
  CMP             R0, #0x63 ; 'c'
  BNE             loc_8000604
  BL              m4a_push_into_index_63h
  B               locret_8000608
loc_8000604:                             ; CODE XREF: capcom_logo_sounds_setup_80005F2+A↑j
  BL              m4a_push_into_list
locret_8000608:                         ; CODE XREF: capcom_logo_sounds_setup_80005F2+10↑j
  POP             {R1-R7,PC}

.org 0x0803D17C


; We memset zero capcom_logo_structure (initialize it)
; We set the toolkit->state to 0x10 (Capcom Logo), so we will execute Capcom Logo State Machine
capcom_logo_reset_struct_and_set_state:  ; CODE XREF: main+C↑p
                                      ; sub_80004A4+B4↑p
  MOV             R0, #1
  B               loc_803D182

loc_803D180:                ; CODE XREF: sub_8005E54+28↑p
                          ; sub_8038A9C+26↑p ...
  MOV             R0, #0

loc_803D182:                             ; CODE XREF: capcom_logo_reset_struct_and_set_state+2↑j
  PUSH            {R4-R7,LR}
  PUSH            {R0}
  LDR             R0, [capcom_logo_structure] ; dst
  MOV             R1, #8  ; size
  BL              ZeroFill
  POP             {R0}
  LDR             R1, [capcom_logo_structure] ; 8 bytes size, seems to be used by menu?
  STRB            R0, [R1,#5]
  MOV             R1, R10
  LDR             R1, [R1]
  MOV             R0, #0x10                   ; this is the next state
  STRB            R0, [R1]
  POP             {R4-R7,PC}


; This is the capcom logo main state machine
; We have four states:
; 0x0 = Setup 
; 0x4 = Configure Timer 
; 0x8 = We are fading out and after it, we wait a "timer" for capcom logo
; 0xC = We fade out to start screen 
; 0x10 = We are done, load start screen state 
capcom_logo_state_machine:
  PUSH            {R4-R7,LR}
  LDR             R5, [capcom_logo_structure] ; 8 bytes size, seems to be used by menu?
  LDR             R0, [capcom_logo_jmp_tbl]
  LDRB            R1, [R5] ; R1 = s_capcom_logo->state
  LDR             R0, [R0,R1] ; R0 = capcom_logo_jmp_tbl[s_capcom_logo->state]
  MOV             LR, PC
  BX              R0
  BL              0x803E90C
  POP             {R4-R7,PC}

.pool

; capcom logo jump table 
capcom_logo_jmp_tbl: 
  .word jmp_tbl_capcom_logo_render
jmp_tbl_capcom_logo_render:
  .word capcom_logo_state_setup+1
  .word capcom_logo_state_conf_logo_tmr+1
  .word capcom_logo_state_wait_fade_in_and_logo_tmr+1
  .word capcom_logo_state_wait_fade_out+1
  .word capcom_logo_state_end+1
capcom_logo_structure: 
  .word s_capcom_logo

;
; We configurate the display information
; Reset the data in IWRAM, VRAM and so on
; We load the graphics 
; We setup the fade effect (fade in/fade out)
; We initialize some m4a node list
; Set the capcom logo state to configurate timer

capcom_logo_state_setup:                 ; DATA XREF: ROM:jmp_tbl_capcom_logo_render↑o
  PUSH            {LR}
  MOV             R0, #0xE ; background_id
  BL              set_background_configuration ; (will store 0x3D033C08 and 0x3F053E02)
  MOV             R4, #0xC
  LDR             R0, [disp_cnt_one_dimension]
  LDRB            R1, [R5,#5] ; R1 = s_capcom_logo->disp_cnt_state
  TST             R1, R1  ; check if field_5 != 0
  BEQ             is_disp_cnt_state_set
  MOV             R4, #4
  LDR             R0, [disp_cnt_fast_vram_access_and_one_dimension] ; data

is_disp_cnt_state_set:                   ; CODE XREF: capcom_logo_state_setup+10↑j
  BL              configure_display_controller
  BL              reset_display_bg_0123_x_y_offset ; init field8->fields partially to 0x0
  BL              reset_display_mosaic_size
  MOV             R0, R4  ; result
  MOV             R1, #0xFF ; a2
  BL              render_setup_fade_effect_struct
  BL              reset_rendering
  BL              reset_IWRAM_struct_unk_8005F6C
  BL              init_2009A8A9_80027C4
  BL              capcom_logo_state_init_gfx
  MOV             R0, #0x63 ; 'c'
  BL              capcom_logo_sounds_setup_80005F2
  MOV             R0, #CAPCOM_LOGO_STATE_CONF_TMR
  STRB            R0, [R5] ; s_capcom_logo->state = 0x4
  POP             {PC}
; End of function capcom_logo_state_setup

.pool

disp_cnt_one_dimension:
  .word 0x40        
disp_cnt_fast_vram_access_and_one_dimension:
  .word 0xC0

; This function is quite straighforward, we do some configuration in
; fade effect setup (I still need to figure it out, but I'm assuming)
; this is when you go back to capcom logo from start screen
; After it, we load capcom struct with the CAPCOM LOGO timer value (0xB4)
; Finally we set the next state for capcom to fade out and wait timer

capcom_logo_state_conf_logo_tmr:         ; DATA XREF: ROM:0803D1BC↑o
  PUSH            {LR}
  LDR             R0, [disp_data_conf_logo_tmr] ; data
  BL              configure_display_controller
  MOV             R0, #8
  LDRB            R1, [R5,#5]
  TST             R1, R1
  BEQ             loc_803D232
  MOV             R0, #0  ; result

loc_803D232:                             ; CODE XREF: capcom_logo_state_conf_logo_tmr+E↑j
  MOV             R1, #8  ; a2
  BL              render_setup_fade_effect_struct
  MOV             R0, #CAPCOM_LOGO_WAIT_TMR
  STRB            R0, [R5,#4]
  MOV             R0, #CAPCOM_LOGO_STATE_IN_TMR
  STRB            R0, [R5]
  POP             {PC}
; End of function capcom_logo_state_conf_logo_tmr

.pool

disp_data_conf_logo_tmr:
.word 0x1F40              ; DATA XREF: capcom_logo_state_conf_logo_tmr+2↑r

; This function will wait the fade effect to be over
; Once it's over, we will decrement the CAPCOM LOGO timer
; Once Capcom Logo timer reaches 0, we will configurate fade effect
; and set thet next state to fade out
capcom_logo_state_wait_fade_in_and_logo_tmr: ; DATA XREF: ROM:0803D1C0↑o
  PUSH            {LR}
  BL              is_fade_effect_enabled
  BEQ             locret_803D266
  LDRB            R0, [R5,#4]
  SUB             R0, #1
  STRB            R0, [R5,#4]
  CMP             R0, #0
  BGT             locret_803D266
  MOV             R0, #0xC ; index
  MOV             R1, #0x10 ; fade_cnt
  BL              render_setup_fade_effect_struct
  MOV             R0, #CAPCOM_LOGO_STATE_FADE_OUT
  STRB            R0, [R5]

locret_803D266:                          ; CODE XREF: capcom_logo_state_wait_fade_in_and_logo_tmr+6↑j
                          ; capcom_logo_state_wait_fade_in_and_logo_tmr+10↑j
  POP             {PC}

.pool

capcom_logo_data_unk:
    .word 0x3FF

; We just wait the fade effect to be over
; once it's over, we set the state to end
capcom_logo_state_wait_fade_out:
  PUSH            {LR}
  BL              is_fade_effect_enabled
  BEQ             locret_803D278
  MOV             R0, #CAPCOM_LOGO_STATE_END_
  STRB            R0, [R5]

locret_803D278:
  POP             {PC}

; We configurate displayer with 0x40 value (DISPCNT)
; We jump into capcom logo start screen that will reset capcom start screen structure
; And set toolkit state to 0x0 (start screen)
capcom_logo_state_end:
  PUSH            {LR}
  LDR             R0, [capcom_logo_w_fade_out_disp_cnt]
  BL              configure_display_controller
  BL              capcom_logo_go_to_start_screen
  POP             {PC}

.pool

capcom_logo_w_fade_out_disp_cnt:
  .word 0x40

; This function will reset the VRAM banks (memset) and a GFX information in IWRAM
; After it, we will go through a list of "bitmap" (graphic + palette), decompress (if decompressed)
; And copy them into their destination memory
; It'll load capcom logo graphic+palette, licensed by graphic+palette
; and more unknown stuff that I didn't check yet
capcom_logo_state_init_gfx:             ; CODE XREF: capcom_logo_state_setup+36↑p
  PUSH            {R4-R7,LR}
  BL              reset_vram_banks
  BL              reset_gfx_related
  LDR             R0, [off_803D2C0] ; address for capcom logo
  BL              parse_bitmap_list ; it'll get a "bitmap list"
  MOV             R0, #0
  MOV             R1, #0
  MOV             R2, #1
  LDR             R3, [capcom_logo_unk_1+0x8] ; palette color compressed for capcom logo
  ADD             R3, #4
  MOV             R4, #0x20 ; ' '
  MOV             R5, #0x14
  BL              fptr_300E580 ; non standard GCC calling conv
  MOV             R0, #8
  MOV             R1, #0x11
  MOV             R2, #2
  LDR             R3, [capcom_logo_unk_2]
  MOV             R4, #0xE
  MOV             R5, #1
  BL              fptr_300E580 ; non standard GCC calling conv
  POP             {R4-R7,PC}

.pool

off_803D2C0:
  .word capcom_logo_logo    ; DATA XREF: capcom_logo_state_init_gfx+A↑r
                                        ; address for capcom logo
capcom_logo_logo:
  .word 0x886C1474
  .word 0x6000020
  .word 0x2014A00

capcom_logo_unk_1:
  .word 0x886C1DE0
  .word 0
  .word 0x2013A00

capcom_logo_logo_palette_:
  .word 0x86C1BE0
  .word 0x3001960
  .word 0x20

capcom_logo_licensed_by:
  .word 0x86C1F20
  .word 0x6001000
  .word 0x1C0

capcom_logo_licensed_by_palette:
  .word 0x86C20E0
  .word 0x3001980
  .word 0x20
     
    .word 0
capcom_logo_unk_2:
  .word 0x086C2100

.org 0x0802F530

; Reset Start Screen Structure and set toolkit state
; Into start screen
capcom_logo_go_to_start_screen:
  PUSH            {LR}
  LDR             R0, [0x0802F570]
  MOV             R1, #0x20
  BL              ZeroFill ; memset_zero start screen structure
  MOV             R1, R10
  LDR             R1, [R1]
  MOV             R0, #0   ; toolkit->state = GAME_STATE_START_SCREEN
  STRB            R0, [R1]
  POP             {PC}
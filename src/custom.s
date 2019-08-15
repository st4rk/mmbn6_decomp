.thumb

; we have around ~7kb free space here for whatever we want


; game and engine hooks

.org 0x08000336 ; <-- main game engine loop hook

; game engine main loop hook
.org 0x08000344
_hook_1:
	.word _hook_engine_main_loop+1

.org 0x08006CA0
; game engine init hook
_hook_2:
	.word _hook_engine_init+1

.org 0x087FE36C

_hook_engine_init:
	PUSH {LR}

	; do exactly what the hook would do
	LDR R3, [_memcpy_2]
	MOV LR, PC
	BX  R3

	PUSH {R0-R7}

	; initialize debug string
	LDR R3, [_debug_draw_text_init]
	MOV LR, PC
	BX  R3


	POP {R0-R7}

	POP {PC}

.pool

_memcpy_2:
	.word 0x080014ED
_debug_draw_text_init:
	.word debug_draw_text_init+1


draw_text_entrypoint:
  PUSH {LR}

  LDR R7, [_draw_text]
  BX  R7

  POP  {PC}

; this is a hook in the end of main game loop
_hook_engine_main_loop:
  ; we do our custom code
  PUSH          {LR}

  ; run same code as expected
  LDR R0, [_unk_address]
  MOV LR, PC
  BX  R0

  ; store the registers in stack and let's do some stuff

  PUSH {R0-R7}
/*
_check_right:
  MOV R7, R10
  LDR R7, [R7, #0x4]
  LDRH R0, [R7, #0x2]
  MOV R1, #0x10
  TST R1, R0
  BEQ _check_left

  ; get track number, increment
  LDR R7, [track_number]
  LDR R0, [R7]
  ADD R0, R0, #0x1
  STR R0, [R7]


  B _play_track

_check_left:
  MOV R7, R10
  LDR R7, [R7, #0x4]
  LDRH R0, [R7, #0x2]
  MOV R1, #0x20
  TST R1, R0
  BEQ _end

  ; get track number, decrement
  LDR R7, [track_number]
  LDR R0, [R7]
  SUB R0, R0, #0x1
  STR R0, [R7]

_play_track:

  ; now we update the draw rendering
  LDR R7, [play_track]
  MOV LR, PC
  BX  R7
*/
_end:

  ; arguments
  LDR R0, =_text_test
  LDR R1, [in_game_state]
  LDRB R1, [R1]
  MOV R2, #0x0
  MOV R3, #0x0
  
  ; draw text 
  BL draw_text_entrypoint

  LDR R1, [set_zenny]
  MOV R0, #0x37
  MOV LR, PC
  BX R1


  ; get zenny
  LDR R0, [get_zenny]
  MOV LR, PC
  BX  R0
  MOV R1, R0

  ; arguments
  LDR R0, =_text_test2
  MOV R2, #0x0
  MOV R3, #0x0
  
  ; draw text 
  BL draw_text_entrypoint

  ; now we update the draw rendering
  LDR R7, [_update_text_rendering]
  MOV LR, PC
  BX  R7


  ; update rendering
  POP {R0-R7}

  POP           {PC}

.pool

set_zenny:
  .word 0x0803D001
get_zenny:
  .word 0x0803D041
in_game_state:
	.word 0x02001B80
toolkit_state:
	.word 0x0200A480
track_number:
	.word 0x0200A2A0
play_track:
	.word m4a_choose_track_number+1
_unk_address:
	.word 0x03006815
_draw_text:
	.word debug_draw_text+1
_update_text_rendering:
	.word debug_update_text_render+1

; how to get text rendering
; print_debug_text is the main function to print an ASCII text
; format:
; 1 byte - X
; 2 byte - y
; N bytes - String, print until null terminator
; we need to *always* call update_debug_print_render to draw

_text_test:
	.byte 0x0  ; y pos
	.byte 0x0
;	.byte 0x13  ; x pos

	.ascii "HACKED BY SHUFFLE2"
	.byte 0x0	
	.byte 0x0

_text_test2:
	.byte 0x0
	.byte 0x1

	.ascii "CURRENT ZENNY: %X"
	.byte 0
	.byte 0

;
;.byte 0xA
;.byte 0x6

;.word 0x44434241
;.word 0x48474645
;.byte 0x0
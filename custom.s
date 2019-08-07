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

  ; arguments
  LDR R0, =_text_test
  MOV R1, #0x0
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
	.byte 0x4  ; y pos
	.byte 0x6  ; x pos

	.ascii "PERFECT :D"
	.byte 0x0	




;
;.byte 0xA
;.byte 0x6

;.word 0x44434241
;.word 0x48474645
;.byte 0x0
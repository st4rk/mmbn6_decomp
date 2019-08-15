.gba

.relativeinclude on
.open "base.gba", "output_base.gba", 0x08000000

; <---------------------------------------
; all engine code should be included here!
; <---------------------------------------

; it will initialize the gba hardware enveriorment
; and jump into the main engine functino
crt0:
	.include "src/engine/crt0.s"

core:
	.include "src/engine/core.s"

; <---------------------------------------
; all game code should be included here!
; <---------------------------------------

; capcom logo state, its the first state to run
; after to initialize the game engine

capcom_logo:
	; .text implementation
	.include "src/game/capcom_logo.s"
	; .data used by capcom logo state
	.include "src/game/capcom_logo_gfx.s"

start_screen:
	; .text implementation
	.include "src/game/start_screen.s"

	; .data used by start screen and title screen state machines
	.include "src/game/start_screen_gfx.s"

; only uncomment that line if you want to build
; custom code hooks into the game engine
custom_code:
	; custom code for rom hacking
	;.include "src/custom.s"
	
.close


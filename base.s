.gba

.open "base.gba", "output_base.gba", 0x08000000


; it will initialize the gba hardware enveriorment
; and jump into the main engine functino
crt0:
	.include "crt0.s"

; capcom logo state, it's the first state to run
; after to initialize the game engine

capcom_logo:
	; .text implementation
	.include "capcom_logo.s"
	; .data used by capcom logo state
	.include "capcom_logo_gfx.s"

.close


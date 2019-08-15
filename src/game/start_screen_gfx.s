; some graphics are compressed (LZ77)
; TODO: decompress->compress tool so we can import and modify them properly

.org 0x87F2C20

; title screen copyright color palette
.incbin "../../graphics/title_screen/title_screen_capcom_copyright_palette.bin"

.org 0x87F216C

; title screen font palette
.incbin "../../graphics/title_screen/title_screen_font_palette.bin"

.org 0x87F2E40

; title screen bg palette
.incbin "../../graphics/title_screen/title_screen_bg_palette.bin"

.org 0x86A280C

; title screen arrow bitmap
.incbin "../../graphics/title_screen/title_screen_arrow.bin"

.org 0x86A344C

; title screen arrow palette
.incbin "../../graphics/title_screen/title_screen_arrow_palette.bin"

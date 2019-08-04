; all state used by the CAPCOM LOGO state machine
CAPCOM_LOGO_STATE_SETUP_ equ 0x0
CAPCOM_LOGO_STATE_CONF_TMR equ 0x4
CAPCOM_LOGO_STATE_IN_TMR equ 0x8
CAPCOM_LOGO_STATE_FADE_OUT equ 0xC
CAPCOM_LOGO_STATE_END_ equ 0x10


; how long it will wait in the CAPCOM logo to go to the out
CAPCOM_LOGO_WAIT_TMR equ 0xB4

; capcom logo structure
s_capcom_logo equ 0x02011800

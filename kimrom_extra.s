.segment "EXTRA"

; ----------------------------------------------------------------------------
; SYS - Jump to an address
; ----------------------------------------------------------------------------
SYS:
        jsr     FRMNUM
        jsr     GETADR
       
        ; Emulate an indirect JSR
        lda     #>SYS_RETADR
        pha
        lda     #<SYS_RETADR
        pha
        jmp     (LINNUM)

SYS_RETADR = *-1
        rts

; --------------------------------------------------------------------------
; CLS - Clear terminal with a form feed 
FF      := $0C
CLS:
        lda     #FF
        jmp     MONCOUT         ; will rts for us

; ---------------------------------------------------------------------------
; GET_UPPER - Support case insensitive keywords.  Copied from the KBD port
GET_UPPER:
        lda     INPUTBUFFERX,x
LF430:
        cmp     #'a'
        bcc     LF43A
        cmp     #'z'+1
        bcs     LF43A
LF438:
        sbc     #$1F
LF43A:
        rts

; ---------------------------------------------------------------------------
; CHKDEL - Make DEL work like BS
;
; Because the KIM-1 uses DEL/RUBOUT to determine TTY baud rate, the user 
; TTY needst to be reconfigured to send DEL rather than BS.  This converts a 
; DEL into a BS and writes the BS back to the TTY to have the same behavior as 
; if a BS was received in the first place.
DEL     := $7F
BS      := $08
CHKDEL:
        cmp     #DEL
        bne     CHKDELX
        lda     #BS
        jsr     MONCOUT         ; Clobbers A
        lda     #BS
CHKDELX:
        rts

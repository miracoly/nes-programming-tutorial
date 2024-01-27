.segment "HEADER"                   ; Don’t forget to always add the iNES header to your ROM files
.org $7FF0
.byte $4E,$45,$53,$1A,$02,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

.segment "CODE"                     ; Define a segment called "CODE" for the PRG-ROM at $8000
.org $8000

Reset:
    cld
    lda #1                          ; Load the A register with the decimal value 1
    ldx #2                          ; Load the X register with the decimal value 2
    ldy #3                          ; Load the Y register with the decimal value 3

    inx                             ; Increment X
    iny                             ; Increment Y

    clc
    adc #1                          ; Increment A

    dex                             ; Decrement X
    dey                             ; Decrement Y

    sec
    sbc #1                          ; Decrement A

NMI:                                ; NMI handler
    rti                             ; doesn't do anything
IRQ:                                ; IRQ handler
    rti                             ; doesn't do anything
.segment "VECTORS"                  ; Add addresses with vectors at $FFFA
.org $FFFA
.word NMI                           ; Put 2 bytes with the NMI address at memory position $FFFA
.word Reset                         ; Put 2 bytes with the break address at memory position $FFFC
.word IRQ                           ; Put 2 bytes with the IRQ address at memory position $FFFE

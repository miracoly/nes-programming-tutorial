;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; INES Header (https://www.nesdev.org/wiki/INES)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.segment "HEADER"
.org $7FF0
.byte $4E,$45,$53,$1A               ; NES\n
.byte $02                           ; 2x 16KB = 32KB PRG ROM
.byte $01                           ; 1x 8KB CHR ROM
.byte %00000000                     ; Flag 6
.byte %00000000                     ; Flag 7
.byte $00                           ; PRG RAM
.byte $00                           ; NTSC TV Format
.byte $00                           ; No PRG-RAM
.byte $00,$00,$00,$00,$00           ; Unused padding

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; PRG-ROM
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.segment "CODE"
.org $8000

RESET:
    sei                             ; disable all IRQ interrupts
    cld                             ; clear decimal mode
    ldx #$ff
    txs                             ; initialize stack pointer at $01FF

    lda #$00
    inx
MemLoop:
    sta $00,x
    dex
    bne MemLoop

NMI:
    rti

IRQ:
    rti

.segment "VECTORS"
.org $FFFA
.word NMI                           ; address of NMI handler
.word RESET                         ; address of RESET handler
.word IRQ                           ; address of IRQ handler

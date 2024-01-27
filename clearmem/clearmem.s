;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; INES Header (https://www.nesdev.org/wiki/INES)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.segment "HEADER"
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

RESET:
    sei                             ; disable all IRQ interrupts
    cld                             ; clear decimal mode
    ldx #$ff
    txs                             ; initialize stack pointer at $01FF

    inx                             ; Roll-off from $FF to $00
    txa                             ; A = 0
ClearRam:
    sta $0000,X                     ; Clear RAM from $0000 to $00FF
    sta $0100,X                     ; Clear RAM from $0100 to $01FF
    sta $0200,X                     ; Clear RAM from $0200 to $02FF
    sta $0300,X                     ; Clear RAM from $0300 to $03FF
    sta $0400,X                     ; Clear RAM from $0400 to $04FF
    sta $0500,X                     ; Clear RAM from $0500 to $05FF
    sta $0600,X                     ; Clear RAM from $0600 to $06FF
    sta $0700,X                     ; Clear RAM from $0700 to $07FF
    inx
    bne ClearRam

LoopForever:
    jmp LoopForever

NMI:
    rti

IRQ:
    rti

.segment "VECTORS"
.word NMI                           ; address of NMI handler
.word RESET                         ; address of RESET handler
.word IRQ                           ; address of IRQ handler

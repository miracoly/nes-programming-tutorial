.include "const.inc"
.include "header.inc"
.include "reset.inc"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; PRG-ROM
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.segment "CODE"

reset:
    INIT_NES

main:
    bit PPU_STATUS
    ldx #$3F
    stx PPU_ADDR
    ldx #$00
    stx PPU_ADDR

    jsr load_palette

    lda #%00011110
    sta PPU_MASK

loop_forever:
    jmp loop_forever

.proc load_palette
    ldy #0
@loop:
    lda palette_data,Y              ; Lookup byte in ROM
    sta PPU_DATA
    iny
    cpy #32
    bne @loop                          ; jump if Y == 32?
    rts
.endproc

nmi:
    rti

irq:
    rti

palette_data:
.byte $0F,$2A,$0C,$3A               ; Background
.byte $0F,$2A,$0C,$3A
.byte $0F,$2A,$0C,$3A
.byte $0F,$2A,$0C,$3A

.byte $0F,$2A,$0C,$26               ; Sprites
.byte $0F,$2A,$0C,$26
.byte $0F,$2A,$0C,$26
.byte $0F,$2A,$0C,$26

.segment "VECTORS"
.word nmi                           ; address of NMI handler
.word reset                         ; address of RESET handler
.word irq                           ; address of IRQ handler

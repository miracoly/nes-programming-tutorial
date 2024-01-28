.include "../const.inc"
.include "../header.inc"
.include "../reset.inc"

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

    lda #$2A
    sta PPU_DATA

    lda #%00011110
    sta PPU_MASK

loop_forever:
    jmp loop_forever

nmi:
    rti

irq:
    rti

.segment "VECTORS"
.word nmi                           ; address of NMI handler
.word reset                         ; address of RESET handler
.word irq                           ; address of IRQ handler

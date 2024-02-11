;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Initialize NES
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.macro INIT_NES
    sei                             ; disable all IRQ interrupts
    cld                             ; clear decimal mode

    ldx #$40
    stx $4017                       ; disable APU frame IRQ

    ldx #$ff
    txs                             ; initialize stack pointer at $01FF

    inx                             ; Roll-off from $FF to $00
    stx PPU_CTRL                    ; disable NMI
    stx PPU_MASK                    ; disable rendering
    stx $4010                       ; disable DMC IRQs

    ; The vblank flag is in an unknown state after reset,
    ; so it is cleared here to make sure that @vblankwait1
    ; does not exit immediately.
    bit PPU_STATUS

@vblank_wait_1:
    bit PPU_STATUS                  ; First of two waits for vertical blank to make sure that the
    bpl @vblank_wait_1              ; PPU has stabilized

    txa                             ; A = 0
@clear_mem:
    sta $0000,X                     ; Clear RAM from $0000 to $00FF
    sta $0100,X                     ; Clear RAM from $0100 to $01FF

    lda #$FF
    sta $0200,X                     ; Clear RAM from $0200 to $02FF

    lda #0
    sta $0300,X                     ; Clear RAM from $0300 to $03FF
    sta $0400,X                     ; Clear RAM from $0400 to $04FF
    sta $0500,X                     ; Clear RAM from $0500 to $05FF
    sta $0600,X                     ; Clear RAM from $0600 to $06FF
    sta $0700,X                     ; Clear RAM from $0700 to $07FF
    inx
    bne @clear_mem

@vblank_wait_2:
    bit PPU_STATUS
    bpl @vblank_wait_2

.endmacro

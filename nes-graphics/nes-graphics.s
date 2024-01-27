;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Constants
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PPU_CTRL = $2000
PPU_MASK = $2001
PPU_STATUS = $2002
OAM_ADDR = $2003
OAM_DATA = $2004
PPU_SCROLL = $2005
PPU_ADDR = $2006
PPU_DATA = $2007

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

reset:
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
    sta $0200,X                     ; Clear RAM from $0200 to $02FF
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

main:
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

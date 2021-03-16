; ay ! this is a test for a bg scroller thingy
; enjoy uwu - this may or may not work btw
; ps it works now !

; ===== HEADER ===== ;

SECTION "header", ROM0[$100]
    nop
    jp entry

; ===== PROGRAM ===== ;

SECTION "rom", ROM0[$150]
entry:
    ; wait until safe to turn off lcd ;
    ld a, [$ff00 + $44]
    cp a, 144
    jr nz, entry

    ; set up lcdc ;
    ld a, %00010001
    ld [$ff00 + $40], a

    ; set up drawing
    ld a, %00011011
    ld [$ff00 + $47], a

    ; load the heart sprite into vram ;
    ld hl, hart_sprite
    ld de, $8000
.loop:
    ld a, [hl+]
    ld [de], a
    inc e

    ld a, e
    cp a, $10
    jr nz, .loop

    ; turn on lcd again ;
    ld b, %10000000
    ld a, [$ff00 + $40]
    or a, b
    ld [$ff00 + $40], a

    jp bide_time

hart_sprite:
    db $40, $6c, $e0, $92, $e4, $a2, $06, $82
    db $0c, $44, $18, $28, $00, $10, $00, $00

bide_time:
    ; wait until vblank period ;
    ld a, [$ff00 + $44]
    cp a, 144
    jr nz, bide_time

    ; count
    ld hl, $d000
    inc [hl]

    ld a, [hl]
    cp a, $10
    jr nz, bide_time

    xor a
    ld [hl], a

scroll:
    ld hl, $d001
    inc [hl]

    ld a, [hl]
    ld c, $42

    ; bg scroll registers
    ld [$ff00 + c], a
    inc c
    ld [$ff00 + c], a

    jp bide_time

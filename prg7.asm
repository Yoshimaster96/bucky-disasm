	.base $C000
	.org $C000
;BANK NUMBER
	.db $3E

;;;;;;;;;;;;;;;;
;LEVEL ROUTINES;
;;;;;;;;;;;;;;;;
InitLevelScroll:
	;Load level PRG bank
	ldy LevelBank
	jsr LoadPRGBank
	;Init level scroll
	jsr InitLevelScrollSub
	;Restore PRG bank
	jsr RestorePRGBank
	rts

InitLevelScrollSub:
	;Clear scroll X/Y velocity/acceleration
	lda #$00
	sta ScrollXAccel
	sta ScrollYAccel
	sta ScrollXVelLo
	sta ScrollYVelLo
	;Clear scroll position
	sta TempMirror_PPUSCROLL_X
	sta TempMirror_PPUSCROLL_Y
	lda TempMirror_PPUCTRL
	and #$FC
	sta TempMirror_PPUCTRL
	;Check for top side of level
	lda AreaScrollFlags
	cmp #$81
	beq InitLevelScrollSub_Top
	;Check for right side of level
	cmp #$82
	beq InitLevelScrollSub_Right
	;Check for bottom side of level
	cmp #$83
	beq InitLevelScrollSub_Bottom
	;Handle left side of level
	lda CurScreen
	sta $06
	clc
	adc #$02
	sta CurScreen
	lda #$F0
	bne InitLevelScrollSub_SetX
InitLevelScrollSub_Right:
	;Handle right side of level
	lda CurScreen
	sta $06
	sec
	sbc #$02
	sta CurScreen
	lda #$10
InitLevelScrollSub_SetX:
	;Set scroll X velocity
	sta ScrollXVelHi
	;Draw 4 columns of tiles
	lda #$00
	sta ScrollInitCounter
InitLevelScrollSub_HorizLoop:
	;Draw column of tiles
	jsr UpdateLevelScroll_Horiz
	;End VRAM buffer
	jsr WriteVRAMBufferCmd_EndAll
	;Write VRAM buffer
	jsr WriteVRAMBuffer
	;Loop for each column
	inc ScrollInitCounter
	lda ScrollInitCounter
	cmp #$04
	bne InitLevelScrollSub_HorizNext
	;Reset column counter
	lda #$00
	sta ScrollInitCounter
	;Update sound
	jsr UpdateSound
InitLevelScrollSub_HorizNext:
	;Loop for column
	lda TempMirror_PPUSCROLL_X
	bne InitLevelScrollSub_HorizLoop
	lda CurScreen
	cmp $06
	bne InitLevelScrollSub_HorizLoop
	;Clear scroll X velocity
	sta ScrollXVelHi
	;Update enemy animation
	jsr UpdateEnemyAnimationCheck
	;Set nametable
	lda CurScreen
	and #$01
	ora TempMirror_PPUCTRL
	sta TempMirror_PPUCTRL
	rts
InitLevelScrollSub_Top:
	;Handle top side of level
	lda CurScreen
	sta $06
	clc
	adc #$02
	sta CurScreen
	lda #$F0
	bne InitLevelScrollSub_SetY
InitLevelScrollSub_Bottom:
	;Handle bottom side of level
	lda CurScreen
	sta $06
	sec
	sbc #$02
	sta CurScreen
	lda #$10
InitLevelScrollSub_SetY:
	;Set scroll Y velocity
	sta ScrollYVelHi
	;Swap nametable
	inc TempMirror_PPUCTRL
	;Draw 4 rows of tiles
	lda #$00
	sta ScrollInitCounter
InitLevelScrollSub_VertLoop:
	;Draw row of tiles
	jsr UpdateLevelScroll_Vert
	;End VRAM buffer
	jsr WriteVRAMBufferCmd_EndAll
	;Write VRAM buffer
	jsr WriteVRAMBuffer
	;Loop for each row
	inc ScrollInitCounter
	lda ScrollInitCounter
	cmp #$04
	bne InitLevelScrollSub_VertNext
	;Reset row counter
	lda #$00
	sta ScrollInitCounter
	;Update sound
	jsr UpdateSound
InitLevelScrollSub_VertNext:
	;Loop for each row
	lda TempMirror_PPUSCROLL_Y
	bne InitLevelScrollSub_VertLoop
	lda CurScreen
	cmp $06
	bne InitLevelScrollSub_VertLoop
	;Clear scroll Y velocity
	sta ScrollYVelHi
	;Update enemy animation
	jmp UpdateEnemyAnimationCheck

SetLevelDataPointers:
	;Get level bank
	ldy LevelBankTable,x
	sty LevelBank
	;Load level PRG bank
	jsr LoadPRGBank
	;Set level data pointers
	lda CurLevel
	asl
	tay
	lda LevelAttrPointerTable,y
	sta LevelAttrPointer
	lda LevelAttrPointerTable+1,y
	sta LevelAttrPointer+1
	lda LevelBGPointerTable,y
	sta LevelBGPointer
	lda LevelBGPointerTable+1,y
	sta LevelBGPointer+1
	lda LevelTilePointerTable,y
	sta LevelTilePointer
	lda LevelTilePointerTable+1,y
	sta LevelTilePointer+1
	;Restore PRG bank
	jsr RestorePRGBank
	rts
LevelBankTable:
	.db $34,$34,$34,$36,$36,$34,$36,$30

SetLevelTileCollRange:
	;Set scroll disable flag
	ldy LevelAreaNum
	lda LevelTileCollRangeTable,y
	and #$01
	sta ScrollDisableFlag
	;Set tile collision ranges
	lda LevelTileCollRangeTable,y
	and #$FE
	tay
	lda TileCollRangeTable,y
	sta TileCollRange00
	lda TileCollRangeTable+1,y
	sta TileCollRange00+1
	lda TileCollRangeTable+2,y
	sta TileCollRange00+2
	lda TileCollRangeTable+3,y
	sta TileCollRange01
	lda TileCollRangeTable+4,y
	sta TileCollRange01+1
	lda TileCollRangeTable+5,y
	sta TileCollRange01+2
	rts

DrawDarkRoomMetatile:
	;Load PRG bank $34 (level 6 data bank)
	ldy #$34
	jsr LoadPRGBank
	;Draw dark room metatile
	jsr DrawDarkRoomMetatileSub
	;Restore PRG bank
	jsr RestorePRGBank
	rts

DrawDarkRoomMetatileSub:
	;Get offset to metatile data
	lda $00
	asl
	tay
	lda (LevelBGPointer),y
	sta $08
	iny
	lda (LevelBGPointer),y
	sta $09
	ldy $01
	lda ($08),y
	jsr GetMetatilePointer
	;Set tiles in VRAM
	ldy $02
DrawDarkRoomMetatileSub_Loop:
	;Set tile in VRAM
	lda ($08),y
	sta VRAMBuffer,x
	;Loop for each tile
	inx
	iny
	iny
	iny
	iny
	cpy #$10
	bcc DrawDarkRoomMetatileSub_Loop
	rts

GetMetatilePointer:
	;Get offset to metatile data
	sta TempMetatileID
	and #$0F
	tay
	lda TempMetatileID
	lsr
	lsr
	lsr
	lsr
	sta TempMetatileID
	;Add to base pointer
	lda OffsetLoToHiTable,y
	clc
	adc LevelTilePointer
	sta $08
	lda TempMetatileID
	adc LevelTilePointer+1
	sta $09
	rts
OffsetLoToHiTable:
	.db $00,$10,$20,$30,$40,$50,$60,$70,$80,$90,$A0,$B0,$C0,$D0,$E0,$F0

UpdateMetatileSub:
	;Load level PRG bank
	ldy LevelBank
	jsr LoadPRGBank
	;Get pointer to metatile data
	lda UpdateMetatileID
	jsr GetMetatilePointer
	;Get metatile VRAM address
	lda UpdateMetatileProps
	and #$01
	clc
	adc #$08
	sta $0B
	lda UpdateMetatilePos
	and #$07
	sta $0A
	lda UpdateMetatilePos
	and #$38
	asl
	asl
	clc
	adc $0A
	sta $0A
	sta $0E
	asl $0A
	rol $0B
	asl $0A
	rol $0B
	;Check for bottom row of metatiles
	ldx VRAMBufferOffset
	ldy #$00
	lda #$04
	sta $0C
	lda $0A
	bpl UpdateMetatileSub_TileLoop
	lda $0B
	and #$03
	cmp #$03
	bne UpdateMetatileSub_TileLoop
	lda #$02
	sta $0C
UpdateMetatileSub_TileLoop:
	;Init VRAM buffer row
	lda #$01
	sta VRAMBuffer,x
	inx
	;Set VRAM buffer address
	lda $0A
	sta VRAMBuffer,x
	inx
	clc
	adc #$20
	sta $0A
	lda $0B
	sta VRAMBuffer,x
	inx
	;Draw row of tiles
	lda #$04
	sta $0D
UpdateMetatileSub_TileLoop2:
	;Set tile in VRAM
	lda ($08),y
	iny
	sta VRAMBuffer,x
	inx
	;Loop for each tile
	dec $0D
	bne UpdateMetatileSub_TileLoop2
	;End VRAM buffer
	lda #$FF
	sta VRAMBuffer,x
	inx
	;Loop for each row
	dec $0C
	bne UpdateMetatileSub_TileLoop
	;Check to update attribute
	lda UpdateMetatileProps
	bpl UpdateMetatileSub_NoAttr
	;Get pointer to attribute data
	lda LevelAttrPointer
	clc
	adc UpdateMetatileID
	sta $08
	lda LevelAttrPointer+1
	adc #$00
	sta $09
	;Init VRAM buffer row
	lda #$01
	sta VRAMBuffer,x
	inx
	;Set VRAM buffer address
	lda UpdateMetatilePos
	clc
	adc #$C0
	sta VRAMBuffer,x
	inx
	lda UpdateMetatileProps
	and #$01
	asl
	asl
	clc
	adc #$23
	sta VRAMBuffer,x
	inx
	;Set attribute in VRAM
	ldy #$00
	lda ($08),y
	sta VRAMBuffer,x
	inx
	;End VRAM buffer
	lda #$FF
	sta VRAMBuffer,x
	inx
UpdateMetatileSub_NoAttr:
	stx VRAMBufferOffset
	;Check to update collision
	lda UpdateMetatileProps
	and #$40
	beq UpdateMetatileSub_NoColl
	;Get collision buffer offset
	lda UpdateMetatileProps
	and #$01
	tay
	lda CollTypeOffsetTable,y
	sta CollBufferPointer
	;Get collision type
	lda UpdateMetatileProps
	and #$06
	tax
	ldy $0E
UpdateMetatileSub_CollLoop:
	;Draw collision tile
	lda MetatileCollTypeTable,x
	sta (CollBufferPointer),y
	;Loop for each tile
	tya
	clc
	adc #$08
	tay
	and #$18
	bne UpdateMetatileSub_CollLoop
UpdateMetatileSub_NoColl:
	;Restore PRG bank
	jsr RestorePRGBank
	rts
MetatileCollTypeTable:
	.db $00,$00,$55,$00,$AA,$00,$FF

GetCollisionType:
	;Check if IRQ buffer collision handling enabled
	lda IRQBufferCollisionFlag
	beq GetCollisionType_NoIRQ
	;Get IRQ buffer index at collision Y position
	lda $01
	ldy #$FF
GetCollisionType_IRQLoop:
	;Check for end of IRQ buffer
	iny
	cpy TempIRQCount
	beq GetCollisionType_IRQYC
	;Check if collision Y position is in this IRQ buffer section
	sta $03
	sec
	sbc TempIRQBufferHeight,y
	bcs GetCollisionType_IRQLoop
	bcc GetCollisionType_IRQNoYC
GetCollisionType_IRQYC:
	dey
GetCollisionType_IRQNoYC:
	dey
	sty $07
	bmi GetCollisionType_NoIRQ
	;Get collision buffer offset based on scroll X position (IRQ)
	lda $00
	clc
	adc TempIRQBufferScrollX,y
	sta $02
	lda TempIRQBufferScrollHi,y
	rol
	and #$09
	tay
	lda CollTypeOffsetTable,y
	sta CollBufferPointer
	;Get collision buffer index based on scroll Y position (IRQ)
	ldy $07
	lda $03
	clc
	adc TempIRQBufferScrollY,y
	bcs GetCollisionType_NoIRQYC
	cmp #$F0
	bcc GetCollisionType_NoIRQNoYC
	bcs GetCollisionType_NoIRQYC
GetCollisionType_NoIRQ:
	;Get collision buffer offset based on scroll X position (no IRQ)
	lda $00
	clc
	adc TempMirror_PPUSCROLL_X
	sta $02
	lda TempMirror_PPUCTRL
	rol
	and #$03
	tay
	lda CollTypeOffsetTable,y
	sta CollBufferPointer
	;Get collision buffer index based on scroll Y position (no IRQ)
	lda $01
	clc
	adc TempMirror_PPUSCROLL_Y
	bcs GetCollisionType_NoIRQYC
	cmp #$F0
	bcc GetCollisionType_NoIRQNoYC
GetCollisionType_NoIRQYC:
	sbc #$F0
GetCollisionType_NoIRQNoYC:
	;Get collision buffer index
	and #$F8
	sta $03
	lda $02
	lsr
	lsr
	lsr
	lsr
	lsr
	clc
	adc $03
	tay
	;Check which bits to use
	lda $02
	and #$18
	beq GetCollisionType_Tile0
	cmp #$08
	beq GetCollisionType_Tile1
	cmp #$10
	beq GetCollisionType_Tile2
	;Use bits 0-1 for collision
	lda (CollBufferPointer),y
	and #$03
	tay
	lda CollTypeBitsTable,y
	rts
GetCollisionType_Tile2:
	;Use bits 2-3 for collision
	lda (CollBufferPointer),y
	and #$0C
	lsr
	lsr
	tay
	lda CollTypeBitsTable,y
	rts
GetCollisionType_Tile1:
	;Use bits 4-5 for collision
	lda (CollBufferPointer),y
	and #$30
	lsr
	lsr
	lsr
	lsr
	tay
	lda CollTypeBitsTable,y
	rts
GetCollisionType_Tile0:
	;Use bits 6-7 for collision
	lda (CollBufferPointer),y
	and #$C0
	clc
	rol
	rol
	rol
	tay
	lda CollTypeBitsTable,y
	rts
CollTypeOffsetTable:
	.db $00,$F0,$F0,$00,$00,$00,$00,$00,$F0,$00
CollTypeBitsTable:
	.db $00,$01,$02,$04

GetVRAMAddr:
	;Get nametable Y position
	lda $01
	clc
	adc TempMirror_PPUSCROLL_Y
	bcs GetVRAMAddr_YC
	cmp #$F0
	bcc GetVRAMAddr_NoYC
GetVRAMAddr_YC:
	sbc #$F0
GetVRAMAddr_NoYC:
	sta $08
	;Get nametable
	lda TempMirror_PPUCTRL
	and #$01
	asl
	asl
	ora #$20
	sta $02
	;Get nametable X position
	lda $00
	clc
	adc TempMirror_PPUSCROLL_X
	sta $09
	bcc GetVRAMAddr_NoXC
	lda $02
	eor #$04
	sta $02
GetVRAMAddr_NoXC:
	;Get VRAM address from position
	lda $08
	lsr
	lsr
	lsr
	lsr
	ror $09
	lsr
	ror $09
	lsr
	ror $09
	clc
	adc $02
	sta $08
	rts

DrawCollisionTileRow:
	;Get collision buffer pointer
	jsr GetCollisionBufferPointer
	;Draw collision tile row
	lda $04
DrawCollisionTileRow_Loop:
	;Get collision buffer offset
	clc
	adc $02
	tax
	ldy $01
	;Draw collision tile
	lda (CollBufferPointer),y
	and CollDrawMaskTable,x
	ora CollDrawSetTable,x
	sta (CollBufferPointer),y
	;Get next tile offset
	lda $04
	clc
	adc #$04
	cmp #$10
	bcc DrawCollisionTileRow_NoVRAMC
	inc $01
	lda #$00
DrawCollisionTileRow_NoVRAMC:
	sta $04
	;Loop for each tile
	dec $00
	bne DrawCollisionTileRow_Loop
	rts

DrawCollisionTileCol:
	;Get collision buffer pointer
	jsr GetCollisionBufferPointer
	;Draw collision tile column
	lda $04
	;Get collision buffer offset
	clc
	adc $02
	tax
	ldy $01
DrawCollisionTileCol_Loop:
	;Draw collision tile
	lda (CollBufferPointer),y
	and CollDrawMaskTable,x
	ora CollDrawSetTable,x
	sta (CollBufferPointer),y
	;Get next tile offset
	tya
	clc
	adc #$08
	tay
	;Loop for each tile
	dec $00
	bne DrawCollisionTileCol_Loop
	rts

GetCollisionBufferPointer:
	;Get collision buffer offset based on VRAM address
	lda $01
	and #$03
	asl
	asl
	sta $04
	sty $03
	tya
	and #$04
	tay
	lda CollBufferPtrLoTable,y
	sta CollBufferPointer
	lsr $03
	ror $01
	lsr $03
	ror $01
	rts

;;;;;;;;;;;;;;;;;;;;
;GAME MODE ROUTINES;
;;;;;;;;;;;;;;;;;;;;
;GAMEPLAY MODE ROUTINES
RunGameMode_Gameplay:
	;Check for START press
	lda JoypadDown
	and #JOY_START
	beq RunGameMode_Gameplay_NoP
	;Check if gameplay loop active
	lda GameplayFlag
	bne RunGameMode_Gameplay_TogP
	;Clear paused flag
	sta PausedFlag
	beq RunGameMode_Gameplay_NoP
RunGameMode_Gameplay_TogP:
	;Toggle paused flag
	lda PausedFlag
	eor #$01
	sta PausedFlag
	;Play sound
	ldy #SE_PAUSE
	jsr LoadSound
RunGameMode_Gameplay_NoP:
	;Check to load level
	lda LevelLoadMode
	bmi RunGameMode_Gameplay_JT
	;Check if paused
	lda PausedFlag
	beq RunGameMode_Gameplay_Play
	;Update palette
	jmp UpdatePalette
RunGameMode_Gameplay_Play:
	;Increment global timer
	inc LevelGlobalTimer
	;Do tasks
	jsr ControlPlayer
	jsr UpdateLevelScroll
	jsr UpdateScrollAnim
	jsr UpdateHUDCheck
	jsr UpdateEnemyBGMovement
	jsr CheckLevelEnemies
	jsr CheckEnemyCollision
	jsr UpdateOtherGraphics
	jsr UpdateCHRBankAnim
	;Set gameplay loop flag
	lda #$01
	sta GameplayFlag
RunGameMode_Gameplay_Exit:
	rts
RunGameMode_Gameplay_JT:
	;Do jump table
	lda LevelLoadMode
	and #$03
	jsr DoJumpTable
GameplayJumpTable:
	.dw RunGameSubmode_GameplayInitPalette	;$00  Init palette
	.dw RunGameSubmode_GameplayInitScroll	;$01  Init scroll
	.dw RunGameSubmode_GameplayInitVRAM1	;$02  Init VRAM part 1
	.dw RunGameSubmode_GameplayInitVRAM2	;$03  Init VRAM part 2
;$00: Init palette
RunGameSubmode_GameplayInitPalette:
	;Clear gameplay loop and paused flags
	lda #$00
	sta GameplayFlag
	sta PausedFlag
	;Next submode ($01: Init scroll)
	inc LevelLoadMode
	;Load HUD palette
	lda #$03
	jmp WritePaletteStrip8
;$01: Init scroll
RunGameSubmode_GameplayInitScroll:
	;Check for level 8
	lda CurLevel
	cmp #$07
	bne RunGameSubmode_GameplayInitScroll_NoHUD
	;Update HUD
	jsr UpdateHUDCheck
RunGameSubmode_GameplayInitScroll_NoHUD:
	;Next submode ($02: Init VRAM part 1)
	inc LevelLoadMode
	;Init level state
	lda LevelLoadMode
	and #$04
	clc
	adc CurArea
	tay
	jmp InitLevelState
;$02: Init VRAM part 1
RunGameSubmode_GameplayInitVRAM1:
	;If black screen timer not 0, exit early
	lda BlackScreenTimer
	bne RunGameMode_Gameplay_Exit
	;Clear second VRAM strip
	lda #$00
	sta SecondVRAMStripIndex
	sta SecondVRAMStripFlag
	;Next submode ($03: Init VRAM part 2)
	inc LevelLoadMode
	;Check for level 3 water areas
	lda LevelAreaNum
	cmp #$20
	bcc RunGameMode_Gameplay_Exit
	cmp #$26
	bcc RunGameSubmode_GameplayInitVRAM1_Water
	;Check for level 5 elevator areas
	cmp #$49
	bcc RunGameMode_Gameplay_Exit
	cmp #$4D
	bcc RunGameSubmode_GameplayInitVRAM1_Elevator
	;Check for level 6 boss area
	cmp #$59
	bne RunGameMode_Gameplay_Exit
	;Set second VRAM strip to draw
	lda #$02
	sta SecondVRAMStripIndex
	;Write VRAM strip (level 6 boss ground)
	lda #$9C
	jsr WriteVRAMStrip
	;Draw collision tile row
	ldy #$27
	lda #$00
	sta $01
	lda #$40
	sta $00
	lda #$02
	sta $02
	jmp DrawCollisionTileRow
RunGameSubmode_GameplayInitVRAM1_Water:
	;Write VRAM strip (level 3 water)
	lda #$1C
	jmp WriteVRAMStrip
RunGameSubmode_GameplayInitVRAM1_Elevator:
	;Set second VRAM strip to draw
	lda #$01
	sta SecondVRAMStripIndex
	;Set disable side exit flag
	lda #$01
	sta DisableSideExitFlag
	;Write VRAM strip (level 5 elevator)
	lda #$34
	jsr WriteVRAMStrip
	;Draw collision tile row
	ldy #$22
	lda #$A0
	sta $01
	lda #$20
	sta $00
	lda #$02
	sta $02
	jsr DrawCollisionTileRow
	;Draw collision tile row
	ldy #$22
	lda #$80
	sta $01
	lda #$20
	sta $00
	lda #$00
	sta $02
	jmp DrawCollisionTileRow
;$03: Init VRAM part 2
RunGameSubmode_GameplayInitVRAM2:
	;Check if second VRAM strip already drawn
	lda SecondVRAMStripFlag
	bne RunGameSubmode_GameplayInitVRAM2_Next
	;Set second VRAM strip drawn flag
	inc SecondVRAMStripFlag
	;Check to draw level 5 elevators VRAM strip
	lda SecondVRAMStripIndex
	cmp #$01
	beq RunGameSubmode_GameplayInitVRAM2_Elevator
	;Check to draw level 6 boss ground VRAM strip
	cmp #$02
	bne RunGameSubmode_GameplayInitVRAM2_Exit
	;Write VRAM strip (level 6 boss ground)
	lda #$9D
	jmp WriteVRAMStrip
RunGameSubmode_GameplayInitVRAM2_Elevator:
	;Write VRAM strip (level 5 elevator)
	lda #$35
	jmp WriteVRAMStrip
RunGameSubmode_GameplayInitVRAM2_Next:
	;Clear level load mode
	lda #$00
	sta LevelLoadMode
	;Get level palette/platform enable flag
	ldy LevelAreaNum
	lda LevelAreaPaletteTable,y
	tay
	rol
	rol
	and #$01
	sta PlatformEnableFlag
	tya
	ora #$80
	sta CurPalette
	;Load level palette
	jmp UpdatePalette_Set
RunGameSubmode_GameplayInitVRAM2_Exit:
	rts

;;;;;;;;;;;;;;;
;VRAM ROUTINES;
;;;;;;;;;;;;;;;
WritePaletteCharacter:
	;Load PRG bank $38 (palette data bank)
	ldy #$38
	jsr LoadPRGBank
	jmp WritePaletteStrip6_Character

WritePaletteStrip8:
	;Get VRAM strip pointer table offset
	asl
	tax
	;Load PRG bank $38 (palette data bank)
	ldy #$38
	jsr LoadPRGBank
	;Init palette strip
	jsr WritePaletteStripInit
	;Write palette strip 8 colors
	lda #$08
	jsr WritePaletteStripEntry
	;End palette strip
	jmp WritePaletteStrip6_End

WritePaletteStrip6:
	;Load PRG bank $38 (palette data bank)
	ldy #$38
	jsr LoadPRGBank
	;Init palette strip
	jsr WritePaletteStripInit
	;Write palette strip 6 colors
	lda #$06
	jsr WritePaletteStripEntry
WritePaletteStrip6_Character:
	;Get player palette table offset based on current character
	lda CurCharacter
	asl
	asl
	asl
	clc
	adc PlayerPaletteOffset
	tay
	;Write palette strip 8 colors
	lda #$08
	sta $0A
WritePaletteStrip6_Loop:
	;Set color in VRAM
	lda PlayerPaletteData,y
	sta VRAMBuffer,x
	;Loop for each color
	inx
	iny
	dec $0A
	bne WritePaletteStrip6_Loop
WritePaletteStrip6_End:
	;End VRAM buffer
	jsr WriteVRAMBufferCmd_End
	;Restore PRG bank
	jsr RestorePRGBank
	rts

WritePaletteStripInit:
	;Get palette data pointer
	lda VRAMStrip00PointerTable,x
	sta $08
	lda VRAMStrip00PointerTable+1,x
	sta $09
	;Init VRAM buffer row
	jsr WriteVRAMBufferCmd_InitRow
	;Write VRAM buffer address
	lda #$00
	sta VRAMBuffer,x
	inx
	lda #$3F
	sta VRAMBuffer,x
	inx
	rts

WritePaletteStripEntry:
	;Save A register
	sta $0B
	;Write palette entries
	ldy #$00
WritePaletteStripEntry_Loop:
	;Write background color for palette entry
	lda #$0F
	sta VRAMBuffer,x
	inx
	;Write other colors for palette entry
	lda #$03
	sta $0A
WritePaletteStripEntry_Loop2:
	;Get color for palette entry
	lda ($08),y
	sta VRAMBuffer,x
	;Loop for each color in entry
	inx
	iny
	dec $0A
	bne WritePaletteStripEntry_Loop2
	;Loop for each entry
	dec $0B
	bne WritePaletteStripEntry_Loop
	rts

WriteVRAMStrip:
	;Save A/X registers
	sta $10
	stx $11
	;Load PRG bank $38 (VRAM strip data bank)
	ldy #$38
	jsr LoadPRGBank
	;Write VRAM strip
	jsr WriteVRAMStripSub
	;Restore PRG bank
	jsr RestorePRGBank
	;Restore X register
	ldx $11
	rts

WriteVRAMStripSub:
	;Init VRAM buffer row
	jsr WriteVRAMBufferCmd_InitRow
	;Get VRAM strip ID
	lda $10
	bpl WriteVRAMStripSub_00
	;Get VRAM strip pointer ($80-$FF)
	asl
	tay
	lda VRAMStrip80PointerTable,y
	sta $08
	lda VRAMStrip80PointerTable+1,y
	sta $09
	;Write VRAM strip
	ldy #$00
	lda ($08),y
	sta VRAMBuffer,x
	inx
	iny
	;Check for clear nametable command
	lda ($08),y
	bne WriteVRAMStripSub_Loop
	beq WriteVRAMStripSub_Clear
WriteVRAMStripSub_00:
	;Get VRAM strip pointer ($00-$7F)
	asl
	tay
	lda VRAMStrip00PointerTable,y
	sta $08
	lda VRAMStrip00PointerTable+1,y
	sta $09
	;Write VRAM strip
	ldy #$00
WriteVRAMStripSub_Loop:
	;Check for end all command
	lda ($08),y
	iny
	cmp #$FF
	beq WriteVRAMBufferCmd_End
	;Check for end strip command
	cmp #$FE
	beq WriteVRAMStripSub_Next
	;Set byte in VRAM
	sta VRAMBuffer,x
	inx
	;Loop for each byte
	bne WriteVRAMStripSub_Loop
WriteVRAMStripSub_Next:
	;End VRAM buffer
	lda #$FF
	sta VRAMBuffer,x
	inx
	;Init VRAM buffer row
	lda #$01
	sta VRAMBuffer,x
	inx
	bne WriteVRAMStripSub_Loop
WriteVRAMStripSub_Clear:
	;Set VRAM buffer address
	lda #$27
	sta VRAMBuffer,x
	inx
	iny
	lda ($08),y
	sta $08
WriteVRAMStripSub_ClearLoop:
	;Set 0 in VRAM
	lda #$00
	sta VRAMBuffer,x
	inx
	;Loop for each byte
	dec $08
	bne WriteVRAMStripSub_ClearLoop
	beq WriteVRAMBufferCmd_End

WriteVRAMBufferCmd_EndAll:
	;Write VRAM command to end all strips
	ldx VRAMBufferOffset
	lda #$00
	sta VRAMBuffer,x
	rts

WriteVRAMBufferCmd_InitRow:
	;Write VRAM command to draw tile row
	ldx VRAMBufferOffset
	lda #$01
	sta VRAMBuffer,x
	inx
	rts

WriteVRAMBufferCmd_InitCol:
	;Write VRAM command to draw tile column
	ldx VRAMBufferOffset
	lda #$02
	sta VRAMBuffer,x
	inx
	rts

WriteVRAMBufferCmd_End:
	;Write VRAM command to end current strip
	lda #$FF
	sta VRAMBuffer,x
	;Save VRAM buffer offset
	inx
	stx VRAMBufferOffset
	rts

WriteVRAMBufferCmd_Addr:
	;Write VRAM buffer address
	sta VRAMBuffer,x
	inx
	tya
	sta VRAMBuffer,x
	inx
	rts

ClearNametableData:
	;Write nametable $00 (empty nametable)
	ldx #$00

WriteNametableData:
	;Load PRG bank $38 (nametable data bank)
	ldy #$38
	jsr LoadPRGBank
	;Write nametable data
	jsr WriteNametableDataSub
	;Restore PRG bank
	jsr RestorePRGBank
	rts

WriteNametableDataSub:
	;Get nametable data pointer
	lda NametableDataPointerTable,x
	sta $00
	lda NametableDataPointerTable+1,x
	sta $01
	;Disable video out
	jsr DisableVideoOut
	;Clear VRAM buffer
	lda #$00
	sta VRAMBufferOffset
WriteNametableDataSub_Loop:
	;Set VRAM address
	ldy #$01
	lda ($00),y
	sta PPU_ADDR
	dey
	lda ($00),y
	sta PPU_ADDR
	;Increment nametable data pointer
	ldx #$00
	lda #$02
	jsr DrawNametableIncAddr
WriteNametableDataSub_Loop2:
	;Check for end all command
	ldy #$00
	lda ($00),y
	cmp #$FF
	beq WriteNametableDataSub_EndAll
	;Check for end strip command
	cmp #$7F
	beq WriteNametableDataSub_EndStrip
	;Check for RLE mode
	tay
	bpl WriteNametableDataSub_RLE
	;Get strip length
	and #$7F
	sta $02
	;Write immediate VRAM strip
	ldy #$01
WriteNametableDataSub_ImmLoop:
	;Set byte in VRAM
	lda ($00),y
	sta PPU_DATA
	;Loop for each byte
	cpy $02
	beq WriteNametableDataSub_ImmEnd
	iny
	bne WriteNametableDataSub_ImmLoop
WriteNametableDataSub_ImmEnd:
	;Increment nametable data pointer
	lda #$01
	clc
	adc $02
WriteNametableDataSub_Next:
	jsr DrawNametableIncAddr
	jmp WriteNametableDataSub_Loop2
WriteNametableDataSub_RLE:
	;Write RLE VRAM strip
	ldy #$01
	sta $02
	lda ($00),y
	ldy $02
WriteNametableDataSub_RLELoop:
	;Set byte in VRAM
	sta PPU_DATA
	;Loop for each byte
	dey
	bne WriteNametableDataSub_RLELoop
	;Increment nametable data pointer
	lda #$02
	bne WriteNametableDataSub_Next
WriteNametableDataSub_EndStrip:
	;Increment nametable data pointer
	lda #$01
	jsr DrawNametableIncAddr
	;Loop for each strip
	jmp WriteNametableDataSub_Loop
WriteNametableDataSub_EndAll:
	;Enable video out
	jmp SetScroll_EnNMI
NametableDataPointerTable:
	.dw Nametable00Data	;$00  Empty
	.dw Nametable02Data	;$02  Title
	.dw Nametable04Data	;$04  Stage select
	.dw Nametable06Data	;$06  Legal
	.dw Nametable08Data	;$08  "THE END"
	.dw Nametable0AData	;$0A  UNUSED
	.dw Nametable0CData	;$0C  Hero ship
	.dw Nametable0EData	;$0E  Toad ship chase
	.dw Nametable10Data	;$10  Intro part 3
	.dw Nametable12Data	;$12  Intro part 4
	.dw Nametable14Data	;$14  Intro part 5
	.dw Nametable16Data	;$16  Intro part 6
	.dw Nametable18Data	;$18  Dialog all
	.dw Nametable1AData	;$1A  Dialog Jenny
	.dw Nametable1CData	;$1C  Dialog Blinky
	.dw Nametable1EData	;$1E  Dialog Dead-Eye
	.dw Nametable20Data	;$20  Dialog Willy
	.dw Nametable22Data	;$22  Blueprint
	.dw Nametable24Data	;$24  Toad ship distant

;;;;;;;;;;;;;;;;;;;;;;;;;;
;ENEMY ANIMATION ROUTINES;
;;;;;;;;;;;;;;;;;;;;;;;;;;
SetEnemyAnimation:
	sty $00
	;Load PRG bank $3A (enemy animation data bank)
	ldy #$3A
	jsr LoadPRGBank
	;Set enemy animation
	jsr SetEnemyAnimationSub
	;Restore PRG bank
	jsr RestorePRGBank
	rts

SetEnemyAnimationSub:
	;Set enemy animation
	lda $00
	sta Enemy_Anim,x
	;Check for bit 0 set
	lsr
	bcs SetEnemyAnimationSub_01
	;Handle enemy animation
	ldy $00
	lda AnimationInfo00PointerTable,y
	sta $08
	lda AnimationInfo00PointerTable+1,y
	sta $09
	lda AnimationData00PointerTable,y
	sta $0A
	lda AnimationData00PointerTable+1,y
	sta $0B
	ldy #$00
	beq SetEnemyAnimationSub_No01
SetEnemyAnimationSub_01:
	;Handle enemy animation
	ldy $00
	lda AnimationInfo01PointerTable-1,y
	sta $08
	lda AnimationInfo01PointerTable-1+1,y
	sta $09
	lda AnimationData01PointerTable-1,y
	sta $0A
	lda AnimationData01PointerTable-1+1,y
	sta $0B
	ldy #$00
SetEnemyAnimationSub_No01:
	;Set enemy flags
	lda ($08),y
	sta Enemy_Flags,x
	;Set enemy collision width
	iny
	lda ($08),y
	sta Enemy_CollWidth,x
	;Set enemy collision height/sprite high
	iny
	lda ($08),y
	sta $01
	and #$3F
	sta Enemy_CollHeight,x
	lda $01
	and #$C0
	clc
	rol
	rol
	rol
	sta Enemy_SpriteHi,x
	;Init animation frame
	lda #$00
	sta Enemy_AnimOffs,x
	ldy #$00
	lda ($0A),y
	and #$7F
	sta Enemy_AnimTimer,x
	iny
	lda ($0A),y
	sta Enemy_SpriteLo,x
	rts

ClearEnemies:
	;Clear enemy slot 0 flags (player)
	lda #$00
	sta Enemy_Flags
ClearEnemies_NoPl:
	lda #$00
	ldx #$0F
ClearEnemies_Loop:
	;Clear enemy flags
	sta Enemy_Flags,x
	dex
	bne ClearEnemies_Loop
	rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;
;BG CHUTE CRUSHER ROUTINES;
;;;;;;;;;;;;;;;;;;;;;;;;;;;
DrawBGChuteCrusher:
	;If bits 0-2 of VRAM strip ID $07, play sound
	lda UpdateVRAMStripID
	and #$07
	cmp #$07
	bne DrawBGChuteCrusher_NoSound
	;Play sound
	ldy #SE_BGCHUTECRUSH
	jsr LoadSound
DrawBGChuteCrusher_NoSound:
	;Get VRAM address for left side
	lda UpdateVRAMStripID
	and #$60
	tay
	lda UpdateVRAMStripID
	and #$18
	lsr
	lsr
	lsr
	clc
	adc #$24
	sta $10
	lda UpdateVRAMStripID
	and #$07
	clc
	adc #$05
	sta $11
	;Draw BG chute crusher section left
	jsr DrawBGChuteCrusherSub
	;Get VRAM address for left side
	lda #$20
	sec
	sbc $11
	sta $11
	;Draw BG chute crusher section right
	jsr DrawBGChuteCrusherSub
	;Draw collision tile column
	lda $11
	sec
	sbc #$04
	sta $01
	lda #$04
	sta $00
	lda UpdateVRAMStripID
	and #$20
	lsr
	lsr
	lsr
	lsr
	eor #$02
	sta $02
	ldy $10
	jsr DrawCollisionTileCol
	;Draw collision tile column
	lda #$23
	sec
	sbc $11
	sta $01
	lda #$04
	sta $00
	ldy $10
	jmp DrawCollisionTileCol

DrawBGChuteCrusherSub:
	;Draw BG chute crusher tile columns
	lda #$04
	sta $08
DrawBGChuteCrusherSub_Loop:
	;Init VRAM buffer column
	jsr WriteVRAMBufferCmd_InitCol
	;Set VRAM buffer address
	lda $11
	sta VRAMBuffer,x
	inx
	lda $10
	sta VRAMBuffer,x
	inx
DrawBGChuteCrusherSub_Loop2:
	;Set tile in VRAM
	lda BGChuteCrusherVRAMData,y
	sta VRAMBuffer,x
	inx
	;Loop for each tile
	iny
	tya
	and #$03
	bne DrawBGChuteCrusherSub_Loop2
	;End VRAM buffer
	jsr WriteVRAMBufferCmd_End
	;Loop for each column
	inc $11
	dec $08
	bne DrawBGChuteCrusherSub_Loop
	rts
BGChuteCrusherVRAMData:
	.db $C3,$D3,$C7,$D6,$C2,$D2,$C6,$C2,$C1,$D1,$C5,$D5,$C0,$D0,$C4,$D4
	.db $C0,$D0,$C4,$D4,$C1,$D1,$C5,$D5,$C2,$D2,$C6,$C2,$C3,$D3,$C7,$D6
	.db $C2,$D2,$C6,$C2,$C1,$D1,$C5,$D5,$C0,$D0,$C4,$D4,$09,$09,$09,$09
	.db $09,$09,$09,$09,$C0,$D0,$C4,$D4,$C1,$D1,$C5,$D5,$C2,$D2,$C6,$C2
	.db $C8,$C9,$C8,$C9,$CA,$CA,$CA,$CA,$B5,$B6,$B6,$B6,$E5,$E4,$E5,$E4
	.db $E3,$E2,$E3,$E2,$B6,$B5,$B6,$B6,$CA,$CA,$CA,$CA,$C8,$C9,$C8,$C9
	.db $CA,$CA,$CA,$CA,$B5,$B6,$B6,$B6,$E5,$E4,$E5,$E4,$09,$09,$09,$09
	.db $09,$09,$09,$09,$E3,$E2,$E3,$E2,$B6,$B5,$B6,$B6,$CA,$CA,$CA,$CA

;;;;;;;;;;;;;;;;;;;;
;SCROLLING ROUTINES;
;;;;;;;;;;;;;;;;;;;;
;$0C: Level 8 boss
ScrollAnimXC:
	;If bits 0-1 of global timer 0, load CHR bank
	lda LevelGlobalTimer
	and #$03
	bne ScrollAnimXC_NoAnim
	;Animate using CHR banks $04/$06/$08
	jsr CHRBankAnim1X_EntXC
ScrollAnimXC_NoAnim:
	;Load level 8 end stars palette
	jsr CHRBankAnimBX
	;Set scroll position to master PPU scroll
	ldx #$01
	jsr ScrollAnimGetPPUXPos
	;Check for end modes
	lda BGAnimMode
	cmp #$02
	bcs ScrollAnimXC_JT
	;If current screen $50 and scroll X position >= $80, scroll left $80
	lda CurScreen
	cmp #$50
	bne ScrollAnimXC_JT
	lda TempMirror_PPUSCROLL_X
	bpl ScrollAnimXC_JT
	;Scroll left $80
	eor #$80
	sta TempMirror_PPUSCROLL_X
ScrollAnimXC_JT:
	;Do jump table
	lda BGAnimMode
	jsr DoJumpTable
ScrollAnimXCJumpTable:
	.dw ScrollAnimXC_Sub0	;$00  Init
	.dw ScrollAnimXC_Sub1	;$01  Main
	.dw ScrollAnimXC_Sub2	;$02  End
	.dw ScrollAnimXC_Sub3	;$03  Exit
	.dw ScrollAnimXC_Sub4	;$04  Stars
;$00: Init
ScrollAnimXC_Sub0:
	;If current screen not $4F, exit early
	lda CurScreen
	cmp #$4F
	bne ScrollAnimXC_Sub3_Exit
	;Next task ($01: Main)
	inc BGAnimMode
	;Set IRQ buffer collision flag
	inc IRQBufferCollisionFlag
	;Load IRQ buffer set
	ldx #$32
	jmp LoadIRQBufferSet
;$01: Main
ScrollAnimXC_Sub1:
	;If boss still alive, exit early
	lda Enemy_Flags+$01
	bne ScrollAnimXC_Sub3_Exit
	;Next task ($02: End)
	inc BGAnimMode
	;Set enemy Y velocity
	lda #$60
	sta Enemy_YAccel+$02
	;Play sound
	ldy #SE_BOSSKILL
	jmp LoadSound
;$02: End
ScrollAnimXC_Sub2:
	;If scroll X position not $FF, scroll right $01
	lda TempIRQBufferScrollX
	cmp #$FF
	beq ScrollAnimXC_Sub2_NoXC
	;Scroll right $01
	inc TempIRQBufferScrollX
ScrollAnimXC_Sub2_NoXC:
	;If current screen not $53, exit early
	lda CurScreen
	cmp #$53
	bne ScrollAnimXC_Sub3_Exit
	;Next task ($03: Exit)
	inc BGAnimMode
	;Set auto escape pod flag
	inc AutoEscapePodFlag
	;Load IRQ buffer set
	ldx #$00
	jmp LoadIRQBufferSet
;$03: Exit
ScrollAnimXC_Sub3:
	;If player Y position $60, don't move player Y
	lda Enemy_Y
	cmp #$60
	beq ScrollAnimXC_Sub3_NoY
	;If player Y position < $60, move player up $01
	bcc ScrollAnimXC_Sub3_Down
	;If player Y position > $60, move player down $01
	dec Enemy_Y
	bne ScrollAnimXC_Sub3_NoY
ScrollAnimXC_Sub3_Down:
	;Move player down $01
	inc Enemy_Y
ScrollAnimXC_Sub3_NoY:
	;If player X position X, don't move player X
	lda Enemy_X
	cmp #$10
	beq ScrollAnimXC_Sub3_NoX
	;Move player left $01
	dec Enemy_X
ScrollAnimXC_Sub3_NoX:
	;If current screen not $56, exit early
	lda CurScreen
	cmp #$56
	bne ScrollAnimXC_Sub3_Exit
	;Set current screen $55
	lda #$55
	sta CurScreen
	;Set scroll update disable flag
	lda #$01
	sta ScrollUpdateDisableFlag
	;Increment scroll X velocity
	inc ScrollXVelHi
	;If scroll X velocity not $0E, exit early
	lda ScrollXVelHi
	cmp #$0E
	bne ScrollAnimXC_Sub3_Exit
	;Next task ($04: Stars)
	inc DialogTextTimer
ScrollAnimXC_Sub3_Exit:
	rts
;$04: Stars
ScrollAnimXC_Sub4:
	;Set current screen $55
	lda #$55
	sta CurScreen
	;Move player right $04
	lda Enemy_X
	clc
	adc #$04
	sta Enemy_X
	;If player X position not 0, exit early
	bne ScrollAnimXC_Sub3_Exit
	;Next mode ($02: Dialog)
	lda #$02
	sta GameMode
	;Next submode ($00: Init)
	lda #$00
	sta GameSubmode
	;Clear scroll X velocity
	sta ScrollXVelHi
	;Set ending dialog
	lda #$09
	sta DialogID
	;Play music
	ldy #MUSIC_CREDITS
	jmp LoadSound

;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;GET ITEM/ENEMY BIT ROUTINE;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;
GetItemEnemyBit:
	;Get item/enemy bit offset based on parameter value
	lda Enemy_Temp1,x
	sta $01
	and #$07
	tay
	lda ItemEnemyBitTable,y
	sta $00
	lda Enemy_Temp1,x
	and #$08
	lsr
	lsr
	lsr
	tay
	rts

;;;;;;;;;;;;;;;;;;;;
;LONG MODE ROUTINES;
;;;;;;;;;;;;;;;;;;;;
ClearShooter_L:
	;Load PRG bank $30 (clear shooter subroutine bank)
	ldy #$30
	jsr LoadPRGBank
	;Clear shooter
	jsr ClearShooter
	;Restore PRG bank
	jsr RestorePRGBank
	rts

ClearEnemy_L:
	;Load PRG bank $30 (clear enemy subroutine bank)
	ldy #$30
	jsr LoadPRGBank
	;Clear enemy
	jsr ClearEnemy
	;Restore PRG bank
	jsr RestorePRGBank
	rts

HitEnemySetYPos_L:
	;Load PRG bank $30 (hit enemy set Y position bank)
	ldy #$30
	jsr LoadPRGBank
	;Set player Y position for hitting enemy
	jsr HitEnemySetYPos
	;Restore PRG bank
	jsr RestorePRGBank
	rts

MoveEnemy_L:
	;Load PRG bank $30 (move enemy subroutine bank)
	ldy #$30
	jsr LoadPRGBank
	;Move enemy
	jsr MoveEnemy
	;Restore PRG bank
	jsr RestorePRGBank
	rts

UpdateHUD_L:
	;Load PRG bank $30 (update HUD subroutine bank)
	ldy #$30
	jsr LoadPRGBank
	;Update HUD
	jsr UpdateHUD
	;Restore PRG bank
	jsr RestorePRGBank
	rts

GivePoints_L:
	;Load PRG bank $30 (give points subroutine bank)
	ldy #$30
	jsr LoadPRGBank
	;Give points
	txa
	jsr GivePoints
	;Restore PRG bank
	jsr RestorePRGBank
	rts

GetCollisionTypeBottom_L:
	;Load PRG bank $30 (get collision type bottom subroutine bank)
	ldy #$30
	jsr LoadPRGBank
	;Get collision type bottom
	jsr GetCollisionTypeBottom
	sta $08
	;Restore PRG bank
	jsr RestorePRGBank
	rts

ClipPlayerYEnemy_L:
	;Load PRG bank $30 (clip player Y position subroutine bank)
	ldy #$30
	jsr LoadPRGBank
	;Clip player Y position (enemy)
	jsr ClipPlayerYEnemy
	;Restore PRG bank
	jsr RestorePRGBank
	rts

ClearSpikes_L:
	;Load PRG bank $30 (clear spikes subroutine bank)
	ldy #$30
	jsr LoadPRGBank
	;Clear spikes
	jsr ClearSpikes
	;Restore PRG bank
	jsr RestorePRGBank
	rts

LoadSceneByte:
	;Load PRG bank $3A (scene data bank)
	ldy #$3A
	jsr LoadPRGBank
	;Get scene data byte
	ldy SceneCommandOffset
	inc SceneCommandOffset
	lda (SceneDataPointer),y
	sta SceneDataByte
	;Restore PRG bank
	jsr RestorePRGBank
	rts

LoadDialogByte:
	;Load PRG bank $3A (dialog data bank)
	ldy #$3A
	jsr LoadPRGBank
	;Get dialog data byte
	ldy #$00
	lda (DialogDataPointer),y
	sta DialogDataByte
	;Restore PRG bank
	jsr RestorePRGBank
	rts

DrawSceneColumn_L:
	;Load PRG bank $3A (draw scene column subroutine bank)
	ldy #$3A
	jsr LoadPRGBank
	;Draw scene column
	jsr DrawSceneColumn
	;Restore PRG bank
	jsr RestorePRGBank
	rts

GetSceneColumnVRAMAddr_L:
	;Load PRG bank $3A (get scene column VRAM address subroutine bank)
	ldy #$3A
	jsr LoadPRGBank
	;Get scene column VRAM address
	jsr GetSceneColumnVRAMAddr
	;Restore PRG bank
	jsr RestorePRGBank
	rts

;;;;;;;;;;;;;;;;;;;;
;LEVEL AREA ROUTINE;
;;;;;;;;;;;;;;;;;;;;
SetLevelAreaNum:
	;Get bits for level
	lda CurLevel
	asl
	asl
	asl
	asl
	sta $10
	;Get bits for area
	lda CurArea
	lsr
	lsr
	lsr
	;Set level area number
	clc
	adc $10
	sta LevelAreaNum
	rts

ItemEnemyBitTable:
	.db $01,$02,$04,$08,$10,$20,$40,$80
LevelAreaInfoPointerTable:
	.dw Level1AreaInfo
	.dw Level2AreaInfo
	.dw Level3AreaInfo
	.dw Level4AreaInfo
	.dw Level5AreaInfo
	.dw Level6AreaInfo
	.dw Level7AreaInfo
	.dw Level8AreaInfo
Level1AreaInfo:
	.db $C0,$00,$8B,$10,$82,$08,$83,$F0
	.db $C3,$0F,$93,$11,$81,$09,$3B,$F1
	.db $C0,$10,$1A,$10,$82,$1C,$3B,$F0
	.db $C1,$1D,$1A,$10,$83,$3B,$A3,$F0
	.db $C0,$3E,$78,$10,$82,$43,$7B,$F0
	.db $84,$47,$98,$10,$84,$47,$99,$F0
	.db $00
Level2AreaInfo:
	.db $C0,$00,$8A,$10,$82,$07,$8B,$F0
	.db $C0,$09,$92,$10,$82,$10,$33,$F0
	.db $C1,$11,$32,$10,$83,$18,$93,$F0
	.db $C0,$19,$72,$10,$82,$1F,$73,$F0
	.db $C0,$21,$92,$10,$82,$22,$93,$F0
	.db $C3,$27,$92,$11,$81,$23,$33,$F1
	.db $C0,$28,$32,$10,$82,$2C,$85,$F0
	.db $C0,$30,$72,$10,$82,$39,$81,$F0
	.db $84,$3D,$80,$10,$84,$3D,$93,$F0
	.db $00
Level3AreaInfo:
	.db $C0,$01,$42,$10,$82,$06,$63,$F0
	.db $C0,$08,$62,$10,$82,$09,$43,$F0
	.db $C0,$0A,$62,$10,$82,$0B,$43,$F0
	.db $C0,$0C,$62,$10,$82,$0D,$43,$F0
	.db $C0,$0E,$6A,$10,$82,$12,$6B,$F0
	.db $C0,$14,$68,$10,$82,$15,$6B,$F0
	.db $C1,$16,$52,$10,$83,$1A,$93,$F0
	.db $C0,$1C,$92,$10,$82,$1D,$53,$F0
	.db $C0,$1E,$92,$10,$82,$20,$83,$F0
	.db $84,$23,$A2,$10,$84,$23,$A3,$F0
	.db $00
Level4AreaInfo:
	.db $C2,$08,$7B,$F1,$80,$02,$7A,$11
	.db $C2,$11,$7B,$F1,$80,$0B,$7A,$11
	.db $C2,$17,$7B,$F1,$80,$13,$7A,$11
	.db $C2,$1C,$91,$D9,$80,$1A,$90,$11
	.db $C3,$22,$9B,$F1,$81,$1E,$12,$11
	.db $C2,$2A,$9B,$F1,$80,$23,$9A,$11
	.db $C2,$67,$53,$F1,$80,$2D,$60,$11
	.db $84,$69,$73,$F1,$84,$69,$72,$11
	.db $00
Level5AreaInfo:
	.db $80,$00,$A2,$2A,$82,$04,$A3,$F0
	.db $80,$00,$52,$10,$82,$04,$53,$F0
	.db $80,$05,$A2,$10,$82,$09,$A3,$F0
	.db $80,$05,$52,$10,$82,$09,$53,$F0
	.db $80,$0A,$A2,$10,$82,$0E,$A3,$F0
	.db $80,$0A,$42,$10,$82,$0E,$43,$F0
	.db $80,$0F,$A2,$10,$82,$13,$A3,$F0
	.db $80,$0F,$52,$10,$82,$13,$53,$F0
	.db $80,$14,$42,$10,$82,$18,$43,$F0
	.db $83,$1C,$99,$B7,$81,$1B,$99,$B7
	.db $83,$1A,$98,$49,$81,$19,$98,$49
	.db $83,$33,$99,$B7,$81,$32,$98,$49
	.db $83,$2B,$98,$C7,$81,$1D,$99,$C7
	.db $80,$2C,$A2,$10,$82,$2D,$53,$F0
	.db $80,$2E,$A2,$10,$82,$2F,$A3,$F0
	.db $80,$30,$A2,$10,$82,$31,$A3,$F0
	.db $00
Level6AreaInfo:
	.db $C0,$00,$92,$10,$82,$03,$93,$F0
	.db $C1,$04,$32,$10,$83,$09,$93,$F0
	.db $C0,$0A,$92,$10,$82,$10,$73,$F0
	.db $C0,$11,$72,$10,$82,$15,$93,$F0
	.db $C0,$17,$92,$10,$82,$1A,$73,$F0
	.db $C0,$1C,$52,$10,$82,$1D,$53,$F0
	.db $C0,$20,$52,$10,$82,$21,$53,$F0
	.db $C0,$24,$52,$10,$82,$25,$53,$F0
	.db $C0,$27,$52,$10,$82,$2B,$73,$F0
	.db $84,$2D,$92,$10,$84,$2D,$93,$F0
	.db $00
Level7AreaInfo:
	.db $C0,$18,$92,$11,$82,$19,$33,$F1
	.db $C0,$1A,$92,$11,$82,$1B,$32,$F1
	.db $C0,$1C,$93,$F1,$82,$1D,$13,$F1
	.db $C0,$1E,$93,$11,$82,$1F,$33,$F1
	.db $C0,$07,$92,$10,$82,$10,$13,$F0
	.db $C0,$11,$12,$10,$82,$15,$93,$F0
	.db $C0,$20,$52,$10,$82,$26,$93,$F0
	.db $C0,$01,$72,$10,$82,$04,$93,$F0
	.db $C0,$29,$72,$10,$82,$2C,$93,$F0
	.db $C0,$31,$72,$10,$82,$34,$93,$F0
	.db $C0,$39,$72,$10,$82,$3C,$93,$F0
	.db $C0,$40,$72,$10,$82,$41,$33,$F0
	.db $C0,$42,$72,$10,$82,$43,$33,$F0
	.db $C0,$44,$72,$10,$82,$45,$33,$F0
	.db $84,$47,$92,$10,$82,$47,$93,$F0
	.db $00
Level8AreaInfo:
	.db $C0,$00,$92,$10,$82,$52,$73,$F0
	.db $C0,$02,$72,$10,$82,$52,$73,$F0
	.db $C0,$1A,$72,$10,$82,$52,$73,$F0
	.db $C0,$25,$72,$10,$82,$52,$73,$F0
	.db $C0,$35,$72,$10,$82,$52,$73,$F0
	.db $C0,$40,$72,$10,$82,$52,$73,$F0
	.db $C0,$4E,$72,$10,$82,$52,$73,$F0
	.db $00

;;;;;;;;;;;;;;;;;;;;
;GAME MODE ROUTINES;
;;;;;;;;;;;;;;;;;;;;
RunGameMode:
	;Do jump table
	lda GameMode
	jsr DoJumpTable
GameModeJumpTable:
	.dw RunGameMode_Title		;$00: Title
	.dw RunGameMode_InitGameState	;$01: Init game state
	.dw RunGameMode_Dialog		;$02: Dialog
	.dw RunGameMode_StageSelect	;$03: Stage select
	.dw RunGameMode_Ready		;$04: Ready
	.dw RunGameMode_Gameplay	;$05: Gameplay
	.dw RunGameMode_Death		;$06: Death
	.dw RunGameMode_GameOver	;$07: Game over
	.dw RunGameMode_Victory		;$08: Victory
	.dw RunGameMode_Ending		;$09: Ending

;TITLE MODE ROUTINES
RunGameMode_Title:
	;Do jump table
	lda GameSubmode
	jsr DoJumpTable
TitleJumpTable:
	.dw RunGameSubmode_TitleLegalInit	;$00  Legal screen init
	.dw RunGameSubmode_TitleLegalMain	;$01  Legal screen main
	.dw RunGameSubmode_TitleScreenMain	;$02  Title screen main
	.dw RunGameSubmode_TitleScreenWait	;$03  Title screen wait
	.dw RunGameSubmode_TitlePassword	;$04  Password entry
	.dw RunGameSubmode_TitleDemoMain	;$05  Title attract demo main
	.dw RunGameSubmode_TitleReloadClear	;$06  Title reload clear
	.dw RunGameSubmode_TitleReloadInit	;$07  Title reload init
	.dw RunGameSubmode_TitleReloadWait	;$08  Title reload wait
	.dw RunGameSubmode_TitleReloadEnd	;$09  Title reload end
;$00: Legal screen init
RunGameSubmode_TitleLegalInit:
	;Next submode ($01: Legal screen main)
	inc GameSubmode
	;Clear sound
	jsr ClearSound
	;Write legal nametable
	ldx #$06
	jsr WriteNametableData
	;Set demo index
	lda #$0E
	sta DemoIndex
RunGameSubmode_TitleLegalInit_EntClear:
	;Init game state
	jsr RunGameMode_InitGameState
	;Load legal/title palette
	lda #$01
	jsr WritePaletteStrip8
	;Clear scroll position
	lda #$A8
	sta TempMirror_PPUCTRL
	lda #$00
	sta TempMirror_PPUSCROLL_X
	sta TempMirror_PPUSCROLL_Y
	;Set timer
	sta LegalWaitTimer
	;Load title CHR bank set
	ldx #$00
	jsr LoadCHRBankSet
	;Load CHR bank
	lda #$0A
	sta TempCHRBanks
	;Clear enemies
	jmp ClearEnemies

;INIT GAME STATE ROUTINES
RunGameMode_InitGameState:
	;Load PRG bank $3C (init game state mode subroutine bank)
	ldy #$3C
	jsr LoadPRGBank
	;Init game state mode subroutine
	jsr RunGameMode_InitGameStateSub
	;Restore PRG bank
	jsr RestorePRGBank
	rts

;TITLE MODE ROUTINES
;$01: Legal screen main
RunGameSubmode_TitleLegalMain:
	;Decrement timer, check if 0
	dec LegalWaitTimer
	bne RunGameSubmode_TitleScreenMain_PassExit
	;Clear title screen
	jsr RunGameSubmode_TitleDemoMain_Clear
	;Play music
	ldy #MUSIC_TITLE
	jmp LoadSound
LoadTitleScreen:
	;Set demo timer
	lda #$C0
	sta DemoTimer+1
	lda #$02
	sta DemoTimer
	;Next submode ($09: Title reload end)
	inc GameSubmode
	;Load CHR bank
	lda #$3E
	sta TempCHRBanks
	;Set title screen cursor position
	lda #$46
	sta TitleCursorPos
	;Load IRQ buffer set
	ldx #$24
	jsr LoadIRQBufferSet
	;Write title nametable
	ldx #$02
	jmp WriteNametableData
;$02: Title screen main
RunGameSubmode_TitleScreenMain:
	;Decrement demo timer, check if 0
	dec DemoTimer+1
	bne RunGameSubmode_TitleScreenMain_PassCheck
	dec DemoTimer
	beq RunGameSubmode_TitleScreenMain_Demo
RunGameSubmode_TitleScreenMain_PassCheck:
	;Check for SELECT/UP/DOWN press
	lda JoypadDown
	and #(JOY_SELECT|JOY_UP|JOY_DOWN)
	bne RunGameSubmode_TitleScreenMain_Pass
	;Check for START press
	lda JoypadDown
	and #JOY_START
	bne RunGameSubmode_TitleScreenMain_Start
RunGameSubmode_TitleScreenMain_PassExit:
	rts
RunGameSubmode_TitleScreenMain_Pass:
	;Toggle title screen cursor position
	lda TitleCursorPos
	eor #$01
	sta TitleCursorPos
	;Write title cursor VRAM strip
	jsr WriteVRAMStrip
	;Play sound
	ldy #SE_CURSMOVE
	jmp LoadSound
RunGameSubmode_TitleScreenMain_Start:
	;Clear sound
	jsr ClearSound
	;Play sound
	ldy #SE_SELECT
	jsr LoadSound
	;Check for title screen cursor position top
	lda TitleCursorPos
	cmp #$46
	beq RunGameSubmode_TitleScreenMain_Next
	;Clear password buffer
	lda #$01
	ldx #$05
RunGameSubmode_TitleScreenMain_Loop:
	;Clear password character
	sta PasswordBuffer,x
	;Loop for each character
	dex
	bpl RunGameSubmode_TitleScreenMain_Loop
	;Clear password index
	lda #$00
	sta PasswordIndex
	sta PasswordIndex+1
	;Next submode ($04: Password entry)
	lda #$04
	sta GameSubmode
	;Init game state
	jmp RunGameMode_InitGameState
RunGameSubmode_TitleScreenMain_Next:
	;Next submode ($03: Title screen wait)
	inc GameSubmode
	;Set timer
	lda #$50
	sta TitleWaitTimer
	rts
RunGameSubmode_TitleScreenMain_Demo:
	;Get next demo index
	ldy DemoIndex
	lda TitleDemoTable,y
	sta DemoIndex
	;Init demo
	jsr RunGameSubmode_EndingDemoEnd
	;Next mode ($00: Title)
	lda #$00
	sta GameMode
	;Clear BG fire arch timer
	sta BGFireArchTimer
	;Next submode ($05: Title attract demo main)
	lda #$05
	sta GameSubmode
	;Set black screen timer
	sta BlackScreenTimer
	;Set global timer
	lda #$FA
	sta LevelGlobalTimer
RunGameSubmode_TitleScreenMain_DemoExit:
	rts
TitleDemoTable:
	.db $01,$FF,$02,$05,$FF,$FF,$07,$FF,$09,$FF,$0A,$0B,$0D,$FF,$FF,$FF
;$03: Title screen wait
RunGameSubmode_TitleScreenWait:
	;Decrement timer, check if 0
	dec TitleWaitTimer
	beq RunGameSubmode_TitleScreenWait_ToDialog
	;Write "START" text flash VRAM strip
	lda TitleWaitTimer
	and #$08
	jmp WriteVRAMStrip
RunGameSubmode_TitleScreenWait_ToDialog:
	;Clear enemy flags
	lda #$00
	sta Enemy_Flags
	;Next submode ($00: Init)
	sta GameSubmode
	;Next mode ($02: Dialog)
	lda #$02
	sta GameMode
	;Init game state
	jmp RunGameMode_InitGameState
;$05: Title attract demo main
RunGameSubmode_TitleDemoMain:
	;Check for START press
	lda JoypadDown
	and #JOY_START
	bne RunGameSubmode_TitleDemoMain_Clear
	;Update demo
	jsr RunGameSubmode_EndingDemoMain
	;Check for death mode
	lda GameMode
	cmp #$06
	beq RunGameSubmode_TitleDemoMain_Clear
	;Check for demo end flag
	lda DemoEndFlag
	beq RunGameSubmode_TitleScreenMain_DemoExit
RunGameSubmode_TitleDemoMain_Clear:
	;Next mode ($00: Title)
	lda #$00
	sta GameMode
	;Next submode (06: Title screen reload clear)
	lda #$06
	sta GameSubmode
	;Set black screen timer
	sta BlackScreenTimer
	;Clear sound
	jmp ClearSound
;$06: Title screen reload clear
RunGameSubmode_TitleReloadClear:
	;Next submode ($07: Title screen reload init)
	inc GameSubmode
	;Clear demo end flag
	lda #$00
	sta DemoEndFlag
	;Clear enemies
	jsr ClearEnemies
	;Clear scroll and reload palette/CHR banks
	jsr RunGameSubmode_TitleLegalInit_EntClear
	;Load blank palette
	lda #$03
	jmp WritePaletteStrip8
;$07: Title screen reload init
RunGameSubmode_TitleReloadInit:
	;Next submode ($08: Title screen reload wait)
	inc GameSubmode
	;Load title screen
	jmp LoadTitleScreen
;$08: Title screen reload wait
RunGameSubmode_TitleReloadWait:
	;If black screen timer not 0, exit early
	lda BlackScreenTimer
	bne RunGameSubmode_TitleScreenBackWait_Exit
	;Next submode ($09: Title screen reload end)
	inc GameSubmode
RunGameSubmode_TitleScreenBackWait_Exit:
	rts
;$09: Title screen reload end
RunGameSubmode_TitleReloadEnd:
	;Next submode ($02: Title screen main)
	lda #$02
	sta GameSubmode
	;Load legal/title palette
	lda #$01
	jmp WritePaletteStrip8

;DIALOG MODE ROUTINES
RunGameMode_Dialog:
	;Load PRG bank $38 (dialog mode subroutine bank)
	ldy #$38
	jsr LoadPRGBank
	;Dialog mode subroutine
	jsr RunGameMode_DialogSub
	;Restore PRG bank
	jsr RestorePRGBank
	rts

;STAGE SELECT MODE ROUTINES
ToStageSelect:
	;Clear sound
	jsr ClearSound
	;Play music
	ldy #MUSIC_STAGESEL
	jsr LoadSound
ToStageSelect_EntDialog:
	;Load PRG bank $3C (init level state subroutine bank)
	ldy #$3C
	jsr LoadPRGBank
	;Init level state
	jsr InitLevelStateFirst
	;Restore PRG bank
	jsr RestorePRGBank
	rts

RunGameMode_StageSelect:
	;Load PRG bank $38 (stage select mode subroutine bank)
	ldy #$38
	jsr LoadPRGBank
	;Stage select subroutine
	jsr RunGameMode_StageSelectSub
	;Restore PRG bank
	jsr RestorePRGBank
	rts

;READY MODE ROUTINES
RunGameMode_Ready:
	;Load PRG bank $3A
	ldy #$3A
	jsr LoadPRGBank
	;Ready subroutine
	jsr RunGameMode_ReadySub
	;Restore PRG bank
	jsr RestorePRGBank
	rts

;DEATH MODE ROUTINES
RunGameMode_Death:
	;Decrement timer, check if 0
	dec GameSubmode
	beq RunGameMode_Death_Next
	;Clear joypad bits
	lda #$00
	sta JoypadCur
	sta JoypadDown
	;Clear player velocity
	sta ScrollXVelHi
	sta ScrollXVelLo
	sta Enemy_XVelHi
	sta Enemy_XVelLo
	;Handle gameplay
	jmp RunGameMode_Gameplay_Play
RunGameMode_Death_Next:
	;Init level state
	lda #$00
	sta TempIRQEnableFlag
	sta EnemyTriggeredBits
	sta EnemyTriggeredBits+1
	sta IceMeltedBits
	;Clear gameplay flag
	sta GameplayFlag
	;Clear paused flag
	sta PausedFlag
	;If player lives 0, setup next mode ($07: Game over)
	lda NumLives
	beq RunGameMode_Death_GameOver
	;Decrement player lives
	dec NumLives
	;Next mode ($04: Ready)
	lda #$04
	sta GameMode
	;Clear sound
	jsr ClearSound
	;Set player HP and clear enemies
	jmp RunGameSubmode_GameOverWait_NextNoClear
RunGameMode_Death_GameOver:
	;Clear score
	lda #$00
	sta ScoreCurrent
	sta ScoreCurrent+1
	;Set black screen timer
	lda #$02
	sta BlackScreenTimer
	;Next mode ($07: Game over)
	jmp GoToNextGameMode

;GAME OVER MODE ROUTINES
RunGameMode_GameOver:
	;Do jump table
	lda GameSubmode
	jsr DoJumpTable
GameOverJumpTable:
	.dw RunGameSubmode_GameOverInit		;$00  Init
	.dw RunGameSubmode_GameOverScroll	;$01  Scroll text
	.dw RunGameSubmode_GameOverWait		;$02  Wait
;$00: Init
RunGameSubmode_GameOverInit:
	;Clear enemies
	jsr ClearEnemies
	;Init game over enemies
	ldx #$07
RunGameSubmode_GameOverInit_Loop:
	;Clear enemy props
	lda #$00
	sta Enemy_Props,x
	;Set enemy position
	lda #$58
	sta Enemy_Y,x
	lda GameOverEnemyX,x
	sta Enemy_X,x
	;Set enemy animation
	ldy #$30
	jsr SetEnemyAnimation
	;Set enemy sprite
	lda GameOverEnemySprite,x
	sta Enemy_SpriteLo,x
	;Clear enemy tile offset
	lda #$00
	sta Enemy_Temp7,x
	;Loop for each enemy
	dex
	bpl RunGameSubmode_GameOverInit_Loop
	;Clear nametable
	jsr ClearNametableData
	;Load game over palette
	lda #$13
	jsr WritePaletteStrip8
	;Clear scroll position
	lda #$88
	sta TempMirror_PPUCTRL
	lda #$00
	sta TempMirror_PPUSCROLL_X
	sta TempMirror_PPUSCROLL_Y
	;Load game over CHR bank set
	ldx #$3E
	jsr LoadCHRBankSet
	;Init game over enemies X velocity
	ldx #$07
RunGameSubmode_GameOverInit_VelLoop:
	;Set enemy X velocity
	lda GameOverEnemyXVel,x
	sta Enemy_XVelHi,x
	;Loop for each enemy
	dex
	bpl RunGameSubmode_GameOverInit_VelLoop
	;Set animation timer
	lda #$02
	sta Enemy_Temp2
	;Next submode ($01: Scroll text)
	inc GameSubmode
	;Clear sound
	jsr ClearSound
	;Play music
	ldy #MUSIC_GAMEOVER
	jmp LoadSound
GameOverEnemySprite:
	.db $8A,$8C,$8E,$90,$92,$94,$90,$96
GameOverEnemyX:
	.db $48,$54,$60,$6C,$84,$90,$9C,$A8
GameOverEnemyXVel:
	.db $04,$03,$02,$01,$FF,$FE,$FD,$FC
;$01: Scroll text
RunGameSubmode_GameOverScroll:
	;Apply game over enemies X velocity
	ldx #$07
RunGameSubmode_GameOverScroll_ApplyLoop:
	;Apply enemy X velocity
	lda Enemy_X,x
	clc
	adc Enemy_XVelHi,x
	sta Enemy_X,x
	;Loop for each enemy
	dex
	bpl RunGameSubmode_GameOverScroll_ApplyLoop
	;If enemy X position $78, flip enemy X
	lda Enemy_X
	cmp #$78
	beq RunGameSubmode_GameOverScroll_FlipP
	;If enemy X position $48/$A8, flip enemy X velocity
	cmp #$A8
	beq RunGameSubmode_GameOverScroll_FlipX
	cmp #$48
	bne RunGameSubmode_GameOverScroll_Exit
	;Decrement animation timer, check if 0
	dec Enemy_Temp2
	beq RunGameSubmode_GameOverScroll_Next
RunGameSubmode_GameOverScroll_FlipX:
	;Flip game over enemies X velocity
	ldx #$07
RunGameSubmode_GameOverScroll_FlipXLoop:
	;Flip enemy X velocity
	lda #$00
	sec
	sbc Enemy_XVelHi,x
	sta Enemy_XVelHi,x
	;Loop for each enemy
	dex
	bpl RunGameSubmode_GameOverScroll_FlipXLoop
	rts
RunGameSubmode_GameOverScroll_FlipP:
	;Flip game over enemies X
	ldx #$07
RunGameSubmode_GameOverScroll_FlipPLoop:
	;Flip enemy X
	lda Enemy_Props,x
	eor #$40
	sta Enemy_Props,x
	;Loop for each enemy
	dex
	bpl RunGameSubmode_GameOverScroll_FlipPLoop
RunGameSubmode_GameOverScroll_Exit:
	rts
RunGameSubmode_GameOverScroll_Next:
	;Write "CONTINUE"/"END" text VRAM strip
	lda #$15
	jsr WriteVRAMStrip
	;If current level < 5, write "STAGE SELECT" text VRAM strip
	lda CurLevel
	cmp #$04
	bcs RunGameSubmode_GameOverScroll_NoStageSelect
	;Write "STAGE SELECT" text VRAM strip
	lda #$71
	jsr WriteVRAMStrip
RunGameSubmode_GameOverScroll_NoStageSelect:
	;Next submode ($02: Wait)
	inc GameSubmode
	;Set enemy props
	lda #$00
	sta Enemy_Props+$08
	;Clear enemy tile offset
	sta Enemy_Temp7+$08
	;Set enemy position
	lda #$48
	sta Enemy_X+$08
	lda #$86
	sta Enemy_Y+$08
	;Set enemy animation
	ldx #$08
	ldy #$26
	jmp SetEnemyAnimation
;$02: Wait
RunGameSubmode_GameOverWait:
	;Check for A/START press
	lda JoypadDown
	and #(JOY_A|JOY_START)
	bne RunGameSubmode_GameOverWait_Select
	;Check for UP press
	lda JoypadDown
	and #JOY_UP
	bne RunGameSubmode_GameOverWait_UpCheck
	;Check for DOWN press
	lda JoypadDown
	and #JOY_DOWN
	beq RunGameSubmode_GameOverWait_Exit
	;If current level < 5, check for "END" option
	lda Enemy_Y+$08
	ldy CurLevel
	cpy #$04
	bcc RunGameSubmode_GameOverWait_EndCheck
	;If enemy Y position $96, exit early
	cmp #$96
	beq RunGameSubmode_GameOverWait_Exit
	bne RunGameSubmode_GameOverWait_Down
RunGameSubmode_GameOverWait_EndCheck:
	;If enemy Y position $A6, exit early
	cmp #$A6
	beq RunGameSubmode_GameOverWait_Exit
RunGameSubmode_GameOverWait_Down:
	;Move cursor down $10
	clc
	adc #$10
	bne RunGameSubmode_GameOverWait_SetY
RunGameSubmode_GameOverWait_UpCheck:
	;If enemy Y position $86, exit early
	lda Enemy_Y+$08
	cmp #$86
	beq RunGameSubmode_GameOverWait_Exit
	;Move cursor up $10
	sec
	sbc #$10
RunGameSubmode_GameOverWait_SetY:
	sta Enemy_Y+$08
	;Play sound
	ldy #SE_CURSMOVE
	jmp LoadSound
RunGameSubmode_GameOverWait_Select:
	;Set player lives
	lda #$02
	sta NumLives
	;Next submode
	lda #$00
	sta GameSubmode
	;Reset player max HP
	lda #$14
	sta Enemy_Temp4
	;Clear scroll position
	lda #$A8
	sta TempMirror_PPUCTRL
	;Clear sound
	jsr ClearSound
	;Play sound
	ldy #SE_SELECT
	jsr LoadSound
	;Check for "CONTINUE" option
	lda Enemy_Y+$08
	cmp #$86
	beq RunGameSubmode_GameOverWait_NextClear
	;Check for "END" option
	cmp #$96
	beq RunGameSubmode_GameOverWait_End
	;Setup next mode ($03: Stage select)
	jsr ToStageSelect
	lda #$03
	sta GameMode
	;Clear level state
	lda #$00
	sta CurArea
	sta BossEnemyIndex
	sta Enemy_Flags
	;Clear enemies
	jmp ClearEnemies_NoPl
RunGameSubmode_GameOverWait_End:
	;Next mode ($00: Title)
	lda #$00
	sta GameMode
	;Clear level state
	sta BossEnemyIndex
	sta CurArea
	sta Level5ExitMode
RunGameSubmode_GameOverWait_Exit:
	rts
RunGameSubmode_GameOverWait_NextClear:
	;Next mode ($04: Ready)
	lda #$04
	sta GameMode
	;Reset item collected bits
	ldx CurLevel
	lda ItemCollectedBits
	and ItemCollectedMask0Table,x
	sta ItemCollectedBits
	lda ItemCollectedBits+1
	and ItemCollectedMask1Table,x
	sta ItemCollectedBits+1
RunGameSubmode_GameOverWait_NextNoClear:
	;Clear IRQ enable flag
	lda #$00
	sta TempIRQEnableFlag
	;Reset player HP
	lda Enemy_Temp4
	sta Enemy_HP
	;Clear enemies
	jmp ClearEnemies
ItemCollectedMask0Table:
	.db $10,$21,$00,$04,$B0,$8B,$0F,$00
ItemCollectedMask1Table:
	.db $40,$4C,$44,$52,$40,$18,$14,$00

;VICTORY MODE ROUTINES
RunGameMode_Victory:
	;Load PRG bank $32 (victory mode subroutine bank)
	ldy #$32
	jsr LoadPRGBank
	;Victory mode subroutine
	jsr RunGameMode_VictorySub
	;Restore PRG bank
	jsr RestorePRGBank
	rts

;ENDING MODE ROUTINES
RunGameMode_Ending:
	;Do jump table
	lda GameSubmode
	jsr DoJumpTable
EndingJumpTable:
	.dw RunGameSubmode_EndingDemoInit	;$00  Init
	.dw RunGameSubmode_EndingDemoMain	;$01  Main
	.dw RunGameSubmode_EndingDemoWait	;$02  Wait
	.dw RunGameSubmode_EndingDemoEnd	;$03  End
;$00: Init
RunGameSubmode_EndingDemoInit:
	;Load PRG bank $3A (ending mode subroutine bank)
	ldy #$3A
	jsr LoadPRGBank
	;Ending mode subroutine
	jsr RunGameSubmode_EndingDemoInitSub
	;Restore PRG bank
	jsr RestorePRGBank
	rts
;$01: Main
RunGameSubmode_EndingDemoMain:
	;Decrement demo timer
	inc DemoTimer+1
	lda DemoTimer+1
	and #$01
	bne RunGameSubmode_EndingDemoMain_Input
	dec DemoTimer
	beq RunGameSubmode_EndingDemoMain_End
RunGameSubmode_EndingDemoMain_Input:
	;Load PRG bank $3A (update demo input subroutine bank)
	ldy #$3A
	jsr LoadPRGBank
	;Update demo input
	jsr UpdateDemoInputSub
	;Restore PRG bank
	jsr RestorePRGBank
	;Handle gameplay
	jmp RunGameMode_Gameplay
RunGameSubmode_EndingDemoMain_End:
	;Next task ($00: Init)
	lda #$00
	sta DemoWaitMode
	;Set demo credits index
	lda #$04
	sta DemoCreditsIndex
	;Set demo end flag
	inc DemoEndFlag
	;Next submode ($02: Wait)
	inc GameSubmode
	rts
;$02: Wait
RunGameSubmode_EndingDemoWait:
	;Load PRG bank $3A (ending mode subroutine bank)
	ldy #$3A
	jsr LoadPRGBank
	;Ending mode subroutine
	jsr RunGameSubmode_EndingDemoWaitSub
	;Restore PRG bank
	jsr RestorePRGBank
	rts
;$03: End
RunGameSubmode_EndingDemoEnd:
	;Load PRG bank $3A (ending mode subroutine bank)
	ldy #$3A
	jsr LoadPRGBank
	;Ending mode subroutine
	jsr RunGameSubmode_EndingDemoEndSub
	;Restore PRG bank
	jsr RestorePRGBank
	rts

GoToNextGameMode:
	;Next mode
	inc GameMode
	lda #$00
	sta GameSubmode
	rts

;;;;;;;;;;;;;;;
;MISC ROUTINES;
;;;;;;;;;;;;;;;
;DO JUMP TABLE ROUTINE
DoJumpTable:
	;Get jump table offset
	asl
	;Get jump address
	tay
	pla
	sta $00
	pla
	adc #$00
	sta $01
	iny
	lda ($00),y
	sta $02
	iny
	lda ($00),y
	sta $03
	;Jump to address
	jmp ($02)

;DRAW NAMETABLE INCREMENT ADDRESS ROUTINE
DrawNametableIncAddr:
	;Increment address
	clc
	adc $00,x
	sta $00,x
	bcc DrawNametableIncAddr_NoC
	inc $01,x
DrawNametableIncAddr_NoC:
	rts

;PRNG ROUTINE
GetPRNGValue:
	;Save PRNG index
	sty PRNGDataSaveY
	;Get data byte
	ldy #$00
	lda (PRNGDataPointer),y
	inc PRNGDataPointer
	;Restore PRNG index
	ldy PRNGDataSaveY
	rts

;SIN/COS ROUTINES
CalcSin:
	;Check for quadrant 4
	cmp #$C0
	bcs CalcCos_Q4
	;Check for quadrant 3
	cmp #$80
	bcs CalcSin_Q3
	;Check for quadrant 2
	cmp #$40
	bcs CalcCos_Q2
CalcSin_Q1:
	;Clear carry (positive)
	clc
	bcc CalcSin_Get
CalcSin_Q3:
	;Set carry (negative)
	sec
CalcSin_Get:
	;Get value from table
	and #$3F
	tay
	lda SineTable,y
	rts

CalcCos:
	;Check for quadrant 4
	cmp #$C0
	bcs CalcSin_Q1
	;Check for quadrant 3
	cmp #$80
	bcs CalcCos_Q4
	;Check for quadrant 2
	cmp #$40
	bcs CalcSin_Q3
CalcCos_Q2:
	;Clear carry (positive)
	clc
	bcc CalcCos_Get
CalcCos_Q4:
	;Set carry (negative)
	sec
CalcCos_Get:
	;Get value from table (inverted)
	eor #$3F
	and #$3F
	tay
	lda SineTable,y
	rts

SineTable:
	.db $00,$06,$0C,$12,$19,$1F,$25,$2B,$31,$38,$3E,$44,$4A,$50,$56,$5C
	.db $61,$67,$6D,$73,$78,$7E,$83,$88,$8E,$93,$98,$9D,$A2,$A7,$AB,$B0
	.db $B5,$B9,$BD,$C1,$C5,$C9,$CD,$D1,$D4,$D8,$DB,$DE,$E1,$E4,$E7,$EA
	.db $EC,$EE,$F1,$F3,$F4,$F6,$F8,$F9,$FB,$FC,$FD,$FE,$FE,$FF,$FF,$FF

;DRAW DECIMAL VALUE ROUTINES
HexToDec:
	;Set 10's digit tile to '0'-1
	ldy #$1A
	sty $00
HexToDec_Loop:
	;Loop for 10's digit
	inc $00
	sec
	sbc #$0A
	bcs HexToDec_Loop
	;Add remainder (1's digit) to to digit tile '9'+1
	clc
	adc #$25
	sta $01
	rts

DrawDecimalValue:
	;Convert values 00-99 to tiles
	jsr HexToDec
	;Set characters to VRAM
	lda $00
	sta VRAMBuffer,x
	inx
	lda $01
	sta VRAMBuffer,x
	inx
	rts

;;;;;;;;;;;;;;;;;;;;;;;;;;
;ENEMY ANIMATION ROUTINES;
;;;;;;;;;;;;;;;;;;;;;;;;;;
UpdateEnemyAnimationCheck:
	;If gameplay paused, exit early
	lda PausedFlag
	ora DemoEndFlag
	bne UpdateEnemyAnimationCheck_Exit
	;Load PRG bank $3A (enemy animation data bank)
	ldy #$3A
	jsr LoadPRGBank
	;Update enemy animation
	jsr UpdateEnemyAnimation
	;Restore PRG bank
	jsr RestorePRGBank
UpdateEnemyAnimationCheck_Exit:
	rts

UpdateEnemyAnimation:
	;Check for lava mask animation
	lda Enemy_Flags+$0C
	beq UpdateEnemyAnimation_NoMask
	lda Enemy_Anim+$0C
	cmp #$A5
	bne UpdateEnemyAnimation_NoMask
	;Update lava mask animation
	lda #$04
	sta $0C
	ldx #$0C
	jsr UpdateEnemyAnimationSub
	jmp UpdateEnemyAnimation_Mask
UpdateEnemyAnimation_NoMask:
	;Init OAM buffer offset
	lda #$04
	sta $0C
UpdateEnemyAnimation_Mask:
	;Update enemies animation (priority flag set)
	ldx #$00
	stx $0D
UpdateEnemyAnimation_PrioLoop:
	;Check if enemy is visible and priority flag is set
	lda Enemy_Flags,x
	and #(EF_PRIORITY|EF_VISIBLE)
	cmp #(EF_PRIORITY|EF_VISIBLE)
	bne UpdateEnemyAnimation_PrioNext
	;Update enemy animation
	jsr UpdateEnemyAnimationSub
UpdateEnemyAnimation_PrioNext:
	;Loop for each enemy
	inc $0D
	ldx $0D
	cpx #$10
	bne UpdateEnemyAnimation_PrioLoop
	;Increment OAM start index for priority flag clear enemies
	inc EnemyOAMStartIndex
	lda EnemyOAMStartIndex
	and #$0F
	sta EnemyOAMStartIndex
	;Update enemies animation (priority flag clear)
	tax
	stx $0D
UpdateEnemyAnimation_NoPrioLoop:
	;Check if enemy is visible and priority flag is clear
	lda Enemy_Flags,x
	and #(EF_PRIORITY|EF_VISIBLE)
	cmp #EF_VISIBLE
	bne UpdateEnemyAnimation_NoPrioNext
	;Update enemy animation
	jsr UpdateEnemyAnimationSub
UpdateEnemyAnimation_NoPrioNext:
	;Loop for each enemy
	inc $0D
	lda $0D
	and #$0F
	sta $0D
	tax
	cpx EnemyOAMStartIndex
	bne UpdateEnemyAnimation_NoPrioLoop
	;Fill rest of OAM buffer $F4
	ldx $0C
	lda #$F4
UpdateEnemyAnimation_EndLoop:
	sta OAMBuffer,x
	inx
	inx
	inx
	inx
	bne UpdateEnemyAnimation_EndLoop
	rts

UpdateEnemyAnimationSub:
	;Check to update enemy animation
	lda Enemy_Flags,x
	and #EF_NOANIM
	bne UpdateEnemyAnimationSub_NoAnim
	;Decrement enemy animation timer, check if 0
	dec Enemy_AnimTimer,x
	bne UpdateEnemyAnimationSub_NoAnim
	;Increment enemy animation frame
	inc Enemy_AnimOffs,x
	inc Enemy_AnimOffs,x
	;Check for bit 0 set
	lda Enemy_Anim,x
	tay
	lsr
	bcs UpdateEnemyAnimationSub_Anim1
	;Get animation data pointer
	lda AnimationData00PointerTable,y
	sta $08
	lda AnimationData00PointerTable+1,y
	sta $09
	;Get next animation frame
	ldy Enemy_AnimOffs,x
	lda ($08),y
	;Check for end of animation
	bpl UpdateEnemyAnimationSub_SetAnim
	bmi UpdateEnemyAnimationSub_ResetAnim
UpdateEnemyAnimationSub_Anim1:
	;Get animation data pointer
	lda AnimationData01PointerTable-1,y
	sta $08
	lda AnimationData01PointerTable-1+1,y
	sta $09
	;Get next animation frame
	ldy Enemy_AnimOffs,x
	lda ($08),y
	;Check for end of animation
	bpl UpdateEnemyAnimationSub_SetAnim
UpdateEnemyAnimationSub_ResetAnim:
	;Reset enemy animation frame
	lda #$00
	sta Enemy_AnimOffs,x
	;Set enemy animation timer
	tay
	lda ($08),y
	and #$7F
UpdateEnemyAnimationSub_SetAnim:
	sta Enemy_AnimTimer,x
	;Set enemy sprite
	iny
	lda ($08),y
	sta Enemy_SpriteLo,x
UpdateEnemyAnimationSub_NoAnim:
	;Check for sprites $000-$0FF
	lda Enemy_SpriteHi,x
	beq UpdateEnemyAnimationSub_Sprite000
	;Check for sprites $100-$1FF
	cmp #$01
	beq UpdateEnemyAnimationSub_Sprite100
	;Check for sprites $200-$2FF
	cmp #$02
	beq UpdateEnemyAnimationSub_Sprite200
	;Handle sprites $300-$3FF
	ldy Enemy_SpriteLo,x
	lda SpriteData300PointerTable,y
	sta $08
	lda SpriteData300PointerTable+1,y
	sta $09
	bne UpdateEnemyAnimationSub_Draw
UpdateEnemyAnimationSub_Sprite200:
	;Handle sprites $200-$2FF
	ldy Enemy_SpriteLo,x
	lda SpriteData200PointerTable,y
	sta $08
	lda SpriteData200PointerTable+1,y
	sta $09
	bne UpdateEnemyAnimationSub_Draw
UpdateEnemyAnimationSub_Sprite100:
	;Handle sprites $100-$1FF
	ldy Enemy_SpriteLo,x
	lda SpriteData100PointerTable,y
	sta $08
	lda SpriteData100PointerTable+1,y
	sta $09
	bne UpdateEnemyAnimationSub_Draw
UpdateEnemyAnimationSub_Sprite000:
	;Handle sprites $000-$0FF
	ldy Enemy_SpriteLo,x
	lda SpriteData000PointerTable,y
	sta $08
	lda SpriteData000PointerTable+1,y
	sta $09
UpdateEnemyAnimationSub_Draw:
	;Draw sprite
	lda Enemy_X,x
	sta $00
	lda Enemy_Y,x
	sta $01
	lda Enemy_Props,x
	sta $02
	lda Enemy_Temp7,x
	sta $03
	stx $0D
	jsr DrawSprite
	stx $0C
UpdateEnemyAnimationSub_Exit:
	rts

DrawSprite:
	;Get number of OAM entries used
	ldx $0C
	ldy #$00
	lda ($08),y
	sta $04
	beq UpdateEnemyAnimationSub_Exit
	iny
	;Check if enemy is facing left or right
	lda $02
	and #$40
	bne DrawSprite_LeftLoop
DrawSprite_RightLoop:
	;Set OAM Y position
	lda ($08),y
	clc
	adc $01
	sta OAMBuffer,x
	iny
	;Set OAM tile
	lda ($08),y
	sec
	rol
	eor $03
	sta OAMBuffer+1,x
	iny
	;Check to load new attribute
	bcc DrawSprite_RightPrev
	;Set OAM attribute
	lda ($08),y
	eor $02
	sta OAMBuffer+2,x
	;Save OAM attribute previous value
	sta OAMPrevAttr
	iny
	bne DrawSprite_RightNoPrev
DrawSprite_RightPrev:
	;Set OAM attribute to previous value
	lda OAMPrevAttr
	sta OAMBuffer+2,x
DrawSprite_RightNoPrev:
	;Check if OAM X position is to left or right
	lda ($08),y
	bmi DrawSprite_RightLeft
	;Check if OAM X position is offscreen (right)
	clc
	adc $00
	bcc DrawSprite_RightSetX
	bcs DrawSprite_RightNext
DrawSprite_RightLeft:
	;Check if OAM X position is offscreen (left)
	clc
	adc $00
	bcc DrawSprite_RightNext
DrawSprite_RightSetX:
	;Set OAM X position
	sta OAMBuffer+3,x
	;Check for OAM buffer overflow
	inx
	inx
	inx
	inx
	beq DrawSprite_End
DrawSprite_RightNext:
	;Loop for each entry
	iny
	dec $04
	bne DrawSprite_RightLoop
	rts
DrawSprite_End:
	pla
	pla
	rts
DrawSprite_LeftLoop:
	;Set OAM Y position
	lda ($08),y
	clc
	adc $01
	sta OAMBuffer,x
	iny
	;Set OAM tile
	lda ($08),y
	sec
	rol
	eor $03
	sta OAMBuffer+1,x
	iny
	;Check to load new attribute
	bcc DrawSprite_LeftPrev
	;Set OAM attribute
	lda ($08),y
	eor $02
	sta OAMBuffer+2,x
	;Save OAM attribute previous value
	sta OAMPrevAttr
	iny
	bne DrawSprite_LeftNoPrev
DrawSprite_LeftPrev:
	;Set OAM attribute to previous value
	lda OAMPrevAttr
	sta OAMBuffer+2,x
DrawSprite_LeftNoPrev:
	;Check if OAM X position is to left or right
	lda #$F8
	sec
	sbc ($08),y
	bmi DrawSprite_LeftLeft
	;Check if OAM X position is offscreen (right)
	clc
	adc $00
	bcc DrawSprite_LeftSetX
	bcs DrawSprite_LeftNext
DrawSprite_LeftLeft:
	;Check if OAM X position is offscreen (left)
	clc
	adc $00
	bcc DrawSprite_LeftNext
DrawSprite_LeftSetX:
	;Set OAM X position
	sta OAMBuffer+3,x
	;Check for OAM buffer overflow
	inx
	inx
	inx
	inx
	beq DrawSprite_End
DrawSprite_LeftNext:
	;Loop for each entry
	iny
	dec $04
	bne DrawSprite_LeftLoop
	rts

;;;;;;;;;;;;;;;;;;;;
;SCROLLING ROUTINES;
;;;;;;;;;;;;;;;;;;;;
InitIRQBuffer:
	;Clear IRQ index
	lda #$00
	sta IRQIndex
	;Set IRQ scanline timer to IRQ buffer scroll height
	lda IRQBufferHeight
	sta $C000
	sta $C001
	;Enable/disable IRQ based on IRQ enable flag
	ldy IRQEnableFlag
	sta $E000,y
	;Clear CPU IRQ disable flag
	cli
	rts

IRQ:
	;Save A/X/Y registers
	pha
	txa
	pha
	tya
	pha
	;Disable IRQ
	sta $E000
	;Save last bank switch value
	lda TempLastBankSwitch
	sta LastBankSwitch
	;Increment IRQ index
	inc IRQIndex
	;Check for end of IRQ buffer
	ldx IRQIndex
	cpx IRQCount
	beq IRQ_EndBuffer
	;Set IRQ scanline timer to IRQ buffer scroll height
	lda IRQBufferHeight,x
	sta $C000
	sta $E001
	;Write IRQ section
	ldy #$05
	jsr DelayIRQSection
	jsr WriteIRQSection
	;Restore last bank switch value
	lda LastBankSwitch
IRQ_End:
	sta $8000
	;Restore A/X/Y registers
	pla
	tay
	pla
	tax
	pla
	rti
IRQ_EndBuffer:
	;Load blank CHR banks
	lda #$7E
	ldy #$02
	sty TempLastBankSwitch
	sty $8000
	sta $8001
	iny
	sty TempLastBankSwitch
	sty $8000
	sta $8001
	iny
	sty TempLastBankSwitch
	sty $8000
	sta $8001
	iny
	sty TempLastBankSwitch
	sty $8000
	sta $8001
	ldy #$00
	sty TempLastBankSwitch
	sty $8000
	sta $8001
	iny
	sty TempLastBankSwitch
	sty $8000
	sta $8001
	;Write IRQ section
	ldy #$0E
	jsr DelayIRQSection
	jsr WriteIRQSection
	;Load text CHR bank for HUD/dialog text
	lda #$0A
	ldy #$00
	sty TempLastBankSwitch
	sty $8000
	sta $8001
	iny
	lda #$34
	sty TempLastBankSwitch
	sty $8000
	sta $8001
	;Clear IRQ index
	lda #$00
	sta IRQIndex
	;Set IRQ wait flag
	lda #$01
	sta IRQWaitFlag
	;Restore last bank switch value
	lda LastBankSwitch
	jmp IRQ_End

DelayIRQSection:
	;Delay IRQ section write
	dey
	bne DelayIRQSection
	rts

WriteIRQSection:
	;Latch PPU address line
	lda PPU_STATUS
	;Set PPU address
	lda IRQBufferAddrHi-1,x
	sta PPU_ADDR
	lda IRQBufferAddrLo-1,x
	sta PPU_ADDR
	;Latch PPU status line
	lda PPU_STATUS
	;Set PPU scroll
	lda IRQBufferScrollX-1,x
	sta PPU_SCROLL
	sta PPU_SCROLL
	rts

LoadIRQBufferSet:
	;Load PRG bank $38 (IRQ buffer set data bank)
	ldy #$38
	jsr LoadPRGBank
	;Get IRQ buffer set pointer
	lda IRQBufferSetPointerTable,x
	sta $08
	lda IRQBufferSetPointerTable+1,x
	sta $09
	;Get number of IRQ buffer entries used
	ldy #$00
	lda ($08),y
	iny
	sta TempIRQCount
	tax
	dex
LoadIRQBufferSet_Loop:
	;Load IRQ buffer entry
	lda ($08),y
	iny
	sta a:TempIRQBufferHeight,x
	lda ($08),y
	iny
	sta a:TempIRQBufferScrollX,x
	lda ($08),y
	iny
	sta a:TempIRQBufferScrollY,x
	lda ($08),y
	iny
	sta a:TempIRQBufferScrollHi,x
	;Loop for each entry
	dex
	bpl LoadIRQBufferSet_Loop
	;Set IRQ enable flag
	lda #$01
	sta TempIRQEnableFlag
	;Restore PRG bank
	jsr RestorePRGBank
	rts

DecodeIRQBuffer:
	;Check if IRQ is enabled
	lda TempIRQEnableFlag
	sta IRQEnableFlag
	beq DecodeIRQBuffer_NoIRQ
	;Set IRQ buffer mutex
	lda #$01
	sta IRQBufferMutex
	;Get number of IRQ buffer entries
	ldx TempIRQCount
	stx IRQCount
	dex
DecodeIRQBuffer_Loop:
	;Decode scroll height value
	lda TempIRQBufferHeight,x
	sta IRQBufferHeight,x
	;Decode scroll X value
	lda TempIRQBufferScrollX,x
	sta IRQBufferScrollX,x
	;Decode scroll address low value
	lda TempIRQBufferScrollY,x
	asl
	asl
	and #$E0
	sta IRQBufferAddrLo,x
	;Decode scroll address high value
	lda TempIRQBufferScrollY,x
	rol
	rol
	rol
	and #$03
	ora TempIRQBufferScrollHi,x
	and #$0F
	sta IRQBufferAddrHi,x
	;Loop for each entry
	dex
	bpl DecodeIRQBuffer_Loop
	;Clear IRQ buffer mutex
	lda #$00
	sta IRQBufferMutex
DecodeIRQBuffer_NoIRQ:
	;Load CHR banks
	ldy #$05
DecodeIRQBuffer_CHRLoop:
	;Load CHR bank
	lda TempCHRBanks,y
	sta CHRBanks,y
	;Loop for each bank
	dey
	bpl DecodeIRQBuffer_CHRLoop
	rts

LevelTilePointerTable:
	.dw Level1TileData
	.dw Level2TileData
	.dw Level3TileData
	.dw Level4TileData
	.dw Level5TileData
	.dw Level6TileData
	.dw Level7TileData
	.dw Level8TileData
LevelAttrPointerTable:
	.dw Level1AttrData
	.dw Level2AttrData
	.dw Level3AttrData
	.dw Level4AttrData
	.dw Level5AttrData
	.dw Level6AttrData
	.dw Level7AttrData
	.dw Level8AttrData
LevelBGPointerTable:
	.dw Level1BGPointerData
	.dw Level2BGPointerData
	.dw Level3BGPointerData
	.dw Level4BGPointerData
	.dw Level5BGPointerData
	.dw Level6BGPointerData
	.dw Level7BGPointerData
	.dw Level8BGPointerData
LevelTileCollRangeTable:
	.db $00,$00,$06,$06,$0C,$12,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.db $18,$18,$18,$1E,$1E,$1E,$66,$66,$66,$00,$00,$00,$00,$00,$00,$00
	.db $24,$24,$24,$24,$24,$25,$2A,$2A,$2A,$30,$00,$00,$00,$00,$00,$00
	.db $36,$36,$36,$36,$36,$3C,$48,$42,$00,$00,$00,$00,$00,$00,$00,$00
	.db $4E,$4E,$4E,$4E,$6C,$6C,$4E,$4E,$6C,$55,$55,$55,$55,$4F,$4F,$4F
	.db $5A,$5A,$5A,$5A,$5A,$78,$78,$78,$78,$72,$00,$00,$00,$00,$00,$00
	.db $85,$85,$85,$85,$7E,$7E,$8A,$61,$61,$61,$61,$8A,$8A,$8A,$96,$00
	.db $9C,$9C,$9C,$9C,$90,$90,$A2,$A2
TileCollRangeTable:
	.db $6D,$76,$80,$EE,$FF,$FF
	.db $60,$78,$80,$F0,$F0,$F0
	.db $67,$75,$80,$E3,$EF,$FF
	.db $67,$75,$80,$7F,$7F,$DB
	.db $50,$50,$6D,$B7,$B7,$B7
	.db $0B,$0B,$1B,$B2,$B2,$B3
	.db $40,$40,$70,$C9,$CD,$F9
	.db $34,$3C,$77,$C9,$CD,$F9
	.db $3B,$3B,$70,$B3,$B3,$B3
	.db $63,$6F,$FF,$E8,$EC,$FF
	.db $7F,$7F,$7F,$E0,$FF,$FF
	.db $17,$17,$2B,$CA,$CA,$FF
	.db $70,$70,$78,$E8,$EC,$FF
	.db $70,$75,$7B,$80,$80,$FF
	.db $70,$75,$7B,$E7,$E7,$F0
	.db $42,$42,$80,$92,$92,$FA
	.db $20,$20,$FF,$80,$80,$FF
	.db $29,$29,$3B,$FF,$FF,$FF
	.db $70,$75,$7B,$FF,$FF,$FF
	.db $01,$01,$51,$80,$80,$80
	.db $42,$42,$80,$93,$97,$F3
	.db $77,$77,$77,$B7,$B7,$F7
	.db $80,$80,$80,$80,$80,$F7
	.db $00,$00,$7F,$B7,$B7,$F7
	.db $20,$20,$7C,$A8,$A8,$A8
	.db $38,$38,$60,$7F,$7F,$7F
	.db $20,$20,$7C,$FF,$FF,$FF
	.db $20,$20,$7C,$C8,$C8,$C8

WriteVRAMBuffer:
	;If VRAM buffer empty, exit early
	lda VRAMBuffer
	beq WriteVRAMBuffer_Exit
	ldy #$00
WriteVRAMBuffer_SetAddr:
	;Set VRAM strip direction
	tax
	lda TempMirror_PPUCTRL
	and #$78
	ora WriteVRAMBufferPPU_CTRLTable-1,x
	sta PPU_CTRL
	iny
	;Latch PPU status line
	lda PPU_STATUS
	;Set PPU address
	lda VRAMBuffer+1,y
	sta PPU_ADDR
	lda VRAMBuffer,y
	sta PPU_ADDR
	iny
	iny
	;Check for end of buffer
	bne WriteVRAMBuffer_GetByte
WriteVRAMBuffer_Exit:
	;Clear VRAM buffer
	lda #$00
	sta VRAMBuffer
	sta VRAMBufferOffset
	;Clear scroll position
	lda TempMirror_PPUCTRL
	sta PPU_CTRL
	rts
WriteVRAMBuffer_ImmFF:
	;Set immediate $FF value in VRAM
	lda #$FF
WriteVRAMBuffer_SetData:
	;Set value in VRAM
	sta PPU_DATA
WriteVRAMBuffer_GetByte:
	;Get data byte
	lda VRAMBuffer,y
	iny
	;Check for $FF
	cmp #$FF
	bne WriteVRAMBuffer_SetData
	;Check for end of VRAM buffer
	lda VRAMBuffer,y
	beq WriteVRAMBuffer_Exit
	;Check for VRAM strip direction
	cmp #$03
	bcc WriteVRAMBuffer_SetAddr
	;Check for immediate $FF value command
	bcs WriteVRAMBuffer_ImmFF
WriteVRAMBufferPPU_CTRLTable:
	.db $00,$04

UpdateLevelScroll:
	;Clear scroll update flag
	lda #$00
	sta ScrollUpdateFlag
	;If scroll disable flag set, scroll vertically
	lda ScrollDisableFlag
	bne UpdateLevelScroll_DoV
	;If on escape pod, scroll horizontally
	lda OnEscapePodFlag
	bne UpdateLevelScroll_DoH
	;If at any side of level, exit early
	lda AreaScrollFlags
	and #$C0
	cmp #$80
	beq UpdateLevelScroll_Exit
	;Check to scroll horizontally or vertically
	lda AreaScrollFlags
	and #$01
	beq UpdateLevelScroll_DoH
UpdateLevelScroll_DoV:
	;Load level PRG bank
	ldy LevelBank
	jsr LoadPRGBank
	;Update scroll vertically
	jsr UpdateLevelScroll_Vert
	;Restore PRG bank
	jsr RestorePRGBank
	rts
UpdateLevelScroll_DoH:
	;Load level PRG bank
	ldy LevelBank
	jsr LoadPRGBank
	;Update scroll horizontally
	jsr UpdateLevelScroll_Horiz
	;Restore PRG bank
	jsr RestorePRGBank
UpdateLevelScroll_Exit:
	rts

UpdateLevelScroll_Horiz:
	;Save current screen
	lda CurScreen
	sta $11
	;Check if scrolling left or right
	lda ScrollXVelHi
	clc
	adc PlatformXVel
	sta $00
	bmi UpdateLevelScroll_Horiz_Left
	;Get screen offset for new column (right)
	ldx #$01
	lda TempMirror_PPUSCROLL_X
	sta $10
	bpl UpdateLevelScroll_Horiz_RightNoC
	ldx #$02
UpdateLevelScroll_Horiz_RightNoC:
	;Apply scroll X velocity
	clc
	adc $00
	sta TempMirror_PPUSCROLL_X
	bcc UpdateLevelScroll_Horiz_NoXC
	inc CurScreen
	bne UpdateLevelScroll_Horiz_XC
UpdateLevelScroll_Horiz_Left:
	;Get screen offset for new column (left)
	ldx #$00
	lda TempMirror_PPUSCROLL_X
	sta $10
	bmi UpdateLevelScroll_Horiz_LeftNoC
	ldx #$FF
UpdateLevelScroll_Horiz_LeftNoC:
	;Apply scroll X velocity
	clc
	adc $00
	sta TempMirror_PPUSCROLL_X
	bcs UpdateLevelScroll_Horiz_NoXC
	dec CurScreen
UpdateLevelScroll_Horiz_XC:
	;Swap nametable
	lda TempMirror_PPUCTRL
	eor #$01
	sta TempMirror_PPUCTRL
UpdateLevelScroll_Horiz_NoXC:
	;If scroll update disabled, exit early
	lda ScrollUpdateDisableFlag
	bne UpdateLevelScroll_Exit
	;If bit 4 of new scroll position == bit 4 of old scroll position, exit early
	lda TempMirror_PPUSCROLL_X
	eor $10
	and #$10
	beq UpdateLevelScroll_Exit
	;Offset screen for new column
	txa
	clc
	adc $11
	;If new screen $80-$FF, exit early
	asl
	bcs UpdateLevelScroll_Exit
	;Set scroll update flag
	inc ScrollUpdateFlag
	;Get screen BG data pointer
	tay
	lda (LevelBGPointer),y
	sta $0A
	iny
	lda (LevelBGPointer),y
	sta $0B
	;Init VRAM buffer column
	jsr WriteVRAMBufferCmd_InitCol
	;Set VRAM buffer address low
	lda $10
	eor #$80
	lsr
	lsr
	lsr
	and #$FE
	sta $12
	sta VRAMBuffer,x
	inx
	;Get collision table offset for each row of tiles
	and #$02
	sta $02
	ora #$04
	sta $03
	ora #$08
	sta $05
	and #$FB
	sta $04
	;Get collision buffer offset
	lda $12
	lsr
	lsr
	sta $0E
	;Get screen BG data offset
	sta $14
	;Get collision buffer pointer
	lda $11
	and #$01
	ldy $10
	bmi UpdateLevelScroll_Horiz_NoVRAMC
	eor #$01
UpdateLevelScroll_Horiz_NoVRAMC:
	asl
	asl
	tay
	lda CollBufferPtrLoTable,y
	sta CollBufferPointer
	;Set VRAM buffer address high
	tya
	clc
	adc #$20
	sta $13
	sta VRAMBuffer,x
UpdateLevelScroll_Horiz_Loop:
	;Draw column of metatile tiles
	lda #$06
	sta $0D
UpdateLevelScroll_Horiz_Loop2:
	;Get metatile data pointer
	ldy $14
	lda ($0A),y
	jsr GetMetatilePointer
	;Draw metatile
	lda #$00
	sta $0C
UpdateLevelScroll_Horiz_Loop3:
	;Get old collision buffer value
	ldy $0E
	lda (CollBufferPointer),y
	sta $01
	;Loop for each row of tiles in metatile
	ldy $0C
	cpy #$04
	beq UpdateLevelScroll_Horiz_Next
	;Get collision table offset for this row of tiles
	inc $0C
	lda $02,y
	tay
	;Set tile in VRAM
	inx
	lda ($08),y
	sta VRAMBuffer,x
	;Update collision buffer value
	jsr TileToCollisionType_Horiz
	;Set value in collision buffer
	ldy $0E
	sta (CollBufferPointer),y
	;Go to next row in collision buffer
	tya
	clc
	adc #$08
	sta $0E
	bne UpdateLevelScroll_Horiz_Loop3
UpdateLevelScroll_Horiz_Next:
	;Go to next row in screen BG data
	lda $14
	clc
	adc #$08
	sta $14
	;Loop for each metatile
	dec $0D
	bne UpdateLevelScroll_Horiz_Loop2
	;Loop for each column
	lda $02
	and #$01
	bne UpdateLevelScroll_Horiz_Attr
	;Init VRAM buffer column
	inx
	jsr WriteVRAMBufferCmd_NewCol
	;Set VRAM buffer address
	inc $12
	lda $12
	sta VRAMBuffer,x
	inx
	lda $13
	sta VRAMBuffer,x
	;Get collision table offset for each row of tiles
	lda $02
	ora #$01
	sta $02
	ora #$04
	sta $03
	ora #$08
	sta $05
	and #$FB
	sta $04
	;Get screen BG data offset
	lda $14
	and #$07
	sta $14
	;Get collision buffer offset
	sta $0E
	jmp UpdateLevelScroll_Horiz_Loop
UpdateLevelScroll_Horiz_Attr:
	;If bit 5 of new scroll position == bit 5 of old scroll position, don't update attributes
	inx
	lda TempMirror_PPUSCROLL_X
	eor $10
	and #$20
	bne UpdateLevelScroll_Horiz_NoAttr
	;Init VRAM buffer column
	jsr WriteVRAMBufferCmd_NewCol
	;Set VRAM buffer address low
	lda $10
	eor #$80
	lsr
	lsr
	lsr
	lsr
	lsr
	clc
	adc #$C0
	sta $12
	sta VRAMBuffer,x
	inx
	;Get screen BG data offset
	and #$07
	sta $14
	;Set VRAM buffer address high
	lda $13
	clc
	adc #$03
	sta $13
	sta VRAMBuffer,x
	inx
	;Draw column of metatile tiles
	lda #$05
	sta $0C
UpdateLevelScroll_Horiz_AttrLoop:
	;Set attribute in VRAM
	ldy $14
	lda ($0A),y
	tay
	lda (LevelAttrPointer),y
	sta VRAMBuffer,x
	inx
	;Get screen BG data offset
	lda $14
	clc
	adc #$08
	sta $14
	;Init VRAM buffer column
	jsr WriteVRAMBufferCmd_NewCol
	;Set VRAM buffer address
	lda $12
	clc
	adc #$08
	sta $12
	sta VRAMBuffer,x
	inx
	lda $13
	sta VRAMBuffer,x
	inx
	;Loop for each metatile
	dec $0C
	bne UpdateLevelScroll_Horiz_AttrLoop
	;Set attribute in VRAM
	ldy $14
	lda ($0A),y
	tay
	lda (LevelAttrPointer),y
	sta VRAMBuffer,x
	inx
UpdateLevelScroll_Horiz_NoAttr:
	;End VRAM buffer
	jmp WriteVRAMBufferCmd_End

TileToCollisionType_Horiz:
	;Check for tile $80-$FF
	bmi TileToCollisionType_Horiz_Tile1
	;Check for tile range 0 (nonsolid collision type)
	cmp TileCollRange00
	bcc TileToCollisionType_Horiz_Set0
	;Check for tile range 1 (semisolid collision type)
	cmp TileCollRange00+1
	bcc TileToCollisionType_Horiz_Set1
	;Check for tile range 2 (solid collision type)
	cmp TileCollRange00+2
	bcc TileToCollisionType_Horiz_Set2
	;Set death collision type
	lda $01
	and CollMaskTable,y
	ora CollSet3Table,y
	rts
TileToCollisionType_Horiz_Tile1:
	;Check for tile range 0 (nonsolid collision type)
	cmp TileCollRange01
	bcc TileToCollisionType_Horiz_Set0
	;Check for tile range 1 (semisolid collision type)
	cmp TileCollRange01+1
	bcc TileToCollisionType_Horiz_Set1
	;Check for tile range 2 (solid collision type)
	cmp TileCollRange01+2
	bcc TileToCollisionType_Horiz_Set2
	;Set death collision type
	lda $01
	and CollMaskTable,y
	ora CollSet3Table,y
	rts
TileToCollisionType_Horiz_Set2:
	;Set solid collision type
	lda $01
	and CollMaskTable,y
	ora CollSet2Table,y
	rts
TileToCollisionType_Horiz_Set1:
	;Set semisolid collision type
	lda $01
	and CollMaskTable,y
	ora CollSet1Table,y
	rts
TileToCollisionType_Horiz_Set0:
	;Set nonsolid collision type
	lda $01
	and CollMaskTable,y
	rts

WriteVRAMBufferCmd_NewCol:
	;Write VRAM command to end current strip
	lda #$FF
	sta VRAMBuffer,x
	inx
	;Write VRAM command to draw tile column
	lda #$02
	sta VRAMBuffer,x
	inx
WriteVRAMBufferCmd_NewCol_Exit:
	rts

UpdateLevelScroll_Vert:
	;Save current screen
	lda CurScreen
	sta $11
	;Apply scroll Y velocity
	lda TempMirror_PPUSCROLL_Y
	sta $10
	clc
	adc ScrollYVelHi
	sta TempMirror_PPUSCROLL_Y
	cmp #$F0
	bcc UpdateLevelScroll_Vert_NoC
	;Check if scrolling up or down
	ldy ScrollYVelHi
	bmi UpdateLevelScroll_Vert_Up
	;Apply scroll Y velocity
	clc
	adc #$10
	sta TempMirror_PPUSCROLL_Y
	inc CurScreen
	bne UpdateLevelScroll_Vert_NoC
UpdateLevelScroll_Vert_Up:
	;Apply scroll Y velocity
	sec
	sbc #$10
	sta TempMirror_PPUSCROLL_Y
	dec CurScreen
UpdateLevelScroll_Vert_NoC:
	;If scroll update disabled, exit early
	lda ScrollUpdateDisableFlag
	bne WriteVRAMBufferCmd_NewCol_Exit
	;If bit 4 of new scroll position == bit 4 of old scroll position, exit early
	lda TempMirror_PPUSCROLL_Y
	and #$F0
	sta $01
	lda $10
	and #$F0
	cmp $01
	beq WriteVRAMBufferCmd_NewCol_Exit
	;Offset screen for new row
	lda $10
	sec
	sbc #$10
	bcc UpdateLevelScroll_Vert_Top
	sta $07
	lda #$00
	ldy ScrollYVelHi
	bmi UpdateLevelScroll_Vert_SetScreen
	lda #$01
	bne UpdateLevelScroll_Vert_SetScreen
UpdateLevelScroll_Vert_Top:
	adc #$F0
	sta $07
	lda #$FF
	ldy ScrollYVelHi
	bmi UpdateLevelScroll_Vert_SetScreen
	lda #$00
UpdateLevelScroll_Vert_SetScreen:
	clc
	adc $11
	;If new screen $80-$FF, exit early
	asl
	bcs WriteVRAMBufferCmd_NewCol_Exit
	;Set scroll update flag
	inc ScrollUpdateFlag
	;Get screen BG data pointer
	tay
	lda (LevelBGPointer),y
	sta $0A
	iny
	lda (LevelBGPointer),y
	sta $0B
	;Init VRAM buffer row
	jsr WriteVRAMBufferCmd_InitRow
	;Set VRAM buffer address low
	lda $07
	and #$30
	asl
	asl
	sta VRAMBuffer,x
	inx
	;Get collision table offset for each column of tiles
	and #$40
	lsr
	lsr
	lsr
	sta $02
	;Get collision buffer offset
	lda $07
	and #$F0
	sta $0E
	;Get screen BG data offset
	and #$E0
	lsr
	lsr
	sta $14
	;Set VRAM buffer address low
	lsr
	lsr
	lsr
	lsr
	clc
	adc #$24
	sta VRAMBuffer,x
	;Get collision buffer pointer
	lda #$F0
	sta CollBufferPointer
	;Draw rows of metatile tiles
	lda #$02
	sta $0C
UpdateLevelScroll_Vert_Loop:
	;Draw row of metatile tiles
	lda #$08
	sta $0D
UpdateLevelScroll_Vert_Loop2:
	;Get metatile data pointer
	ldy $14
	lda ($0A),y
	jsr GetMetatilePointer
	;Clear old collision buffer value
	lda #$00
	sta $01
	;Set tile in VRAM
	ldy $02
	inx
	lda ($08),y
	sta VRAMBuffer,x
	;Update collision buffer value
	jsr TileToCollisionType_Vert
	;Set tile in VRAM
	iny
	inx
	lda ($08),y
	sta VRAMBuffer,x
	;Update collision buffer value
	jsr TileToCollisionType_Vert
	;Set tile in VRAM
	iny
	inx
	lda ($08),y
	sta VRAMBuffer,x
	;Update collision buffer value
	jsr TileToCollisionType_Vert
	;Set tile in VRAM
	iny
	inx
	lda ($08),y
	sta VRAMBuffer,x
	;Update collision buffer value
	jsr TileToCollisionType_Vert
	;Set value in collision buffer
	ldy $0E
	lda $01
	sta (CollBufferPointer),y
	;Go to next column in screen BG data
	inc $14
	;Go to next column in collision buffer
	inc $0E
	;Loop for each metatile
	dec $0D
	bne UpdateLevelScroll_Vert_Loop2
	;Get collision table offset for each column of tiles
	lda $02
	ora #$04
	sta $02
	;Go to next row in screen BG data
	lda $14
	sec
	sbc #$08
	sta $14
	;Loop for each row
	dec $0C
	bne UpdateLevelScroll_Vert_Loop
	;If bit 5 of new scroll position set or new scroll position $E0, update attributes
	inx
	lda $07
	and #$F0
	cmp #$E0
	beq UpdateLevelScroll_Vert_Attr
	and #$10
	beq UpdateLevelScroll_Vert_NoAttr
UpdateLevelScroll_Vert_Attr:
	;Init VRAM buffer row
	jsr WriteVRAMBufferCmd_NewRow
	;Set VRAM buffer address
	lda $14
	clc
	adc #$C0
	sta VRAMBuffer,x
	inx
	lda #$27
	sta VRAMBuffer,x
	inx
	;Draw rows of metatile tiles
	lda #$08
	sta $0C
UpdateLevelScroll_Vert_AttrLoop:
	;Set attribute in VRAM
	ldy $14
	lda ($0A),y
	tay
	lda (LevelAttrPointer),y
	sta VRAMBuffer,x
	inx
	;Get screen BG data offset
	inc $14
	;Loop for each metatile
	dec $0C
	bne UpdateLevelScroll_Vert_AttrLoop
UpdateLevelScroll_Vert_NoAttr:
	;End VRAM buffer
	jmp WriteVRAMBufferCmd_End

TileToCollisionType_Vert:
	;Check for tile $80-$FF
	bmi TileToCollisionType_Vert_Tile1
	;Check for tile range 0 (nonsolid collision type)
	cmp TileCollRange00
	bcc TileToCollisionType_Vert_Set0
	;Check for tile range 1 (semisolid collision type)
	cmp TileCollRange00+1
	bcc TileToCollisionType_Vert_Set1
	;Check for tile range 2 (solid collision type)
	cmp TileCollRange00+2
	bcc TileToCollisionType_Vert_Set2
	;Set death collision type
	lda $01
	ora CollSet3Table,y
	sta $01
	rts
TileToCollisionType_Vert_Tile1:
	;Check for tile range 0 (nonsolid collision type)
	cmp TileCollRange01
	bcc TileToCollisionType_Vert_Set0
	;Check for tile range 1 (semisolid collision type)
	cmp TileCollRange01+1
	bcc TileToCollisionType_Vert_Set1
	;Check for tile range 2 (solid collision type)
	cmp TileCollRange01+2
	bcc TileToCollisionType_Vert_Set2
	;Set death collision type
	lda $01
	ora CollSet3Table,y
	sta $01
	rts
TileToCollisionType_Vert_Set2:
	;Set solid collision type
	lda $01
	ora CollSet2Table,y
	sta $01
	rts
TileToCollisionType_Vert_Set1:
	;Set semisolid collision type
	lda $01
	ora CollSet1Table,y
	sta $01
TileToCollisionType_Vert_Set0:
	;Set nonsolid collision type
	rts

WriteVRAMBufferCmd_NewRow:
	;Write VRAM command to end current strip
	lda #$FF
	sta VRAMBuffer,x
	inx
	;Write VRAM command to draw tile row
	lda #$01
	sta VRAMBuffer,x
	inx
	rts

CollBufferPtrLoTable:
	.db $00,$00,$00,$00
	.db $F0,$F0,$F0,$F0
BGEnemyBitTable:
	.db $01,$02,$04,$08,$10,$20,$40,$80
CollDrawSetTable:
	.db $00,$40,$80,$C0
	.db $00,$10,$20,$30
	.db $00,$04,$08,$0C
	.db $00,$01,$02,$03
CollSet1Table:
	.db $40,$10,$04,$01
	.db $40,$10,$04,$01
	.db $40,$10,$04,$01
	.db $40,$10,$04,$01
CollSet2Table:
	.db $80,$20,$08,$02
	.db $80,$20,$08,$02
	.db $80,$20,$08,$02
	.db $80,$20,$08,$02
CollSet3Table:
	.db $C0,$30,$0C,$03
	.db $C0,$30,$0C,$03
	.db $C0,$30,$0C,$03
	.db $C0,$30,$0C,$03
CollDrawMaskTable:
	.db $3F,$3F,$3F,$3F
	.db $CF,$CF,$CF,$CF
	.db $F3,$F3,$F3,$F3
	.db $FC,$FC,$FC,$FC
CollMaskTable:
	.db $3F,$CF,$F3,$FC
	.db $3F,$CF,$F3,$FC
	.db $3F,$CF,$F3,$FC
	.db $3F,$CF,$F3,$FC

;;;;;;;;;;;;;;;;;;;;;;
;LEVEL ENEMY ROUTINES;
;;;;;;;;;;;;;;;;;;;;;;
CheckLevelEnemies:
	;Load PRG bank $38 (enemy data bank)
	ldy #$38
	jsr LoadPRGBank
	;Check level enemies
	jsr CheckLevelEnemiesSub
	;Restore PRG bank
	jsr RestorePRGBank
CheckLevelEnemies_Exit:
	rts

CheckLevelEnemiesSub:
	;Get enemy data pointer
	lda CurLevel
	asl
	tay
	lda LevelEnemyDataPointerTable,y
	sta $0C
	lda LevelEnemyDataPointerTable+1,y
	sta $0D
	;Check if scrolling is disabled
	lda ScrollDisableFlag
	beq CheckLevelEnemiesSub_Scroll
	;Check to scroll horizontally or vertically
	lda AreaScrollFlags
	and #$01
	bne CheckLevelEnemiesSub_Vert
	beq CheckLevelEnemiesSub_Horiz
CheckLevelEnemiesSub_Scroll:
	;If at any side of level, exit early
	lda AreaScrollFlags
	bmi CheckLevelEnemies_Exit
	;Check to scroll horizontally or vertically
	beq CheckLevelEnemiesSub_Horiz
CheckLevelEnemiesSub_Vert:
	;If scroll Y velocity 0, exit early
	lda ScrollYVelHi
	beq CheckLevelEnemies_Exit
	;Check if scrolling up or down
	bpl CheckLevelEnemiesSub_Down
	;Set min Y position for spawning level enemies
	lda TempMirror_PPUSCROLL_Y
	sta $10
	;Set max Y position for spawning level enemies
	clc
	adc #$08
	cmp #$F0
	bcc CheckLevelEnemiesSub_UpNoYC
	clc
	adc #$10
CheckLevelEnemiesSub_UpNoYC:
	sta $11
	;Check if min Y position >= max Y position
	jmp CheckLevelEnemiesSub_SingleCheck
CheckLevelEnemiesSub_Exit:
	rts
CheckLevelEnemiesSub_Down:
	;Set min Y position for spawning level enemies
	ldy #$00
	lda TempMirror_PPUSCROLL_Y
	clc
	adc #$C8
	bcs CheckLevelEnemiesSub_DownYC
	cmp #$F0
	bcc CheckLevelEnemiesSub_DownNoYC
	clc
	adc #$10
CheckLevelEnemiesSub_DownYC:
	iny
CheckLevelEnemiesSub_DownNoYC:
	sta $10
	;Set max Y position for spawning level enemies
	clc
	adc #$08
	cmp #$F0
	bcc CheckLevelEnemiesSub_DownNoYC2
	clc
	adc #$10
CheckLevelEnemiesSub_DownNoYC2:
	sta $11
	;Check if min Y position >= max Y position
	lda $10
	cmp $11
	bcc CheckLevelEnemiesSub_VertSingle
	;Split range and check two screens instead
	lda $11
	sta $12
	lda #$EF
	sta $11
	lda #$00
	jsr CheckLevelScreenEnemies
	lda $12
	sta $11
	lda #$00
	sta $10
	lda #$01
	jmp CheckLevelScreenEnemies
CheckLevelEnemiesSub_VertSingle:
	;Only check one screen
	tya
	jmp CheckLevelScreenEnemies
CheckLevelEnemiesSub_Horiz:
	;If scroll X velocity 0, exit early
	lda ScrollXVelHi
	clc
	adc PlatformXVel
	beq CheckLevelEnemiesSub_Exit
	;Check if scrolling left or right
	bpl CheckLevelEnemiesSub_Right
	;Set min X position for spawning level enemies
	lda TempMirror_PPUSCROLL_X
	sta $10
	;Set max X position for spawning level enemies
	clc
	adc #$0A
	sta $11
	;Check if min X position >= max X position
	jmp CheckLevelEnemiesSub_SingleCheck
CheckLevelEnemiesSub_Right:
	;Set max X position for spawning level enemies
	lda TempMirror_PPUSCROLL_X
	sta $11
	;Set min X position for spawning level enemies
	sec
	sbc #$0A
	sta $10
	;Check if min X position >= max X position
	lda $10
	cmp $11
	bcc CheckLevelEnemiesSub_HorizSingle1
	;Split range and check two screens instead
	lda $11
	sta $12
	lda #$FF
	sta $11
	lda #$00
	jsr CheckLevelScreenEnemies
	lda $12
	sta $11
	lda #$00
	sta $10
	lda #$01
	jmp CheckLevelScreenEnemies
CheckLevelEnemiesSub_HorizSingle1:
	;Only check one screen
	lda #$01
	jmp CheckLevelScreenEnemies
CheckLevelEnemiesSub_SingleCheck:
	;Check if min X position >= max X position
	lda $10
	cmp $11
	bcc CheckLevelEnemiesSub_HorizSingle0
	;Split range and check two screens instead
	lda $11
	sta $12
	lda #$FF
	sta $11
	lda #$FF
	jsr CheckLevelScreenEnemies
	lda $12
	sta $11
	lda #$00
	sta $10
	lda #$00
	jmp CheckLevelScreenEnemies
CheckLevelEnemiesSub_HorizSingle0:
	;Only check one screen
	lda #$00

CheckLevelScreenEnemies:
	;Offset screen for enemy spawn check
	clc
	adc CurScreen
	;If new screen $80-$FF, exit early
	bmi CheckLevelScreenEnemies_Exit
	;Get screen enemy data pointer
	asl
	tay
	lda ($0C),y
	sta $0E
	iny
	lda ($0C),y
	sta $0F
	;Check to spawn level screen enemies
	ldy #$00
CheckLevelScreenEnemies_Loop:
	;Check for end of level screen enemy data
	lda ($0E),y
	beq CheckLevelScreenEnemies_Exit
	;If level enemy position in range, spawn level enemy
	cmp $10
	bcc CheckLevelScreenEnemies_Next
	cmp $11
	bcs CheckLevelScreenEnemies_Next
	;Save Y register
	sty $13
	;Spawn level enemy
	jsr SpawnLevelEnemy
	;Restore Y register
	ldy $13
CheckLevelScreenEnemies_Next:
	;Loop for each enemy
	iny
	iny
	iny
	iny
	bne CheckLevelScreenEnemies_Loop
CheckLevelScreenEnemies_Exit:
	rts

SpawnLevelEnemy:
	;Get level enemy slot index
	iny
	lda ($0E),y
	and #$0F
	tax
	;If no free slot available, exit early
	lda Enemy_Flags,x
	bne CheckLevelScreenEnemies_Exit
	;Get level enemy parameter value
	lda ($0E),y
	lsr
	lsr
	lsr
	lsr
	sta Enemy_Temp1,x
	dey
	;Check to scroll horizontally or vertically
	lda AreaScrollFlags
	beq SpawnLevelEnemy_Horiz
	;Get level enemy Y position
	lda ($0E),y
	sec
	sbc TempMirror_PPUSCROLL_Y
	sta Enemy_Y,x
	;If enemy Y position offscreen, adjust enemy Y position based on scrolling direction
	bcc SpawnLevelEnemy_ScrollCheck
	cmp #$F0
	bcc SpawnLevelEnemy_SetX
SpawnLevelEnemy_ScrollCheck:
	;Check if scrolling up or down
	lda ScrollYVelHi
	bpl SpawnLevelEnemy_Down
	;Increment enemy Y position
	lda Enemy_Y,x
	clc
	adc #$10
	jmp SpawnLevelEnemy_SetY
SpawnLevelEnemy_Down:
	;Decrement enemy Y position
	lda Enemy_Y,x
	sec
	sbc #$10
SpawnLevelEnemy_SetY:
	sta Enemy_Y,x
SpawnLevelEnemy_SetX:
	;Get level enemy X position
	iny
	iny
	lda ($0E),y
	sta Enemy_X,x
	iny
	bne SpawnLevelEnemy_Init
SpawnLevelEnemy_Horiz:
	;Get level enemy X position
	lda ($0E),y
	sec
	sbc TempMirror_PPUSCROLL_X
	sta Enemy_X,x
	;Decrement enemy Y position
	iny
	iny
	lda ($0E),y
	iny
	sta Enemy_Y,x
SpawnLevelEnemy_Init:
	;Get level enemy ID
	lda ($0E),y
	sta Enemy_ID,x
	;Init level enemy HP
	tay
	lda EnemyInitialHP,y
	sta Enemy_HP,x
	;Init level enemy animation
	lda EnemyInitialAnimation,y
	tay
	jsr SetEnemyAnimation

ClearEnemy:
	;Clear enemy state
	lda #$00
	sta Enemy_Props,x
	sta Enemy_Temp0,x
	sta Enemy_Temp2,x
	sta Enemy_Temp3,x
	sta Enemy_Temp4,x
	sta Enemy_Temp6,x
	sta Enemy_Temp5,x
	sta Enemy_Temp7,x
ClearEnemy_ClearXY:
	;Clear enemy X/Y position/velocity/acceleration
	lda #$00
	sta Enemy_XLo,x
	sta Enemy_XVelHi,x
	sta Enemy_XVelLo,x
	sta Enemy_XAccel,x
	sta Enemy_YLo,x
	sta Enemy_YVelHi,x
	sta Enemy_YVelLo,x
	sta Enemy_YAccel,x
	rts

CheckLevelEnemiesInit:
	;Load PRG bank $38 (enemy data bank)
	ldy #$38
	jsr LoadPRGBank
	;Check level enemies for initial load
	jsr CheckLevelEnemiesInitSub
	;Restore PRG bank
	jsr RestorePRGBank
	rts

CheckLevelEnemiesInitSub:
	;Save area scroll flags
	lda AreaScrollFlags
	sta $17
	;Check to scroll horizontally or vertically
	and #$01
	sta AreaScrollFlags
	beq CheckLevelEnemiesInitSub_Horiz
	;Set scroll Y velocity
	lda #$F8
	sta ScrollYVelHi
CheckLevelEnemiesInitSub_VertLoop:
	;Apply scroll Y velocity
	lda TempMirror_PPUSCROLL_Y
	clc
	adc ScrollYVelHi
	sta TempMirror_PPUSCROLL_Y
	;Check to apply scroll Y velocity to spawned enemies
	ldx #$10
CheckLevelEnemiesInitSub_VertLoop2:
	;If enemy has spawned in this slot index, apply scroll Y velocity
	lda Enemy_Flags,x
	bpl CheckLevelEnemiesInitSub_VertNext
	;Apply scroll Y velocity to spawned enemy
	lda Enemy_Y,x
	sec
	sbc ScrollYVelHi
	sta Enemy_Y,x
CheckLevelEnemiesInitSub_VertNext:
	;Loop for each enemy
	dex
	bne CheckLevelEnemiesInitSub_VertLoop2
	;Check level enemies
	jsr CheckLevelEnemiesSub
	;Loop for each row
	lda TempMirror_PPUSCROLL_Y
	bne CheckLevelEnemiesInitSub_VertLoop
	;Clear scroll Y velocity
	lda #$00
	sta ScrollYVelHi
	;Restore area scroll flags
	lda $17
	sta AreaScrollFlags
	rts
CheckLevelEnemiesInitSub_Horiz:
	;Set scroll X velocity
	lda #$00
	sta PlatformXVel
	lda #$F8
	sta ScrollXVelHi
CheckLevelEnemiesInitSub_HorizLoop:
	;Apply scroll X velocity
	lda TempMirror_PPUSCROLL_X
	clc
	adc ScrollXVelHi
	sta TempMirror_PPUSCROLL_X
	;Check to apply scroll X velocity to spawned enemies
	ldx #$10
CheckLevelEnemiesInitSub_HorizLoop2:
	;If enemy has spawned in this slot index, apply scroll X velocity
	lda Enemy_Flags,x
	bpl CheckLevelEnemiesInitSub_HorizNext
	;Apply scroll X velocity to spawned enemy
	lda Enemy_X,x
	sec
	sbc ScrollXVelHi
	sta Enemy_X,x
CheckLevelEnemiesInitSub_HorizNext:
	;Loop for each enemy
	dex
	bne CheckLevelEnemiesInitSub_HorizLoop2
	;Check level enemies
	jsr CheckLevelEnemiesSub
	;Loop for each column
	lda TempMirror_PPUSCROLL_X
	bne CheckLevelEnemiesInitSub_HorizLoop
	;Clear scroll Y velocity
	lda #$00
	sta ScrollXVelHi
	;Restore area scroll flags
	lda $17
	sta AreaScrollFlags
	rts

RunEnemy_DoLF:
	;Check if lifetime or flash timer
	bpl RunEnemy_Flash
	;Decrement lifetime timer, check if 0
	dec Enemy_Temp5,x
	lda Enemy_Temp5,x
	cmp #$80
	bne RunEnemy_Exit
	;Clear enemy flags
	lda #$00
	sta Enemy_Flags,x
RunEnemy_Exit:
	rts
RunEnemy_Flash:
	;Decrement flash timer
	dec Enemy_Temp5,x
	;If bit 1 of flash timer 0, set enemy visible flag
	lda Enemy_Temp5,x
	and #$02
	beq RunEnemy_Show
	;Clear enemy visible flag
	lda Enemy_Flags,x
	and #~EF_VISIBLE
	sta Enemy_Flags,x
	bne RunEnemy_DoJump
RunEnemy_Show:
	;Set enemy visible flag
	lda Enemy_Flags,x
	ora #EF_VISIBLE
	sta Enemy_Flags,x
	bne RunEnemy_DoJump
RunEnemy:
	;Check for lifetime/flash timer
	lda Enemy_Temp5,x
	bne RunEnemy_DoLF
RunEnemy_DoJump:
	;Do jump table
	lda Enemy_ID,x
	jsr DoJumpTable
EnemyJumpTable:
	.dw Enemy00	;$00  Player fire
	.dw Enemy01	;$01  Mecha frog middle
	.dw Enemy02	;$02  Mecha frog bottom
	.dw Enemy00	;$03  Blinky fire
	.dw Enemy04	;$04  Rotating room arrow
	.dw Enemy05	;$05  Trooper
	.dw Enemy06	;$06  Enemy fire
	.dw Enemy07	;$07  Trooper 2
	.dw Enemy08	;$08  Jenny light ball
	.dw Enemy09	;$09  BG 8-way shooter
	.dw Enemy0A	;$0A  Caterpillar
	.dw Enemy0B	;$0B  Spider
	.dw Enemy0C	;$0C  Beehive
	.dw Enemy0D	;$0D  Bee
	.dw Enemy0E	;$0E  Ship fin
	.dw Enemy0F	;$0F  Level 7 boss front shooters part 2
	.dw Enemy10	;$10  Item lifeup
	.dw Enemy10	;$11  Item powerup
	.dw Enemy10	;$12  Item 1-UP
	.dw Enemy10	;$13  Item bonus coin
	.dw Enemy14	;$14  Lightning
	.dw Enemy15	;$15  Swinging vine
	.dw Enemy16	;$16  Level 1 boss
	.dw Enemy17	;$17  Floating log platform
	.dw Enemy18	;$18  Boulder rolling
	.dw Enemy19	;$19  Floating log spawner
	.dw Enemy1A	;$1A  Floating log dummy?
	.dw Enemy1B	;$1B  Swinging vine platform
	.dw Enemy1C	;$1C  Fish
	.dw Enemy1D	;$1D  Balance vine platform
	.dw Enemy1E	;$1E  Balance vine mask
	.dw Enemy1F	;$1F  Falling tree platform left
	.dw Enemy1F	;$20  Falling tree platform right
	.dw Enemy21	;$21  Side flower
	.dw Enemy22	;$22  Falling rock
	.dw Enemy23	;$23  Falling rock/ship mouth spawner
	.dw Enemy24	;$24  Ship down laser
	.dw Enemy25	;$25  Ship mouth
	.dw Enemy26	;$26  Level 1 boss boulder
	.dw Enemy27	;$27  Trooper in ice
	.dw Enemy28	;$28  Lava bubble splash
	.dw Enemy29	;$29  Lava bubble
	.dw Enemy2A	;$2A  Volcano
	.dw Enemy2B	;$2B  BG fire arch
	.dw Enemy2C	;$2C  BG fire snake
	.dw Enemy2D	;$2D  Boulder rolling spawner
	.dw Enemy2E	;$2E  Trooper rolling
	.dw Enemy2F	;$2F  Boulder pushable
	.dw Enemy30	;$30  Green ball dot
	.dw Enemy31	;$31  Level 2 boss
	.dw Enemy32	;$32  Level 2 boss dot
	.dw Enemy33	;$33  BG snake
	.dw Enemy34	;$34  BG iceberg/conveyor platform
	.dw Enemy35	;$35  Trooper melting ice
	.dw Enemy36	;$36  Trooper with jetpack
	.dw Enemy37	;$37  Trooper dropping ice spikes
	.dw Enemy38	;$38  Trooper dropping ice blocks
	.dw Enemy39	;$39  Ice spike
	.dw Enemy3A	;$3A  Ice block
	.dw Enemy3B	;$3B  Rolling spike
	.dw Enemy3C	;$3C  Ice water decoration
	.dw Enemy3D	;$3D  Sprite mask
	.dw Enemy3E	;$3E  Level 3 boss
	.dw Enemy3F	;$3F  Level 3 boss missile
	.dw Enemy40	;$40  Frozen item/trooper in ice
	.dw Enemy41	;$41  Level 2 boss eyes/BG gray pipe
	.dw Enemy42	;$42  Icicle
	.dw Enemy43	;$43  Trooper throwing icicles
	.dw Enemy44	;$44  BG 3-way shooter
	.dw Enemy45	;$45  Crater gun
	.dw Enemy46	;$46  Flashing arrow
	.dw Enemy47	;$47  Dive bomber
	.dw Enemy48	;$48  Crater snake
	.dw Enemy49	;$49  Blue side spikes
	.dw Enemy4A	;$4A  Minecart
	.dw Enemy4B	;$4B  Crater snake part
	.dw Enemy4C	;$4C  Spike particles
	.dw Enemy4D	;$4D  Reset meltable ice
	.dw Enemy4E	;$4E  Level 4 boss part 2
	.dw Enemy4F	;$4F  Boss missile homing
	.dw Enemy50	;$50  Level 4 boss fire
	.dw Enemy51	;$51  Level 4 boss part 1
	.dw Enemy52	;$52  Asteroid
	.dw Enemy53	;$53  Asteroid platform
	.dw Enemy54	;$54  Vertical area ship fire
	.dw Enemy55	;$55  Behind BG area/BG glass pipe
	.dw Enemy56	;$56  Conveyor
	.dw Enemy57	;$57  Trooper in trench
	.dw Enemy58	;$58  Hypno Jenny
	.dw Enemy59	;$59  Hypno Willy
	.dw Enemy5A	;$5A  Hypno Dead-Eye
	.dw Enemy5B	;$5B  Hypno frog
	.dw Enemy5C	;$5C  Hypno frog beam
	.dw Enemy5D	;$5D  Hypno Jenny light ball
	.dw Enemy5E	;$5E  BG chute crusher
	.dw Enemy5F	;$5F  Arrow platform/Yoku block
	.dw Enemy60	;$60  Yoku block spawner
	.dw Enemy61	;$61  Dark room
	.dw Enemy62	;$62  Beetle in wall
	.dw Enemy63	;$63  Ceiling slug
	.dw Enemy64	;$64  Beetle moving up/down
	.dw Enemy14	;$65  Ceiling laser
	.dw Enemy66	;$66  Caged pig
	.dw Enemy67	;$67  Spike bug
	.dw Enemy68	;$68  Lava worm
	.dw Enemy69	;$69  BG fake block
	.dw Enemy6A	;$6A  Level 6 boss
	.dw Enemy6B	;$6B  Asteroid falling
	.dw Enemy6C	;$6C  BG appearing spikes
	.dw Enemy6D	;$6D  Lava platform
	.dw Enemy6E	;$6E  Tanker side spikes
	.dw Enemy6F	;$6F  Gravity up/down area
	.dw Enemy70	;$70  BG robot from behind glass
	.dw Enemy71	;$71  Background monitor
	.dw Enemy72	;$72  Conveyor platform
	.dw Enemy73	;$73  Escape pod
	.dw Enemy74	;$74  Trooper escaping
	.dw Enemy75	;$75  Trooper grabbing
	.dw Enemy76	;$76  BG glass pipe
	.dw Enemy77	;$77  Escape miniboss ship
	.dw Enemy78	;$78  Enemy fire 2
	.dw Enemy79	;$79  Level 7 boss back
	.dw Enemy7A	;$7A  Level 7 boss top shooter
	.dw Enemy7B	;$7B  Level 7 boss front shooters part 1
	.dw Enemy7C	;$7C  Trooper jetpack spawner
	.dw Enemy7D	;$7D  Escape flame
	.dw Enemy7E	;$7E  Escape shooter
	.dw Enemy7F	;$7F  UNUSED
	.dw Enemy80	;$80  Mecha frog
	.dw Enemy81	;$81  Escape miniboss snake
	.dw Enemy82	;$82  Level 8 boss
	.dw Enemy83	;$83  Level 8 boss bomb
	.dw Enemy84	;$84  Crocodile
	.dw Enemy85	;$85  Rotating room shooter
	.dw Enemy86	;$86  Crocodile spawner

;$7F: UNUSED
Enemy7F:

EnemyMovementFlags:
	.db $01,$01,$01,$03,$01,$13,$01,$13,$01,$09,$01,$01,$01,$01,$00,$01
	.db $01,$01,$01,$01,$01,$05,$01,$01,$03,$01,$01,$05,$01,$01,$01,$01
	.db $01,$01,$01,$00,$01,$08,$01,$13,$01,$01,$01,$05,$01,$01,$03,$07
	.db $00,$00,$01,$05,$05,$01,$01,$01,$01,$01,$01,$03,$00,$00,$05,$01
	.db $01,$05,$01,$01,$01,$01,$01,$01,$05,$01,$01,$05,$01,$01,$00,$01
	.db $01,$00,$05,$05,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
	.db $01,$05,$01,$01,$01,$01,$01,$01,$01,$01,$05,$01,$01,$05,$01,$01
	.db $03,$01,$05,$01,$13,$05,$01,$04,$01,$01,$01,$01,$01,$01,$01,$01
	.db $01,$01,$01,$01,$01,$01,$01

UpdateEnemyBGMovement:
	;If scrolling is disabled, don't clear scroll velocity
	lda ScrollDisableFlag
	bne UpdateEnemyBGMovement_NoSetY
	;If on escape pod, don't clear scroll velocity
	lda OnEscapePodFlag
	bne UpdateEnemyBGMovement_NoSetY
	;If scrolling horizontally, don't clear scroll X velocity
	ldy #$00
	lda AreaScrollFlags
	beq UpdateEnemyBGMovement_NoSetX
	;If on left or right side of level, don't clear scroll X velocity
	cmp #$C0
	beq UpdateEnemyBGMovement_NoSetX
	cmp #$C2
	beq UpdateEnemyBGMovement_NoSetX
	;Clear scroll X velocity
	sty ScrollXVelHi
UpdateEnemyBGMovement_NoSetX:
	;If scrolling vertically, don't clear scroll Y velocity
	cmp #$01
	beq UpdateEnemyBGMovement_NoSetY
	;If on top or bottom side of level, don't clear scroll Y velocity
	cmp #$C1
	beq UpdateEnemyBGMovement_NoSetY
	cmp #$C3
	beq UpdateEnemyBGMovement_NoSetY
	;Clear scroll Y velocity
	sty ScrollYVelHi
UpdateEnemyBGMovement_NoSetY:
	;Load PRG bank $32 (enemy subroutines bank)
	ldy #$32
	jsr LoadPRGBank
	;Run enemy subroutines
	ldx #$0F
UpdateEnemyBGMovement_RunLoop:
	;If enemy is active, run enemy subroutine
	lda Enemy_Flags,x
	bpl UpdateEnemyBGMovement_RunNext
	;Run enemy subroutine
	jsr RunEnemy
UpdateEnemyBGMovement_RunNext:
	;Loop for each enemy
	dex
	bne UpdateEnemyBGMovement_RunLoop
	;Restore PRG bank
	jsr RestorePRGBank
	;If scrolling horizontally, set platform scroll X velocity
	lda AreaScrollFlags
	beq UpdateEnemyBGMovement_NoScroll
	;Clear platform scroll X velocity
	lda #$00
	beq UpdateEnemyBGMovement_Scroll
UpdateEnemyBGMovement_NoScroll:
	;Set platform scroll X velocity
	lda PlatformXVel
UpdateEnemyBGMovement_Scroll:
	sta PlatformScrollXVel
	;Update enemies BG movement
	ldx #$0F
UpdateEnemyBGMovement_BGLoop:
	;If enemy is active, update enemy BG movement
	lda Enemy_Flags,x
	bpl UpdateEnemyBGMovement_BGNext
	;Update enemy BG movement
	jsr UpdateEnemyBGMovementSub
UpdateEnemyBGMovement_BGNext:
	;Loop for each enemy
	dex
	bne UpdateEnemyBGMovement_BGLoop
UpdateEnemyBGMovement_Exit:
	rts

UpdateEnemyBGMovementSub:
	;Check for enemy BG movement flag
	ldy Enemy_ID,x
	lda EnemyMovementFlags,y
	and #$01
	beq UpdateEnemyBGMovementSub_NoMove
	;Update enemy BG movement
	jsr MoveEnemy
UpdateEnemyBGMovementSub_NoMove:
	;Check for enemy BG collision flag
	ldy Enemy_ID,x
	lda EnemyMovementFlags,y
	and #$02
	beq UpdateEnemyBGMovement_Exit
	;If enemy lifetime timer set, exit early
	lda Enemy_Temp5,x
	bmi UpdateEnemyBGMovement_Exit
	;Update enemy BG collision
	jmp CheckEnemyBG

;;;;;;;;;;;;;;;;
;ENEMY ROUTINES;
;;;;;;;;;;;;;;;;
;$6A: Level 6 boss
Enemy6A:
	;Load PRG bank $36 (level 6 boss subroutine bank)
	ldy #$36
	jsr LoadPRGBank
	;Level 6 boss subroutine
	jsr Enemy6ASub
	;Restore PRG bank
	jsr RestorePRGBank
	rts

;$61: Dark room
Enemy61:
	;Check if already inited
	lda Enemy_Temp0,x
	bne Enemy61_Main
	;Set enemy X velocity
	ldy Enemy_Temp1,x
	lda #$FE
	sta Enemy_XVelHi,x
	;Set enemy Y velocity/acceleration/sprite/flags based on parameter value
	lda DarkRoomYVel,y
	sta Enemy_YVelHi,x
	lda DarkRoomYAccel,y
	sta Enemy_YAccel,x
	lda DarkRoomSprite,y
	sta Enemy_SpriteLo,x
	lda DarkRoomFlags,y
	sta Enemy_Flags,x
	;Set dark room screen
	lda CurArea
	lsr
	clc
	adc DarkRoomScreen,y
	sta Enemy_Temp3,x
	sta Enemy_Temp3+$03,x
	;Set dark room screen position
	lda DarkRoomScreenPos,y
	sta Enemy_Temp4,x
	clc
	adc #$01
	sta Enemy_Temp4+$03,x
	;Set dark room VRAM address
	lda DarkRoomVRAMAddrHi,y
	sta Enemy_XLo,x
	sta Enemy_XLo+$03,x
	lda DarkRoomVRAMAddrLo,y
	sta Enemy_CollWidth,x
	clc
	adc #$04
	sta Enemy_CollWidth+$03,x
	;Clear dark room next column flag
	lda #$00
	sta Enemy_Temp2,x
	sta Enemy_Temp2+$03,x
	;Set dark room screen metatile column
	sta Enemy_Temp6,x
	sta Enemy_Temp6+$03,x
	;Init animation timer
	sta Enemy_CollHeight,x
	sta Enemy_CollHeight+$03,x
	;Mark inited
	inc Enemy_Temp0,x
Enemy61_InitExit:
	rts
DarkRoomYVel:
	.db $FF,$01,$FF
DarkRoomYAccel:
	.db $20,$E0,$20
DarkRoomFlags:
	.db EF_ACTIVE|EF_NOANIM|EF_PRIORITY|EF_VISIBLE
	.db EF_ACTIVE|EF_NOANIM|EF_PRIORITY
	.db EF_ACTIVE|EF_NOANIM|EF_PRIORITY
DarkRoomSprite:
	.db $5E,$5E,$5C
DarkRoomScreen:
	.db $08,$09,$09
DarkRoomScreenPos:
	.db $0A,$19,$2E
DarkRoomVRAMAddrHi:
	.db $20,$25,$26
DarkRoomVRAMAddrLo:
	.db $88,$84,$98
Enemy61_Main:
	;Update BG
	jsr DarkRoomUpdateBG
	;Check if on left or right side of screen
	lda Enemy_X,x
	bmi Enemy61_NoXC
	;Check for right side sprite
	lda Enemy_SpriteLo,x
	cmp #$5E
	beq Enemy61_NoXC
	;Set enemy sprite
	lda #$5E
	sta Enemy_SpriteLo,x
	;Set enemy X position
	lda Enemy_X,x
	clc
	adc #$28
	sta Enemy_X,x
Enemy61_NoXC:
	;If enemy Y velocity $FF, set enemy Y acceleration down
	lda Enemy_YVelLo,x
	bne Enemy61_InitExit
	lda Enemy_YVelHi,x
	cmp #$FF
	beq Enemy61_Down
	;If enemy Y velocity $01, set enemy Y acceleration up
	cmp #$01
	bne Enemy61_InitExit
	;Set enemy Y acceleration up
	lda #$E0
	bne Enemy61_SetY
Enemy61_Down:
	;Set enemy Y acceleration down
	lda #$20
Enemy61_SetY:
	sta Enemy_YAccel,x
Enemy61_Exit:
	rts
DarkRoomUpdateBG:
	;Clear dark room BG
	inx
	inx
	inx
	jsr DarkRoomUpdateBG_Sub
	;Draw dark room BG
	dex
	dex
	dex
DarkRoomUpdateBG_Sub:
	;Decrement animation timer
	dec Enemy_CollHeight,x
	;If bits 0-1 of animation timer 0, set next column flag
	lda Enemy_CollHeight,x
	and #$03
	bne DarkRoomUpdateBG_NoNext
	;Set dark room next column flag
	lda #$01
	sta Enemy_Temp2,x
DarkRoomUpdateBG_NoNext:
	;If dark room next column flag not set, exit early
	lda Enemy_Temp2,x
	beq Enemy61_Exit
	;If bit 0 of global timer 0, exit early
	lda LevelGlobalTimer
	and #$01
	beq Enemy61_Exit
	;Clear dark room next column flag
	lda #$00
	sta Enemy_Temp2,x
	;Check for left or right nametable
	lda Enemy_XLo,x
	and #$04
	beq DarkRoomUpdateBG_Left
	;Decrement dark room VRAM address and metatile column
	jsr DarkRoomDecAddr
	beq DarkRoomUpdateBG_RightNoC
	jmp DarkRoomUpdateBG_Draw
DarkRoomUpdateBG_RightNoC:
	;Reset dark room screen metatile column
	lda #$03
	sta Enemy_Temp6,x
	;Decrement dark room screen position
	dec Enemy_Temp4,x
	;Check for dark room screen X position $07
	lda Enemy_Temp4,x
	and #$07
	cmp #$07
	bne DarkRoomUpdateBG_Draw
	;Reset dark room VRAM address low
	lda Enemy_CollWidth,x
	eor #$E0
	sta Enemy_CollWidth,x
	;Swap dark room VRAM nametable
	lda Enemy_XLo,x
	eor #$04
	sta Enemy_XLo,x
	;Reset dark room screen position
	lda Enemy_Temp4,x
	clc
	adc #$08
	sta Enemy_Temp4,x
	;Swap dark room screen
	lda Enemy_Temp3,x
	eor #$01
	sta Enemy_Temp3,x
	bne DarkRoomUpdateBG_Draw
DarkRoomUpdateBG_Left:
	;Decrement dark room VRAM address and metatile column
	jsr DarkRoomDecAddr
	bne DarkRoomUpdateBG_LeftNoC
	;Decrement dark room screen position
	dec Enemy_Temp4,x
	;Reset dark room screen metatile column
	lda #$03
	sta Enemy_Temp6,x
	bne DarkRoomUpdateBG_Draw
DarkRoomUpdateBG_LeftNoC:
	;If bits 0-6 of dark room VRAM address low $75, loop horizontally
	lda Enemy_CollWidth,x
	and #$7F
	cmp #$75
	bne DarkRoomUpdateBG_Draw
	;Reset dark room screen metatile column
	lda #$03
	sta Enemy_Temp6,x
	;Reset dark room VRAM address low
	lda Enemy_CollWidth,x
	and #$80
	ora #$1F
	sta Enemy_CollWidth,x
	;Increment dark room screen position
	lda Enemy_Temp4,x
	clc
	adc #$02
	sta Enemy_Temp4,x
	;Check for top row of metatiles
	and #$0F
	cmp #$07
	beq DarkRoomUpdateBG_NoTop
	;Increment dark room screen position
	lda Enemy_Temp4,x
	clc
	adc #$10
	sta Enemy_Temp4,x
DarkRoomUpdateBG_NoTop:
	;Swap dark room VRAM nametable
	lda Enemy_XLo,x
	eor #$04
	sta Enemy_XLo,x
	;Swap dark room screen
	lda Enemy_Temp3,x
	eor #$01
	sta Enemy_Temp3,x
DarkRoomUpdateBG_Draw:
	;If BG dark room not dark yet, exit early
	lda BGDarkRoomMode
	cmp #$03
	bcc DarkRoomDrawMetatile_Exit
	;Get dark room VRAM address low
	lda Enemy_CollWidth,x
	sta $04
	;If bits 0-6 of dark room VRAM address low >= $20, exit early
	and #$7F
	cmp #$20
	bcs DarkRoomDrawMetatile_Exit
	;Get dark room screen
	lda Enemy_Temp3,x
	sta $00
	;Get dark room screen position
	lda Enemy_Temp4,x
	sta $01
	;Get dark room screen metatile column
	lda Enemy_Temp6,x
	sta $02
	;Get dark room VRAM address high
	lda Enemy_XLo,x
	sta $03
	;Save X register
	stx $10
	;Init VRAM buffer column
	jsr WriteVRAMBufferCmd_InitCol
	;Set VRAM buffer address
	ldy $03
	lda $04
	jsr WriteVRAMBufferCmd_Addr
	;Draw dark room metatile
	jsr DarkRoomDrawMetatile
	;End VRAM buffer
	jsr WriteVRAMBufferCmd_End
	;Restore X register
	ldx $10
	rts
DarkRoomDecAddr:
	;Decrement VRAM address
	dec Enemy_CollWidth,x
	;Decrement metatile column
	dec Enemy_Temp6,x
	lda Enemy_Temp6,x
	cmp #$FF
	rts
DarkRoomDrawMetatile:
	;Check for clear metatile slot index
	lda $10
	cmp #$04
	bcs DarkRoomDrawMetatile_Clear
	;Draw dark room metatile
	jmp DrawDarkRoomMetatile
DarkRoomDrawMetatile_Clear:
	;Clear dark room metatile
	lda #$00
	sta VRAMBuffer,x
	inx
	sta VRAMBuffer,x
	inx
	sta VRAMBuffer,x
	inx
	sta VRAMBuffer,x
	inx
DarkRoomDrawMetatile_Exit:
	rts

;$62: Beetle in wall
Enemy62:
	;Do jump table
	lda Enemy_Temp0,x
	jsr DoJumpTable
Enemy62JumpTable:
	.dw Enemy62_Sub0	;$00  Init
	.dw Enemy62_Sub1	;$01  Main
	.dw Enemy62_Sub2	;$02  Finish
;$00: Init
Enemy62_Sub0:
	;Set enemy animation based on parameter value
	ldy Enemy_Temp1,x
	lda BeetleInWallAnim,y
	tay
	jsr SetEnemyAnimation
	;Set enemy priority to be behind background
	lda #$20
	sta Enemy_Props,x
	;Set enemy flags
	lda #(EF_ACTIVE|EF_INVINCIBLE|EF_HITBULLET|EF_HITENEMY|EF_VISIBLE)
	sta Enemy_Flags,x
	;Init animation frame counter
	lda #$07
	sta Enemy_Temp2,x
	;Next task ($01: Main)
	inc Enemy_Temp0,x
Enemy62_Sub0_Exit:
	rts
;$01: Main
Enemy62_Sub1:
	;If animation timer 0, update beetle in wall
	lda Enemy_Temp3,x
	beq Enemy62_Sub1_NoDec
	;Decrement animation timer
	dec Enemy_Temp3,x
	rts
Enemy62_Sub1_NoDec:
	;If there's a level scroll update, exit early
	lda ScrollUpdateFlag
	bne Enemy62_Sub0_Exit
	;If bit 0 of global timer 0, exit early
	ldy Enemy_Temp1,x
	lda LevelGlobalTimer
	and #$01
	beq Enemy62_Sub0_Exit
	;If animation frame counter not $07, don't check to start animation
	lda Enemy_Temp2,x
	cmp #$07
	bne Enemy62_Sub1_NoCheck
	;If enemy X position not $8A-$A3, exit early
	lda Enemy_X,x
	cmp #$8A
	bcc Enemy62_Sub0_Exit
	cmp #$A4
	bcs Enemy62_Sub0_Exit
	;If beetle in wall already out, exit early
	lda BeetleInWallOutFlag
	bne Enemy62_Sub0_Exit
	;Set beetle in wall out flag
	lda #$01
	sta BeetleInWallOutFlag
	;Save Y register
	tya
	pha
	;Play sound
	ldy #SE_BEETLEINWALL
	jsr LoadSound
	;Restore Y register
	pla
	tay
Enemy62_Sub1_NoCheck:
	;Get beetle in wall VRAM address based on parameter value
	lda BeetleInWallVRAMAddrHi,y
	sta $02
	lda BeetleInWallVRAMAddrLo,y
	sta $03
	;Get beetle in wall direction based on parameter value
	lda BeetleInWallDirection,y
	and #$F0
	sta $04
	lda BeetleInWallDirection,y
	and #$20
	sta $05
	;Increment animation frame counter
	inc Enemy_Temp2,x
	lda Enemy_Temp2,x
	and #$07
	sta Enemy_Temp2,x
	;If animation frame counter $07, end animation
	cmp #$07
	bne Enemy62_Sub1_NoClear
	;Clear beetle in wall out flag
	lda #$00
	sta BeetleInWallOutFlag
	;Reset animation timer
	lda #$20
	sta Enemy_Temp3,x
Enemy62_Sub1_NoClear:
	;Get VRAM address offset data index
	lda Enemy_Temp2,x
	tay
	clc
	adc $05
	sta $00
	;Set enemy position
	lda BeetleInWallPosOffs,y
	eor $04
	clc
	adc Enemy_X,x
	sta Enemy_X,x
	lda BeetleInWallPosOffs,y
	eor $04
	clc
	adc Enemy_Y,x
	sta Enemy_Y,x
	;Get VRAM tile data index
	lda BeetleInWallDirection,y
	and #$04
	clc
	adc $05
	sta $01
	;Save X register
	stx $10
	;Init VRAM buffer row
	jsr WriteVRAMBufferCmd_InitRow
Enemy62_Sub1_Loop:
	;If VRAM address offset 0, end VRAM buffer
	ldy $00
	lda BeetleInWallVRAMOffs,y
	beq Enemy62_Sub1_End
	;Set VRAM buffer address
	clc
	adc $03
	sta VRAMBuffer,x
	inx
	lda $02
	sta VRAMBuffer,x
	inx
	;Draw tile row
	ldy $01
Enemy62_Sub1_Loop2:
	;Set tile in VRAM
	lda BeetleInWallVRAMData,y
	sta VRAMBuffer,x
	inx
	iny
	;Loop for each tile
	cmp #$FF
	bne Enemy62_Sub1_Loop2
	;Save VRAM tile data index
	sty $01
	;Init VRAM buffer row
	lda #$01
	sta VRAMBuffer,x
	inx
	;Increment VRAM address offset data index
	lda $00
	clc
	adc #$08
	sta $00
	;Loop for each row
	and #$18
	bne Enemy62_Sub1_Loop
Enemy62_Sub1_End:
	;End VRAM buffer
	dex
	stx VRAMBufferOffset
	;Restore X register
	ldx $10
;$02: Finish
Enemy62_Sub2:
	rts
BeetleInWallAnim:
	.db $62,$62,$62,$62,$2A,$2A,$2A,$2A
BeetleInWallPosOffs:
	.db $F8,$F8,$F8,$F8,$08,$08,$08,$08
BeetleInWallDirection:
	.db $04,$04,$04,$04,$F0,$F0,$F0,$F0
BeetleInWallVRAMAddrHi:
	.db $21,$22,$25,$26,$20,$21,$24,$25
BeetleInWallVRAMAddrLo:
	.db $00,$90,$00,$90,$00,$90,$00,$90
BeetleInWallVRAMOffs:
	.db $E4,$C3,$A2,$81,$82,$A3,$C4,$E5
	.db $00,$E3,$C2,$A1,$A2,$C3,$E4,$00
	.db $00,$00,$E3,$C2,$C2,$E3,$00,$00
	.db $00,$00,$00,$E3,$E3,$00,$00,$00
	.db $88,$A9,$CA,$EB,$EB,$CA,$A9,$88
	.db $00,$88,$A9,$CA,$CA,$A9,$88,$00
	.db $00,$00,$88,$A9,$A9,$88,$00,$00
	.db $00,$00,$00,$88,$88,$00,$00,$00
BeetleInWallVRAMData:
	;$00
	.db $00,$00,$00,$FF
	.db $00,$E0,$E1,$E1,$FF
	.db $00,$F2,$F3,$7E,$82,$FF
	.db     $F4,$7E,$7E,$F5,$F6,$FF
	.db         $86,$F5,$F7,$7E,$F9,$FF
	.db $01,$02,$03,$04,$05
	;$20
	.db                 $00,$00,$00,$FF
	.db             $BA,$BB,$DD,$00,$FF
	.db         $86,$7E,$87,$B9,$00,$FF
	.db     $83,$84,$7E,$7E,$85,$FF
	.db $80,$7E,$81,$84,$82,$FF

;$63: Ceiling slug
Enemy63:
	;Do jump table
	lda Enemy_Temp0,x
	jsr DoJumpTable
Enemy63JumpTable:
	.dw Enemy63_Sub0	;$00  Init
	.dw Enemy63_Sub1	;$01  Wait
	.dw Enemy63_Sub2	;$02  Fall
	.dw Enemy63_Sub3	;$03  Grab init
	.dw Enemy63_Sub4	;$04  Grab small
	.dw Enemy63_Sub5	;$05  Grab medium
	.dw Enemy63_Sub6	;$06  Grab large
	.dw Enemy63_Sub7	;$07  Death
;$00: Init
Enemy63_Sub0:
	;Set enemy animation
	txa
	sta Enemy_AnimTimer,x
	;Set enemy props
	lda #$C0
	sta Enemy_Props,x
	;Next task ($01: Wait)
	inc Enemy_Temp0,x
;$02: Fall
Enemy63_Sub2:
	rts
;$01: Wait
Enemy63_Sub1:
	;If enemy X position - player X position >= $40, exit early
	lda Enemy_X,x
	sec
	sbc Enemy_X
	cmp #$40
	bcs Enemy63_Sub2
	;Set enemy animation
	ldy #$6A
	jsr SetEnemyAnimation
	;Flip enemy X
	lda #$40
	sta Enemy_Props,x
	;Set enemy velocity
	lda #$FC
	sta Enemy_XVelHi,x
	lda #$04
	sta Enemy_YVelHi,x
	;Next task ($02: Fall)
	inc Enemy_Temp0,x
Enemy63_Sub1_Exit:
	rts
;$03: Grab init
Enemy63_Sub3:
	;Play sound
	ldy #SE_ENEMYGRAB
	jsr LoadSound
	;Set enemy animation
	ldy #$64
	jsr SetEnemyAnimation
	;Set enemy flags
	lda #(EF_ACTIVE|EF_VISIBLE)
	sta Enemy_Flags,x
	;Set enemy props
	lda #$00
	sta Enemy_Props,x
	;Next task ($04: Grab small)
	inc Enemy_Temp0,x
;$04: Grab small
Enemy63_Sub4:
	;Copy player position and check for collision
	jsr Enemy63_Sub6
	;Decrement animation timer, check if 0
	dec Enemy_Temp2,x
	bne Enemy63_Sub1_Exit
	;Next task ($05: Grab medium)
	inc Enemy_Temp0,x
	;Increment size of slug grabbing
	inc EnemyGrabbingMode
	;Set enemy animation
	ldy #$66
	jmp SetEnemyAnimation
;$05: Grab medium
Enemy63_Sub5:
	;Copy player position and check for collision
	jsr Enemy63_Sub6
	;Decrement animation timer, check if 0
	dec Enemy_Temp2,x
	bne Enemy63_Sub1_Exit
	;Next task ($06: Grab large)
	inc Enemy_Temp0,x
	;Increment size of slug grabbing
	inc EnemyGrabbingMode
	;Set enemy animation
	ldy #$68
	jmp SetEnemyAnimation
;$07: Death
Enemy63_Sub7:
	;Decrement animation timer, check if 0
	dec Enemy_Temp6,x
	bne Enemy63_Sub1_Exit
	;Clear enemy flags
	lda #$00
	sta Enemy_Flags,x
	rts
;$06: Grab large
Enemy63_Sub6:
	;If player HP 0, set enemy Y acceleration
	lda Enemy_HP
	beq Enemy63_Sub6_SetY
	;Set enemy position
	lda Enemy_X
	sta Enemy_X,x
	lda Enemy_Y
	sec
	sbc #$14
	sta Enemy_Y,x
	;Set enemy props
	lda Enemy_Props
	sta Enemy_Props,x
	;Get collision type
	lda Enemy_X,x
	sta $00
	lda Enemy_Y,x
	sec
	sbc #$10
	sta $01
	jsr GetCollisionType
	;Check for death collision type (used by spikes)
	cmp #$04
	bne Enemy63_Sub1_Exit
	;Clear enemy velocity/acceleration
	jsr ClearEnemy_ClearXY
	;Clear enemy grabbing mode
	lda #$00
	sta EnemyGrabbingMode
	;Set animation timer
	lda #$20
	sta Enemy_Temp6,x
	;Next task ($07: Death)
	lda #$07
	sta Enemy_Temp0,x
	;Play sound
	ldy #SE_CRASH
	jsr LoadSound
	;Set enemy animation
	ldy #$E4
	jmp SetEnemyAnimation
Enemy63_Sub6_SetY:
	;Set enemy Y acceleration
	lda #$7F
	sta Enemy_YAccel,x

;$68: Lava worm
Enemy68:
	;Do nothing
	rts

;$6D: Lava platform
Enemy6D:
	;Check if already inited
	lda Enemy_Temp0,x
	beq Enemy6D_Init
	;Check to set enemy Y acceleration based on enemy Y velocity
	jmp Enemy61_NoXC
Enemy6D_Init:
	;Mark inited
	inc Enemy_Temp0,x
	;Set enemy X velocity
	lda #$01
	sta Enemy_XVelHi,x
	;Set enemy Y velocity/acceleration based on parameter value
	ldy Enemy_Temp1,x
	lda DarkRoomYVel,y
	sta Enemy_YVelHi,x
	lda DarkRoomYAccel,y
	sta Enemy_YAccel,x
	rts

;$67: Spike bug
Enemy67:
	;Load PRG bank $36 (spike bug subroutine bank)
	ldy #$36
	jsr LoadPRGBank
	;Spike bug subroutine
	jsr Enemy67Sub
	;Restore PRG bank
	jsr RestorePRGBank
	rts

EnemyShootDir:
	;Spawn enemy
	lda #$00
	sta $01
	lda Enemy_Props,x
	and #$40
	lsr
	lsr
	sbc #$07
	sta $00
	pha
	lda $02
	jsr FindFreeEnemySlot
	;If no free slot available, exit early
	bcc EnemyShootDir_Exit
	;Set enemy X velocity
	pla
	eor #$FF
	sta Enemy_XVelHi,y
	;Play sound
	ldy #SE_SHOOTFRONT
	jmp LoadSound
EnemyShootDir_Exit:
	pla
	rts

;$80: Mecha frog
Enemy80:
	;Do jump table
	lda Enemy_Temp0,x
	jsr DoJumpTable
Enemy80JumpTable:
	.dw Enemy80_Sub0	;$00  Init
	.dw Enemy80_Sub1	;$01  Spawn parts
	.dw Enemy80_Sub2	;$02  Idle
	.dw Enemy80_Sub3	;$03  Jump init
	.dw Enemy80_Sub4	;$04  Jump
	.dw Enemy80_Sub5	;$05  Split init
	.dw Enemy80_Sub6	;$06  Split
	.dw Enemy80_Sub7	;$07  Rejoin
Enemy80_Sub0_Active:
	;Clear enemy parts slot index
	lda #$00
	sta MechaFrogMiddleIndex
	sta MechaFrogBottomIndex
	;Setup next task ($01: Spawn parts)
	beq Enemy80_Sub1_NoSpawn
;$00: Init
Enemy80_Sub0:
	;Clear rejoin flag
	lda #$00
	sta MechaFrogRejoinFlag
	;Init enemy parts HP
	lda #$12
	sta MechaFrogTopHP
	sta MechaFrogMiddleHP
	sta MechaFrogBottomHP
	;Set parent enemy slot index
	stx MechaFrogTopIndex
	;If other slot active, clear enemy parts slot index
	ldy #$07
	lda Enemy_Flags,y
	bmi Enemy80_Sub0_Active
	;Set enemy middle part slot index
	sty MechaFrogMiddleIndex
	;If other slot active, clear enemy parts slot index
	dey
	lda Enemy_Flags,y
	bmi Enemy80_Sub0_Active
	;Set enemy bottom part slot index
	sty MechaFrogBottomIndex
	;Next task ($01: Spawn parts)
	inc Enemy_Temp0,x
;$01: Spawn parts
Enemy80_Sub1:
	;If no free slot available, exit early
	ldy MechaFrogBottomIndex
	beq Enemy80_Sub1_NoSpawn
	;Spawn enemy
	lda #$00
	sta $00
	sta $01
	lda #$A8
	jsr SpawnEnemy
	;Set enemy ID to mecha frog bottom
	lda #ENEMY_MECHAFROGBOTTOM
	sta Enemy_ID,y
	;Next task ($00: Init)
	lda #$00
	sta Enemy_Temp0,y
	;Set enemy HP
	lda MechaFrogBottomHP
	sta Enemy_HP,y
	;If no free slot available, exit early
	ldy MechaFrogMiddleIndex
	beq Enemy80_Sub1_NoSpawn
	;Spawn enemy
	lda #$00
	sta $00
	sta $01
	lda #$A8
	jsr SpawnEnemy
	;Set enemy ID to mecha frog middle
	lda #ENEMY_MECHAFROGMIDDLE
	sta Enemy_ID,y
	;Next task ($00: Init)
	lda #$00
	sta Enemy_Temp0,y
	;Set enemy HP
	lda MechaFrogMiddleHP
	sta Enemy_HP,y
Enemy80_Sub1_NoSpawn:
	;Next task ($02: Idle)
	inc Enemy_Temp0,x
	;Set enemy HP
	clc
	lda MechaFrogTopHP
	adc MechaFrogMiddleHP
	adc MechaFrogBottomHP
	ora #$07
	sta Enemy_HP,x
	;Clear enemy velocity
	lda #$00
	sta Enemy_XVelHi,x
	sta Enemy_YVelHi,x
Enemy80_Sub1_EntS4:
	;Set enemy animation
	ldy #$E9
	jsr SetEnemyAnimation
	;Init animation timer
	lda #$0C
	sta MechaFrogAnimTimer
Enemy80_Sub1_Exit:
	rts
;$02: Idle
Enemy80_Sub2:
	;Flip enemy to face player
	jsr EnemyFacePlayer
	;Decrement animation timer, check if 0
	dec MechaFrogAnimTimer
	bne Enemy80_Sub1_Exit
	;If bits 0-2 of enemy HP 0, split enemy
	lda Enemy_HP,x
	and #$07
	bne Enemy80_Sub2_NoSplit
	;Next task ($05: Split init)
	inc Enemy_Temp0,x
	inc Enemy_Temp0,x
Enemy80_Sub2_NoSplit:
	;Next task ($03: Jump init)
	inc Enemy_Temp0,x
	rts
;$03: Jump init
Enemy80_Sub3:
	;Set enemy jump
	ldy #$00
	jsr EnemyJump
	rts
;$04: Jump
Enemy80_Sub4:
	;If bits 0-5 of global timer 0, shoot toward player
	lda LevelGlobalTimer
	and #$3F
	bne Enemy80_Sub4_NoShoot
	;Shoot toward player
	lda #$00
	sta $00
	lda #$F8
	sta $01
	jsr EnemyShootPlayerOffs
Enemy80_Sub4_NoShoot:
	;Check for collision
	lda #$14
	jsr EnemyCheckCollision
	;If collision on bottom, setup next task
	bcc Enemy80_Sub4_Exit
	;Next task ($02: Idle)
	lda #$02
	sta Enemy_Temp0,x
	;Setup next task
	jmp Enemy80_Sub1_EntS4
Enemy80_Sub4_Exit:
	rts
;$05: Split init
Enemy80_Sub5:
	;If no free slot available, exit early
	lda MechaFrogBottomIndex
	beq Enemy80_Sub5_NoSplit
	;If no free slot available, exit early
	lda MechaFrogMiddleIndex
	beq Enemy80_Sub5_NoSplit
	;Save X register
	stx MechaFrogTopIndex2
	;Set enemy animation
	tax
	ldy #$E5
	jsr SetEnemyAnimation
	;Set enemy ID to mecha frog middle
	lda #ENEMY_MECHAFROGMIDDLE
	sta Enemy_ID,x
	;Set enemy HP
	lda MechaFrogMiddleHP
	sta Enemy_HP,x
	;Next task ($01: Fly)
	inc Enemy_Temp0,x
	;Set enemy animation
	ldx MechaFrogBottomIndex
	ldy #$E7
	jsr SetEnemyAnimation
	;Set enemy ID to mecha frog bottom
	lda #ENEMY_MECHAFROGBOTTOM
	sta Enemy_ID,x
	;Set enemy HP
	lda MechaFrogBottomHP
	sta Enemy_HP,x
	;Next task ($01: Idle)
	inc Enemy_Temp0,x
	;Restore X register
	ldx MechaFrogTopIndex2
	;Set enemy animation
	ldy #$E3
	jsr SetEnemyAnimation
	;Next task ($06: Split)
	inc Enemy_Temp0,x
	;Set enemy HP
	lda MechaFrogTopHP
	sta Enemy_HP,x
	;Reset animation timer
	lda #$00
	sta MechaFrogAnimTimer
	rts
Enemy80_Sub5_NoSplit:
	;Next task ($03: Jump init)
	lda #$03
	sta Enemy_Temp0,x
	rts
;$06: Split
Enemy80_Sub6:
	;Flip enemy to face player
	jsr EnemyFacePlayer
	;Target back
	jsr EnemyTargetBack
	;Target Y
	lda #$18
	sta $00
	jsr EnemyTargetY
	;Check if enemy Y velocity 0
	lda Enemy_YVelHi,x
	bne Enemy80_Sub6_NoClearY
	;Clear enemy Y velocity
	sta Enemy_YVelLo,x
Enemy80_Sub6_NoClearY:
	;Decrement animation timer, check if 0
	dec MechaFrogAnimTimer
	beq Enemy80_Sub6_Next
	;If bits 0-7 of animation timer 0, shoot toward player
	lda MechaFrogAnimTimer
	and #$7F
	bne Enemy80_Sub6_Exit
	;Shoot toward player
	jsr EnemyShootPlayer
Enemy80_Sub6_Exit:
	rts
Enemy80_Sub6_Next:
	;If any enemy parts not active, exit early
	jsr EnemyPartsGetFlags
	bpl Enemy80_Sub6_Exit
	;Set rejoin flag
	lda #$FF
	sta MechaFrogRejoinFlag
	;Set rejoin timer
	lda #$1E
	sta MechaFrogRejoinTimer
	rts

;$01: Mecha frog middle
Enemy01:
	;Do jump table
	lda Enemy_Temp0,x
	jsr DoJumpTable
Enemy01JumpTable:
	.dw Enemy01_Sub0	;$00  Init
	.dw Enemy01_Sub1	;$01  Fly
	.dw Enemy80_Sub7	;$02  Rejoin
;$00: Init
Enemy01_Sub0:
	;If top part active, set enemy position
	ldy MechaFrogTopIndex
	lda Enemy_Flags,y
	bpl Enemy01_Sub0_ClearF
	;Set enemy position
	lda Enemy_X,y
	sta Enemy_X,x
	lda Enemy_Y,y
	sta Enemy_Y,x
	rts
Enemy01_Sub0_ClearF:
	;Clear enemy flags
	lda #$00
	sta Enemy_Flags,x
	rts
;$01: Fly
Enemy01_Sub1:
	;Flip enemy to face player
	jsr EnemyFacePlayer
	;Target front
	jsr EnemyTargetFront
	;Target Y
	lda #$30
	sta $00
	jsr EnemyTargetY
	;Check if enemy Y velocity 0
	lda Enemy_YVelHi,x
	bne Enemy01_Sub1_NoClearY
	;Clear enemy Y velocity
	sta Enemy_YVelLo,x
Enemy01_Sub1_NoClearY:
	;If bits 0-4 and 6 of global timer 0, shoot toward front
	lda LevelGlobalTimer
	and #$5F
	bne Enemy01_Sub1_Exit
	;Shoot toward front
	lda #$24
	sta $02
	jsr EnemyShootDirFlip
Enemy01_Sub1_Exit:
	rts

;$07: Rejoin
Enemy80_Sub7:
	;Target X
	ldy MechaFrogBottomIndex
	lda Enemy_X,y
	lsr
	sta $00
	jsr EnemyTargetX
	;Target Y
	lda Enemy_Y,y
	lsr
	sta $00
	jsr EnemyTargetY
	;Check to rejoin enemy parts
	jsr EnemyPartsCheckRejoin
	rts

;$02: Mecha frog bottom
Enemy02:
	;Do jump table
	lda Enemy_Temp0,x
	jsr DoJumpTable
Enemy02JumpTable:
	.dw Enemy01_Sub0	;$00  Init
	.dw Enemy02_Sub1	;$01  Idle
	.dw Enemy02_Sub2	;$02  Jump
	.dw Enemy02_Sub3	;$03  Rejoin
;$01: Idle
Enemy02_Sub1:
	;Flip enemy to face player
	jsr EnemyFacePlayer
	;If bits 0-3 of global timer 0, set enemy jump
	lda LevelGlobalTimer
	and #$0F
	bne Enemy02_Sub1_Exit
	;Set enemy jump
	ldy #$04
	jsr EnemyJump
Enemy02_Sub1_Exit:
	rts
;$02: Jump
Enemy02_Sub2:
	;Check for collision
	lda #$0C
	jsr EnemyCheckCollision
	;If collision on bottom, setup next task ($01: Idle)
	bcc Enemy02_Sub2_Exit
	;Next task ($01: Idle)
	dec Enemy_Temp0,x
	;If rejoin flag not set, exit early
	lda MechaFrogRejoinFlag
	beq Enemy02_Sub2_Exit
	;Set enemy animation
	lda #$00
	sta Enemy_AnimOffs,x
	;Set enemy flags
	lda #(EF_ACTIVE|EF_NOANIM|EF_HITBULLET|EF_HITENEMY|EF_VISIBLE)
	sta Enemy_Flags,x
	;If any enemy parts not active, exit early
	jsr EnemyPartsGetFlags
	bpl Enemy02_Sub2_Exit
	;Next task ($02: Rejoin)
	ldy MechaFrogMiddleIndex
	lda #$02
	sta Enemy_Temp0,y
	;Next task ($07: Rejoin)
	ldy MechaFrogTopIndex
	lda #$07
	sta Enemy_Temp0,y
	;Next task ($03: Rejoin)
	inc Enemy_Temp0,x
	inc Enemy_Temp0,x
Enemy02_Sub2_Exit:
	rts
EnemyPartsGetFlags:
	;Get enemy flags for all parts
	ldy MechaFrogTopIndex
	lda Enemy_Flags,y
	ldy MechaFrogMiddleIndex
	and Enemy_Flags,y
	ldy MechaFrogBottomIndex
	and Enemy_Flags,y
	rts
;$03: Rejoin
Enemy02_Sub3:
	;Clear rejoin flag
	lda #$00
	sta MechaFrogRejoinFlag
	;Decrement rejoin timer, check if 0
	dec MechaFrogRejoinTimer
	bne Enemy02_Sub3_Exit
	;Check to rejoin enemy parts
	jsr EnemyPartsCheckRejoin
	;Save enemy bottom part HP
	lda Enemy_HP,x
	sta MechaFrogBottomHP
	;Save enemy middle part HP
	ldy MechaFrogMiddleIndex
	lda Enemy_HP,y
	sta MechaFrogMiddleHP
	;Save enemy top part HP
	ldy MechaFrogTopIndex
	lda Enemy_HP,y
	sta MechaFrogTopHP
	;Next task ($01: Spawn parts)
	lda #$01
	sta Enemy_Temp0,y
Enemy02_Sub3_Exit:
	rts
EnemyPartsCheckRejoin:
	;If all enemy parts active, exit early
	jsr EnemyPartsGetFlags
	bmi EnemyPartsCheckRejoin_Exit
	;If enemy top part active, setup next task
	ldy MechaFrogTopIndex
	lda Enemy_Flags,y
	bpl EnemyPartsCheckRejoin_NoTop
	;Next task ($06: Split)
	lda #$06
	sta Enemy_Temp0,y
EnemyPartsCheckRejoin_NoTop:
	;If enemy middle part active, setup next task
	ldy MechaFrogMiddleIndex
	lda Enemy_Flags,y
	bpl EnemyPartsCheckRejoin_NoMiddle
	;Next task ($01: Fly)
	lda #$01
	sta Enemy_Temp0,y
EnemyPartsCheckRejoin_NoMiddle:
	;If enemy bottom part active, setup next task
	ldy MechaFrogBottomIndex
	lda Enemy_Flags,y
	bpl EnemyPartsCheckRejoin_Exit
	;Next task ($01: Idle)
	lda #$01
	sta Enemy_Temp0,y
EnemyPartsCheckRejoin_Exit:
	rts

;$84: Crocodile
Enemy84:
	;Do jump table
	lda Enemy_Temp0,x
	jsr DoJumpTable
Enemy84JumpTable:
	.dw Enemy84_Sub0	;$00  Fall
	.dw Enemy84_Sub1	;$01  Walk
	.dw Enemy84_Sub2	;$02  Jump init
;$02: Jump init
Enemy84_Sub2:
	;Set enemy jump
	ldy #$08
	jsr EnemyJump
	;Next task ($00: Fall)
	lda #$00
	sta Enemy_Temp0,x
	;Flip enemy to face player
	jsr EnemyFacePlayer
	rts
;$00: Fall
Enemy84_Sub0:
	;Check for collision
	lda #$12
	jsr EnemyCheckCollision
	;If collision on bottom, setup next task ($01: Walk)
	bcs Enemy84_Sub0_Land
	;Restore enemy X velocity
	lda Enemy_Temp2,x
	sta Enemy_XVelHi,x
	rts
Enemy84_Sub0_Land:
	;Next task ($01: Walk)
	inc Enemy_Temp0,x
	;Set enemy animation
	ldy #$22
	jsr SetEnemyAnimation
	;Flip enemy to face player
	jsr EnemyFacePlayer
	;Set animation frame counter
	lda #$02
	sta Enemy_Temp3,x
	rts
;$01: Walk
Enemy84_Sub1:
	;If bits 0-6 of global timer 0, shoot projectile
	lda LevelGlobalTimer
	and #$7F
	bne Enemy84_Sub1_NoShoot
	;Shoot projectile
	lda #$24
	sta $02
	jsr EnemyShootDirFlip
Enemy84_Sub1_NoShoot:
	;Set enemy flags
	lda #(EF_ACTIVE|EF_HITBULLET|EF_HITENEMY|EF_VISIBLE)
	sta Enemy_Flags,x
	;Clear enemy Y velocity
	lda #$00
	sta Enemy_YVelHi,x
	;Get collision type
	lda Enemy_X,x
	sta $00
	lda Enemy_Y,x
	adc #$0F
	sta $01
	jsr GetCollisionType
	;If solid tile at bottom, go to next task ($02: Jump init)
	bne Enemy84_Sub1_Jump
	;Get collision type
	lda #$14
	clc
	adc $01
	sta $01
	jsr GetCollisionType
	;If no solid tile at bottom, go to next task ($02: Jump init)
	beq Enemy84_Sub1_Jump
	;Get facing direcion
	jsr EnemyGetDirection
	;Set enemy X velocity
	eor #$FF
	clc
	adc #$01
	sta Enemy_XVelHi,x
	;Get collision type front
	asl
	asl
	asl
	asl
	clc
	adc Enemy_X,x
	sta $00
	jsr GetCollisionType
	;If no solid tile at front, decrement animation frame counter
	beq Enemy84_Sub1_Dec
	;Get collision type
	lda Enemy_Y,x
	sec
	sbc #$08
	sta $01
	jsr GetCollisionType
	;If solid tile at top front, decrement animation frame counter
	bne Enemy84_Sub1_Dec
	;If player fire not active, exit early
	lda Enemy_Flags+$0F
	ora Enemy_Flags+$0E
	ora Enemy_Flags+$0D
	bpl Enemy84_Sub1_Exit
Enemy84_Sub1_Check:
	;If enemy Y position >= $40, go to next task ($02: Jump init)
	lda Enemy_Y,x
	cmp #$40
	bcc Enemy84_Sub1_Reset
Enemy84_Sub1_Jump:
	;Next task ($02: Jump init)
	inc Enemy_Temp0,x
Enemy84_Sub1_Exit:
	rts
Enemy84_Sub1_Dec:
	;Decrement animation frame counter, check if 0
	dec Enemy_Temp3,x
	beq Enemy84_Sub1_Check
	;Flip enemy X
	jsr EnemyFlip
	rts
Enemy84_Sub1_Reset:
	;Reset animation frame counter
	lda #$01
	sta Enemy_Temp3,x
	rts

;$86: Crocodile spawner
Enemy86:
	;Do jump table
	lda Enemy_Temp0,x
	jsr DoJumpTable
Enemy86JumpTable:
	.dw Enemy86_Sub0	;$00  Init
	.dw Enemy86_Sub1	;$01  Randomize
	.dw Enemy86_Sub2	;$02  Wait
	.dw Enemy86_Sub3	;$03  Spawn
;$00: Init
Enemy86_Sub0:
	;Set unused value
	lda #$00
	sta $01
	sta Enemy_Temp4,x
	;Init spawn X position
	sta Enemy_Temp3,x
	;Next task ($01: Randomize)
	inc Enemy_Temp0,x
	rts
;$01: Randomize
Enemy86_Sub1:
	;Set spawn X position randomly
	jsr GetPRNGValue
	and #$F0
	sta Enemy_Temp3,x
	;Init animation timer
	lda #$80
	sta Enemy_Temp1,x
	;Next task ($02: Wait)
	inc Enemy_Temp0,x
	rts
;$02: Wait
Enemy86_Sub2:
	;Decrement animation timer, check if 0
	dec Enemy_Temp1,x
	bne Enemy86_Sub2_Exit
	;Next task ($03: Spawn)
	inc Enemy_Temp0,x
	rts
Enemy86_Sub2_EntS3:
	;Next task ($01: Randomize)
	lda #$01
	sta Enemy_Temp0,x
Enemy86_Sub2_Exit:
	rts
;$03: Spawn
Enemy86_Sub3:
	;Check if crocodile already spawned
	ldy #$10
Enemy86_Sub3_Loop:
	;Loop for each slot index
	dey
	beq Enemy86_Sub3_Spawn
	;If enemy ID not crocodile, check next slot index
	lda #ENEMY_CROCODILE
	cmp Enemy_ID,y
	bne Enemy86_Sub3_Loop
	;If enemy not active, check next slot index
	lda Enemy_Flags,y
	bpl Enemy86_Sub3_Loop
Enemy86_Sub3_Exit:
	rts
Enemy86_Sub3_Spawn:
	;Spawn enemy
	lda Enemy_Temp3,x
	sbc Enemy_X,x
	sbc #$10
	sta $00
	lda #$08
	sta $01
	lda #$32
	jsr FindFreeEnemySlot
	;If no free slot available, exit early
	bcc Enemy86_Sub3_Exit
	;Set enemy ID to crocodile
	lda #ENEMY_CROCODILE
	sta Enemy_ID,y
	;Next task ($00: Fall)
	lda #$00
	sta Enemy_Temp0,y
	;Set enemy Y velocity/acceleration
	lda #$00
	sta Enemy_YVelHi,y
	lda #$40
	sta Enemy_YAccel,y
	;Set unused value
	lda #$0A
	sta Enemy_Temp1,y
	;Set enemy flags
	lda #(EF_ACTIVE|EF_NOANIM|EF_HITBULLET|EF_HITENEMY|EF_VISIBLE)
	sta Enemy_Flags,y
	;Save X/Y registers
	txa
	pha
	tya
	tax
	;Flip enemy to face player
	jsr EnemyFacePlayer
	;Get facing direcion
	jsr EnemyGetDirection
	;Set enemy X velocity
	eor #$FF
	tay
	iny
	tya
	sta Enemy_XVelHi,x
	;Save enemy X velocity
	sta Enemy_Temp2,x
	;Restore X register
	pla
	tax
	;Next task ($01: Randomize)
	bne Enemy86_Sub2_EntS3

EnemyGetDirection:
	;Get X direction based on enemy flip X
	lda Enemy_Props,x
	and #$40
	beq EnemyGetDirection_Right
	;Set X direction left
	lda #$FF
	bmi EnemyGetDirection_Exit
EnemyGetDirection_Right:
	;Set X direction right
	lda #$01
EnemyGetDirection_Exit:
	rts

EnemyShootPlayer:
	;Clear X/Y offset
	lda #$00
	sta $00
	sta $01

EnemyShootPlayerOffs:
	;Spawn projectile
	lda #$24
	jsr FindFreeEnemySlot
	;If no free slot available, exit early
	bcc EnemyShootPlayerOffs_Exit
	;Determine player relative position X
	lda Enemy_X,y
	lsr
	sta $0E
	lda Enemy_X
	lsr
	clc
	sbc $0E
	;Check if player is to left or right
	php
	bpl EnemyShootPlayerOffs_PosX
	;Flip enemy X velocity
	eor #$FF
EnemyShootPlayerOffs_PosX:
	sta $0E
	;Determine player relative position Y
	lda Enemy_Y,y
	lsr
	sta $0F
	lda Enemy_Y
	lsr
	clc
	sbc $0F
	;Check if player is to top or bottom
	php
	bpl EnemyShootPlayerOffs_PosY
	;Flip enemy Y velocity
	eor #$FF
EnemyShootPlayerOffs_PosY:
	sta $0F
	;Loop until |enemy X/Y velocity| <= $03
	lda #$03
EnemyShootPlayerOffs_Loop:
	;Shift enemy X/Y velocity right 1 bit
	lsr $0E
	lsr $0F
	;Check if |enemy X velocity| <= $03
	cmp $0E
	bcc EnemyShootPlayerOffs_Loop
	;Check if |enemy Y velocity| <= $03
	cmp $0F
	bcc EnemyShootPlayerOffs_Loop
	;If enemy X/Y velocity both 0, set Y velocity $01
	lda $0E
	ora $0F
	bne EnemyShootPlayerOffs_NoVel0
	;Set enemy Y velocity $01
	inc $0F
EnemyShootPlayerOffs_NoVel0:
	;Check if player is to top or bottom
	lda $0F
	plp
	bpl EnemyShootPlayerOffs_PosY2
	;Flip enemy Y velocity
	eor #$FF
EnemyShootPlayerOffs_PosY2:
	;Set enemy Y velocity
	sta Enemy_YVelHi,y
	;Check if player is to left or right
	lda $0E
	plp
	bpl EnemyShootPlayerOffs_PosX2
	;Flip enemy X velocity
	eor #$FF
EnemyShootPlayerOffs_PosX2:
	;Set enemy X velocity
	sta Enemy_XVelHi,y
EnemyShootPlayerOffs_Exit:
	rts

EnemyTargetFront:
	;Target front of player
	lda #$40
	bne EnemyTargetBack_AnyP

EnemyTargetBack:
	;Target back of player
	lda #$00
EnemyTargetBack_AnyP:
	;Target front or back of player X based on player flip X
	eor Enemy_Props
	and #$40
	clc
	adc #$20
	sta $00
	jsr EnemyTargetX
	;Clear enemy X velocity
	lda #$00
	sta Enemy_XVelLo,x
	rts

EnemyTargetX:
	;Save Y register
	sty $0F
	;Get distance to target X
	lda Enemy_X,x
	lsr
	sta $07
	lda $00
	sec
	sbc $07
	;Target X (shift 3 bits)
	ldy #$03
	jsr EnemyTarget
	;Set enemy X velocity
	sta Enemy_XVelHi,x
	lda $0E
	sta Enemy_XVelLo,x
	;Restore Y register
	ldy $0F
	rts

EnemyTargetY:
	;Save Y register
	sty $0F
	;Get distance to target Y
	lda Enemy_Y,x
	lsr
	sta $07
	lda $00
	sec
	sbc $07
	;Target Y (shift 4 bits)
	ldy #$04
	jsr EnemyTarget
	;Set enemy Y velocity
	sta Enemy_YVelHi,x
	lda $0E
	sta Enemy_YVelLo,x
	;Restore Y register
	ldy $0F
	rts

EnemyFacePlayer:
	;Check if player is to left or right
	lda Enemy_X
	cmp Enemy_X,x
	;Flip enemy X according to player relative position X
	ror
	ror
	and #$40
	sta Enemy_Props,x
	rts

EnemyJump:
	;Clear enemy velocity
	lda #$00
	sta Enemy_XVelLo,x
	sta Enemy_YVelLo,x
	;If enemy X position $00-$47, use entry 0
	lda Enemy_X,x
	cmp #$48
	bcc EnemyJump_NoInc
	;If enemy X position $48-$7F, use entry 1
	iny
	cmp #$80
	bcc EnemyJump_NoInc
	;If enemy X position $80-$B7, use entry 2
	iny
	cmp #$B8
	bcc EnemyJump_NoInc
	;If enemy X position $B8-$FF, use entry 3
	iny
EnemyJump_NoInc:
	;Get data table index
	tya
	asl
	asl
	tay
	;Set enemy velocity
	lda EnemyJumpDataTable,y
	sta Enemy_Temp2,x
	sta Enemy_XVelHi,x
	lda EnemyJumpDataTable+1,y
	sta Enemy_YVelHi,x
	;Get enemy flags value
	lda EnemyJumpDataTable+3,y
	sta $07
	;Get enemy animation value
	lda EnemyJumpDataTable+2,y
	tay
	;Set enemy Y acceleration
	lda #$40
	sta Enemy_YAccel,x
	;Set enemy animation
	tya
	beq EnemyJump_NoAnim
	jsr SetEnemyAnimation
EnemyJump_NoAnim:
	;Set enemy flags
	lda $07
	sta Enemy_Flags,x
	;Next task
	inc Enemy_Temp0,x
	;If enemy Y position $00-$3F, set enemy Y velocity $FE
	lda Enemy_Y,x
	cmp #$40
	bcs EnemyJump_Exit
	;Set enemy Y velocity
	lda #$FE
	sta Enemy_YVelHi,x
EnemyJump_Exit:
	rts
EnemyJumpDataTable:
	.db $03,$FA,$DC,EF_ACTIVE|EF_HITBULLET|EF_HITENEMY|EF_VISIBLE
	.db $01,$FD,$00,EF_ACTIVE|EF_HITBULLET|EF_HITENEMY|EF_VISIBLE
	.db $01,$FD,$00,EF_ACTIVE|EF_HITBULLET|EF_HITENEMY|EF_VISIBLE
	.db $FE,$FA,$DC,EF_ACTIVE|EF_HITBULLET|EF_HITENEMY|EF_VISIBLE
	.db $03,$FA,$E7,EF_ACTIVE|EF_HITBULLET|EF_HITENEMY|EF_VISIBLE
	.db $01,$FD,$E7,EF_ACTIVE|EF_NOANIM|EF_HITBULLET|EF_HITENEMY|EF_VISIBLE
	.db $01,$FD,$E7,EF_ACTIVE|EF_NOANIM|EF_HITBULLET|EF_HITENEMY|EF_VISIBLE
	.db $FE,$FA,$E7,EF_ACTIVE|EF_HITBULLET|EF_HITENEMY|EF_VISIBLE
	.db $02,$FA,$32,EF_ACTIVE|EF_HITBULLET|EF_HITENEMY|EF_VISIBLE
	.db $01,$FA,$32,EF_ACTIVE|EF_HITBULLET|EF_HITENEMY|EF_VISIBLE
	.db $FF,$FA,$32,EF_ACTIVE|EF_HITBULLET|EF_HITENEMY|EF_VISIBLE
	.db $FE,$FA,$32,EF_ACTIVE|EF_HITBULLET|EF_HITENEMY|EF_VISIBLE

EnemyCheckCollision:
	;Set Y collision check offset
	adc Enemy_Y,x
	sta $01
	;Set enemy X velocity
	lda Enemy_XVelHi
	clc
	adc Enemy_Temp2,x
	sta Enemy_XVelHi,x
	;Check if moving down
	lda Enemy_YVelHi,x
	bmi EnemyCheckCollision_NoBottom
	;Get collision type
	lda Enemy_X,x
	sta $00
	jsr GetCollisionType
	;If solid tile underneath, clear enemy velocity/acceleration
	ora #$00
	beq EnemyCheckCollision_NoBottom
	;Clear enemy velocity/acceleration
	lda #$00
	sta Enemy_XVelHi,x
	sta Enemy_YVelHi,x
	sta Enemy_YVelLo,x
	sta Enemy_YAccel,x
	;Set carry flag
	sec
	rts
EnemyCheckCollision_NoBottom:
	;Get collision type
	lda Enemy_X,x
	sta $00
	lda Enemy_XVelHi,x
	asl
	asl
	asl
	asl
	clc
	lda Enemy_Y,x
	sta $01
	jsr GetCollisionType
	;If solid tile in front, clear enemy X velocity
	beq EnemyCheckCollision_NoFront
	;Clear enemy X velocity
	lda #$00
	sta Enemy_XVelHi,x
	sta Enemy_Temp2,x
EnemyCheckCollision_NoFront:
	;Clear carry flag
	clc
	rts

EnemyTarget:
	;Save A register
	pha
	;Init high byte of result
	lda #$80
	sta $0E
	;Restore A register
	pla
EnemyTarget_Loop:
	;Shift right arithmetically
	cmp #$80
	ror
	ror $0E
	;Loop for each bit
	dey
	bne EnemyTarget_Loop
	rts

EnemyShootDirFlip:
	;Flip enemy X
	jsr EnemyFlip
	;Shoot toward front
	jsr EnemyShootDir

EnemyFlip:
	;Flip enemy X
	lda Enemy_Props,x
	eor #$40
	sta Enemy_Props,x
	rts

;$85: Rotating room shooter
Enemy85:
	;If drawing scroll X position $80, exit early
	lda BGRotRoomDrawScrollX
	cmp #$80
	beq Enemy6E_Sub0
	;If bits 0-5 of drawing scroll X position not 0, exit early
	and #$3F
	bne Enemy6E_Sub0
	;Spawn enemy
	lda #$FF
	sta $00
	lda #$08
	sta $01
	ldy #$06
	lda #$7E
	jsr SpawnEnemy
	;Set enemy sprite
	lda #$6C
	sta Enemy_SpriteLo+$06
	;Set enemy flags
	lda #(EF_ACTIVE|EF_NOANIM|EF_HITENEMY|EF_VISIBLE)
	sta Enemy_Flags+$06
	;Set enemy Y velocity
	lda #$06
	sta Enemy_YVelHi+$06
	;Set enemy ID to enemy fire 2
	lda #ENEMY_ENEMYFIRE2
	sta Enemy_ID+$06
	;Play sound
	ldy #SE_SHOOTLASER
	jmp LoadSound

;$6E: Tanker side spikes
Enemy6E:
	;Check if already inited
	lda Enemy_Temp0,x
	bne Enemy6E_Main
	;Set tanker side spikes VRAM address based on slot index and parameter value
	txa
	sec
	sbc #$01
	asl
	asl
	clc
	adc Enemy_Temp1,x
	tay
	lda TankerSideSpikesVRAMAddrHi,y
	sta Enemy_Temp2,x
	lda TankerSideSpikesVRAMAddrLo,y
	sta Enemy_Temp3,x
	;Mark inited
	inc Enemy_Temp0,x
	;If enemy X position $EF, exit early
	lda Enemy_X,x
	cmp #$EF
	beq Enemy6E_Sub0
	;Set enemy flags
	lda #(EF_ACTIVE|EF_NOANIM|EF_HITENEMY|EF_VISIBLE)
	sta Enemy_Flags,x
;$00: Idle in
;$02: Idle out
Enemy6E_Sub0:
	rts
Enemy6E_Main:
	;If bits 0-1 of global timer not $01, exit early
	lda LevelGlobalTimer
	and #$03
	cmp #$01
	bne Enemy6E_Sub0
	;Do jump table
	lda BGAnimMode
	jsr DoJumpTable
Enemy6EJumpTable:
	.dw Enemy6E_Sub0	;$00  Idle in
	.dw Enemy6E_Sub1	;$01  Moving out
	.dw Enemy6E_Sub0	;$02  Idle out
	.dw Enemy6E_Sub3	;$03  Moving in
;$01: Moving out
Enemy6E_Sub1:
	;Save X register
	stx $17
	;Get tanker side spikes VRAM address
	lda Enemy_Temp2,x
	sta $10
	lda Enemy_Temp3,x
	sta $11
	;Init VRAM buffer column
	txa
	tay
	jsr WriteVRAMBufferCmd_InitCol
	;Set VRAM buffer address
	lda $11
	sta VRAMBuffer,x
	inx
	lda $10
	sta VRAMBuffer,x
	inx
	;Set tiles in VRAM
	lda TankerSideSpikesVRAMClear0Data-1,y
	sta VRAMBuffer,x
	inx
	lda TankerSideSpikesVRAMClear1Data-1,y
	sta VRAMBuffer,x
	inx
	lda TankerSideSpikesVRAMClear2Data-1,y
	sta VRAMBuffer,x
	inx
	lda TankerSideSpikesVRAMClear3Data-1,y
	sta VRAMBuffer,x
	inx
	;End VRAM buffer
	jsr WriteVRAMBufferCmd_End
	;Draw collision tile column
	ldy $10
	lda $11
	sta $01
	lda #$04
	sta $00
	lda #$00
	sta $02
	jsr DrawCollisionTileCol
	;Draw attributes
	lda $11
	and #$03
	tay
	jsr Enemy6E_Sub3_Attr
	;Decrement tanker side spikes VRAM address
	dec Enemy_Temp3,x
	lda Enemy_Temp3,x
	cmp #$FF
	beq Enemy6E_Sub1_NoVRAMC
	cmp #$7F
	bne Enemy6E_Sub1_Exit
	lda #$9F
	bne Enemy6E_Sub1_SetLo
Enemy6E_Sub1_NoVRAMC:
	lda #$1F
Enemy6E_Sub1_SetLo:
	sta Enemy_Temp3,x
Enemy6E_Sub1_Swap:
	;Swap nametable
	lda Enemy_Temp2,x
	eor #$04
	sta Enemy_Temp2,x
Enemy6E_Sub1_Exit:
	rts

;$03: Moving in
Enemy6E_Sub3:
	;Increment tanker side spikes VRAM address
	inc Enemy_Temp3,x
	lda Enemy_Temp3,x
	cmp #$A0
	beq Enemy6E_Sub3_NoVRAMC
	cmp #$20
	bne Enemy6E_Sub3_Draw
	lda #$00
	beq Enemy6E_Sub3_SetLo
Enemy6E_Sub3_NoVRAMC:
	lda #$80
Enemy6E_Sub3_SetLo:
	sta Enemy_Temp3,x
	;Swap nametable
	jsr Enemy6E_Sub1_Swap
Enemy6E_Sub3_Draw:
	;Save X register
	stx $17
	;Get tanker side spikes VRAM address
	lda Enemy_Temp2,x
	sta $10
	lda Enemy_Temp3,x
	sta $11
	;Init VRAM buffer column
	txa
	tay
	jsr WriteVRAMBufferCmd_InitCol
	;Set VRAM buffer address
	lda $11
	sta VRAMBuffer,x
	inx
	lda $10
	sta VRAMBuffer,x
	inx
	;Set tiles in VRAM
	lda TankerSideSpikesVRAMSet0Data-1,y
	sta VRAMBuffer,x
	inx
	lda TankerSideSpikesVRAMSet1Data-1,y
	sta VRAMBuffer,x
	inx
	lda TankerSideSpikesVRAMSet2Data-1,y
	sta VRAMBuffer,x
	inx
	lda TankerSideSpikesVRAMSet3Data-1,y
	sta VRAMBuffer,x
	inx
	;End VRAM buffer
	jsr WriteVRAMBufferCmd_End
	;Draw collision tile column
	ldy $10
	lda $11
	sta $01
	lda #$04
	sta $00
	lda #$02
	sta $02
	jsr DrawCollisionTileCol
	;Draw attributes
	lda $11
	and #$03
	tay
	iny
Enemy6E_Sub3_Attr:
	;Get VRAM attributes address
	lda $10
	ora #$03
	sta $08
	asl $11
	rol $10
	asl $10
	asl $10
	asl $10
	lsr $11
	lsr $11
	lsr $11
	lda $11
	and #$07
	ora $10
	ora #$C0
	sta $09
	;Init VRAM buffer row
	jsr WriteVRAMBufferCmd_InitRow
	;Set VRAM buffer address
	lda $09
	sta VRAMBuffer,x
	inx
	lda $08
	sta VRAMBuffer,x
	inx
	;Set attribute in VRAM
	lda TankerSideSpikesVRAMAttrData,y
	sta VRAMBuffer,x
	inx
	;End VRAM buffer
	jsr WriteVRAMBufferCmd_End
	;Restore X register
	ldx $17
	rts
TankerSideSpikesVRAMAddrHi:
	.db $20,$20,$20,$20
	.db $20,$24,$20,$20
	.db $21,$21,$21,$21
	.db $21,$21,$21,$21
	.db $26,$26,$22,$26
	.db $22,$22,$22,$22
TankerSideSpikesVRAMAddrLo:
	.db $07,$0B,$0F,$07
	.db $93,$9F,$83,$93
	.db $03,$0F,$03,$03
	.db $8F,$8B,$87,$87
	.db $1F,$1F,$03,$1F
	.db $97,$8F,$93,$97
TankerSideSpikesVRAMClear0Data:
	.db $78,$7C,$78,$7C,$78,$7C
TankerSideSpikesVRAMClear1Data:
	.db $79,$7A,$79,$7A,$79,$7A
TankerSideSpikesVRAMClear2Data:
	.db $7A,$7B,$7A,$7B,$7A,$7B
TankerSideSpikesVRAMClear3Data:
	.db $7B,$7D,$7B,$7D,$7B,$7D
TankerSideSpikesVRAMSet0Data:
	.db $92,$81,$A3,$A3,$92,$81
TankerSideSpikesVRAMSet1Data:
	.db $93,$82,$A7,$A7,$93,$82
TankerSideSpikesVRAMSet2Data:
	.db $AE,$81,$86,$86,$AE,$81
TankerSideSpikesVRAMSet3Data:
	.db $AB,$81,$8C,$8C,$AB,$81
TankerSideSpikesVRAMAttrData:
	.db $AA,$88,$88,$00,$00

;$6F: Gravity up/down area
Enemy6F:
	;Set enemy flags
	lda #(EF_ACTIVE|EF_NOANIM|EF_HITENEMY|EF_VISIBLE)
	sta Enemy_Flags,x
	;Set enemy collision size
	lda #$0A
	sta Enemy_CollWidth,x
	lda #$70
	sta Enemy_CollHeight,x
	;Clear gravity area mode
	lda #$00
	sta GravityAreaMode
	rts

;$04: Rotating room arrow
Enemy04:
	;Set enemy flags
	lda #(EF_ACTIVE|EF_NOANIM|EF_VISIBLE)
	sta Enemy_Flags,x
	;Check for left side of screen
	lda Enemy_X,x
	cmp #$60
	bcc Enemy04_Left
	;Check for right side of screen
	cmp #$A0
	bcs Enemy04_Right
	;Check for top side of screen
	lda Enemy_Y,x
	cmp #$60
	bcc Enemy04_Top
	;Set enemy sprite/props bottom
	ldy #$00
	beq Enemy04_Set
Enemy04_Top:
	;Set enemy sprite/props top
	ldy #$01
	bne Enemy04_Set
Enemy04_Right:
	;Set enemy sprite/props right
	ldy #$02
	bne Enemy04_Set
Enemy04_Left:
	;Set enemy sprite/props left
	ldy #$03
Enemy04_Set:
	lda RotatingRoomArrowSprite,y
	sta Enemy_SpriteLo,x
	lda RotatingRoomArrowProps,y
	sta Enemy_Props,x
	rts
RotatingRoomArrowSprite:
	.db $5E,$5E,$AE,$5C
RotatingRoomArrowProps:
	.db $C0,$00,$00,$00

;$70: BG robot from behind glass
Enemy70:
	;Do jump table
	lda Enemy_Temp0,x
	jsr DoJumpTable
Enemy70JumpTable:
	.dw Enemy70_Sub0	;$00  Init
	.dw Enemy70_Sub1	;$01  Wait
	.dw Enemy70_Sub2	;$02  Break
	.dw Enemy70_Sub3	;$03  Fall
	.dw Enemy70_Sub4	;$04  Turn
	.dw Enemy70_Sub5	;$05  Walk
;$00: Init
Enemy70_Sub0:
	;Check if enemy is already dead
	jsr GetItemEnemyBit
	lda EnemyTriggeredBits
	and $00
	beq Enemy70_Sub0_NoDead
	;If not initializer enemy, clear enemy flags
	tya
	beq Enemy70_Sub0_ClearF
	;Draw fully broken glass metatiles
	lda Enemy_Temp1,x
	and #$07
	tay
	jsr BGGlassRobotDrawBrokenMetatile
	;Next task ($05: Walk)
	lda #$05
	sta Enemy_Temp0,x
	;Set enemy flags
	lda #EF_ACTIVE
	sta Enemy_Flags,x
	rts
Enemy70_Sub0_ClearF:
	;Clear enemy flags
	lda #$00
	sta Enemy_Flags,x
	rts
Enemy70_Sub0_NoDead:
	;If initializer enemy, clear enemy flags
	tya
	bne Enemy70_Sub0_ClearF
	;Save enemy bit
	lda $00
	sta Enemy_Temp6,x
	;Save enemy Y position
	lda Enemy_Y,x
	sta Enemy_Temp4,x
	;Next task ($01: Wait)
	inc Enemy_Temp0,x
;$05: Walk
Enemy70_Sub5:
	rts
;$01: Wait
Enemy70_Sub1:
	;If break X position < enemy X position, exit early
	ldy Enemy_Temp1,x
	lda BGGlassRobotMetatileProps,y
	cmp Enemy_X,x
	bcc Enemy70_Sub5
	;Init animation timer
	lda #$10
	sta Enemy_Temp2,x
	;Set enemy triggered bit
	lda Enemy_Temp6,x
	ora EnemyTriggeredBits
	sta EnemyTriggeredBits
	;Play sound
	ldy #SE_BREAKGLASS
	jsr LoadSound
	;Next task ($02: Break)
	inc Enemy_Temp0,x
	;Get parameter value
	ldy Enemy_Temp1,x
	;Save X register
	txa
	pha
	;Draw half broken glass metatiles
	lda #$00
	sta $00
	lda #$71
	jsr BGGlassRobotDrawMetatile
	lda #$08
	sta $00
	lda #$71
	jsr BGGlassRobotDrawMetatile
	;Restore X register
	pla
	tax
	rts
BGGlassRobotDrawMetatile:
	;Draw metatile
	ldx UpdateMetatileCount
	sta UpdateMetatileID,x
	lda BGGlassRobotMetatilePos,y
	clc
	adc $00
	sta UpdateMetatilePos,x
	lda BGGlassRobotMetatileProps,y
	and #$01
	sta UpdateMetatileProps,x
	inc UpdateMetatileCount
BGGlassRobotDrawMetatile_Exit:
	rts
BGGlassRobotMetatileProps:
	.db $B0,$B0,$B1,$C0,$60,$B1,$61
BGGlassRobotMetatilePos:
	.db $00,$16,$14,$09,$06,$0B,$0F
;$02: Break
Enemy70_Sub2:
	;Decrement animation timer, check if 0
	dec Enemy_Temp2,x
	bne BGGlassRobotDrawMetatile_Exit
	;Set enemy animation
	ldy #$A9
	jsr SetEnemyAnimation
	;Restore enemy Y position
	lda Enemy_Temp4,x
	sta Enemy_Y,x
	;Spawn enemy
	lda #$00
	sta $00
	sta $01
	lda #$C7
	jsr FindFreeEnemySlot
	;Set enemy Y acceleration
	lda #$7F
	sta Enemy_YAccel,y
	;Reset animation timer
	lda #$20
	sta Enemy_Temp2,x
	;Next task ($03: Fall)
	inc Enemy_Temp0,x
	;Get parameter value
	ldy Enemy_Temp1,x
BGGlassRobotDrawBrokenMetatile:
	;Save X register
	txa
	pha
	;Draw fully broken glass metatiles
	lda #$00
	sta $00
	lda #$72
	jsr BGGlassRobotDrawMetatile
	lda #$08
	sta $00
	lda #$73
	jsr BGGlassRobotDrawMetatile
	;Restore X register
	pla
	tax
BGGlassRobotDrawBrokenMetatile_Exit:
	rts
;$03: Fall
Enemy70_Sub3:
	;Decrement animation timer, check if 0
	dec Enemy_Temp2,x
	bne BGGlassRobotDrawBrokenMetatile_Exit
	;Set enemy animation
	ldy #$AB
	jsr SetEnemyAnimation
	;Reset animation timer
	lda #$20
	sta Enemy_Temp2,x
	;Next task ($04: Turn)
	inc Enemy_Temp0,x
	;Don't flip enemy X
	lda #$00
	;Check if on left or right side of screen
	ldy Enemy_X,x
	bmi Enemy70_Sub3_SetP
	;Flip enemy X
	lda #$40
Enemy70_Sub3_SetP:
	sta Enemy_Props,x
	;Play sound
	ldy #SE_BGGLASSROBOT
	jmp LoadSound
;$04: Turn
Enemy70_Sub4:
	;Decrement animation timer, check if 0
	dec Enemy_Temp2,x
	bne BGGlassRobotDrawBrokenMetatile_Exit
	;Set enemy animation
	ldy #$AD
	jsr SetEnemyAnimation
	;Next task ($05: Walk)
	inc Enemy_Temp0,x
	;Check if facing left or right
	lda Enemy_Props,x
	beq Enemy70_Sub4_Left
	;Set enemy X velocity right
	lda #$00
	sta Enemy_XVelHi,x
	lda #$40
	sta Enemy_XVelLo,x
	rts
Enemy70_Sub4_Left:
	;Set enemy X velocity left
	lda #$FF
	sta Enemy_XVelHi,x
	lda #$C0
	sta Enemy_XVelLo,x
	rts

;$71: Background monitor
Enemy71:
	;Check for kissing animation
	lda Enemy_Temp1,x
	beq Enemy71_NoKiss
	;Check if already inited
	lda Enemy_Temp0,x
	bne Enemy71_Exit
	;Mark inited
	inc Enemy_Temp0,x
	;Set enemy animation
	ldy #$BF
	jmp SetEnemyAnimation
Enemy71_NoKiss:
	;Check for static mode
	lda Enemy_Temp0,x
	beq Enemy71_Static
	;Check for talking mode
	cmp #$01
	beq Enemy71_Talk
	;Decrement animation timer, check if 0
	dec Enemy_Temp2,x
	bne Enemy71_Exit
	;Clear enemy flags
	ldy Enemy_Temp3,x
	lda #$00
	sta Enemy_Flags,y
	;Next mode ($00: Static)
	sta Enemy_Temp0,x
Enemy71_Static:
	;Set enemy animation
	ldy #$BD
	jsr SetEnemyAnimation
	;Init animation timer
	lda #$30
Enemy71_SetT:
	sta Enemy_Temp2,x
	;Next mode ($01: Talking)
	inc Enemy_Temp0,x
Enemy71_Exit:
	rts
Enemy71_Talk:
	;Decrement animation timer, check if 0
	dec Enemy_Temp2,x
	bne Enemy71_Exit
	;Spawn enemy
	lda #$00
	sta $00
	lda #$EC
	sta $01
	;Get random speech bubble animation
	jsr GetPRNGValue
	and #$03
	tay
	lda BackgroundMonitorAnim,y
	pha
	txa
	tay
	iny
	pla
	jsr SpawnEnemy
	;Save speech bubble slot index
	tya
	sta Enemy_Temp3,x
	;Reset animation timer
	lda #$40
	bne Enemy71_SetT
BackgroundMonitorAnim:
	.db $C1,$C1,$C3,$C5

;$72: Conveyor platform
Enemy72:
	;Decrement animation timer, check if 0
	dec Enemy_Temp1,x
	bne Enemy72_Exit
	;Increment animation frame counter
	lda Enemy_Temp2,x
	clc
	adc #$01
	and #$07
	sta Enemy_Temp2,x
	tay
	;Set enemy sprite based on animation frame counter
	lda ConveyorPlatformSprite,y
	sta Enemy_SpriteLo,x
	;Set enemy props based on animation frame counter
	lda ConveyorPlatformProps,y
	and #$40
	sta Enemy_Props,x
	;Reset animation timer based on animation frame counter
	lda ConveyorPlatformTimer,y
	sta Enemy_Temp1,x
	;Set enemy flags based on animation frame counter
	lda Enemy_Flags,x
	and #~EF_PLATFORM
	ora ConveyorPlatformFlags,y
	sta Enemy_Flags,x
	;Set enemy velocity based on animation frame counter
	lda ConveyorPlatformXVel,y
	sta Enemy_XVelHi,x
	lda ConveyorPlatformYVel,y
	sta Enemy_YVelHi,x
	lda ConveyorPlatformProps,y
	and #$80
	sta Enemy_YVelLo,x
	;If direction clockwise, exit early
	lda Enemy_Temp6,x
	beq Enemy72_Exit
	;Flip enemy X
	lda Enemy_Props,x
	eor #$40
	sta Enemy_Props,x
	;Flip enemy X velocity
	lda #$00
	sec
	sbc Enemy_XVelHi,x
	sta Enemy_XVelHi,x
Enemy72_Exit:
	rts
ConveyorPlatformSprite:
	.db $1A,$18,$10,$12,$14,$12,$10,$18
ConveyorPlatformProps:
	.db $00,$00,$80,$00,$40,$40,$C0,$40
ConveyorPlatformTimer:
	.db $09,$04,$80,$04,$09,$04,$80,$04
ConveyorPlatformXVel:
	.db $01,$01,$00,$FF,$FF,$FF,$00,$01
ConveyorPlatformYVel:
	.db $00,$00,$00,$00,$00,$00,$FF,$00
ConveyorPlatformFlags:
	.db EF_PLATFORM
	.db EF_PLATFORM
	.db EF_PLATFORM
	.db $00
	.db $00
	.db $00
	.db EF_PLATFORM
	.db EF_PLATFORM

;$7A: Level 7 boss top shooter
Enemy7A:
	;Do jump table
	lda Enemy_Temp0+$02
	jsr DoJumpTable
Enemy7AJumpTable:
	.dw Enemy7A_Sub0	;$00  Init
	.dw Enemy7A_Sub1	;$01  Main
	.dw Enemy7A_Sub2	;$02  Stop
	.dw Enemy7A_Sub3	;$03  Shoot
;$00: Init
Enemy7A_Sub0:
	;Set shoot X position
	lda #$14
	sta Enemy_Temp2+$02
	;Set enemy X velocity
	lda #$01
	sta Enemy_XVelHi+$02
	;Set enemy collision height
	lda #$50
	sta Enemy_CollHeight+$02
	;Next task ($01: Main)
	inc Enemy_Temp0+$02
Enemy7A_Sub0_Exit:
	rts
;$01: Main
Enemy7A_Sub1:
	;If moving left, don't shoot laser
	lda Enemy_XVelHi+$02
	bmi Enemy7A_Sub1_NoShoot
	;If enemy X position = shoot X position, shoot laser
	lda Enemy_X+$02
	cmp Enemy_Temp2+$02
	beq Enemy7A_Sub1_Shoot
Enemy7A_Sub1_NoShoot:
	;If enemy X position $00 or $60, flip enemy X velocity
	lda Enemy_X+$02
	beq Enemy7A_Sub1_FlipX
	cmp #$60
	bne Enemy7A_Sub0_Exit
Enemy7A_Sub1_FlipX:
	;Flip enemy X velocity
	lda Enemy_XVelHi+$02
	eor #$FF
	clc
	adc #$01
	sta Enemy_XVelHi+$02
	rts
Enemy7A_Sub1_Shoot:
	;Set next shoot X position
	lda Enemy_Temp2+$02
	sec
	sbc #$20
	bpl Enemy7A_Sub1_SetX
	lda #$54
Enemy7A_Sub1_SetX:
	sta Enemy_Temp2+$02
	;Clear enemy X velocity
	lda #$00
	sta Enemy_XVelHi+$02
	;Set enemy flags
	lda #(EF_ACTIVE|EF_VISIBLE)
	sta Enemy_Flags+$02
	;Next task ($02: Stop)
	inc Enemy_Temp0+$02
	rts
;$02: Stop
Enemy7A_Sub2:
	;If not end of animation, exit early
	lda Enemy_AnimOffs+$02
	cmp #$0E
	bne Enemy7A_Sub0_Exit
	;Set enemy flags
	lda #(EF_ACTIVE|EF_HITENEMY|EF_VISIBLE)
	sta Enemy_Flags+$02
	;Init animation timer
	lda #$10
	sta Enemy_Temp1+$02
	;Next task ($03: Shoot)
	inc Enemy_Temp0+$02
	;Play sound
	ldy #SE_WHIRLASER2
	jmp LoadSound
;$03: Shoot
Enemy7A_Sub3:
	;Decrement animation timer, check if 0
	dec Enemy_Temp1+$02
	bne Enemy7A_Sub0_Exit
	;Set enemy flags
	lda #(EF_ACTIVE|EF_NOANIM|EF_VISIBLE)
	sta Enemy_Flags+$02
	;Set enemy sprite/animation
	lda #$4C
	sta Enemy_SpriteLo+$02
	lda #$05
	sta Enemy_AnimTimer+$02
	lda #$00
	sta Enemy_AnimOffs+$02
	;Next task ($01: Main)
	lda #$01
	sta Enemy_Temp0+$02
	;Set enemy X velocity
	sta Enemy_XVelHi+$02
	rts

;$7B: Level 7 boss shooters front part 1
Enemy7B:
	;Check if already inited
	lda Enemy_Temp0,x
	bne Enemy7B_Main
	;Init shooting timer
	lda #$40
	sta Enemy_Temp1,x
Enemy7B_SetF:
	;Set enemy priority to be behind background
	lda #$20
	sta Enemy_Props,x
	;Set enemy flags
	lda #(EF_ACTIVE|EF_NOANIM|EF_HITBULLET|EF_HITENEMY|EF_VISIBLE)
	sta Enemy_Flags,x
	;Next task
	inc Enemy_Temp0,x
Enemy7B_Exit:
	rts
Enemy7B_Main:
	;If shooting timer 0, spawn missile
	lda Enemy_Temp1,x
	beq Enemy7B_Spawn
	;Decrement shooting timer, check if 0
	dec Enemy_Temp1,x
	bne Enemy7B_Exit
Enemy7B_Spawn:
	;Get missile slot index
	txa
	clc
	adc #$04
	tay
	;If missile still active, exit early
	lda Enemy_Flags,y
	bne Enemy7B_Exit
	;Reset shooting timer
	lda #$40
	sta Enemy_Temp1,x
	;Spawn enemy
	lda #$00
	sta $00
	sta $01
	lda #$79
	jsr SpawnEnemy
	;Set enemy X velocity
	lda #$FF
	sta Enemy_XVelHi,y
	;Set enemy tile offset
	lda #$40
	sta Enemy_Temp7,y
	;Set enemy ID to boss missile homing
	lda #ENEMY_BOSSMISSILEHOMING
	sta Enemy_ID,y
	rts

;$0F: Level 7 boss shooters front part 2
Enemy0F:
	;Do jump table
	lda Enemy_Temp0,x
	jsr DoJumpTable
Enemy0FJumpTable:
	.dw Enemy0F_Sub0	;$00  Init
	.dw Enemy0F_Sub1	;$01  Out
	.dw Enemy0F_Sub2	;$02  Shoot laser
	.dw Enemy0F_Sub3	;$03  Wait
	.dw Enemy0F_Sub4	;$04  Clear laser
	.dw Enemy0F_Sub5	;$05  In
;$00: Init
Enemy0F_Sub0:
	;Get part 1 slot index
	txa
	sec
	sbc #$02
	tay
	;If part 1 still active, exit early
	lda Enemy_Flags,y
	bne Enemy0F_Sub0_Exit
	;Set enemy props/flags and setup next task ($01: Out)
	jsr Enemy7B_SetF
Enemy0F_Sub0_SetX:
	;Set enemy X velocity
	lda #$FF
	sta Enemy_XVelHi,x
	lda #$C0
	sta Enemy_XVelLo,x
Enemy0F_Sub0_Exit:
	rts
;$01: Out
Enemy0F_Sub1:
	;If enemy X position not $92, exit early
	lda Enemy_X,x
	cmp #$92
	bne Enemy0F_Sub0_Exit
	;Clear enemy X velocity
	lda #$00
	sta Enemy_XVelHi,x
	sta Enemy_XVelLo,x
	;Next task ($02: Shoot laser)
	inc Enemy_Temp0,x
	;Set enemy flags
	lda #(EF_ACTIVE|EF_NOANIM|EF_VISIBLE)
	sta Enemy_Flags,x
	;Init animation timer
	lda #$11
	sta Enemy_Temp2,x
	;Play sound
	ldy #SE_WHIRLASER1
	jmp LoadSound
Level7BossFrontPart1VRAMAddrHi:
	.db $24,$26
Level7BossFrontPart1VRAMAddr0Lo:
	.db $A0,$20
Level7BossFrontPart1VRAMAddr1Lo:
	.db $C0,$40
Level7BossFrontPart1MetatilePos:
	.db $0D,$25
Level7BossFrontPart1MetatileID:
	.db $C5,$C5,$C5,$C5,$B9
;$02: Shoot laser
Enemy0F_Sub2:
	;Decrement animation timer
	dec Enemy_Temp2,x
	lda Enemy_Temp2,x
	sta $16
	;Save X register
	txa
	tay
	;Init VRAM buffer row
	jsr WriteVRAMBufferCmd_InitRow
	;Set VRAM buffer address
	lda Level7BossFrontPart1VRAMAddr0Lo-5,y
	clc
	adc $16
	sta VRAMBuffer,x
	inx
	lda Level7BossFrontPart1VRAMAddrHi-5,y
	sta VRAMBuffer,x
	inx
	;Set tiles in VRAM
	lda #$64
	sta VRAMBuffer,x
	inx
	lda #$66
	sta VRAMBuffer,x
	inx
	;End VRAM buffer
	jsr WriteVRAMBufferCmd_End
	;Init VRAM buffer row
	jsr WriteVRAMBufferCmd_InitRow
	;Set VRAM buffer address
	lda Level7BossFrontPart1VRAMAddr1Lo-5,y
	clc
	adc $16
	sta VRAMBuffer,x
	inx
	lda Level7BossFrontPart1VRAMAddrHi-5,y
	sta VRAMBuffer,x
	inx
	;Set tiles in VRAM
	lda #$65
	sta VRAMBuffer,x
	inx
	lda #$67
	sta VRAMBuffer,x
	inx
	;End VRAM buffer
	jsr WriteVRAMBufferCmd_End
	;Restore X register
	tya
	tax
	;If not end of animation, exit early
	lda $16
	bne Enemy0F_Sub2_Exit
	;Spawn enemy
	lda #$C0
	sta $00
	lda #$00
	sta $01
	txa
	clc
	adc #$02
	tay
	lda #$A8
	jsr SpawnEnemy
	;Set enemy ID to enemy fire 2
	lda #ENEMY_ENEMYFIRE2
	sta Enemy_ID,y
	;Set enemy flags
	lda #(EF_ACTIVE|EF_NOANIM|EF_HITENEMY|EF_VISIBLE)
	sta Enemy_Flags,y
	;Set enemy collision size
	lda #$07
	sta Enemy_CollHeight,y
	lda #$40
	sta Enemy_CollWidth,y
	;Init animation timer
	lda #$20
	sta Enemy_Temp3,x
	;Next task ($03: Wait)
	inc Enemy_Temp0,x
Enemy0F_Sub2_Exit:
	rts
;$03: Wait
Enemy0F_Sub3:
	;Decrement animation timer, check if 0
	dec Enemy_Temp3,x
	bne Enemy0F_Sub2_Exit
	;Get metatile position
	lda Level7BossFrontPart1MetatilePos-5,x
	sta Enemy_Temp3,x
	;Next task ($04: Clear laser)
	inc Enemy_Temp0,x
	rts
;$04: Clear laser
Enemy0F_Sub4:
	;If bits 0-1 of global timer not 0, exit early
	lda LevelGlobalTimer
	and #$03
	bne Enemy0F_Sub2_Exit
	;Decrement metatile position
	dec Enemy_Temp3,x
	;Get metatile position
	lda Enemy_Temp3,x
	sta $00
	;Get metatile ID
	and #$04
	tay
	lda Level7BossFrontPart1MetatileID,y
	sta $01
	;Draw metatile
	ldy UpdateMetatileCount
	lda #$01
	sta UpdateMetatileProps,y
	lda $00
	sta UpdateMetatilePos,y
	lda $01
	sta UpdateMetatileID,y
	inc UpdateMetatileCount
	;If bits 0-2 of metatile position not 0, exit early
	lda Enemy_Temp3,x
	and #$07
	bne Enemy0F_Sub4_Exit
	;Clear enemy flags
	lda #$00
	sta Enemy_Flags+$02,x
	;Set enemy X velocity
	lda #$40
	sta Enemy_XVelLo,x
	;Set enemy flags
	lda #(EF_ACTIVE|EF_NOANIM|EF_HITBULLET|EF_HITENEMY|EF_VISIBLE)
	sta Enemy_Flags,x
	;Next task ($05: In)
	inc Enemy_Temp0,x
Enemy0F_Sub4_Exit:
	rts
;$05: In
Enemy0F_Sub5:
	;If enemy X position not $A8, exit early
	lda Enemy_X,x
	cmp #$A8
	bne Enemy0F_Sub4_Exit
	;Next task ($01: Out)
	lda #$01
	sta Enemy_Temp0,x
	;Set enemy X velocity
	jmp Enemy0F_Sub0_SetX

;$7C: Trooper jetpack spawner
Enemy7C:
	;Do jump table
	lda Enemy_Temp0,x
	jsr DoJumpTable
Enemy7CJumpTable:
	.dw Enemy7C_Sub0	;$00  Init
	.dw Enemy7C_Sub1	;$01  Closed wait
	.dw Enemy7C_Sub2	;$02  Open
	.dw Enemy7C_Sub3	;$03  Spawn
	.dw Enemy7C_Sub1	;$04  Open wait
	.dw Enemy7C_Sub2	;$05  Close
	.dw Enemy7C_Sub0	;$06  Finish
;$00: Init
;$06: Finish
Enemy7C_Sub0:
	;Init VRAM data index
	lda TrooperJetpackSpawnerIndex-9,x
	sta Enemy_Temp2,x
	;Init animation timer
	lda TrooperJetpackSpawnerTimer-9,x
	sta Enemy_Temp1,x
	;Next task ($01: Closed wait)
	lda #$01
	sta Enemy_Temp0,x
Enemy7C_Sub0_Exit:
	rts
TrooperJetpackSpawnerIndex:
	.db $00,$04
TrooperJetpackSpawnerTimer:
	.db $C0,$F0
TrooperJetpackSpawnerVRAMAddrHi:
	.db $24,$24,$24,$24
	.db $26,$26,$26,$26
TrooperJetpackSpawnerVRAMAddrLo:
	.db $70,$6F,$6E,$6D
	.db $8D,$8E,$8F,$90
TrooperJetpackSpawnerVRAMData:
	.db $00,$43,$43,$43
;$01: Closed wait
;$04: Open wait
Enemy7C_Sub1:
	;Decrement animation timer, check if 0
	dec Enemy_Temp1,x
	bne Enemy7C_Sub0_Exit
	;Next task
	inc Enemy_Temp0,x
	rts
;$02: Open
;$05: Close
Enemy7C_Sub2:
	;If bits 0-2 of global timer not 0, exit early
	lda LevelGlobalTimer
	and #$07
	bne Enemy7C_Sub0_Exit
	;Get tile
	ldy Enemy_Temp0,x
	lda TrooperJetpackSpawnerVRAMData-2,y
	sta $00
	;Get VRAM data index
	ldy Enemy_Temp2,x
	;Save X register
	stx $16
	;Init VRAM buffer row
	jsr WriteVRAMBufferCmd_InitRow
	;Set VRAM buffer address
	lda TrooperJetpackSpawnerVRAMAddrLo,y
	sta VRAMBuffer,x
	inx
	lda TrooperJetpackSpawnerVRAMAddrHi,y
	sta VRAMBuffer,x
	inx
	;Set tile in VRAM
	lda $00
	sta VRAMBuffer,x
	inx
	;End VRAM buffer
	jsr WriteVRAMBufferCmd_End
	;Restore X register
	ldx $16
	;Increment VRAM data index
	inc Enemy_Temp2,x
	;If not at end of animation, exit early
	lda Enemy_Temp2,x
	and #$03
	bne Enemy7C_Sub2_Exit
	;Set VRAM data index
	lda Enemy_Temp2,x
	sec
	sbc #$04
	sta Enemy_Temp2,x
	;Next task
	inc Enemy_Temp0,x
Enemy7C_Sub2_Exit:
	rts
;$03: Spawn
Enemy7C_Sub3:
	;Spawn enemy
	lda #$00
	sta $00
	sta $01
	;Get trooper slot index
	txa
	clc
	adc #$02
	tay
	;If trooper still active, exit early
	lda Enemy_Flags,y
	bne Enemy7C_Sub3_Exit
	;Spawn enemy
	lda #$3D
	jsr SpawnEnemy
	;Set enemy ID to trooper with jetpack
	lda #ENEMY_TROOPERJETPACK
	sta Enemy_ID,y
	;Set enemy velocity
	lda TrooperJetpackSpawnerYVel-$0B,y
	sta Enemy_YVelHi,y
	lda #$40
	sta Enemy_XVelLo,y
	;Reset animation timer
	lda #$10
	sta Enemy_Temp1,x
	;Next task ($04: Open wait)
	inc Enemy_Temp0,x
Enemy7C_Sub3_Exit:
	rts
TrooperJetpackSpawnerYVel:
	.db $01,$FF

;$79: Level 7 boss back
Enemy79:
	;Do jump table
	lda Enemy_Temp0+$01
	jsr DoJumpTable
Enemy79JumpTable:
	.dw Enemy79_Sub0	;$00  Init
	.dw Enemy79_Sub1	;$01  Wait
	.dw Enemy79_Sub2	;$02  Unbroken
	.dw Enemy79_Sub3	;$03  Break part 1
	.dw Enemy79_Sub4	;$04  Break part 2
	.dw Enemy79_Sub5	;$05  Main
;$00: Init
Enemy79_Sub0:
	;Set boss enemy slot index
	lda #$01
	sta BossEnemyIndex
	;Set enemy collision size
	lda #$08
	sta Enemy_CollWidth+$01
	lda #$18
	sta Enemy_CollHeight+$01
	;Set enemy flags
	lda #(EF_ACTIVE|EF_INVINCIBLE|EF_NOANIM|EF_HITBULLET|EF_HITENEMY|EF_VISIBLE)
	sta Enemy_Flags+$01
	;Next task ($01: Wait)
	inc Enemy_Temp0+$01
Enemy79_Sub0_Exit:
	rts
;$01: Wait
Enemy79_Sub1:
	;If part 2 still active, exit early
	lda Enemy_Flags+$05
	ora Enemy_Flags+$06
	bne Enemy79_Sub0_Exit
	;Set enemy flags
	lda #(EF_ACTIVE|EF_NOANIM|EF_HITBULLET|EF_HITENEMY|EF_VISIBLE)
	sta Enemy_Flags+$01
	;Next task ($02: Unbroken)
	inc Enemy_Temp0+$01
	rts
;$02: Unbroken
Enemy79_Sub2:
	;If enemy HP >= $78, exit early
	lda Enemy_HP+$01
	cmp #$78
	bcs Enemy79_Sub0_Exit
	;Draw partly broken part 1 glass metatiles
	lda #$D1
	sta $00
	lda #$D0
	sta $01
Enemy79_Sub2_Draw:
	;Draw metatiles
	ldy UpdateMetatileCount
	lda #$01
	sta UpdateMetatileProps,y
	sta UpdateMetatileProps+1,y
	lda $00
	sta UpdateMetatileID,y
	lda $01
	sta UpdateMetatileID+1,y
	lda #$15
	sta UpdateMetatilePos,y
	lda #$1D
	sta UpdateMetatilePos+1,y
	inc UpdateMetatileCount
	inc UpdateMetatileCount
	;Next task
	inc Enemy_Temp0+$01
	;Play sound
	ldy #SE_BREAKGLASS
	jmp LoadSound
;$03: Break part 1
Enemy79_Sub3:
	;If enemy HP >= $70, exit early
	lda Enemy_HP+$01
	cmp #$70
	bcs Enemy79_Sub0_Exit
	;Draw partly broken part 2 glass metatiles
	lda #$CF
	sta $00
	lda #$D2
	sta $01
	bne Enemy79_Sub2_Draw
;$04: Break part 2
Enemy79_Sub4:
	;If enemy HP >= $68, exit early
	lda Enemy_HP+$01
	cmp #$68
	bcs Enemy79_Sub0_Exit
	;Spawn enemy
	lda #$00
	sta $00
	sta $01
	ldy #$07
	lda #$C7
	jsr SpawnEnemy
	;Set enemy Y acceleration
	lda #$7F
	sta Enemy_YAccel,y
	;Set enemy tile offset
	lda #$40
	sta Enemy_Temp7,y
	;Save enemy HP
	lda Enemy_HP+$01
	sta Enemy_Temp6+$01
	;Init shooting timer
	lda #$20
	sta Enemy_Temp1+$01
	;Set enemy X position
	lda #$BC
	sta Enemy_X+$01
	;Set enemy collision height
	lda #$0C
	sta Enemy_CollHeight+$01
	;Draw fully broken glass metatiles
	lda #$AD
	sta $00
	lda #$AF
	sta $01
	bne Enemy79_Sub2_Draw
;$05: Main
Enemy79_Sub5:
	;Check to flash palette
	jsr Level7BossBackFlashPalette
	;Decrement shooting timer, check if 0
	dec Enemy_Temp1+$01
	beq Enemy79_Sub5_Shoot
	;If shooting timer not $40, exit early
	lda Enemy_Temp1+$01
	cmp #$40
	bne Enemy79_Sub5_Exit
	;Spawn explosion projectiles
	ldx #$03
	ldy #$03
Enemy79_Sub5_Loop:
	;Spawn projectile
	lda #$00
	sta $00
	sta $01
	lda #$1C
	jsr SpawnEnemy
	;Set enemy velocity based on slot index
	lda Level7BossBackExplodeXVel-3,y
	sta Enemy_XVelHi,y
	lda Level7BossBackExplodeYVel-3,y
	sta Enemy_YVelHi,y
	;Loop for each projectile
	iny
	cpy #$09
	bne Enemy79_Sub5_Loop
	;Restore X register
	ldx #$01
	;Play sound
	ldy #SE_CRASH
	jmp LoadSound
Enemy79_Sub5_Shoot:
	;Reset shooting timer
	lda #$80
	sta Enemy_Temp1+$01
	;Get random velocity data index
	jsr GetPRNGValue
	and #$03
	tay
	lda Level7BossBackYVelHi,y
	sta $16
	lda Level7BossBackYVelLo,y
	sta $15
	;Spawn projectile
	lda #$00
	sta $00
	sta $01
	ldy #$03
	lda #$14
	jsr SpawnEnemy
	;Set enemy velocity
	lda #$FE
	sta Enemy_XVelHi+$03
	lda $16
	sta Enemy_YVelHi+$03
	lda $15
	sta Enemy_YVelLo+$03
	;Set enemy ID to enemy fire 2
	lda #ENEMY_ENEMYFIRE2
	sta Enemy_ID+$03
Enemy79_Sub5_Exit:
	rts
Level7BossBackYVelHi:
	.db $FF,$FF,$00,$01
Level7BossBackYVelLo:
	.db $00,$80,$80,$00
Level7BossBackExplodeXVel:
	.db $00,$00,$02,$02,$FE,$FE
Level7BossBackExplodeYVel:
	.db $FD,$03,$02,$FE,$02,$FE
Level7BossBackFlashPalette:
	;If bits 0-3 of global timer not $04, exit early
	lda LevelGlobalTimer
	and #$07
	cmp #$04
	bne Level7BossBackFlashPalette_Exit
	;If enemy HP == saved HP, exit early
	lda Enemy_HP+$01
	cmp Enemy_Temp6+$01
	beq Level7BossBackFlashPalette_Exit
	;Save enemy HP
	lda Enemy_HP+$01
	sta Enemy_Temp6+$01
	;Load palette
	lda #$DD
	sta CurPalette
Level7BossBackFlashPalette_Exit:
	rts

;$4C: Spike particles
Enemy4C:
	;Decrement animation timer, check if 0
	dec Enemy_Temp2,x
	bne Enemy4C_Exit
	;Clear enemy flags
	lda #$00
	sta Enemy_Flags,x
Enemy4C_Exit:
	rts

;$7D: Escape flame
Enemy7D:
	;Check if already inited
	lda Enemy_Temp0,x
	bne Enemy7D_Main
	;Set enemy flags
	lda #(EF_ACTIVE|EF_NOANIM|EF_HITENEMY|EF_VISIBLE)
	sta Enemy_Flags,x
	;Mark inited
	inc Enemy_Temp0,x
	;Get direction
	lda Enemy_Temp1,x
	asl
	asl
	asl
	sta Enemy_Temp1,x
	;Save enemy Y position
	lda Enemy_Y,x
	sta Enemy_Temp2,x
	bne Enemy7D_SetAnim
Enemy7D_Main:
	;Increment animation timer
	inc Enemy_Temp4,x
	;If bits 0-1 of animation timer not 0, exit early
	lda Enemy_Temp4,x
	and #$03
	bne Enemy73
	;Increment animation frame counter
	inc Enemy_Temp3,x
	lda Enemy_Temp3,x
	and #$0F
	sta Enemy_Temp3,x
Enemy7D_SetAnim:
	;Get sprite data index
	ldy Enemy_Temp3,x
	lda EscapeFlameSpriteOffs,y
	clc
	adc Enemy_Temp1,x
	sta $00
	;Set enemy sprite
	asl
	clc
	adc #$8C
	sta Enemy_SpriteLo,x
	;Set enemy collision height
	ldy $00
	lda EscapeFlameCollHeight,y
	sta Enemy_CollHeight,x
	;Set enemy Y position
	lda EscapeFlameYPosOffs,y
	clc
	adc Enemy_Temp2,x
	sta Enemy_Y,x

;$73: Escape pod
Enemy73:
	;Do nothing
	rts

EscapeFlameCollHeight:
	.db $08,$08,$10,$18,$20,$28,$30,$30
EscapeFlameYPosOffs:
	.db $08,$08,$10,$18,$20,$28,$30,$30
	.db $F8,$F8,$F0,$E8,$E0,$D8,$D0,$D0
EscapeFlameSpriteOffs:
	.db $00,$01,$00,$01,$02,$03,$04,$05
	.db $06,$07,$06,$07,$05,$04,$03,$02

;$7E: Escape shooter
Enemy7E:
	;Set enemy flags
	lda #(EF_ACTIVE|EF_HITBULLET|EF_HITENEMY|EF_VISIBLE)
	sta Enemy_Flags,x
	;Check for left side shooter
	lda Enemy_Temp1,x
	bne Enemy7E_JT
	;Check for init mode
	lda Enemy_Temp0,x
	beq Enemy7E_Init
	;Check for shoot mode
	cmp #$02
	beq Enemy7E_Sub3
;$02: Left
Enemy7E_Sub2:
	;Decrement animation timer, check if 0
	dec Enemy_Temp2,x
	bne Enemy7E_Sub3
	;Next task
	inc Enemy_Temp0,x
	;Shoot toward player
	jsr EnemyShootPlayerOnce
	;Set enemy X velocity
	lda Enemy_XVelHi,y
	sec
	sbc #$02
	sta Enemy_XVelHi,y
	rts
Enemy7E_Init:
	;Set enemy X velocity
	lda #$FF
	sta Enemy_XVelHi,x
	;Init animation timer
	lda #$08
	sta Enemy_Temp2,x
	;Next task
	inc Enemy_Temp0,x
;$03: Shoot
Enemy7E_Sub3:
	rts
Enemy7E_JT:
	;Do jump table
	lda Enemy_Temp0,x
	jsr DoJumpTable
Enemy7EJumpTable:
	.dw Enemy7E_Sub0	;$00  Init
	.dw Enemy7E_Sub1	;$01  Right
	.dw Enemy7E_Sub2	;$02  Left
	.dw Enemy7E_Sub3	;$03  Shoot
;$00: Init
Enemy7E_Sub0:
	;Set enemy animation
	ldy #$96
	jsr SetEnemyAnimation
	;Set enemy props
	lda #$41
	sta Enemy_Props,x
	;Set enemy X velocity
	lda #$05
	sta Enemy_XVelHi,x
	;Set enemy X position
	lda #$00
	sta Enemy_X,x
	;Next task ($01: Right)
	inc Enemy_Temp0,x
Enemy7E_Sub0_Exit:
	rts
;$01: Right
Enemy7E_Sub1:
	;If enemy X position < $F0, exit early
	lda Enemy_X,x
	cmp #$F0
	bcc Enemy7E_Sub0_Exit
	;Set enemy X velocity/animation and setup next task ($02: ???)
	jsr Enemy7E_Init
	;Set enemy props
	lda #$01
	sta Enemy_Props,x
	rts

;$74: Trooper escaping
Enemy74:
	;Do jump table
	lda Enemy_Temp0,x
	jsr DoJumpTable
Enemy74JumpTable:
	.dw Enemy74_Sub0	;$00  Init
	.dw Enemy74_Sub1	;$01  Jump
	.dw Enemy74_Sub2	;$02  Land init
	.dw Enemy74_Sub3	;$03  Land
	.dw Enemy74_Sub4	;$04  Explode
;$00: Init
Enemy74_Sub0:
	;Check if jumping out of ship
	lda Enemy_Temp4,x
	beq Enemy74_Sub0_NoShip
	;Set enemy velocity
	lda #$F6
	sta Enemy_YVelHi,x
	lda #$03
	bne Enemy74_Sub0_SetX
Enemy74_Sub0_NoShip:
	;Check if player is to left or right
	lda Enemy_X,x
	sec
	sbc Enemy_X
	bcc Enemy74_Sub0_Right
	;Flip enemy X
	lda #$40
	sta Enemy_Props,x
	rts
Enemy74_Sub0_Right:
	;Set enemy velocity
	lda #$F8
	sta Enemy_YVelHi,x
	lda #$01
Enemy74_Sub0_SetX:
	sta Enemy_XVelHi,x
	;Set enemy props
	lda #$00
	sta Enemy_Props,x
	;Set enemy animation
	ldy #$EB
	jsr SetEnemyAnimation
	;Set enemy Y acceleration
	lda #$7F
	sta Enemy_YAccel,x
	;Next task ($01: Jump)
	inc Enemy_Temp0,x
;$03: Land
Enemy74_Sub3:
	rts
;$01: Jump
Enemy74_Sub1:
	;Get collision type
	lda Enemy_X,x
	sta $00
	lda Enemy_Y,x
	clc
	adc #$10
	sta $01
	jsr GetCollisionType
	;Check for death collision type (used by spikes)
	cmp #$04
	beq Enemy74_Sub1_Land
	;Get collision type
	lda $01
	sec
	sbc #$20
	sta $01
	jsr GetCollisionType
	;If solid tile at top, set enemy Y velocity
	beq Enemy74_Sub1_NoTop
	;Set enemy Y velocity
	lda #$01
	sta Enemy_YVelHi,x
	lda #$00
	sta Enemy_YVelLo,x
Enemy74_Sub1_NoTop:
	;If enemy Y velocity not 0, exit early
	lda Enemy_YVelHi,x
	ora Enemy_YVelLo,x
	bne Enemy74_Sub3
	;Next task ($02: Land init)
	inc Enemy_Temp0,x
	;Clear enemy X velocity
	lda #$00
	sta Enemy_XVelHi,x
	;Set enemy animation
	ldy #$BB
	jmp SetEnemyAnimation
Enemy74_Sub1_Land:
	;Next task ($02: Land init)
	inc Enemy_Temp0,x
	;Clear grabbing enemy
	jmp TrooperGrabbingClearGrab_NoDec
;$04: Explode
;$02: Explode
Enemy74_Sub4:
	;Decrement animation timer, check if 0
	dec Enemy_Temp2,x
	bne Enemy74_Sub4_Exit
Enemy74_Sub4_ClearF:
	;Clear enemy flags
	lda #$00
	sta Enemy_Flags,x
Enemy74_Sub4_Exit:
	rts
;$02: Land init
Enemy74_Sub2:
	;Next task ($03: Land)
	inc Enemy_Temp0,x
	;Get collision type
	lda Enemy_X,x
	sta $00
	lda Enemy_Y,x
	clc
	adc #$0C
	sta $01
	jsr GetCollisionType
	;Check for death collision type (used by spikes)
	cmp #$04
	bne Enemy74_Sub4_Exit
	;Clear grabbing enemy
	jmp TrooperGrabbingClearGrab_NoDec

;$75: Trooper grabbing
Enemy75:
	;Do jump table
	lda Enemy_Temp0,x
	jsr DoJumpTable
Enemy75JumpTable:
	.dw Enemy75_Sub0	;$00  Init
	.dw Enemy75_Sub1	;$01  Main
	.dw Enemy74_Sub4	;$02  Explode
Enemy75_Sub1_SetY:
	;Set enemy Y acceleration
	lda #$7F
	sta Enemy_YAccel,x
	;If enemy Y position >= $E0, clear enemy flags
	lda Enemy_Y,x
	cmp #$E0
	bcs Enemy74_Sub4_ClearF
Enemy75_Sub1_Exit:
	rts
;$00: Init
Enemy75_Sub0:
	;Play sound
	ldy #SE_ENEMYGRAB
	jsr LoadSound
	;Set enemy flags
	lda #(EF_ACTIVE|EF_VISIBLE)
	sta Enemy_Flags,x
	;Next task ($01: Main)
	inc Enemy_Temp0,x
;$01: Main
Enemy75_Sub1:
	;If player HP 0, set enemy Y acceleration
	lda Enemy_HP
	beq Enemy75_Sub1_SetY
	;Set enemy position based on grabbing index
	ldy Enemy_Temp6,x
	lda Enemy_Y
	clc
	adc TrooperGrabbingYOffs,y
	sta Enemy_Y,x
	lda Enemy_X
	sec
	sbc TrooperGrabbingXOffs,y
	sta Enemy_X,x
	;Check if offscreen
	bcs Enemy75_Sub1_NoClearF
	;Clear enemy visible flag
	lda #EF_ACTIVE
	sta Enemy_Flags,x
	rts
Enemy75_Sub1_NoClearF:
	;Set enemy visible flag
	lda #(EF_ACTIVE|EF_VISIBLE)
	sta Enemy_Flags,x
	;Get collision type
	lda Enemy_X,x
	sta $00
	lda Enemy_Y,x
	sta $01
	jsr GetCollisionType
	;Check for death collision type (used by spikes)
	cmp #$04
	beq Enemy75_Sub1_Explode
	;Get collision type
	lda $01
	clc
	adc #$08
	sta $01
	jsr GetCollisionType
	;Check for death collision type (used by spikes)
	cmp #$04
	bne Enemy75_Sub1_Exit
Enemy75_Sub1_Explode:
	;Check for first grabbing enemy
	lda Enemy_Temp6,x
	bne TrooperGrabbingClearGrab
	;Check if 2 troopers are already grabbing
	lda EnemyGrabbingMode
	cmp #$02
	bne TrooperGrabbingClearGrab
	;Clear first grabbing enemy
	ldx EnemyGrabbingIndex
	jsr TrooperGrabbingClearGrab
	;Clear second grabbing enemy
	ldx EnemyGrabbingIndex+1
TrooperGrabbingClearGrab:
	;Decrement number of troopers grabbing
	dec EnemyGrabbingMode
TrooperGrabbingClearGrab_NoDec:
	;Clear enemy velocity/acceleration
	jsr ClearEnemy_ClearXY
	;Next task
	inc Enemy_Temp0,x
	;Init animation timer
	lda #$10
	sta Enemy_Temp2,x
	;Play sound
	ldy #SE_CRASH
	jsr LoadSound
	;Set enemy animation
	ldy #$E4
	jmp SetEnemyAnimation
TrooperGrabbingXOffs:
	.db $10,$18
TrooperGrabbingYOffs:
	.db $1E,$3A

;$76: BG glass pipe
Enemy76:
	;Do jump table
	lda Enemy_Temp0,x
	jsr DoJumpTable
Enemy76JumpTable:
	.dw Enemy76_Sub0	;$00  Init
	.dw Enemy76_Sub0	;$01  Break part 1
	.dw Enemy76_Sub0	;$02  Break part 2
	.dw Enemy76_Sub0	;$03  Break part 3
	.dw Enemy76_Sub4	;$04  Broken
	.dw Enemy76_Sub5	;$05  Close part 1
	.dw Enemy76_Sub5	;$06  Close part 2
	.dw Enemy76_Sub5	;$07  Close part 3
	.dw Enemy76_Sub5	;$08  Close part 4
	.dw Enemy76_Sub9	;$09  Closed
;$00: Init
;$01: Break part 1
;$02: Break part 2
;$03: Break part 3
Enemy76_Sub0:
	;Set enemy collision size
	lda #$10
	sta Enemy_CollWidth,x
	lda #$20
	sta Enemy_CollHeight,x
	;Set enemy flags
	lda #(EF_ACTIVE|EF_NOANIM|EF_HITBULLET|EF_VISIBLE)
	sta Enemy_Flags,x
	;If enemy not shot yet, exit early
	lda Enemy_HP,x
	cmp #$7F
	bcs Enemy76_Sub9
	;Get metatile ID based on current task
	ldy Enemy_Temp0,x
	lda BGGlassPipeMetatileID,y
	sta $00
	ldy Enemy_Temp1,x
	;Save X register
	stx $10
	;Draw metatiles
	ldx UpdateMetatileCount
	lda $00
	sta UpdateMetatileID,x
	lda BGGlassPipeMetatileProps,y
	sta UpdateMetatileProps,x
	lda BGGlassPipeMetatilePos,y
	sta UpdateMetatilePos,x
	lda $00
	sta UpdateMetatileID+1,x
	lda BGGlassPipeMetatileProps,y
	sta UpdateMetatileProps+1,x
	lda BGGlassPipeMetatilePos,y
	clc
	adc #$08
	sta UpdateMetatilePos+1,x
	inc UpdateMetatileCount
	inc UpdateMetatileCount
	;Restore X register
	ldx $10
	;Set shot flag
	lda #$80
	sta Enemy_HP,x
	;Play sound
	ldy #SE_CRASH
	jsr LoadSound
	;Next task
	inc Enemy_Temp0,x
	;If not fully broken, exit early
	lda Enemy_Temp0,x
	cmp #$04
	bne Enemy76_Sub9
	;Set broken metatile props
	ldy UpdateMetatileCount
	lda UpdateMetatileProps-2,y
	ora #$C0
	sta UpdateMetatileProps-2,y
	lda UpdateMetatileProps-1,y
	ora #$C0
	sta UpdateMetatileProps-1,y
	;Init animation timer
	lda #$18
	sta Enemy_Temp4,x
;$09: Closed
Enemy76_Sub9:
	rts
;$04: Broken
Enemy76_Sub4:
	;Decrement animation timer, check if 0
	dec Enemy_Temp4,x
	bne Enemy76_Sub9
	;Next task ($05: Close part 1)
	inc Enemy_Temp0,x
	;Play sound
	ldy #SE_WHIRLONG
	jmp LoadSound
;$05: Close part 1
;$06: Close part 2
;$07: Close part 3
;$08: Close part 4
Enemy76_Sub5:
	;If there's a level scroll update, exit early
	lda ScrollUpdateFlag
	bne Enemy76_Sub9
	;If bits 0-1 of global timer not $03, exit early
	lda LevelGlobalTimer
	and #$03
	cmp #$03
	bne Enemy76_Sub9
	;Get VRAM address offset
	ldy Enemy_Temp0,x
	lda BGGlassPipeVRAMOffs-5,y
	sta $00
	;Get top part VRAM address
	ldy Enemy_Temp1,x
	lda BGGlassPipeTopVRAMAddrLo,y
	clc
	adc $00
	sta $08
	lda BGGlassPipeTopVRAMAddrHi,y
	adc #$00
	sta $10
	lda $08
	clc
	adc #$20
	sta $09
	lda $10
	adc #$00
	sta $11
	;Get bottom part VRAM address
	lda BGGlassPipeBottomVRAMAddrLo,y
	sec
	sbc $00
	sta $0A
	lda BGGlassPipeBottomVRAMAddrHi,y
	sbc #$00
	sta $12
	lda $0A
	sec
	sbc #$20
	sta $0B
	lda $12
	sbc #$00
	sta $13
	;Save X register
	stx $17
	;Init VRAM buffer row
	jsr WriteVRAMBufferCmd_InitRow
	;Set VRAM buffer address
	lda $08
	sta VRAMBuffer,x
	inx
	lda $10
	sta VRAMBuffer,x
	inx
	;Draw pipe shaft
	jsr BGGlassPipeDrawPipeShaft
	;End VRAM buffer
	jsr WriteVRAMBufferCmd_End
	;Init VRAM buffer row
	jsr WriteVRAMBufferCmd_InitRow
	;Set VRAM buffer address
	lda $09
	sta VRAMBuffer,x
	inx
	lda $11
	sta VRAMBuffer,x
	inx
	;Draw pipe end
	jsr BGGlassPipeDrawPipeEnd
	;End VRAM buffer
	jsr WriteVRAMBufferCmd_End
	;Init VRAM buffer row
	jsr WriteVRAMBufferCmd_InitRow
	;Set VRAM buffer address
	lda $0A
	sta VRAMBuffer,x
	inx
	lda $12
	sta VRAMBuffer,x
	inx
	;Draw pipe shaft
	jsr BGGlassPipeDrawPipeShaft
	;End VRAM buffer
	jsr WriteVRAMBufferCmd_End
	;Init VRAM buffer row
	jsr WriteVRAMBufferCmd_InitRow
	;Set VRAM buffer address
	lda $0B
	sta VRAMBuffer,x
	inx
	lda $13
	sta VRAMBuffer,x
	inx
	;Draw pipe end
	jsr BGGlassPipeDrawPipeEnd
	;End VRAM buffer
	jsr WriteVRAMBufferCmd_End
	;Draw collision
	jsr BGGlassPipeDrawCollision
	;Restore X register
	ldx $17
	;Next task
	inc Enemy_Temp0,x
	rts
BGGlassPipeDrawCollision:
	;Draw collision tile row bottom
	lda #$02
	sta $02
	ldx #$03
	jsr BGGlassPipeDrawCollision_Sub
	;Draw collision tile row top
	ldx #$01
BGGlassPipeDrawCollision_Sub:
	ldy $10,x
	lda $08,x
	sta $01
	lda #$04
	sta $00
	jmp DrawCollisionTileRow
BGGlassPipeDrawPipeShaft:
	;Set tiles in VRAM
	lda #$38
BGGlassPipeDrawPipeShaft_Any:
	sta VRAMBuffer,x
	inx
	clc
	adc #$01
	sta VRAMBuffer,x
	inx
	adc #$01
	sta VRAMBuffer,x
	inx
	adc #$01
	sta VRAMBuffer,x
	inx
	rts
BGGlassPipeDrawPipeEnd:
	;Set tiles in VRAM
	lda #$48
	bne BGGlassPipeDrawPipeShaft_Any
BGGlassPipeMetatileID:
	.db $49,$4A,$4B,$00
BGGlassPipeMetatilePos:
	.db $15,$17,$12,$1F
BGGlassPipeMetatileProps:
	.db $00,$01,$00,$01
BGGlassPipeTopVRAMAddrHi:
	.db $20,$24,$20,$25
BGGlassPipeTopVRAMAddrLo:
	.db $F4,$FC,$E8,$7C
BGGlassPipeBottomVRAMAddrHi:
	.db $22,$26,$22,$26
BGGlassPipeBottomVRAMAddrLo:
	.db $14,$1C,$08,$9C
BGGlassPipeVRAMOffs:
	.db $00,$20,$40,$60

;$77: Escape miniboss ship
Enemy77:
	;Check if already inited
	lda Enemy_Temp0,x
	bne Enemy77_Main
	;Check if BG animation is inited
	lda BGAnimMode
	beq Enemy77_InitExit
	;Mark inited
	inc Enemy_Temp0,x
	;Check for thruster part
	cpx #$01
	bne Enemy77_NoInitBack
	;Set enemy HP
	lda #$90
	sta Enemy_HP+$01
	;Save enemy HP
	sta Enemy_Temp2+$01
	;Set enemy collision size
	lda #$10
	sta Enemy_CollHeight+$01
	lda #$03
	sta Enemy_CollWidth+$01
	rts
Enemy77_NoInitBack:
	;Set enemy collision size
	lda #$0C
	sta Enemy_CollWidth,x
	sta Enemy_CollHeight,x
	;Save enemy HP
	lda #$20
	sta Enemy_Temp2,x
Enemy77_InitExit:
	rts
Enemy77_Main:
	;Check for hatches parts
	cpx #$06
	bcc Enemy77_NoHatch
	;Set enemy flags (hatches)
	lda #(EF_ACTIVE|EF_NOANIM|EF_VISIBLE)
	bne Enemy77_SetF
Enemy77_NoHatch:
	;Set enemy flags
	lda #(EF_ACTIVE|EF_NOANIM|EF_HITBULLET|EF_HITENEMY|EF_VISIBLE)
Enemy77_SetF:
	sta Enemy_Flags,x
	;Set enemy X position
	lda Level8MinibossShipXPos-1,x
	sec
	sbc TempIRQBufferScrollX+2
	sta Enemy_X,x
	bcc Enemy77_NoXC
	;Check if offscreen (right)
	lda TempIRQBufferScrollHi+2
	cmp #$20
	bne Enemy77_NoClearFX
	beq Enemy77_ClearF
Enemy77_NoXC:
	;Check if offscreen (left)
	lda TempIRQBufferScrollHi+2
	cmp #$20
	beq Enemy77_NoClearFX
Enemy77_ClearF:
	;Clear enemy hit flags
	lda #(EF_ACTIVE|EF_NOANIM)
	sta Enemy_Flags,x
Enemy77_NoClearFX:
	;Set enemy Y position
	lda Level8MinibossShipYPos-1,x
	clc
	adc TempIRQBufferHeight+2
	clc
	adc TempIRQBufferHeight+1
	clc
	adc TempIRQBufferHeight
	sec
	sbc TempIRQBufferScrollY+2
	sta Enemy_Y,x
	;If enemy Y position >= $A8, clear enemy hit flags
	cmp #$A8
	bcc Enemy77_NoClearFY
	;Clear enemy hit flags
	lda #(EF_ACTIVE|EF_NOANIM)
	sta Enemy_Flags,x
Enemy77_NoClearFY:
	;Check for thruster part
	cpx #$01
	beq Enemy77_Back
	jmp Enemy77_NoBack
Enemy77_Back:
	;Clear enemy hit flags
	lda #(EF_ACTIVE|EF_NOANIM)
	;If BG animation task not $0B, set enemy hit flags
	ldy BGAnimMode
	cpy #$0B
	bne Enemy77_NoBottomLeft
	;Set enemy hit flags
	lda #(EF_ACTIVE|EF_NOANIM|EF_HITBULLET|EF_HITENEMY|EF_VISIBLE)
Enemy77_NoBottomLeft:
	sta Enemy_Flags+$01
	;Check if enemy HP = saved HP
	lda Enemy_HP+$01
	cmp Enemy_Temp2+$01
	beq Enemy77_NoSetHP
	;If BG animation task not $08-$0B, don't flash palette
	lda BGAnimMode
	cmp #$08
	bcc Enemy77_BackNoFlash
	cmp #$0C
	bcs Enemy77_BackNoFlash
	;Save enemy HP
	lda Enemy_HP+$01
	sta Enemy_Temp2+$01
	;Load palette
	lda #$D4
	sta CurPalette
Enemy77_BackNoFlash:
	;Restore enemy HP
	lda Enemy_Temp2+$01
	sta Enemy_HP+$01
Enemy77_NoSetHP:
	;Check for shoot projectile task flag
	ldy BGAnimMode
	lda Level8MinibossShipTaskFlags,y
	and #$04
	beq Enemy77_Exit
	;If bits 0-4 of global timer not 0, exit early
	lda LevelGlobalTimer
	and #$1F
	bne Enemy77_Exit
	;If BG animation task < $10, exit early
	cpy #$10
	bcc Enemy77_NoSpawn
	;Spawn projectile
	ldy #$09
	lda #$6C
	sta $00
	lda #$0C
	sta $01
	lda #$3A
	jsr Enemy77_Spawn
	;Set enemy X velocity
	lda #$08
	sta Enemy_XVelHi+$09
Enemy77_Exit:
	rts
Enemy77_NoSpawn:
	;Get projectile offset data index
	lda LevelGlobalTimer
	and #$60
	lsr
	lsr
	lsr
	lsr
	lsr
	clc
	adc #$09
	tay
	;Get projectile offset
	lda #$20
	sta $00
	lda Level8MinibossShipYOffs-9,y
	sta $01
	;If free slot not available, exit early
	lda Enemy_Flags,y
	bne Enemy77_Exit
	;Check to shoot toward player
	lda Level8MinibossShipAnim-9,y
	bne Enemy77_Spawn
	;Shoot toward player
	jmp EnemyShootPlayerOnce_Offs
Enemy77_Spawn:
	;Spawn enemy
	jsr SpawnEnemy
	;Set enemy ID to enemy fire 2
	lda #ENEMY_ENEMYFIRE2
	sta Enemy_ID,y
	;Set enemy X velocity
	lda #$FC
	sta Enemy_XVelHi,y
	;Play sound
	ldy #SE_WHIRLASER1
	jmp LoadSound
Enemy77_NoBack:
	;If enemy HP = saved HP, don't flash palette
	lda Enemy_HP,x
	cmp Enemy_Temp2,x
	beq Enemy77_ShooterNoFlash
	;Save enemy HP
	sta Enemy_Temp2,x
	;Load palette
	lda #$D4
	sta CurPalette
Enemy77_ShooterNoFlash:
	;If enemy not visible, exit early
	lda Enemy_Flags,x
	and #EF_VISIBLE
	beq Enemy77_Exit
	;Get shooting timer value
	txa
	and #$03
	sta $00
	;If global timer != shooting timer value, exit early
	lda LevelGlobalTimer
	and #$7F
	lsr
	lsr
	lsr
	lsr
	lsr
	cmp $00
	bne Enemy77_Exit
	;Check for hatches parts
	cpx #$06
	bcc Enemy77_Shooter
	;Check for shoot trooper task flag
	ldy BGAnimMode
	lda Level8MinibossShipTaskFlags,y
	and #$02
	beq Enemy77_Exit
	;Set trooper offset
	lda #$00
	sta $00
	sta $01
	;Get trooper slot index
	txa
	clc
	adc #$03
	tay
	;If trooper still active, exit early
	lda Enemy_Flags,y
	bne Enemy77_Exit
	;Spawn enemy
	lda #$BB
	jsr SpawnEnemy
	;Set enemy ID to trooper escaping
	lda #ENEMY_TROOPERESCAPING
	sta Enemy_ID,y
	;Set jumping out of ship flag
	sta Enemy_Temp4,y
	;If hatch not open yet, draw hatch metatile
	lda Enemy_Temp3,x
	beq Enemy77_Draw
	rts
Enemy77_Draw:
	;Set hatch open flag
	lda #$01
	sta Enemy_Temp3,x
	;Get metatile position
	lda Level8MinibossShipMetatilePos-9,y
	sta $00
	;Draw metatile
	ldy UpdateMetatileCount
	lda #$41
	sta UpdateMetatileProps,y
	lda #$24
	sta UpdateMetatileID,y
	lda $00
	sta UpdateMetatilePos,y
	inc UpdateMetatileCount
	;Play sound
	ldy #SE_CRASH
	jmp LoadSound
Enemy77_Shooter:
	;Check for shoot projectile task flag
	ldy BGAnimMode
	lda Level8MinibossShipTaskFlags,y
	and #$01
	beq Enemy78

EnemyShootPlayerOnce:
	;Get projectile slot index
	txa
	clc
	adc #$07
	tay
	;Spawn enemy
	lda #$00
	sta $00
	sta $01
	;If projectile still active, exit early
	lda Enemy_Flags,y
	bne Enemy78
EnemyShootPlayerOnce_Offs:
	lda #$24
	jsr SpawnEnemy
	;Set enemy ID to enemy fire 2
	lda #ENEMY_ENEMYFIRE2
	sta Enemy_ID,y
	;Determine player relative position Y
	lda Enemy_Y
	sec
	sbc Enemy_Y,y
	sta $00
	bcc EnemyShootPlayerOnce_Up
	;Set enemy Y velocity down
	lda #$00
	beq EnemyShootPlayerOnce_SetY
EnemyShootPlayerOnce_Up:
	;Set enemy Y velocity up
	lda #$FF
EnemyShootPlayerOnce_SetY:
	sta $01
	;Determine player relative position X
	lda Enemy_X
	sec
	sbc Enemy_X,y
	sta $02
	bcc EnemyShootPlayerOnce_Left
	;Set enemy X velocity right
	lda #$00
	beq EnemyShootPlayerOnce_SetX
EnemyShootPlayerOnce_Left:
	;Set enemy X velocity left
	lda #$FF
EnemyShootPlayerOnce_SetX:
	sta $03
	;Shift enemy velocity left 2 bits
	asl $00
	rol $01
	asl $00
	rol $01
	asl $02
	rol $03
	asl $02
	rol $03
	;Set enemy velocity
	lda $00
	sta Enemy_YVelLo,y
	lda $01
	sta Enemy_YVelHi,y
	lda $02
	sta Enemy_XVelLo,y
	lda $03
	clc
	adc #$02
	sta Enemy_XVelHi,y

;$78: Enemy fire 2
Enemy78:
	;Do nothing
	rts

Level8MinibossShipXPos:
	.db $92,$2A,$4A,$6A,$8A,$10,$50,$90
Level8MinibossShipYPos:
	.db $72,$5A,$5A,$5A,$5A,$28,$28,$28
Level8MinibossShipMetatilePos:
	.db $08,$0A,$0C
Level8MinibossShipYOffs:
	.db $EC,$E4,$D4,$CC
Level8MinibossShipAnim:
	.db $3A,$00,$3A,$00
Level8MinibossShipTaskFlags:
	.db $00,$00,$00,$02,$01,$01,$01,$00,$04,$04,$04,$04,$01,$01,$01,$01
	.db $01,$05,$04,$04,$01,$02,$00,$00,$00,$00

;;;;;;;;;;;;;;;;;;;;
;SCROLLING ROUTINES;
;;;;;;;;;;;;;;;;;;;;
;$78: Level 8 miniboss snake
ScrollAnimF8:
	;Update level 8 miniboss flashing palette
	jsr CHRBankAnimEX
	;If miniboss snake already ended, exit early
	lda BGMinibossSnakeEndFlag
	bne Enemy78
	;If miniboss snake not active, don't loop current screen
	lda Enemy_Flags+$01
	beq ScrollAnimF8_NoLoop
	;If current screen $3A, set current screen $38
	lda CurScreen
	cmp #$3A
	bne ScrollAnimF8_NoLoop
	;Set current screen $38
	lda #$38
	sta CurScreen
ScrollAnimF8_NoLoop:
	;If current screen $3C, load IRQ buffer set
	lda CurScreen
	cmp #$3C
	bne ScrollAnimF8_NoClear
	;Load IRQ buffer set
	ldx #$00
	jsr LoadIRQBufferSet
	;Set miniboss snake ended flag
	inc BGMinibossSnakeEndFlag
	rts
ScrollAnimF8_NoClear:
	;Move enemies
	jsr BGMinibossSnakeMoveEnemies
	;Set scroll position to master PPU scroll
	ldx #$01
	jsr ScrollAnimGetPPUXPos
	;Set scroll position to master PPU scroll
	ldx #$03
	jsr ScrollAnimGetPPUXPos
	;Do jump table
	lda BGAnimMode
	jsr DoJumpTable
ScrollAnimF8JumpTable:
	.dw ScrollAnimF8_Sub0	;$00  Init
	.dw ScrollAnimF8_Sub1	;$01  In part 1
	.dw ScrollAnimF8_Sub2	;$02  In part 2
	.dw ScrollAnimF8_Sub3	;$03  Left
	.dw ScrollAnimF8_Sub4	;$04  Right
;$00: Init
ScrollAnimF8_Sub0:
	;If current screen not $37, exit early
	lda CurScreen
	cmp #$37
	bne ScrollAnimF8_Sub1_Exit
	;Next task ($01: In part 1)
	inc BGAnimMode
	;Set IRQ buffer collision flag
	lda #$01
	sta IRQBufferCollisionFlag
	;Load IRQ buffer set
	ldx #$30
	jmp LoadIRQBufferSet
;$01: In part 1
ScrollAnimF8_Sub1:
	;If current screen not $38, exit early
	lda CurScreen
	cmp #$38
	bne ScrollAnimF8_Sub1_Exit
	;Next task ($02: In part 2)
	inc BGAnimMode
ScrollAnimF8_Sub1_Exit:
	rts
;$02: In part 2
ScrollAnimF8_Sub2:
	;Move platforms left $01
	inc TempIRQBufferScrollX
	inc TempIRQBufferScrollX+2
	;If top platform scroll X position $60, go to next task ($03: Left)
	lda TempIRQBufferScrollX+2
	cmp #$C0
	beq ScrollAnimF8_Sub2_Next
	;If top platform scroll X position not $64, exit early
	cmp #$64
	bne ScrollAnimF8_Sub1_Exit
	;Init snake parts
	ldy #$07
ScrollAnimF8_Sub2_Loop:
	;Set enemy flags
	lda #(EF_ACTIVE|EF_INVINCIBLE|EF_NOANIM|EF_HITBULLET|EF_HITENEMY|EF_VISIBLE)
	sta Enemy_Flags,y
	;Next task ($01: Both platforms)
	lda #$01
	sta Enemy_Temp0,y
	;Loop for each part
	dey
	bne ScrollAnimF8_Sub2_Loop
	;Set enemy flags
	lda #(EF_ACTIVE|EF_NOANIM|EF_HITBULLET|EF_VISIBLE)
	sta Enemy_Flags+$08
	sta Enemy_Flags+$09
	rts
ScrollAnimF8_Sub2_Next:
	;Next task ($03: Left)
	inc BGAnimMode
ScrollAnimF8_Sub2_Exit:
	rts
;$03: Left
ScrollAnimF8_Sub3:
	;Check platforms
	jsr BGMinibossSnakeCheckTop
	;Move top platform left and bottom platform right
	dec TempIRQBufferScrollX+2
	inc TempIRQBufferScrollX
	;If not all the way left, exit early
	bne ScrollAnimF8_Sub2_Exit
	;Next task ($04: Right)
	inc BGAnimMode
;$04: Right
ScrollAnimF8_Sub4:
	;Check platforms
	jsr BGMinibossSnakeCheckTop
	;Move top platform right and bottom platform left
	dec TempIRQBufferScrollX
	inc TempIRQBufferScrollX+2
	;If not all the way left, exit early
	bne ScrollAnimF8_Sub2_Exit
	;Next task ($03: Left)
	dec BGAnimMode
	bne ScrollAnimF8_Sub3
BGMinibossSnakeCheckTop:
	;Check bottom platform
	jsr BGMinibossSnakeCheckBottom
	;If top platform active, exit early
	lda Enemy_Flags+$08
	bne BGMinibossSnakeCheckBottom_Exit
	;If using left nametable, exit early
	lda #$20
	cmp TempIRQBufferScrollHi
	beq BGMinibossSnakeCheckBottom_Exit
	;Set nametable
	sta TempIRQBufferScrollHi
	;Next task
	inc Enemy_Temp0+$01
	;Explode top snake parts
	ldx #$02
BGMinibossSnakeCheckTop_Loop:
	;Explode snake part
	jsr BGMinibossSnakeSetExplosion
	;Loop for each part
	cpx #$05
	bne BGMinibossSnakeCheckTop_Loop
	rts
BGMinibossSnakeCheckBottom:
	;If top platform active, exit early
	lda Enemy_Flags+$09
	bne BGMinibossSnakeCheckBottom_Exit
	;If using left nametable, exit early
	lda #$20
	cmp TempIRQBufferScrollHi+2
	beq BGMinibossSnakeCheckBottom_Exit
	;Set nametable
	sta TempIRQBufferScrollHi+2
	;Next task
	inc Enemy_Temp0+$01
	;Explode bottom snake parts
	ldx #$05
BGMinibossSnakeCheckBottom_Loop:
	;Explode snake part
	jsr BGMinibossSnakeSetExplosion
	;Loop for each part
	cpx #$08
	bne BGMinibossSnakeCheckBottom_Loop
BGMinibossSnakeCheckBottom_Exit:
	rts
BGMinibossSnakeSetExplosion:
	;Set enemy animation
	ldy #$E4
	jsr SetEnemyAnimation
	;Set enemy lifetime
	lda #$90
	sta Enemy_Temp5,x
	inx
BGMinibossSnakeSetExplosion_Exit:
	rts
BGMinibossSnakeMoveEnemies:
	;If miniboss snake in spinning mode, exit early
	lda Enemy_Temp0+$01
	cmp #$03
	bcs BGMinibossSnakeSetExplosion_Exit
	;Set enemy X position
	lda #$60
	sec
	sbc TempIRQBufferScrollX
	sta Enemy_X+$02
	lda #$60
	sec
	sbc TempIRQBufferScrollX+2
	sta Enemy_X+$07
	;Check if moving left or right
	cmp Enemy_X+$02
	bcs BGMinibossSnakeMoveEnemies_Right
	;Get enemy X position offset
	lda Enemy_X+$02
	sec
	sbc Enemy_X+$07
	jsr BGMinibossSnakeGetEnemyXOffs
	;Set enemy X position
	clc
	lda Enemy_X+$07
	adc $01
	sta Enemy_X+$06
	lda Enemy_X+$07
	adc $00
	sta Enemy_X+$05
	lda Enemy_X+$07
	adc $08
	sta Enemy_X+$01
	sec
	lda Enemy_X+$02
	sbc $01
	sta Enemy_X+$03
	lda Enemy_X+$02
	sbc $00
	sta Enemy_X+$04
	jmp BGMinibossSnakeMoveEnemies_TB
BGMinibossSnakeMoveEnemies_Right:
	;Get enemy X position offset
	sec
	sbc Enemy_X+$02
	jsr BGMinibossSnakeGetEnemyXOffs
	;Set enemy X position
	clc
	lda Enemy_X+$02
	adc $01
	sta Enemy_X+$03
	lda Enemy_X+$02
	adc $00
	sta Enemy_X+$04
	lda Enemy_X+$02
	adc $08
	sta Enemy_X+$01
	sec
	lda Enemy_X+$07
	sbc $01
	sta Enemy_X+$06
	lda Enemy_X+$07
	sbc $00
	sta Enemy_X+$05
BGMinibossSnakeMoveEnemies_TB:
	;Set enemy X position
	lda Enemy_X+$02
	sec
	sbc #$30
	sta Enemy_X+$08
	lda Enemy_X+$07
	sec
	sbc #$30
	sta Enemy_X+$09
	rts
BGMinibossSnakeGetEnemyXOffs:
	;Shift X distance right 1 bit
	lsr
	sta $08
	;Shift X distance right 4 bits and multiply by 5
	lsr
	sta $00
	lsr
	lsr
	clc
	adc $00
	sta $00
	;Shift X distance right 5 bits and multiply by 5
	lsr
	sta $01
BGMinibossSnakeGetEnemyXOffs_Exit:
	rts

;;;;;;;;;;;;;;;;
;ENEMY ROUTINES;
;;;;;;;;;;;;;;;;
;$81: Escape miniboss snake
Enemy81:
	;Check if already inited
	lda Enemy_Temp0,x
	bne Enemy81_Main
	;Set enemy X velocity
	lda #$02
	sta Enemy_XVelHi,x
Enemy81_Main:
	;Check for snake head
	cpx #$01
	beq Enemy81_DoSub
	;If platform, exit early
	cpx #$08
	bcc BGMinibossSnakeGetEnemyXOffs_Exit
	;Check if already inited
	lda Enemy_Temp0,x
	bne Enemy81_Main2
	;Set enemy animation
	ldy #$A8
	jsr SetEnemyAnimation
	;Mark inited
	inc Enemy_Temp0,x
	;Set enemy HP
	lda #$80
	sta Enemy_HP,x
	;Set enemy max HP
	sta Enemy_Temp2,x
	;Set enemy collision size
	lda #$0C
	sta Enemy_CollWidth,x
	sta Enemy_CollHeight,x
	rts
Enemy81_Main2:
	;If enemy HP equals == max HP, exit early
	lda Enemy_HP,x
	cmp Enemy_Temp2,x
	beq BGMinibossSnakeGetEnemyXOffs_Exit
	;Set enemy max HP
	sta Enemy_Temp2,x
	;Load palette
	lda #$D4
	sta CurPalette
	rts
Enemy81_DoSub:
	;Load PRG bank $36 (level 6 miniboss snake subroutine bank)
	ldy #$36
	jsr LoadPRGBank
	;Level 8 miniboss snake subroutine
	jsr Enemy81Sub
	;Restore PRG bank
	jsr RestorePRGBank
	rts

FindFreeEnemySlot:
	;Save A/X registers
	stx $10
	sta $14
	;Check for free slots
	ldy #$08
FindFreeEnemySlot_Loop:
	;If free slot available, spawn enemy
	lda Enemy_Flags,y
	beq SpawnEnemy_AnyX
	;Loop for each slot
	iny
	cpy #$0D
	bne FindFreeEnemySlot_Loop
	;Clear carry flag
	clc
	rts

SpawnEnemy:
	;Save A/X registers
	stx $10
	sta $14
SpawnEnemy_AnyX:
	;Offset enemy X position
	tya
	tax
	ldy $10
	lda Enemy_X,y
	clc
	adc $00
	;Check if to left or right
	lda $00
	bmi SpawnEnemy_Left
	;Check if offscreen (right)
	bcs SpawnEnemy_NoSpawn
	bcc SpawnEnemy_Spawn
SpawnEnemy_Left:
	;Check if offscreen (left)
	bcc SpawnEnemy_NoSpawn
SpawnEnemy_Spawn:
	;Set enemy X position
	lda Enemy_X,y
	clc
	adc $00
	sta Enemy_X,x
	;Set enemy Y position
	lda Enemy_Y,y
	clc
	adc $01
	sta Enemy_Y,x
	;Set enemy ID to enemy fire
	lda #ENEMY_ENEMYFIRE
	sta Enemy_ID,x
	;Set enemy HP
	lda #$01
	sta Enemy_HP,x
	;Set enemy animation
	ldy $14
	jsr SetEnemyAnimation
	;Clear enemy
	jsr ClearEnemy_L
	;Get spawned enemy slot index
	txa
	tay
	;Restore X register
	ldx $10
	;Set carry flag
	sec
	rts
SpawnEnemy_NoSpawn:
	;Get spawned enemy slot index
	txa
	tay
	;Restore X register
	ldx $10
	;Clear carry flag
	clc
	rts

;$82: Level 8 boss
Enemy82:
	;Load PRG bank $34 (level 8 boss subroutine bank)
	ldy #$34
	jsr LoadPRGBank
	;Level 8 boss subroutine
	jsr Enemy82Sub
	;Restore PRG bank
	jsr RestorePRGBank
Enemy82_Exit:
	rts

;$83: Level 8 boss bomb
Enemy83:
	;If enemy Y position < $90, exit early
	lda Enemy_Y+$03
	cmp #$90
	bcc Enemy82_Exit
	;Clear enemy flags
	lda #$00
	sta Enemy_Flags+$03
	;Spawn shrapnel
	ldy #$04
Enemy83_Loop:
	;Spawn enemy
	lda #$00
	sta $00
	sta $01
	lda #$24
	jsr SpawnEnemy
	;Set enemy ID to enemy fire 2
	lda #ENEMY_ENEMYFIRE2
	sta Enemy_ID,y
	;Set enemy velocity based on slot index
	lda Level8BossBombXVelHi-4,y
	sta Enemy_XVelHi,y
	lda Level8BossBombXVelLo-4,y
	sta Enemy_XVelLo,y
	lda Level8BossBombYVelHi-4,y
	sta Enemy_YVelHi,y
	lda Level8BossBombYVelLo-4,y
	sta Enemy_YVelLo,y
	;Loop for each shrapnel
	iny
	cpy #$0B
	bne Enemy83_Loop
	;Play sound
	ldy #SE_CRASH
	jmp LoadSound
Level8BossBombXVelHi:
	.db $05,$04,$04,$03,$02,$01,$01
Level8BossBombXVelLo:
	.db $00,$BC,$00,$00,$00,$44
Level8BossBombYVelHi:
	.db $00,$FF,$FE,$FE,$FE,$FF
Level8BossBombYVelLo:
	.db $00,$00,$44,$00,$44,$00,$00

;;;;;;;;;;;;;;;;;;;;
;GAME MODE ROUTINES;
;;;;;;;;;;;;;;;;;;;;
;TITLE MODE ROUTINES
RunGameSubmode_TitlePassword:
	;Load PRG bank $34 (title password subroutine bank)
	ldy #$34
	jsr LoadPRGBank
	;Title password subroutine
	jsr RunGameSubmode_TitlePasswordSub
	;Restore PRG bank
	jsr RestorePRGBank
	rts

;READY MODE ROUTINES
RunGameMode_ReadySub:
	;Do jump table
	lda GameSubmode
	jsr DoJumpTable
ReadySubJumpTable:
	.dw RunGameSubmode_ReadyInit	;$00  Init
	.dw RunGameSubmode_ReadyScroll	;$01  Scroll text
	.dw RunGameSubmode_ReadyWait	;$02  Wait
	.dw RunGameSubmode_ReadyEnd	;$03  End
;$00: Init
RunGameSubmode_ReadyInit:
	;Set level area number
	jsr SetLevelAreaNum
	;Check for level 4 vertical scrolling area
	cmp #$34
	beq RunGameSubmode_ReadyInit_Level4Vert
	;Check for level 2 vertical scrolling area
	cmp #$15
	bne RunGameSubmode_ReadyInit_NoSetArea
	;Set area to before level 2 vertical scrolling area
	lda #$20
	bne RunGameSubmode_ReadyInit_SetArea
RunGameSubmode_ReadyInit_Level4Vert:
	;Set area to before level 4 vertical scrolling area
	lda #$18
RunGameSubmode_ReadyInit_SetArea:
	sta CurArea
RunGameSubmode_ReadyInit_NoSetArea:
	;Next submode ($01: Scroll text)
	inc GameSubmode
	;Load ready CHR bank set
	ldx #$3E
	jsr LoadCHRBankSet
	;Set scroll position
	lda #$89
	sta TempMirror_PPUCTRL
	lda #$70
	sta TempMirror_PPUSCROLL_Y
	lda #$80
	sta TempMirror_PPUSCROLL_X
	;Clear nametable
	jsr ClearNametableData
	;Write level name VRAM strip
	lda CurLevel
	clc
	adc #$0B
	jsr WriteVRAMStrip
	;Write ready palette
	lda #$13
	jsr WritePaletteStrip8
	;Set enemy X position
	lda #$E8
	sta Enemy_X+$01
	lda #$08
	sta Enemy_X+$02
	lda #$10
	sta Enemy_X
	;Set enemy Y position
	lda #$E7
	sta Enemy_Y
	lda #$00
	sta Enemy_Y+$01
	sta Enemy_Y+$02
	;Set enemies props/tile offset
	ldx #$02
RunGameSubmode_ReadyInit_Loop:
	;Set enemy props
	sta Enemy_Props,x
	;Clear enemy tile offset
	sta Enemy_Temp7,x
	;Loop for each enemy
	dex
	bpl RunGameSubmode_ReadyInit_Loop
	;Set enemy animation
	tax
	ldy #$2E
	jsr SetEnemyAnimation
	inx
	ldy #$2C
	jsr SetEnemyAnimation
	inx
	ldy #$2E
	jsr SetEnemyAnimation
	;Set enemy sprite
	ldy CurLevel
	lda LevelNameSpriteTable,y
	sta Enemy_SpriteLo
	;Check for bit 0 set
	lda LevelAreaNum
	lsr
	tay
	lda LevelActNumberTable,y
	bcs RunGameSubmode_ReadyInit_Area1
	;Set enemy sprite
	and #$F0
	lsr
	lsr
	lsr
	sta Enemy_SpriteLo+$02
	rts
RunGameSubmode_ReadyInit_Area1:
	;Set enemy sprite
	and #$0F
	asl
	sta Enemy_SpriteLo+$02
	rts
;$01: Scroll text
RunGameSubmode_ReadyScroll:
	;Set enemy animation timer
	lda #$FE
	sta Enemy_AnimTimer+$02
	;Move enemies $02
	lda #$02
	sta $0C
RunGameSubmode_ReadyScroll_Loop:
	;Move enemies
	inc Enemy_X
	dec Enemy_Y
	dec Enemy_X+$01
	inc Enemy_Y+$01
	inc Enemy_X+$02
	inc Enemy_Y+$02
	;Update scroll position
	inc TempMirror_PPUSCROLL_X
	inc TempMirror_PPUSCROLL_Y
	;Loop $02
	dec $0C
	bne RunGameSubmode_ReadyScroll_Loop
	;If scroll Y position not $F0, exit early
	lda TempMirror_PPUSCROLL_Y
	cmp #$F0
	bne RunGameSubmode_ReadyScroll_Exit
	;Clear scroll position
	lda #$00
	sta TempMirror_PPUSCROLL_Y
	lda #$88
	sta TempMirror_PPUCTRL
	;Next submode ($02: Wait)
	inc GameSubmode
	;Set timer
	lda #$40
	sta ReadyTimer
RunGameSubmode_ReadyScroll_Exit:
	rts
;$02: Wait
RunGameSubmode_ReadyWait:
	;Decrement timer, check if 0
	dec ReadyTimer
	bne RunGameSubmode_ReadyScroll_Exit
	;Next submode ($03: End)
	inc GameSubmode
	;Clear scroll position
	lda #$A8
	sta TempMirror_PPUCTRL
	;Set black screen timer
	lda #$03
	sta BlackScreenTimer
	rts
;$03: End
RunGameSubmode_ReadyEnd:
	;Clear sound
	jsr ClearSound
	;If boss enemy slot index set, don't load music
	lda BossEnemyIndex
	bne RunGameSubmode_ReadyEnd_NoMusic
	;Play music
	ldx CurLevel
	ldy LevelMusicTable,x
	jsr LoadSound
RunGameSubmode_ReadyEnd_NoMusic:
	;Set level data pointers
	ldx CurLevel
	jsr SetLevelDataPointers
	;Clear IRQ enable flag
	lda #$00
	sta TempIRQEnableFlag
	sta IRQEnableFlag
	;Clear level 5 exit values
	sta Level5ExitElevator
	sta Level5ExitArea
	;Load player CHR bank
	lda #$50
	sta TempCHRBanks+2
	lda #$56
	sta TempCHRBanks+3
	;Check for level 5
	lda CurLevel
	cmp #$04
	bne RunGameSubmode_ReadyEnd_NoLevel5
	;Set level load mode for level 5
	lda Level5ExitMode
	ora #$80
	bne RunGameSubmode_ReadyEnd_SetMode
RunGameSubmode_ReadyEnd_NoLevel5:
	;Set level load mode
	lda #$80
RunGameSubmode_ReadyEnd_SetMode:
	sta LevelLoadMode
	;Next mode ($05: Gameplay)
	jmp GoToNextGameMode
LevelNameSpriteTable:
	.db $88,$88,$88,$88,$44,$46,$CE,$D0
LevelMusicTable:
	.db MUSIC_LEVEL1
	.db MUSIC_LEVEL2
	.db MUSIC_LEVEL3
	.db MUSIC_LEVEL4
	.db MUSIC_LEVEL5
	.db MUSIC_LEVEL6
	.db MUSIC_LEVEL7
	.db MUSIC_LEVEL8
LevelActNumberTable:
	.db $01,$23,$45,$00,$00,$00,$00,$00
	.db $01,$23,$44,$56,$70,$00,$00,$00
	.db $01,$23,$45,$67,$89,$00,$00,$00
	.db $01,$23,$34,$56,$00,$00,$00,$00
	.db $00,$00,$22,$22,$40,$00,$51,$36
	.db $01,$23,$45,$67,$89,$00,$00,$00
	.db $01,$23,$45,$67,$89,$AB,$CD,$E0
	.db $01,$23,$45,$60

;;;;;;;;;;;;;;;;;
;SYSTEM ROUTINES;
;;;;;;;;;;;;;;;;;
Reset:
	;Setup CPU
	cld
	sei
	ldx #$FF
	txs
	;Setup PPU
	lda #$00
	sta PPU_CTRL
	sta PPU_MASK
Reset_WaitVBlank1:
	lda PPU_STATUS
	bpl Reset_WaitVBlank1
Reset_WaitVBlank2:
	lda PPU_STATUS
	bpl Reset_WaitVBlank2
	;Clear ZP
	lda #$00
	sta $00
	sta $01
	ldy #$F9
Reset_ClearZP:
	dey
	sta ($00),y
	bne Reset_ClearZP
	;Clear WRAM
	inc $01
	ldy #$03
	ldx #$08
Reset_ClearWRAM:
	sta ($00),y
	iny
	bne Reset_ClearWRAM
	inc $01
	cpx $01
	bne Reset_ClearWRAM
	;Process game init tasks
	jsr InitMMC3
	jsr DisableVideoOut
	jsr InitAPU
	jsr EnableVideoOut
	jsr ClearSound
	;Disable IRQ
	sta $E000
	cli
Reset_InfiniteLoop:
	;Loop infinitely
	jmp Reset_InfiniteLoop

NMI:
	;Save A/X/Y registers
	pha
	txa
	pha
	tya
	pha
	;Clear IRQ wait flag
	lda #$00
	sta IRQWaitFlag
	;Clear bank switch mutex
	sta BankSwitchMutex
	;If NMI mutex set, wait until next frame to process game logic tasks
	lda NMIMutex
	bne NMI_Wait
	;Set NMI mutex
	inc NMIMutex
	;Disable video output
	jsr DisableVideoOut
	;Write OAM buffer data
	lda #$00
	sta OAM_ADDR
	lda #>OAMBuffer
	sta OAM_DMA
	;Write VRAM buffer data
	jsr WriteVRAMBuffer
	;If black screen timer not 0, hide sprites/background
	lda Mirror_PPUMASK
	ldx BlackScreenTimer
	beq NMI_NoBlack
	;Decrement black screen timer
	dec BlackScreenTimer
	;Hide sprites/background
	and #$E7
NMI_NoBlack:
	sta PPU_MASK
	;Process game logic tasks
	jsr SetScroll
	jsr InitIRQBuffer
	jsr LoadCHRBank
	jsr ReadInput
	jsr UpdateBlackScreen
	jsr UpdateSound
	jsr RunGameMode
	jsr UpdateEnemyAnimationCheck
	;End VRAM buffer
	jsr WriteVRAMBufferCmd_EndAll
	;If IRQ enabled, decode IRQ buffer
	lda IRQEnableFlag
	beq NMI_IRQDecode
	;If black screen timer $01, decode IRQ buffer
	lda BlackScreenTimer
	cmp #$01
	beq NMI_IRQDecode
NMI_IRQWait:
	;Wait for IRQ
	lda IRQWaitFlag
	beq NMI_IRQWait
NMI_IRQDecode:
	;Decode IRQ buffer
	jsr DecodeIRQBuffer
NMI_Exit:
	;Clear NMI mutex
	lda #$00
	sta NMIMutex
	;Restore A/X/Y registers
	pla
	tay
	pla
	tax
	pla
	rti
NMI_Wait:
	;Save last bank switch
	lda TempLastBankSwitch
	sta LastBankSwitch
	;Save bank switch mutex
	lda TempBankSwitchMutex
	sta BankSwitchMutex
	;Check IRQ buffer mutex
	lda IRQBufferMutex
	beq NMI_NoIRQDecode
	;Process game logic tasks
	jsr SetScroll
	jsr DecodeIRQBuffer
	jmp NMI_WaitTasks
NMI_NoIRQDecode:
	;Latch PPU status line
	lda PPU_STATUS
	;Set PPU scroll
	lda Mirror_PPUSCROLL_X
	sta PPU_SCROLL
	lda Mirror_PPUSCROLL_Y
	sta PPU_SCROLL
	lda Mirror_PPUCTRL
	sta PPU_CTRL
NMI_WaitTasks:
	;Process game logic tasks
	jsr InitIRQBuffer
	jsr LoadCHRBank
	jsr UpdateBlackScreen
	jsr UpdateSound
	;Restore bank switch mode
	lda LastBankSwitch
	sta $8000
	jmp NMI_Exit

SetScroll:
	;Clear latch
	lda PPU_STATUS
	;Set scroll X
	lda TempMirror_PPUSCROLL_X
	sta Mirror_PPUSCROLL_X
	sta PPU_SCROLL
	;Set scroll Y
	lda TempMirror_PPUSCROLL_Y
	sta Mirror_PPUSCROLL_Y
	sta PPU_SCROLL
SetScroll_EnNMI:
	;Enable NMI
	lda TempMirror_PPUCTRL
	ora #$80
	sta Mirror_PPUCTRL
	sta TempMirror_PPUCTRL
	sta PPU_CTRL
SetScroll_Exit:
	rts

UpdateBlackScreen:
	;If black screen timer not 0, exit early
	ldx BlackScreenTimer
	bne SetScroll_Exit
	;Setup loop counter
	ldx #$80
	ldy #$00
UpdateBlackScreen_Loop:
	;Wait for sprite 0 hit
	lda PPU_STATUS
	and #$40
	beq SetScroll_Exit
	;Wait for $8000 loops before bailing
	iny
	bne UpdateBlackScreen_Loop
	inx
	bne UpdateBlackScreen_Loop
	rts

DisableNMI:
	;Disable NMI
	lda TempMirror_PPUCTRL
	and #$7F
	sta TempMirror_PPUCTRL
	sta PPU_CTRL
	rts

InitAPU:
	;Init APU registers
	lda #$0F
	sta SND_CHN
	lda #$C0
	sta JOY2
	rts

EnableVideoOut:
	;Enable video output
	lda #$A8
	sta TempMirror_PPUCTRL
	sta PPU_CTRL
	lda #$18
	sta Mirror_PPUMASK
	lda #$05
	sta BlackScreenTimer
	rts

DisableVideoOut:
	;Disable video output
	jsr DisableNMI
	lda PPU_STATUS
	lda #$00
	sta PPU_ADDR
	sta PPU_ADDR
	lda Mirror_PPUMASK
	and #$E7
	sta PPU_MASK
	rts

UpdateSound:
	;Check mutexes
	lda SoundMutex
	ora BankSwitchMutex
	ora TempBankSwitchMutex
	bne ClearSound_Exit
	;Set sound mutex
	lda #$01
	sta SoundMutex
	;Load PRG bank $3C (sound engine bank)
	ldy #$3C
	jsr LoadPRGBank
	;Update sound
	jsr UpdateSoundSub
	;Restore PRG bank
	jsr RestorePRGBank
	;Clear sound mutex
	lda #$00
	sta SoundMutex
	rts

ClearSound:
	;If sound loading disabled, exit early
	lda DisableSoundLoadFlag
	bne ClearSound_Exit
	;Set sound mutex
	lda #$01
	sta SoundMutex
	;Save X register
	txa
	pha
	;Load PRG bank $3C (sound engine bank)
	ldy #$3C
	jsr LoadPRGBank
	;Clear sound
	jsr ClearSoundSub
	;Restore PRG bank
	jsr RestorePRGBank
	;Restore X register
	pla
	tax
	;Clear sound mutex
	lda #$00
	sta SoundMutex
ClearSound_Exit:
	rts

LoadSound:
	;If sound loading disabled, exit early
	lda DisableSoundLoadFlag
	bne ClearSound_Exit
	;Set sound mutex
	lda #$01
	sta SoundMutex
	;Save X register
	txa
	pha
	;Transfer Y to X register
	tya
	tax
	;Load PRG bank $3C (sound engine bank)
	ldy #$3C
	jsr LoadPRGBank
	;Update sound
	txa
	jsr LoadSoundSub
	;Restore PRG bank
	jsr RestorePRGBank
	;Restore X register
	pla
	tax
	;Clear sound mutex
	lda #$00
	sta SoundMutex
	rts

ReadInput:
	;Read input
	jsr ReadInputSub
	;Save input value
	lda $00
	sta $01
	;Read input again
	jsr ReadInputSub
	;If input mismatch, branch to exit
	lda $00
	cmp $01
	bne ReadInput_Diff
	;Get buttons pressed this frame and exit
	ldy $00
	tya
	eor JoypadCur
	and $00
	sta JoypadDown
	sty JoypadCur
	rts
ReadInput_Diff:
	;Input mismatch (DMC hardware bug workaround)
	lda #$00
	sta JoypadDown
	rts

ReadInputSub:
	;Strobe input register
	lda #$01
	sta JOY1
	lda #$00
	sta JOY1
	ldy #$08
ReadInputSub_BitLoop:
	;Get input bit and shift into result
	lda JOY1
	sta $02
	lsr
	ora $02
	lsr
	rol $00
	;Loop for all 8 bits
	dey
	bne ReadInputSub_BitLoop
	rts

LoadCHRBank:
	;Set bank switch mutex
	lda #$01
	sta TempBankSwitchMutex
	;Set CHR banks
	ldy #$05
LoadCHRBank_Loop:
	;Set CHR bank
	lda CHRBanks,y
	sty TempLastBankSwitch
	sty $8000
	sta $8001
	;Loop for each bank
	dey
	bpl LoadCHRBank_Loop
	;Clear PRG bank mutex
	lda #$00
	sta TempBankSwitchMutex
	rts

LoadPRGBank:
	;Check bank switch mutex
	lda TempBankSwitchMutex
	bne LoadPRGBank_Exit
	;Set bank switch mutex
	lda #$01
	sta TempBankSwitchMutex
	;Get return address
	pla
	sta BankSwitchReturnAddr
	pla
	sta BankSwitchReturnAddr+1
	;Save PRG bank number
	lda $8000
	pha
	;Save return address
	lda BankSwitchReturnAddr+1
	pha
	lda BankSwitchReturnAddr
	pha
	;Set PRG bank
	lda #$06
	sta TempLastBankSwitch
	sta $8000
	sty $8001
	iny
	lda #$07
	sta TempLastBankSwitch
	sta $8000
	sty $8001
	;Clear bank switch mutex
	lda #$00
	sta TempBankSwitchMutex
LoadPRGBank_Exit:
	rts

RestorePRGBank:
	;Check bank switch mutex
	lda TempBankSwitchMutex
	bne LoadPRGBank_Exit
	;Set bank switch mutex
	lda #$01
	sta TempBankSwitchMutex
	;Restore return address
	pla
	sta BankSwitchReturnAddr
	pla
	sta BankSwitchReturnAddr+1
	;Restore PRG bank number
	pla
	tay
	;Set PRG bank
	lda #$06
	sta TempLastBankSwitch
	sta $8000
	sty $8001
	iny
	lda #$07
	sta TempLastBankSwitch
	sta $8000
	sty $8001
	;Set return address
	lda BankSwitchReturnAddr+1
	pha
	lda BankSwitchReturnAddr
	pha
	;Clear bank switch mutex
	lda #$00
	sta TempBankSwitchMutex
	rts

LoadCHRBankSet:
	;Load PRG bank $38 (CHR bank set data bank)
	ldy #$38
	jsr LoadPRGBank
	;Get CHR bank set pointer
	lda CHRBankSetPointerTable,x
	sta $08
	lda CHRBankSetPointerTable+1,x
	sta $09
	;Set CHR banks
	ldy #$00
	lda ($08),y
	sta TempCHRBanks
	iny
	lda ($08),y
	sta TempCHRBanks+1
	iny
	lda ($08),y
	sta TempCHRBanks+4
	iny
	lda ($08),y
	sta TempCHRBanks+5
	;Restore PRG bank
	jsr RestorePRGBank
	rts

InitMMC3:
	;Set sprite 0 Y position in OAM buffer (disable sprite 0 hit)
	lda #$F4
	sta OAMBuffer
	;Init some states
	lda #$00
	sta TempLastBankSwitch
	sta TempMirror_PPUSCROLL_X
	sta TempMirror_PPUSCROLL_Y
	sta DemoEndAllFlag
	sta BossEnemyIndex
	;Set default PRG bank
	ldy #$06
	sty $8000
	lda #$30
	sta $8001
	iny
	sty $8000
	lda #$31
	sta $8001
	;Set vertical mirroring
	lda #$00
	sta $A000
	;Init some states
	lda #>CollisionBuffer
	sta CollBufferPointer+1
	lda #$E2
	sta PRNGDataPointer+1
	;Load PRG bank $38 (clear hard mode subroutine bank)
	ldy #$38
	jsr LoadPRGBank
	;Do copy protection check
	jsr CopyProtectCheck
	;Restore PRG bank
	jsr RestorePRGBank
	rts

;;;;;;;;;;
;DMC DATA;
;;;;;;;;;;
DMCInstrumentTable:
	;DMC snare drum
	.db $0F,$00
	.db (DMCSnareDrumData>>6)&$FF
	.db (DMCSnareDrumDataEnd-DMCSnareDrumData)>>4
	;DMC bass drum
	.db $0F,$00
	.db (DMCBassDrumData>>6)&$FF
	.db (DMCBassDrumDataEnd-DMCBassDrumData)>>4

DMCSnareDrumData:
	.db $FF,$FF,$FF,$AA,$AA,$AA,$02,$C4,$87,$1F,$83,$FF,$F9,$FF,$FF,$19
	.db $0F,$00,$00,$00,$30,$C0,$00,$FF,$33,$BF,$1F,$FC,$07,$FF,$1F,$FF
	.db $FD,$CF,$87,$C1,$01,$10,$00,$00,$00,$80,$03,$3E,$EE,$E3,$E7,$F8
	.db $DF,$7F,$FE,$C7,$4F,$FF,$01,$FC,$C0,$0F,$00,$00,$0F,$00,$0A,$E7
	.db $70,$90,$0F,$F8,$B3,$BF,$FF,$C3,$9F,$FC,$18,$0F,$BE,$61,$3E,$F8
	.db $70,$0C,$07,$81,$21,$28,$38,$84,$07,$77,$F0,$F8,$E7,$F7,$F1,$FE
	.db $E0,$37,$FC,$C1,$F8,$80,$97,$C0,$0F,$5C,$61,$D0,$38,$C0,$03,$8F
	.db $E8,$0F,$77,$B8,$07,$FB,$7C,$E0,$C3,$FD,$E0,$83,$F7,$E0,$07,$3F
	.db $1C,$0E,$C6,$C1,$30,$05,$3E,$F0,$03,$1F,$FC,$04,$7F,$E0,$0F,$7E
	.db $70,$3E,$F8,$DD,$F0,$07,$7E,$F0,$C1,$1F,$90,$19,$8E,$E0,$C1,$03
	.db $1F,$04,$1F,$FC,$C1,$0F,$9E,$E8,$C7,$3C,$5E,$0F,$7F,$74,$87,$AB
	.db $03,$0F,$0F,$74,$0C,$3E,$88,$2E,$98,$0F,$F4,$81,$1F,$38,$0E,$1F
	.db $FC,$E2,$2D,$F9,$AC,$1F,$3E,$CC,$87,$8D,$07,$1E,$0F,$0E,$3C,$88
	.db $47,$D8,$C1,$83,$07,$7E,$F0,$70,$EC,$0E,$E7,$E3,$F1,$E5,$E1,$17
	.db $8F,$D1,$8B,$0E,$27,$DC,$18,$39,$1C,$F8,$C0,$83,$C3,$F0,$C3,$86
	.db $6D,$49,$8E,$CF,$E1,$3B,$CE,$83,$77,$E1,$07,$6E,$0A,$7E,$D0,$23
	.db $78,$42,$47,$F4,$E0,$38,$B8,$E1,$E2,$19,$8F,$C7,$39,$9E,$F2,$E1
	.db $2D,$3E,$3A,$1E,$AB,$1C,$95,$A3,$C5,$1C,$4A,$8D,$52,$C3,$E4,$22
	.db $1B,$7C,$E4,$96,$D2,$87,$C7,$E7,$F0,$59,$35,$2F,$8E,$D5,$78,$70
	.db $B1,$71,$E8
	;Padding?
	.db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
DMCSnareDrumDataEnd:
DMCBassDrumData:
	.db $55,$55,$55,$95,$AA,$2A,$95,$E0,$7F,$FC,$C0,$F1,$03,$28,$FE,$FF
	.db $FF,$F1,$5F,$3F,$00,$00,$00,$00,$00,$00,$08,$80,$C0,$F1,$FF,$C7
	.db $8B,$1F,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$AB,$6A,$9B,$AA,$92,$52,$25
	.db $95,$24,$25,$92,$80,$4A,$50,$05,$00,$00,$80,$20,$42,$04,$80,$E2
	.db $FF,$01,$80,$6D,$AB,$6D,$DF,$BB,$77,$7B,$AB,$AF,$DD,$D5,$7D,$DD
	.db $BF,$FF,$EF,$B6,$6D,$6F,$BB,$6D,$AF,$2A,$95,$94,$24,$49,$92,$88
	.db $42,$84,$48,$88,$04,$09,$49,$92,$24,$51,$22,$A5,$92,$22,$49,$AA
	.db $52,$A9,$AA,$5A,$55,$AD,$55,$55,$AD,$6D,$B5,$AD,$6D,$B5,$6D,$DB
	.db $FF
DMCBassDrumDataEnd:

;;;;;;;;
;HEADER;
;;;;;;;;
	.org $FFE0
	;    0123456789ABCDEF
	.db "    BUCKY O'HARE"	;Title
.if VER_JPN != 0
	.db $DE,$39	;PRG checksum
.else ;VER_USA
	.db $DA,$F3	;PRG checksum
.endif
	.db $0E,$55	;CHR checksum
	.db $33		;128KiB PRG, 128KiB CHR
	.db $04		;Horizontal mirroring, MMC
	.db $01		;Title encoding (ASCII)
	.db $0B		;Title length
.if VER_JPN != 0
	.db $CA		;Maker code (Konami)
	.db $90		;Header checksum
.else ;VER_USA
	.db $A4		;Maker code (Konami)
	.db $B6		;Header checksum
.endif
;IVT data
	.dw NMI
	.dw Reset
	.dw IRQ

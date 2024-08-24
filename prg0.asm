	.base $8000
	.org $8000
;BANK NUMBER
	.db $30

;;;;;;;;;;;;;;
;HUD ROUTINES;
;;;;;;;;;;;;;;
UpdateHUDCheck:
	;Check for level 4 minecart area
	lda LevelAreaNum
	cmp #$36
	beq UpdateHUDCheck_Exit
	;If there's a level scroll update, exit early
	lda ScrollUpdateFlag
	bne UpdateHUDCheck_Exit
	;If bits 0-1 of global timer 0, update HUD
	lda LevelGlobalTimer
	and #$03
	beq UpdateHUD
UpdateHUDCheck_Exit:
	rts

UpdateHUD:
	;If in ending mode, exit early
	lda GameMode
	cmp #$09
	beq UpdateHUDCheck_Exit
	;Write HUD tilemap VRAM strip
	lda #$02
	jsr WriteVRAMStrip
	;Decrement VRAM buffer index
	ldx VRAMBufferOffset
	dex
	;Draw filled tiles for power
	lda #$37
	sta $00
	ldy CurCharacter
	lda CharacterPowerCur,y
	beq UpdateHUD_NoFillPow
	sta $01
	jsr DrawHPPowerTiles
	;Draw partly filled tile for power
	lda $01
	and #$03
	beq UpdateHUD_NoFillPow
	clc
	adc #$33
	sta VRAMBuffer,x
	inx
UpdateHUD_NoFillPow:
	;Draw unfilled tiles for power
	lda #$33
	sta $00
	ldy CurCharacter
	lda CharacterPowerMax,y
	sec
	sbc CharacterPowerCur,y
	and #$3C
	jsr DrawHPPowerTiles
	;Draw blank tiles for power
	lda #$00
	sta $00
	ldy CurCharacter
	lda #$24
	sec
	sbc CharacterPowerMax,y
	and #$3C
	jsr DrawHPPowerTiles
	;End VRAM buffer
	jsr WriteVRAMBufferCmd_End
	;Decrement VRAM buffer index
	txa
	sec
	sbc #$16
	tax
	;Draw top score
	lda ScoreTop
	jsr DrawDecimalValue
	lda ScoreTop+1
	jsr DrawDecimalValue
	;Decrement VRAM buffer index
	txa
	sec
	sbc #$0D
	tax
	;Draw lives
	lda NumLives
	jsr DrawDecimalValue
	;Decrement VRAM buffer index
	txa
	sec
	sbc #$0D
	tax
	;Draw filled tiles for HP
	lda #$37
	sta $00
	lda Enemy_HP
	beq UpdateHUD_NoFillHP
	jsr DrawHPPowerTiles
	;Draw partly filled tile for HP
	lda Enemy_HP
	and #$03
	beq UpdateHUD_NoFillHP
	clc
	adc #$33
	sta VRAMBuffer,x
	inx
UpdateHUD_NoFillHP:
	;Draw unfilled tiles for HP
	lda #$33
	sta $00
	lda Enemy_Temp4
	sec
	sbc Enemy_HP
	jsr DrawHPPowerTiles
	;Draw blank tiles for HP
	lda #$00
	sta $00
	lda #$24
	sec
	sbc Enemy_Temp4
	and #$3C
	jsr DrawHPPowerTiles
	;Decrement VRAM buffer index
	txa
	sec
	sbc #$15
	tax
	;Draw current score
	lda ScoreCurrent
	jsr DrawDecimalValue
	lda ScoreCurrent+1
	jmp DrawDecimalValue

DrawHPPowerTiles:
	;Get number of tiles
	lsr
	lsr
	beq DrawHPPowerTiles_Exit
	;Draw HP tiles
	tay
	lda $00
DrawHPPowerTiles_Loop:
	;Set tile in VRAM
	sta VRAMBuffer,x
	;Loop for each tile
	inx
	dey
	bne DrawHPPowerTiles_Loop
DrawHPPowerTiles_Exit:
	rts

;;;;;;;;;;;;;;;;
;LEVEL ROUTINES;
;;;;;;;;;;;;;;;;
InitLevelState:
	;Disable IRQ
	lda #$00
	sta IRQEnableFlag
	sta $E000
	;Disable video output
	jsr DisableVideoOut
	;Init level state
	jsr InitLevelStateSub
	;Enable NMI
	jsr SetScroll_EnNMI
	;Set IRQ wait flag
	lda #$01
	sta IRQWaitFlag
	;Decode IRQ buffer
	jsr DecodeIRQBuffer
	;Enable IRQ
	sta $E001
	rts

InitLevelStateSub:
	;Clear enemies
	jsr ClearEnemies_NoPl
	;Clear collision buffer
	jsr ClearCollisionBuffer
	;Init level state
	sta BeetleInWallOutFlag
	sta DisableSideExitFlag
	sta ScrollXVelHi
	sta ScrollXVelLo
	sta ScrollXAccel
	sta ScrollYVelHi
	sta ScrollYVelLo
	sta ScrollYAccel
	sta Enemy_XVelHi
	sta Enemy_XVelLo
	sta Enemy_XAccel
	sta Enemy_YVelHi
	sta Enemy_YVelLo
	sta Enemy_YAccel
	sta Enemy_Temp1
	sta Enemy_Temp2
	sta Enemy_Temp3
	sta Enemy_Temp1
	sta Enemy_Temp0
	sta $2A
	sta UpdateMetatileCount
	sta UpdateVRAMStripCount
	sta PlayerPaletteOffset
	sta PlatformXVel
	sta BossEnemyIndex
	sta ScrollDisableFlag
	sta IRQBufferPlatformXVel
	sta IRQBufferPlatformXVel+1
	sta IRQBufferPlatformXVel+2
	sta FrozenIceLayerFlag
	sta ScrollDirectionFlag
	sta EnemyGrabbingMode
	sta LavaWormGrabFlag
	sta GravityAreaMode
	sta AutoEscapePodFlag
	sta CrusherAreaFlag
	;Set level area number
	jsr SetLevelAreaNum
	;Check for level 8 escape pod areas
	cmp #$71
	bcc InitLevelStateSub_NoEP
	;Set on escape pod flag
	lda #$01
	bne InitLevelStateSub_SetEP
InitLevelStateSub_NoEP:
	;Clear on escape pod flag
	lda #$00
InitLevelStateSub_SetEP:
	sta OnEscapePodFlag
	;Get level area info pointer
	lda CurLevel
	asl
	tax
	lda LevelAreaInfoPointerTable,x
	sta LevelAreaInfoPointer
	lda LevelAreaInfoPointerTable+1,x
	sta LevelAreaInfoPointer+1
	;Setup player entrance
	lda (LevelAreaInfoPointer),y
	and #$BF
	sta AreaScrollFlags
	iny
	lda (LevelAreaInfoPointer),y
	sta CurScreen
	iny
	lda (LevelAreaInfoPointer),y
	ora #$01
	sta Enemy_Y
	iny
	lda (LevelAreaInfoPointer),y
	sta Enemy_X
	and #$01
	sta AreaDirectionFlags
	;Check for level 5 big elevator area
	lda LevelAreaNum
	cmp #$4D
	bne InitLevelStateSub_NoElevator
	;Set player position
	lda #$F0
	sta Enemy_X
	lda #$53
	sta Enemy_Y
InitLevelStateSub_NoElevator:
	;Check for current character Blinky
	lda CurCharacter
	cmp #$03
	bne InitLevelStateSub_NoBlinky
	;Increment player Y position $02 (to account for height difference)
	lda Enemy_Y
	clc
	adc #$02
	sta Enemy_Y
InitLevelStateSub_NoBlinky:
	;Check if on left or right side of screen
	lda Enemy_X
	bpl InitLevelStateSub_Right
	;Flip player X
	lda #$40
	bne InitLevelStateSub_SetP
InitLevelStateSub_Right:
	;Don't flip player X
	lda #$00
InitLevelStateSub_SetP:
	sta Enemy_Props
	;Set level tile collision range
	jsr SetLevelTileCollRange
	;Clear scroll update disable flag
	lda #$00
	sta ScrollUpdateDisableFlag
	;Init level scroll
	jsr InitLevelScroll
	;Check level enemies for initial load
	jsr CheckLevelEnemiesInit
	;Set IRQ buffer collision flag
	ldy LevelAreaNum
	lda LevelAreaIRQBufferSetTable,y
	and #$01
	sta IRQBufferCollisionFlag
	;Load IRQ buffer set
	lda LevelAreaIRQBufferSetTable,y
	and #$FE
	tax
	jsr LoadIRQBufferSet
	;Check for ending mode
	lda GameMode
	cmp #$09
	beq InitLevelStateSub_NoBossMusic
	;Check for scrolling disabled (single screen area)
	lda AreaScrollFlags
	cmp #$84
	bne InitLevelStateSub_NoBossMusic
	;Set current screen
	lda #$FF
	sta CurScreen
	;Clear sound
	jsr ClearSound
	;Check for level 7/8
	lda CurLevel
	cmp #$06
	bcs InitLevelStateSub_BossMusic
	;Play boss music
	ldy #MUSIC_BOSS
	bne InitLevelStateSub_SetMusic
InitLevelStateSub_BossMusic:
	;Play boss 2 music
	ldy #MUSIC_BOSS2
InitLevelStateSub_SetMusic:
	jsr LoadSound
InitLevelStateSub_NoBossMusic:
	;Set scroll update disable flag
	ldy LevelAreaNum
	lda LevelAreaCHRBankSetTable,y
	and #$01
	sta ScrollUpdateDisableFlag
	;Load CHR bank set
	lda LevelAreaCHRBankSetTable,y
	and #$FE
	tax
	jsr LoadCHRBankSet
	;Update HUD
	jsr UpdateHUD
	;Check if on escape pod
	lda OnEscapePodFlag
	bne InitLevelStateSub_EP
	;Setup current character
	jmp HandleCharacterChange_InitHP
InitLevelStateSub_EP:
	;Setup current character (escape pod)
	jmp HandleCharacterChange_EP_Init

ClearCollisionBuffer:
	;Clear collision buffer
	lda #$00
	ldx #$2F
ClearCollisionBuffer_Loop:
	sta CollisionBuffer+$1E0-$30,x
	dex
	bpl ClearCollisionBuffer_Loop
ClearCollisionBuffer_IRQ:
	;Clear IRQ buffer
	lda #$00
	ldx #$03
ClearCollisionBuffer_IRQLoop:
	sta TempIRQBufferHeight,x
	sta TempIRQBufferScrollX,x
	sta TempIRQBufferScrollHi,x
	sta IRQBufferPlatformXVel,x
	inx
	cpx #$08
	bne ClearCollisionBuffer_IRQLoop
	rts

LevelAreaIRQBufferSetTable:
	.db $00,$00,$00,$00,$03,$05,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.db $08,$00,$00,$00,$00,$07,$00,$0B,$0D,$00,$00,$00,$00,$00,$00,$00
	.db $10,$10,$10,$10,$10,$13,$00,$14,$14,$17,$00,$00,$00,$00,$00,$00
	.db $1A,$00,$1D,$1F,$07,$00,$00,$19,$00,$00,$00,$00,$00,$00,$00,$00
	.db $00,$00,$00,$00,$00,$00,$00,$00,$00,$21,$21,$21,$21,$00,$00,$00
	.db $00,$00,$00,$00,$00,$00,$00,$00,$00,$27,$00,$00,$00,$00,$00,$00
	.db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.db $00,$00,$00,$00,$00,$2F,$01
LevelAreaPaletteTable:
	.db $14,$0A,$97,$18,$07,$16,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.db $04,$85,$05,$06,$26,$26,$99,$99,$9A,$00,$00,$00,$00,$00,$00,$00
	.db $1B,$23,$23,$23,$22,$22,$1B,$9B,$1B,$24,$00,$00,$00,$00,$00,$00
	.db $1D,$1D,$1E,$1F,$1F,$A0,$A7,$21,$00,$00,$00,$00,$00,$00,$00,$00
	.db $A9,$A9,$A9,$A9,$BF,$BF,$A9,$A9,$BF,$2A,$2A,$2A,$2A,$36,$37,$38
	.db $2B,$2C,$2D,$2D,$2D,$2E,$2E,$2E,$AF,$43,$00,$00,$00,$00,$00,$00
	.db $30,$30,$30,$30,$31,$31,$B1,$32,$32,$32,$32,$4D,$4D,$4D,$58,$00
	.db $40,$40,$40,$40,$52,$52,$56
LevelAreaCHRBankSetTable:
	.db $02,$02,$04,$0E,$07,$0C,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.db $08,$08,$08,$0A,$0A,$0A,$10,$10,$18,$00,$00,$00,$00,$00,$00,$00
	.db $12,$23,$23,$23,$12,$20,$14,$15,$14,$16,$00,$00,$00,$00,$00,$00
	.db $1B,$1A,$1A,$1A,$1A,$1C,$1E,$24,$00,$00,$00,$00,$00,$00,$00,$00
	.db $2A,$2A,$2A,$2A,$40,$40,$2A,$2A,$40,$2C,$2C,$2C,$2C,$36,$38,$3A
	.db $60,$2E,$2E,$2E,$2F,$31,$31,$31,$30,$48,$00,$00,$00,$00,$00,$00
	.db $51,$51,$51,$51,$4E,$54,$56,$32,$32,$32,$32,$53,$53,$53,$5C,$00
	.db $46,$46,$46,$46,$62,$46,$5E

;;;;;;;;;;;;;;;;;;;;
;COLLISION ROUTINES;
;;;;;;;;;;;;;;;;;;;;
CheckEnemyCollision:
	;Check bullet collision
	jsr CheckBulletCollision
	;If player HP 0, set player visible flag
	lda Enemy_HP
	beq CheckEnemyCollision_Show
	;If invincibility timer not 0, decrement and check for visibility
	lda Enemy_Temp3
	beq CheckEnemyCollision_NoInvin
	;Decrement invincibility timer
	dec Enemy_Temp3
	;If bit 0 of invincibility timer 0, clear player visible flag
	and #$01
	bne CheckEnemyCollision_Show
	;Clear player visible flag
	lda Enemy_Flags
	and #~EF_VISIBLE
	sta Enemy_Flags
	bne CheckEnemyCollision_NoInvin
CheckEnemyCollision_Show:
	;Set player visible flag
	lda Enemy_Flags
	ora #EF_VISIBLE
	sta Enemy_Flags
CheckEnemyCollision_NoInvin:
	;Loop for enemy
	ldx #$0C
CheckEnemyCollision_Loop:
	;Check if enemy is visible and enemy collision is enabled
	lda Enemy_Flags,x
	and #(EF_HITENEMY|EF_VISIBLE)
	cmp #(EF_HITENEMY|EF_VISIBLE)
	bne CheckEnemyCollision_Next
	;Check collision X
	lda Enemy_CollWidth,x
	clc
	adc Enemy_CollWidth
	sta $00
	lda Enemy_X,x
	sec
	sbc Enemy_X
	bcs CheckEnemyCollision_PosX
	eor #$FF
	clc
	adc #$01
CheckEnemyCollision_PosX:
	cmp $00
	bcs CheckEnemyCollision_Next
	;Check collision Y
	lda Enemy_CollHeight,x
	clc
	adc Enemy_CollHeight
	sta $00
	lda Enemy_Y,x
	sec
	sbc Enemy_Y
	bcs CheckEnemyCollision_PosY
	eor #$FF
	clc
	adc #$01
CheckEnemyCollision_PosY:
	cmp $00
	bcc CheckEnemyCollision_CheckSpecial
CheckEnemyCollision_Next:
	;Loop enemy
	dex
	bne CheckEnemyCollision_Loop
	rts
CheckEnemyCollision_3F:
	;Check if frozen in ice layer
	lda FrozenIceLayerFlag
	beq CheckEnemyCollision_3FDef
	;Set player Y velocity
	lda #$F4
	sta Enemy_YVelHi
	;Set player jumping flag
	lda Enemy_Temp2
	ora #$10
	sta Enemy_Temp2
	;Clear frozen ice layer flag
	lda #$00
	sta FrozenIceLayerFlag
CheckEnemyCollision_3FDef:
	;Do default collision handler
	lda #ENEMY_L3BSMISSBGICEROCK
	jmp CheckEnemyCollision_DoDefault
CheckEnemyCollision_63:
	;If enemy already grabbing player, do default collision handler
	lda EnemyGrabbingMode
	beq CheckEnemyCollision_63Grab
	;Do default collision handler
	lda #ENEMY_CEILINGSLUG
	jmp CheckEnemyCollision_DoDefault
CheckEnemyCollision_63Grab:
	;Set grabbing player flag
	inc EnemyGrabbingMode
	;Next task ($03: Grab init)
	lda #$03
	sta Enemy_Temp0,x
	;Clear enemy velocity/acceleration
	jmp ClearEnemy_ClearXY
CheckEnemyCollision_68:
	;Set lava worm grab flag
	stx LavaWormGrabFlag
	;Set enemy Y position
	lda #$96
	sta Enemy_Y+$0C
	;Clear enemy flags
	lda #$00
	sta Enemy_Flags+$01
	sta Enemy_Flags+$02
	sta Enemy_Flags+$03
	sta Enemy_Flags+$04
	rts
CheckEnemyCollision_6F:
	;Set gravity area mode
	lda Enemy_Temp1,x
	sta GravityAreaMode
	dec GravityAreaMode
	rts
CheckEnemyCollision_73:
	;Clear current power
	ldy CurCharacter
	lda #$00
	sta CharacterPowerCur,y
	;Clear enemy flags
	sta Enemy_Flags,x
	sta Enemy_Flags+$0E
	sta Enemy_Flags+$0F
	;Set on escape pod flag
	lda #$01
	sta OnEscapePodFlag
	;Setup current character (escape pod)
	jmp HandleCharacterChange_EP_Init
CheckEnemyCollision_CheckSpecial:
	;Handle special collision for enemy $3F (Level 3 boss missile/Rock that destroys iceberg)
	lda Enemy_ID,x
	cmp #ENEMY_L3BSMISSBGICEROCK
	beq CheckEnemyCollision_3F
	;Handle special collision for enemy $74 (Trooper escaping)
	cmp #ENEMY_TROOPERESCAPING
	beq CheckEnemyCollision_74
	;Handle special collision for enemy $55 (Behind BG area)
	cmp #ENEMY_BEHBGAREABGGLPIPE
	beq CheckEnemyCollision_55
	;Handle special collision for enemy $6F (Gravity up/down area)
	cmp #ENEMY_GRAVITYAREA
	beq CheckEnemyCollision_6F
	;Handle special collision for enemy $73 (Escape pod)
	cmp #ENEMY_ESCAPEPOD
	beq CheckEnemyCollision_73
	;Handle special collision for enemy $2F (Boulder pushable)
	cmp #ENEMY_BOULDERPUSH
	beq CheckEnemyCollision_2F
	;Handle special collision for enemy $63 (Ceiling slug)
	cmp #ENEMY_CEILINGSLUG
	beq CheckEnemyCollision_63
	;Handle special collision for enemy $68 (Lava worm)
	cmp #ENEMY_LAVAWORM
	beq CheckEnemyCollision_68
	;Handle special collision for enemies $10-$14 (various items)
	cmp #$10
	bcc CheckEnemyCollision_Default
	cmp #$14
	bcc CheckEnemyCollision_Item
CheckEnemyCollision_Default:
	;Do default collision handler
	jmp CheckEnemyCollision_DoDefault
CheckEnemyCollision_Item:
	;Do item collision handler
	jmp HandleItemCollision
CheckEnemyCollision_55:
	;Set player priority to be behind background
	lda #$20
	sta Enemy_Props
	rts
CheckEnemyCollision_74:
	;Check if 2 troopers are already grabbing
	lda EnemyGrabbingMode
	cmp #$02
	beq CheckEnemyCollision_74Def
	;If not already inited, do default collision handler
	lda Enemy_Temp0,x
	cmp #$01
	beq CheckEnemyCollision_74Grab
CheckEnemyCollision_74Def:
	;Do default collision handler
	lda #ENEMY_TROOPERESCAPING
	jmp CheckEnemyCollision_DoDefault
CheckEnemyCollision_74Grab:
	;Set trooper grabbing index
	lda EnemyGrabbingMode
	sta Enemy_Temp6,x
	tay
	txa
	sta EnemyGrabbingIndex,y
	;Increment number of troopers grabbing
	inc EnemyGrabbingMode
	;Set enemy ID to trooper grabbing
	lda #ENEMY_TROOPERGRABBING
	sta Enemy_ID,x
	;Mark uninited
	lda #$00
	sta Enemy_Temp0,x
	;Set enemy props
	sta Enemy_Props,x
	;Clear enemy velocity/acceleration
	jmp ClearEnemy_ClearXY
CheckEnemyCollision_2F:
	;Check for current character Blinky
	lda Enemy_Y
	ldy CurCharacter
	cpy #$03
	bne CheckEnemyCollision_2FNoBlinky
	;Decrement player Y position $04 (to account for height difference)
	sec
	sbc #$04
CheckEnemyCollision_2FNoBlinky:
	sta $00
	clc
	adc #$07
	sta $01
	;If player Y position <= enemy Y position < player Y position + $07, push boulder
	lda Enemy_Y,x
	cmp $00
	bcc CheckEnemyCollision_DefExit
	cmp $01
	bcs CheckEnemyCollision_DefExit
	;Determine player relative position X
	lda Enemy_X
	cmp Enemy_X,x
	bcc CheckEnemyCollision_2FLeft
	;Push boulder left
	sec
	sbc #$16
	sta Enemy_X,x
	rts
CheckEnemyCollision_2FLeft:
	;Push boulder right
	clc
	adc #$16
	sta Enemy_X,x
CheckEnemyCollision_DefExit:
	rts
CheckEnemyCollision_DoDefault:
	;Check for hard mode
	tay
	lda HardModeFlag
	bne CheckEnemyCollision_Hard
	;Get enemy damage amount
	lda EnemyStrengthPointsTable,y
	and #$0F
	sta $02
	;If damage amount $0F, do max damage
	cmp #$0F
	bne CheckEnemyCollision_NormDamage
CheckEnemyCollision_Hard:
	;Set damage to $80 (do max damage)
	lda #$80
CheckEnemyCollision_SetDamage
	sta $02
	;If max damage, don't check invincibility timer
	bmi CheckEnemyCollision_MaxDamage
CheckEnemyCollision_NormDamage:
	;If invincibility timer not 0, exit early
	lda Enemy_Temp3
	bne CheckEnemyCollision_DefExit
CheckEnemyCollision_MaxDamage:
	;If player HP 0, exit early
	lda Enemy_HP
	beq CheckEnemyCollision_DefExit
	;If title or ending mode, exit early
	lda GameMode
	beq CheckEnemyCollision_DefExit
	cmp #$09
	beq CheckEnemyCollision_DefExit
	;If on escape pod, skip this part
	lda OnEscapePodFlag
	bne CheckEnemyCollision_EP
	;Set player Y position for hit player
	jsr HitEnemySetYPos
	;If player charging/in special state, don't clear enemy flags
	lda Enemy_Temp2
	and #$2C
	beq CheckEnemyCollision_NoClearF
	;If player got hit by self fire, clear enemy flags
	dey
	bne CheckEnemyCollision_NoClearF
	;Clear enemy flags
	lda #$00
	sta Enemy_Flags+$0F
CheckEnemyCollision_NoClearF:
	;Clear player ducking/charging/special mode flags
	lda Enemy_Temp2
	and #$13
	sta Enemy_Temp2
	lda Enemy_Temp0
	and #$70
	sta Enemy_Temp0
	;Set player animation
	ldx CurCharacter
	ldy NormModePlayerAnimWalkTable,x
	ldx #$00
	jsr SetEnemyAnimation
CheckEnemyCollision_EP:
	;Reset invincibility timer
	lda #$20
	sta Enemy_Temp3
	;Play sound
	ldy #SE_PLAYERHIT
	jsr LoadSound
	;Do damage to player
	lda Enemy_HP
	sec
	sbc $02
	sta Enemy_HP
	;If player HP 0 or above max, kill player
	beq CheckEnemyCollision_Death
	cmp Enemy_Temp4
	bcc CheckEnemyCollision_Exit
CheckEnemyCollision_Death:
	;Check if player is on escape pod
	lda OnEscapePodFlag
	bne CheckEnemyCollision_DeathEP
	;Load CHR bank
	ldx CurCharacter
	lda NormModePlayerCHRBankTable,x
	sta TempCHRBanks+2
	;Set player animation
	ldy NormModePlayerAnimDeadTable,x
	ldx #$00
	jsr SetEnemyAnimation
	;Clear player X velocity/acceleration
	lda #$00
	sta Enemy_XVelHi
	sta Enemy_XVelLo
	sta Enemy_XAccel
	sta ScrollXVelHi
	sta ScrollXVelLo
	sta ScrollXAccel
	;Clear player HP
	sta Enemy_HP
	;Clear player flags
	sta Enemy_Temp0
	;Unflash player palette
	jsr UnflashPlayerPalette
CheckEnemyCollision_DeathDef:
	;Reset invincibility timer
	lda #$FF
	sta Enemy_Temp3
	;Set mode timer
	lda #$80
	sta GameSubmode
	;Next mode ($06: Death)
	lda #$06
	sta GameMode
	;Play music
	ldy #MUSIC_DEATH
	jmp LoadSound
CheckEnemyCollision_DeathEP:
	;Set enemy grabbing mode for death animation
	lda #$06
	sta EnemyGrabbingMode
	;Clear player HP
	lda #$00
	sta Enemy_HP
	;Setup next mode
	beq CheckEnemyCollision_DeathDef
CheckEnemyCollision_Exit:
	rts

HitEnemySetYPos:
	;Check if player is ducking
	ldy CurCharacter
	lda Enemy_Temp2
	bpl HitEnemySetYPos_NoDuck
	;Decrement player Y position $04 (to account for height difference)
	lda Enemy_Y
	sec
	sbc #$04
	sta Enemy_Y
HitEnemySetYPos_NoDuck:
	;Clear player charging flag
	lda Enemy_Temp2
	and #$20
	beq CheckEnemyCollision_Exit
	;Decrement player Y position (to account for height difference)
	lda Enemy_Y
	sec
	sbc NormModePlayerChargeYOffs,y
	sta Enemy_Y
	rts

HandleItemCollision:
	;If player HP 0, exit early
	lda Enemy_HP
	beq CheckEnemyCollision_Exit
	;Set enemy flags
	lda #(EF_ACTIVE|EF_VISIBLE)
	sta Enemy_Flags,x
	;Set enemy Y velocity
	lda #$FC
	sta Enemy_YVelHi,x
	;Check if on left or right side of screen
	lda Enemy_X,x
	bmi HandleItemCollision_Right
	;Set enemy X velocity (right)
	lda #$04
	bne HandleItemCollision_SetX
HandleItemCollision_Right:
	;Set enemy X velocity (left)
	lda #$FC
HandleItemCollision_SetX:
	sta Enemy_XVelHi,x
	;Mark item as collected
	jsr GetItemEnemyBit
	lda $00
	ora ItemCollectedBits,y
	sta ItemCollectedBits,y
	;Play sound
	lda Enemy_ID,x
	sec
	sbc #$10
	sta $17
	tay
	lda ItemSndEffTable,y
	tay
	jsr LoadSound
	;Do jump table
	lda $17
	jsr DoJumpTable
HandleItemJumpTable:
	.dw HandleItem10	;$10  Lifeup item
	.dw HandleItem11	;$11  Powerup item
	.dw HandleItem12	;$12  1-UP
	.dw HandleItem13	;$13  Bonus coin
;$10: Lifeup item
HandleItem10:
	;Check if player max HP $24 (max allowed)
	lda Enemy_Temp4
	cmp #$24
	beq HandleItem10_Max
	;Increment player max HP $08
	clc
	adc #$08
	sta Enemy_Temp4
HandleItem10_Max:
	;Max out player HP
	sta Enemy_HP
	;Jump to give points
	jmp HandleItem13
;$11: Powerup item
HandleItem11:
	;Check if players max power $A4 (max allowed)
	ldy CurCharacter
	lda CharacterPowerMax,y
	cmp #$A4
	;Jump to give points if already maxed out
	beq HandleItem13
	;Increment player max power $0C
	clc
	adc #$0C
	sta CharacterPowerMax,y
	rts
;$12: 1-UP
HandleItem12:
	;Check for 99 lives (max allowed)
	lda NumLives
	cmp #$63
	;Jump to give points if already maxed out
	beq HandleItem13
	;Increment lives count
	inc NumLives
	rts
;$13: Bonus coin
HandleItem13:
	;Give player 300 points
	lda #$1E
	jmp GivePoints
ItemSndEffTable:
	.db SE_LIFEUP		;$10  Lifeup item
	.db SE_POWERUP		;$11  Powerup item
	.db SE_1UP		;$12  1-UP
	.db SE_BONUSCOIN	;$13  Bonus coin

;NORMAL MODE PLAYER SPRITE DATA
NormModePlayerAnimDeadTable:
	.db $E6,$EA,$E8,$EE,$EC

CheckBulletCollision:
	;Loop for first enemy
	ldy #$0D
CheckBulletCollision_Loop1:
	lda Enemy_Flags,y
	bpl CheckBulletCollision_Next1
	;Loop for second enemy
	ldx #$0C
CheckBulletCollision_Loop2:
	;Check if enemy is visible and bullet collision is enabled
	lda Enemy_Flags,x
	and #(EF_HITBULLET|EF_VISIBLE)
	cmp #(EF_HITBULLET|EF_VISIBLE)
	bne CheckBulletCollision_Next2
	;Check collision X
	lda Enemy_CollWidth,x
	clc
	adc Enemy_CollWidth,y
	sta $00
	lda Enemy_X,x
	sec
	sbc Enemy_X,y
	bcs CheckBulletCollision_PosX
	eor #$FF
	clc
	adc #$01
CheckBulletCollision_PosX:
	cmp $00
	bcs CheckBulletCollision_Next2
	;Check collision Y
	lda Enemy_CollHeight,x
	clc
	adc Enemy_CollHeight,y
	sta $00
	lda Enemy_Y,x
	sec
	sbc Enemy_Y,y
	bcs CheckBulletCollision_PosY
	eor #$FF
	clc
	adc #$01
CheckBulletCollision_PosY:
	cmp $00
	bcs CheckBulletCollision_Next2
	;Handle collision
	jsr HandleBulletCollision
CheckBulletCollision_Next2:
	;Loop second enemy
	dex
	bne CheckBulletCollision_Loop2
CheckBulletCollision_Next1:
	;Loop first enemy
	iny
	cpy #$10
	bne CheckBulletCollision_Loop1
CheckBulletCollision_Exit:
	rts

HandleBulletCollision:
	;Check for ice block particles animation
	lda Enemy_Anim,y
	cmp #$03
	beq CheckBulletCollision_Exit
	cmp #$95
	beq CheckBulletCollision_Exit
	;Check if enemy is invincible to player fire
	lda Enemy_Flags,x
	and #EF_INVINCIBLE
	bne HandleBulletCollision_Invin
	;Check for BG glass pipe
	lda Enemy_ID,x
	cmp #ENEMY_BGGLASSPIPE
	beq HandleBulletCollision_ClearF
	;If current current character Willy, don't clear enemy flags
	lda CurCharacter
	cmp #$04
	beq HandleBulletCollision_NoClearF
	;If player charging/in special state, don't clear enemy flags
	lda Enemy_Temp2
	and #$24
	bne HandleBulletCollision_NoClearF
HandleBulletCollision_ClearF:
	;Clear enemy flags
	lda #$00
	sta Enemy_Flags,y
HandleBulletCollision_NoClearF:
	;Do damage to enemy
	lda Enemy_HP,x
	sec
	sbc Enemy_Temp4,y
	sta Enemy_HP,x
	;If enemy HP 0 or $C0-$FF, kill enemy
	beq HandleBulletCollision_Kill
	cmp #$C0
	bcs HandleBulletCollision_Kill
	;Save Y register
	tya
	pha
	;Play sound
	ldy #SE_ENEMYHIT
	jsr LoadSound
	;Restore Y register
	pla
	tay
	;Set enemy flash
	lda #$10
	sta Enemy_Temp5,x
	;Check for caged pig
	lda Enemy_ID,x
	cmp #ENEMY_CAGEDPIG
	bne HandleBulletCollision_Exit
	;Next task ($02: Run init)
	lda #$02
	sta Enemy_Temp0,x
	rts
HandleBulletCollision_Invin:
	;Check if already bounced off invincible enemy
	lda Enemy_Temp6,y
	bne HandleBulletCollision_Exit
	;Set already bounced flag
	lda #$01
	sta Enemy_Temp6,y
	;Flip enemy X velocity
	lda #$00
	sec
	sbc Enemy_XVelHi,y
	sta Enemy_XVelHi,y
	;Set enemy Y velocity
	lda #$FA
	sta Enemy_YVelHi,y
	;Save Y register
	tya
	pha
	;Play sound
	ldy #SE_ENEMYINVIN
	jsr LoadSound
	;Restore Y register
	pla
	tay
HandleBulletCollision_Exit:
	rts
HandleBulletCollision_Boss:
	;If player HP 0, setup next mode
	lda Enemy_HP
	beq HandleBulletCollision_Exit
	;Next mode ($08: Victory)
	lda #$08
	sta GameMode
	;Next submode ($00: Update game state)
	lda #$00
	sta GameSubmode
	;Clear enemies
	jmp ClearEnemies_NoPl
HandleBulletCollision_Hypno:
	;Next task ($00: Defeated init)
	lda #$00
	sta Enemy_Temp2+$01
	;Set enemy HP
	lda #$C0
	sta Enemy_HP+$01
	;Save Y register
	tya
	pha
	;Clear sound
	jsr ClearSound
	;Play music
	ldy #MUSIC_CLEAR
	jsr LoadSound
	;Restore Y register
	pla
	tay
	rts
HandleBulletCollision_Kill:
	;Check for boss enemy slot index
	cpx BossEnemyIndex
	beq HandleBulletCollision_Boss
	;Check for hypno Willy/Dead-Eye/Jenny
	lda Enemy_ID,x
	cmp #ENEMY_HYPNOWILLY
	beq HandleBulletCollision_Hypno
	cmp #ENEMY_HYPNODEADEYE
	beq HandleBulletCollision_Hypno
	cmp #ENEMY_HYPNOJENNY
	beq HandleBulletCollision_Hypno
	;Save Y register
	tya
	pha
	;Set enemy animation
	ldy #$E4
	jsr SetEnemyAnimation
	;Set enemy props
	lda #$00
	sta Enemy_Props,x
	;Clear enemy tile offset
	sta Enemy_Temp7,x
	;Set enemy lifetime
	lda #$90
	sta Enemy_Temp5,x
	;Clear enemy velocity/acceleration
	jsr ClearEnemy_ClearXY
	;Give player points
	ldy Enemy_ID,x
	lda EnemyStrengthPointsTable,y
	lsr
	lsr
	lsr
	lsr
	jsr GivePoints
	;Play sound
	ldy #SE_ENEMYKILL
	jsr LoadSound
	;Restore Y register
	pla
	tay
HandleBulletCollision_CheckSpecial:
	;Handle special collision for enemy $0B (Spider)
	lda Enemy_ID,x
	cmp #ENEMY_SPIDER
	beq HandleBulletCollision_0B
	;Handle special collision for enemy $51 (Level 4 boss part 1)
	cmp #ENEMY_LEVEL4BOSSP1
	beq HandleBulletCollision_51
	;Handle special collision for enemy $09 (BG 8-way shooter)
	cmp #ENEMY_BG8WAYSHOOTER
	beq HandleBulletCollision_09_44
	;Handle special collision for enemy $44 (BG 3-way shooter)
	cmp #ENEMY_BG3WAYSHOOTER
	beq HandleBulletCollision_09_44
	;Handle special collision for enemy $77 (Escape miniboss ship)
	cmp #ENEMY_ESCAPEMBSHIP
	beq HandleBulletCollision_77
	;Handle special collision for enemy $0F (Level 7 boss front part 2)
	cmp #ENEMY_LEVEL7BOSSFRONTP2
	beq HandleBulletCollision_0F
	;Handle special collision for enemy $25 (Ship mouth)
	cmp #ENEMY_SHIPMOUTH
	bne HandleBulletCollision_SpecialExit
	;Save X/Y registers
	tya
	pha
	txa
	pha
	;Loop infinitely? (crashes game)
	jsr HandleBulletCollision_CheckSpecial
	;Draw metatile
	ldx UpdateMetatileCount
	dex
	lda #$78
	sta UpdateMetatileID,x
	;Restore X/Y registers
	bne HandleBulletCollision_RestoreXY
HandleBulletCollision_0B:
	;Clear enemy flags
	lda #$00
	sta Enemy_Flags+$0C
	rts
HandleBulletCollision_51:
	;Save X/Y registers
	tya
	pha
	txa
	pha
	;Clear boss shooter metatile
	jsr ClearBossShooter
HandleBulletCollision_RestoreXY:
	;Restore X/Y registers
	pla
	tax
	pla
	tay
HandleBulletCollision_SpecialExit:
	rts
HandleBulletCollision_09_44:
	;Save X/Y registers
	txa
	pha
	tya
	pha
	;Mark enemy as dead
	jsr GetItemEnemyBit
	lda EnemyTriggeredBits,y
	ora $00
	sta EnemyTriggeredBits,y
	;Clear shooter metatile
	jsr ClearShooter
	;Restore X/Y registers
	pla
	tay
	pla
	tax
	rts
HandleBulletCollision_77:
	;Save X/Y registers
	txa
	pha
	tya
	pha
	;Check for back thruster
	txa
	cmp #$01
	beq HandleBulletCollision_77Thruster
	;Clear boss shooter metatile
	clc
	adc #$0F
	ldx UpdateMetatileCount
	sta UpdateMetatilePos,x
	lda #$30
	jsr ClearBossShooter_Ent77Set
	;Restore X/Y registers
	pla
	tay
	pla
	tax
	rts
HandleBulletCollision_0F:
	;Save Y register
	tya
	pha
	;Draw metatiles
	ldy UpdateMetatileCount
	lda #$41
	sta UpdateMetatileProps,y
	lda #$01
	sta UpdateMetatileProps+1,y
	lda #$00
	sta UpdateMetatileID,y
	lda Level7BossMetatile1ID-5,x
	sta UpdateMetatileID+1,y
	lda Level7BossMetatile0Pos-5,x
	sta UpdateMetatilePos,y
	lda Level7BossMetatile1Pos-5,x
	sta UpdateMetatilePos+1,y
	inc UpdateMetatileCount
	inc UpdateMetatileCount
	;Restore Y register
	pla
	tay
	rts
HandleBulletCollision_77Thruster:
	;Next task ($16: Defeated falling part 1)
	lda #$16
	sta BGAnimMode
	;Clear boss shooter metatiles
	ldy #$03
HandleBulletCollision_77Loop:
	;Clear boss shooter metatile
	jsr ClearBossShooter_Ent77
	lda #$C0
	sta UpdateMetatileProps,x
	;Loop for each tile
	iny
	cpy #$09
	bne HandleBulletCollision_77Loop
	;Play sound
	ldy #SE_BOSSKILL
	jsr LoadSound
	;Restore X/Y registers
	pla
	tay
	pla
	tax
	rts

ClearBossShooter:
	;Draw metatile
	ldy Enemy_Temp1,x
ClearBossShooter_Ent77:
	ldx UpdateMetatileCount
	lda BossMetatilePos,y
	sta UpdateMetatilePos,x
	lda BossMetatileID,y
ClearBossShooter_Ent77Set:
	sta UpdateMetatileID,x
	lda #$01
	sta UpdateMetatileProps,x
	inc UpdateMetatileCount
	rts

ClearShooter:
	;Get shooter table index
	lda $01
	ldy CurLevel
	clc
	adc ShooterOffsetTable,y
	tay
	;Draw metatile
	ldx UpdateMetatileCount
	lda ShooterMetatilePos,y
	sta UpdateMetatilePos,x
	lda #$5E
	sta UpdateMetatileID,x
	lda ShooterMetatileProps,y
	sta UpdateMetatileProps,x
	inc UpdateMetatileCount
	rts
Level7BossMetatile1ID:
	.db $CE,$CD
Level7BossMetatile0Pos:
	.db $0C,$24
Level7BossMetatile1Pos:
	.db $0D,$25
ShooterOffsetTable:
	.db $00,$00,$00,$07,$0D
ShooterMetatilePos:
	;$00
	.db $16,$10,$2F,$2D,$15,$2E,$29
	;$07
	.db $0E,$01,$0C,$0B,$00,$05
	;$0D
	.db $13,$16,$1C,$0B,$11,$14,$0D,$13
ShooterMetatileProps:
	;$00
	.db $01,$00,$00,$01,$00,$00,$01
	;$07
	.db $00,$00,$01,$01,$01,$00
	;$0D
	.db $00,$00,$01,$00,$01,$01,$00,$00
BossMetatilePos:
	.db $09,$19,$12,$1A,$1B,$1C,$1D,$1E,$1F
BossMetatileID:
	.db $5C,$5D,$75,$00,$00,$00,$40,$41,$42

GivePoints:
	;Add to 100's+10's places
	clc
	adc ScoreCurrent+1
	sta ScoreCurrent+1
	;Check for carry to 10000's+1000's places
	cmp #$64
	bcc GivePoints_NoCL
	;Subtract 100 from 100's+10's place
	sec
	sbc #$64
	sta ScoreCurrent+1
	;Check for max score (99990 points)
	lda ScoreCurrent
	cmp #$63
	bne GivePoints_NoMax
	;Set max score
	lda #$63
	sta ScoreCurrent+1
	sta ScoreTop
	sta ScoreTop+1
	rts
GivePoints_NoMax:
	;Increment 10000's+1000's places
	inc ScoreCurrent
	;Check for 99 lives (max allowed)
	lda NumLives
	cmp #$63
	beq GivePoints_NoCL
	;Increment lives count
	inc NumLives
	;Play sound
	tya
	pha
	ldy #SE_1UP
	jsr LoadSound
	pla
	tay
GivePoints_NoCL:
	;Compare top score 10000's+1000's place
	lda ScoreCurrent
	cmp ScoreTop
	;If equal, check 100's+10's place as well
	beq GivePoints_Pass1
	;If less, exit
	bcc GivePoints_Exit
	;If greater, set top score
	bcs GivePoints_Pass2
GivePoints_Pass1:
	;Compare top score 100's+10's place
	lda ScoreCurrent+1
	cmp ScoreTop+1
	;If less, exit
	bcc GivePoints_Exit
GivePoints_Pass2:
	;Set top score to current score
	lda ScoreCurrent
	sta ScoreTop
	lda ScoreCurrent+1
	sta ScoreTop+1
GivePoints_Exit:
	rts
	
HandlePlatformCollision:
	;Loop for enemy
	ldx #$0C
HandlePlatformCollision_Loop:
	;Check if enemy is platform
	lda Enemy_Flags,x
	and #EF_PLATFORM
	beq HandlePlatformCollision_Next
	;Check for BG gray pipe
	lda Enemy_ID,x
	cmp #ENEMY_L2BSEYESBGGRPIPE
	beq HandlePlatformCollision_Check
	;Check for conveyor
	cmp #ENEMY_CONVEYOR
	bne HandlePlatformCollision_NoConveyor
	;Check for conveyor update mode flag
	lda ConveyorUpdateFlag
	beq HandlePlatformCollision_Next
	bne HandlePlatformCollision_Check
HandlePlatformCollision_NoConveyor:
	;Check for conveyor update mode flag
	lda ConveyorUpdateFlag
	bne HandlePlatformCollision_Next
HandlePlatformCollision_Check:
	;Check collision X
	lda Enemy_CollWidth,x
	clc
	adc Enemy_CollWidth
	sta $00
	lda Enemy_X,x
	sec
	sbc Enemy_X
	bcs HandlePlatformCollision_PosX
	eor #$FF
	clc
	adc #$01
HandlePlatformCollision_PosX:
	cmp $00
	bcs HandlePlatformCollision_Next
	;Get platform top/bottom Y position
	lda Enemy_Y,x
	sec
	sbc Enemy_CollHeight,x
	sta $00
	clc
	adc #$0A
	sta $01
	;Check for BG gray pipe
	lda Enemy_ID,x
	cmp #ENEMY_L2BSEYESBGGRPIPE
	bne HandlePlatformCollision_NoGrayPipe
	;Set platform bottom Y position $C0
	lda #$C0
	sta $01
	;Check if Blinky is in special state
	lda Enemy_Temp0
	bmi HandlePlatformCollision_Blinky
HandlePlatformCollision_NoGrayPipe:
	;Check if player Y velocity 0 or down
	lda Enemy_YVelHi
	bmi HandlePlatformCollision_Next
HandlePlatformCollision_Blinky:
	;Check collision Y
	lda Enemy_Y
	clc
	adc Enemy_CollHeight
	cmp $00
	bcc HandlePlatformCollision_Next
	cmp $01
	bcc HandlePlatformCollision_Hit
HandlePlatformCollision_Next:
	;Loop enemy
	dex
	bne HandlePlatformCollision_Loop
HandlePlatformCollision_NoHit:
	;Clear platform slot index
	lda Enemy_Temp0
	and #$8F
	sta Enemy_Temp0
	;Clear platform velocity
	lda #$00
	sta PlatformXVel
	rts
HandlePlatformCollision_Hit:
	;Check for conveyor
	lda Enemy_ID,x
	cmp #ENEMY_CONVEYOR
	beq HandlePlatformCollision_HitConveyor
	;Set on platform flag
	lda PlatformEnableFlag
	ora #$80
	sta PlatformEnableFlag
	;Set player Y position
	lda Enemy_Y,x
	sec
	sbc Enemy_CollHeight,x
	sec
	sbc Enemy_CollHeight
	clc
	adc Enemy_YVelHi,x
	clc
	adc #$01
	cmp #$C0
	bcs HandlePlatformCollision_NoHit
	sta Enemy_Y
	;Set platform Y position
	sta PlatformYPos
	;Clear player Y velocity/acceleration
	lda #$00
	sta $10
	sta $11
	sta $12
HandlePlatformCollision_HitConveyor:
	;Set platform X velocity
	lda Enemy_XVelHi,x
	sta PlatformXVel
	;Set platform slot index
	txa
	asl
	asl
	asl
	asl
	sta $00
	lda Enemy_Temp0
	and #$8F
	ora $00
	sta Enemy_Temp0
	rts

EnemyStrengthPointsTable:
	.db $11,$11,$11,$11,$10,$11,$11,$11,$11,$11,$11,$11,$11,$11,$11,$A4
	.db $50,$50,$50,$A0,$04,$00,$A2,$00,$00,$00,$00,$00,$11,$00,$00,$00
	.db $00,$21,$11,$00,$01,$11,$0F,$11,$01,$01,$00,$08,$00,$00,$11,$00
	.db $00,$A1,$01,$0F,$00,$11,$11,$12,$12,$02,$02,$02,$00,$00,$A6,$06
	.db $00,$00,$02,$51,$21,$21,$00,$31,$51,$0F,$00,$01,$00,$0F,$A1,$01
	.db $01,$31,$01,$00,$01,$00,$00,$11,$A8,$A8,$A8,$08,$08,$18,$1F,$01
	.db $01,$02,$04,$11,$04,$08,$32,$32,$01,$01,$A1,$08,$00,$00,$0F,$00
	.db $58,$00,$00,$01,$24,$24,$21,$A1,$A4,$A4,$04,$A4,$04,$04,$34,$11
	.db $11,$A4,$A4,$24,$21,$44,$00

;;;;;;;;;;;;;;;;;;;;;;;;;
;PLAYER CONTROL ROUTINES;
;;;;;;;;;;;;;;;;;;;;;;;;;
ControlPlayer:
	;If on escape pod, run escape pod control routine instead
	lda OnEscapePodFlag
	beq ControlPlayer_NoEP
	jmp ControlPlayer_EP
ControlPlayer_NoEP:
	;Set control player mutex
	lda #$01
	sta ControlPlayerMutex
	;Do tasks
	jsr HandlePlayerSpecial
	jsr HandlePlayerCHRBank
	jsr HandlePlayerSpecialScroll
	jsr HandlePlayerScrolling
	jsr HandleCharacterChange
	jsr HandlePlayerDucking
	jsr HandlePlayerB
	jsr HandlePlayerMovementY
	jsr HandlePlayerMovementX
	jsr HandleBGGrayPipeArea
	;Clear control player mutex
	lda #$00
	sta ControlPlayerMutex
	;If player HP 0, exit early
	lda Enemy_HP
	beq ControlPlayer_Exit
	;If player ducking/charging, handle level 2 vertical scrolling area
	lda Enemy_Temp2
	and #$A0
	bne HandleVerticalPlatformArea
	;If player not on ground in normal state, exit early
	lda Enemy_Temp2
	and #$FC
	bne ControlPlayer_Exit
	lda Enemy_Temp0
	and #$86
	bne ControlPlayer_Exit
	;Check if camera is tracking player X
	lda AreaScrollFlags
	bne ControlPlayer_Enemy
	lda ScrollDisableFlag
	bne ControlPlayer_Enemy
	;If scroll X velocity not 0, exit early
	lda ScrollXVelHi
	beq ControlPlayer_NoMoveX
	rts
ControlPlayer_Enemy:
	;If player X velocity not 0, exit early
	lda Enemy_XVelHi
	ora Enemy_XVelLo
	bne ControlPlayer_Exit
ControlPlayer_NoMoveX:
	;Handle level 2 vertical scrolling area
	jsr HandleVerticalPlatformArea
	;Set player animation
	lda #$02
	sta Enemy_AnimTimer
	;Check for current character Bucky
	ldx CurCharacter
	bne ControlPlayer_Idle
	;Check for UP press
	lda JoypadCur
	and #JOY_UP
	beq ControlPlayer_Idle
	;Check for LEFT/RIGHT press
	lda JoypadCur
	and #(JOY_LEFT|JOY_RIGHT)
	beq ControlPlayer_LookUp
ControlPlayer_Idle:
	;Set player sprite
	lda NormModePlayerSpriteIdleTable,x
	sta Enemy_SpriteLo
	rts
ControlPlayer_LookUp:
	;Load CHR bank
	lda #$55
	sta TempCHRBanks+2
	;Set player sprite
	lda #$54
	sta Enemy_SpriteLo
ControlPlayer_Exit:
	rts

HandleVerticalPlatformArea:
	;Check for level 2 vertical scrolling area
	lda LevelAreaNum
	cmp #$15
	bne HandleVerticalPlatformArea_Exit
	;If player Y velocity not $01, exit early
	lda Enemy_YVelHi
	cmp #$01
	bne HandleVerticalPlatformArea_Exit
	;Set player Y position/velocity
	lda #$00
	sta Enemy_YVelHi
	lda #$50
	sta Enemy_Y
HandleVerticalPlatformArea_Exit:
	rts

;NORMAL MODE PLAYER SPRITE DATA
NormModePlayerCHRBankTable:
	.db $50,$52,$51,$54,$53
NormModePlayerAnimWalkTable:
	.db $00,$04,$02,$08,$06
NormModePlayerAnimJumpTable:
	.db $3E,$42,$40,$46,$44
NormModePlayerAnimDuckTable:
	.db $48,$4C,$4A,$18,$4E
NormModePlayerAnimChargeTable:
	.db $48,$58,$4A,$18,$4E
NormModePlayerChargeYOffs:
	.db $04,$00,$04,$04,$04
NormModePlayerSpriteIdleTable:
	.db $24,$28,$24,$2C,$2A

VerticalPlatformAreaScroll:
	;Check for level 2/4 vertical scrolling areas
	lda LevelAreaNum
	cmp #$15
	beq VerticalPlatformAreaScroll_DoScroll
	cmp #$34
	bne ControlPlayer_Exit
VerticalPlatformAreaScroll_DoScroll:
	;Update scroll animation
	jmp ScrollAnimX3

HandleBGGrayPipeArea:
	;Check for level 3 gray pipe area
	lda LevelAreaNum
	cmp #$26
	bne HandleBGGrayPipeArea_Exit
	;Get collision type middle
	lda Enemy_X
	sta $00
	lda Enemy_Y
	sta $01
	jsr GetCollisionType
	;If solid tile at middle, set player X position based on facing direction
	beq HandleBGGrayPipeArea_Exit
	;Set player X position based on facing direction
	lda Enemy_Props
	and #$40
	lsr
	lsr
	sec
	sbc #$08
	clc
	adc Enemy_X
	sta Enemy_X
HandleBGGrayPipeArea_Exit:
	rts

HandlePlayerSpecial:
	;Check if Jenny light ball is in special state
	lda Enemy_Temp2
	and #$04
	beq HandlePlayerSpecial_NoJenny
	jmp HandlePlayerSpecial_Jenny
HandlePlayerSpecial_NoJenny:
	;Check if Blinky is in special state
	lda Enemy_Temp0
	bmi HandlePlayerSpecial_Blinky
	;Check if Dead-Eye is in special state
	lsr
	bcc HandlePlayerSpecial_Exit
	;If bits 0-1 of global timer not 0, exit early
	lda LevelGlobalTimer
	and #$03
	bne HandlePlayerSpecial_Exit
	;Flash player palette
	jsr FlashPlayerPalette
	;If current power 0, end special mode
	lda CharacterPowerCur+2
	beq HandlePlayerSpecial_EndDeadEye
	;Decrement current power, check if 0
	dec CharacterPowerCur+2
	bne HandlePlayerSpecial_Exit
HandlePlayerSpecial_EndDeadEye:
	;Clear Dead-Eye special state flag
	lda Enemy_Temp0
	and #$F0
	sta Enemy_Temp0
	;Clear player special mode flag
	jmp HandlePlayerSpecial_End
HandlePlayerSpecial_Blinky:
	;If bit 0 of global timer not 0, exit early
	lda LevelGlobalTimer
	and #$01
	bne HandlePlayerSpecial_Exit
	;Flash player palette
	jsr FlashPlayerPalette
	;If current power 0, end special mode
	lda CharacterPowerCur+3
	beq HandlePlayerSpecial_EndBlinky
	;Decrement current power, check if 0
	dec CharacterPowerCur+3
	bne HandlePlayerSpecial_Exit
HandlePlayerSpecial_EndBlinky:
	;Clear Blinky special state flag
	lda Enemy_Temp0
	and #$7F
	sta Enemy_Temp0
	;Clear player special mode flag
	jsr HandlePlayerSpecial_End
	;Clear player X velocity/acceleration
	lda #$00
	sta ScrollXVelHi
	sta ScrollXVelLo
	sta ScrollXAccel
	sta Enemy_XVelHi
	sta Enemy_XVelLo
	sta Enemy_XAccel
	;Check if camera is tracking player Y
	lda AreaScrollFlags
	cmp #$01
	beq HandlePlayerSpecial_Scroll
	;Set player Y acceleration (enemy)
	lda #$7F
	sta Enemy_YAccel
HandlePlayerSpecial_Exit:
	rts
HandlePlayerSpecial_Scroll:
	;Set player Y acceleration (scroll)
	lda #$7F
	sta ScrollYAccel
HandlePlayerSpecial_GrabExit:
	rts

StartPlayerGrabWall:
	;If player climbing wall, exit early
	lda Enemy_Temp0
	and #$02
	bne HandlePlayerSpecial_GrabExit
	;If wall grab cooldown timer 0, grab wall
	lda GrabWallCooldownTimer
	beq StartPlayerGrabWall_DoGrab
	;Decrement wall grab cooldown timer
	dec GrabWallCooldownTimer
	rts
StartPlayerGrabWall_DoGrab:
	;Play sound
	ldy #SE_DEADEYEGRAB
	jsr LoadSound
	;Set wall climbing state flag
	lda Enemy_Temp0
	ora #$02
	sta Enemy_Temp0
	;Clear player Y velocity/acceleration
	lda #$00
	sta ScrollYVelHi
	sta ScrollYVelLo
	sta ScrollYAccel
	sta Enemy_YVelHi
	sta Enemy_YVelLo
	sta Enemy_YAccel
	;Load CHR bank
	lda #$57
	sta TempCHRBanks+2
	;Set player animation
	ldy #$54
	ldx #$00
	jmp SetEnemyAnimation

HandlePlayerSpecial_Jenny:
	;Check if light ball is active
	lda Enemy_Flags+$0F
	beq HandlePlayerSpecial_ClearF
	;Mask joypad bits
	jsr MaskJoypadBits
	;If bits 0-1 of global timer not 0, exit early
	lda LevelGlobalTimer
	and #$03
	bne MaskJoypadBits_Exit
	;Flash player palette
	jsr FlashPlayerPalette
	;If bits 0-3 of global timer not 0, exit early
	lda LevelGlobalTimer
	and #$07
	bne MaskJoypadBits_Exit
	;If current power 0, end special mode
	lda CharacterPowerCur+1
	beq HandlePlayerSpecial_ClearF
	;Decrement current power, check if 0
	dec CharacterPowerCur+1
	bne MaskJoypadBits_Exit
HandlePlayerSpecial_ClearF:
	;Clear enemy flags
	lda #$00
	sta Enemy_Flags+$0F
	;Clear current power
	sta CharacterPowerCur+1
HandlePlayerSpecial_End:
	;Clear player special mode flag
	lda Enemy_Temp2
	and #$F3
	sta Enemy_Temp2
	;Setup current character
	jmp HandleCharacterChange_InitNoHP

MaskJoypadBits:
	;Save current joypad bits
	lda JoypadCur
	sta JoypadUnmasked
	;Mask out all but START button (to allow pausing)
	lda JoypadCur
	and #JOY_START
	sta JoypadCur
	lda JoypadDown
	and #JOY_START
	sta JoypadDown
MaskJoypadBits_Exit:
	rts

HandlePlayerSpecialScroll:
	;Check if lava worm is grabbing player
	ldy LavaWormGrabFlag
	beq HandlePlayerSpecialScroll_NoGrab
	;Mask joypad bits and clear player X velocity/acceleration
	jsr MaskJoypadBitsX
	;If player Y position >= $98, set mask sprite Y position
	lda Enemy_Y
	cmp #$98
	bcc HandlePlayerSpecialScroll_NoSetY
	;Set enemy Y position
	sec
	sbc #$08
	sta Enemy_Y+$0C
HandlePlayerSpecialScroll_NoSetY:
	;Check if player is to left or right
	lda Enemy_X,y
	cmp Enemy_X
	beq HandlePlayerSpecialScroll_NoGrab
	bcc HandlePlayerSpecialScroll_Left
	;Set scroll X velocity right
	lda #$02
	bne HandlePlayerSpecialScroll_SetX
HandlePlayerSpecialScroll_Left:
	;Set scroll X velocity left
	lda #$FF
HandlePlayerSpecialScroll_SetX:
	sta ScrollXVelHi
HandlePlayerSpecialScroll_NoGrab:
	;Check if wall is in front of player
	lda AreaDirectionFlags
	bpl HandlePlayerSpecialScroll_NoWall
	;Clear wall in front flag
	lda AreaDirectionFlags
	and #$7F
	sta AreaDirectionFlags
	;Clear scroll velocity
	lda #$00
	sta ScrollYVelHi
	sta ScrollXVelHi
HandlePlayerSpecialScroll_NoWall:
	;If invincibility timer $18-$FF, mask joypad bits and clear player X velocity/acceleration
	lda Enemy_Temp3
	bmi MaskJoypadBitsX_Exit
	cmp #$18
	bcc MaskJoypadBitsX_Exit

MaskJoypadBitsX:
	;Mask out all but START button (to allow pausing)
	lda JoypadDown
	and #JOY_START
	sta JoypadDown
	lda JoypadCur
	and #JOY_START
	sta JoypadCur
	;Check if camera is tracking player X
	lda AreaScrollFlags
	beq MaskJoypadBitsX_Scroll
	;Clear player X velocity/acceleration (enemy)
	lda #$00
	sta Enemy_XVelLo
	sta Enemy_XAccel
	rts
MaskJoypadBitsX_Scroll:
	;Clear player X velocity/acceleration (scroll)
	lda #$00
	sta ScrollXVelLo
	sta ScrollXAccel
MaskJoypadBitsX_Exit:
	rts

HandleCharacterChange:
	;Get level area info pointer
	lda CurLevel
	asl
	tay
	lda LevelAreaInfoPointerTable,y
	sta LevelAreaInfoPointer
	lda LevelAreaInfoPointerTable+1,y
	sta LevelAreaInfoPointer+1
	;Check for SELECT press
	lda JoypadDown
	and #JOY_SELECT
	beq MaskJoypadBitsX_Exit
	;If player not on ground in normal state, exit early
	lda Enemy_Temp2
	bne MaskJoypadBitsX_Exit
	lda Enemy_Temp0
	and #$8F
	bne MaskJoypadBitsX_Exit
	;Clear current power
	lda #$00
	sta CharacterPowerCur
	sta CharacterPowerCur+1
	sta CharacterPowerCur+2
	sta CharacterPowerCur+3
	sta CharacterPowerCur+4
	;Find next unlocked character
	ldy CurCharacter
	sty $00
HandleCharacterChange_Loop:
	iny
	cpy #$05
	bne HandleCharacterChange_NoC
	ldy #$00
HandleCharacterChange_NoC:
	;Check if character is unlocked
	lda CharacterPowerMax,y
	bpl HandleCharacterChange_Loop
	;Set current character
	sty CurCharacter
	;Flash player palette
	jsr FlashPlayerPalette
	;Check for current character Blinky
	ldx CurCharacter
	cpx #$03
	bne HandleCharacterChange_NoBlinky
	;Increment player Y position $02 (to account for height difference)
	lda Enemy_Y
	clc
	adc #$02
	sta Enemy_Y
	bne HandleCharacterChange_ClearF
HandleCharacterChange_NoBlinky:
	;Check for previous character Blinky
	lda $00
	cmp #$03
	bne HandleCharacterChange_ClearF
	;Decrement player Y position $02 (to account for height difference)
	lda Enemy_Y
	sec
	sbc #$02
	sta Enemy_Y
HandleCharacterChange_ClearF:
	;Clear enemy flags
	lda #$00
	sta Enemy_Flags+$0D
	sta Enemy_Flags+$0E
	sta Enemy_Flags+$0F
HandleCharacterChange_InitHP:
	;If player HP 0, exit early
	lda Enemy_HP
	beq HandlePlayerCHRBank_Exit
HandleCharacterChange_InitNoHP:
	;Load CHR bank
	ldx CurCharacter
	lda NormModePlayerCHRBankTable,x
	sta TempCHRBanks+2
	;Set player animation
	ldy NormModePlayerAnimWalkTable,x
	ldx #$00
	jmp SetEnemyAnimation

HandlePlayerCHRBank:
	;If player shooting down/charging or Jenny light ball is in special state, exit early
	lda Enemy_Temp2
	and #$64
	bne HandlePlayerCHRBank_Exit
	;If player climbing wall, exit early
	lda Enemy_Temp0
	and #$02
	bne HandlePlayerCHRBank_Exit
	;Load CHR bank
	ldx CurCharacter
	lda NormModePlayerCHRBankTable,x
	sta TempCHRBanks+2
HandlePlayerCHRBank_Exit:
	rts

HandlePlayerDucking:
	;If Blinky/Dead-Eye is in special state, exit early
	lda Enemy_Temp0
	and #$81
	bne HandlePlayerCHRBank_Exit
	;Check for DOWN press
	lda JoypadCur
	and #JOY_DOWN
	beq EndPlayerDuck
	;Mask out LEFT/RIGHT buttons
	lda JoypadCur
	and #~(JOY_LEFT|JOY_RIGHT)
	sta JoypadCur
	;If player ducking/charging/jumping, exit early
	lda Enemy_Temp2
	and #$B0
	bne HandlePlayerCHRBank_Exit
	;Set player ducking flag
	lda Enemy_Temp2
	ora #$80
	sta Enemy_Temp2
	;Clear current power
	ldx CurCharacter
	lda #$00
	sta CharacterPowerCur,x
	;Increment player Y position $04 (to account for height difference)
	lda Enemy_Y
	clc
	adc #$04
	sta Enemy_Y
	;Set player animation
	lda NormModePlayerAnimDuckTable,x
	tay
	ldx #$00
	jsr SetEnemyAnimation

ClearPlayerXVel:
	;Clear player X velocity/acceleration
	lda #$00
	sta Enemy_XVelHi
	sta Enemy_XVelLo
	sta Enemy_XAccel
	sta ScrollXVelHi
	sta ScrollXVelLo
	sta ScrollXAccel
ClearPlayerXVel_Exit:
	rts

EndPlayerDuck:
	;Check if player is ducking
	lda Enemy_Temp2
	bpl ClearPlayerXVel_Exit
	;Clear player ducking flag
	lda Enemy_Temp2
	and #$7F
	sta Enemy_Temp2
	;Decrement player Y position $04 (to account for height difference)
	ldx CurCharacter
	lda Enemy_Y
	sec
	sbc #$04
	sta Enemy_Y
	jmp HandleCharacterChange_InitHP

HandlePlayerB:
	;If Blinky/Dead-Eye is in special state, exit early
	lda Enemy_Temp0
	and #$81
	bne ClearPlayerXVel_Exit
	;Handle player shooting
	jsr PlayerShoot
	;Check to unflash player palette
	jsr UnflashPlayerPaletteCheck
	;Check for B press
	lda JoypadCur
	and #JOY_B
	bne HandlePlayerB_NoSpecial
	;Check to handle player special
	jmp PlayerSpecialCheck
HandlePlayerB_NoSpecial:
	;If frozen in ice layer, exit early
	lda FrozenIceLayerFlag
	lsr
	bcs ClearPlayerXVel_Exit
	;If bits 0-1 of global timer not 0, exit early
	lda LevelGlobalTimer
	and #$03
	bne ClearPlayerXVel_Exit
	;If player ducking/jumping, exit early
	lda Enemy_Temp2
	and #$90
	bne ClearPlayerXVel_Exit
	;If current power $04, play charging sound
	ldx CurCharacter
	lda a:CharacterPowerCur,x
	cmp #$04
	bne HandlePlayerB_Charging2
	;Play sound
	ldy #SE_CHARGING
	jsr LoadSound
	jmp HandlePlayerB_NoCharging
HandlePlayerB_Charging2:
	;If current power >= $0C, play charging 2 sound
	lda a:CharacterPowerCur,x
	cmp #$0C
	bcc HandlePlayerB_NoCharging
	;Play sound
	ldy #SE_CHARGING2
	jsr LoadSound
HandlePlayerB_NoCharging:
	;If current power = max power, don't increment current power
	lda a:CharacterPowerMax,x
	and #$7F
	cmp a:CharacterPowerCur,x
	beq HandlePlayerB_NoIncPow
	;Increment current power
	inc a:CharacterPowerCur,x
	;If bit 2 of current power not 0, flash player palette
	lda a:CharacterPowerCur,x
	cmp #$04
	beq StartPlayerCharge
	bcc FlashPlayerPalette_Exit
HandlePlayerB_NoIncPow:
	;Flash player palette
	jsr FlashPlayerPalette
	;Check for current player Jenny
	cpx #$01
	bne FlashPlayerPalette_Exit
	;If current power $10/$1C, set player animation
	lda CharacterPowerCur+1
	cmp #$1C
	beq HandlePlayerB_JennyCharging2
	cmp #$10
	bne FlashPlayerPalette_Exit
	;Set player animation
	ldy #$5C
	bne StartPlayerCharge_SetBallAnim
HandlePlayerB_JennyCharging2:
	;Set player animation
	ldy #$5E
	bne StartPlayerCharge_SetBallAnim

FlashPlayerPalette:
	;If another palette is to be loaded, exit early
	lda CurPalette
	bmi FlashPlayerPalette_Exit
	;Toggle player palette offset
	lda PlayerPaletteOffset
	eor #$28
	sta PlayerPaletteOffset
	;Load palette
	lda CurPalette
	ora #$80
	sta CurPalette
FlashPlayerPalette_Exit:
	rts

StartPlayerCharge:
	;Set player charging flag
	lda Enemy_Temp2
	ora #$20
	sta Enemy_Temp2
	;If at bottom side of level, don't increment player Y position
	ldx CurCharacter
	lda AreaScrollFlags
	cmp #$83
	bne StartPlayerCharge_NoOffsY
	lda Enemy_Y
	bmi StartPlayerCharge_NoOffsY
	;Increment player Y position (to account for height difference)
	clc
	adc NormModePlayerChargeYOffs,x
	bpl StartPlayerCharge_NoOffsY
	;Set scroll flags
	lda #$01
	sta AreaScrollFlags
	lda #$00
	sta ScrollDirectionFlag
StartPlayerCharge_NoOffsY:
	;Increment player Y position (to account for height difference)
	lda Enemy_Y
	clc
	adc NormModePlayerChargeYOffs,x
	sta Enemy_Y
	;Set player animation
	lda NormModePlayerAnimChargeTable,x
	tay
	ldx #$00
	jsr SetEnemyAnimation
	;Clear player X velocity/acceleration
	jsr ClearPlayerXVel
	;Check for current player Jenny
	lda CurCharacter
	cmp #$01
	bne FlashPlayerPalette_Exit
	;Load CHR bank
	lda #$58
	sta TempCHRBanks+2
	;Spawn light ball
	lda Enemy_X
	sta Enemy_X+$0F
	lda Enemy_Y
	sec
	sbc #$18
	sta Enemy_Y+$0F
	lda Enemy_Props
	sta Enemy_Props+$0F
	lda #ENEMY_JENNYLIGHTBALL
	sta Enemy_ID+$0F
	ldy #$5A
StartPlayerCharge_SetBallAnim:
	;Clear enemy
	ldx #$0F
	jsr ClearEnemy
	;Set enemy power
	lda #$02
	sta Enemy_Temp4+$0F
	;Set enemy animation
	jmp SetEnemyAnimation

PlayerSpecialCheck:
	;If Jenny light ball is in special state, exit early
	lda Enemy_Temp2
	and #$04
	bne UnflashPlayerPalette_Exit
	;If player charging, exit early
	lda Enemy_Temp2
	and #$20
	;Handle player special
	bne PlayerSpecial
	beq UnflashPlayerPalette_ClearPow

UnflashPlayerPaletteCheck:
	;If player in special state, exit early
	lda Enemy_Temp2
	and #$24
	bne UnflashPlayerPalette_Exit
	;If player palette offset already 0, exit early
	lda PlayerPaletteOffset
	beq UnflashPlayerPalette_Exit

UnflashPlayerPalette:
	;Clear player palette offset
	lda #$00
	sta PlayerPaletteOffset
	;Load palette
	lda CurPalette
	ora #$80
	sta CurPalette
UnflashPlayerPalette_ClearPow:
	;Clear current power
	ldx CurCharacter
	lda #$00
	sta CharacterPowerCur,x
UnflashPlayerPalette_Exit:
	rts

PlayerSpecial:
	;Play sound
	ldy #SE_CHARGING2
	jsr LoadSound
	;Clear player charging flag
	lda Enemy_Temp2
	and #$DF
	;Set player in special state flag
	ora #$08
	sta Enemy_Temp2
	;Decrement player Y position (to account for height difference)
	ldx CurCharacter
	lda Enemy_Y
	sec
	sbc NormModePlayerChargeYOffs,x
	sta Enemy_Y
	lda Enemy_CollHeight
	clc
	adc NormModePlayerChargeYOffs,x
	sta Enemy_CollHeight
	;Do jump table
	lda CurCharacter
	jsr DoJumpTable
PlayerSpecialJumpTable:
	.dw PlayerSpecial_Bucky		;$00  Bucky
	.dw PlayerSpecial_Jenny		;$01  Jenny
	.dw PlayerSpecial_DeadEye	;$02  Dead-Eye
	.dw PlayerSpecial_Blinky	;$03  Blinky
	.dw PlayerSpecial_Willy		;$04  Willy

PlayerShoot:
	;Check for B press
	lda JoypadDown
	and #JOY_B
	beq PlayerShoot_Dec
	;If player shoot cooldown timer 0, do jump table
	lda Enemy_Temp1
	beq PlayerShoot_JT
	;Decrement shoot cooldown timer
	dec Enemy_Temp1
	rts
PlayerShoot_JT:
	;Do jump table
	lda CurCharacter
	jsr DoJumpTable
PlayerShootJumpTable:
	.dw PlayerShoot_Bucky	;$00  Bucky
	.dw PlayerShoot_Jenny	;$01  Jenny
	.dw PlayerShoot_DeadEye	;$02  Dead-Eye
	.dw PlayerShoot_Blinky	;$03  Blinky
	.dw PlayerShoot_Willy	;$04  Willy
PlayerShoot_Dec:
	;If player shoot cooldown timer 0, exit early
	lda Enemy_Temp1
	beq PlayerShoot_Exit
	;Decrement shoot cooldown timer, if not 0, exit early
	dec Enemy_Temp1
	bne PlayerShoot_Exit
	;Check for current character Dead-Eye
	lda CurCharacter
	cmp #$02
	bne PlayerShoot_Exit
	;Clear enemy flags
	lda #$00
	sta Enemy_Flags+$0D
	sta Enemy_Flags+$0E
	sta Enemy_Flags+$0F
PlayerShoot_Exit:
	rts

HandlePlayerMovementY:
	;Check if camera is tracking player Y
	lda AreaScrollFlags
	beq HandlePlayerMovementY_Enemy
	bmi HandlePlayerMovementY_Enemy
	;Get player Y velocity/acceleration (scroll)
	lda ScrollYVelHi
	sta $10
	lda ScrollYVelLo
	sta $11
	lda ScrollYAccel
	sta $12
	;Handle player jumping
	jsr HandlePlayerJumping
	;Apply player Y acceleration
	jsr ApplyPlayerYAccel
	;Save scroll Y position
	lda TempMirror_PPUSCROLL_Y
	sta $16
	;Add player Y velocity to scroll Y position
	clc
	adc $10
	sta TempMirror_PPUSCROLL_Y
	;Handle vertical scrolling area
	jsr VerticalPlatformAreaScroll
	;Handle collision
	jsr HandlePlayerCollisionY
	;Adjust player Y velocity based on scroll Y position
	lda TempMirror_PPUSCROLL_Y
	sec
	sbc $16
	sta $10
	;Restore scroll Y position
	lda $16
	sta TempMirror_PPUSCROLL_Y
	;Handle special movement Y (scroll)
	jsr HandlePlayerSpecialMoveY_Scroll
	;Set player Y velocity/acceleration (scroll)
	lda $10
	sta ScrollYVelHi
	lda $11
	sta ScrollYVelLo
	lda $12
	sta ScrollYAccel
	rts
HandlePlayerMovementY_Enemy:
	;Get player Y velocity/acceleration (enemy)
	lda Enemy_YVelHi
	sta $10
	lda Enemy_YVelLo
	sta $11
	lda Enemy_YAccel
	sta $12
	;Handle player jumping
	jsr HandlePlayerJumping
	;Apply player Y acceleration
	jsr ApplyPlayerYAccel
	;Handle special movement Y (enemy)
	jsr HandlePlayerSpecialMoveY_Enemy
	;Handle vertical scrolling area
	jsr VerticalPlatformAreaScroll
	;Handle collision
	jsr HandlePlayerCollisionY
	;Set player Y velocity/acceleration (enemy)
	lda $10
	sta Enemy_YVelHi
	lda $11
	sta Enemy_YVelLo
	lda $12
	sta Enemy_YAccel
HandlePlayerMovementY_Exit:
	rts

HandlePlayerJumping:
	;Check if player is ducking
	lda Enemy_Temp0
	bpl HandlePlayerJumping_NoDuck
	;Set jump Y acceleration
	jmp SetJumpYAccel
HandlePlayerJumping_NoDuck:
	;Check if player is grabbing wall
	and #$02
	beq HandlePlayerJumping_NoWall
	;Handle player wall climbing
	jmp HandlePlayerWallClimbing
HandlePlayerJumping_NoWall:
	;Check if player is jumping
	lda Enemy_Temp2
	and #$10
	beq HandlePlayerJumping_OnGround
	jmp HandlePlayerJumping_InAir
HandlePlayerJumping_OnGround:
	;Check for A press
	lda JoypadDown
	and #JOY_A
	beq HandlePlayerMovementY_Exit
	;If frozen in ice layer, exit early
	lda FrozenIceLayerFlag
	lsr
	bcs HandlePlayerMovementY_Exit
	;If player ducking/charging/jumping, check for jumping down
	lda Enemy_Temp2
	and #$B0
	beq HandlePlayerJumping_NoDown
	;If player charging/jumping, exit early
	and #$30
	bne HandlePlayerMovementY_Exit
	;Get collision type bottom left
	lda Enemy_X
	sec
	sbc Enemy_CollWidth
	clc
	adc #$02
	sta $00
	lda Enemy_Y
	clc
	adc Enemy_CollHeight
	sta $01
	jsr GetCollisionType
	sta $08
	;Get collision type bottom right
	lda Enemy_X
	clc
	adc Enemy_CollWidth
	sec
	sbc #$02
	sta $00
	jsr GetCollisionType
	;Combine results
	ora $08
	;Check for semisolid collision type
	cmp #$01
	bne HandlePlayerMovementY_Exit
	;If in level 3 or 5, exit early
	lda CurLevel
	cmp #$02
	beq HandlePlayerMovementY_Exit
	cmp #$04
	beq HandlePlayerMovementY_Exit
	;Set player jumping down timer
	lda Enemy_Temp2
	ora #$03
	;Clear player ducking flag
	and #$7F
	sta Enemy_Temp2
	;Move player up $04
	ldy CurCharacter
	lda Enemy_Y
	sec
	sbc #$04
	sta Enemy_Y
	;Set player Y velocity
	lda #$02
	sta $10
	lda #$80
	sta $11
	bne HandlePlayerJumping_PlaySound
HandlePlayerJumping_NoDown:
	;Check if enemy is grabbing player
	ldy EnemyGrabbingMode
	beq HandlePlayerJumping_NoGrab
	;Set player Y velocity based on enemy grabbing mode
	lda PlayerJumpYVelTable-1,y
	bne HandlePlayerJumping_SetY
HandlePlayerJumping_NoGrab:
	;Set player Y velocity
	lda #$F8
HandlePlayerJumping_SetY:
	sta $10
	lda #$40
	sta $11
HandlePlayerJumping_PlaySound:
	;Play sound
	ldy #SE_JUMP
	jsr LoadSound
HandlePlayerJumping_Fall:
	;Check for current character Jenny
	lda CurCharacter
	cmp #$01
	bne HandlePlayerJumping_NoJenny
	;Clear enemy flags
	lda #$00
	sta Enemy_Flags+$0F
HandlePlayerJumping_NoJenny:
	;Clear player charging flag
	lda Enemy_Temp2
	and #$DF
	;Set player jumping flag
	ora #$10
	sta Enemy_Temp2
	;Set player Y acceleration
	lda #$7F
	sta $12
	;If shooting down, exit early
	lda Enemy_Temp2
	and #$40
	bne HandlePlayerJumping_Exit
	;Check if player is ducking
	lda Enemy_Temp2
	bpl HandlePlayerJumping_NoDuck2
	;Clear player ducking flag
	and #$7F
	sta Enemy_Temp2
	;Move player up $04
	ldx CurCharacter
	lda Enemy_Y
	sec
	sbc #$04
	sta Enemy_Y
HandlePlayerJumping_NoDuck2:
	;If Blinky is in special state, exit early
	ldx CurCharacter
	lda Enemy_Temp0
	bmi HandlePlayerJumping_Exit
	;Check if Dead-Eye is in special state
	and #$01
	bne HandlePlayerJumping_SpecialDeadEye
	;Clear current power
	lda #$00
	sta CharacterPowerCur,x
HandlePlayerJumping_SpecialDeadEye:
	;If player HP 0, exit early
	lda Enemy_HP
	beq HandlePlayerJumping_Exit
	;Set player animation
	ldy NormModePlayerAnimJumpTable,x
	ldx #$00
	jmp SetEnemyAnimation
PlayerJumpYVelTable:
	.db $FA,$FB,$FC
HandlePlayerJumping_InAir:
	;If player Y velocity down, exit early
	lda $10
	bpl HandlePlayerJumping_Exit
	;Check for A press
	lda JoypadCur
	and #JOY_A
	bne HandlePlayerJumping_Exit
	;If player in special state, exit early
	lda Enemy_Temp2
	and #$08
	bne HandlePlayerJumping_Exit
	;If player Y velocity >= $FD, exit early
	lda $10
	cmp #$FD
	bcs HandlePlayerJumping_Exit
	;Set player Y velocity $FD
	lda #$FD
	sta $10
	lda #$00
	sta $11
HandlePlayerJumping_Exit:
	rts

ApplyPlayerYAccel:
	;Check if player accelerating up or down
	lda $12
	bmi ApplyPlayerYAccel_Up
	;If player Y acceleration $06, exit early
	lda $10
	cmp #$06
	bne ApplyPlayerYAccel_SetY
	rts
ApplyPlayerYAccel_Up:
	;If player Y acceleration $FA, exit early
	lda $10
	cmp #$FA
	beq HandlePlayerJumping_Exit
	dec $10
ApplyPlayerYAccel_SetY:
	;Apply player Y acceleration
	lda $11
	clc
	adc $12
	sta $11
	lda $10
	adc #$00
	sta $10
	rts

GravityAreaSndEffTable:
	.db SE_GRAVITYUP
	.db SE_WHIRLONG
	.db SE_GRAVITYDOWN
HandlePlayerSpecialMoveY_Enemy:
	;Check for gravity area mode
	lda GravityAreaMode
	beq HandlePlayerSpecialMoveY_Enemy_NoGrav
	;If player HP 0, skip this part
	lda Enemy_HP
	beq HandlePlayerSpecialMoveY_Enemy_NoGrav
	;If bits 0-2 of global timer 0, play sound
	lda LevelGlobalTimer
	and #$07
	bne HandlePlayerSpecialMoveY_Enemy_NoSound
	;Play sound based on gravity mode
	ldy GravityAreaMode
	iny
	lda GravityAreaSndEffTable,y
	tay
	jsr LoadSound
HandlePlayerSpecialMoveY_Enemy_NoSound:
	;Check if player is grabbing wall
	lda Enemy_Temp0
	and #$03
	beq HandlePlayerSpecialMoveY_Enemy_NoWall
	;Set current power $01
	lda #$01
	sta CharacterPowerCur+2
	bne HandlePlayerSpecialMoveY_Enemy_NoDown
HandlePlayerSpecialMoveY_Enemy_NoWall:
	;Check if player is jumping down
	lda Enemy_Temp2
	and #$40
	beq HandlePlayerSpecialMoveY_Enemy_NoDown
	;Clear jumping down flag
	lda Enemy_Temp2
	and #$BF
	sta Enemy_Temp2
	;Load CHR bank
	lda #$50
	sta TempCHRBanks+2
	;Set player animation
	ldx #$00
	ldy #$3E
	jsr SetEnemyAnimation
HandlePlayerSpecialMoveY_Enemy_NoDown:
	;Clear player Y velocity
	lda #$00
	sta $10
	sta $11
	;Add gravity area effect to player Y position
	lda Enemy_Y
	clc
	adc GravityAreaMode
	jmp HandlePlayerSpecialMoveY_Enemy_Check
HandlePlayerSpecialMoveY_Enemy_NoGrav:
	;Check for level 6 lava worm area
	lda LevelAreaNum
	cmp #$58
	bne HandlePlayerSpecialMoveY_Enemy_NoGrabArea
	;Check if lava worm is grabbing player
	lda LavaWormGrabFlag
	bne HandlePlayerSpecialMoveY_Enemy_Grab
	;If player Y position < $93, clear enemy grabbing mode
	lda Enemy_Y
	cmp #$93
	bcc HandlePlayerSpecialMoveY_Enemy_ClearGrab
HandlePlayerSpecialMoveY_Enemy_Grab:
	;Set enemy grabbing mode for lava worm
	lda #$02
	sta EnemyGrabbingMode
	;Increment player Y velocity
	lda $11
	clc
	adc #$80
	sta $00
	lda $10
	adc #$00
	sta $01
	;Apply player Y velocity
	lda $00
	clc
	adc Enemy_YLo
	sta Enemy_YLo
	lda Enemy_Y
	adc $01
	jmp HandlePlayerSpecialMoveY_Enemy_Check
HandlePlayerSpecialMoveY_Enemy_ClearGrab:
	;Clear enemy grabbing mode
	lda #$00
	sta EnemyGrabbingMode
HandlePlayerSpecialMoveY_Enemy_NoGrabArea:
	;Apply player Y velocity
	lda $11
	clc
	adc Enemy_YLo
	sta Enemy_YLo
	lda Enemy_Y
	adc $10
HandlePlayerSpecialMoveY_Enemy_Check:
	;If player Y position $00, clear player visible flag
	beq HandlePlayerSpecialMoveY_Enemy_ClearF
	;If player Y position < $D0, set player visible flag
	cmp #$D0
	bcc HandlePlayerSpecialMoveY_Enemy_SetF
	;If player Y position < $E0, kill player
	cmp #$E0
	bcc HandlePlayerSpecialMoveY_Enemy_NoBottom
HandlePlayerSpecialMoveY_Enemy_ClearF:
	;Set player Y position $00
	lda #$00
	sta Enemy_Y
	;Clear player visible flag
	lda Enemy_Flags
	and #~EF_VISIBLE
	sta Enemy_Flags
HandlePlayerSpecialMoveY_Enemy_Exit:
	rts
HandlePlayerSpecialMoveY_Enemy_NoBottom:
	;If player HP 0, exit early
	ldy Enemy_HP
	beq HandlePlayerSpecialMoveY_Enemy_Exit
	;Set player Y position $D7
	lda #$D7
	sta Enemy_Y
	;Kill player
	jmp CheckEnemyCollision_Death
HandlePlayerSpecialMoveY_Enemy_SetF:
	;Set player Y position
	sta Enemy_Y
	;Set player visible flag
	lda Enemy_Flags
	ora #EF_VISIBLE
	sta Enemy_Flags
	rts

HandlePlayerSpecialMoveY_Scroll:
	;Check if scrolling up or down
	lda ScrollDirectionFlag
	beq HandlePlayerSpecialMoveY_Scroll_Down
	;If player Y velocity 0, exit early
	lda $10
	beq HandlePlayerSpecialMoveY_Enemy_Exit
	;Check for player Y velocity down
	bpl HandlePlayerSpecialMoveY_Scroll_Other
	;If entering a new screen, check for top of area
	lda TempMirror_PPUSCROLL_Y
	clc
	adc $10
	bcs HandlePlayerSpecialMoveY_Scroll_UpExit
	;Get top screen based on area scroll direction
	ldy CurArea
	iny
	lda AreaDirectionFlags
	and #$01
	beq HandlePlayerSpecialMoveY_Scroll_UpNoWarp2
	iny
	iny
	iny
	iny
HandlePlayerSpecialMoveY_Scroll_UpNoWarp2:
	;If current screen = top screen, setup scroll for top side of level
	lda (LevelAreaInfoPointer),y
	cmp CurScreen
	bne HandlePlayerSpecialMoveY_Scroll_UpExit
	;Set player Y velocity
	jsr SetPlayerYVel
	;Set scroll flags for top side of level
	lda #$C1
	sta AreaScrollFlags
	;Set scroll direction down
	lda #$00
	sta ScrollDirectionFlag
	;Set player Y velocity
	sec
	sbc TempMirror_PPUSCROLL_Y
	sta $10
HandlePlayerSpecialMoveY_Scroll_UpExit:
	rts
HandlePlayerSpecialMoveY_Scroll_Other:
	;Set player Y velocity
	jsr SetPlayerYVel
	;Set scroll flags for bottom side of level
	lda #$C3
	sta AreaScrollFlags
	;Set scroll direction up
	lda #$01
	sta ScrollDirectionFlag
	;Clear player Y velocity
	lda #$00
	sta $10
HandlePlayerSpecialMoveY_Scroll_DownExit:
	rts
HandlePlayerSpecialMoveY_Scroll_Down:
	;If player Y velocity 0, exit early
	lda $10
	beq HandlePlayerSpecialMoveY_Scroll_DownExit
	;Check for player Y velocity up
	bmi HandlePlayerSpecialMoveY_Scroll_Other
	;If entering a new screen, check for bottom of area
	lda TempMirror_PPUSCROLL_Y
	clc
	adc $10
	cmp #$F0
	bcc SetPlayerYVel_Exit
	;Get bottom screen based on area scroll direction
	ldy CurArea
	iny
	lda AreaDirectionFlags
	and #$01
	bne HandlePlayerSpecialMoveY_Scroll_DownNoWarp2
	iny
	iny
	iny
	iny
HandlePlayerSpecialMoveY_Scroll_DownNoWarp2:
	;If current screen = bottom screen, setup scroll for bottom side of level
	lda (LevelAreaInfoPointer),y
	sec
	sbc #$01
	cmp CurScreen
	bne SetPlayerYVel_Exit
	;Set player Y velocity
	jsr SetPlayerYVel
	;Set scroll flags for bottom side of level
	lda #$C3
	sta AreaScrollFlags
	;Set scroll direction down
	lda #$00
	sta ScrollDirectionFlag
	;Set player Y velocity
	lda #$F0
	sec
	sbc TempMirror_PPUSCROLL_Y
	sta $10
	rts

SetPlayerYVel:
	;Set player Y velocity/acceleration
	lda $10
	sta Enemy_YVelHi
	lda $11
	sta Enemy_YVelLo
	lda $12
	sta Enemy_YAccel
	;Clear player Y velocity/acceleration
	lda #$00
	sta $11
	sta $12
SetPlayerYVel_Exit:
	rts

HandlePlayerCollisionY:
	;If player climbing wall, exit early
	lda Enemy_Temp0
	and #$02
	bne SetPlayerYVel_Exit
	;If jumping down, decrement timer
	ldx #$00
	lda Enemy_Temp2
	and #$03
	beq HandlePlayerCollisionY_NoDown
	;Decrement jumping down timer
	dec Enemy_Temp2
	rts
HandlePlayerCollisionY_NoDown:
	;Check for level 1 floating log area
	lda LevelAreaNum
	cmp #$02
	bne HandlePlayerCollisionY_NoLogArea
	;Check for current screen $17/$18/$19
	lda CurScreen
	cmp #$17
	beq HandlePlayerCollisionY_CheckLogC
	cmp #$18
	beq HandlePlayerCollisionY_CheckLog
	cmp #$19
	bne HandlePlayerCollisionY_NoLogArea
	beq HandlePlayerCollisionY_CheckLog
HandlePlayerCollisionY_CheckLogC:
	;If scroll X position < $90, skip this part
	lda TempMirror_PPUSCROLL_X
	cmp #$90
	bcc HandlePlayerCollisionY_NoLogArea
HandlePlayerCollisionY_CheckLog:
	;If player Y position + $04 < platform Y position, set floating log jump flag
	lda Enemy_Y
	clc
	adc #$04
	cmp PlatformYPos
	bcs HandlePlayerCollisionY_NoLogArea
	;Set floating log jump flag
	lda #$01
	bne HandlePlayerCollisionY_SetLog
HandlePlayerCollisionY_NoLogArea:
	;Clear floating log jump flag
	lda #$00
HandlePlayerCollisionY_SetLog:
	sta FloatingLogJumpFlag
	;Clear platform X velocity
	ldx #$00
	stx PlatformXVel
	;Handle collision bottom
	jsr HandlePlayerCollisionBottom
	;Get collision type top
	ldx #$00
	jsr GetCollisionTypeTop
	;If nonsolid collision type, exit early
	beq HandlePlayerCollisionY_Exit
	;If death collision type, kill player
	cmp #$04
	beq HandlePlayerCollisionBottom_Death
	;If solid collision type, update player Y position accordingly
	cmp #$02
	beq HandlePlayerCollisionBottom_Solid
	cmp #$03
	beq HandlePlayerCollisionBottom_Solid
	;If level 3/5, treat semisolid collision type as solid collision type
	lda CurLevel
	cmp #$02
	beq HandlePlayerCollisionBottom_Solid
	cmp #$04
	beq HandlePlayerCollisionBottom_Solid
HandlePlayerCollisionY_Exit:
	rts

HandlePlayerCollisionBottom:
	;Get collision type bottom
	jsr GetCollisionTypeBottom
	;Check for nonsolid collision type
	beq HandlePlayerCollisionBottom_NonSolid
	;Check for death collision type
	cmp #$04
	bne HandlePlayerCollisionBottom_NoDeath
HandlePlayerCollisionBottom_Death:
	;If platforms are not enabled, check for floating log jump flag
	lda PlatformEnableFlag
	beq HandlePlayerCollisionBottom_DeathNoPlat
	;Handle platform collision
	jsr HandlePlatformCollision
	;If player not on platform, check for floating log jump flag
	lda PlatformEnableFlag
	bpl HandlePlayerCollisionBottom_DeathNoPlat
	;Clear on platform flag
	and #$7F
	sta PlatformEnableFlag
	;Setup player landing
	jmp LandPlayer
HandlePlayerCollisionBottom_DeathNoPlat:
	;If jumping on floating log, exit early
	lda FloatingLogJumpFlag
	bne HandlePlayerCollisionY_Exit
	;Kill player
	lda #$80
	jmp CheckEnemyCollision_SetDamage
HandlePlayerCollisionBottom_NonSolid:
	;If platforms are not enabled, setup player fall
	lda PlatformEnableFlag
	beq HandlePlayerCollisionBottom_AirNoPlat
	;Handle platform collision
	jsr HandlePlatformCollision
	;If player not on platform, setup player fall
	lda PlatformEnableFlag
	bpl HandlePlayerCollisionBottom_AirNoPlat
	;Clear on platform flag
	and #$7F
	sta PlatformEnableFlag
	;If player not jumping, exit early
	lda Enemy_Temp2
	and #$10
	beq HandlePlayerCollisionBottom_SolidExit
	;If Blinky is in special state, exit early
	lda Enemy_Temp0
	bmi HandlePlayerCollisionBottom_SolidExit
	;Setup player landing
	jmp LandPlayer
HandlePlayerCollisionBottom_AirNoPlat:
	;Setup player fall
	jmp HandlePlayerJumping_Fall
HandlePlayerCollisionBottom_Solid:
	;If player Y velocity down, exit early
	lda $10
	bpl HandlePlayerCollisionY_Exit
	;If jumping on floating log, exit early
	lda FloatingLogJumpFlag
	bne HandlePlayerCollisionBottom_EnemyExit
	;Clear player Y velocity/acceleration
	lda #$00
	sta $10
	sta $11
	sta $12
	;Check if camera is tracking player Y
	lda AreaScrollFlags
	beq HandlePlayerCollisionBottom_Enemy
	bmi HandlePlayerCollisionBottom_Enemy
	;Adjust player Y position for collision (scroll)
	jsr ClipPlayerYScroll
	clc
	adc #$07
	sta TempMirror_PPUSCROLL_Y
HandlePlayerCollisionBottom_SolidExit:
	rts
HandlePlayerCollisionBottom_Enemy:
	;Adjust player Y position for collision (enemy)
	jsr ClipPlayerYEnemy
	clc
	adc #$07
	sta Enemy_Y
HandlePlayerCollisionBottom_EnemyExit:
	rts
HandlePlayerCollisionBottom_NoDeath:
	;Check for level 4 big asteroid area
	lda LevelAreaNum
	cmp #$35
	bne HandlePlayerCollisionBottom_SemiSolid
	;If player on platform, treat as nonsolid collision type
	lda Enemy_Temp0
	and #$70
	beq HandlePlayerCollisionBottom_SemiSolid
	bne HandlePlayerCollisionBottom_NonSolid
HandlePlayerCollisionBottom_SemiSolid:
	;Clear platform slot index
	lda Enemy_Temp0
	and #$8F
	sta Enemy_Temp0
	;If jumping on floating log, exit early
	lda FloatingLogJumpFlag
	bne HandlePlayerCollisionBottom_EnemyExit
	;Set conveyor update mode flag
	lda #$01
	sta ConveyorUpdateFlag
	;Handle platform collision
	jsr HandlePlatformCollision
	;Clear conveyor update mode flag
	lda #$00
	sta ConveyorUpdateFlag
	;Clear on platform flag
	lda PlatformEnableFlag
	and #$7F
	sta PlatformEnableFlag
	;Check if IRQ buffer collision handling enabled
	lda IRQBufferCollisionFlag
	beq HandlePlayerCollisionBottom_NoIRQ
	;Get IRQ buffer index at collision Y position
	ldy $07
	bmi HandlePlayerCollisionBottom_NoIRQ
	;Set platform X velocity based on IRQ scroll buffer
	lda IRQBufferPlatformXVel,y
	sta PlatformXVel
HandlePlayerCollisionBottom_NoIRQ:
	;If player not jumping, exit early
	lda Enemy_Temp2
	and #$10
	beq HandlePlayerCollisionBottom_EnemyExit
	;If player Y velocity 0, exit early
	lda $10
	bmi HandlePlayerCollisionBottom_EnemyExit
	;Clear player Y velocity/acceleration
	lda #$00
	sta $11
	sta $10
	sta $12
	;Check for level 6 lava worm area
	lda LevelAreaNum
	cmp #$58
	bne HandlePlayerCollisionBottom_NoGrab
	;Check if lava worm is grabbing player
	lda LavaWormGrabFlag
	bne HandlePlayerCollisionBottom_Grab
	;If player Y position < $93, check player special state before landing
	lda Enemy_Y
	cmp #$93
	bcc HandlePlayerCollisionBottom_NoGrab
HandlePlayerCollisionBottom_Grab:
	;Setup player landing
	jmp LandPlayer_SetAnim
HandlePlayerCollisionBottom_NoGrab:
	;Setup player landing
	jsr LandPlayer_CheckSound
	;Check if camera is tracking player Y
	lda AreaScrollFlags
	bmi ClipPlayerYEnemy
	beq ClipPlayerYEnemy

ClipPlayerYScroll:
	;Set wall in front flag
	lda AreaDirectionFlags
	ora #$80
	sta AreaDirectionFlags
	;Adjust scroll Y position for collision
	lda TempMirror_PPUSCROLL_Y
	clc
	adc Enemy_Y
	clc
	adc Enemy_CollHeight
	and #$F8
	sec
	sbc Enemy_CollHeight
	sec
	sbc Enemy_Y
	sta TempMirror_PPUSCROLL_Y
	rts

ClipPlayerYEnemy:
	;Clear enemy slot index
	ldx #$00
ClipPlayerYEnemy_Any:
	;Check if IRQ buffer collision handling enabled
	lda IRQBufferCollisionFlag
	beq ClipPlayerYEnemy_NoIRQ
	;Get scroll Y position
	jsr GetScrollYPos
	jmp ClipPlayerYEnemy_Loop
ClipPlayerYEnemy_NoIRQ:
	;Get scroll Y position
	lda TempMirror_PPUSCROLL_Y
ClipPlayerYEnemy_Loop:
	;Adjust enemy Y position for collision
	and #$07
	sta $00
	clc
	adc Enemy_Y,x
	clc
	adc Enemy_CollHeight,x
	and #$F8
	sec
	sbc $00
	sec
	sbc Enemy_CollHeight,x
	sta Enemy_Y,x
ClipPlayerYEnemy_Exit:
	rts

GetScrollYPos:
	;Get IRQ buffer index at collision Y position
	ldy $07
	bmi GetScrollYPos_NoIRQ
	;Get scroll Y position
	lda #$FF
GetScrollYPos_Loop:
	clc
	adc TempIRQBufferHeight,y
	dey
	bpl GetScrollYPos_Loop
	eor #$FF
	rts
GetScrollYPos_NoIRQ:
	;Get scroll Y position
	lda TempMirror_PPUSCROLL_Y
	rts

LandPlayer:
	;If player ducking/charging, clear player jumping down/jumping/in special state flags
	lda Enemy_Temp2
	and #$A0
	beq LandPlayer_NoSound
	bne LandPlayer_ClearF
LandPlayer_CheckSound:
	;If Blinky is in special state, exit early
	lda Enemy_Temp0
	bmi ClipPlayerYEnemy_Exit
	;If player max HP 0, don't play sound
	lda Enemy_Temp3
	bne LandPlayer_NoSound
	;Play sound
	ldy #SE_LAND
	jsr LoadSound
LandPlayer_NoSound:
	;If Jenny light ball is in special state, exit early
	lda Enemy_Temp2
	and #$04
	bne ClipPlayerYEnemy_Exit
	;If player HP 0, exit early
	lda Enemy_HP
	beq ClipPlayerYEnemy_Exit
LandPlayer_SetAnim:
	;Load CHR bank
	ldx CurCharacter
	lda NormModePlayerCHRBankTable,x
	sta TempCHRBanks+2
	;Set player animation
	ldy NormModePlayerAnimWalkTable,x
	ldx #$00
	jsr SetEnemyAnimation
LandPlayer_ClearF:
	;Clear player jumping down/jumping/in special state flags
	lda Enemy_Temp2
	and #$A7
	sta Enemy_Temp2
	rts

GetCollisionTypeBottom:
	;Get collision type bottom left
	lda Enemy_Y,x
	clc
	adc Enemy_CollHeight,x
GetCollisionTypeBottomSub_AnyY:
	sta $01
	lda Enemy_X,x
	sec
	sbc Enemy_CollWidth,x
	clc
	adc #$04
	sta $00
	jsr GetCollisionType
	sta $08
	;Get collision type bottom left
	lda Enemy_X,x
	clc
	adc Enemy_CollWidth,x
	sec
	sbc #$04
	sta $00
	jsr GetCollisionType
	;Combine results
	ora $08
	rts

GetCollisionTypeTop:
	;Get collision type top left/top right
	lda Enemy_Y,x
	sec
	sbc Enemy_CollHeight,x
	jmp GetCollisionTypeBottomSub_AnyY

GetCollisionTypeRight:
	;Get collision type bottom right
	lda Enemy_X,x
	clc
	adc Enemy_CollWidth,x
	sta $00
	bcs GetCollisionTypeLeft_Exit
GetCollisionTypeRight_NoExit:
	lda Enemy_Y,x
	clc
	adc Enemy_CollHeight,x
	sec
	sbc #$04
	sta $01
	jsr GetCollisionType
	sta $08
	;Get collision type top right
	lda Enemy_Y,x
	sec
	sbc Enemy_CollHeight,x
	clc
	adc #$04
	sta $01
	;If collision check offset top $F0-$FF, don't check collision top right
	cmp #$F0
	bcc GetCollisionTypeRight_Top
	lda #$00
	beq GetCollisionTypeRight_NoTop
GetCollisionTypeRight_Top:
	jsr GetCollisionType
GetCollisionTypeRight_NoTop:
	;Combine results
	ora $08
	sta $08
	;Get collision type middle right
	lda Enemy_Y,x
	sta $01
	;If collision check offset middle $F0-$FF, don't check collision middle right
	cmp #$F0
	bcc GetCollisionTypeRight_Mid
	lda #$00
	beq GetCollisionTypeRight_NoMid
GetCollisionTypeRight_Mid:
	jsr GetCollisionType
GetCollisionTypeRight_NoMid:
	;Combine results
	ora $08
	rts

GetCollisionTypeLeft:
	;Get collision type bottom left/top left/middle left
	lda Enemy_X,x
	sec
	sbc Enemy_CollWidth,x
	sta $00
	bcs GetCollisionTypeRight_NoExit
GetCollisionTypeLeft_Exit:
	lda #$00
	rts

HandlePlayerMovementX:
	;Check if camera is tracking player X
	lda AreaScrollFlags
	ora ScrollDisableFlag
	beq HandlePlayerMovementX_Scroll
	jmp HandlePlayerMovementX_Enemy
HandlePlayerMovementX_Scroll:
	;Get player X velocity/acceleration (scroll)
	lda ScrollXVelHi
	sta $13
	lda ScrollXVelLo
	sta $14
	lda ScrollXAccel
	sta $15
	;Handle player running
	jsr HandlePlayerRunning
	;Apply player X acceleration
	jsr ApplyPlayerXAccel
	;Save scroll X position
	lda TempMirror_PPUCTRL
	sta $17
	lda TempMirror_PPUSCROLL_X
	sta $16
	;Check for player X velocity right
	lda $13
	bpl HandlePlayerMovementX_Right
	;Add player X velocity to scroll X position (left)
	clc
	adc TempMirror_PPUSCROLL_X
	sta TempMirror_PPUSCROLL_X
	bcs HandlePlayerMovementX_NoXC
	bcc HandlePlayerMovementX_XC
HandlePlayerMovementX_Right:
	;Add player X velocity to scroll X position (right)
	clc
	adc TempMirror_PPUSCROLL_X
	sta TempMirror_PPUSCROLL_X
	bcc HandlePlayerMovementX_NoXC
HandlePlayerMovementX_XC:
	;Swap nametable
	lda TempMirror_PPUCTRL
	eor #$01
	sta TempMirror_PPUCTRL
HandlePlayerMovementX_NoXC:
	;Handle collision
	jsr HandlePlayerCollisionX
	;Adjust player X velocity based on scroll X position
	lda TempMirror_PPUSCROLL_X
	sec
	sbc $16
	sta $13
	;Restore scroll X position
	lda $16
	sta TempMirror_PPUSCROLL_X
	lda $17
	sta TempMirror_PPUCTRL
	;Handle special movement X
	jsr HandlePlayerSpecialMoveX
	;Set player X velocity/acceleration (scroll)
	lda $13
	sta ScrollXVelHi
	lda $14
	sta ScrollXVelLo
	lda $15
	sta ScrollXAccel
	rts
HandlePlayerMovementX_Enemy:
	;Get player X velocity/acceleration (enemy)
	lda Enemy_XVelHi
	sta $13
	lda Enemy_XVelLo
	sta $14
	lda Enemy_XAccel
	sta $15
	;Handle player running
	jsr HandlePlayerRunning
	;Apply player X acceleration
	jsr ApplyPlayerXAccel
	;Handle collision
	jsr HandlePlayerCollisionX
	;Set player X velocity/acceleration (enemy)
	lda $13
	sta Enemy_XVelHi
	lda $14
	sta Enemy_XVelLo
	lda $15
	sta Enemy_XAccel
	;Set player X position
	lda Enemy_XVelHi
	clc
	adc PlatformXVel
	sta $00
	lda Enemy_XVelLo
	clc
	adc Enemy_XLo
	sta Enemy_XLo
	;If on left or right side of screen before movement, kill player
	lda Enemy_X
	cmp #$0E
	bcc HandlePlayerMovementX_Kill
	cmp #$F2
	bcs HandlePlayerMovementX_Kill
	;If on left or right side of screen after movement, check for warp
	adc $00
	cmp #$0E
	bcc HandlePlayerMovementX_CheckWarpLeft
	cmp #$F2
	bcs HandlePlayerMovementX_CheckWarpRight
	;Set player X position
	sta Enemy_X
HandlePlayerMovementX_EnemyExit:
	rts
HandlePlayerMovementX_Kill:
	;Kill player
	lda #$80
	jmp CheckEnemyCollision_SetDamage
HandlePlayerMovementX_CheckWarpLeft:
	;Check for exit on left side of level
	lda #$00
	beq HandlePlayerMovementX_CheckWarp
HandlePlayerMovementX_CheckWarpRight:
	;Check for exit on right side of level
	lda #$01
HandlePlayerMovementX_CheckWarp:
	sta $00
	;If in middle of level, exit early
	lda AreaScrollFlags
	bpl HandlePlayerMovementX_EnemyExit
	;Check for level 5
	lda CurLevel
	cmp #$04
	beq HandlePlayerMovementX_Level5
	;If current screen = entrance 1 screen, check for warp backward
	ldy CurArea
	iny
	lda (LevelAreaInfoPointer),y
	cmp CurScreen
	beq HandlePlayerMovementX_CheckWarp2
	;Check for level 4 ships area (area 3)
	lda LevelAreaNum
	cmp #$33
	beq HandlePlayerMovementX_CheckNoY
	;If warp Y position - player Y position < $F8 or >= $08, exit early
	lda CurArea
	clc
	adc #$06
	tay
	lda (LevelAreaInfoPointer),y
	sec
	sbc Enemy_Y
	clc
	adc #$08
	cmp #$10
	bcs HandlePlayerMovementX_EnemyExit
	;If warp on wrong side of level, exit early
	lda (LevelAreaInfoPointer),y
	and #$01
	cmp $00
	bne HandlePlayerMovementX_EnemyExit
HandlePlayerMovementX_CheckNoY:
	;If this is the last area, exit early
	lda CurArea
	clc
	adc #$08
	tay
	lda (LevelAreaInfoPointer),y
	beq HandlePlayerMovementX_EnemyExit
	;Set current area
	sty CurArea
	;Load next area
	lda #$80
	sta LevelLoadMode
	rts
HandlePlayerMovementX_CheckWarp2:
	;If this area doesn't allow backtracking, exit early
	ldy CurArea
	lda (LevelAreaInfoPointer),y
	and #$40
	bne HandlePlayerMovementX_EnemyExit
	;If warp Y position - player Y position < $F8 or >= $08, exit early
	iny
	iny
	lda (LevelAreaInfoPointer),y
	sec
	sbc Enemy_Y
	clc
	adc #$08
	cmp #$10
	bcs HandlePlayerMovementX_EnemyExit
	;If warp on wrong side of level, exit early
	lda (LevelAreaInfoPointer),y
	and #$01
	cmp $00
	bne HandlePlayerMovementX_EnemyExit
	;If this is the first area, exit early
	lda CurArea
	beq HandlePlayerMovementX_EnemyExit
	;Set current area
	lda CurArea
	sec
	sbc #$08
	sta CurArea
	;Load next area
	lda #$84
	sta LevelLoadMode
HandlePlayerMovementX_CheckExit:
	rts
HandlePlayerMovementX_Level5:
	;If disable side exit flag set, exit early
	lda DisableSideExitFlag
	bne HandlePlayerMovementX_CheckExit
	;Check for current screen $27/$28/$2A
	lda CurScreen
	cmp #$27
	beq HandlePlayerMovementX_CheckExit
	cmp #$28
	beq HandlePlayerMovementX_CheckExit
	cmp #$2A
	beq HandlePlayerMovementX_CheckExit
	;If current screen = entrance 1 screen, check for warp backward
	lda CurArea
	tay
	lsr
	lsr
	lsr
	tax
	iny
	lda (LevelAreaInfoPointer),y
	cmp CurScreen
	beq HandlePlayerMovementX_Level5Warp2
	;If warp on wrong side of level, exit early
	lda CurArea
	clc
	adc #$06
	tay
	lda (LevelAreaInfoPointer),y
	and #$01
	cmp $00
	bne HandlePlayerMovementX_CheckExit
	;If player Y position >= $60, use bottom warp
	lda Enemy_Y
	cmp #$60
	bcs HandlePlayerMovementX_Level5Bottom
	;Check for level 5 elevator area
	lda Level5ExitElevator
	bne HandlePlayerMovementX_Level5Elevator
	beq HandlePlayerMovementX_Level5NoElevator
HandlePlayerMovementX_Level5Bottom:
	;Check for level 5 elevator area
	lda Level5ExitElevator
	bne HandlePlayerMovementX_Level5Elevator
	;Increment warp data index
	txa
	clc
	adc #$20
	tax
	bne HandlePlayerMovementX_Level5NoElevator
HandlePlayerMovementX_Level5Warp2:
	;If warp on wrong side of level, exit early
	ldy CurArea
	iny
	iny
	lda (LevelAreaInfoPointer),y
	and #$01
	cmp $00
	bne HandlePlayerMovementX_CheckExit
	;If player Y position >= $60, use bottom warp
	lda Enemy_Y
	cmp #$60
	bcs HandlePlayerMovementX_Level5Bottom2
	;Check for level 5 elevator area
	lda Level5ExitElevator
	bne HandlePlayerMovementX_Level5Elevator
	;Increment warp data index
	txa
	clc
	adc #$40
	tax
	bne HandlePlayerMovementX_Level5NoElevator
HandlePlayerMovementX_Level5Bottom2:
	;Check for level 5 elevator area
	lda Level5ExitElevator
	bne HandlePlayerMovementX_Level5Elevator
	;Increment warp data index
	txa
	clc
	adc #$60
	tax
HandlePlayerMovementX_Level5NoElevator:
	;If no warp exists, exit early
	lda Level5WarpDataTable,x
	and #$F8
	beq HandlePlayerMovementX_Level5Exit
	;Setup player entrance
	sta CurArea
	lda Level5WarpDataTable,x
	and #$04
	ora #$80
	sta LevelLoadMode
	lda Level5WarpDataTable,x
	and #$01
	sta Level5ExitElevator
	lda Level5WarpDataTable+$10,x
	and #$F8
	sta Level5ExitArea
	lda Level5WarpDataTable+$10,x
	and #$07
	ora #$80
	sta Level5ExitMode
HandlePlayerMovementX_Level5Exit:
	rts
HandlePlayerMovementX_Level5Elevator:
	;Setup player entrance
	lda Level5ExitArea
	sta CurArea
	lda Level5ExitMode
	sta LevelLoadMode
	lda #$00
	sta Level5ExitElevator
	rts
Level5WarpDataTable:
	.db $00,$00,$00,$00,$51,$51,$70,$70,$00,$00,$00,$00,$00,$18,$51,$00
	.db $00,$00,$00,$00,$34,$34,$00,$00,$00,$00,$00,$00,$00,$00,$44,$00
	.db $00,$00,$51,$51,$55,$55,$55,$55,$00,$00,$00,$00,$78,$18,$51,$00
	.db $00,$00,$24,$24,$14,$14,$2C,$2C,$00,$00,$00,$00,$00,$00,$44,$00
	.db $49,$49,$6C,$6C,$49,$49,$59,$59,$59,$00,$00,$00,$00,$49,$3C,$00
	.db $10,$10,$00,$00,$30,$30,$34,$34,$44,$00,$00,$00,$00,$20,$00,$00
	.db $00,$00,$4D,$4D,$00,$00,$4D,$4D,$60,$00,$00,$00,$00,$49,$3C,$00
	.db $00,$00,$08,$08,$00,$00,$28,$28,$00,$00,$00,$00,$00,$20,$00,$00

HandlePlayerRunning:
	;Check if Blinky/Dead-Eye is in special state
	lda Enemy_Temp0
	and #$87
	beq HandlePlayerRunning_NoSpecial
	;Check if Blinky is in special state
	bmi HandlePlayerRunning_Blinky
	;If player climbing wall, exit early
	and #$06
	bne HandlePlayerRunning_WallExit
	;Check if camera is tracking player Y
	lda AreaScrollFlags
	cmp #$01
	beq HandlePlayerRunning_Scroll
	;If player Y velocity $F9, exit early (enemy)
	lda Enemy_YVelHi
	cmp #$F9
	bne HandlePlayerRunning_NoSpecial
	rts
HandlePlayerRunning_Scroll:
	;If player Y velocity $F9, exit early (scroll)
	lda ScrollYVelHi
	cmp #$F9
	bne HandlePlayerRunning_NoSpecial
HandlePlayerRunning_WallExit:
	rts
HandlePlayerRunning_Blinky:
	;Clear player X acceleration
	lda #$00
	sta $15
	;Check for LEFT press
	lda JoypadCur
	and #JOY_LEFT
	bne HandlePlayerRunning_BlinkyLeft
	;Check for RIGHT press
	lda JoypadCur
	and #JOY_RIGHT
	beq HandlePlayerRunning_BlinkyExit
	;If player X velocity $02, don't set player X acceleration
	lda $13
	cmp #$02
	beq HandlePlayerRunning_RightP
	;Set player X acceleration right
	lda #$20
	sta $15
	bne HandlePlayerRunning_RightP
HandlePlayerRunning_BlinkyLeft:
	;If player X velocity $FE, don't set player X acceleration
	lda $13
	cmp #$FE
	beq HandlePlayerRunning_LeftP
	;Set player X acceleration left
	lda #$E0
	sta $15
	bne HandlePlayerRunning_LeftP
HandlePlayerRunning_NoSpecial:
	;If player ducking/charging, decelerate player
	lda Enemy_Temp2
	and #$A0
	bne HandlePlayerRunning_None
	;Get player X velocity shifted left 2 bits
	lda $13
	sta $00
	lda $14
	sta $01
	asl $01
	rol $00
	asl $01
	rol $00
	;Check for RIGHT press
	lda JoypadCur
	and #JOY_RIGHT
	bne HandlePlayerRunning_RightCheck
	;Check for LEFT press
	lda JoypadCur
	and #JOY_LEFT
	beq HandlePlayerRunning_None
	;Check if enemy is grabbing player
	ldy EnemyGrabbingMode
	beq HandlePlayerRunning_LeftNoGrab
	;Check for player X velocity right
	lda $00
	bpl HandlePlayerRunning_Left
	;If player X velocity << 2 = $FD, clear player X acceleration
	cmp #$FD
	bcc HandlePlayerRunning_ClearX
	bcs HandlePlayerRunning_Left
HandlePlayerRunning_LeftNoGrab:
	;Check for player X velocity right
	lda $00
	bpl HandlePlayerRunning_Left
	;If player X velocity << 2 = $F9, clear player X acceleration
	cmp #$F9
	bcc HandlePlayerRunning_ClearX
HandlePlayerRunning_Left:
	;Set player X acceleration left
	lda #$C0
	sta $15
HandlePlayerRunning_LeftP:
	;Flip player X
	lda Enemy_Props
	ora #$40
	sta Enemy_Props
HandlePlayerRunning_BlinkyExit:
	rts
HandlePlayerRunning_RightCheck:
	;Check if enemy is grabbing player
	ldy EnemyGrabbingMode
	beq HandlePlayerRunning_RightNoGrab
	;Check for player X velocity left
	lda $00
	bmi HandlePlayerRunning_Right
	;If player X velocity << 2 = $04, clear player X acceleration
	cmp #$04
	bcs HandlePlayerRunning_ClearX
	bcc HandlePlayerRunning_Right
HandlePlayerRunning_RightNoGrab:
	;Check for player X velocity left
	lda $00
	bmi HandlePlayerRunning_Right
	;If player X velocity << 2 = $08, clear player X acceleration
	cmp #$08
	bcs HandlePlayerRunning_ClearX
HandlePlayerRunning_Right:
	;Set player X acceleration right
	lda #$40
	sta $15
HandlePlayerRunning_RightP:
	;Don't flip player X
	lda Enemy_Props
	and #$BF
	sta Enemy_Props
	rts
HandlePlayerRunning_None:
	;If player X velocity 0, clear player X acceleration
	lda $13
	ora $14
	beq HandlePlayerRunning_ClearX
	;Check for player X velocity left
	lda $13
	bmi HandlePlayerRunning_IceRightCheck
	;Check for level 3
	lda CurLevel
	cmp #$02
	beq HandlePlayerRunning_IceLeft
	;Set player X acceleration left
	lda #$C0
	sta $15
	rts
HandlePlayerRunning_IceLeft:
	;Set player X acceleration left (ice)
	lda #$F8
	sta $15
	rts
HandlePlayerRunning_IceRightCheck:
	;Check for level 3
	lda CurLevel
	cmp #$02
	beq HandlePlayerRunning_IceRight
	;Set player X acceleration right
	lda #$40
	sta $15
	rts
HandlePlayerRunning_IceRight:
	;Set player X acceleration right (ice)
	lda #$08
	sta $15
	rts
HandlePlayerRunning_ClearX:
	;Clear player X acceleration
	lda #$00
	sta $15
	rts

ApplyPlayerXAccel:
	;Check if player accelerating left or right
	lda $15
	bpl ApplyPlayerXAccel_Right
	dec $13
ApplyPlayerXAccel_Right:
	;Apply player X acceleration
	lda $14
	clc
	adc $15
	sta $14
	lda $13
	adc #$00
	sta $13
	rts

HandlePlayerSpecialMoveX:
	;Get left and right screens based on area scroll direction
	ldy CurArea
	iny
	lda AreaDirectionFlags
	and #$01
	bne HandlePlayerSpecialMoveX_Back
	;Get left and right screens (forward)
	lda (LevelAreaInfoPointer),y
	sta $02
	iny
	iny
	iny
	iny
	lda (LevelAreaInfoPointer),y
	sta $03
	jmp HandlePlayerSpecialMoveX_NoBack
HandlePlayerSpecialMoveX_Back:
	;Get left and right screens (backward)
	lda (LevelAreaInfoPointer),y
	sta $03
	iny
	iny
	iny
	iny
	lda (LevelAreaInfoPointer),y
	sta $02
HandlePlayerSpecialMoveX_NoBack:
	;Check if player X velocity right
	dec $02
	lda $13
	clc
	adc PlatformXVel
	bpl HandlePlayerSpecialMoveX_Right
	;If current screen = left screen, set scroll flags for left side of level
	clc
	adc TempMirror_PPUSCROLL_X
	lda CurScreen
	sbc #$00
	cmp $02
	bne HandlePlayerSpecialMoveX_Exit
	;Set scroll flags for left side of level
	lda #$C0
	bne HandlePlayerSpecialMoveX_SetX
HandlePlayerSpecialMoveX_Right:
	;If current screen = right screen, set scroll flags for right side of level
	clc
	adc TempMirror_PPUSCROLL_X
	lda CurScreen
	adc #$00
	cmp $03
	bne HandlePlayerSpecialMoveX_Exit
	;Set scroll flags for right side of level
	lda #$C2
HandlePlayerSpecialMoveX_SetX:
	sta AreaScrollFlags
	;Set player X velocity/acceleration
	lda $13
	sta Enemy_XVelHi
	lda $14
	sta Enemy_XVelLo
	lda $15
	sta Enemy_XAccel
	;Clear player X velocity/acceleration
	lda #$00
	sta $14
	sta $15
	;Subtract scroll X position from player X velocity
	sec
	sbc TempMirror_PPUSCROLL_X
	sta $13
HandlePlayerSpecialMoveX_Exit:
	rts

HandlePlayerCollisionX:
	;If jumping on floating log, exit early
	lda FloatingLogJumpFlag
	bne HandlePlayerSpecialMoveX_Exit
	;If lava worm is grabbing player, exit early
	lda LavaWormGrabFlag
	bne HandlePlayerSpecialMoveX_Exit
	;Clear death collision type counter
	ldx #$00
	stx $04
	;Handle collision right
	jsr HandlePlayerCollisionRight
	;Handle collision left
	ldx #$00
	jsr HandlePlayerCollisionLeft
	;If death collision type on both sides, kill player
	lda $04
	cmp #$02
	bne HandlePlayerSpecialMoveX_Exit
	;Kill player
	lda #$80
	jmp CheckEnemyCollision_SetDamage

HandlePlayerCollisionRight:
	;Get collision type right
	jsr GetCollisionTypeRight
	;If nonsolid collision type, exit early
	beq HandlePlayerSpecialMoveX_Exit
	;If death collision type, increment death collision type counter
	sta $08
	and #$04
	beq HandlePlayerCollisionRight_NoDeath
	;Increment death collision type counter
	inc $04
HandlePlayerCollisionRight_NoDeath:
	;If solid collision type, update player X position accordingly
	lda $08
	and #$02
	bne HandlePlayerCollisionRight_Solid
	;If not semisolid collision type, exit early
	lda $08
	lsr
	bcc HandlePlayerSpecialMoveX_Exit
	;If level 3/5, treat semisolid collision type as solid collision type
	lda CurLevel
	cmp #$02
	beq HandlePlayerCollisionRight_Solid
	cmp #$04
	bne HandlePlayerSpecialMoveX_Exit
HandlePlayerCollisionRight_Solid:
	;If player X velocity right, clear player X velocity/acceleration
	lda $13
	clc
	adc PlatformXVel
	bmi HandlePlayerCollisionRight_NoClearX
	;Clear player X velocity/acceleration
	lda #$00
	sta $14
	sta $13
	sta $15
HandlePlayerCollisionRight_NoClearX:
	;If player HP 0, exit early
	lda Enemy_HP
	beq HandlePlayerCollisionRight_WallExit
	;If Dead-Eye not in special state, don't grab wall
	lda Enemy_Temp0
	lsr
	bcc HandlePlayerCollisionRight_NoGrab
	;If player facing left, don't grab wall
	lda Enemy_Props
	and #$40
	bne HandlePlayerCollisionRight_NoGrab
	;Setup player grabbing wall
	jsr StartPlayerGrabWall
HandlePlayerCollisionRight_NoGrab:
	;Check if camera is tracking player X
	lda AreaScrollFlags
	bne HandlePlayerCollisionRight_Enemy
	;Check for level 4 ships area (area 2)
	lda LevelAreaNum
	cmp #$32
	beq HandlePlayerCollisionRight_Scroll
	;Check for level 2 big rolling ball area
	cmp #$17
	bne HandlePlayerCollisionRight_ScrollNoIRQ
HandlePlayerCollisionRight_Scroll:
	;Get IRQ buffer index at collision Y position
	ldy $07
	bmi HandlePlayerCollisionRight_ScrollNoIRQ
	;Adjust player X position for collision
	lda TempIRQBufferScrollX,y
	clc
	adc Enemy_X
	clc
	adc Enemy_CollWidth
	and #$F8
	sec
	sbc Enemy_CollWidth
	sec
	sbc Enemy_X
	sec
	sbc TempIRQBufferScrollX,y
	sta $13
	clc
	adc TempMirror_PPUSCROLL_X
	sta TempMirror_PPUSCROLL_X
	;Set wall in front flag
	jmp HandlePlayerCollisionRight_SetWall
HandlePlayerCollisionRight_ScrollNoIRQ:
	;Adjust player X position for collision
	lda TempMirror_PPUSCROLL_X
	sta $00
	clc
	adc Enemy_X
	clc
	adc Enemy_CollWidth
	and #$F8
	sec
	sbc Enemy_CollWidth
	sec
	sbc Enemy_X
	sta TempMirror_PPUSCROLL_X
	sec
	sbc $00
	sta $13
HandlePlayerCollisionRight_SetWall:
	;Set wall in front flag
	lda AreaDirectionFlags
	ora #$80
	sta AreaDirectionFlags
HandlePlayerCollisionRight_WallExit:
	rts
HandlePlayerCollisionRight_Enemy:
	;Adjust player X position for collision
	jsr GetClipPlayerXOffs
	lda Enemy_X
	sta $01
	clc
	adc Enemy_CollWidth
	clc
	adc $00
	and #$F8
	sec
	sbc $00
	sec
	sbc Enemy_CollWidth
	sta Enemy_X
	;If player X position >= $F8, reset player X position
	cmp #$F8
	bcc HandlePlayerCollisionRight_NoResetX
	;Reset player X position
	lda $01
	sta Enemy_X
HandlePlayerCollisionRight_NoResetX:
	;Check for level 7 crusher areas
	lda LevelAreaNum
	and #$7C
	cmp #$60
	bne HandlePlayerCollisionRight_Exit
	;Check for moving in mode
	lda BGAnimMode
	cmp #$03
	bne HandlePlayerCollisionRight_Exit
	;If Blinky not in special state, move player left $04
	lda Enemy_Temp0
	bpl HandlePlayerCollisionRight_CrusherLeft
	;Get collision type top
	lda Enemy_X
	sta $00
	lda Enemy_Y
	sec
	sbc Enemy_CollHeight
	sta $01
	jsr GetCollisionType
	;If solid tile at top, move player left $04
	beq HandlePlayerCollisionRight_CrusherLeft
	;Move player down $04
	lda Enemy_Y
	clc
	adc #$04
	sta Enemy_Y
HandlePlayerCollisionRight_CrusherLeft:
	;Move player left $04
	lda Enemy_X
	sec
	sbc #$04
	sta Enemy_X
HandlePlayerCollisionRight_Exit:
	rts

HandlePlayerCollisionLeft:
	;Get collision type left
	jsr GetCollisionTypeLeft
	;If nonsolid collision type, exit early
	beq HandlePlayerCollisionRight_Exit
	;If death collision type, increment death collision type counter
	sta $08
	and #$04
	beq HandlePlayerCollisionLeft_NoDeath
	;Increment death collision type counter
	inc $04
HandlePlayerCollisionLeft_NoDeath:
	;If solid collision type, update player X position accordingly
	lda $08
	and #$02
	bne HandlePlayerCollisionLeft_Solid
	;If not semisolid collision type, exit early
	lda $08
	lsr
	bcc HandlePlayerCollisionRight_Exit
	;If level 3/5, treat semisolid collision type as solid collision type
	lda CurLevel
	cmp #$02
	beq HandlePlayerCollisionLeft_Solid
	cmp #$04
	bne HandlePlayerCollisionRight_Exit
HandlePlayerCollisionLeft_Solid:
	;If player X velocity left, clear player X velocity/acceleration
	lda $13
	clc
	adc PlatformXVel
	bpl HandlePlayerCollisionLeft_NoClearX
	;Clear player X velocity/acceleration
	lda #$00
	sta $14
	sta $13
	sta $15
HandlePlayerCollisionLeft_NoClearX:
	;If player HP 0, exit early
	lda Enemy_HP
	beq HandlePlayerCollisionRight_Exit
	;If Dead-Eye not in special state, don't grab wall
	lda Enemy_Temp0
	lsr
	bcc HandlePlayerCollisionLeft_NoGrab
	;If player facing right, don't grab wall
	lda Enemy_Props
	and #$40
	beq HandlePlayerCollisionLeft_NoGrab
	;Setup player grabbing wall
	jsr StartPlayerGrabWall
HandlePlayerCollisionLeft_NoGrab:
	;Check if camera is tracking player X
	lda AreaScrollFlags
	bne HandlePlayerCollisionLeft_Enemy
	;Check for level 4 ships area (area 2)
	lda LevelAreaNum
	cmp #$32
	beq HandlePlayerCollisionLeft_Scroll
	;Check for level 2 big rolling ball area
	cmp #$17
	bne HandlePlayerCollisionLeft_ScrollNoIRQ
HandlePlayerCollisionLeft_Scroll:
	;Get IRQ buffer index at collision Y position
	ldy $07
	bmi HandlePlayerCollisionLeft_ScrollNoIRQ
	;Adjust player X position for collision
	lda TempIRQBufferScrollX,y
	sec
	sbc Enemy_X
	sec
	sbc Enemy_CollWidth
	and #$F8
	clc
	adc Enemy_CollWidth
	clc
	adc Enemy_X
	clc
	adc #$07
	sec
	sbc TempIRQBufferScrollX,y
	sta $13
	clc
	adc TempMirror_PPUSCROLL_X
	sta TempMirror_PPUSCROLL_X
	;Set wall in front flag
	jmp HandlePlayerCollisionRight_SetWall
HandlePlayerCollisionLeft_ScrollNoIRQ:
	;Adjust player X position for collision
	lda TempMirror_PPUSCROLL_X
	sta $00
	sec
	sbc Enemy_X
	sec
	sbc Enemy_CollWidth
	and #$F8
	clc
	adc Enemy_CollWidth
	clc
	adc Enemy_X
	clc
	adc #$07
	sta TempMirror_PPUSCROLL_X
	sec
	sbc $00
	sta $13
	;Set wall in front flag
	jmp HandlePlayerCollisionRight_SetWall
HandlePlayerCollisionLeft_Enemy:
	;Adjust player X position for collision
	jsr GetClipPlayerXOffs
	lda Enemy_X
	sta $01
	sec
	sbc Enemy_CollWidth
	sec
	sbc $00
	and #$F8
	clc
	adc $00
	clc
	adc Enemy_CollWidth
	clc
	adc #$07
	sta Enemy_X
	;If player X position < $08, reset player X position
	cmp #$08
	bcs HandlePlayerCollisionLeft_NoResetX
	;Reset player X position
	lda $01
	sta Enemy_X
HandlePlayerCollisionLeft_NoResetX:
	;Check for level 7 crusher areas
	lda LevelAreaNum
	and #$7C
	cmp #$60
	bne HandlePlayerCollisionLeft_Exit
	;Check for moving out mode
	lda BGAnimMode
	cmp #$01
	bne HandlePlayerCollisionLeft_Exit
	;Move player right $04
	lda Enemy_X
	clc
	adc #$04
	sta Enemy_X
HandlePlayerCollisionLeft_Exit:
	rts

GetClipPlayerXOffs:
	;Check if IRQ buffer collision handling enabled
	lda IRQBufferCollisionFlag
	beq GetClipPlayerXOffs_NoIRQ
	;Get IRQ buffer index at collision Y position
	ldy $07
	bmi GetClipPlayerXOffs_NoIRQ
	;Get clip player X offset based on scroll X position
	lda TempIRQBufferScrollX,y
	and #$07
	sta $00
	rts
GetClipPlayerXOffs_NoIRQ:
	;Get clip player X offset based on scroll X position
	lda TempMirror_PPUSCROLL_X
	and #$07
	sta $00
	rts

HandlePlayerScrolling:
	;If scrolling is disabled, exit early
	lda ScrollDisableFlag
	bne HandlePlayerCollisionLeft_Exit
	;If in middle of level, exit early
	lda AreaScrollFlags
	bpl HandlePlayerCollisionLeft_Exit
	;Check for scroll mode change delay flag
	and #$40
	beq HandlePlayerScrolling_Side
	;Clear scroll mode change delay flag
	lda AreaScrollFlags
	and #$BF
	sta AreaScrollFlags
	rts
HandlePlayerScrolling_Side:
	;Check for left side of level
	lda AreaScrollFlags
	cmp #$80
	beq HandlePlayerScrolling_Left
	;Check for top side of level
	cmp #$81
	beq HandlePlayerScrolling_Top
	;Check for right side of level
	cmp #$82
	beq HandlePlayerScrolling_Right
	;Check for bottom side of level
	cmp #$83
	beq HandlePlayerScrolling_Bottom
	rts
HandlePlayerScrolling_Left:
	;If player X position >= $80, setup scroll for middle of horizontal level
	lda Enemy_X
	bmi HandlePlayerScrolling_SetX
	rts
HandlePlayerScrolling_Right:
	;If player X position < $80, setup scroll for middle of horizontal level
	lda Enemy_X
	bmi HandlePlayerScrolling_Exit
HandlePlayerScrolling_SetX:
	;Set player X position $80
	lda #$80
	sta Enemy_X
	;Copy enemy X velocity/acceleration to scroll X velocity/acceleration
	lda Enemy_XVelHi
	sta ScrollXVelHi
	lda Enemy_XVelLo
	sta ScrollXVelLo
	lda Enemy_XAccel
	sta ScrollXAccel
	;Set scroll flags for middle of horizontal level
	lda #$00
	sta AreaScrollFlags
	;Clear player X velocity/acceleration (enemy)
	sta Enemy_XVelHi
	sta Enemy_XVelLo
	sta Enemy_XAccel
	rts
HandlePlayerScrolling_Top:
	;If player Y position >= $80 and < $C0, setup scroll for middle of vertical level
	lda Enemy_Y
	bpl HandlePlayerScrolling_Exit
HandlePlayerScrolling_BottomCheck:
	cmp #$C0
	bcs HandlePlayerScrolling_Exit
	;Set scroll direction down
	lda #$00
	sta ScrollDirectionFlag
	;Set player Y position $80
	lda #$80
	bne HandlePlayerScrolling_SetY
HandlePlayerScrolling_Bottom:
	;Check if scrolling up or down
	lda ScrollDirectionFlag
	beq HandlePlayerScrolling_Down
	;If player Y position >= $80 and < $C0, setup scroll for middle of vertical level
	lda Enemy_Y
	bmi HandlePlayerScrolling_BottomCheck
HandlePlayerScrolling_Down:
	;If player Y position < $50, setup scroll for middle of vertical level
	lda Enemy_Y
	cmp #$50
	bcs HandlePlayerScrolling_Exit
	;If area scroll direction is backward or wall is in front of player, exit early
	lda AreaDirectionFlags
	beq HandlePlayerScrolling_Exit
	;Set scroll direction up
	lda #$01
	sta ScrollDirectionFlag
	;Set player Y position $50
	lda #$50
HandlePlayerScrolling_SetY:
	sta Enemy_Y
	;Set scroll flags for middle of vertical level
	lda #$01
	sta AreaScrollFlags
	;Copy enemy Y velocity/acceleration to scroll Y velocity/acceleration
	lda Enemy_YVelHi
	sta ScrollYVelHi
	lda #$00
	sta ScrollYVelLo
	lda Enemy_YAccel
	sta ScrollYAccel
	;Clear player Y velocity/acceleration (enemy)
	lda #$00
	sta Enemy_YVelHi
	sta Enemy_YVelLo
	sta Enemy_YAccel
HandlePlayerScrolling_Exit:
	rts

;$00: Bucky
PlayerSpecial_Bucky:
	;Get current power
	lda CharacterPowerCur
	;Clear current power
	ldy #$00
	sty CharacterPowerCur
	;Set player Y velocity based on current power
	lsr
	lsr
	tax
	ldy PlayerSpecialBuckyYVel,x
	;Check if camera is tracking player Y
	lda AreaScrollFlags
	cmp #$01
	beq PlayerSpecial_Bucky_Scroll
PlayerSpecial_Bucky_Enemy:
	;Set player Y velocity/acceleration (enemy)
	sty Enemy_YVelHi
	lda #$C0
	sta Enemy_YVelLo
	lda #$7F
	sta Enemy_YAccel
	;Setup player jump
	jmp HandlePlayerJumping_NoDown
PlayerSpecial_Bucky_Scroll:
	;Set player Y velocity/acceleration (scroll)
	sty ScrollYVelHi
	lda #$C0
	sta ScrollYVelLo
	lda #$7F
	sta ScrollYAccel
	;Setup player jump
	jmp HandlePlayerJumping_NoDown
	rts
PlayerSpecialBuckyYVel:
	.db $F8,$F8,$F8,$F7,$F7,$F7,$F6,$F6,$F6,$F5
;$02: Dead-Eye
PlayerSpecial_DeadEye:
	;Check for level 3 gray pipe area
	lda LevelAreaNum
	cmp #$27
	beq PlayerSpecial_DeadEye_NoClimb
	;Check for level 6 ceiling spikes area
	cmp #$54
	beq PlayerSpecial_DeadEye_NoClimb
	;Check for level 7 rotating room areas
	cmp #$67
	bcc PlayerSpecial_DeadEye_Climb
	cmp #$6B
	bcc PlayerSpecial_DeadEye_NoClimb
PlayerSpecial_DeadEye_Climb:
	;Set player climbing wall state flag
	lda Enemy_Temp0
	ora #$01
	sta Enemy_Temp0
	;Clear wall grab cooldown timer
	lda #$00
	sta GrabWallCooldownTimer
PlayerSpecial_DeadEye_NoClimb:
	;Set player Y velocity
	ldy #$F8
	;Check if camera is tracking player Y
	lda AreaScrollFlags
	cmp #$01
	beq PlayerSpecial_Bucky_Scroll
	bne PlayerSpecial_Bucky_Enemy
;$01: Jenny
PlayerSpecial_Jenny:
	;Play sound
	ldy #SE_JENNYLTBALL
	jsr LoadSound
	;Set player Y velocity/acceleration
	lda #$FF
	sta Enemy_YVelHi+$0F
	lda #$20
	sta Enemy_YAccel+$0F
	;Set Jenny light ball special state flag
	lda Enemy_Temp2
	ora #$04
	sta Enemy_Temp2
	;Mask joypad bits
	jmp MaskJoypadBits
;$03: Blinky
PlayerSpecial_Blinky:
	;Play sound
	ldy #SE_BLINKYFLY
	jsr LoadSound
	;Set Blinky special state flag
	lda Enemy_Temp0
	ora #$80
	sta Enemy_Temp0
	;Check if camera is tracking player Y
	lda AreaScrollFlags
	cmp #$01
	beq PlayerSpecial_Blinky_Scroll
	;Set player Y velocity/acceleration (enemy)
	lda #$FF
	sta Enemy_YVelHi
	lda #$00
	sta Enemy_YVelLo
	lda #$20
	sta Enemy_YAccel
	bne PlayerSpecial_Blinky_NoScroll
PlayerSpecial_Blinky_Scroll:
	;Set player Y velocity/acceleration (scroll)
	lda #$FF
	sta ScrollYVelHi
	lda #$00
	sta ScrollYVelLo
	lda #$20
	sta ScrollYAccel
PlayerSpecial_Blinky_NoScroll:
	;Set player jumping flag
	lda Enemy_Temp2
	ora #$10
	sta Enemy_Temp2
	;Set player animation
	ldx #$00
	ldy #$60
	jsr SetEnemyAnimation
	;Play sound
	ldy #SE_JUMP
	jmp LoadSound
;$04: Willy
PlayerSpecial_Willy:
	;End player special
	jsr HandlePlayerSpecial_End
	;Handle player shooting
	jsr PlayerShoot_Willy
	;Play sound
	ldy #SE_WILLYSHOOT
	jsr LoadSound
	;Get current power
	lda CharacterPowerCur+4
	;Clear current power
	ldy #$00
	sty CharacterPowerCur+4
	;Set enemy power/animation based on current power
	lsr
	lsr
	tax
	lda PlayerSpecialWillyPower,x
	ldy PlayerSpecialWillyAnim,x
	ldx #$0D
	sta Enemy_Temp4,x
	jmp SetEnemyAnimation
PlayerSpecialWillyAnim:
	.db $1E,$1E,$1E,$6C,$6C,$6C,$6E,$6E,$6E,$70
PlayerSpecialWillyPower:
	.db $02,$04,$04,$08,$08,$10,$10,$10,$20,$20

;$00: Bucky
PlayerShoot_Bucky:
	;Find free slot for projectile
	ldx #$0D
	lda Enemy_Flags+$0D
	beq PlayerShoot_Bucky_Spawn
	inx
	lda Enemy_Flags+$0E
	beq PlayerShoot_Bucky_Spawn
	inx
	lda Enemy_Flags+$0F
	bne PlayerShoot_Bucky_Exit
PlayerShoot_Bucky_Spawn:
	;Play sound
	ldy #SE_PLAYERSHOOT1
	jsr LoadSound
	;Set player shoot cooldown timer
	lda #$04
	sta Enemy_Temp1
	;Set projectile position/animation
	ldy #$1A
	jsr PlayerShootSetPos
	;Set enemy ID to player fire
	lda #ENEMY_PLAYERFIRE
	sta Enemy_ID,x
	;Clear enemy
	jsr ClearEnemy
	;Set projectile power
	lda #$01
	sta Enemy_Temp4,x
	;Check if player is jumping
	lda Enemy_Temp2
	and #$10
	beq PlayerShoot_Bucky_NoJump
	;Check for DOWN press
	lda JoypadCur
	and #JOY_DOWN
	bne PlayerShoot_Bucky_ShootDown
	beq PlayerShoot_Bucky_NoUpDown
PlayerShoot_Bucky_NoJump:
	;Check for UP press
	lda JoypadCur
	and #JOY_UP
	bne PlayerShoot_Bucky_ShootUp
PlayerShoot_Bucky_NoUpDown:
	;Check if player is facing left or right
	lda Enemy_Props
	and #$40
	bne PlayerShoot_Bucky_Left
	;Set projectile X velocity right
	lda #$06
	bne PlayerShoot_Bucky_SetX
PlayerShoot_Bucky_Left:
	;Set projectile X velocity left
	lda #$FA
PlayerShoot_Bucky_SetX:
	clc
	adc PlatformXVel
	sta Enemy_XVelHi,x
	rts
PlayerShoot_Bucky_ShootUp:
	;Check for LEFT/RIGHT press
	lda JoypadCur
	and #(JOY_LEFT|JOY_RIGHT)
	bne PlayerShoot_Bucky_NoUpDown
	;Check if camera is tracking player X
	lda AreaScrollFlags
	bne PlayerShoot_Bucky_Enemy
	lda ScrollDisableFlag
	bne PlayerShoot_Bucky_Enemy
	;If player X velocity not 0, don't shoot up (scroll)
	lda ScrollXVelHi
	beq PlayerShoot_Bucky_Up
	bne PlayerShoot_Bucky_NoUpDown
PlayerShoot_Bucky_Enemy:
	;If player X velocity not 0, don't shoot up (enemy)
	lda Enemy_XVelHi
	ora Enemy_XVelLo
	bne PlayerShoot_Bucky_NoUpDown
PlayerShoot_Bucky_Up:
	;Set projectile Y velocity up
	lda #$FA
PlayerShoot_Bucky_SetY:
	sta Enemy_YVelHi,x
	;Set projectile X velocity
	lda Enemy_X
	sta Enemy_X,x
PlayerShoot_Bucky_Exit:
	rts
PlayerShoot_Bucky_ShootDown:
	;Check for level 1 waterfall area
	lda LevelAreaNum
	cmp #$03
	beq PlayerShoot_Bucky_NoUpDown
	;If player in gravity area, don't shoot down
	lda GravityAreaMode
	bne PlayerShoot_Bucky_NoUpDown
	;Set projectile Y velocity down
	lda #$06
	jsr PlayerShoot_Bucky_SetY
	;Load CHR bank
	lda #$55
	sta TempCHRBanks+2
	;Set shooting down flag
	lda Enemy_Temp2
	ora #$40
	sta Enemy_Temp2
	;Set player animation
	ldx #$00
	ldy #$52
	jmp SetEnemyAnimation
;$01: Jenny
PlayerShoot_Jenny:
	;Find free slot for projectile
	ldx #$0D
	lda Enemy_Flags+$0D
	beq PlayerShoot_Jenny_Spawn
	inx
	lda Enemy_Flags+$0E
	bne PlayerShoot_Bucky_Exit
PlayerShoot_Jenny_Spawn:
	;Play sound
	ldy #SE_PLAYERSHOOT2
	jsr LoadSound
	;Set player shoot cooldown timer
	lda #$06
	sta Enemy_Temp1
	;Set projectile position/animation
	ldy #$1E
	jsr PlayerShootSetPos
	;Set enemy ID to player fire
	lda #ENEMY_PLAYERFIRE
	sta Enemy_ID,x
	;Clear enemy
	jsr ClearEnemy
	;Set projectile power
	lda #$01
	sta Enemy_Temp4,x
	;Check if player is facing left or right
	lda Enemy_Props
	and #$40
	bne PlayerShoot_Jenny_Left
	;Set projectile props/velocity right
	sta Enemy_Props,x
	lda #$0E
	jmp PlayerShoot_Bucky_SetX
PlayerShoot_Jenny_Left:
	;Set projectile props/velocity left
	sta Enemy_Props,x
	lda #$F2
	jmp PlayerShoot_Bucky_SetX
;$02: Dead-Eye
PlayerShoot_DeadEye:
	;Play sound
	ldy #SE_PLAYERSHOOT3
	jsr LoadSound
	;Set player shoot cooldown timer
	lda #$10
	sta Enemy_Temp1
	;Spawn projectiles
	ldx #$0D
PlayerShoot_DeadEye_Loop:
	;Set projectile position/animation
	ldy #$1A
	jsr PlayerShootSetPos
	;If projectile Y position >= $C0, clear enemy flags
	lda Enemy_Y,x
	cmp #$C0
	bcc PlayerShoot_DeadEye_NoYC
	;Clear enemy flags
	lda #$00
	sta Enemy_Flags,x
	beq PlayerShoot_DeadEye_Next
PlayerShoot_DeadEye_NoYC:
	;Set enemy ID to player fire
	lda #ENEMY_PLAYERFIRE
	sta Enemy_ID,x
	;Clear enemy
	jsr ClearEnemy
	;Set projectile power
	lda #$01
	sta Enemy_Temp4,x
	;Check if player is facing left or right
	lda Enemy_Props
	and #$40
	bne PlayerShoot_DeadEye_Left
	;Set projectile X velocity right
	lda PlayerShootDeadEyeXVelRight-$0D,x
	bne PlayerShoot_DeadEye_SetX
PlayerShoot_DeadEye_Left:
	;Set projectile X velocity left
	lda PlayerShootDeadEyeXVelLeft-$0D,x
PlayerShoot_DeadEye_SetX:
	clc
	adc PlatformXVel
	sta Enemy_XVelHi,x
	;Set projectile Y velocity
	lda PlayerShootDeadEyeYVel-$0D,x
	sta Enemy_YVelHi,x
PlayerShoot_DeadEye_Next:
	;Loop for each projectile
	inx
	cpx #$10
	bne PlayerShoot_DeadEye_Loop
	rts
PlayerShootDeadEyeYVel:
	.db $04,$00,$FC
PlayerShootDeadEyeXVelLeft:
	.db $FC,$FA,$FC
PlayerShootDeadEyeXVelRight:
	.db $04,$06,$04
;$03: Blinky
PlayerShoot_Blinky:
	;Find free slot for projectile
	ldx #$0E
	lda Enemy_Flags+$0E
	beq PlayerShoot_Blinky_Spawn
	inx
	lda Enemy_Flags+$0F
	bne PlayerShoot_Blinky_Exit
PlayerShoot_Blinky_Spawn:
	;Play sound
	ldy #SE_PLAYERSHOOT1
	jsr LoadSound
	;Set player shoot cooldown timer
	lda #$06
	sta Enemy_Temp1
	;Set projectile position/animation
	ldy #$1A
	jsr PlayerShootSetPos
	;Set enemy ID to Blinky fire
	lda #ENEMY_BLINKYFIRE
	sta Enemy_ID,x
	;Clear enemy
	jsr ClearEnemy
	;Set projectile power
	lda #$01
	sta Enemy_Temp4,x
	;Check if player is facing left or right
	lda Enemy_Props
	and #$40
	bne PlayerShoot_Blinky_Left
	;Don't flip projectile X
	lda #$00
	sta Enemy_Props,x
	;Set projectile X velocity right
	lda #$06
	bne PlayerShoot_Blinky_SetX
PlayerShoot_Blinky_Left:
	;Flip projectile X
	lda #$40
	sta Enemy_Props,x
	;Set projectile X velocity left
	lda #$FA
PlayerShoot_Blinky_SetX:
	clc
	adc PlatformXVel
	sta Enemy_XVelHi,x
PlayerShoot_Blinky_Exit:
	rts
;$04: Willy
PlayerShoot_Willy:
	;Find free slot for projectile
	lda Enemy_Flags+$0D
	bne PlayerShoot_Blinky_Exit
	;Play sound
	ldy #SE_PLAYERSHOOT2
	jsr LoadSound
	;Set player shoot cooldown timer
	lda #$06
	sta Enemy_Temp1
	;Set projectile position/animation
	ldx #$0D
	ldy #$1E
	jsr PlayerShootSetPos
	;Set enemy ID to player fire
	lda #ENEMY_PLAYERFIRE
	sta Enemy_ID,x
	;Clear enemy
	jsr ClearEnemy
	;Set projectile power
	lda #$02
	sta Enemy_Temp4,x
	;Set projectile props
	lda Enemy_Props
	sta Enemy_Props+$0D
	;Check if player is facing left or right
	and #$40
	bne PlayerShoot_Willy_Left
	;Set projectile X velocity right
	lda #$0E
	bne PlayerShoot_Blinky_SetX
PlayerShoot_Willy_Left:
	;Set projectile X velocity left
	lda #$F2
	bne PlayerShoot_Blinky_SetX

PlayerShootSetPos:
	;Set projectile animation
	jsr SetEnemyAnimation
	;If player is ducking, increment shoot offset data index
	ldy CurCharacter
	lda Enemy_Temp2
	bpl PlayerShootSetPos_NoDuck
	;Increment shoot offset data index
	tya
	clc
	adc #$05
	tay
PlayerShootSetPos_NoDuck:
	;Get projectile X offset
	lda NormModePlayerShootXOffsTable,y
	sta $00
	;Set projectile props
	lda Enemy_Props
	sta Enemy_Props,x
	;Check if player is facing left or right
	and #$40
	beq PlayerShootSetPos_Right
	;Negate projectile X offset
	lda $00
	eor #$FF
	clc
	adc #$01
	sta $00
PlayerShootSetPos_Right:
	;Set projectile X position
	lda Enemy_X
	clc
	adc $00
	sta Enemy_X,x
	;Set projectile Y position
	lda Enemy_Y
	clc
	adc NormModePlayerShootYOffsTable,y
	sta Enemy_Y,x
PlayerShootSetPos_Exit:
	rts
NormModePlayerShootXOffsTable:
	.db $07,$02,$0A,$FA,$03
	.db $05,$04,$0A,$00,$03
NormModePlayerShootYOffsTable:
	.db $00,$F4,$00,$F8,$00
	.db $03,$FA,$FF,$FC,$04

HandlePlayerWallClimbing:
	;Clear player Y velocity/acceleration
	lda #$00
	sta $10
	sta $12
	tax
	;Check for A press
	lda JoypadDown
	and #JOY_A
	bne HandlePlayerWallClimbing_Jump
	;Check for UP press
	lda JoypadCur
	and #JOY_UP
	bne HandlePlayerWallClimbing_Up
	;Check for DOWN press
	lda JoypadCur
	and #JOY_DOWN
	beq PlayerShootSetPos_Exit
	;Get collision type front
	jsr GetCollisionTypeFront
	;If nonsolid collision type, exit early
	lda $08
	beq PlayerShootSetPos_Exit
	;If death collision type, exit early
	cmp #$04
	beq PlayerShootSetPos_Exit
	;Get collision type bottom
	jsr GetCollisionTypeBottom
	;If solid tile at bottom, exit early
	bne PlayerShootSetPos_Exit
	;Set player Y velocity
	lda #$02
	sta $10
	;If player climbing wall down, exit early
	lda Enemy_Temp0
	and #$08
	bne PlayerShootSetPos_Exit
	;Set player climbing wall down state flag
	lda Enemy_Temp0
	ora #$08
	sta Enemy_Temp0
	;Set player animation
	ldy #$72
	jmp SetEnemyAnimation
HandlePlayerWallClimbing_Exit:
	rts
HandlePlayerWallClimbing_Up:
	;If player Y position < $14, exit early
	lda Enemy_Y
	cmp #$14
	bcc HandlePlayerWallClimbing_Exit
	;Get collision type front
	jsr GetCollisionTypeFront
	;If nonsolid collision type, exit early
	beq HandlePlayerWallClimbing_Exit
	;If death collision type, exit early
	cmp #$04
	beq HandlePlayerWallClimbing_Exit
	;Get collision type top
	jsr GetCollisionTypeTop
	;If solid tile at top, exit early
	bne HandlePlayerWallClimbing_Exit
	;Set player Y velocity
	lda #$FE
	sta $10
	;If player not climbing wall down, exit early
	lda Enemy_Temp0
	and #$08
	beq HandlePlayerWallClimbing_Exit
	;Clear player climbing wall down state flag
	lda Enemy_Temp0
	and #$F7
	sta Enemy_Temp0
	;Set player animation
	ldy #$54
	jmp SetEnemyAnimation
HandlePlayerWallClimbing_Jump:
	;Clear player climbing wall state flag
	lda Enemy_Temp0
	and #$F5
	sta Enemy_Temp0
	;Flip player X
	lda Enemy_Props
	eor #$40
	sta Enemy_Props
	;Set wall grab cooldown timer
	lda #$04
	sta GrabWallCooldownTimer
	;Setup player jump
	jmp HandlePlayerJumping_NoDown

GetCollisionTypeFront:
	;Check if player is facing left or right
	lda Enemy_Props
	and #$40
	beq GetCollisionTypeFront_Right
	;Get collision type bottom left
	lda Enemy_X
	sec
	sbc #$0C
	sta $00
	bcc GetCollisionTypeFront_Exit
	bcs GetCollisionTypeFront_NoExit
GetCollisionTypeFront_Right:
	;Get collision type bottom right
	lda Enemy_X
	clc
	adc #$0C
	sta $00
	bcs GetCollisionTypeFront_Exit
GetCollisionTypeFront_NoExit:
	lda Enemy_Y
	clc
	adc #$09
	sta $01
	jsr GetCollisionType
	sta $08
	;Get collision type top left or top right
	lda Enemy_Y
	sec
	sbc #$09
	sta $01
	jmp GetCollisionType
GetCollisionTypeFront_Exit:
	lda #$00
	sta $08
	rts

SetJumpYAccel:
	;Clear player Y acceleration
	lda #$00
	sta $12
	;Check for UP press
	lda JoypadCur
	and #JOY_UP
	bne SetJumpYAccel_Up
	;Check for DOWN press
	lda JoypadCur
	and #JOY_DOWN
	beq SetJumpYAccel_Exit
	;If player Y velocity $02, exit early
	lda $10
	cmp #$02
	beq SetJumpYAccel_Exit
	;Set player Y acceleration down
	lda #$40
	sta $12
	rts
SetJumpYAccel_Up:
	;If player Y velocity $FE, exit early
	lda $10
	cmp #$FE
	beq SetJumpYAccel_Exit
	;Set player Y acceleration up
	lda #$C0
	sta $12
SetJumpYAccel_Exit:
	rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;ENEMY BG MOVEMENT ROUTINES;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;
MoveEnemy:
	;Check if enemy accelerating left or right
	lda Enemy_XAccel,x
	bpl MoveEnemy_NoXC
	dec Enemy_XVelHi,x
MoveEnemy_NoXC:
	;Apply enemy acceleration X
	clc
	adc Enemy_XVelLo,x
	sta Enemy_XVelLo,x
	lda Enemy_XVelHi,x
	adc #$00
	sta Enemy_XVelHi,x
	;Apply enemy velocity X
	sec
	sbc ScrollXVelHi
	sec
	sbc PlatformScrollXVel
	sta $00
	lda Enemy_XLo,x
	clc
	adc Enemy_XVelLo,x
	sta Enemy_XLo,x
	lda Enemy_X,x
	adc $00
	sta Enemy_X,x
	;Check if enemy moving left or right
	lda $00
	bmi MoveEnemy_Right
	;Check if enemy is now offscreen (left)
	bcs MoveEnemy_ClearCheck
	bcc MoveEnemy_Y
MoveEnemy_Right:
	;Check if enemy is now offscreen (right)
	bcc MoveEnemy_ClearCheck
MoveEnemy_Y:
	;Check if enemy accelerating up or down
	lda Enemy_YAccel,x
	bpl MoveEnemy_NoYC
	dec Enemy_YVelHi,x
MoveEnemy_NoYC:
	;Apply enemy acceleration Y
	clc
	adc Enemy_YVelLo,x
	sta Enemy_YVelLo,x
	lda Enemy_YVelHi,x
	adc #$00
	sta Enemy_YVelHi,x
	;Apply enemy velocity Y
	sec
	sbc ScrollYVelHi
	sta $00
	lda Enemy_YLo,x
	clc
	adc Enemy_YVelLo,x
	sta Enemy_YLo,x
	lda Enemy_Y,x
	sta $01
	adc $00
	sta Enemy_Y,x
	;Check if enemy is now offscreen
	cmp #$D0
	bcc MoveEnemy_ClearExit
	;Check if enemy was previously offscreen
	lda $01
	cmp #$D0
	bcs MoveEnemy_ClearExit
MoveEnemy_ClearCheck:
	;Check for special offscreen movement flag
	ldy Enemy_ID,x
	lda EnemyMovementFlags,y
	and #$04
	bne MoveEnemy_Special
	;Clear enemy flags
	lda #$00
	sta Enemy_Flags,x
MoveEnemy_ClearExit:
	rts
MoveEnemy_Special:
	;Handle special offscreen movement for enemy $15 (Swinging vine)
	lda Enemy_ID,x
	cmp #ENEMY_SWINGINGVINE
	beq MoveEnemy_15
	;Handle special offscreen movement for enemy $61 (Dark room)
	cmp #ENEMY_DARKROOM
	beq MoveEnemy_61
	;Handle special offscreen movement for enemy $2B (BG fire arch)
	cmp #ENEMY_BGFIREARCH
	beq MoveEnemy_2B
	;Handle special offscreen movement for enemy $41 (BG gray pipe)
	cmp #ENEMY_L2BSEYESBGGRPIPE
	beq MoveEnemy_41
	;Handle special offscreen movement for enemy $33 (BG snake)
	cmp #ENEMY_BGSNAKE
	beq MoveEnemy_33
	;Handle special offscreen movement for enemy $52 (Asteroid)
	cmp #ENEMY_ASTEROID
	beq MoveEnemy_52_54
	;Handle special offscreen movement for enemy $72 (Conveyor platform)
	cmp #ENEMY_CONVEYORPLAT
	beq MoveEnemy_72_75
	;Handle special offscreen movement for enemy $75 (Trooper grabbing)
	cmp #ENEMY_TROOPERGRABBING
	beq MoveEnemy_72_75
	;Handle special offscreen movement for enemy $54 (Vertical ship fire)
	cmp #ENEMY_VERTSHIPFIRE
	beq MoveEnemy_52_54
	;Handle special offscreen movement for enemy $48 (Crater snake)
	cmp #ENEMY_CRATERSNAKE
	beq MoveEnemy_48
	;Handle special offscreen movement for enemy $4B (Crater snake part)
	cmp #ENEMY_CRATERSNAKEPART
	beq MoveEnemy_4B
	;Handle special offscreen movement for enemy $34 (Conveyor platform spawner)
	cmp #ENEMY_BGICEBERGCONVPLAT
	beq MoveEnemy_34
	;Handle special offscreen movement for enemy $2F (Boulder pushable)
	cmp #ENEMY_BOULDERPUSH
	bne MoveEnemy_ClearExit
	jmp MoveEnemy_2F
MoveEnemy_33:
	;If enemy Y position >= $D0, clear enemy flags
	lda Enemy_Y,x
	cmp #$D0
	bcs MoveEnemy_ClearF
	;Apply enemy Y velocity
	clc
	adc Enemy_YVelHi,x
	sta Enemy_Y,x
MoveEnemy_72_75:
	;Toggle enemy visible flag
	lda Enemy_Flags,x
	eor #EF_VISIBLE
MoveEnemy_SetF:
	sta Enemy_Flags,x
MoveEnemy_SetFExit:
	rts
MoveEnemy_61:
	;Set enemy sprite
	lda #$5C
	sta Enemy_SpriteLo,x
	;Toggle enemy visible flag
	jsr MoveEnemy_72_75
	;If enemy visible, exit early
	and #EF_VISIBLE
	bne MoveEnemy_SetFExit
	;Set enemy Y position
	lda Enemy_Y,x
	eor #$20
	bne MoveEnemy_SetY
MoveEnemy_41:
	;Move enemy Y
	jsr MoveEnemy_Y
	;Toggle enemy platform flag
	lda Enemy_Flags,x
	eor #EF_PLATFORM
	bne MoveEnemy_SetF
MoveEnemy_15:
	;Clear enemy flags
	lda #$00
	sta Enemy_Flags+$01,x
	beq MoveEnemy_ClearF
MoveEnemy_2B:
	;If not spawner, exit early
	lda Enemy_Temp2,x
	bne MoveEnemy_Exit
MoveEnemy_ClearF:
	;Clear enemy flags
	lda #$00
	sta Enemy_Flags,x
MoveEnemy_Exit:
	rts
MoveEnemy_52_54:
	;Check for level 4 ships area (area 3)
	lda LevelAreaNum
	lsr
	bcs MoveEnemy_ClearF
	;If enemy Y position >= $D0, clear enemy flags
	lda Enemy_Y,x
	cmp #$D0
	bcs MoveEnemy_ClearF
	rts
MoveEnemy_48:
	;If child slot index set, go to next task ($01: Out)
	ldy Enemy_Temp6,x
	beq MoveEnemy_48NoIndex
	;Next task ($01: Out)
	lda #$01
	sta Enemy_Temp0,y
MoveEnemy_48NoIndex:
	;Clear enemy flags
	jmp MoveEnemy_ClearF
MoveEnemy_4B:
	;Check for init mode
	lda Enemy_Temp0,x
	bne MoveEnemy_48
	;Toggle enemy hit enemy/visible flags
	lda Enemy_Flags,x
	eor #(EF_HITENEMY|EF_VISIBLE)
	sta Enemy_Flags,x
	rts
MoveEnemy_34:
	;Clear enemy flags
	ldy ConveyorPlatSpawnOffscreenIndex-8,x
	lda #$00
	sta Enemy_Flags,x
	sta Enemy_Flags,y
	sta Enemy_Flags+1,y
	rts
MoveEnemy_2F:
	;Check if boulder is platform
	lda Enemy_Flags,x
	and #(EF_PLATFORM|EF_VISIBLE)
	beq MoveEnemy_2FNoPlat
	;Set enemy flags
	lda #(EF_ACTIVE|EF_NOANIM|EF_HITENEMY)
	sta Enemy_Flags,x
	;Save enemy Y position
	lda Enemy_Y,x
	sta Enemy_Temp2,x
	rts
MoveEnemy_2FNoPlat:
	;Set enemy flags
	lda #(EF_ACTIVE|EF_NOANIM|EF_PLATFORM|EF_HITENEMY|EF_VISIBLE)
	sta Enemy_Flags,x
	;Restore enemy Y position
	lda Enemy_Temp2,x
MoveEnemy_SetY:
	sta Enemy_Y,x
	rts
ConveyorPlatSpawnOffscreenIndex:
	.db $01,$03

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;SCROLLING AND BG ANIMATION ROUTINES;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
UpdateOtherGraphics:
	;Check for level 4 minecart area
	lda LevelAreaNum
	cmp #$36
	bne UpdateOtherGraphics_NoMCArea
	;If there's a level scroll update, exit early
	lda ScrollUpdateFlag
	bne MoveEnemy_Exit
	;If there's a palette update, update palette
	lda CurPalette
	bmi UpdatePalette_Set
	;Update HUD
	jmp UpdateHUD
UpdateOtherGraphics_NoMCArea:
	;If there's a level scroll update, exit early
	lda ScrollUpdateFlag
	bne UpdateMetatiles_Exit
	;If bits 0-1 of global timer 0, exit early
	lda LevelGlobalTimer
	and #$03
	beq UpdateMetatiles_Exit
	;If bits 0-1 of global timer $02, update palette
	cmp #$02
	beq UpdatePalette
UpdateOtherGraphics_MetatileCheck:
	;Check if there's a metatile update
	ldy UpdateMetatileCount
	beq UpdateVRAMStrips
	;Update metatiles
	jsr UpdateMetatiles

UpdateMetatiles:
	;If there's not a metatile update, exit early
	ldy UpdateMetatileCount
	beq UpdateMetatiles_Exit
	;Update metatile
	jsr UpdateMetatileSub
	;Decrement number of metatiles to update, check if 0
	dec UpdateMetatileCount
	beq UpdateMetatiles_Exit
	;Copy metatile buffer over one entry
	ldy #$00
UpdateMetatiles_Loop:
	;Copy metatile buffer entry
	lda UpdateMetatilePos+1,y
	sta UpdateMetatilePos,y
	lda UpdateMetatileID+1,y
	sta UpdateMetatileID,y
	lda UpdateMetatileProps+1,y
	sta UpdateMetatileProps,y
	;Loop for each entry
	iny
	cpy UpdateMetatileCount
	bne UpdateMetatiles_Loop
UpdateMetatiles_Exit:
	rts

UpdateVRAMStrips:
	;Check if there's a VRAM strip update
	ldy UpdateVRAMStripCount
	bne UpdateVRAMStrips_Set
	;If in level 7 crusher area, exit early
	lda CrusherAreaFlag
	bne UpdateMetatiles_Exit
	;If not in level 6 dark room area, exit early
	lda LevelAreaNum
	cmp #$55
	bcc UpdatePalette_Set
	cmp #$58
	bcs UpdatePalette_Set
	rts
UpdateVRAMStrips_Set:
	;Update VRAM strip
	jsr UpdateVRAMStripSub
	;Decrement number of VRAM strips to update, check if 0
	dec UpdateVRAMStripCount
	beq UpdateMetatiles_Exit
	;Copy VRAM strip buffer over one entry
	ldy #$00
UpdateVRAMStrips_Loop:
	;Copy VRAM strip buffer entry
	lda UpdateVRAMStripID+1,y
	sta UpdateVRAMStripID,y
	;Loop for each entry
	iny
	cpy UpdateVRAMStripCount
	bne UpdateVRAMStrips_Loop
	rts

UpdateVRAMStripSub:
	;Check for level 6
	lda CurLevel
	cmp #$05
	bne UpdateVRAMStripSub_Set
	;Update BG chute crusher
	jmp DrawBGChuteCrusher
UpdateVRAMStripSub_Set:
	;Update VRAM strip
	lda UpdateVRAMStripID
	jmp WriteVRAMStrip

UpdatePalette:
	;Check if there's a palette update
	lda CurPalette
	bpl UpdateOtherGraphics_MetatileCheck
UpdatePalette_Set:
	;Clear palette update flag
	lda CurPalette
	and #$7F
	sta CurPalette
	;Write palette strip data
	asl
	tax
	jsr WritePaletteStrip6
	;Update metatiles
	jmp UpdateMetatiles
	rts

UpdateScrollAnim:
	;Check for scroll animation mode $F0-$FF
	ldy LevelAreaNum
	lda LevelAreaAnimSetTable,y
	cmp #$F0
	bcs UpdateScrollAnim_Fx
	;Do jump table
	and #$0F
	jsr DoJumpTable
ScrollAnimJumpTable:
	.dw ScrollAnimX0	;$00  Normal gameplay
	.dw ScrollAnimX1	;$01  Level 1 ships
	.dw ScrollAnimX2	;$02  Level 2 fire arches
	.dw ScrollAnimX3	;$03  Level 2/4 vertical scrolling areas
	.dw ScrollAnimX4	;$04  Level 2 volcano
	.dw ScrollAnimX5	;$05  Level 2 big rolling ball area
	.dw ScrollAnimX6	;$06  Level 3 water
	.dw ScrollAnimX7	;$07  Level 7 rotating room
	.dw ScrollAnimX8	;$08  Level 5 big elevator
	.dw ScrollAnimX9	;$09  Level 7 flashing palette
	.dw ScrollAnimXA	;$0A  Level 8 miniboss ship
	.dw ScrollAnimXB	;$0B  Level 4 ships (area 2)
	.dw ScrollAnimXC	;$0C  Level 8 boss
UpdateScrollAnim_Fx:
	;Do jump table
	and #$0F
	jsr DoJumpTable
ScrollAnimFxJumpTable:
	.dw ScrollAnimF0	;$F0  Level 3 iceberg
	.dw ScrollAnimF1	;$F1  Level 3 gray pipes
	.dw ScrollAnimF2	;$F2  Level 3 horizontal ice cave areas
	.dw ScrollAnimF3	;$F3  Level 4 ships (area 3)
	.dw ScrollAnimF4	;$F4  Level 5 hypno Jenny area
	.dw ScrollAnimF5	;$F5  Level 5 hypno Willy area
	.dw ScrollAnimF6	;$F6  Level 6 ceiling spikes
	.dw ScrollAnimF7	;$F7  Level 5 hypno Dead-Eye area
	.dw ScrollAnimF8	;$F8  Level 8 miniboss snake

;$01: Level 1 ships
ScrollAnimX1:
	;Set IRQ buffer scroll speed
	lda #$FF
	sta IRQBufferPlatformXVel+1
	lda #$FE
	sta IRQBufferPlatformXVel+2
	;Get scroll X velocity
	jsr ScrollAnimGetXVel
	;Apply scroll X velocity to scroll position
	inc $00
	ldx #$01
	jsr ScrollAnimApplyXVel
	;Apply scroll X velocity to scroll position
	inc $00
	inx
	jsr ScrollAnimApplyXVel
	;Shift scroll X position 1 bit
	jsr ScrollAnimShiftX1
	sta TempIRQBufferScrollHi+3
	lda $01
	sta TempIRQBufferScrollX+3
	;Shift scroll X position 2 bits
	jsr ScrollAnimShiftX2
	sta TempIRQBufferScrollHi
	lda $01
	sta TempIRQBufferScrollX
	;Set scroll position to master PPU scroll
	ldx #$04
	jmp ScrollAnimGetPPUXPos

;$0B: Level 4 ships (area 2)
ScrollAnimXB:
	;Set IRQ buffer scroll speed
	lda #$FF
	sta IRQBufferPlatformXVel
	lda #$FE
	sta IRQBufferPlatformXVel+1
	;Get scroll X velocity
	jsr ScrollAnimGetXVel
	;Apply scroll X velocity to scroll position
	inc $00
	ldx #$00
	jsr ScrollAnimApplyXVel
	;Apply scroll X velocity to scroll position
	inc $00
	inx
	jsr ScrollAnimApplyXVel
	;Set scroll position to master PPU scroll
	inx
	jmp ScrollAnimGetPPUXPos

;$F3: Level 4 ships (area 3)
ScrollAnimF3:
	;Set IRQ buffer scroll speed
	lda #$FE
	sta IRQBufferPlatformXVel
	sta IRQBufferPlatformXVel+2
	lda #$FD
	sta IRQBufferPlatformXVel+1
	lda #$FF
	sta IRQBufferPlatformXVel+3
	;Get scroll X velocity
	jsr ScrollAnimGetXVel
	;Apply scroll X velocity to scroll position
	inc $00
	ldx #$03
	jsr ScrollAnimApplyXVel
	;Apply scroll X velocity to scroll position
	inc $00
	ldx #$00
	jsr ScrollAnimApplyXVel
	ldx #$02
	jsr ScrollAnimApplyXVel
	;Apply scroll X velocity to scroll position
	inc $00
	ldx #$01
	jmp ScrollAnimApplyXVel

;$0A: Level 8 miniboss ship
ScrollAnimXA:
	;Set scroll position to master PPU scroll
	ldx #$04
	jsr ScrollAnimGetPPUXPos
	;Check if level 8 miniboss ship is active
	lda Enemy_Flags+$01
	beq ScrollAnimXA_BGLoop
	;Loop current screen $42-$43
	lda CurScreen
	cmp #$44
	bne ScrollAnimXA_BGLoop
	lda #$42
	sta CurScreen
ScrollAnimXA_BGLoop:
	;If current screen $4C, load IRQ buffer set
	lda CurScreen
	cmp #$4C
	beq ScrollAnimXA_LoadIRQ
	;If current screen $49, clear level 8 miniboss ship enemies
	cmp #$49
	bne ScrollAnimXA_NoClear
	;Clear level 8 miniboss ship enemies
	lda #$00
	ldx #$08
ScrollAnimXA_ClearFLoop:
	;Clear enemy flags
	sta Enemy_Flags,x
	dex
	;Loop for each enemy
	bne ScrollAnimXA_ClearFLoop
	;Clear scroll update disable flag
	sta ScrollUpdateDisableFlag
	beq ScrollAnimXA_NoClear
ScrollAnimXA_LoadIRQ:
	;Load IRQ buffer set
	ldx #$00
	jsr LoadIRQBufferSet
ScrollAnimXA_NoClear:
	;If bit 0 of global timer 0, do jump table
	lda LevelGlobalTimer
	and #$01
	bne ScrollLevel8MinibossShipFlashPalette_Exit
	;Do jump table
	lda BGAnimMode
	jsr DoJumpTable
ScrollAnimXAJumpTable:
	.dw ScrollAnimXA_Sub00	;$00  Init
	.dw ScrollAnimXA_Sub01	;$01  Intro moving up right
	.dw ScrollAnimXA_Sub02	;$02  Intro moving right
	.dw ScrollAnimXA_Sub03	;$03  Intro shooting troopers
	.dw ScrollAnimXA_Sub04	;$04  Up to middle
	.dw ScrollAnimXA_Sub03	;$05  Top right
	.dw ScrollAnimXA_Sub06	;$06  Top right to top left
	.dw ScrollAnimXA_Sub03	;$07  Top left
	.dw ScrollAnimXA_Sub08	;$08  Top left up
	.dw ScrollAnimXA_Sub09	;$09  Top left to bottom left part 1
	.dw ScrollAnimXA_Sub0A	;$0A  Top left to bottom left part 2
	.dw ScrollAnimXA_Sub03	;$0B  Bottom left
	.dw ScrollAnimXA_Sub0C	;$0C  Bottom left to bottom middle
	.dw ScrollAnimXA_Sub0D	;$0D  Bottom middle moving up
	.dw ScrollAnimXA_Sub03	;$0E  Bottom middle
	.dw ScrollAnimXA_Sub0A	;$0F  Bottom middle moving down
	.dw ScrollAnimXA_Sub10	;$10  Bottom middle to bottom right
	.dw ScrollAnimXA_Sub03	;$11  Bottom right
	.dw ScrollAnimXA_Sub0D	;$12  Bottom right to top right part 1
	.dw ScrollAnimXA_Sub08	;$13  Bottom right to top right part 2
	.dw ScrollAnimXA_Sub14	;$14  Moving left
	.dw ScrollAnimXA_Sub15	;$15  Shooting troopers
	.dw ScrollAnimXA_Sub16	;$16  Defeated falling part 1
	.dw ScrollAnimXA_Sub17	;$17  Defeated falling part 2
	.dw ScrollAnimXA_Sub18	;$18  Defeated falling part 3
	.dw ScrollAnimXA_Sub19	;$19  Defeated off screen
;$16: Defeated falling part 1
ScrollAnimXA_Sub16:
	;Move ship section right $01
	inc TempIRQBufferScrollX+2
	;Flash palette for defeated animation
	jsr ScrollLevel8MinibossShipFlashPalette
	;Move ship down
	jmp ScrollAnimXA_Sub0D
;$17: Defeated falling part 2
ScrollAnimXA_Sub17:
	;Flash palette for defeated animation
	jsr ScrollLevel8MinibossShipFlashPalette
	;If height of blank section above ship $4E, go to next task ($18: Defeated falling part 3)
	lda TempIRQBufferHeight+2
	cmp #$4E
	beq ScrollAnimXA_Sub17_Next
	;Decrement height of ship section
	dec TempIRQBufferHeight+3
	;Increment height of blank section above ship
	inc TempIRQBufferHeight+2
	;Move ship right $01
	inc TempIRQBufferScrollX+2
	rts
ScrollAnimXA_Sub17_Next:
	;Next task ($18: Defeated falling part 3)
	inc BGAnimMode
;$18: Defeated falling part 3
ScrollAnimXA_Sub18:
	;Flash palette for defeated animation
	jsr ScrollLevel8MinibossShipFlashPalette
	;If height of blank section above ship $4D, go to next task ($19: Defeated off screen)
	lda TempIRQBufferHeight+1
	cmp #$4D
	beq ScrollAnimXA_Sub18_Next
	;Decrement height of ship section
	dec TempIRQBufferHeight+3
	;Increment height of blank section above ship
	inc TempIRQBufferHeight+1
	;Move ship right $01
	inc TempIRQBufferScrollX+2
	rts
ScrollAnimXA_Sub18_Next:
	;Next task ($19: Defeated off screen)
	inc BGAnimMode
	;If player HP 0, exit early
	lda Enemy_HP
	beq ScrollLevel8MinibossShipFlashPalette_Exit
	;Clear sound
	jsr ClearSound
	;Play music
	ldy #MUSIC_LEVEL8
	jmp LoadSound
ScrollLevel8MinibossShipFlashPalette:
	;Flash palette for defeated animation
	lda #$D4
	sta CurPalette
ScrollLevel8MinibossShipFlashPalette_Exit:
	rts
;$00: Init
ScrollAnimXA_Sub00:
	;Wait until current screen $43
	lda CurScreen
	cmp #$43
	bne ScrollAnimXA_Sub19
	;Next task ($01: Intro moving up right)
	inc BGAnimMode
	;Set scroll update disable flag
	inc ScrollUpdateDisableFlag
	;If player HP 0, exit early
	lda Enemy_HP
	beq ScrollLevel8MinibossShipFlashPalette_Exit
	;Clear sound
	jsr ClearSound
	;Play music
	ldy #MUSIC_BOSS2
	jmp LoadSound
;$01: Intro moving up right
ScrollAnimXA_Sub01:
	;Decrement height of blank section above ship, check if 0
	dec TempIRQBufferHeight+2
	beq ScrollAnimXA_Sub01_Next
	;Move ship section right $01
	dec TempIRQBufferScrollX+2
	;Increment height of ship section
	inc TempIRQBufferHeight+3
;$19: Defeated off screen
ScrollAnimXA_Sub19:
	;Do nothing
	rts
ScrollAnimXA_Sub01_Next:
	;Reset height to 1
	inc TempIRQBufferHeight+2
	;Next task ($02: Intro moving right)
	inc BGAnimMode
	rts
;$02: Intro moving right
ScrollAnimXA_Sub02:
	;Move ship section right $01, check if 0
	dec TempIRQBufferScrollX+2
	bne ScrollAnimXA_Sub19
	;Reset animation timer and go to next task ($03: Intro shooting troopers)
	lda #$00
	beq ScrollAnimXA_Sub06_SetT
;$03: Intro shooting troopers
;$05: Top right
;$07: Top left
;$0B: Bottom left
;$0E: Bottom middle
;$11: Bottom right
ScrollAnimXA_Sub03:
	;Decrement animation timer, check if 0
	dec BGAnimTimer
	bne ScrollAnimXA_Sub03_Exit
	;Next task
	inc BGAnimMode
ScrollAnimXA_Sub03_Exit:
	rts
;$04: Up to middle
ScrollAnimXA_Sub04:
	;Decrement height of blank section above ship, check if 0
	dec TempIRQBufferHeight+1
	beq ScrollAnimXA_Sub04_Next
	;Increment height of ship section
	inc TempIRQBufferHeight+3
	rts
ScrollAnimXA_Sub04_Next:
	;Reset height to 1
	inc TempIRQBufferHeight+1
	;Draw closed hatch metatiles
	ldy #$02
ScrollAnimXA_Sub04_Loop:
	;Draw metatile
	ldx UpdateMetatileCount
	lda #$01
	sta UpdateMetatileProps,x
	lda #$20
	sta UpdateMetatileID,x
	lda Level8MinibossShipMetatilePos,y
	sta UpdateMetatilePos,x
	inc UpdateMetatileCount
	;Loop for each metatile
	dey
	bpl ScrollAnimXA_Sub04_Loop
	;Play sound
	ldy #SE_CRASH
	jsr LoadSound
	;Clear hatch open flag
	lda #$00
	sta Enemy_Temp3+$06
	sta Enemy_Temp3+$07
	sta Enemy_Temp3+$08
	;Reset animation timer and go to next task ($05: Top right)
	lda #$80
	bne ScrollAnimXA_Sub06_SetT
;$06: Top right to top left
ScrollAnimXA_Sub06:
	;Move ship section left $01
	lda #$20
	sta TempIRQBufferScrollHi+2
	dec TempIRQBufferScrollX+2
	;If ship X position not 0, exit early
	bne ScrollAnimXA_Sub19
	;Reset animation timer
	lda #$40
ScrollAnimXA_Sub06_SetT:
	sta BGAnimTimer
	;Next task
	inc BGAnimMode
	rts
;$08: Top left up
;$13: Bottom right to top right part 2
ScrollAnimXA_Sub08:
	;Decrement height of ship section
	dec TempIRQBufferHeight+3
	;Increment height of blank section above ship, check if $38
	inc TempIRQBufferHeight+1
	lda TempIRQBufferHeight+1
	cmp #$38
	bne ScrollAnimXA_Sub03_Exit
	;Next task
	inc BGAnimMode
ScrollAnimXA_Sub08_Exit:
	rts
;$09: Top left to bottom left part 1
ScrollAnimXA_Sub09:
	;Increment height of ship section
	inc TempIRQBufferHeight+3
	;Decrement height of blank section above ship, check if $01
	dec TempIRQBufferHeight+1
	lda TempIRQBufferHeight+1
	cmp #$01
	bne ScrollAnimXA_Sub08_Exit
	;Next task ($0A: Top left to bottom left part 2)
	inc BGAnimMode
ScrollAnimXA_Sub09_Exit:
	rts
;$0A: Top left to bottom left part 2
;$0F: Bottom middle moving down
ScrollAnimXA_Sub0A:
	;Move ship section up $01
	inc TempIRQBufferHeight+4
	dec TempIRQBufferHeight+2
	;If height of blank section above ship 0, reset blank section
	beq ScrollAnimXA_Sub0A_ResetBlank
	;If height of blank section above ship not $01, exit early
	lda TempIRQBufferHeight+2
	cmp #$01
	bne ScrollAnimXA_Sub09_Exit
	;If ship Y position not $28, exit early
	lda TempIRQBufferScrollY+2
	cmp #$28
	bne ScrollAnimXA_Sub09_Exit
	;Reset animation timer and go to next task
	lda #$00
	beq ScrollAnimXA_Sub06_SetT
ScrollAnimXA_Sub0A_ResetBlank:
	;Set height of blank section above ship $08
	lda #$08
	sta TempIRQBufferHeight+2
	;Decrement height of ship section $08
	lda TempIRQBufferHeight+3
	sec
	sbc #$08
	sta TempIRQBufferHeight+3
	;Move ship section down $08
	lda TempIRQBufferScrollY+2
	clc
	adc #$08
	sta TempIRQBufferScrollY+2
	rts
;$0C: Bottom left to bottom middle
ScrollAnimXA_Sub0C:
	;Move ship right $01
	inc TempIRQBufferScrollX+2
	;If ship X position $C0, go to next task ($0D: Bottom middle moving up)
	lda TempIRQBufferScrollX+2
	cmp #$C0
	bne ScrollAnimXA_Sub09_Exit
	;Next task
	inc BGAnimMode
ScrollAnimXA_Sub0C_Exit:
	rts
;$0D: Bottom middle moving up
;$12: Bottom right to top right part 1
ScrollAnimXA_Sub0D:
	;Decrement height of blank section below ship
	dec TempIRQBufferHeight+4
	;Increment height of blank section above ship
	inc TempIRQBufferHeight+2
	;If height of blank section above ship $09, reset blank section
	lda TempIRQBufferHeight+2
	cmp #$09
	bne ScrollAnimXA_Sub0C_Exit
	;Set height of blank section above ship $01
	lda #$01
	sta TempIRQBufferHeight+2
	;Increment height of ship section $08
	lda TempIRQBufferHeight+3
	clc
	adc #$08
	sta TempIRQBufferHeight+3
	;Move ship section up $08
	lda TempIRQBufferScrollY+2
	sec
	sbc #$08
	sta TempIRQBufferScrollY+2
	bne ScrollAnimXA_Sub0C_Exit
	;Reset animation timer and go to next task
	lda #$40
	bne ScrollAnimXA_Sub06_SetT
;$10: Bottom middle to bottom right
ScrollAnimXA_Sub10:
	;Move ship section right $01
	inc TempIRQBufferScrollX+2
	;If ship X position not $40, exit early
	lda TempIRQBufferScrollX+2
	beq ScrollAnimXA_Sub10_NoXC
	cmp #$40
	bne ScrollAnimXA_Sub10_Exit
	;Reset animation timer
	lda #$40
ScrollAnimXA_Sub10_SetT:
	sta BGAnimTimer
	;Next task
	inc BGAnimMode
	rts
ScrollAnimXA_Sub10_NoXC:
	lda #$24
	sta TempIRQBufferScrollHi+2
ScrollAnimXA_Sub10_Exit:
	rts
;$14: Moving left
ScrollAnimXA_Sub14:
	;Move ship section left $01
	dec TempIRQBufferScrollX+2
	bne ScrollAnimXA_Sub10_Exit
	;Reset animation timer and go to next task ($15: Shooting troopers)
	lda #$80
	bne ScrollAnimXA_Sub10_SetT
;$15: Shooting troopers
ScrollAnimXA_Sub15:
	;Decrement animation timer, check if 0
	dec BGAnimTimer
	bne ScrollAnimXA_Sub10_Exit
	;Next task ($04: Up to middle)
	lda #$04
	sta BGAnimMode
	rts

;$05: Level 2 big rolling ball area
ScrollAnimX5:
	;Check for init mode
	lda BGBallRollMode
	beq ScrollAnimX5_Next
	;Check for right mode
	cmp #$03
	beq ScrollAnimX5_Right
	;Check for end mode
	cmp #$04
	bne ScrollAnimX5_NoEnd
	;Set scroll X position
	lda #$46
	sta TempIRQBufferScrollX
	;Set scroll position to master PPU scroll
	ldx #$01
	jmp ScrollAnimGetPPUXPos
ScrollAnimX5_NoEnd:
	;If current screen $39, go to next task ($04: End)
	lda CurScreen
	cmp #$39
	bne ScrollAnimX5_Left
	;Next task ($04: End)
	lda #$04
	sta BGBallRollMode
	rts
ScrollAnimX5_Left:
	;Set IRQ buffer scroll speed
	lda #$FE
	sta IRQBufferPlatformXVel
	lda #$00
	sta IRQBufferPlatformXVel+1
	;Get scroll X velocity
	jsr ScrollAnimGetXVel
	;Apply scroll X velocity to scroll position
	inc $00
	inc $00
	ldx #$00
	jsr ScrollAnimApplyXVel
	;Set scroll position to master PPU scroll
	inx
	jsr ScrollAnimGetPPUXPos
	;Check if using left or right nametable
	ldx BGBallRollMode
	lda ScrollBallRollScrollHi-1,x
	cmp TempIRQBufferScrollHi
	bne ScrollAnimX0
	;If scroll X position $30-$3F, go to next task
	lda TempIRQBufferScrollX
	cmp #$30
	bcc ScrollAnimX0
	cmp #$40
	bcs ScrollAnimX0
	;Next task
	inc BGBallRollMode
	;Check for right mode
	lda BGBallRollMode
	cmp #$03
	beq ScrollAnimX5_PlaySound

;$00: Normal gameplay
ScrollAnimX0:
	;Do nothing
	rts

ScrollAnimX5_Next:
	;Next task
	inc BGBallRollMode
ScrollAnimX5_PlaySound:
	;Play sound
	ldy #SE_BALLROLL
	jmp LoadSound
ScrollAnimX5_Right:
	;Set IRQ buffer scroll speed
	lda #$02
	sta IRQBufferPlatformXVel
	lda #$00
	sta IRQBufferPlatformXVel+1
	;Get scroll X velocity
	jsr ScrollAnimGetXVel
	;Apply scroll X velocity to scroll position
	dec $00
	dec $00
	ldx #$00
	jsr ScrollAnimApplyXVel
	;Set scroll position to master PPU scroll
	inx
	jsr ScrollAnimGetPPUXPos
	;Check if using right nametable
	lda TempIRQBufferScrollHi
	cmp #$24
	bne ScrollAnimX0
	;If scroll X position $40-$4F, go to next task
	lda TempIRQBufferScrollX
	cmp #$40
	bcc ScrollAnimX0
	cmp #$50
	bcs ScrollAnimX0
	;Next task ($02: Left)
	dec BGBallRollMode
	;Play sound
	jmp ScrollAnimX5_PlaySound
ScrollBallRollScrollHi:
	.db $20,$24

ScrollAnimGetXVel:
	;Check if camera is tracking player X
	lda AreaScrollFlags
	beq ScrollAnimGetXVel_NoScroll
	;Don't apply platform X velocity
	lda #$00
	beq ScrollAnimGetXVel_Scroll
ScrollAnimGetXVel_NoScroll:
	;Apply platform X velocity
	lda PlatformXVel
ScrollAnimGetXVel_Scroll:
	;Add to scroll X velocity
	clc
	adc ScrollXVelHi
	sta $00
	rts

ScrollAnimGetPPUXPos:
	;Set scroll position to master PPU scroll
	lda TempMirror_PPUCTRL
	and #$01
	asl
	asl
	clc
	adc #$20
	sta TempIRQBufferScrollHi,x
	lda TempMirror_PPUSCROLL_X
	sta TempIRQBufferScrollX,x
ScrollAnimGetPPUXPos_Exit:
	rts

ScrollAnimApplyXVel:
	;Apply scroll X velocity to scroll position
	lda TempIRQBufferScrollX,x
	clc
	adc $00
	sta TempIRQBufferScrollX,x
	;Check if scrolling left or right
	lda $00
	bmi ScrollAnimApplyXVel_Left
	;Check for X carry (right)
	bcs ScrollAnimApplyXVel_NoXC
	rts
ScrollAnimApplyXVel_Left:
	;Check for X carry (left)
	bcc ScrollAnimApplyXVel_NoXC
	rts
ScrollAnimApplyXVel_NoXC:
	;Swap nametable
	lda TempIRQBufferScrollHi,x
	eor #$04
	sta TempIRQBufferScrollHi,x
	rts

;$02: Level 2 fire arches
ScrollAnimX2:
	;If bits 0-1 of global timer 0, increment animation timer
	lda LevelGlobalTimer
	and #$03
	bne ScrollAnimGetPPUXPos_Exit
	;Increment animation timer
	inc BGFireArchTimer
	;Check if at end of animation
	lda BGFireArchTimer
	cmp #$16
	bcc ScrollAnimX2_NoReset
	;Play sound
	ldy #SE_BGFIREARCH
	jsr LoadSound
	;Reset animation timer
	lda #$00
	sta BGFireArchTimer
ScrollAnimX2_NoReset:
	;Draw VRAM strip
	ora #$80
	ldx UpdateVRAMStripCount
	sta UpdateVRAMStripID,x
	inc UpdateVRAMStripCount
	rts

;$03: Level 2/4 vertical scrolling areas
ScrollAnimX3:
	;Divide scroll Y position by $30, get remainder
	lda TempMirror_PPUSCROLL_Y
ScrollAnimX3_SubLoop:
	sec
	sbc #$30
	bcs ScrollAnimX3_SubLoop
	;Negate result
	eor #$FF
	clc
	adc #$01
	sta $00
	;Check if scrolling up or down
	lda $00
	sec
	sbc TempIRQBufferHeight
	bpl ScrollAnimX3_Up
	;Check for section wrap
	cmp #$F0
	bcs ScrollAnimX3_NoCopy
	;Copy IRQ scroll buffer over one entry
	ldx #$02
ScrollAnimX3_DownLoop:
	;Copy IRQ scroll buffer entry
	lda TempIRQBufferScrollX,x
	sta TempIRQBufferScrollX+1,x
	lda TempIRQBufferScrollHi,x
	sta TempIRQBufferScrollHi+1,x
	;Loop for each entry
	dex
	bpl ScrollAnimX3_DownLoop
	;Set scroll X position
	lda TempMirror_PPUSCROLL_X
	sta TempIRQBufferScrollX
	lda TempMirror_PPUCTRL
	and #$01
	asl
	asl
	ora #$20
	sta TempIRQBufferScrollHi
	;Set scroll X position
	lda #$00
	sta TempMirror_PPUSCROLL_X
	lda #$A9
	sta TempMirror_PPUCTRL
	bne ScrollAnimX3_NoCopy
ScrollAnimX3_Up:
	;Check for section wrap
	cmp #$10
	bcc ScrollAnimX3_NoCopy
	;Set scroll X position
	lda TempIRQBufferScrollX
	sta TempMirror_PPUSCROLL_X
	lda TempIRQBufferScrollHi
	and #$04
	lsr
	lsr
	ora #$A8
	sta TempMirror_PPUCTRL
	;Copy IRQ scroll buffer over one entry
	ldx #$00
ScrollAnimX3_UpLoop:
	;Copy IRQ scroll buffer entry
	lda TempIRQBufferScrollX+1,x
	sta TempIRQBufferScrollX,x
	lda TempIRQBufferScrollHi+1,x
	sta TempIRQBufferScrollHi,x
	;Loop for each entry
	inx
	cpx #$03
	bne ScrollAnimX3_UpLoop
	;Set scroll X position
	lda #$00
	sta TempIRQBufferScrollX+3
	lda #$24
	sta TempIRQBufferScrollHi+3
ScrollAnimX3_NoCopy:
	;Set height of top section
	lda $00
	sta TempIRQBufferHeight
	;Set height of bottom section, check if 0
	lda #$30
	sec
	sbc $00
	sta TempIRQBufferHeight+4
	beq ScrollAnimX3_ResetBottom
	;Set height of second from bottom section
	lda #$30
	sta TempIRQBufferHeight+3
	bne ScrollAnimX3_NoResetBottom
ScrollAnimX3_ResetBottom:
	;Set height of second from bottom section
	lda #$2F
	sta TempIRQBufferHeight+3
	;Reset height of bottom section to 1
	lda #$01
	sta TempIRQBufferHeight+4
ScrollAnimX3_NoResetBottom:
	;Set scroll Y position of second from top section
	lda TempMirror_PPUSCROLL_Y
	lsr
	lsr
	lsr
	lsr
	tax
	lda ScrollVerticalAreaScrollY,x
	sta TempIRQBufferScrollY
	;Set scroll Y position for lower sections
	ldx #$01
ScrollAnimX3_YLoop:
	;Increment scroll Y position $30
	clc
	adc #$30
	cmp #$F0
	bne ScrollAnimX3_NoYC
	lda #$00
ScrollAnimX3_NoYC:
	;Set scroll Y position for section
	sta TempIRQBufferScrollY,x
	;Loop for each section
	inx
	cpx #$04
	bne ScrollAnimX3_YLoop
	;Check control player mutex
	lda ControlPlayerMutex
	bne ScrollVerticalAreaXVelTopSub_Exit
	;Check for level 4
	lda CurLevel
	cmp #$03
	beq ScrollAnimX3_Level4
	;Update X scroll
	jsr ScrollVerticalAreaXVelSub
	;Update X scroll for top of screen
	jsr ScrollVerticalAreaXVelTopSub
	;If current screen $23, set X scroll for top/bottom of area
	lda CurScreen
	cmp #$23
	bne ScrollVerticalAreaXVelTopSub_Exit
	;Set X scroll for top/bottom of area
	jmp ScrollVerticalAreaTopBottomSub_Top
ScrollVerticalAreaXVelTopSub:
	;Check for row at Y position $C0
	lda TempIRQBufferScrollY
	beq ScrollVerticalAreaXVelTopSub_Exit
	;Check for row at Y position $30/$90
	and #$10
	bne ScrollVerticalAreaXVelTopSub_L1
	;Check for level 4
	lda CurLevel
	cmp #$03
	beq ScrollVerticalAreaXVelTopSub_L2
	;Set IRQ buffer scroll speed $01
	dec TempMirror_PPUSCROLL_X
	lda TempMirror_PPUSCROLL_X
	cmp #$FF
	beq ScrollVerticalAreaXVelTopSub_NoXC
	rts
ScrollVerticalAreaXVelTopSub_L2:
	;Set IRQ buffer scroll speed $FE
	inc TempMirror_PPUSCROLL_X
ScrollVerticalAreaXVelTopSub_L1:
	;Set IRQ buffer scroll speed $FF
	inc TempMirror_PPUSCROLL_X
	bne ScrollVerticalAreaXVelTopSub_Exit
ScrollVerticalAreaXVelTopSub_NoXC:
	;Swap nametable
	lda TempMirror_PPUCTRL
	eor #$01
	sta TempMirror_PPUCTRL
ScrollVerticalAreaXVelTopSub_Exit:
	rts
ScrollAnimX3_Level4:
	;Update X scroll
	jsr ScrollVerticalAreaXVelSub
	;Update X scroll for top of screen
	jsr ScrollVerticalAreaXVelTopSub
	;Set X scroll for top/bottom of area
	jsr ScrollVerticalAreaTopBottomSub
	;Update ship mouths
	jmp ScrollVerticalAreaShipMouthSub
ScrollVerticalAreaTopBottomSub:
	;If current screen $1E, set scroll X for top of area
	lda CurScreen
	cmp #$1E
	beq ScrollVerticalAreaTopBottomSub_Top
	;If current screen $21/$22, set scroll X for bottom of area
	cmp #$22
	beq ScrollVerticalAreaTopBottomSub_Bottom
	;If current screen $21 and scroll Y position $00-$7F, exit early
	cmp #$21
	bne ScrollVerticalAreaTopBottomSub_Exit
	lda TempMirror_PPUSCROLL_Y
	bpl ScrollVerticalAreaTopBottomSub_Exit
ScrollVerticalAreaTopBottomSub_Bottom:
	;Check for bottom section of area
	ldx #$02
	lda TempIRQBufferScrollY,x
	cmp #$90
	beq ScrollVerticalAreaTopBottomSub_SetX
	inx
	lda TempIRQBufferScrollY,x
	cmp #$90
	bne ScrollVerticalAreaTopBottomSub_Exit
ScrollVerticalAreaTopBottomSub_SetX:
	;Set scroll X position
	lda #$00
	sta TempIRQBufferScrollX,x
	;Set IRQ buffer scroll speed
	sta IRQBufferPlatformXVel,x
	;Set right nametable
	lda #$24
	sta TempIRQBufferScrollHi,x
	rts
ScrollVerticalAreaTopBottomSub_Top:
	;Check for top section of area
	lda TempMirror_PPUSCROLL_Y
	cmp #$30
	bcs ScrollVerticalAreaTopBottomSub_Exit
	;Set scroll X position
	lda #$00
	sta TempMirror_PPUSCROLL_X
	;Set right nametable
	lda #$A9
	sta TempMirror_PPUCTRL
ScrollVerticalAreaTopBottomSub_Exit:
	rts
ScrollVerticalAreaScrollY:
	.db $30,$30,$30
	.db $60,$60,$60
	.db $90,$90,$90
	.db $C0,$C0,$C0
	.db $00,$00,$00
	.db $30,$30
ScrollVerticalAreaShipMouthSub:
	;If animation timer 0, clear vertical area ship mouth frame counters
	lda BGAnimTimer
	bne ScrollVerticalAreaShipMouthSub_NoClear
	;Clear vertical area ship mouth frame counters
	lda #$00
	ldx #$06
ScrollVerticalAreaShipMouthSub_ClearLoop:
	;Clear vertical area ship mouth frame counter
	sta VerticalShipMouthFrame,x
	;Loop for each entry
	dex
	bpl ScrollVerticalAreaShipMouthSub_ClearLoop
	;Increment animation timer
	inc BGAnimTimer
	rts
ScrollVerticalAreaShipMouthSub_NoClear:
	;If bits 0-3 of global timer not 0, exit early
	lda LevelGlobalTimer
	and #$0F
	bne ScrollVerticalAreaTopBottomSub_Exit
	;Draw ship mouth metatile
	ldx UpdateMetatileCount
	ldy #$06
ScrollVerticalAreaShipMouthSub_CheckLoop:
	;If vertical area ship mouth frame counter not 0, draw metatile
	lda VerticalShipMouthFrame,y
	bne ScrollVerticalAreaShipMouthSub_Draw
	;Loop for each entry
	dey
	bpl ScrollVerticalAreaShipMouthSub_CheckLoop
	;Get ship mouth metatile data index based on scroll Y position
	lda TempIRQBufferScrollY
	lsr
	lsr
	lsr
	lsr
	lsr
	tay
	;If scroll X position in range, open mouth
	lda ScrollVerticalAreaShipMouthXMin,y
	cmp TempIRQBufferScrollX
	bcs ScrollVerticalAreaTopBottomSub_Exit
	lda ScrollVerticalAreaShipMouthXMax,y
	cmp TempIRQBufferScrollX
	bcs ScrollVerticalAreaShipMouthSub_Open
	rts
ScrollVerticalAreaShipMouthSub_Draw:
	;Save Y register
	sty $00
	;Draw metatile
	lda ScrollVerticalAreaShipMouthMetatilePos,y
	sta UpdateMetatilePos,x
	lda VerticalShipMouthProps,y
	sta UpdateMetatileProps,x
	tya
	clc
	adc VerticalShipMouthFrame,y
	tay
	lda ScrollVerticalAreaShipMouthMetatileID,y
	sta UpdateMetatileID,x
	inc UpdateMetatileCount
	;Restore Y register
	ldy $00
	;Increment vertical ship mouth frame counter
	lda VerticalShipMouthFrame,y
	clc
	adc #$08
	and #$18
	sta VerticalShipMouthFrame,y
ScrollVerticalAreaShipMouthSub_Exit:
	rts
ScrollVerticalAreaShipMouthSub_Open:
	;If current screen >= $21, exit early
	lda CurScreen
	cmp #$21
	bcs ScrollVerticalAreaShipMouthSub_Exit
	;Draw metatile
	lda ScrollVerticalAreaShipMouthMetatileID,y
	sta UpdateMetatileID,x
	lda TempIRQBufferScrollHi
	and #$04
	eor #$04
	lsr
	lsr
	sta UpdateMetatileProps,x
	sta VerticalShipMouthProps,y
	lda ScrollVerticalAreaShipMouthMetatilePos,y
	sta UpdateMetatilePos,x
	inc UpdateMetatileCount
	;Set vertical ship mouth frame counter
	lda #$08
	sta VerticalShipMouthFrame,y
	;Spawn enemy
	lda ScrollVerticalAreaShipMouthXOffs,y
	sec
	sbc TempIRQBufferScrollX
	sta Enemy_X+$08
	lda TempIRQBufferHeight
	clc
	adc #$28
	sta Enemy_Y+$08
	;Set enemy animation
	ldy #$24
	ldx #$08
	jsr SetEnemyAnimation
	;Clear enemy
	jsr ClearEnemy
	;Set enemy ID to vertical area ship fire
	lda #ENEMY_VERTSHIPFIRE
	sta Enemy_ID+$08
	;Set enemy X velocity
	lda IRQBufferPlatformXVel
	sta Enemy_XVelHi+$08
	;Set delay timer
	lda #$10
	sta Enemy_Temp2+$08
	;Set enemy flags
	lda #(EF_ACTIVE|EF_NOANIM)
	sta Enemy_Flags+$08
	rts
ScrollVerticalAreaShipMouthXMin:
	.db $20,$80,$FF,$60,$C0,$FF,$80
ScrollVerticalAreaShipMouthXMax:
	.db $50,$B0,$FF,$90,$F0,$FF,$B0
ScrollVerticalAreaShipMouthMetatilePos:
	.db $08,$13,$FF,$22,$2D,$FF,$3B
ScrollVerticalAreaShipMouthMetatileID:
	.db $40,$0E,$FF,$40,$0E,$FF,$40,$FF
	.db $41,$0F,$FF,$41,$0F,$FF,$41,$FF
	.db $40,$0E,$FF,$40,$0E,$FF,$40,$FF
	.db $3D,$0B,$FF,$3D,$0B,$FF,$3D,$FF
ScrollVerticalAreaShipMouthXOffs:
	.db $10,$70,$FF,$50,$B0,$FF,$50
ScrollVerticalAreaXVelSub:
	;Update X scroll for lower sections
	ldx #$03
ScrollVerticalAreaXVelSub_Loop:
	;Check for row at Y position $C0
	lda TempIRQBufferScrollY,x
	cmp #$C0
	bne ScrollVerticalAreaXVelSub_No0
	;Set IRQ buffer scroll speed $00
	lda #$00
	sta IRQBufferPlatformXVel,x
	beq ScrollVerticalAreaXVelSub_Next
ScrollVerticalAreaXVelSub_No0:
	;Check for row at Y position $30/$90
	and #$10
	beq ScrollVerticalAreaXVelSub_L1
	;Check for level 4
	lda CurLevel
	cmp #$03
	beq ScrollVerticalAreaXVelSub_L2
	;Set IRQ buffer scroll speed $01
	lda #$01
	sta IRQBufferPlatformXVel,x
	dec TempIRQBufferScrollX,x
	lda TempIRQBufferScrollX,x
	cmp #$FF
	beq ScrollVerticalAreaXVelSub_NoXC
	bne ScrollVerticalAreaXVelSub_Next
ScrollVerticalAreaXVelSub_L2:
	;Set IRQ buffer scroll speed $FE
	lda #$FE
	sta IRQBufferPlatformXVel,x
	inc TempIRQBufferScrollX,x
	inc TempIRQBufferScrollX,x
	beq ScrollVerticalAreaXVelSub_NoXC
	bne ScrollVerticalAreaXVelSub_Next
ScrollVerticalAreaXVelSub_L1:
	;Set IRQ buffer scroll speed $FF
	lda #$FF
	sta IRQBufferPlatformXVel,x
	inc TempIRQBufferScrollX,x
	bne ScrollVerticalAreaXVelSub_Next
ScrollVerticalAreaXVelSub_NoXC:
	;Swap nametable
	lda TempIRQBufferScrollHi,x
	eor #$04
	sta TempIRQBufferScrollHi,x
ScrollVerticalAreaXVelSub_Next:
	;Loop for each section
	dex
	bpl ScrollVerticalAreaXVelSub_Loop
	rts

;$04: Level 2 volcano
ScrollAnimX4:
	;Set scroll position to master PPU scroll
	ldx #$02
	jsr ScrollAnimGetPPUXPos
	;Shift scroll X position 1 bit
	jsr ScrollAnimShiftX1
	sta TempIRQBufferScrollHi+1
	lda $01
	sta TempIRQBufferScrollX+1
	;Shift scroll X position 2 bits
	jsr ScrollAnimShiftX2
	sta TempIRQBufferScrollHi
	lda $01
	sta TempIRQBufferScrollX
	rts

ScrollAnimShiftX1:
	;Shift scroll X position 1 bit
	lda CurScreen
	sta $00
	lda TempMirror_PPUSCROLL_X
	sta $01
	lsr $00
	ror $01
	lda CurScreen
	and #$02
	asl
	ora #$20
	rts

ScrollAnimShiftX2:
	;Shift scroll X position 2 bits (uses result from previous shift)
	lsr $00
	ror $01
	lda CurScreen
	and #$04
	ora #$20
	rts

;$06: Level 3 water
ScrollAnimX6:
	;Get scroll X velocity
	jsr ScrollAnimGetXVel
	;Apply scroll X velocity to scroll position
	inc $00
	ldx #$04
	jsr ScrollAnimApplyXVel
	;Apply scroll X velocity to scroll position
	ldx #$00
	jsr ScrollAnimApplyXVel
	;Check if scroll X position $80-$FF
	lda TempIRQBufferScrollX
	bmi ScrollAnimX6_Right
	;If scroll X position $08-$7F, decrement scroll X position $10
	cmp #$08
	bcc ScrollAnimX6_NoSetX
	;Decrement scroll X position $10
	clc
	adc #$F0
	bne ScrollAnimX6_SetX
ScrollAnimX6_Right:
	;If scroll X position $80-$F7, increment scroll X position $10
	cmp #$F8
	bcs ScrollAnimX6_NoSetX
	;Increment scroll X position $10
	clc
	adc #$10
ScrollAnimX6_SetX:
	;Set scroll X position
	sta TempIRQBufferScrollX
	;Swap nametable
	lda TempIRQBufferScrollHi
	eor #$04
	sta TempIRQBufferScrollHi
ScrollAnimX6_NoSetX:
	;Set scroll position to master PPU scroll
	ldx #$01
	jmp ScrollAnimGetPPUXPos

;$F0: Level 3 iceberg
ScrollAnimF0:
	;Apply scroll X velocity to scroll position
	lda #$01
	sta $00
	ldx #$00
	jsr ScrollAnimApplyXVel
	;Apply scroll X velocity to scroll position
	inc $00
	inx
	jsr ScrollAnimApplyXVel
	;Apply scroll X velocity to scroll position
	ldx #$04
	jsr ScrollAnimApplyXVel
	;Apply scroll X velocity to scroll position
	inc $00
	ldx #$02
	jsr ScrollAnimApplyXVel
	;If bits 0-3 of global timer not 0, exit early
	lda LevelGlobalTimer
	and #$0F
	bne ScrollAnimF0_Exit
	;Check for down mode
	lda BGAnimMode
	beq ScrollAnimF0_Down
	;Move iceberg up
	dec TempIRQBufferHeight+3
	inc TempIRQBufferHeight+4
	dec TempIRQBufferHeight+5
	inc TempIRQBufferHeight+6
	;Check if iceberg is all the way up
	lda TempIRQBufferHeight+6
	cmp #$1E
	bne ScrollAnimF0_Exit
	;Next task ($00: Down)
	lda #$00
	sta BGAnimMode
	rts
ScrollAnimF0_Down:
	;Move iceberg down
	inc TempIRQBufferHeight+3
	dec TempIRQBufferHeight+4
	inc TempIRQBufferHeight+5
	dec TempIRQBufferHeight+6
	;Check if iceberg is all the way down
	lda TempIRQBufferHeight+6
	cmp #$1C
	bne ScrollAnimF0_Exit
	;Next task ($01: Up)
	lda #$01
	sta BGAnimMode
ScrollAnimF0_Exit:
	rts

;$F1: Level 3 gray pipes
ScrollAnimF1:
	;Update level 3 horizontal ice cave areas
	jsr ScrollAnimF2
	;Check if already inited
	lda BGAnimMode
	bne ScrollAnimF1_Main
	;Mark inited
	inc BGAnimMode
	;Init VRAM addresses
	ldx #$03
ScrollAnimF1_InitLoop:
	;Init VRAM address
	lda ScrollGrayPipeVRAMAddrHi,x
	sta BGGrayPipeVRAMAddrHi,x
	lda ScrollGrayPipeVRAMAddrLo,x
	sta BGGrayPipeVRAMAddrLo,x
	;Loop for each entry
	dex
	bpl ScrollAnimF1_InitLoop
	rts
ScrollAnimF1_Main:
	;Increment animation timer
	inc BGAnimTimer
	;Get gray pipe table indexes
	lda BGAnimTimer
	and #$03
	tay
	eor #$02
	tax
	;Check if gray pipe is moving up or down
	lda BGGrayPipeMode,x
	bne ScrollAnimF1_DownY
	;Set enemy Y velocity up
	lda #$FE
	bne ScrollAnimF1_SetY
ScrollAnimF1_DownY:
	;Set enemy Y velocity down
	lda #$02
ScrollAnimF1_SetY:
	sta Enemy_YVelHi+$01,x
	;Check if gray pipe is moving up or down
	lda BGGrayPipeMode,y
	beq ScrollAnimF1_UpVRAM
	jmp ScrollAnimF1_DownVRAM
ScrollAnimF1_UpVRAM:
	;Decrement VRAM address
	lda BGGrayPipeVRAMAddrLo,y
	sta $01
	sec
	sbc #$20
	sta $09
	sta BGGrayPipeVRAMAddrLo,y
	lda BGGrayPipeVRAMAddrHi,y
	sta $00
	sbc #$00
	sta $08
	sta BGGrayPipeVRAMAddrHi,y
	;Check if gray pipe is all the way up
	and #$03
	cmp #$01
	bne ScrollAnimF1_NoDown
	lda $09
	and #$E0
	bne ScrollAnimF1_NoDown
	;Set gray pipe Y velocity down
	lda #$01
	sta BGGrayPipeMode,y
ScrollAnimF1_NoDown:
	;Init VRAM buffer row
	jsr WriteVRAMBufferCmd_InitRow
	;Set VRAM buffer address
	lda $01
	sta VRAMBuffer,x
	inx
	lda $00
	sta VRAMBuffer,x
	inx
	;Draw gray pipe tile row
	ldy #$00
ScrollAnimF1_UpVRAMLoop:
	;Set tile in VRAM
	lda ScrollGrayPipeVRAMData,y
	sta VRAMBuffer,x
	;Loop for each tile
	inx
	iny
	cpy #$08
	bne ScrollAnimF1_UpVRAMLoop
	;End VRAM buffer
	lda #$FF
	sta VRAMBuffer,x
	inx
	;Init VRAM buffer row
	lda #$01
	sta VRAMBuffer,x
	inx
	;Set VRAM buffer address
	lda $09
	sta VRAMBuffer,x
	inx
	lda $08
	sta VRAMBuffer,x
	inx
	;Draw gray pipe tile row
ScrollAnimF1_UpVRAMLoop2:
	;Set tile in VRAM
	lda ScrollGrayPipeVRAMData,y
	sta VRAMBuffer,x
	;Loop for each tile
	inx
	iny
	cpy #$10
	bne ScrollAnimF1_UpVRAMLoop2
	;End VRAM buffer
	jsr WriteVRAMBufferCmd_End
	;Draw collision tile row
	ldy $00
	lda #$08
	sta $00
	lda #$02
	sta $02
	jmp DrawCollisionTileRow
ScrollAnimF1_DownVRAM:
	;Increment VRAM address
	lda BGGrayPipeVRAMAddrLo,y
	sta $01
	clc
	adc #$20
	sta $09
	sta BGGrayPipeVRAMAddrLo,y
	lda BGGrayPipeVRAMAddrHi,y
	sta $00
	adc #$00
	sta $08
	sta BGGrayPipeVRAMAddrHi,y
	;Check if gray pipe is all the way down
	and #$03
	cmp #$02
	bne ScrollAnimF1_NoUp
	lda $09
	and #$E0
	cmp #$60
	bne ScrollAnimF1_NoUp
	;Set gray pipe Y velocity up
	lda #$00
	sta BGGrayPipeMode,y
ScrollAnimF1_NoUp:
	;Init VRAM buffer row
	jsr WriteVRAMBufferCmd_InitRow
	;Set VRAM buffer address
	lda $01
	sta VRAMBuffer,x
	inx
	lda $00
	sta VRAMBuffer,x
	inx
	;Draw gray pipe tile row
	ldy #$00
ScrollAnimF1_DownVRAMLoop:
	;Set tile in VRAM
	lda #$00
	sta VRAMBuffer,x
	;Loop for each tile
	inx
	iny
	cpy #$08
	bne ScrollAnimF1_DownVRAMLoop
	;End VRAM buffer
	lda #$FF
	sta VRAMBuffer,x
	inx
	;Init VRAM buffer row
	lda #$01
	sta VRAMBuffer,x
	inx
	;Set VRAM buffer address
	lda $09
	sta VRAMBuffer,x
	inx
	lda $08
	sta VRAMBuffer,x
	inx
	;Draw gray pipe tile row
ScrollAnimF1_DownVRAMLoop2:
	;Set tile in VRAM
	lda ScrollGrayPipeVRAMData,y
	sta VRAMBuffer,x
	;Loop for each tile
	inx
	iny
	cpy #$10
	bne ScrollAnimF1_DownVRAMLoop2
	;End VRAM buffer
	jsr WriteVRAMBufferCmd_End
	;Draw collision tile row
	ldy $08
	lda $09
	sta $01
	lda #$08
	sta $00
	lda #$00
	sta $02
	jmp DrawCollisionTileRow
ScrollGrayPipeVRAMAddrHi:
	.db $22,$21,$26,$25
ScrollGrayPipeVRAMAddrLo:
	.db $0C,$98,$08,$94
ScrollGrayPipeVRAMData:
	.db $56,$57,$72,$73,$74,$00,$75,$76
	.db $4E,$4F,$50,$51,$52,$53,$54,$55

;$F2: Level 3 horizontal ice cave areas
ScrollAnimF2:
	;Get scroll X velocity
	jsr ScrollAnimGetXVel
	;Apply scroll X velocity to scroll position
	inc $00
	ldx #$00
	jmp ScrollAnimApplyXVel

;$07: Level 7 rotating room
ScrollAnimX7:
	;Check if already inited
	lda BGAnimMode
	bne ScrollAnimX7_Main
	;Init scroll X position for drawing
	lda #$A9
	sta BGRotRoomDrawScrollHi
	lda #$00
	sta BGRotRoomDrawScrollX
	;Mark inited
	inc BGAnimMode
ScrollAnimX7_MainExit:
	rts
ScrollAnimX7_Main:
	;If bits 0-2 of global timer not 0, exit early
	lda LevelGlobalTimer
	and #$07
	bne ScrollAnimX7_MainExit
	;Save scroll X position
	lda TempMirror_PPUCTRL
	sta BGRotRoomSaveScrollHi
	lda TempMirror_PPUSCROLL_X
	sta BGRotRoomSaveScrollX
	;Load drawing scroll X position
	lda BGRotRoomDrawScrollHi
	sta TempMirror_PPUCTRL
	lda BGRotRoomDrawScrollX
	sta TempMirror_PPUSCROLL_X
	;Set drawing scroll X velocity
	lda #$10
	sta ScrollXVelHi
	;Draw more level data
	jsr UpdateLevelScroll_DoH
	;Reset scroll X velocity
	lda #$00
	sta ScrollXVelHi
	;Save drawing scroll X position
	lda TempMirror_PPUSCROLL_X
	sta BGRotRoomDrawScrollX
	lda TempMirror_PPUCTRL
	sta BGRotRoomDrawScrollHi
	;Restore scroll X position
	lda BGRotRoomSaveScrollX
	sta TempMirror_PPUSCROLL_X
	lda BGRotRoomSaveScrollHi
	sta TempMirror_PPUCTRL
	;Check if next orientation has finished drawing
	lda BGRotRoomDrawScrollX
	cmp #$80
	bne ScrollAnimX7_MainExit
	;Play sound
	ldy #SE_CRASH
	jsr LoadSound
	;Update rotating room enemy position
	ldx #$05
ScrollAnimX7_Loop:
	;Update enemy position
	jsr ScrollRotatingRoomSetPos
	;Loop for each enemy
	dex
	bpl ScrollAnimX7_Loop
	;Move rotating room shooter down $08
	lda Enemy_Y+$05
	clc
	adc #$08
	sta Enemy_Y+$05
	;Swap nametable
	lda TempMirror_PPUCTRL
	eor #$01
	sta TempMirror_PPUCTRL
	;If bits 0-3 of current screen $05, reset current screen value for looping
	lda CurScreen
	and #$07
	cmp #$05
	bne ScrollAnimX7_MainExit
	lda CurScreen
	and #$F9
	sta CurScreen
ScrollAnimX7_Exit:
	rts
ScrollRotatingRoomSetPos:
	;If enemy X position $00-$27, check if X position $18-$27
	lda Enemy_X,x
	cmp #$28
	bcc ScrollRotatingRoomSetPos_LeftCheck
	;If enemy X position $D8-$FF, check if X position $E4-$FF
	cmp #$D8
	bcs ScrollRotatingRoomSetPos_RightCheck
ScrollRotatingRoomSetPos_Rot:
	;Save enemy X position
	sta $00
	;If enemy Y position $B0-$FF, exit early
	lda Enemy_Y,x
	cmp #$B0
	bcs ScrollAnimX7_Exit
	;If enemy Y position $00-$10, set X position $D0
	lda #$E0
	sec
	sbc Enemy_Y,x
	cmp #$D0
	bcs ScrollRotatingRoomSetPos_Right
	;If enemy Y position $B1-$E0, set X position $30 (never happens)
	cmp #$30
	bcs ScrollRotatingRoomSetPos_SetXY
	;Set enemy X position $30
	lda #$30
	bne ScrollRotatingRoomSetPos_SetXY
ScrollRotatingRoomSetPos_Right:
	;Set enemy X position $D0
	lda #$D0
ScrollRotatingRoomSetPos_SetXY:
	sta Enemy_X,x
	;Set enemy Y position based on X position for rotation
	lda $00
	sec
	sbc #$28
	sta Enemy_Y,x
ScrollRotatingRoomSetPos_Exit:
	rts
ScrollRotatingRoomSetPos_LeftCheck:
	;If enemy X position $18-$27, set X position $18
	cmp #$18
	bcc ScrollRotatingRoomSetPos_Exit
	;Set enemy X position $18
	lda #$18
	bne ScrollRotatingRoomSetPos_SetX
ScrollRotatingRoomSetPos_RightCheck:
	;If enemy X position $E4-$FF, exit early
	cmp #$E4
	bcs ScrollRotatingRoomSetPos_Exit
	;Bugged check to set X position $E8 (never happens)
	lda Enemy_Y,x
	cmp #$88
	bcc ScrollRotatingRoomSetPos_DoRot
	cmp #$62
	bcs ScrollRotatingRoomSetPos_DoRot
	;Set enemy X position $E8
	lda #$E8
ScrollRotatingRoomSetPos_SetX:
	sta Enemy_X,x
	rts
ScrollRotatingRoomSetPos_DoRot:
	lda Enemy_X,x
	jmp ScrollRotatingRoomSetPos_Rot
;$F4: Level 5 hypno Jenny area
ScrollAnimF4:
	;If player X position < $A8, set player to be behind background
	lda Enemy_X
	cmp #$A8
	bcc ScrollAnimF4_Back
ScrollAnimF4_Front:
	;Set player priority to be in front of background
	lda Enemy_Props
	and #$DF
	sta Enemy_Props
	rts
ScrollAnimF4_Back:
	;Set player priority to be behind background
	lda Enemy_Props
	ora #$20
	sta Enemy_Props
	rts

;$F7: Level 5 hypno Dead-Eye area
ScrollAnimF7:
	;Check if hypno Dead-Eye is active
	lda Enemy_Flags+$01
	bne ScrollAnimF5
	;Unlock character Dead-Eye
	lda CharacterPowerMax+2
	ora #$80
	sta CharacterPowerMax+2
	;Next mode ($08: Victory)
	lda #$08
	sta GameMode
	;Next submode ($00: Update game state)
	lda #$00
	sta GameSubmode
	;Set boss enemy slot index
	lda #$01
	sta BossEnemyIndex
	;Clear enemies
	jsr ClearEnemies_NoPl

;$F5: Level 5 hypno Willy area
ScrollAnimF5:
	;If player X position >= $50, set player to be behind background
	lda Enemy_X
	cmp #$50
	bcc ScrollAnimF4_Front
	bcs ScrollAnimF4_Back

;$F6: Level 6 ceiling spikes
ScrollAnimF6:
	;Check if already inited
	lda BGCeilingSpikesMode
	bne ScrollAnimF6_Main
	;Init animation timers
	lda #$03
	sta BGCeilingSpikesTimer
	sta BGCeilingSpikesTimer+2
	lda #$0B
	sta BGCeilingSpikesTimer+1
	sta BGCeilingSpikesTimer+3
	;Mark inited
	inc BGCeilingSpikesMode
ScrollAnimF6_MainExit:
	rts
ScrollAnimF6_Main:
	;If bit 0 of global timer 0, exit early
	lda LevelGlobalTimer
	and #$01
	beq ScrollAnimF6_MainExit
	;Increment ceiling spikes index
	inc BGCeilingSpikesIndex
	;Get VRAM address
	lda BGCeilingSpikesIndex
	and #$03
	tay
	lda ScrollCeilingSpikesVRAMAddrHi,y
	sta $10
	lda ScrollCeilingSpikesVRAMAddrLo,y
	sta $11
	;Increment animation timer
	lda BGCeilingSpikesTimer,y
	clc
	adc #$01
	and #$0F
	sta BGCeilingSpikesTimer,y
	tay
	and #$08
	sta $12
	sta $13
	;If animation timer 0, play sound
	tya
	bne ScrollAnimF6_NoSound
	;Save Y register
	tya
	pha
	;Play sound
	ldy #SE_WHIRSHORT
	jsr LoadSound
	;Restore Y register
	pla
	tay
ScrollAnimF6_NoSound:
	;Draw ceiling spike tile rows
	lda #$04
	sta $08
	;Get VRAM address offset
	lda ScrollCeilingSpikesVRAMOffs,y
ScrollAnimF6_Loop:
	;Adjust VRAM address for row
	clc
	adc $11
	sta $11
	lda $10
	adc #$00
	sta $10
	;Init VRAM buffer row
	jsr WriteVRAMBufferCmd_InitRow
	;Set VRAM buffer address
	ldy $10
	lda $11
	jsr WriteVRAMBufferCmd_Addr
	;Draw ceiling spike tile row
	ldy $12
ScrollAnimF6_VRAMLoop:
	;Set tile in VRAM
	lda ScrollCeilingSpikesVRAMData,y
	sta VRAMBuffer,x
	;Loop for each tile
	inx
	iny
	tya
	and #$07
	bne ScrollAnimF6_VRAMLoop
	;End VRAM buffer
	sty $12
	jsr WriteVRAMBufferCmd_End
	;Loop for each row
	dec $08
	beq ScrollAnimF6_Exit
	;Draw collision
	jsr ScrollCeilingSpikesDrawCollision
	;Increment VRAM address offset
	lda #$20
	bne ScrollAnimF6_Loop
ScrollAnimF6_Exit:
	rts
ScrollCeilingSpikesDrawCollision:
	;Check for row 3, if so, exit early
	lda $08
	cmp #$03
	beq ScrollAnimF6_Exit
	;Draw collision tile row
	sec
	sbc #$01
	sta $00
	lda $13
	lsr
	lsr
	ora $00
	tay
	lda ScrollCeilingSpikesCollisionType,y
	sta $02
	lda #$08
	sta $00
	lda $11
	sta $01
	ldy $10
	jmp DrawCollisionTileRow
ScrollCeilingSpikesVRAMAddrHi:
	.db $20,$20,$24,$24
ScrollCeilingSpikesVRAMAddrLo:
	.db $A4,$B8,$A4,$B8
ScrollCeilingSpikesVRAMOffs:
	.db $00,$20,$40,$60,$80,$A0,$C0,$E0
	.db $E0,$C0,$A0,$80,$60,$40,$20,$00
ScrollCeilingSpikesVRAMData:
	.db $D7,$D8,$D8,$D9,$D9,$DB,$DC,$DE
	.db $CB,$CC,$CC,$CD,$CD,$CE,$CF,$CF
	.db $FB,$FA,$FD,$FC,$FD,$FA,$FB,$FB
	.db $3A,$3B,$3C,$3D,$3C,$3B,$3A,$3A
	.db $00,$00,$00,$00,$00,$00,$00,$00
ScrollCeilingSpikesCollisionType:
	.db $03,$02,$00,$03

;$80: Level 5 elevators
CHRBankAnim8X:
	;Check for init mode
	lda BGAnimMode
	beq CHRBankAnim8X_Init
	;Check elevator direction
	lda BGElevatorDirection
	beq CHRBankAnim8X_JT
	bne CHRBankAnim8X_Down
CHRBankAnim8X_Init:
	;Check if current screen $19/$1B/$32
	lda CurScreen
	cmp #$19
	beq CHRBankAnim8X_Down
	cmp #$1B
	beq CHRBankAnim8X_Down
	cmp #$32
	beq CHRBankAnim8X_Down
CHRBankAnim8X_JT:
	;Do jump table
	lda BGAnimMode
	jsr DoJumpTable
CHRBankAnim8XBigJumpTable:
	.dw CHRBankAnim8X_Up_Sub0	;$00  Init
	.dw CHRBankAnim8X_Up_Sub1	;$01  Main
	.dw CHRBankAnim0X		;$02  Finish
;$00: Init
CHRBankAnim8X_Up_Sub0:
	;Set elevator direction up
	lda #$00
	sta BGElevatorDirection
	;Set scroll Y velocity $FE
	lda #$FE
	;Check for level 6 big elevator area
	ldy CurArea
	cpy #$60
	bne CHRBankAnim8X_Up_Sub0_SetY
	;Set scroll Y velocity $FF
	lda #$FF
CHRBankAnim8X_Up_Sub0_SetY:
	sta ScrollYVelHi
	;Next task ($01: Main)
	inc BGAnimMode
	;Play sound
	ldy #SE_ELEVATOR
	jmp LoadSound
;$01: Main
CHRBankAnim8X_Up_Sub1:
	;Set scroll Y velocity $FE
	lda #$FE
	;Check for level 6 big elevator area
	ldy CurArea
	cpy #$60
	bne CHRBankAnim8X_Up_Sub1_SetY
	;If bit 0 of global timer not 0, set scroll Y velocity $FF
	lda LevelGlobalTimer
	and #$01
	beq CHRBankAnim8X_Up_Sub1_SetY
	;Set scroll Y velocity $FF
	lda #$FF
CHRBankAnim8X_Up_Sub1_SetY:
	sta ScrollYVelHi
	;If scroll Y position not 0, exit early
	lda TempMirror_PPUSCROLL_Y
	bne CHRBankAnim8X_Down_Sub1_Exit
	;Check for level 6 big elevator area
	cpy #$60
	bne CHRBankAnim8X_Up_Sub1_Next
	;If current screen not $1D, exit early
	lda CurScreen
	cmp #$1D
	bne CHRBankAnim8X_Down_Sub1_Exit
CHRBankAnim8X_Up_Sub1_Next:
	;Next task ($02: Finish)
	inc BGAnimMode
	;Clear disable side exit flag
	lda #$00
	sta DisableSideExitFlag
	;Clear scroll Y velocity
	sta ScrollYVelHi
	;Play sound
	ldy #SE_CRASH
	jsr LoadSound
	;If current screen = $32 or < $1B, clear collision for left exit
	lda CurScreen
	cmp #$32
	beq CHRBankAnim8X_Up_Sub1_Left
	cmp #$1B
	bcc CHRBankAnim8X_Up_Sub1_Left
	;Clear collision for right exit
	ldy #$07
	bne CHRBankAnim8X_Up_Sub1_Clear
CHRBankAnim8X_Up_Sub1_Left:
	;Clear collision for left exit
	ldy #$00
CHRBankAnim8X_Up_Sub1_Clear:
	lda #$00
	sta CollisionBuffer+$178,y
	sta CollisionBuffer+$180,y
	sta CollisionBuffer+$188,y
	rts
CHRBankAnim8X_Down:
	;Do jump table
	lda BGAnimMode
	jsr DoJumpTable
CHRBankAnim8XDownJumpTable:
	.dw CHRBankAnim8X_Down_Sub0	;$00  Init
	.dw CHRBankAnim8X_Down_Sub1	;$01  Main
	.dw CHRBankAnim0X		;$02  Finish
;$00: Init
CHRBankAnim8X_Down_Sub0:
	;Set elevator direction down
	lda #$01
	sta BGElevatorDirection
	;Set scroll Y velocity $02
	lda #$02
	bne CHRBankAnim8X_Up_Sub0_SetY
;$01: Main
CHRBankAnim8X_Down_Sub1:
	;Set scroll Y velocity $02
	lda #$02
	sta ScrollYVelHi
	;If scroll Y position not 0, exit early
	lda TempMirror_PPUSCROLL_Y
	beq CHRBankAnim8X_Up_Sub1_Next
CHRBankAnim8X_Down_Sub1_Exit:
	rts

;$08: Level 5 big elevator
ScrollAnimX8:
	;If bit 0 of global timer not 0, exit early
	lda LevelGlobalTimer
	and #$01
	bne CHRBankAnim8X_Down_Sub1_Exit
	;Increment animation timer
	inc BGPalAnimTimer
	lda BGPalAnimTimer
	cmp #$03
	bne ScrollAnimX8_NoResetC
	lda #$00
ScrollAnimX8_NoResetC:
	sta BGPalAnimTimer
	;Load palette
	tay
	lda ScrollBigElevatorPaletteTable,y
	sta CurPalette
	rts
ScrollBigElevatorPaletteTable:
	.db $AA,$C4,$C5

;$09: Level 7 flashing palette
ScrollAnimX9:
	;If bits 0-2 of global timer not 0, exit early
	lda LevelGlobalTimer
	and #$07
	bne CHRBankAnim8X_Down_Sub1_Exit
	;Increment animation timer
	inc BGPalAnimTimer
	lda BGPalAnimTimer
	and #$07
	sta BGPalAnimTimer
	;Load palette
	tay
	lda ScrollLevel7FlashPaletteTable,y
	sta CurPalette
	rts
ScrollLevel7FlashPaletteTable:
	.db $B1,$CA,$CB,$CC,$CC,$CC,$CB,$CA

;$90: Level 7 crusher areas
CHRBankAnim9X:
	;Do subroutines
	jsr CHRBankAnim9X_DoSub
	;Set current screen based on player Y position
	lda Enemy_Y
	bpl CHRBankAnim9X_Top
	;Set current screen bottom
	lda CurScreen
	and #$FE
	bne CHRBankAnim9X_SetScreen
CHRBankAnim9X_Top:
	;Set current screen top
	lda CurScreen
	ora #$01
CHRBankAnim9X_SetScreen:
	sta CurScreen
CHRBankAnim9X_Exit:
	rts
CHRBankAnim9X_DoSub:
	;Set crusher area flag
	lda #$01
	sta CrusherAreaFlag
	;If bits 0-1 of global timer not $01, exit early
	lda LevelGlobalTimer
	and #$03
	cmp #$01
	bne CHRBankAnim9X_Exit
	;Do jump table
	lda BGAnimMode
	jsr DoJumpTable
CHRBankAnim9XJumpTable:
	.dw CHRBankAnim9X_Sub0	;$00  Idle in
	.dw CHRBankAnim9X_Sub1	;$01  Moving out
	.dw CHRBankAnim9X_Sub0	;$02  Idle out
	.dw CHRBankAnim9X_Sub3	;$03  Moving in
;$00: Idle in
;$02: Idle out
CHRBankAnim9X_Sub0:
	;Decrement animation timer, check if $F0
	dec BGAnimTimer
	lda BGAnimTimer
	cmp #$F0
	bne CHRBankAnim9X_Exit
	;Reset animation timer
	lda #$00
	sta BGAnimTimer
	;Next task
	inc BGAnimMode
	;Play sound
	ldy #SE_WHIRSHORT
	jmp LoadSound
;$01: Moving out
CHRBankAnim9X_Sub1:
	;Move tanker side spikes left $04
	ldx #$06
CHRBankAnim9X_Sub1_Loop:
	;If enemy X position $EF, hide spikes
	lda Enemy_X,x
	cmp #$EF
	beq CHRBankAnim9X_Sub1_Hide
	;Move side spikes left $04
	sec
	sbc #$04
	sta Enemy_X,x
	;If enemy X position $FC, hide spikes
	cmp #$FC
	bne CHRBankAnim9X_Sub1_Next
CHRBankAnim9X_Sub1_Hide:
	;Clear enemy visible flag
	lda #(EF_ACTIVE|EF_NOANIM|EF_HITENEMY)
	sta Enemy_Flags,x
CHRBankAnim9X_Sub1_Next:
	;Loop for each set of spikes
	dex
	bne CHRBankAnim9X_Sub1_Loop
	;Check for player climbing wall state flag
	lda Enemy_Temp0
	and #$02
	beq CHRBankAnim9X_Sub1_NoWall
	;If player X position >= $ED, jump off wall
	lda Enemy_X
	cmp #$ED
	bcs CHRBankAnim9X_Sub1_ClearWall
	;Move player right $04
	clc
	adc #$04
	sta Enemy_X
	bne CHRBankAnim9X_Sub1_NoWall
CHRBankAnim9X_Sub1_ClearWall:
	;Clear player climbing wall state flag
	lda Enemy_Temp0
	and #$F5
	sta Enemy_Temp0
	;Setup player jump
	jsr HandlePlayerJumping_NoDown
CHRBankAnim9X_Sub1_NoWall:
	;Load CHR bank
	lda TempCHRBanks
	eor #$40
	sta TempCHRBanks
	;Scroll X left $04
	lda TempMirror_PPUSCROLL_X
	sec
	sbc #$04
	sta TempMirror_PPUSCROLL_X
	cmp #$FC
	beq CHRBankAnim9X_Sub1_NoXC
	;If scroll X position not $C0, exit early
	cmp #$C0
	bne CHRBankAnim9X_Exit
	;Next task ($02: Idle out)
	inc BGAnimMode
	;Play sound
	ldy #SE_CRASH
	jmp LoadSound
CHRBankAnim9X_Sub1_NoXC:
	;Swap nametable
	lda #$A9
	sta TempMirror_PPUCTRL
CHRBankAnim9X_Sub1_Exit:
	rts
;$03: Moving in
CHRBankAnim9X_Sub3:
	;Move tanker side spikes right $04
	ldx #$06
CHRBankAnim9X_Sub3_Loop:
	;If enemy X position $EF, show spikes
	lda Enemy_X,x
	cmp #$EF
	beq CHRBankAnim9X_Sub3_Next
	;Move side spikes right $04
	clc
	adc #$04
	sta Enemy_X,x
	bne CHRBankAnim9X_Sub3_Next
	;Set enemy visible flag
	lda #(EF_ACTIVE|EF_NOANIM|EF_HITENEMY|EF_VISIBLE)
	sta Enemy_Flags,x
CHRBankAnim9X_Sub3_Next:
	;Loop for each set of spikes
	dex
	bne CHRBankAnim9X_Sub3_Loop
	;Check for player climbing wall state flag
	lda Enemy_Temp0
	and #$02
	beq CHRBankAnim9X_Sub3_NoWall
	;Move player left $04
	lda Enemy_X
	sec
	sbc #$04
	sta Enemy_X
CHRBankAnim9X_Sub3_NoWall:
	;Load CHR bank
	lda TempCHRBanks
	eor #$40
	sta TempCHRBanks
	;Scroll X right $04
	lda TempMirror_PPUSCROLL_X
	clc
	adc #$04
	sta TempMirror_PPUSCROLL_X
	;If scroll X position not $00, exit early
	bne CHRBankAnim9X_Sub1_Exit
	;Swap nametable
	lda #$A8
	sta TempMirror_PPUCTRL
	;Next task ($00: Idle in)
	lda #$00
	sta BGAnimMode
	;Play sound
	ldy #SE_CRASH
	jmp LoadSound

UpdateCHRBankAnim:
	;Do jump table
	ldx LevelAreaNum
	lda LevelAreaAnimSetTable,x
	lsr
	lsr
	lsr
	lsr
	jsr DoJumpTable
CHRBankAnimJumpTable:
	.dw CHRBankAnim0X	;$00  Normal gameplay
	.dw CHRBankAnim1X	;$10  Level 1/2/3 water/lava
	.dw CHRBankAnim2X	;$20  Level 3/7 snakes
	.dw CHRBankAnim3X	;$30  Level 6 dark rooms
	.dw CHRBankAnim4X	;$40  Level 6 lava
	.dw CHRBankAnim5X	;$50  Level 5 conveyors
	.dw CHRBankAnim6X	;$60  Level 2/5 background squares
	.dw CHRBankAnim7X	;$70  Level 2 boss
	.dw CHRBankAnim8X	;$80  Level 5 elevators
	.dw CHRBankAnim9X	;$90  Level 7 crusher areas
	.dw CHRBankAnimAX	;$A0  Level 8 background pattern
	.dw CHRBankAnimBX	;$B0  Level 8 end stars
	.dw CHRBankAnimCX	;$C0  Level 8 glass pipes area
	.dw CHRBankAnimDX	;$D0  Level 7 boss
	.dw CHRBankAnimEX	;$E0  Level 8 miniboss ship
	.dw CHRBankAnim0X	;$F0  UNUSED

;$10: Level 1/2/3 water/lava
CHRBankAnim1X:
	;If bits 0-3 of global timer 0, load CHR bank
	lda LevelGlobalTimer
	and #$07
	bne CHRBankAnim0X
CHRBankAnim1X_EntXC:
	;Animate using CHR banks $04/$06/$08
	lda TempCHRBanks+1
	clc
	adc #$02
	cmp #$0A
	bne CHRBankAnim1X_Set
	lda #$04
CHRBankAnim1X_Set:
	;Load CHR bank
	sta TempCHRBanks+1

;$00: Normal gameplay
CHRBankAnim0X:
	rts

;$20: Level 3/7 snakes
CHRBankAnim2X:
	;If bit 0 of global timer 0, load CHR bank
	lda LevelGlobalTimer
	and #$01
	bne CHRBankAnim0X
	;Animate using CHR banks $48/$4A/$4C/$4E
	lda TempCHRBanks
	clc
	adc #$02
	cmp #$50
	bne CHRBankAnim2X_Set
	lda #$48
CHRBankAnim2X_Set:
	;Load CHR bank
	sta TempCHRBanks
	rts

;$30: Level 6 dark rooms
CHRBankAnim3X:
	;Do subroutines
	jsr CHRBankAnim3X_DoSub
	;If CHR bank $7E loaded, exit early
	lda TempCHRBanks+1
	cmp #$7E
	beq CHRBankAnim0X
	;If bits 0-1 of global timer 0, load CHR bank
	lda #$03
CHRBankAnim3X_AnyM:
	and LevelGlobalTimer
	bne CHRBankAnim0X
	;Animate using CHR banks $48/$4A/$4C/$4E
	lda TempCHRBanks+1
	clc
	adc #$02
	cmp #$50
	bne CHRBankAnim3X_Set
	lda #$48
CHRBankAnim3X_Set:
	;Load CHR bank
	sta TempCHRBanks+1
	rts

;$40: Level 6 lava
CHRBankAnim4X:
	;If bits 0-2 of global timer 0, load CHR bank
	lda #$07
	bne CHRBankAnim3X_AnyM

;$50: Level 5 conveyors
CHRBankAnim5X:
	;If bit 0 of global timer 0, load CHR bank
	lda #$01
	bne CHRBankAnim3X_AnyM

;$60: Level 2/5 background squares
CHRBankAnim6X:
	;Load CHR bank based on scroll X position
	lda TempMirror_PPUSCROLL_X
	and #$1F
	lsr
	jmp CHRBankAnim7X_Ent6X

;$70: Level 2 boss
CHRBankAnim7X:
	;Load CHR bank based on scroll X position
	lda TempIRQBufferScrollX
	and #$0F
CHRBankAnim7X_Ent6X:
	tay
	lda CHRSquaresCHRBankTable,y
	sta TempCHRBanks+1
	rts
CHRSquaresCHRBankTable:
	.db $00,$76,$74,$72,$70,$6E,$6C,$6A,$68,$3E,$3C,$3A,$38,$20,$1C,$02

CHRBankAnim3X_DoSub:
	;Do jump table
	lda BGDarkRoomMode
	jsr DoJumpTable
CHRBankAnim3XJumpTable:
	.dw CHRBankAnim3X_Sub0	;$00  Flash
	.dw CHRBankAnim3X_Sub1	;$01  Dark clear part 1
	.dw CHRBankAnim3X_Sub2	;$02  Dark clear part 2
	.dw CHRBankAnim3X_Sub3	;$03  Dark wait
	.dw CHRBankAnim3X_Sub4	;$04  Dark main
;$00: Flash
CHRBankAnim3X_Sub0:
	;Decrement animation timer
	dec BGDarkRoomTimer
	;If animation timer $80-$FF, exit early
	lda BGDarkRoomTimer
	bmi CHRBankAnim3X_Sub4
	;If bits 0-3 of animation timer not 0, exit early
	and #$0F
	bne CHRBankAnim3X_Sub4
	;Load CHR banks for light/dark room based on bit 4 of animation timer
	lda BGDarkRoomTimer
	and #$10
	bne CHRBankAnim3X_Sub0_Dark
CHRBankAnim3X_Sub0_Light:
	;Load CHR banks (light)
	lda #$28
	sta TempCHRBanks
	lda #$4C
	sta TempCHRBanks+1
	rts
CHRBankAnim3X_Sub0_Dark:
	;Load CHR banks (dark)
	lda #$7E
	sta TempCHRBanks
	sta TempCHRBanks+1
	;If animation timer $10, setup next task ($01: Dark clear part 1)
	lda BGDarkRoomTimer
	cmp #$10
	beq CHRBankAnim3X_Sub0_Next
;$04: Dark main
CHRBankAnim3X_Sub4:
	rts
CHRBankAnim3X_Sub0_Next:
	;Init VRAM address
	lda #$00
	sta BGDarkRoomVRAMAddrLo
	lda #$20
	sta BGDarkRoomVRAMAddrHi
	;Next task (Dark clear part 1)
	inc BGDarkRoomMode
	rts
;$01: Dark clear part 1
CHRBankAnim3X_Sub1:
	;Clear VRAM section
	jsr CHRDarkRoomClearVRAM
	;If VRAM address not $2300-$23FF, exit early
	lda BGDarkRoomVRAMAddrHi
	cmp #$23
	bne CHRBankAnim3X_Sub4
	;Increment VRAM address
	inc BGDarkRoomVRAMAddrHi
	;Next task ($02: Dark clear part 2)
	inc BGDarkRoomMode
	rts
;$02: Dark clear part 2
CHRBankAnim3X_Sub2:
	;Clear VRAM section
	jsr CHRDarkRoomClearVRAM
	;If VRAM address not $2700-$27FF, exit early
	lda BGDarkRoomVRAMAddrHi
	cmp #$27
	bne CHRBankAnim3X_Sub4
	;Set enemy sprite
	lda #$00
	sta Enemy_SpriteHi+$01
	sta Enemy_SpriteHi+$02
	sta Enemy_SpriteHi+$03
	;Next task ($03: Dark wait)
	inc BGDarkRoomMode
	;Reset animation timer
	lda #$10
	sta BGDarkRoomTimer
	rts
;$03: Dark wait
CHRBankAnim3X_Sub3:
	;Decrement animation timer, check if 0
	dec BGDarkRoomTimer
	bne CHRBankAnim3X_Sub4
	;Next task ($02: Dark main)
	inc BGDarkRoomMode
	;Load CHR banks
	bne CHRBankAnim3X_Sub0_Light
CHRDarkRoomClearVRAM:
	;If bit 0 of global timer 0, exit early
	lda LevelGlobalTimer
	and #$01
	beq CHRBankAnim3X_Sub4
	;Init VRAM buffer row
	jsr WriteVRAMBufferCmd_InitRow
	;Set VRAM buffer address
	ldy BGDarkRoomVRAMAddrHi
	lda BGDarkRoomVRAMAddrLo
	jsr WriteVRAMBufferCmd_Addr
	;Clear VRAM tiles
	lda #$40
	sta $00
	lda #$00
CHRDarkRoomClearVRAM_Loop:
	;Set tile in VRAM
	sta VRAMBuffer,x
	inx
	dec $00
	bne CHRDarkRoomClearVRAM_Loop
	;End VRAM buffer
	jsr WriteVRAMBufferCmd_End
	;Increment VRAM address
	lda BGDarkRoomVRAMAddrLo
	clc
	adc #$40
	sta BGDarkRoomVRAMAddrLo
	lda BGDarkRoomVRAMAddrHi
	adc #$00
	sta BGDarkRoomVRAMAddrHi
CHRDarkRoomClearVRAM_Exit:
	rts

;$A0: Level 8 background pattern
CHRBankAnimAX:
	;Load CHR bank based on scroll X position
	lda TempMirror_PPUSCROLL_X
	and #$1F
	lsr
	lsr
	tay
	lda CHRLevel8PatternCHRBankTable,y
	sta TempCHRBanks+1

;$C0: Level 8 glass pipes area
CHRBankAnimCX:
	;If bits 0-3 of global timer not 0, exit early
	lda LevelGlobalTimer
	and #$0F
	bne CHRDarkRoomClearVRAM_Exit
	;Increment animation timer
	jsr CHRLevel7BossIncTimer
	;Load palette
	lda CHRLevel8GlassPipesPaletteTable,y
	bne CHRBankAnimBX_SetPalette
CHRLevel8PatternCHRBankTable:
	.db $30,$32,$1E,$22,$34,$3C,$3E,$78
CHRLevel8GlassPipesPaletteTable:
	.db $C0,$C1,$D0,$D5,$D5,$D0,$C1,$C0

;$B0: Level 8 end stars
CHRBankAnimBX:
	;If bits 0-1 of global timer not 0, exit early
	lda LevelGlobalTimer
	and #$03
	bne CHRDarkRoomClearVRAM_Exit
	;Load palette
	lda CurPalette
	eor #$81
CHRBankAnimBX_SetPalette:
	sta CurPalette
	rts

;$E0: Level 8 miniboss ship
CHRBankAnimEX:
	;If bits 0-1 of global timer not 0, exit early
	lda LevelGlobalTimer
	and #$03
	bne CHRDarkRoomClearVRAM_Exit
	;Toggle animation timer
	lda BGPalAnimTimer
	eor #$01
	sta BGPalAnimTimer
	;Load palette
	tay
	lda CHRLevel8MinibossShipPaletteTable,y
	bne CHRBankAnimBX_SetPalette
CHRLevel8MinibossShipPaletteTable:
	.db $D2,$D3

;$D0: Level 7 boss
CHRBankAnimDX:
	;If bits 0-2 of global timer not 0, exit early
	lda LevelGlobalTimer
	and #$07
	bne CHRDarkRoomClearVRAM_Exit
	;Increment animation timer
	jsr CHRLevel7BossIncTimer
	;Load palette
	lda CHRLevel7BossPaletteTable,y
	bne CHRBankAnimBX_SetPalette
CHRLevel7BossIncTimer:
	;Increment animation timer
	inc DialogCursorY
	lda DialogCursorY
	and #$07
	sta DialogCursorY
	tay
	rts
CHRLevel7BossPaletteTable:
	.db $D8,$D8,$D9,$DA,$DB,$DB,$DA,$D9

LevelAreaAnimSetTable:
	.db $00,$00,$10,$10,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.db $14,$10,$10,$12,$00,$03,$60,$65,$70,$00,$00,$00,$00,$00,$00,$00
	.db $06,$26,$26,$26,$06,$F0,$00,$F1,$F2,$10,$00,$00,$00,$00,$00,$00
	.db $04,$00,$0B,$F3,$03,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.db $50,$50,$50,$50,$60,$60,$50,$50,$60,$80,$80,$80,$88,$F4,$F5,$F7
	.db $00,$00,$00,$00,$F6,$30,$30,$30,$40,$00,$00,$00,$00,$00,$00,$00
	.db $90,$90,$90,$90,$09,$09,$29,$07,$07,$07,$07,$20,$20,$20,$D0,$00
	.db $A0,$A0,$C0,$A0,$F8,$EA,$0C,$B0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;ENEMY BG COLLISION ROUTINES;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
CheckEnemyBG:
	;Check enemy BG collision Y
	jsr CheckEnemyBGY
	;Check enemy BG collision X
	jmp CheckEnemyBGX

CheckEnemyBGY:
	;Check if enemy not moving up or down
	lda Enemy_YVelHi,x
	ora Enemy_YVelLo,x
	bne CheckEnemyBGY_NoNone
	;Get collision type bottom left
	lda Enemy_CollWidth,x
	sec
	sbc #$02
	sta $09
	lda Enemy_X,x
	sec
	sbc $09
	bcs CheckEnemyBGY_NoXC
	adc $09
CheckEnemyBGY_NoXC:
	sta $00
	lda Enemy_Y,x
	clc
	adc Enemy_CollHeight,x
	sta $01
	jsr GetCollisionType
	sta $08
	;Get collision type bottom right
	lda Enemy_X,x
	clc
	adc $09
	bcc CheckEnemyBGY_NoXC2
	sbc $09
CheckEnemyBGY_NoXC2:
	sta $00
	jsr GetCollisionType
	;If solid tile at bottom right and not bottom left, check enemy facing direction
	bne CheckEnemyBGY_LeftCheck
	lda $08
	beq CheckEnemyBGY_SetY
	;If enemy facing right, check to turn around
	lda Enemy_Props,x
	and #$40
	beq CheckEnemyBGX_TurnCheck
	rts
CheckEnemyBGY_LeftCheck:
	;If solid tile at bottom left and not bottom right, check enemy facing direction
	lda $08
	bne CheckEnemyBGY_BlinkyCheck
	;If enemy facing left, check to turn around
	lda Enemy_Props,x
	and #$40
	bne CheckEnemyBGX_TurnCheck
	rts
CheckEnemyBGY_BlinkyCheck:
	;Check for Blinky fire
	lda Enemy_ID,x
	cmp #ENEMY_BLINKYFIRE
	bne CheckEnemyBGY_Exit
	;Clear enemy flags
	lda #$00
	sta Enemy_Flags,x
	rts
CheckEnemyBGY_SetY:
	;Set enemy Y acceleration
	lda #$7F
	sta Enemy_YAccel,x
CheckEnemyBGY_Exit:
	rts
CheckEnemyBGY_NoNone:
	;If enemy Y velocity >= $06, clear enemy Y acceleration
	lda Enemy_YVelHi,x
	bmi CheckEnemyBGY_NoTerm
	cmp #$06
	bcc CheckEnemyBGY_NoTerm
	;Clear enemy Y acceleration
	lda #$00
	sta Enemy_YAccel,x
CheckEnemyBGY_NoTerm:
	;Get collision type bottom
	jsr GetCollisionTypeBottom
	;If no solid tile at bottom, exit early
	beq CheckEnemyBGY_Exit
	;Check for death collision type
	cmp #$04
	bne CheckEnemyBGY_NoDeath
	;Check for boulder animation
	lda Enemy_Anim,x
	cmp #$E0
	bne CheckEnemyBGY_Exit
	;Set enemy priority to be behind background
	lda Enemy_Props,x
	ora #$20
	sta Enemy_Props,x
CheckEnemyBGY_NoDeath:
	;Check for semisolid collision type
	cmp #$01
	bne CheckEnemyBGY_ClearY
	;Check for Blinky fire
	lda Enemy_ID,x
	cmp #ENEMY_BLINKYFIRE
	beq CheckEnemyBGX_Bottom
CheckEnemyBGY_ClearY:
	;Clear enemy Y velocity/acceleration
	lda #$00
	sta Enemy_YAccel,x
	sta Enemy_YVelHi,x
	sta Enemy_YVelLo,x
	;Adjust enemy Y position for collision
	jmp ClipPlayerYEnemy_Any

CheckEnemyBGX:
	;Check if enemy not moving left or right
	lda Enemy_XVelHi,x
	beq CheckEnemyBGX_NoneExit
	;Check for enemy X velocity left
	bmi CheckEnemyBGX_Left
	;Get collision type right
	jsr GetCollisionTypeRight
	;If no solid tile at right, exit early
	beq CheckEnemyBGX_NoneExit
	;Check for semisolid collision type
	cmp #$01
	beq CheckEnemyBGX_NoSemisolid
	bne CheckEnemyBGX_BlinkyCheck
CheckEnemyBGX_Left:
	;Get collision type left
	jsr GetCollisionTypeLeft
	;If no solid tile at left, exit early
	beq CheckEnemyBGX_NoneExit
	;Check for semisolid collision type
	cmp #$01
	beq CheckEnemyBGX_NoSemisolid
	bne CheckEnemyBGX_BlinkyCheck
CheckEnemyBGX_TurnCheck:
	;Check for enemy turn around movement flag
	ldy Enemy_ID,x
	lda EnemyMovementFlags,y
	and #$10
	beq CheckEnemyBGX_NoneExit
CheckEnemyBGX_BlinkyCheck:
	;Check for Blinky fire
	lda Enemy_ID,x
	cmp #ENEMY_BLINKYFIRE
CheckEnemyBGX_FlipX:
	beq CheckEnemyBGX_ClearF
	;Flip enemy X velocity
	lda #$00
	sec
	sbc Enemy_XVelHi,x
	sta Enemy_XVelHi,x
	;Flip enemy X
	lda Enemy_Props,x
	eor #$40
	sta Enemy_Props,x
CheckEnemyBGX_NoneExit:
	rts
CheckEnemyBGX_ClearF:
	;Clear enemy flags
	lda #$00
	sta Enemy_Flags,x
	rts
CheckEnemyBGX_NoSemisolid:
	;Check for Blinky fire
	lda Enemy_ID,x
	cmp #ENEMY_BLINKYFIRE
	bne CheckEnemyBGX_FlipX
	;Set clear spikes position middle
	lda Enemy_X,x
	clc
	adc Enemy_XVelHi,x
	sta $00
	lda Enemy_Y,x
	sta $01
	bne CheckEnemyBGX_SpikesCheck
CheckEnemyBGX_Bottom:
	;Set clear spikes position bottom
	lda Enemy_X,x
	sta $00
	lda Enemy_Y,x
	clc
	adc #$08
	sta $01
CheckEnemyBGX_SpikesCheck:
	;Check for level 3/5
	lda CurLevel
	cmp #$02
	beq ClearSpikes
	cmp #$04
	beq ClearSpikes
	;Clear enemy flags
	lda #$00
	sta Enemy_Flags,x
CheckEnemyBGX_Exit:
	rts

ClearSpikes:
	;Save X register
	stx $17
	;Get position in middle of metatile X
	lda $00
	clc
	adc TempMirror_PPUSCROLL_X
	and #$F0
	ora #$08
	sec
	sbc TempMirror_PPUSCROLL_X
	sta $00
	;Get position in middle of metatile Y
	lda $01
	clc
	adc TempMirror_PPUSCROLL_Y
	and #$F0
	ora #$07
	sec
	sbc TempMirror_PPUSCROLL_Y
	sta $01
	;Get collision type
	jsr GetCollisionType
	;Check for semisolid collision type
	cmp #$01
	beq ClearSpikes_Semisolid
	;Check for level 5 big elevator area
	tay
	lda LevelAreaNum
	cmp #$4C
	bne CheckEnemyBGX_Exit
	;Check for death collision type
	tya
	cmp #$04
	bne CheckEnemyBGX_Exit
ClearSpikes_Semisolid:
	;If enemy X position < $10 or >= $F0, exit early
	lda Enemy_X,x
	cmp #$10
	bcc CheckEnemyBGX_Exit
	cmp #$F0
	bcs CheckEnemyBGX_Exit
	;Set enemy position
	lda $00
	sta Enemy_X,x
	lda $01
	sta Enemy_Y,x
	;Get VRAM data index
	ldy LevelAreaNum
	lda ClearSpikesVRAMOffs-$20,y
	sta $10
	lda $00
	and #$10
	lsr
	ora $10
	sta $10
	lda $01
	and #$10
	lsr
	lsr
	ora $10
	sta $10
	;Init VRAM buffer row
	jsr WriteVRAMBufferCmd_InitRow
	;Get VRAM address
	jsr GetVRAMAddr
	;Init VRAM buffer address
	ldy $08
	lda $09
	and #$DE
	sta $09
	sta $01
	jsr WriteVRAMBufferCmd_Addr
	;Set tiles in VRAM
	ldy $10
	lda ClearSpikesVRAMData-$20,y
	sta VRAMBuffer,x
	inx
	lda ClearSpikesVRAMData-$20+1,y
	sta VRAMBuffer,x
	inx
	;End VRAM buffer
	jsr WriteVRAMBufferCmd_End
	;Draw collision tile row
	ldy $08
	lda #$02
	sta $00
	lda #$00
	sta $02
	jsr DrawCollisionTileRow
	;Init VRAM buffer row
	jsr WriteVRAMBufferCmd_InitRow
	;Set VRAM buffer address
	ldy $08
	lda $09
	clc
	adc #$20
	sta $01
	jsr WriteVRAMBufferCmd_Addr
	;Set tiles in VRAM
	ldy $10
	lda ClearSpikesVRAMData-$20+2,y
	sta VRAMBuffer,x
	inx
	lda ClearSpikesVRAMData-$20+3,y
	sta VRAMBuffer,x
	inx
	;End VRAM buffer
	jsr WriteVRAMBufferCmd_End
	;Draw collision tile row
	ldy $08
	lda #$02
	sta $00
	jsr DrawCollisionTileRow
	;Restore X register
	ldx $17
	;Play sound
	ldy #SE_CRASH
	jsr LoadSound
	;Check for Jenny light ball
	lda Enemy_ID,x
	cmp #ENEMY_JENNYLIGHTBALL
	beq ClearSpikes_Exit
	;Clear enemy velocity
	lda #$00
	sta Enemy_XVelHi,x
	sta Enemy_YVelHi,x
	sta Enemy_YVelLo,x
	sta Enemy_ID,x
	;Set enemy Y acceleration
	lda #$20
	sta Enemy_YAccel,x
	;Set enemy ID to spike particles
	lda #ENEMY_SPIKEPARTICLES
	sta Enemy_ID,x
	;Set enemy animation timer
	lda #$14
	sta Enemy_Temp2,x
	;Check for level 5
	lda CurLevel
	cmp #$04
	beq ClearSpikes_NoIce
	;Set enemy animation (ice particles)
	ldy #$03
	jmp SetEnemyAnimation
ClearSpikes_NoIce:
	;Set enemy animation (spike particles)
	ldy #$95
	jmp SetEnemyAnimation
ClearSpikes_Exit:
	rts
ClearSpikesVRAMOffs:
	.db $00,$00,$00,$00,$00,$00,$20,$30,$30,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	.db $BD,$BD,$BD,$BD,$BD,$BD,$BD,$BD,$BD,$BD,$BD,$BD,$BD,$BD,$BD,$BD
	.db $30,$30,$30,$30,$30,$30,$30,$30,$30,$30,$30,$30,$30,$30,$30,$30
ClearSpikesVRAMData:
	.db $01,$02,$05,$06,$09,$0A,$0D,$0E,$03,$04,$07,$08,$0B,$0C,$0F,$10
	.db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

;;;;;;;;;;;;;;
;LEVEL 8 DATA;
;;;;;;;;;;;;;;
Level8TileData:
	.db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.db $30,$31,$32,$33,$40,$41,$42,$43,$50,$51,$52,$53,$60,$61,$62,$F1
	.db $34,$35,$36,$37,$F1,$45,$46,$47,$54,$55,$56,$57,$64,$65,$66,$67
	.db $17,$17,$17,$17,$7E,$7E,$7E,$7E,$50,$51,$52,$53,$60,$61,$62,$F1
	.db $30,$31,$32,$33,$40,$41,$42,$43,$00,$00,$00,$00,$00,$00,$00,$00
	.db $54,$55,$56,$57,$64,$65,$66,$67,$00,$00,$00,$00,$00,$00,$00,$00
	.db $54,$55,$56,$57,$64,$65,$66,$67,$54,$55,$56,$57,$64,$65,$66,$67
	.db $34,$35,$36,$37,$F1,$45,$46,$47,$7F,$7F,$7F,$7F,$16,$16,$16,$16
	.db $52,$53,$50,$51,$62,$F1,$60,$61,$50,$51,$52,$53,$60,$61,$62,$F1
	.db $34,$35,$36,$37,$F1,$45,$46,$47,$36,$37,$34,$35,$46,$47,$F1,$45
	.db $25,$25,$25,$25,$21,$21,$21,$21,$21,$21,$21,$21,$21,$21,$21,$21
	.db $00,$00,$00,$00,$6A,$6A,$6A,$6A,$28,$28,$28,$28,$27,$26,$27,$26
	.db $F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$17,$17,$17,$17,$7E,$7E,$7E,$7E
	.db $7F,$7F,$7F,$7F,$16,$16,$16,$16,$00,$00,$00,$00,$00,$00,$00,$00
	.db $00,$00,$00,$00,$17,$17,$17,$17,$7E,$7E,$7E,$7E,$5A,$5A,$5A,$5A
	.db $25,$25,$C9,$C7,$21,$21,$C8,$C6,$21,$21,$E8,$C5,$21,$21,$C8,$C6
	.db $00,$00,$00,$00,$00,$00,$00,$00,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0
	.db $00,$00,$00,$00,$10,$11,$11,$14,$12,$13,$13,$15,$12,$13,$13,$15
	.db $DD,$DD,$DD,$AC,$BC,$BD,$BC,$BD,$01,$E6,$F2,$F3,$00,$8D,$B4,$B5
	.db $00,$00,$C4,$C5,$00,$00,$8D,$D5,$00,$00,$00,$8F,$00,$00,$00,$00
	.db $F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0
	.db $17,$17,$17,$17,$7E,$7E,$7E,$7E,$30,$31,$32,$33,$40,$41,$42,$43
	.db $5A,$5A,$5A,$5A,$01,$01,$01,$01,$6D,$72,$72,$24,$6D,$72,$72,$72
	.db $5C,$5D,$5E,$04,$2A,$2B,$29,$2C,$01,$01,$01,$28,$73,$73,$73,$26
	.db $13,$15,$00,$00,$13,$15,$00,$00,$13,$15,$00,$00,$13,$15,$00,$00
	.db $00,$00,$00,$00,$00,$00,$00,$00,$30,$31,$32,$33,$40,$41,$42,$43
	.db $6D,$72,$72,$72,$6D,$72,$72,$24,$6D,$72,$72,$72,$5A,$5A,$5A,$5A
	.db $6D,$72,$72,$27,$72,$72,$72,$26,$5C,$5D,$5E,$04,$2A,$2B,$29,$2C
	.db $F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$30,$31,$32,$33,$40,$41,$42,$43
	.db $5A,$5A,$5A,$5A,$29,$29,$29,$29,$F0,$F0,$F0,$F0,$F0,$F0,$F0,$F0
	.db $00,$00,$00,$00,$2E,$2F,$2F,$2F,$00,$00,$00,$00,$00,$00,$00,$00
	.db $56,$00,$00,$56,$73,$2E,$2F,$73,$04,$00,$00,$04,$00,$00,$00,$00
	.db $00,$00,$00,$00,$00,$80,$81,$82,$C0,$C1,$C2,$C3,$D0,$D1,$D1,$D3
	.db $00,$00,$00,$00,$00,$00,$00,$00,$A6,$A7,$00,$00,$B6,$B7,$D4,$00
	.db $80,$81,$82,$00,$87,$C8,$83,$84,$97,$D8,$03,$85,$87,$C8,$E6,$01
	.db $00,$00,$00,$00,$00,$00,$00,$00,$86,$00,$00,$00,$83,$84,$00,$00
	.db $88,$89,$8A,$8B,$98,$99,$99,$9B,$A8,$A9,$AA,$AB,$B8,$B9,$BA,$BB
	.db $C6,$C7,$00,$00,$D6,$8E,$00,$00,$9F,$00,$00,$00,$00,$00,$00,$00
	.db $97,$D8,$03,$03,$87,$C8,$E6,$01,$97,$D8,$03,$EF,$87,$C8,$D4,$D7
	.db $03,$85,$86,$00,$01,$01,$83,$84,$C0,$C1,$C2,$C3,$D0,$D1,$D1,$D3
	.db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$CB,$EC,$90,$91
	.db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$92,$93,$94,$00
	.db $97,$D8,$D4,$D7,$87,$EE,$EE,$BD,$00,$00,$D4,$D7,$00,$00,$D4,$D7
	.db $DD,$DD,$DD,$AC,$BC,$BD,$BC,$BD,$DD,$DD,$DD,$AC,$DD,$DD,$DD,$AC
	.db $CB,$EC,$EC,$01,$CB,$F6,$F7,$EC,$CB,$F8,$F9,$EC,$EE,$DC,$DF,$CF
	.db $AE,$AF,$95,$00,$BE,$BF,$DE,$8C,$EC,$EC,$01,$9C,$CF,$CF,$CF,$96
	.db $C7,$CC,$CD,$AD,$C4,$CC,$CD,$AD,$F4,$F5,$F2,$F3,$B6,$B7,$B4,$B5
	.db $AD,$DB,$CE,$00,$AD,$DB,$CE,$00,$F4,$F5,$F2,$F3,$B6,$B7,$B4,$B5
	.db $DD,$DD,$DD,$AC,$BC,$BD,$BC,$BD,$B0,$B1,$DD,$AC,$B2,$B3,$DD,$AC
	.db $DD,$DD,$DD,$AC,$BC,$BD,$BC,$BD,$C9,$CA,$DD,$AC,$D9,$DA,$DD,$AC
	.db $EC,$DD,$DD,$AC,$E0,$BD,$BC,$BD,$E5,$F5,$F2,$F3,$E4,$B7,$B4,$B5
	.db $DD,$DD,$DD,$AC,$BC,$BD,$BC,$BD,$F4,$F5,$F2,$F3,$B6,$B7,$B4,$B5
	.db $00,$00,$E0,$E1,$00,$00,$8D,$D5,$00,$00,$00,$8F,$00,$00,$00,$00
	.db $E2,$E3,$E0,$E1,$D6,$8E,$8D,$D5,$9F,$00,$00,$8F,$00,$00,$00,$00
	.db $E2,$C7,$C4,$C5,$D6,$8E,$8D,$D5,$9F,$00,$00,$8F,$00,$00,$00,$00
	.db $C6,$C7,$C4,$C5,$D6,$8E,$8D,$D5,$9F,$00,$00,$8F,$00,$00,$00,$00
	.db $00,$12,$13,$13,$00,$12,$13,$13,$00,$12,$13,$13,$00,$12,$13,$13
	.db $08,$09,$0A,$0B,$0C,$0D,$0E,$0F,$00,$00,$00,$00,$F0,$F0,$F0,$F0
	.db $00,$00,$00,$00,$07,$07,$00,$07,$00,$00,$00,$00,$00,$00,$00,$00
	.db $00,$00,$00,$00,$00,$00,$00,$00,$07,$00,$07,$07,$00,$00,$00,$00
	.db $00,$00,$00,$00,$A0,$A2,$FA,$FA,$A1,$A3,$FB,$FB,$00,$00,$00,$00
	.db $00,$00,$00,$00,$FA,$FA,$FA,$FA,$FB,$FB,$FB,$FB,$00,$00,$00,$00
	.db $18,$19,$00,$1C,$3C,$3D,$3E,$3F,$4C,$4D,$4E,$4F,$1A,$1B,$00,$1D
	.db $E7,$E7,$EC,$E7,$E8,$E8,$EB,$E8,$E9,$E9,$EC,$E9,$EA,$EA,$ED,$EA
	.db $00,$1D,$47,$53,$1C,$37,$3F,$35,$1D,$63,$00,$61,$00,$1C,$47,$1D
	.db $36,$37,$50,$51,$46,$36,$47,$53,$29,$4E,$00,$00,$1B,$00,$1B,$00
	.db $52,$53,$3F,$57,$53,$53,$3C,$3F,$1B,$45,$4C,$4F,$00,$00,$4F,$43
	.db $38,$39,$3A,$3B,$38,$39,$3A,$3B,$38,$39,$3A,$3B,$48,$49,$4A,$4B
	.db $08,$09,$0A,$0B,$0C,$0D,$0E,$0F,$02,$05,$00,$00,$02,$05,$F0,$F0
	.db $00,$00,$00,$00,$2E,$2F,$2F,$2F,$00,$00,$00,$00,$02,$05,$00,$00
	.db $02,$05,$00,$00,$02,$05,$00,$00,$02,$05,$00,$00,$02,$05,$00,$00
	.db $48,$49,$4A,$4B,$38,$39,$3A,$3B,$38,$39,$3A,$3B,$38,$39,$3A,$3B
	.db $38,$39,$3A,$3B,$38,$39,$3A,$3B,$38,$39,$3A,$3B,$38,$39,$3A,$3B
	.db $00,$6B,$6C,$00,$00,$6B,$6C,$00,$00,$6B,$6C,$00,$00,$6B,$6C,$00
	.db $00,$76,$77,$00,$00,$74,$75,$00,$00,$76,$77,$00,$00,$74,$75,$00
	.db $00,$78,$79,$00,$00,$78,$79,$00,$00,$78,$79,$00,$00,$78,$79,$00
	.db $00,$00,$00,$00,$00,$00,$00,$00,$10,$11,$11,$11,$12,$13,$13,$13
	.db $00,$00,$00,$00,$00,$00,$00,$00,$11,$11,$11,$11,$13,$13,$13,$13
	.db $00,$00,$00,$00,$00,$00,$00,$00,$11,$11,$11,$14,$13,$13,$13,$15
	.db $6D,$72,$72,$72,$6D,$22,$23,$72,$6D,$7C,$7D,$72,$6D,$72,$72,$72
	.db $36,$37,$B4,$B5,$46,$47,$C4,$C5,$9E,$9E,$9E,$9E,$00,$00,$00,$00
	.db $B6,$B7,$B4,$B5,$C6,$C7,$C4,$C5,$9E,$9E,$9E,$9E,$00,$00,$00,$00
	.db $B6,$B7,$52,$53,$C6,$C7,$50,$51,$9E,$9E,$60,$61,$00,$00,$00,$00
	.db $34,$35,$36,$37,$44,$45,$46,$47,$5B,$5B,$5B,$5B,$00,$00,$00,$00
	.db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$9D,$9D,$34,$35
	.db $21,$21,$21,$21,$21,$21,$21,$21,$21,$21,$21,$21,$21,$21,$21,$21
	.db $21,$21,$E8,$C5,$21,$21,$C8,$C6,$21,$21,$E8,$C5,$21,$21,$C8,$C6
	.db $34,$35,$36,$37,$44,$45,$46,$47,$5B,$5B,$5B,$5B,$A5,$29,$29,$A5
	.db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$9D,$9D,$9D,$9D
	.db $00,$00,$00,$00,$17,$6E,$6A,$6A,$7E,$7A,$00,$28,$5A,$D2,$28,$26
	.db $00,$00,$00,$00,$6A,$6A,$6F,$17,$28,$28,$7B,$7E,$27,$26,$9A,$5A
	.db $2D,$2D,$2D,$2D,$5F,$5F,$5F,$5F,$00,$00,$00,$00,$00,$00,$00,$00
	.db $52,$53,$B4,$B5,$62,$63,$C4,$C5,$00,$00,$00,$00,$5A,$5A,$5A,$5A
	.db $B6,$B7,$B4,$B5,$C6,$C7,$C4,$C5,$A4,$04,$04,$A4,$5A,$5A,$5A,$5A
	.db $B6,$B7,$44,$45,$C6,$C7,$46,$47,$00,$00,$00,$00,$5A,$5A,$5A,$5A
	.db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$5A,$5A,$5A,$5A
	.db $00,$1F,$00,$00,$00,$00,$00,$00,$00,$00,$1E,$00,$06,$00,$00,$00
	.db $00,$1E,$00,$00,$00,$00,$00,$06,$00,$00,$00,$00,$00,$00,$1F,$00
	.db $00,$00,$00,$00,$00,$00,$1F,$00,$00,$00,$00,$00,$00,$06,$00,$1E
	.db $02,$05,$F0,$F0,$02,$05,$F0,$F0,$02,$05,$F0,$F0,$02,$05,$F0,$F0
	.db $DD,$DD,$DD,$AC,$BC,$BD,$BC,$BD,$F4,$F5,$C4,$C7,$B6,$B7,$B7,$04
	.db $DD,$DD,$DD,$AC,$BC,$BD,$BC,$BD,$C8,$E6,$01,$E6,$00,$00,$04,$04
Level8AttrData:
	.db $AA,$F0,$0F,$F0,$00,$00,$00,$0F,$FF,$FF,$55,$F0,$05,$00,$00,$55
	.db $55,$00,$AA,$5A,$55,$00,$00,$0F,$00,$00,$00,$F0,$05,$50,$50,$00
	.db $AA,$AA,$AA,$AA,$AA,$9A,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA,$AA
	.db $8A,$8A,$AA,$AA,$59,$5A,$5A,$5A,$00,$55,$55,$55,$55,$55,$FF,$00
	.db $FF,$FF,$FF,$AA,$45,$40,$00,$AA,$AA,$00,$00,$00,$00,$00,$00,$00
	.db $5B,$5A,$1E,$0F,$10,$55,$55,$0F,$50,$C0,$30,$00,$0B,$0A,$0E,$00
	.db $AA,$AA,$AA,$44,$AA,$AA
Level8BGPointerData:
	;Area 0
	.dw Level8BGData+$0000
	.dw Level8BGData+$0030
	;Area 1
	.dw Level8BGData+$0240
	.dw Level8BGData+$0240
	.dw Level8BGData+$0060
	.dw Level8BGData+$0210
	.dw Level8BGData+$0240
	.dw Level8BGData+$0060
	.dw Level8BGData+$00C0
	.dw Level8BGData+$0240
	.dw Level8BGData+$00C0
	.dw Level8BGData+$0060
	.dw Level8BGData+$00F0
	.dw Level8BGData+$0120
	.dw Level8BGData+$0210
	.dw Level8BGData+$0060
	.dw Level8BGData+$0090
	.dw Level8BGData+$00C0
	.dw Level8BGData+$00F0
	.dw Level8BGData+$0120
	.dw Level8BGData+$0150
	.dw Level8BGData+$0180
	.dw Level8BGData+$01B0
	.dw Level8BGData+$01E0
	.dw Level8BGData+$0210
	.dw Level8BGData+$0240
	;Area 2
	.dw Level8BGData+$0270
	.dw Level8BGData+$0270
	.dw Level8BGData+$02A0
	.dw Level8BGData+$02D0
	.dw Level8BGData+$0330
	.dw Level8BGData+$0300
	.dw Level8BGData+$02A0
	.dw Level8BGData+$0270
	.dw Level8BGData+$0330
	.dw Level8BGData+$0300
	.dw Level8BGData+$02A0
	;Area 3
	.dw Level8BGData+$0270
	.dw Level8BGData+$0270
	.dw Level8BGData+$00C0
	.dw Level8BGData+$01B0
	.dw Level8BGData+$01E0
	.dw Level8BGData+$0180
	.dw Level8BGData+$01B0
	.dw Level8BGData+$01E0
	.dw Level8BGData+$0120
	.dw Level8BGData+$0150
	.dw Level8BGData+$00F0
	.dw Level8BGData+$0210
	.dw Level8BGData+$0210
	.dw Level8BGData+$0060
	.dw Level8BGData+$0240
	.dw Level8BGData+$0210
	;Area 4
	.dw Level8BGData+$0270
	.dw Level8BGData+$0360
	.dw Level8BGData+$0360
	.dw Level8BGData+$0390
	.dw Level8BGData+$0360
	.dw Level8BGData+$0390
	.dw Level8BGData+$0360
	.dw Level8BGData+$0360
	.dw Level8BGData+$0360
	.dw Level8BGData+$0360
	.dw Level8BGData+$03C0
	;Area 5
	.dw Level8BGData+$03C0
	.dw Level8BGData+$0420
	.dw Level8BGData+$03F0
	.dw Level8BGData+$0420
	.dw Level8BGData+$03F0
	.dw Level8BGData+$0420
	.dw Level8BGData+$03C0
	.dw Level8BGData+$03C0
	.dw Level8BGData+$03C0
	.dw Level8BGData+$03C0
	.dw Level8BGData+$03C0
	.dw Level8BGData+$03C0
	.dw Level8BGData+$03C0
	.dw Level8BGData+$03C0
	;Area 6
	.dw Level8BGData+$0450
	.dw Level8BGData+$0450
	.dw Level8BGData+$0450
	.dw Level8BGData+$0480
	.dw Level8BGData+$0450
	.dw Level8BGData+$0450
	.dw Level8BGData+$0450
	.dw Level8BGData+$04B0
	.dw Level8BGData+$04B0
	.dw Level8BGData+$04B0
Level8BGData:
	.db $09,$09,$09,$09,$09,$4F,$09,$09
	.db $02,$02,$02,$02,$02,$4F,$02,$02
	.db $00,$00,$00,$00,$00,$1F,$45,$1E
	.db $00,$00,$00,$00,$00,$00,$63,$14
	.db $00,$11,$11,$11,$11,$00,$63,$1C
	.db $01,$01,$01,$01,$01,$01,$01,$08
	.db $09,$4F,$09,$09,$09,$09,$09,$09
	.db $02,$4F,$02,$02,$02,$02,$02,$02
	.db $1E,$1F,$1E,$1E,$1E,$1E,$1E,$1E
	.db $14,$14,$14,$14,$14,$14,$14,$14
	.db $1C,$01,$01,$1D,$1D,$1D,$1D,$14
	.db $08,$08,$08,$01,$1C,$1C,$1C,$1C
	.db $4F,$09,$09,$09,$09,$09,$09,$09
	.db $4F,$02,$02,$02,$02,$02,$02,$02
	.db $4F,$1F,$1E,$1E,$1E,$1E,$1E,$1E
	.db $04,$14,$14,$14,$14,$14,$14,$14
	.db $14,$14,$14,$14,$14,$14,$14,$14
	.db $03,$03,$03,$03,$03,$03,$03,$03
	.db $4F,$09,$09,$02,$02,$09,$09,$10
	.db $4F,$09,$09,$1E,$1E,$09,$09,$14
	.db $1F,$02,$09,$14,$14,$02,$02,$14
	.db $14,$10,$02,$14,$14,$10,$10,$14
	.db $14,$14,$10,$14,$14,$14,$14,$14
	.db $14,$14,$14,$14,$14,$1C,$1C,$1C
	.db $10,$02,$02,$02,$02,$02,$02,$02
	.db $14,$10,$10,$10,$10,$10,$10,$10
	.db $14,$14,$14,$14,$14,$14,$14,$14
	.db $14,$14,$14,$14,$14,$14,$04,$04
	.db $14,$0C,$0C,$14,$14,$14,$14,$14
	.db $1C,$08,$08,$1C,$1C,$01,$01,$01
	.db $02,$02,$09,$09,$09,$09,$09,$09
	.db $10,$10,$07,$07,$07,$4F,$4F,$4F
	.db $14,$14,$10,$10,$10,$02,$02,$02
	.db $14,$14,$14,$14,$14,$10,$10,$10
	.db $14,$14,$14,$14,$14,$14,$15,$15
	.db $01,$1C,$1C,$1C,$1C,$01,$01,$01
	.db $02,$09,$09,$02,$02,$09,$09,$02
	.db $10,$0D,$0D,$10,$10,$05,$05,$10
	.db $14,$14,$14,$14,$14,$14,$14,$14
	.db $14,$14,$14,$14,$14,$1C,$1C,$14
	.db $14,$14,$14,$14,$14,$4F,$4F,$14
	.db $1C,$1C,$1C,$01,$0C,$08,$08,$0C
	.db $02,$02,$02,$02,$02,$09,$09,$09
	.db $10,$10,$10,$10,$10,$05,$05,$05
	.db $14,$14,$14,$14,$14,$14,$14,$14
	.db $14,$0C,$0C,$14,$14,$14,$14,$14
	.db $14,$4F,$4F,$14,$14,$14,$14,$14
	.db $0C,$08,$08,$0C,$0C,$01,$01,$01
	.db $02,$02,$02,$02,$02,$09,$02,$02
	.db $0D,$0D,$10,$10,$10,$06,$0D,$0D
	.db $14,$14,$14,$14,$0C,$06,$14,$14
	.db $14,$14,$14,$14,$04,$05,$14,$14
	.db $39,$14,$14,$14,$14,$14,$14,$14
	.db $1C,$1C,$1C,$1C,$1C,$1C,$1C,$15
	.db $02,$02,$02,$02,$02,$02,$02,$02
	.db $10,$10,$10,$10,$10,$10,$10,$10
	.db $39,$14,$14,$1C,$1C,$1C,$14,$14
	.db $14,$14,$14,$0D,$10,$01,$5B,$5B
	.db $14,$14,$14,$14,$14,$01,$01,$14
	.db $15,$1C,$1C,$1C,$1C,$08,$08,$1C
	.db $02,$02,$02,$02,$02,$02,$02,$02
	.db $10,$10,$0D,$0D,$0D,$0D,$06,$06
	.db $14,$14,$14,$14,$14,$14,$10,$06
	.db $5B,$14,$14,$14,$14,$1C,$05,$05
	.db $14,$14,$39,$14,$14,$10,$14,$14
	.db $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C
	.db $02,$02,$02,$02,$02,$02,$02,$02
	.db $0D,$0D,$0D,$0D,$0D,$0D,$0D,$0D
	.db $14,$14,$14,$14,$14,$14,$14,$14
	.db $14,$14,$14,$14,$14,$14,$14,$14
	.db $14,$14,$14,$14,$14,$14,$14,$14
	.db $1C,$15,$15,$15,$15,$15,$15,$15
	.db $02,$02,$02,$02,$02,$02,$02,$02
	.db $10,$10,$10,$10,$10,$10,$10,$10
	.db $14,$14,$14,$14,$14,$14,$14,$14
	.db $14,$14,$14,$14,$14,$14,$14,$14
	.db $14,$14,$14,$14,$14,$14,$14,$14
	.db $1C,$1C,$1C,$1C,$1C,$1C,$1C,$1C
	.db $1B,$1B,$1B,$1B,$1B,$1B,$1B,$1B
	.db $46,$00,$38,$18,$38,$18,$38,$18
	.db $46,$00,$38,$18,$38,$18,$38,$18
	.db $46,$00,$38,$18,$38,$18,$38,$18
	.db $46,$00,$38,$18,$38,$18,$38,$18
	.db $17,$17,$17,$17,$17,$17,$17,$17
	.db $02,$02,$02,$02,$02,$48,$4F,$09
	.db $00,$00,$00,$00,$00,$43,$05,$05
	.db $00,$00,$3A,$00,$00,$49,$00,$00
	.db $00,$00,$00,$00,$00,$49,$00,$00
	.db $00,$00,$00,$00,$00,$47,$19,$19
	.db $01,$01,$01,$01,$01,$48,$4F,$09
	.db $09,$00,$00,$00,$00,$00,$00,$48
	.db $05,$05,$05,$06,$00,$00,$00,$48
	.db $00,$00,$00,$05,$5B,$5B,$05,$43
	.db $00,$3A,$00,$00,$00,$00,$00,$49
	.db $19,$19,$19,$3A,$00,$3B,$00,$49
	.db $09,$00,$04,$04,$5B,$5B,$04,$47
	.db $00,$00,$00,$00,$00,$4F,$4F,$48
	.db $05,$05,$05,$05,$05,$05,$05,$43
	.db $3A,$00,$00,$00,$00,$00,$3A,$49
	.db $00,$00,$00,$00,$00,$00,$00,$49
	.db $00,$00,$3A,$00,$00,$19,$19,$47
	.db $19,$19,$19,$19,$19,$4F,$4F,$48
	.db $4F,$4F,$48,$4F,$4F,$48,$16,$16
	.db $05,$05,$43,$05,$05,$43,$1A,$1A
	.db $00,$00,$49,$00,$00,$49,$00,$3A
	.db $00,$00,$49,$3A,$00,$49,$00,$00
	.db $19,$19,$47,$19,$19,$47,$16,$16
	.db $4F,$4F,$48,$4F,$4F,$48,$1A,$1A
	.db $53,$53,$53,$53,$53,$53,$53,$53
	.db $00,$00,$00,$00,$00,$00,$00,$00
	.db $00,$00,$00,$3A,$00,$00,$3B,$00
	.db $00,$00,$3B,$00,$00,$00,$00,$3A
	.db $00,$00,$00,$00,$00,$00,$00,$00
	.db $5F,$5F,$5F,$5F,$5F,$5F,$5F,$5F
	.db $53,$57,$53,$53,$53,$53,$53,$53
	.db $50,$51,$52,$00,$00,$00,$00,$00
	.db $00,$00,$00,$00,$00,$3B,$00,$00
	.db $00,$00,$3A,$00,$00,$00,$00,$00
	.db $58,$58,$54,$00,$00,$00,$00,$00
	.db $5C,$5D,$5E,$5F,$5F,$5F,$5F,$5F
	.db $00,$00,$00,$00,$00,$00,$00,$00
	.db $00,$00,$00,$00,$00,$00,$00,$00
	.db $00,$00,$00,$00,$00,$00,$00,$00
	.db $00,$00,$00,$00,$00,$00,$00,$00
	.db $00,$00,$00,$00,$00,$00,$00,$00
	.db $0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E
	.db $00,$00,$00,$00,$00,$22,$23,$00
	.db $00,$00,$00,$00,$00,$26,$27,$20
	.db $00,$00,$00,$00,$00,$2A,$2B,$2B
	.db $00,$00,$3C,$3D,$3E,$3F,$3F,$3F
	.db $00,$00,$00,$00,$00,$34,$35,$35
	.db $0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E
	.db $00,$00,$00,$00,$00,$00,$00,$00
	.db $20,$20,$20,$20,$20,$28,$29,$00
	.db $2B,$31,$31,$31,$31,$2C,$2D,$00
	.db $32,$64,$65,$12,$33,$2E,$2F,$21
	.db $36,$25,$00,$13,$37,$37,$37,$25
	.db $0E,$0E,$0E,$0E,$0E,$59,$0B,$5A
	.db $1B,$1B,$1B,$1B,$1B,$1B,$1B,$1B
	.db $00,$00,$00,$00,$00,$00,$00,$00
	.db $00,$00,$00,$00,$00,$00,$00,$00
	.db $00,$00,$00,$00,$00,$00,$00,$00
	.db $00,$00,$00,$00,$00,$00,$00,$00
	.db $17,$17,$17,$17,$17,$17,$17,$17
	.db $1B,$1B,$1B,$1B,$1B,$1B,$1B,$1B
	.db $00,$00,$00,$00,$0A,$0A,$0A,$0F
	.db $00,$00,$00,$00,$55,$55,$55,$56
	.db $00,$00,$00,$00,$55,$55,$55,$56
	.db $00,$00,$00,$00,$55,$55,$55,$56
	.db $17,$17,$17,$17,$17,$17,$17,$17
	.db $60,$61,$62,$00,$61,$60,$60,$60
	.db $61,$00,$60,$62,$00,$62,$00,$61
	.db $60,$62,$62,$61,$60,$60,$61,$60
	.db $62,$00,$60,$00,$00,$61,$62,$00
	.db $00,$61,$00,$62,$61,$00,$62,$61
	.db $62,$61,$61,$60,$00,$61,$60,$00

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;PLAYER CONTROL ROUTINES (ESCAPE POD);
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ControlPlayer_EP:
	;If auto control enabled, mask joypad bits
	lda AutoEscapePodFlag
	beq ControlPlayer_EP_NoAuto
	;Mask joypad bits
	jsr MaskJoypadBits
ControlPlayer_EP_NoAuto:
	;Do tasks
	jsr HandleCharacterChange_EP
	jsr HandlePlayerMovementY_EP
	jsr HandlePlayerMovementX_EP
	jsr HandlePlayerShooting_EP
	jsr HandlePlayerCollision_EP
	jsr HandlePlayerScrolling_EP
	;If player HP 0, exit early
	lda Enemy_HP
	beq ControlPlayer_EP_Exit
	;Check if we've reached the next area
	lda LevelAreaNum
	and #$0F
	tay
	lda EPModeAreaScreenTable,y
	cmp CurScreen
	bne ControlPlayer_EP_Exit
	;Clear IRQ buffer
	jsr ClearCollisionBuffer_IRQ
	;Load palette
	lda EPModePaletteTable,y
	sta CurPalette
	;Load CHR bank set
	lda EPModeCHRBankSetTable,y
	tax
	jsr LoadCHRBankSet
	;Load IRQ buffer set
	lda LevelAreaNum
	and #$0F
	tay
	lda EPModeIRQBufSetTable,y
	tax
	jsr LoadIRQBufferSet
	;Increment area number
	inc LevelAreaNum
	lda CurArea
	clc
	adc #$08
	sta CurArea
	;Set level tile collision range
	jmp SetLevelTileCollRange
ControlPlayer_EP_Exit:
	rts

;ESCAPE POD MODE AREA DATA
EPModeAreaScreenTable:
	.db     $02,$1A,$25,$35,$40,$4D
EPModePaletteTable:
	.db     $C0,$C0,$C0,$D2,$D2,$D6
EPModeCHRBankSetTable:
	.db     $46,$46,$46,$62,$46,$5E
EPModeIRQBufSetTable:
	.db     $00,$00,$00,$00,$2E,$00
EPModeScrollSpeedTable:
	.db $02,$02,$02,$03,$02,$02,$03

HandlePlayerScrolling_EP:
	;If past end of level, exit early
	lda CurScreen
	cmp #$55
	bcs HandlePlayerScrolling_EP_Exit
	;Set scrolling speed
	ldy LevelAreaNum
	lda EPModeScrollSpeedTable-$70,y
	sta ScrollXVelHi
	lda #$00
	sta AreaScrollFlags
	sta Enemy_Props
HandlePlayerScrolling_EP_Exit:
	rts

HandlePlayerCollision_EP:
	;If player HP 0, exit early
	lda Enemy_HP
	beq HandlePlayerScrolling_EP_Exit
	;Handle collision right
	ldx #$00
	jsr HandlePlayerCollisionRight_EP
	;Handle collision top
	jsr HandlePlayerCollisionTop_EP
	;Get collision type bottom
	jsr GetCollisionTypeBottom
	;If nonsolid collision type, exit early
	beq HandlePlayerScrolling_EP_Exit
	;If death collision type, kill player
	cmp #$04
	beq HandlePlayerCollision_EP_Death
	;If solid tile at top, kill player
	lda $17
	bne HandlePlayerCollision_EP_Death
	;Adjust player Y position for collision
	jsr ClipPlayerYEnemy
	;Clear escape pod direction
	jmp HandlePlayerMovementY_EP_NoneCheck
HandlePlayerCollision_EP_Death:
	;Kill player
	lda #$80
	jmp CheckEnemyCollision_SetDamage

HandlePlayerCollisionTop_EP:
	;Get collision type top
	jsr GetCollisionTypeTop
	sta $17
	;If nonsolid collision type, exit early
	beq HandlePlayerScrolling_EP_Exit
	;If death collision type, kill player
	cmp #$04
	beq HandlePlayerCollision_EP_Death
	;Adjust player Y position for collision
	jsr ClipPlayerYEnemy
	clc
	adc #$07
	sta Enemy_Y
	;Clear escape pod direction
	jmp HandlePlayerMovementY_EP_NoneCheck

HandlePlayerCollisionRight_EP:
	;Get collision type right
	jsr GetCollisionTypeRight
	;If nonsolid collision type, exit early
	beq HandlePlayerScrolling_EP_Exit
	;If death collision type, kill player
	cmp #$04
	beq HandlePlayerCollision_EP_Death
	;Adjust player X position for collision
	jmp HandlePlayerCollisionRight_Enemy

HandlePlayerShooting_EP:
	;If player shoot cooldown timer 0, do jump table
	lda Enemy_Temp1
	beq HandlePlayerShooting_EP_NoDec
	;Decrement shoot cooldown timer
	dec Enemy_Temp1
	rts
HandlePlayerShooting_EP_NoDec:
	;Check for current character Jenny
	ldy CurCharacter
	cpy #$02
	bne HandlePlayerShooting_EP_NoJenny
	;Clear player fire
	jsr ClearPlayerFire_EP
HandlePlayerShooting_EP_NoJenny:
	;Check for B press
	lda JoypadCur
	and #JOY_B
	beq HandlePlayerShooting_EP_Bucky_Exit
	;Do jump table
	tya
	jsr DoJumpTable
PlayerShootEPJumpTable:
	.dw HandlePlayerShooting_EP_Bucky	;$00  Bucky
	.dw HandlePlayerShooting_EP_JennyWilly	;$01  Jenny
	.dw HandlePlayerShooting_EP_DeadEye	;$02  Dead-Eye
	.dw HandlePlayerShooting_EP_Blinky	;$03  Blinky
	.dw HandlePlayerShooting_EP_JennyWilly	;$04  Willy
;$00: Bucky
HandlePlayerShooting_EP_Bucky:
	;Find free slot for projectile
	lda Enemy_Flags+$0E
	ora Enemy_Flags+$0F
	bne HandlePlayerShooting_EP_JennyWilly_Exit
	;Set projectile position/animation
	ldx #$0E
	jsr PlayerShootSetPos_EP
	;Set projectile X velocity
	lda #$14
	sta Enemy_XVelHi+$0E
	;Set projectile position/animation
	inx
	jsr PlayerShootSetPos_EP
	;Set projectile X velocity
	lda #$EC
	sta Enemy_XVelHi+$0F
HandlePlayerShooting_EP_Bucky_Exit:
	rts
;$02: Dead-Eye
HandlePlayerShooting_EP_DeadEye:
	;Find free slot for projectile
	lda Enemy_Flags+$0D
	ora Enemy_Flags+$0E
	ora Enemy_Flags+$0F
	bne HandlePlayerShooting_EP_JennyWilly_Exit
	;Set projectile position/animation
	ldx #$0D
	jsr PlayerShootSetPos_EP
	inx
	jsr PlayerShootSetPos_EP
	inx
	jsr PlayerShootSetPos_EP
	;Set projectile Y velocity
	lda #$FA
	sta Enemy_YVelHi+$0D
	lda #$06
	sta Enemy_YVelHi+$0F
	;Set projectile X velocity
	sta Enemy_XVelHi+$0D
	sta Enemy_XVelHi+$0F
	lda #$0C
	sta Enemy_XVelHi+$0E
	;Set player shoot cooldown timer
	sta Enemy_Temp1
	rts
;$03: Blinky
HandlePlayerShooting_EP_Blinky:
	;Find free slot for projectile
	ldx #$0E
	lda Enemy_Flags+$0E
	beq HandlePlayerShooting_EP_Blinky_Spawn
	inx
	lda Enemy_Flags+$0F
	bne HandlePlayerShooting_EP_JennyWilly_Exit
HandlePlayerShooting_EP_Blinky_Spawn:
	;Set projectile position/animation
	jsr PlayerShootSetPos_EP
	;Set projectile Y acceleration
	lda #$7F
	sta Enemy_YAccel,x
	;Set projectile X velocity
	lda #$06
	bne HandlePlayerShooting_EP_JennyWilly_SetX
;$01: Jenny
;$04: Willy
HandlePlayerShooting_EP_JennyWilly:
	;Find free slot for projectile
	ldx #$0E
	lda Enemy_Flags+$0E
	beq HandlePlayerShooting_EP_JennyWilly_Spawn
	inx
	lda Enemy_Flags+$0F
	bne HandlePlayerShooting_EP_JennyWilly_Exit
HandlePlayerShooting_EP_JennyWilly_Spawn:
	;Set projectile position/animation
	jsr PlayerShootSetPos_EP
	;Set projectile X velocity
	lda #$10
HandlePlayerShooting_EP_JennyWilly_SetX:
	sta Enemy_XVelHi,x
HandlePlayerShooting_EP_JennyWilly_Exit:
	rts

ClearPlayerFire_EP:
	;Clear enemy flags
	lda #$00
	sta Enemy_Flags+$0D
	sta Enemy_Flags+$0E
	sta Enemy_Flags+$0F
	rts

PlayerShootSetPos_EP:
	;Set player shoot cooldown timer
	lda #$0A
	sta Enemy_Temp1
	;Set projectile position
	lda Enemy_X
	sta Enemy_X,x
	lda Enemy_Y
	clc
	adc #$06
	sta Enemy_Y,x
	;Set projectile animation
	ldy CurCharacter
	lda EPModePlayerShootAnimTable,y
	tay
	jsr SetEnemyAnimation
	;Clear enemy
	jsr ClearEnemy
	;Set enemy ID to player fire
	lda #ENEMY_PLAYERFIRE
	sta Enemy_ID,x
	;Set projectile power
	ldy CurCharacter
	lda EPModePlayerShootPowerTable,y
	sta Enemy_Temp4,x
	;Play sound
	ldy #SE_PLAYERSHOOT1
	jmp LoadSound
EPModePlayerShootAnimTable:
	.db $1A,$1E,$1A,$1A,$1E
EPModePlayerShootPowerTable:
	.db $01,$02,$01,$01,$02

HandleCharacterChange_EP:
	;Check for SELECT press
	lda JoypadDown
	and #JOY_SELECT
	beq HandleCharacterChange_EP_Exit
	;Clear player fire
	jsr ClearPlayerFire_EP
	;Find next unlocked character
	inc CurCharacter
	lda CurCharacter
	cmp #$05
	bne HandleCharacterChange_EP_Init
	lda #$00
	sta CurCharacter
HandleCharacterChange_EP_Init:
	;Clear player palette offset
	lda #$00
	sta PlayerPaletteOffset
	;Load palette
	lda CurPalette
	ora #$80
	sta CurPalette
	;Load CHR bank
	ldx CurCharacter
	lda EPModePlayerCHRBankTable,x
	sta TempCHRBanks+2
	;Clear escape pod direction
	bne HandlePlayerMovementY_EP_None
HandleCharacterChange_EP_Exit:
	rts

;ESCAPE POD MODE PLAYER SPRITE DATA
EPModePlayerCHRBankTable:
	.db $6D,$6E,$6D,$6B,$6E
EPModePlayerAnimIdleTable:
	.db $B1,$B7,$B3,$B5,$B9
EPModePlayerAnimUpTable:
	.db $CD,$D9,$D1,$D5,$DD
EPModePlayerAnimDownTable:
	.db $CF,$DB,$D3,$D7,$DF

HandlePlayerMovementY_EP:
	;Check for UP press
	lda JoypadCur
	and #JOY_UP
	bne HandlePlayerMovementY_EP_Up
	;Check for DOWN press
	lda JoypadCur
	and #JOY_DOWN
	bne HandlePlayerMovementY_EP_Down
	;Set max Y position $B8
	ldy #$B8
	;If player HP 0, set max Y position $E0
	lda Enemy_HP
	bne HandlePlayerMovementY_EP_NoDead
	;Set max Y position $E0
	ldy #$E0
HandlePlayerMovementY_EP_NoDead:
	sty $00
	;If player Y position + player Y velocity < max Y position, apply player Y velocity
	lda Enemy_Y
	clc
	adc EnemyGrabbingMode
	cmp $00
	bcs HandlePlayerMovementY_EP_NoneCheck
	;Apply player Y velocity
	sta Enemy_Y
HandlePlayerMovementY_EP_NoneCheck:
	;If escape pod not moving up or down, exit early
	lda EscapePodDirection
	beq HandleCharacterChange_EP_Exit
HandlePlayerMovementY_EP_None:
	;Clear escape pod direction
	lda #$00
	sta EscapePodDirection
	;Set player animation
	ldx CurCharacter
	ldy EPModePlayerAnimIdleTable,x
	ldx #$00
	jmp SetEnemyAnimation
HandlePlayerMovementY_EP_Up:
	;Get player Y velocity based on number of troopers grabbing
	lda #$03
	sec
	sbc EnemyGrabbingMode
	sta $00
	;If player Y position + player Y velocity < $10, clear escape pod direction
	lda Enemy_Y
	sec
	sbc $00
	cmp #$10
	bcc HandlePlayerMovementY_EP_NoneCheck
	;Apply player Y velocity
	sta Enemy_Y
	;If escape pod moving up, exit early
	lda EscapePodDirection
	cmp #$01
	beq HandlePlayerMovementX_EP_Exit
	;Set escape pod direction up
	lda #$01
	sta EscapePodDirection
	;Set player animation
	ldx CurCharacter
	ldy EPModePlayerAnimUpTable,x
	ldx #$00
	jmp SetEnemyAnimation
HandlePlayerMovementY_EP_Down:
	;Get player Y velocity based on number of troopers grabbing
	lda #$03
	clc
	adc EnemyGrabbingMode
	sta $00
	;If player Y position + player Y velocity >= $A8, clear escape pod direction
	lda Enemy_Y
	clc
	adc $00
	cmp #$A8
	bcs HandlePlayerMovementY_EP_NoneCheck
	;Apply player Y velocity
	sta Enemy_Y
	;If escape pod moving down, exit early
	lda EscapePodDirection
	cmp #$02
	beq HandlePlayerMovementX_EP_Exit
	;Set escape pod direction down
	lda #$02
	sta EscapePodDirection
	;Set player animation
	ldx CurCharacter
	ldy EPModePlayerAnimDownTable,x
	ldx #$00
	jmp SetEnemyAnimation

HandlePlayerMovementX_EP:
	;Set player X velocity based on number of troopers grabbing
	lda #$03
	sec
	sbc EnemyGrabbingMode
	sta Enemy_XVelHi
	;If player X position < $10, kill player
	lda Enemy_X
	cmp #$10
	bcs HandlePlayerMovementX_EP_NoCrush
	;Kill player
	jmp HandlePlayerCollision_EP_Death
HandlePlayerMovementX_EP_NoCrush:
	;Check for LEFT press
	lda JoypadCur
	and #JOY_LEFT
	bne HandlePlayerMovementX_EP_Left
	;Check for RIGHT press
	lda JoypadCur
	and #JOY_RIGHT
	beq HandlePlayerMovementX_EP_Exit
	;Apply player X velocity (right)
	lda Enemy_X
	clc
	adc Enemy_XVelHi
	;If player X position >= $F0, set player X position $F0
	cmp #$F0
	bcs HandlePlayerMovementX_EP_Exit
	;Set player X position $F0
	sta Enemy_X
HandlePlayerMovementX_EP_Exit:
	rts
HandlePlayerMovementX_EP_Left:
	;Save player X position
	lda Enemy_X
	sta Enemy_XLo
	;Apply player X velocity (left)
	sec
	sbc Enemy_XVelHi
	;If player X position < $10, set player X position $10
	cmp #$10
	bcc HandlePlayerMovementX_EP_Exit
	;Set player X position $10
	sta Enemy_X
	;Get collision type left
	ldx #$00
	jsr GetCollisionTypeLeft
	;If nonsolid collision type, exit early
	beq HandlePlayerMovementX_EP_Exit
	;If death collision type, kill player
	cmp #$04
	bne HandlePlayerMovementX_EP_NoDeath
	;Kill player
	jmp HandlePlayerCollision_EP_Death
HandlePlayerMovementX_EP_NoDeath:
	;Apply scroll X velocity
	lda Enemy_XLo
	sec
	sbc ScrollXVelHi
	sta Enemy_X
	rts

;UNUSED SPACE
	;$06 bytes of free space available
	;.db $FF,$FF,$FF,$FF,$FF,$FF

	.org $C000

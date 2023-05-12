	.base $8000
	.org $8000
;BANK NUMBER
	.db $32

;;;;;;;;;;;;;;;;;;
;VICTORY ROUTINES;
;;;;;;;;;;;;;;;;;;
RunGameMode_VictorySub:
	;Do jump table
	lda GameSubmode
	jsr DoJumpTable
VictorySubJumpTable:
	.dw RunGameSubmode_VictoryInit	;$00  Init
	.dw RunGameSubmode_VictoryUpdateHUD		;$01  Update HUD
	.dw RunGameSubmode_VictoryBossClear		;$02  Boss clear
	.dw RunGameSubmode_VictoryExplosion		;$03  Explosion
	.dw RunGameSubmode_VictoryJingle		;$04  Jingle
	.dw RunGameSubmode_VictoryScoreUp		;$05  Score up
	.dw RunGameSubmode_VictoryScoreUpEnd		;$06  Score up end
	.dw RunGameSubmode_VictoryLifeUp		;$07  Life up
	.dw RunGameSubmode_VictoryLifeUpEnd		;$08  Life up end
;$00: Init
RunGameSubmode_VictoryInit:
	;Next submode ($01: Update HUD)
	inc GameSubmode
	;Set unused value
	lda #$00
	sta Enemy_Temp6+$01
	;Set explosion animation timer
	sta Enemy_Temp4+$01
	;Set explosion spawn timer
	lda #$01
	sta Enemy_Temp3+$01
	;Set global timer
	sta LevelGlobalTimer
	;Set explosion index
	lda #$FF
	sta Enemy_Temp2+$01
	;Check for level 5
	lda CurLevel
	cmp #$04
	beq RunGameSubmode_VictoryInit_NoSound
	;Clear sound
	jsr ClearSound
	;Play sound
	ldy #SE_BOSSKILL
	jsr LoadSound
RunGameSubmode_VictoryInit_NoSound:
	;Check for level 7
	lda CurLevel
	cmp #$06
	bne RunGameSubmode_VictoryInit_NoLevel7
	;Write level 7 boss clear palette
	lda #$5B
	jsr WritePaletteStrip8
RunGameSubmode_VictoryInit_NoLevel7:
	;Init VRAM buffer row
	jsr WriteVRAMBufferCmd_InitRow
	;Load victory palette data
	ldy #$00
RunGameSubmode_VictoryInit_Loop:
	;Load victory palette data byte
	lda VictoryPaletteData,y
	sta VRAMBuffer,x
	;Loop for each byte
	inx
	iny
	cpy #$0A
	bne RunGameSubmode_VictoryInit_Loop
	;Clear player palette offset
	lda #$00
	sta PlayerPaletteOffset
	;Write player palette
	jsr WritePaletteCharacter
	;Load CHR bank
	ldx CurCharacter
	lda VictModePlayerCHRBankTable,x
	sta TempCHRBanks+2
	;Set player sprite
	lda VictModePlayerSpriteTable,x
	sta Enemy_SpriteLo
	;Set player collision height
	lda VictModePlayerCollHeightTable,x
	sta Enemy_CollHeight
	;Adjust player Y position for collision
	jsr HitEnemySetYPos_L
	;Set enemy flags
	lda #(EF_ACTIVE|EF_NOANIM|EF_PRIORITY|EF_VISIBLE)
	sta Enemy_Flags
	;Clear enemy tile offset
	lda #$00
	sta Enemy_Temp7
	;Clear player velocity/acceleration
	sta Enemy_XVelHi
	sta Enemy_XVelLo
	sta Enemy_XAccel
	sta Enemy_YVelHi
	sta Enemy_YVelLo
	sta Enemy_YAccel
	;Clear player current power
	sta CharacterPowerCur
	sta CharacterPowerCur+3
	sta CharacterPowerCur+4
	sta CharacterPowerCur+1
	sta CharacterPowerCur+2
	;Do jump table
	lda CurLevel
	jsr DoJumpTable
VictoryInitJumpTable:
	.dw VictoryInit_Sub0	;$00  Level 1
	.dw VictoryInit_Sub1	;$01  Level 2
	.dw VictoryInit_Sub2	;$02  Level 3
	.dw VictoryInit_Sub3	;$03  Level 4
	.dw VictoryInit_Sub4	;$04  Level 5
	.dw VictoryInit_Sub5	;$05  Level 6
	.dw VictoryInit_Sub6	;$06  Level 7
;$00: Level 1
VictoryInit_Sub0:
	;Enable character Blinky
	ldy #$03
VictoryInit_Sub0_Unlock:
	lda #$8C
	sta CharacterPowerMax,y
	rts
;$01: Level 2
VictoryInit_Sub1:
	;Clear scroll position
	lda #$A9
	sta TempMirror_PPUCTRL
	;Load IRQ buffer set
	ldx #$0C
	jsr LoadIRQBufferSet
	;Enable character Dead-Eye
	ldy #$02
	bne VictoryInit_Sub0_Unlock
;$02: Level 3
VictoryInit_Sub2:
	;Enable character Jenny
	ldy #$01
	bne VictoryInit_Sub0_Unlock
;$03: Level 4
VictoryInit_Sub3:
	;Clear scroll position
	lda #$00
	sta TempIRQBufferScrollX
	lda #$20
	sta TempIRQBufferScrollHi
	;Enable character Willy
	ldy #$04
	bne VictoryInit_Sub0_Unlock
;$04: Level 5
VictoryInit_Sub4:
	;Set explosion animation timer
	lda #$40
	sta Enemy_Temp4+$01
;$06: Level 7
VictoryInit_Sub6:
	rts
;$05: Level 6
VictoryInit_Sub5:
	;Load IRQ buffer set
	ldx #$26
	jmp LoadIRQBufferSet

;VICTORY MODE PLAYER SPRITE DATA
VictModePlayerSpriteTable:
	.db $24,$28,$24,$2C,$2A
VictModePlayerCHRBankTable:
	.db $50,$52,$51,$54,$53
VictModePlayerCollHeightTable:
	.db $0D,$0D,$0D,$0B,$0D

;$01: Update HUD
RunGameSubmode_VictoryUpdateHUD:
	;Next submode ($02: Boss clear)
	inc GameSubmode
	;Update HUD
	jmp UpdateHUD_L
;$02: Boss clear
RunGameSubmode_VictoryBossClear:
	;Next submode ($03: Explosion)
	inc GameSubmode
	;Check for level 7
	lda CurLevel
	cmp #$06
	bne VictoryInit_Sub6
	;Write level 7 boss clear VRAM strip
	lda #$51
	jmp WriteVRAMStrip
;$03: Explosion
RunGameSubmode_VictoryExplosion:
	;Land player for victory animation
	jsr VictoryLand
	;Decrement explosion animation timer, check if 0
	dec Enemy_Temp4+$01
	beq RunGameSubmode_VictoryExplosion_Next
	;Decrement explosion spawn timer, check if 0
	dec Enemy_Temp3+$01
	bne RunGameSubmode_VictoryExplosion_Exit
	;Check for level 5
	lda CurLevel
	cmp #$04
	beq RunGameSubmode_VictoryExplosion_Exit
	;Reset explosion spawn timer
	lda #$04
	sta Enemy_Temp3+$01
	;Increment explosion index
	inc Enemy_Temp2+$01
	ldy Enemy_Temp2+$01
	cpy #$15
	bne RunGameSubmode_VictoryExplosion_Spawn
	ldy #$00
	sty Enemy_Temp2+$01
RunGameSubmode_VictoryExplosion_Spawn:
	;Get explosion offset
	lda VictoryExplosionOffs,y
	and #$F0
	sta $00
	lda VictoryExplosionOffs,y
	and #$0F
	asl
	asl
	asl
	asl
	sta $01
	;Get explosion slot index
	tya
	and #$07
	clc
	adc #$02
	tay
	;Clear enemy flags
	lda #$00
	sta Enemy_Flags,y
	;If boss X position < $40, set boss X position $40
	ldx BossEnemyIndex
	lda Enemy_X,x
	cmp #$40
	bcc RunGameSubmode_VictoryExplosion_Left
	;If boss X position >= $C0, set boss X position $C0
	cmp #$C0
	bcc RunGameSubmode_VictoryExplosion_SetY
	;Set boss X position $C0
	lda #$C0
	bne RunGameSubmode_VictoryExplosion_SetX
RunGameSubmode_VictoryExplosion_Left:
	;Set boss X position $40
	lda #$40
RunGameSubmode_VictoryExplosion_SetX:
	sta Enemy_X,x
RunGameSubmode_VictoryExplosion_SetY:
	;Set boss Y position $70
	lda #$70
	sta Enemy_Y,x
	;Spawn enemy
	lda #$E4
	jmp SpawnEnemy
RunGameSubmode_VictoryExplosion_Exit:
	rts
RunGameSubmode_VictoryExplosion_Next:
	;Clear enemies
	jsr ClearEnemies_NoPl
	;Play music
	ldy #MUSIC_CLEAR
	jsr LoadSound
	;Set timer
	lda #$F0
	bne RunGameSubmode_VictoryJingle_SetT
VictoryLand:
	;If ground has already been detected, exit early
	lda VictoryGroundFlag
	bne RunGameSubmode_VictoryExplosion_Exit
	;Get collision type bottom
	ldx #$00
	jsr GetCollisionTypeBottom_L
	;If solid tile at bottom, set ground detected flag
	lda $08
	bne VictoryLand_Solid
	;Set player Y acceleration
	lda #$7F
	sta Enemy_YAccel
	;Clear platform X velocity
	lda #$00
	sta PlatformScrollXVel
	;Move player
	tax
	jmp MoveEnemy_L
VictoryLand_Solid:
	;Set ground detected flag
	inc VictoryGroundFlag
	;Adjust player Y position for collision
	jmp ClipPlayerYEnemy_L
VictoryPaletteData:
	.dw $3F10
	.db $0F,$06,$36,$26,$0F,$0F,$0F,$0F
VictoryExplosionOffs:
	.db $00,$ED,$2C,$C1,$F4,$33,$4E,$DF,$12,$0C,$CE,$3D,$D3,$2F,$31,$FE
	.db $14,$F2,$1D,$E0,$4F
;$04: Jingle
RunGameSubmode_VictoryJingle:
	;Decrement timer, check if 0
	dec Enemy_Temp2+$01
	bne RunGameSubmode_VictoryJingle_Exit
	;Reset timer
	lda #$C9
RunGameSubmode_VictoryJingle_SetT:
	sta Enemy_Temp2+$01
	;Next submode
	inc GameSubmode
RunGameSubmode_VictoryJingle_Exit:
	rts
;$05: Score up
RunGameSubmode_VictoryScoreUp:
	;Decrement timer, check if 0
	dec Enemy_Temp2+$01
	beq RunGameSubmode_VictoryScoreUp_End
	;If bits 0-1 of timer not 0, exit early
	lda Enemy_Temp2+$01
	and #$03
	bne RunGameSubmode_VictoryJingle_Exit
	;Clear sound
	jsr ClearSound
	;Play sound
	ldy #SE_SELECT
	jsr LoadSound
	;Give player 100 points
	ldx #$01
	jsr GivePoints_L
	;Update HUD
	jmp UpdateHUD_L
RunGameSubmode_VictoryScoreUp_End:
	;Reset timer
	lda #$20
	bne RunGameSubmode_VictoryJingle_SetT
;$06: Score up end
RunGameSubmode_VictoryScoreUpEnd:
	;Decrement timer, check if 0
	dec Enemy_Temp2+$01
	bne RunGameSubmode_VictoryLifeUpEnd_Exit
	;Next submode ($07: Life up)
	inc GameSubmode
	rts
;$07: Life up
RunGameSubmode_VictoryLifeUp:
	;Decrement timer
	dec Enemy_Temp2+$01
	;If bits 0-1 of timer not 0, exit early
	lda Enemy_Temp2+$01
	and #$03
	bne RunGameSubmode_VictoryJingle_Exit
	;If player HP = player max HP, setup next submode ($08: Life up end)
	lda Enemy_HP
	cmp Enemy_Temp4
	beq RunGameSubmode_VictoryLifeUp_End
	;Increment player HP
	inc Enemy_HP
	;Clear sound
	jsr ClearSound
	;Play sound
	ldy #SE_SELECT
	jsr LoadSound
	;Update HUD
	jmp UpdateHUD_L
RunGameSubmode_VictoryLifeUp_End:
	;Reset timer
	lda #$80
	bne RunGameSubmode_VictoryJingle_SetT
;$08: Life up end
RunGameSubmode_VictoryLifeUpEnd:
	;Decrement timer, check if 0
	dec Enemy_Temp2+$01
	bne RunGameSubmode_VictoryLifeUpEnd_Exit
	;Clear level state
	lda #$00
	sta BossEnemyIndex
	sta GameSubmode
	sta CurArea
	sta TempIRQEnableFlag
	sta ItemCollectedBits
	sta ItemCollectedBits+1
	sta EnemyTriggeredBits
	sta EnemyTriggeredBits+1
	sta IceMeltedBits
	;Clear enemy flags
	sta Enemy_Flags
	;Clear scroll position
	sta TempMirror_PPUSCROLL_X
	sta TempMirror_PPUSCROLL_Y
	lda #$A8
	sta TempMirror_PPUCTRL
	;Set level beaten flag
	ldy CurLevel
	lda ItemEnemyBitTable,y
	ora LevelsCompletedFlags
	sta LevelsCompletedFlags
	;Next mode ($02: Dialog)
	lda #$02
	sta GameMode
	;Set dialog
	ldy CurLevel
	lda VictoryDialogTable,y
	sta DialogID
RunGameSubmode_VictoryLifeUpEnd_Exit:
	rts
VictoryDialogTable:
	.db $01,$02,$03,$04,$06,$07,$08

;;;;;;;;;;;;;;;;
;ENEMY ROUTINES;
;;;;;;;;;;;;;;;;
;$00: Player fire
Enemy00:
	;If enemy Y position < $C0, clear enemy flags
	lda Enemy_Y,x
	cmp #$C0
	bcs Enemy00_ClearF
	;Check for level 5 elevator area
	lda LevelAreaNum
	cmp #$4C
	bne Enemy08_Exit00
	lda CurScreen
	cmp #$24
	bcc Enemy08_Exit00
	;Get collision type
	lda Enemy_X,x
	sta $00
	lda Enemy_Y,x
	sta $01
	jsr GetCollisionType
	;Check for death collision type (used by spikes)
	cmp #$04
	bne Enemy08_Exit00
	;Clear spikes
	jsr ClearSpikes_L
	;Wrap vertically
	lda Enemy_Y,x
	cmp #$E0
	bcc Enemy08_Exit00
	lda #$00
	sta Enemy_Y,x
	rts
Enemy00_ClearF:
	;Clear enemy flags
	lda #$00
	sta Enemy_Flags,x
	rts

;$08: Jenny light ball
Enemy08:
	;Check if light ball is active
	lda Enemy_Temp2
	and #$04
	bne Enemy08_Active
	;If still being held, set enemy position to player position
	lda Enemy_X
	sta Enemy_X+$0F
	lda Enemy_Y
	sec
	sbc #$19
	sta Enemy_Y+$0F
Enemy08_Exit00:
	rts
Enemy08_Active:
	;Save enemy position
	lda Enemy_X+$0F
	sta Enemy_Temp2+$0F
	lda Enemy_Y+$0F
	sta Enemy_Temp3+$0F
	;Process player fire
	jsr Enemy00
	;Restore enemy position
	lda Enemy_Temp2+$0F
	sta Enemy_X+$0F
	lda Enemy_Temp3+$0F
	sta Enemy_Y+$0F
	;Clear enemy acceleration
	lda #$00
	sta Enemy_XAccel+$0F
	sta Enemy_YAccel+$0F
	;Check for UP/DOWN/LEFT/RIGHT press
	lda JoypadUnmasked
	lsr
	bcs Enemy08_Right
	lsr
	bcs Enemy08_Left
	lsr
	bcs Enemy08_Down
	lsr
	bcc Enemy08_Exit
	;Handle UP press
	lda Enemy_YVelHi+$0F
	cmp #$FD
	beq Enemy08_Exit
	lda #$C0
	bne Enemy08_SetY
Enemy08_Down:
	;Handle DOWN press
	lda Enemy_YVelHi+$0F
	cmp #$02
	beq Enemy08_Exit
	lda #$40
Enemy08_SetY:
	;Set enemy Y acceleration
	sta Enemy_YAccel+$0F
	rts
Enemy08_Left:
	;Handle LEFT press
	lda Enemy_XVelHi+$0F
	cmp #$FD
	beq Enemy08_Exit
	lda #$C0
	bne Enemy08_SetX
Enemy08_Right:
	;Handle RIGHT press
	lda Enemy_XVelHi+$0F
	cmp #$02
	beq Enemy08_Exit
	lda #$40
Enemy08_SetX:
	;Set enemy X acceleration
	sta Enemy_XAccel+$0F
Enemy08_Exit:
	rts

;$18: Boulder rolling
Enemy18:
	;Check for init mode
	lda Enemy_Temp0,x
	beq Enemy18_Init
	;Check for main mode
	cmp #$01
	beq Enemy18_Main
	rts
Enemy18_Init:
	;Set enemy priority to be behind background
	lda #$20
	sta Enemy_Props,x
	;Next task ($01: Main)
	inc Enemy_Temp0,x
	;Set enemy X velocity based on parameter value
	lda Enemy_Temp1,x
	beq Enemy18_Left
	;Set enemy X velocity right
	jsr Enemy05_Right
Enemy18_Right:
	;Don't flip enemy X
	lda #$00
	beq Enemy18_SetP
Enemy18_Left:
	;Set enemy X velocity left
	jsr Enemy05_Left
Enemy18_LeftP:
	;Flip enemy X
	lda #$40
Enemy18_SetP:
	;Set enemy flip X
	sta Enemy_Props,x
Enemy18_Exit:
	rts
Enemy18_Main:
	;If enemy Y position < $8A, exit early
	lda Enemy_Y,x
	cmp #$8A
	bcc Enemy18_Exit
	;Next task ($02: Finish)
	inc Enemy_Temp0,x
	;Set enemy priority to be behind background
	lda Enemy_Props,x
	ora #$20
	bne Enemy18_SetP

;$05: Trooper
Enemy05:
	;Check if already inited
	lda Enemy_Temp0,x
	bne Enemy06
Enemy05_Ent07:
	;Mark inited
	inc Enemy_Temp0,x
	;Check if on left or right side of screen
	lda Enemy_X,x
	bmi Enemy05_Left
Enemy05_Right:
	;Set enemy X velocity right
	lda #$01
	sta Enemy_XVelHi,x
	bne Enemy18_Right
Enemy05_Left:
	;Set enemy X velocity left
	lda #$FF
	sta Enemy_XVelHi,x
	bne Enemy18_LeftP

;$07: Trooper 2
Enemy07:
	;Check if already inited
	lda Enemy_Temp0,x
	bne Enemy07_Main
	;Set enemy max HP based on parameter value
	lda Enemy_Temp1,x
	beq Enemy07_Weak
	lda #$06
	sta Enemy_HP,x
Enemy07_Weak:
	;Init shooting timer
	lda #$20
	sta Enemy_Temp2,x
	;Mark inited and set enemy X velocity based on if on left or right side of screen
	bne Enemy05_Ent07
Enemy07_Main:
	;Decrement shooting timer, check if 0
	dec Enemy_Temp2,x
	bne Enemy06
	;Reset shooting timer
	lda #$40
	sta Enemy_Temp2,x
	;Get enemy direction
	lda Enemy_Props,x
	and #$40
	beq Enemy07_Right
	;Check if on left side of screen
	lda Enemy_X,x
	bpl Enemy06
	;Spawn enemy left
	lda #$F9
	sta $00
	lda #$00
	sta $01
	lda #$24
	jsr FindFreeEnemySlot
	;If no free slot available, exit early
	bcc Enemy06
	;Set enemy X velocity
	lda #$FD
	sta Enemy_XVelHi,y
	rts
Enemy07_Right:
	;Check if on right side of screen
	lda Enemy_X,x
	bmi Enemy06
	;Spawn enemy right
	lda #$07
	sta $00
	lda #$00
	sta $01
	lda #$24
	jsr FindFreeEnemySlot
	;If no free slot available, exit early
	bcc Enemy06
	;Set enemy X velocity
	lda #$03
	sta Enemy_XVelHi,y

;$06: Enemy fire
Enemy06:
	;Do nothing
	rts

;$09: BG 8-way shooter
Enemy09:
	;Check if already inited
	lda Enemy_Temp0,x
	bne Enemy09_Main
Enemy09_Ent44:
	txa
	pha
	;Check if enemy is already dead
	jsr GetItemEnemyBit
	lda EnemyTriggeredBits
	and $00
	beq Enemy09_NoDead
	;If not already dead, don't clear
	tya
	beq Enemy09_NoClear
	;Clear shooter metatile
	lda $01
	and #$07
	sta $01
	jsr ClearShooter_L
Enemy09_NoClear:
	;Clear enemy flags
	pla
	tax
	lda #$00
	sta Enemy_Flags,x
	rts
Enemy09_NoDead:
	;If not already dead, don't clear
	tya
	bne Enemy09_NoClear
	;Init shooting timer and frame counter
	pla
	tax
	lda #$40
	sta Enemy_Temp2,x
	lda #$00
	sta Enemy_Temp3,x
	;Set enemy collision size
	lda #$0D
	sta Enemy_CollWidth,x
	lda #$0D
	sta Enemy_CollHeight,x
	;Set enemy flags
	lda #(EF_ACTIVE|EF_HITBULLET|EF_HITENEMY|EF_VISIBLE)
	sta Enemy_Flags,x
	;Mark inited
	inc Enemy_Temp0,x
Enemy09_Exit:
	rts
Enemy09_Main:
	;Decrement shooting timer, check if 0
	dec Enemy_Temp2,x
	bne Enemy09_Exit
	;Reset shooting timer and increment frame counter
	lda #$40
	sta Enemy_Temp2,x
	inc Enemy_Temp3,x
	;Check if at end of animation
	lda Enemy_Temp3,x
	cmp #$03
	bne Enemy09_NoResetC
	lda #$00
	sta Enemy_Temp3,x
Enemy09_NoResetC:
	;Determine player relative position Y
	tay
	lda Enemy_Y,x
	cmp Enemy_Y
	;If enemy Y position < player Y position, increment quadrant 2x
	bcs Enemy09_IncQ2
	iny
	iny
	iny
	iny
	;Determine player relative position X
	lda Enemy_X,x
	cmp Enemy_X
	;If enemy X position >= player X position, increment quadrant 1x (Q3 to Q4)
	bcc Enemy09_IncQ1
	iny
	iny
	bne Enemy09_IncQ1
Enemy09_IncQ2:
	;Determine player relative position X
	lda Enemy_X,x
	cmp Enemy_X
	;If enemy X position < player X position, increment quadrant 1x (Q1 to Q2)
	bcs Enemy09_IncQ1
	iny
	iny
Enemy09_IncQ1:
	;Spawn enemy
	lda Shooter8WayXVel,y
	sta $02
	asl
	sta $00
	lda Shooter8WayYVel,y
	sta $03
	asl
	sta $01
	lda #$24
	jsr FindFreeEnemySlot
	;If no free slots available, exit early
	bcc Enemy09_Exit
	;Set enemy velocity
	lda $02
	sta Enemy_XVelHi,y
	lda $03
	sta Enemy_YVelHi,y
	;Play sound
	ldy #SE_SHOOTLASER
	jmp LoadSound
Shooter8WayXVel:
	.db $FD,$FE,$00,$02,$03,$02,$00,$FE,$FD
Shooter8WayYVel:
	.db $00,$FE,$FD,$FE,$00,$02,$03,$02,$00

;$0A: Caterpillar
Enemy0A:
	;Do jump table
	lda Enemy_Temp0,x
	jsr DoJumpTable
Enemy0AJumpTable:
	.dw Enemy0A_Sub0	;$00  Init
	.dw Enemy0A_Sub1	;$01  Out
	.dw Enemy0A_Sub2	;$02  Down
	.dw Enemy0A_Sub3	;$03  Up
	.dw Enemy0A_Sub4	;$04  In
	.dw Enemy0A_Sub5	;$05  Wait
;Sub 0: Init
Enemy0A_Sub0:
	;Check if on left or right side of screen
	lda Enemy_X,x
	bpl Enemy0A_Sub0_Left
	;Don't flip enemy X
	lda #$00
	sta Enemy_Props,x
	;Set enemy X velocity right
	sta Enemy_XVelHi,x
	lda #$40
	bne Enemy0A_Sub0_SetX
Enemy0A_Sub0_Left:
	;Flip enemy X
	lda #$40
	sta Enemy_Props,x
	;Set enemy X velocity left
	lda #$FF
	sta Enemy_XVelHi,x
	lda #$C0
Enemy0A_Sub0_SetX:
	sta Enemy_XVelLo,x
	;Next task ($01: Out)
	inc Enemy_Temp0,x
	rts
;Sub 1: Out
Enemy0A_Sub1:
	;Check if at end of animation
	lda Enemy_X,x
	cmp #$5D
	beq Enemy0A_Sub1_Next
	cmp #$B2
	bne Enemy0A_Sub1_Exit
Enemy0A_Sub1_Next:
	;Set enemy animation
	ldy #$AA
	jsr SetEnemyAnimation
	;Flip enemy X and set enemy priority to be in front of background
	lda Enemy_Props,x
	eor #$60
	sta Enemy_Props,x
	;Set enemy velocity
	lda #$00
	sta Enemy_XVelHi,x
	sta Enemy_XVelLo,x
	lda #$40
	sta Enemy_YVelLo,x
	;Reset animation timer
	lda #$E0
	sta Enemy_Temp2,x
	;Next task ($02: Down)
	inc Enemy_Temp0,x
Enemy0A_Sub1_Exit:
	rts
;Sub 2: Down
Enemy0A_Sub2:
	;Decrement animation timer, check if 0
	dec Enemy_Temp2,x
	bne Enemy0A_Sub1_Exit
	;Set enemy animation
	ldy #$94
	jsr SetEnemyAnimation
	;Set enemy velocity
	lda #$C0
	sta Enemy_YVelLo,x
	lda #$FF
	sta Enemy_YVelHi,x
	;Reset animation timer
	lda #$E0
	sta Enemy_Temp2,x
	;Next task ($03: Up)
	inc Enemy_Temp0,x
	rts
;Sub 3: Up
Enemy0A_Sub3:
	;Decrement animation timer, check if 0
	dec Enemy_Temp2,x
	bne Enemy0A_Sub1_Exit
	;Set enemy animation
	ldy #$76
	jsr SetEnemyAnimation
	;Clear enemy Y velocity
	lda #$00
	sta Enemy_YVelLo,x
	sta Enemy_YVelHi,x
	;Set enemy priority to be behind background
	lda Enemy_Props,x
	eor #$20
	sta Enemy_Props,x
	;Check if on left or right side of screen
	lda Enemy_X,x
	bmi Enemy0A_Sub3_Left
	;Set enemy X velocity right
	lda #$00
	sta Enemy_XVelHi,x
	lda #$40
	bne Enemy0A_Sub3_SetX
Enemy0A_Sub3_Left:
	;Set enemy X velocity left
	lda #$FF
	sta Enemy_XVelHi,x
	lda #$C0
Enemy0A_Sub3_SetX:
	sta Enemy_XVelLo,x
	;Next task ($04: In)
	inc Enemy_Temp0,x
	rts
;Sub 4: In
Enemy0A_Sub4:
	;Check if at end of animation
	lda Enemy_X,x
	cmp #$64
	beq Enemy0A_Sub4_Next
	cmp #$A3
	bne Enemy0A_Sub1_Exit
Enemy0A_Sub4_Next:
	;Set enemy animation
	ldy #$A8
	jsr SetEnemyAnimation
	;Clear enemy X velocity
	lda #$00
	sta Enemy_XVelHi,x
	sta Enemy_XVelLo,x
	;Reset animation timer
	lda #$A0
	sta Enemy_Temp2,x
	;Next task ($05: Wait)
	inc Enemy_Temp0,x
	rts
;Sub 5: Wait
Enemy0A_Sub5:
	;Decrement animation timer, check if 0
	dec Enemy_Temp2,x
	bne Enemy0A_Sub1_Exit
	;Set enemy animation
	ldy #$76
	jsr SetEnemyAnimation
	;Next task ($00: Init)
	lda #$00
	sta Enemy_Temp0,x
	jmp Enemy0A_Sub0

;$0B: Spider
Enemy0B:
	;Check if already inited
	lda Enemy_Temp0,x
	bne Enemy0B_Main
	;Check enemy if Y position < $80
	lda Enemy_Y,x
	bmi Enemy0B_ClearF
	;Set enemy position
	lda #$08
	sta Enemy_Y,x
	;Set enemy flags
	lda #(EF_ACTIVE|EF_HITBULLET|EF_HITENEMY|EF_VISIBLE)
	sta Enemy_Flags,x
	;Set enemy Y velocity
	lda #$01
	sta Enemy_YVelHi,x
	;Mark inited
	inc Enemy_Temp0,x
	rts
Enemy0B_ClearF:
	;Clear enemy flags
	lda #$00
	sta Enemy_Flags,x
	rts
Enemy0B_Main:
	;Check if at end of animation
	lda Enemy_Y,x
	cmp #$52
	bcc Enemy0B_Exit
	;Set enemy animation
	ldy #$E4
	jsr SetEnemyAnimation
	;Set enemy lifetime
	lda #$90
	sta Enemy_Temp5,x
	;Set enemy Y velocity
	lda #$00
	sta Enemy_YVelHi,x
	;Play sound
	ldy #SE_CRASH
	jsr LoadSound
	;Spawn projectiles
	ldy #$05
Enemy0B_Loop:
	;If free slot not available, go to next enemy
	lda Enemy_Flags,y
	bne Enemy0B_Next
	;Spawn enemy
	lda #$00
	sta $00
	sta $01
	lda #$24
	jsr SpawnEnemy
	;Set enemy velocity
	lda Shooter8WayYVel-$05,y
	sta Enemy_YVelHi,y
	lda Shooter8WayXVel-$05,y
	sta Enemy_XVelHi,y
Enemy0B_Next:
	;Loop for each projectile
	iny
	cpy #$0D
	bne Enemy0B_Loop
Enemy0B_Exit:
	rts

;$0C: Beehive
Enemy0C:
	;Do jump table
	lda Enemy_Temp0,x
	jsr DoJumpTable
Enemy0CJumpTable:
	.dw Enemy0C_Sub0	;$00  Init
	.dw Enemy0C_Sub1	;$01  Main
	.dw Enemy0C_Sub2	;$02  Finish
;Sub 0: Init
Enemy0C_Sub0:
	;Flip enemy X
	lda Enemy_Props,x
	eor #$40
	sta Enemy_Props,x
	;Next task ($01: Main)
	inc Enemy_Temp0,x
	rts
;Sub 1: Main
Enemy0C_Sub1:
	;If enemy Y position $40-$5F, spawn bees
	lda Enemy_Y,x
	cmp #$40
	bcc Enemy0C_Sub2
	cmp #$60
	bcs Enemy0C_Sub2
	;Next task ($02: Finish)
	inc Enemy_Temp0,x
	;Spawn bees
	lda #$02
	sta $11
Enemy0C_Sub1_Loop:
	ldy $11
	;Spawn enemy
	lda BeeSpawnDX,y
	sta $00
	lda BeeSpawnDY,y
	sta $01
	lda #$74
	jsr FindFreeEnemySlot
	;If no free slots available, exit early
	bcc Enemy0C_Sub1_End
	;Set enemy ID to bee
	lda #ENEMY_BEE
	sta Enemy_ID,y
	;Loop for each bee
	dec $11
	bpl Enemy0C_Sub1_Loop
Enemy0C_Sub1_End:
	;Play sound
	ldy #SE_BUZZ
	jmp LoadSound
BeeSpawnDX:
	.db $E8,$F4,$F8
BeeSpawnDY:
	.db $04,$10,$1C

;$0D: Bee
Enemy0D:
	;If animation timer 0, process enemy
	lda Enemy_Temp2,x
	beq Enemy0D_Main
	;Decrement animation timer
	dec Enemy_Temp2,x
;Sub 2: Finish
Enemy0C_Sub2:
	rts
Enemy0D_Main:
	;Reset animation timer
	lda #$10
	sta Enemy_Temp2,x
	;Determine player relative X position
	lda Enemy_X,x
	cmp Enemy_X
	bcs Enemy0D_Left
	;Set enemy X velocity right
	lda #$00
	sta Enemy_XVelHi,x
	;Don't flip enemy X
	sta Enemy_Props,x
	beq Enemy0D_SetX
Enemy0D_Left:
	;Set enemy X velocity left
	lda #$FF
	sta Enemy_XVelHi,x
	;Flip enemy X
	lda #$40
	sta Enemy_Props,x
Enemy0D_SetX:
	;Add random offset to enemy X velocity based on slot index
	txa
	and #$07
	asl
	asl
	asl
	asl
	clc
	adc #$60
	sta Enemy_XVelLo,x
	;Determine player relative Y position
	lda Enemy_Y,x
	cmp Enemy_Y
	bcs Enemy0D_Up
	;Set enemy Y velocity down
	lda #$00
	sta Enemy_YVelHi,x
	lda #$A0
	bne Enemy0D_SetY
Enemy0D_Up:
	;Set enemy Y velocity up
	lda #$FF
	sta Enemy_YVelHi,x
	lda #$60
Enemy0D_SetY:
	sta Enemy_YVelLo,x
	rts

;$0E: Ship fin
Enemy0E:
	;Set enemy X position based on IRQ scroll buffer
	jsr ShipPartSetXPos
	;If enemy X position $D0-$DF or $90-$9F, shoot laser
	lda Enemy_X,x
	cmp #$D0
	bcc Enemy0E_Check2
	cmp #$E0
	bcc Enemy0E_Shoot
Enemy0E_Check2:
	cmp #$90
	bcc Enemy0E_Exit
	cmp #$A0
	bcs Enemy0E_Exit
Enemy0E_Shoot:
	;Get slot index for laser
	txa
	clc
	adc #$07
	tay
	;If free slot not available, exit early
	lda Enemy_Flags,y
	bne Enemy0E_Exit
	;Spawn enemy
	lda #$F2
	clc
	adc ScrollXVelHi
	sta $00
	lda #$2C
	sta $01
	lda #$7E
	jsr SpawnEnemy
	;Set laser X velocity based on top or bottom row
	lda Enemy_Temp1,x
	and #$01
	bne Enemy0E_Bottom
	;Set laser X velocity (top row)
	lda #$FF
	bne Enemy0E_NoBottom
Enemy0E_Bottom:
	;Set laser X velocity (bottom row)
	lda #$FE
Enemy0E_NoBottom:
	sta Enemy_XVelHi,y
	;Init animation timer
	lda #$18
	sta Enemy_Temp2,y
	;Set enemy ID to ship down laser
	lda #ENEMY_SHIPDOWNLASER
	sta Enemy_ID,y
Enemy0E_Exit:
	rts
ShipPartSetXPos:
	;Check for top or bottom row
	lda Enemy_Temp1,x
	and #$01
	beq ShipPartSetXPos_Top
	;Set enemy X position (bottom row)
	lda #$A5
	sec
	sbc TempIRQBufferScrollX+2
	sta Enemy_X,x
	rts
ShipPartSetXPos_Top:
	;Set enemy X position (top row)
	lda #$E5
	sec
	sbc TempIRQBufferScrollX+1
	sta Enemy_X,x
	rts

;$24: Ship down laser
Enemy24:
	;Decrement animation timer, check if 0
	dec Enemy_Temp2,x
	bne Enemy0E_Exit
	;Set enemy velocity
	lda #$00
	sta Enemy_XVelHi,x
	lda #$04
	sta Enemy_YVelHi,x
	;Set enemy flags
	lda #(EF_ACTIVE|EF_HITENEMY|EF_VISIBLE)
	sta Enemy_Flags,x
	;Play sound
	ldy #SE_SHOOTLASER
	jmp LoadSound

;$25: Ship mouth
Enemy25:
	;Set enemy X position based on IRQ scroll buffer
	jsr ShipPartSetXPos
	lda Enemy_X,x
	sec
	sbc #$38
	sta Enemy_X,x
	;Check if already inited
	lda Enemy_Temp0,x
	bne Enemy25_Main
	;Clear ship mouth metatile (closed mouth)
	jsr ShipMouthClearMetatile
	;If enemy X position $F0-$FF or $B0-$BF, shoot projectile
	lda Enemy_X,x
	cmp #$F0
	bcs Enemy25_NoCheck2
	cmp #$B0
	bcc Enemy25_Exit
	cmp #$C0
	bcs Enemy25_Exit
Enemy25_NoCheck2:
	;If free slots not available, exit early
	lda Enemy_Flags+$0A
	bne Enemy25_Exit
	lda Enemy_Flags+$0B
	bne Enemy25_Exit
	;Spawn enemy
	lda #$FC
	sta $00
	lda #$04
	sta $01
	ldy #$0A
	lda #$24
	jsr SpawnEnemy
	;Set enemy active flag
	lda #EF_ACTIVE
	sta Enemy_Flags+$0A
	;Spawn enemy
	lda #$FC
	sta $00
	lda #$04
	sta $01
	iny
	lda #$24
	jsr SpawnEnemy
	;Set enemy active flag
	lda #EF_ACTIVE
	sta Enemy_Flags+$0B
	;Set enemy X velocity based on top or bottom row
	lda Enemy_Temp1,x
	and #$01
	bne Enemy25_Bottom
	;Set enemy X velocity (top row)
	lda #$FF
	bne Enemy25_SetX
Enemy25_Bottom:
	;Set enemy X velocity (bottom row)
	lda #$FE
Enemy25_SetX:
	sta Enemy_XVelHi+$0A
	sta Enemy_XVelHi+$0B
	;Next task ($01: Main)
	inc Enemy_Temp0,x
	;Init animation timer
	lda #$80
	sta Enemy_Temp4,x
Enemy25_Exit:
	rts
Enemy25_Main:
	;Decrement animation timer, check if 0
	lda Enemy_Temp4,x
	sec
	sbc #$08
	sta Enemy_Temp4,x
	and #$F8
	bne Enemy25_Exit
	;Reset animation timer
	lda Enemy_Temp4,x
	sta $00
	ora #$80
	sta Enemy_Temp4,x
	;Increment animation frame counter
	inc Enemy_Temp4,x
	;Draw ship mouth metatile
	jsr ShipMouthClearMetatile
	jsr ShipMouthDrawMetatile
	;Check for mouth open frame
	lda $00
	cmp #$01
	beq Enemy25_Shoot
	;Check for mouth closed frame
	cmp #$03
	bne Enemy25_Exit
	;Next task ($00: Init)
	dec Enemy_Temp0,x
	rts
Enemy25_Shoot:
	;Set enemy flags
	lda #(EF_ACTIVE|EF_HITENEMY|EF_VISIBLE)
	sta Enemy_Flags+$0A
	;Set enemy X velocity
	lda #$FC
	sta Enemy_XVelHi+$0A
	;Set enemy flags
	lda #(EF_ACTIVE|EF_HITENEMY|EF_VISIBLE)
	sta Enemy_Flags+$0B
	;Set enemy velocity
	lda #$02
	sta Enemy_YVelHi+$0B
	lda #$FE
	sta Enemy_XVelHi+$0B
	rts
ShipMouthDrawMetatile:
	;Save X register
	stx $08
	;Draw ship mouth metatile
	ldx UpdateMetatileCount
	ldy $00
	lda ShipMouthMetatileID,y
	sta UpdateMetatileID,x
	ldy $02
	lda ShipMouthMetatilePos,y
	sta UpdateMetatilePos,x
	lda $03
	sta UpdateMetatileProps,x
	inc UpdateMetatileCount
	;Restore X register
	ldx $08
ShipMouthDrawMetatile_Exit:
	rts
ShipMouthMetatileID:
	.db $62,$63,$62,$5F
ShipMouthMetatilePos:
	.db $0D,$13
ShipMouthMetatileXPos:
	.db $AD,$6D
ShipMouthClearMetatile:
	;Check for top or bottom row
	lda Enemy_Temp1,x
	and #$01
	sta $02
	tay
	iny
	;Get metatile X position
	lda ShipMouthMetatileXPos-1,y
	sta $03
	;Get current scroll X position and nametable based on IRQ scroll buffer
	lda TempIRQBufferScrollX,y
	sta $04
	lda TempIRQBufferScrollHi,y
	and #$04
	lsr
	lsr
	;If current scroll X position >= metatile X position, use other nametable
	ldy $04
	cpy $03
	bcc ShipMouthClearMetatile_NoXC
	eor #$01
ShipMouthClearMetatile_NoXC:
	sta $03
	;If metatile was already drawn, exit early
	cmp Enemy_Temp2,x
	beq ShipMouthDrawMetatile_Exit
	sta Enemy_Temp2,x
	;Set metatile position based on top or bottom row
	ldy $02
	lda ShipMouthMetatilePos,y
	sta $09
	;Draw metatile
	ldy UpdateMetatileCount
	lda #$5F
	sta UpdateMetatileID,y
	lda $09
	sta UpdateMetatilePos,y
	lda $03
	sta UpdateMetatileProps,y
	inc UpdateMetatileCount
	rts

;$10: Item lifeup
;$11: Item powerup
;$12: Item 1-UP
;$13: Item bonus coin
Enemy10:
	;Check if already inited
	lda Enemy_Temp0,x
	bne Enemy10_Exit
	;Check if item is already collected
	jsr GetItemEnemyBit
	lda ItemCollectedBits,y
	and $00
	bne Enemy10_Dead
	;Set enemy flags
	lda #(EF_ACTIVE|EF_HITENEMY|EF_VISIBLE)
	bne Enemy10_SetF
Enemy10_Dead:
	;Clear enemy flags
	lda #$00
Enemy10_SetF:
	sta Enemy_Flags,x
	;Mark inited
	inc Enemy_Temp0,x
Enemy10_Exit:
	rts

;$15: Swinging vine
Enemy15:
	;Do jump table
	lda Enemy_Temp0,x
	jsr DoJumpTable
Enemy15JumpTable:
	.dw Enemy15_Sub0	;$00  Init
	.dw Enemy15_Sub1	;$01  Main
;Sub 0: Init
Enemy15_Sub0:
	;Next task ($01: Main)
	inc Enemy_Temp0,x
	;Init enemy velocity/props
	lda #$FF
	sta Enemy_XVelHi+$01,x
	lda #$40
	sta Enemy_Props,x
	bne Enemy15_Sub1_EntS0
;Sub 1: Main
Enemy15_Sub1:
	;Check for swinging vine platform
	lda Enemy_ID+$01,x
	cmp #ENEMY_SWINGINGVINEPLAT
	bne Enemy15_Sub1_NoPlat
	;Set enemy active flags for swinging vine platform
	lda Enemy_Flags+$01,x
	ora #EF_ACTIVE
	sta Enemy_Flags+$01,x
Enemy15_Sub1_NoPlat:
	;Decrement animation timer
	dec Enemy_Temp1,x
	bne Enemy15_Sub1_Exit
Enemy15_Sub1_EntS0:
	;Increment animation frame counter
	ldy Enemy_Temp2,x
	inc Enemy_Temp2,x
	;Set platform Y position and enemy sprite
	lda SwingingVineYPos,y
	sta Enemy_Y+$01,x
	lda SwingingVineSprite,y
	sta Enemy_SpriteLo,x
	;Check if at end of animation
	cpy #$15
	bne Enemy15_Sub1_NoResetC
	;Flip enemy
	lda Enemy_Props,x
	eor #$40
	sta Enemy_Props,x
	;Reset animation frame counter
	lda #$00
	sta Enemy_Temp2,x
	beq Enemy15_Sub1_ResetT
Enemy15_Sub1_NoResetC:
	;Check which vine this is
	txa
	and #$02
	beq Enemy15_Sub1_Vine1
	;Check for animation frame $09
	cpy #$09
	bne Enemy15_Sub1_ResetT
	;Set animation frame $0D
	lda #$0D
	sta Enemy_Temp2,x
	bne Enemy15_Sub1_SetX
Enemy15_Sub1_Vine1:
	;Check for animation frame $0B
	cpy #$0B
	bne Enemy15_Sub1_ResetT
Enemy15_Sub1_SetX:
	;Flip enemy X velocity
	lda Enemy_XVelHi+$01,x
	eor #$FF
	clc
	adc #$01
	sta Enemy_XVelHi+$01,x
Enemy15_Sub1_ResetT:
	;Reset animation timer
	lda #$02
	sta Enemy_Temp1,x
	lda #$FE
	sta Enemy_AnimTimer,x
Enemy15_Sub1_Exit:
	rts
SwingingVineSprite:
	.db $E0,$AA,$AC,$96,$98,$9A,$9C,$9E,$A0,$FC,$FE
	.db $FC,$A0,$9E,$9C,$9A,$98,$96,$AC,$AA,$E0,$A6
SwingingVineYPos:
	.db $84,$84,$84,$84,$83,$83,$83,$82,$82,$81,$81
	.db $81,$82,$82,$83,$83,$83,$84,$84,$84,$84,$84

;$1B: Swinging vine platform
Enemy1B:
	;Check if on left or right side of screen
	lda Enemy_X-$01,x
	bpl Enemy1B_Left
	;Check if visible on screen (right)
	lda Enemy_X,x
	cmp #$20
	bcc Enemy1B_Hide
	cmp #$FC
	bcs Enemy1B_Hide
	bcc Enemy1B_Show
Enemy1B_Left:
	;Check if visible on screen (left)
	lda Enemy_X,x
	cmp #$E0
	bcs Enemy1B_Hide
	cmp #$04
	bcc Enemy1B_Hide
Enemy1B_Show:
	;Set enemy visible flag
	lda Enemy_Flags,x
	ora #EF_VISIBLE
	bne Enemy1B_SetF
Enemy1B_Hide:
	;Clear enemy visible flag
	lda Enemy_Flags,x
	and #~EF_VISIBLE
Enemy1B_SetF:
	sta Enemy_Flags,x
	rts

;$19: Floating log spawner
Enemy19:
	;Increment timer for spawning floating logs
	inc Enemy_Temp2,x
	lda Enemy_Temp2,x
	and #$3F
	bne Enemy19_Exit
	;Check which floating log this is
	cpx #$03
	beq Enemy19_Log1
	;If free slot not available, exit early
	lda Enemy_Flags+$06
	bne Enemy19_Exit
Enemy19_Log1:
	;If free slot not available, exit early
	lda Enemy_Flags+$04
	bne Enemy19_Exit
	;Get slot index for platform
	txa
	tay
	iny
	;Spawn enemy
	lda #$00
	sta $00
	sta $01
	lda #$86
	jsr SpawnEnemy
	;Set enemy ID to floating log platform
	ldy Enemy_Temp1,x
	inx
	lda #ENEMY_FLOATINGLOGPLAT
	sta Enemy_ID,x
	;Set enemy X velocity
	lda FloatingLogSpawnXVel,y
	sta Enemy_XVelHi,x
	;Set enemy position
	lda FloatingLogSpawnXPos,y
	sta Enemy_X,x
	lda FloatingLogSpawnYPos,y
	sta Enemy_Y,x
	;Set enemy parameter value
	lda FloatingLogSpawnParam,y
	sta Enemy_Temp1,x
	;Run floating log platform enemy subroutine
	jsr Enemy17_Sub0_Ent19
	dex
Enemy19_Exit:
	rts
FloatingLogSpawnXVel:
	.db $FF,$01
FloatingLogSpawnXPos:
	.db $F7,$09
FloatingLogSpawnYPos:
	.db $70,$30
FloatingLogSpawnParam:
	.db $01,$00

;$17: Floating log platform
Enemy17:
	;Set enemy Y acceleration
	jsr FloatingLogSetYAccel
	;Do jump table
	lda Enemy_Temp0,x
	jsr DoJumpTable
Enemy17JumpTable
	.dw Enemy17_Sub0	;$00  Init
	.dw Enemy17_Sub1	;$01  Fall
	.dw Enemy17_Sub2	;$02  Wait
	.dw Enemy17_Sub3	;$03  Move
;$00: Init
Enemy17_Sub0:
	;Set continuous flag
	lda #$01
	sta Enemy_Temp4,x
Enemy17_Sub0_Ent19:
	;Set enemy priority to be behind background
	lda Enemy_Props,x
	ora #$20
	sta Enemy_Props,x
	;Next task ($01: Fall)
	inc Enemy_Temp0,x
	;Set enemy Y acceleration
	lda #$7F
	sta Enemy_YAccel,x
Enemy17_Sub0_Exit:
	rts
;$01: Fall
Enemy17_Sub1:
	;If current Y position < row Y position, exit early (wait to fall down)
	ldy Enemy_Temp1,x
	lda FloatingLogPlatYPos,y
	cmp Enemy_Y,x
	bcs Enemy17_Sub0_Exit
	;Set enemy Y position based on parameter value
	sta Enemy_Y,x
	;Increment parameter value (next row)
	inc Enemy_Temp1,x
	;Clear enemy Y velocity/acceleration
	lda #$00
	sta Enemy_YVelHi,x
	sta Enemy_YVelLo,x
	sta Enemy_YAccel,x
	;Init timer for bobbing up/down
	lda #$0C
	sta Enemy_Temp3,x
	;Next task ($02: Wait)
	inc Enemy_Temp0,x
	;Check to skip collision check
	lda Enemy_Temp4,x
	beq Enemy17_Sub2_EntS1
	;Clear continuous flag
	lda #$00
	sta Enemy_Temp4,x
	rts
;$02: Wait
Enemy17_Sub2:
	;Check for collision
	jsr PlatformCheckCollision
	bne Enemy17_Sub2_NoColl
	beq Enemy17_Sub2_Coll
Enemy17_Sub2_EntS1:
	;Play sound
	ldy #SE_SPLASH
	jsr LoadSound
Enemy17_Sub2_Coll:
	;Next task ($03: Move)
	inc Enemy_Temp0,x
	;Set enemy Y position
	lda Enemy_Y,x
	and #$FE
	sta Enemy_Y,x
	;Check for left or right moving log
	lda Enemy_Temp1,x
	and #$01
	bne Enemy17_Sub2_Left
	;Set enemy X velocity left
	lda #$FF
	sta Enemy_XVelHi,x
	rts
Enemy17_Sub2_Left:
	;Set enemy X velocity right
	lda #$01
	sta Enemy_XVelHi,x
Enemy17_Sub2_Exit:
	rts
FloatingLogPlatYPos:
	.db $30,$70,$B0,$FF,$FF,$B0,$FF
Enemy17_Sub2_NoColl:
	;Decrement bobbing timer, check if 0
	dec Enemy_Temp3,x
	bne Enemy17_Sub2_Exit
	;Reset bobbing timer
	lda #$0C
	sta Enemy_Temp3,x
	;Set enemy Y position
	lda Enemy_Y,x
	eor #$01
	sta Enemy_Y,x
	rts
;$03: Move
Enemy17_Sub3:
	;Check for left or right moving log
	lda Enemy_XVelHi,x
	bpl Enemy17_Sub3_Left
	;Get X position for collision (right)
	lda Enemy_X,x
	clc
	adc #$08
	bcc Enemy17_Sub3_NoLeft
	bcs Enemy17_Sub3_ClearF
Enemy17_Sub3_Left:
	;Get X position for collision (left)
	lda Enemy_X,x
	sec
	sbc #$08
	bcc Enemy17_Sub3_ClearF
Enemy17_Sub3_NoLeft:
	;Get collision type
	sta $00
	lda Enemy_Y,x
	sta $01
	jsr GetCollisionType
	;If solid tile underneath, don't set Y acceleration
	bne Enemy17_Sub3_Exit
	;Set enemy Y acceleration
	lda #$7F
	sta Enemy_YAccel,x
	;Next task ($01: Fall)
	dec Enemy_Temp0,x
	dec Enemy_Temp0,x
Enemy17_Sub3_Exit:
	rts
Enemy17_Sub3_ClearF:
	;Clear enemy flags
	lda #$00
	sta Enemy_Flags,x
	rts
FloatingLogSetYAccel:
	;Check for max enemy Y velocity
	lda Enemy_YVelHi,x
	cmp #$08
	bcc Enemy17_Sub3_Exit
	;Clear enemy Y acceleration
	lda #$00
	sta Enemy_YAccel,x
	rts

;$1A: Floating log dummy?
Enemy1A:
	;If player Y position < $1C, clear platform Y position
	lda Enemy_Y
	cmp #$1C
	bcs Enemy1A_NoClearY
	;Clear platform Y position
	lda #$00
	sta PlatformYPos
Enemy1A_NoClearY:
	;Clear enemy flags
	lda #$00
	sta Enemy_Flags+$02
	rts

;$1C: Fish
Enemy1C:
	;Do jump table
	lda Enemy_Temp0,x
	jsr DoJumpTable
Enemy1CJumpTable:
	.dw Enemy1C_Sub0	;$00  Init
	.dw Enemy1C_Sub1	;$01  Main
	.dw Enemy1C_Sub2	;$02  Jump
;$00: Init
Enemy1C_Sub0:
	;Mark inited and set enemy X velocity based on if on left or right side of screen
	jsr Enemy05_Ent07
	;Set enemy priority to be behind background
	lda Enemy_Props,x
	ora #$20
	sta Enemy_Props,x
	;If enemy Y position < player Y position, set enemy flags
	lda Enemy_Y,x
	cmp Enemy_Y
	bcs Enemy1C_Sub0_Exit
	;Set enemy flags
	lda #(EF_ACTIVE|EF_VISIBLE)
	sta Enemy_Flags,x
Enemy1C_Sub0_Exit:
	rts
;$01: Main
Enemy1C_Sub1:
	;Get collision type
	jsr FishGetCollisionType
	;Check if enemy X position $60-$9F
	lda Enemy_X,x
	cmp #$60
	bcc Enemy1C_Sub0_Exit
	cmp #$A0
	bcs Enemy1C_Sub0_Exit
	;Check if enemy is facing left or right
	lda Enemy_Props,x
	and #$40
	beq Enemy1C_Sub1_Right
	;Set X collision check offset left
	lda Enemy_X,x
	sec
	sbc #$20
	jmp Enemy1C_Sub1_NoRight
Enemy1C_Sub1_Right:
	;Set X collision check offset right
	lda Enemy_X,x
	clc
	adc #$20
Enemy1C_Sub1_NoRight:
	;Get collision type
	sta $00
	lda Enemy_Y,x
	sec
	sbc #$08
	sta $01
	jsr GetCollisionType
	;Check for death collision type (used by water)
	cmp #$04
	bne FishGetCollisionType_Exit
	;Set enemy priority to be in front of background
	lda Enemy_Props,x
	and #$DF
	sta Enemy_Props,x
	;Next task ($01: Jump)
	inc Enemy_Temp0,x
	;Set enemy Y velocity/acceleration
	lda #$FB
	sta Enemy_YVelHi,x
	lda #$50
	sta Enemy_YAccel,x
	;Save enemy Y position
	lda Enemy_Y,x
	sta Enemy_Temp2,x
	rts
;$02: Jump
Enemy1C_Sub2:
	;Check if saved Y position < current Y position
	lda Enemy_Temp2,x
	cmp Enemy_Y,x
	bcs FishGetCollisionType_Exit
	;Restore enemy Y position
	sta Enemy_Y,x
	;Set enemy priority to be behind background
	lda Enemy_Props,x
	ora #$20
	sta Enemy_Props,x
	;Clear enemy Y velocity/acceleration
	lda #$00
	sta Enemy_YVelHi,x
	sta Enemy_YVelLo,x
	sta Enemy_YAccel,x
	;Next task ($02: Main)
	dec Enemy_Temp0,x
	;Play sound
	ldy #SE_SPLASH
	jmp LoadSound
FishGetCollisionType:
	;Get collision type
	lda Enemy_X,x
	sta $00
	lda Enemy_Y,x
	sec
	sbc #$08
	sta $01
	jsr GetCollisionType
	;Check for death collision type (used by water)
	cmp #$04
	beq FishGetCollisionType_Exit
	;Flip enemy X velocity
	lda Enemy_XVelHi,x
	eor #$FF
	clc
	adc #$01
	sta Enemy_XVelHi,x
	;Flip enemy X
	lda Enemy_Props,x
	eor #$40
	sta Enemy_Props,x
FishGetCollisionType_Exit:
	rts

;$1D: Balance vine platform
Enemy1D:
	;Check for init mode
	lda Enemy_Temp0,x
	beq Enemy1D_Init
	;Check for main mode
	cmp #$01
	beq Enemy1D_Main
	;If enemy Y position >= $F0, clear enemy flags
	lda Enemy_Y,x
	cmp #$F0
	bcc Enemy1D_FinishExit
	;Clear enemy flags
	lda #$00
	sta Enemy_Flags,x
Enemy1D_FinishExit:
	rts
Enemy1D_Init:
	;Set enemy flags
	lda #(EF_ACTIVE|EF_PLATFORM|EF_VISIBLE)
	sta Enemy_Flags,x
	;Next task ($01: Main)
	inc Enemy_Temp0,x
	;Get slot index for other platform
	txa
	eor #$02
	tay
	;If other slot not active, exit early
	lda Enemy_Flags,y
	beq Enemy1D_MainExit
	;If other slot not balance vine platform, exit early
	lda Enemy_ID,y
	cmp #ENEMY_BALANCEVINEPLAT
	bne Enemy1D_MainExit
	;Set enemy Y position for other platform
	lda #$F0
	sec
	sbc Enemy_Y,y
	sta Enemy_Y,x
	rts
Enemy1D_Main:
	;Get slot index for other platform
	txa
	eor #$02
	tay
	;Check which platform this is
	and #$02
	bne Enemy1D_Right
	;Check if enemy Y position < $A2
	lda Enemy_Y,x
	cmp #$A2
	bcs Enemy1D_Fall
	;Check for collision
	jsr PlatformCheckCollision
	bne Enemy1D_LNoOnLeft
	;Set on left platform flag
	lda #$01
	bne Enemy1D_LOnLeft
Enemy1D_LNoOnLeft:
	;Clear on left platform flag
	lda #$00
Enemy1D_LOnLeft:
	sta Enemy_Temp3,x
Enemy1D_MainExit:
	rts
Enemy1D_Right:
	;Check if enemy Y position < $A2
	lda Enemy_Y,x
	cmp #$A2
	bcs Enemy1D_Fall
	;Check for collision
	jsr PlatformCheckCollision
	bne Enemy1D_RNoOnRight
	;If other slot not active, don't check on left platform flag
	lda Enemy_Flags,y
	beq Enemy1D_ROnRight
	;Check if on left platform
	lda Enemy_Temp3,y
	bne Enemy1D_CheckY
Enemy1D_ROnRight:
	;Set enemy Y velocity to move right platform down/left platform up
	lda #$01
	sta Enemy_YVelHi,x
	lda #$FF
	sta Enemy_YVelHi,y
	rts
Enemy1D_RNoOnRight:
	;If other slot not active, don't check on left platform flag
	lda Enemy_Flags,y
	beq Enemy1D_CheckY
	;Check if on left platform
	lda Enemy_Temp3,y
	bne Enemy1D_ROnLeft
Enemy1D_CheckY:
	;If enemy Y velocity not 0, clear enemy Y velocity (move once every 2 frames)
	lda Enemy_YVelHi,x
	bne Enemy1D_ROff
	;Check if enemy Y position >= $80 (reset platforms to rest position)
	lda Enemy_Y,x
	cmp #$80
	beq Enemy1D_ROff
	bcc Enemy1D_ROnRight
Enemy1D_ROnLeft:
	;Set enemy Y velocity to move right platform up/left platform down
	lda #$FF
	sta Enemy_YVelHi,x
	lda #$01
	sta Enemy_YVelHi,y
	rts
Enemy1D_ROff:
	;Clear enemy Y velocity
	lda #$00
	sta Enemy_YVelHi,x
	sta Enemy_YVelHi,y
	rts
Enemy1D_Fall:
	;Next task ($02: Finish)
	lda #$02
	sta Enemy_Temp0,x
	sta Enemy_Temp0,y
	;Set enemy Y velocity/acceleration
	sta Enemy_YVelHi,x
	sta Enemy_YVelHi,y
	lda #$7F
	sta Enemy_YAccel,x
	sta Enemy_YAccel,y
	;Play sound
	ldy #SE_VINEPLATFALL
	jmp LoadSound
PlatformCheckCollision:
	;Check if player is on this platform
	stx $00
	lda Enemy_Temp0
	and #$70
	lsr
	lsr
	lsr
	lsr
	cmp $00
	rts

;$1F: Falling tree platform left
;$20: Falling tree platform right
Enemy1F:
	;Check for init mode
	lda Enemy_Temp0,x
	beq Enemy1F_Init
	;Check for main mode
	cmp #$01
	beq Enemy1F_Main

;$1E: Balance vine mask
Enemy1E:
	;Do nothing
	rts

Enemy1F_Init:
	;Check for collision
	jsr PlatformCheckCollision
	bne Enemy1F_Exit
	;Init animation timer
	lda #$10
	sta Enemy_Temp1,x
	;Next task ($01: Main)
	inc Enemy_Temp0,x
Enemy1F_Exit:
	rts
Enemy1F_Main:
	;Decrement animation timer, check if 0
	dec Enemy_Temp1,x
	bne Enemy1F_Exit
	;Set enemy Y acceleration
	lda #$7F
	sta Enemy_YAccel,x
	;Next task ($02: Finish)
	inc Enemy_Temp0,x
	;Play sound
	ldy #SE_TREEPLATFALL
	jmp LoadSound

;$21: Side flower
Enemy21:
	;Check if already inited
	lda Enemy_Temp0,x
	bne Enemy1F_Exit
	;Mark inited
	inc Enemy_Temp0,x
	;Set enemy animation based on slot index
	txa
	asl
	sta Enemy_AnimOffs,x
	;Check if on left or right side of screen
	lda Enemy_X,x
	cmp #$F0
	bne Enemy1F_Exit
	;Flip enemy X
	lda #$40
	sta Enemy_Props,x
	rts

;$22: Falling rock
Enemy22:
	;Check if delay timer 0, if so, init enemy
	lda Enemy_Temp2,x
	beq Enemy22_Init
	;Decrement delay timer
	dec Enemy_Temp2,x
	;Set low gravity flag
	lda #$01
	sta Enemy_Temp3,x
	rts
Enemy22_Init:
	;Check low gravity flag
	lda Enemy_Temp3,x
	bne Enemy22_LowG
	;Set enemy Y acceleration
	lda #$7F
	sta Enemy_YAccel,x
	;If enemy Y velocity >= $08, clear enemy Y acceleration
	lda Enemy_YVelHi,x
	bmi Enemy23_Exit
	cmp #$08
	bcc Enemy23_Exit
Enemy22_ClearY:
	;Clear enemy Y acceleration
	lda #$00
	sta Enemy_YAccel,x
	rts
Enemy22_LowG:
	;Set enemy Y acceleration
	lda #$7F
	sta Enemy_YAccel,x
	;If enemy Y velocity >= $04, clear enemy Y acceleration
	lda Enemy_YVelHi,x
	bmi Enemy23_Exit
	cmp #$04
	bcs Enemy22_ClearY
	rts

;$23: Falling rock/ship mouth spawner
Enemy23:
	;Check if rock or ship mouth spawner based on parameter value
	lda Enemy_Temp1,x
	beq Enemy23_RockMode
	;Check if already inited
	lda Enemy_Temp0,x
	bne Enemy23_Exit
	;Mark inited
	inc Enemy_Temp0,x
	;Spawn enemies
	lda #$00
	sta $00
	sta $01
	ldy #$03
	jsr SpawnEnemy
	lda #$00
	sta $00
	sta $01
	iny
	jsr SpawnEnemy
	;Set enemy active flag
	lda #EF_ACTIVE
	sta Enemy_Flags+$03
	sta Enemy_Flags+$04
	;Set enemy ID to ship mouth
	lda #ENEMY_SHIPMOUTH
	sta Enemy_ID+$03
	sta Enemy_ID+$04
	;Set enemy collision size
	lda #$08
	sta Enemy_CollWidth+$03
	sta Enemy_CollWidth+$04
	sta Enemy_CollHeight+$03
	sta Enemy_CollHeight+$04
	;Set enemy X position
	lda #$68
	sta Enemy_X+$03
	lda #$A8
	sta Enemy_X+$04
	;Set enemy Y position
	lda #$50
	sta Enemy_Y+$03
	lda #$30
	sta Enemy_Y+$04
	;Set ship mouth position
	lda #$03
	sta Enemy_Temp1+$03
	lda #$02
	sta Enemy_Temp1+$04
	rts
Enemy23_RockMode:
	;If bits 0-3 of global timer 0, spawn rock
	lda LevelGlobalTimer
	and #$0F
	beq Enemy23_RockSpawn
Enemy23_Exit:
	rts
Enemy23_RockSpawn:
	;Spawn enemy
	lda #$00
	sta $00
	lda #$A0
	jsr FindFreeEnemySlot
	;If no free slot available, exit early
	bcc Enemy23_Exit
	;Set enemy X position randomly
	tax
	jsr GetPRNGValue
	;If enemy X position $00-$17 or $E8-$FF, flip bit 7
	cmp #$18
	bcc Enemy23_FlipX
	cmp #$E8
	bcc Enemy23_NoFlipX
Enemy23_FlipX:
	;Flip bit 7 to make enemy X position in range of waterfall
	eor #$80
Enemy23_NoFlipX:
	sta Enemy_X,x
	;Check for top of level 1 waterfall area
	lda CurScreen
	cmp #$1D
	bne Enemy23_SetYVel
	;Set enemy Y position
	lda #$34
	sec
	sbc TempMirror_PPUSCROLL_Y
	bcs Enemy23_SetYPos
Enemy23_SetYVel:
	;Set enemy Y velocity
	lda #$06
	sta Enemy_YVelHi,x
	;Set enemy Y position
	lda #$00
Enemy23_SetYPos:
	sta Enemy_Y,x
	;Set enemy ID to falling rock
	lda #ENEMY_FALLINGROCK
	sta Enemy_ID,x
	;Set enemy Y acceleration
	lda #$60
	sta Enemy_YAccel,x
	;Set enemy animation based on random value
	jsr GetPRNGValue
	and #$02
	clc
	adc #$A0
	tay
	jsr SetEnemyAnimation
	;Restore X register
	ldx $10
	rts
RockAnim:
	.db $9A,$9C,$9E,$A0,$A2,$9E,$A0,$A2

;$16: Level 1 boss
Enemy16:
	;Decrement scroll timer
	dec Enemy_Temp1+$01
	;Do jump table
	lda Enemy_Temp0+$01
	jsr DoJumpTable
Enemy16JumpTable:
	.dw Enemy16_Sub0	;$00  Init
	.dw Enemy16_Sub1	;$01  Idle
	.dw Enemy16_Sub2	;$02  Jump
	.dw Enemy16_Sub3	;$03  Land
	.dw Enemy16_Sub4	;$04  Boulder drop part 1
	.dw Enemy16_Sub5	;$05  Boulder drop part 2
	.dw Enemy16_Sub6	;$06  Boulder hold
	.dw Enemy16_Sub7	;$07  Boulder throw
	.dw Enemy16_Sub8	;$08  Boulder land
	.dw Enemy16_Sub9	;$09  Run left
	.dw Enemy16_SubA	;$0A  Idle left
	.dw Enemy16_SubB	;$0B  Run right
	.dw Enemy16_SubC	;$0C  Idle right
	.dw Enemy16_SubD	;$0D  Run to center
;$00: Init
Enemy16_Sub0:
	;Init scroll Y position
	lda #$95
	sta TempMirror_PPUSCROLL_Y
	lda #$A8
	sta TempMirror_PPUCTRL
	;Init animation timer
	lda #$40
	sta Enemy_Temp2+$01
	;Set boss enemy slot index
	lda #$01
	sta BossEnemyIndex
	;Next task ($01: Idle)
	inc Enemy_Temp0+$01

;$26: Level 1 boss boulder
Enemy26:
	;Do nothing
	rts

;$01: Idle
Enemy16_Sub1:
	;Decrement animation timer, check if 0
	dec Enemy_Temp2+$01
	bne Enemy26
Enemy16_Sub1_EntSD:
	;Set enemy Y acceleration
	lda #$7F
	sta Enemy_YAccel+$01
	;Set enemy velocity
	lda #$F9
	sta Enemy_YVelHi+$01
	lda #$FF
	sta Enemy_XVelHi+$01
	;Reset animation timer
	lda #$1B
	sta Enemy_Temp2+$01
	;Next task ($02: Jump)
	inc Enemy_Temp0+$01
	;Set enemy animation
	ldy #$8E
	jmp SetEnemyAnimation
;$02: Jump
Enemy16_Sub2:
	;Set enemy animation timer
	lda #$FE
	sta Enemy_AnimTimer+$01
	;Decrement animation timer, check if 0
	dec Enemy_Temp2+$01
	bne Enemy26
	;Clear enemy velocity/acceleration
	jsr ClearEnemy_ClearXY
	;Next task ($03: Land)
	inc Enemy_Temp0,x
	;Set enemy Y position
	lda #$8F
	sta Enemy_Y+$01
	;Reset animation timer
	lda #$20
	sta Enemy_Temp2+$01
	;Set enemy animation
	ldy #$88
	jsr SetEnemyAnimation
	;Play sound
	ldy #SE_CRASH
	jmp LoadSound
Level1BossQuake:
	;If bits 0-1 of animation timer 0, set scroll Y position to quake up/down
	lda Enemy_Temp2+$01
	and #$03
	bne Level1BossQuake_Exit
	;Set scroll Y position to quake up/down
	lda TempIRQBufferHeight+1
	eor #$02
	sta TempIRQBufferHeight+1
	lda TempIRQBufferHeight+2
	eor #$02
	sta TempIRQBufferHeight+2
Level1BossQuake_Exit:
	rts
;$03: Land
Enemy16_Sub3:
	;Process quaking effect
	jsr Level1BossQuake
	;Decrement animation timer, check if 0
	dec Enemy_Temp2+$01
	bne Enemy26
	;Init scroll timer
	lda #$7E
	sta Enemy_Temp1+$01
	;Next task ($04: Boulder drop part 1)
	inc Enemy_Temp0+$01
	;Set enemy animation
	ldy #$8A
	jmp SetEnemyAnimation
;$04: Boulder drop part 1
Enemy16_Sub4:
	;Move boulder down $04
	lda TempMirror_PPUSCROLL_Y
	sec
	sbc #$04
	sta TempMirror_PPUSCROLL_Y
	lda TempIRQBufferHeight
	clc
	adc #$04
	sta TempIRQBufferHeight
	lda TempIRQBufferHeight+1
	sec
	sbc #$04
	sta TempIRQBufferHeight+1
	;Check if entire boulder is visible
	lda TempMirror_PPUSCROLL_Y
	cmp #$3D
	bne Enemy16_Sub4_Exit
	;Copy IRQ scroll buffer over one entry
	ldy #$02
Enemy16_Sub4_Loop:
	;Copy IRQ scroll buffer entry
	lda TempIRQBufferScrollY,y
	sta TempIRQBufferScrollY+1,y
	lda TempIRQBufferHeight,y
	sta TempIRQBufferHeight+1,y
	lda TempIRQBufferScrollHi,y
	sta TempIRQBufferScrollHi+1,y
	;Loop for each entry
	dey
	bpl Enemy16_Sub4_Loop
	;Add IRQ scroll buffer entry for blank section above boulder
	lda TempIRQBufferHeight+1
	sec
	sbc #$05
	sta TempIRQBufferHeight+1
	lda #$40
	sta TempIRQBufferScrollY
	lda #$04
	sta TempIRQBufferHeight
	lda #$20
	sta TempIRQBufferScrollHi
	;Set scroll Y position
	lda #$00
	sta TempMirror_PPUSCROLL_Y
	lda #$A9
	sta TempMirror_PPUCTRL
	;Increment IRQ scroll buffer entry count
	inc TempIRQCount
	;Next task ($05: Boulder drop part 2)
	inc Enemy_Temp0+$01
Enemy16_Sub4_Exit:
	rts
;$05: Boulder drop part 2
Enemy16_Sub5:
	;Move boulder down $04
	lda TempIRQBufferHeight
	clc
	adc #$04
	sta TempIRQBufferHeight
	lda TempIRQBufferHeight+2
	sec
	sbc #$04
	sta TempIRQBufferHeight+2
	;Check if boulder hit hands
	lda TempIRQBufferHeight
	cmp #$20
	bne Enemy16_Sub4_Exit
	;Next task ($06: Boulder hold)
	inc Enemy_Temp0+$01
	rts
;$06: Boulder hold
Enemy16_Sub6:
	;Check if scroll timer 0, if so, setup next task
	lda Enemy_Temp1,x
	bne Enemy16_Sub4_Exit
	;Next task ($07: Boulder throw)
	inc Enemy_Temp0,x
	;Init boulder Y velocity
	lda #$00
	sta Enemy_Temp2,x
	lda #$FC
	sta Enemy_Temp3,x
	;Spawn enemy
	lda #$00
	sta $00
	sta $01
	ldy #$0C
	lda #$A8
	jsr SpawnEnemy
	;Set enemy X position
	lda #$AF
	sta Enemy_X,y
	;Set enemy collision width
	lda #$30
	sta Enemy_CollWidth,y
	;Set enemy Y position
	lda #$60
	sta Enemy_Y,y
	;Set enemy collision height
	lda #$0F
	sta Enemy_CollHeight,y
	;Set enemy ID to level 1 boss boulder
	lda #ENEMY_LEVEL1BOSSBOULDER
	sta Enemy_ID,y
	;Set enemy Y velocity/acceleration
	lda #$FC
	sta Enemy_YVelHi,y
	lda #$60
	sta Enemy_YAccel,y
	;Set enemy X velocity
	lda #$FC
	sta Enemy_XVelHi,y
	;Set enemy flags
	lda #(EF_ACTIVE|EF_HITENEMY|EF_VISIBLE)
	sta Enemy_Flags,y
	rts
;$07: Boulder throw
Enemy16_Sub7:
	;Check if scroll timer $E8, if so, set enemy animation
	lda Enemy_Temp1+$01
	cmp #$E8
	bne Enemy16_Sub7_NoAnim
	;Set enemy animation
	ldy #$88
	jsr SetEnemyAnimation
Enemy16_Sub7_NoAnim:
	;Increment boulder Y velocity
	jsr Level1BossBoulderSetYVel
	;Apply boulder Y velocity to boulder Y position
	clc
	adc TempIRQBufferHeight
	sta TempIRQBufferHeight
	lda #$51
	sec
	sbc TempIRQBufferHeight
	sta TempIRQBufferHeight+2
	;Move boulder left $04
	lda TempIRQBufferScrollX
	clc
	adc #$04
	sta TempIRQBufferScrollX
	;Check if boulder hit ground
	lda TempIRQBufferHeight
	cmp #$50
	bcc Enemy16_Sub7_Exit
	;Next task ($08: Boulder land)
	inc Enemy_Temp0+$01
	;Save X register
	stx $17
	;Load IRQ buffer set
	ldx #$04
	jsr LoadIRQBufferSet
	;Restore X register
	ldx $17
	;Set scroll Y position
	lda #$E0
	sta TempMirror_PPUSCROLL_Y
	lda #$A8
	sta TempMirror_PPUCTRL
	;Reset animation timer
	lda #$40
	sta Enemy_Temp2+$01
	;Play sound
	ldy #SE_CRASH
	jsr LoadSound
	;Spawn falling rocks
	ldx #$00
	jsr Level1BossRockSpawn
	;Clear enemy flags
	lda #$00
	sta Enemy_Flags+$0C
Enemy16_Sub7_Exit:
	rts
Level1BossRockSpawn:
	;Spawn rocks
	ldy #$02
Level1BossRockSpawn_Loop:
	;Spawn enemy
	lda #$00
	sta $00
	sta $01
	lda #$24
	jsr SpawnEnemy
	;Set enemy X position
	lda Level1BossRockXPos,x
	sta Enemy_X,y
	;Get enemy Y position or delay timer value
	lda Level1BossRockYT,x
	;Check which rock spawn mode this is
	cpx #$0A
	bcs Level1BossRockSpawn_Delay
	;Set enemy Y position
	sta Enemy_Y,y
	bne Level1BossRockSpawn_NoDelay
Level1BossRockSpawn_Delay:
	;Set delay timer
	sta Enemy_Temp2,y
	;Set enemy Y position
	lda #$00
	sta Enemy_Y,y
Level1BossRockSpawn_NoDelay:
	;Set enemy X velocity $00
	lda #$00
	;Check which rock spawn mode this is
	cpx #$0A
	bcs Level1BossRockSpawn_SetX
	;Set enemy X velocity based on slot index
	lda Level1BossRockXVel,x
Level1BossRockSpawn_SetX:
	sta Enemy_XVelHi,y
	;Set enemy Y velocity $FE
	lda #$FE
	;Check which rock spawn mode this is
	cpx #$0A
	bcc Level1BossRockSpawn_SetY
	;Set enemy Y velocity $00
	lda #$00
Level1BossRockSpawn_SetY:
	sta Enemy_YVelHi,y
	;Set enemy ID to falling rock
	lda #ENEMY_FALLINGROCK
	sta Enemy_ID,y
	;Save X register
	stx $16
	;Get animation table index
	txa
	and #$07
	tax
	;Save Y register
	sty $15
	;Set enemy animation
	ldy Level1BossRockAnim,x
	ldx $15
	jsr SetEnemyAnimation
	;Restore X/Y registers
	ldx $16
	ldy $15
	;Loop for each rock
	inx
	iny
	cpy #$0C
	bne Level1BossRockSpawn_Loop
	;Restore X register
	ldx #$01
	rts
Level1BossRockXPos:
	;$00
	.db $30,$38,$40,$48,$50,$58,$60,$68,$70,$78
	;$0A
	.db $18,$38,$58,$78,$98,$A8,$B8,$C8,$D8,$E8
Level1BossRockYT:
	;$00
	.db $58,$88,$70,$90,$50,$80,$68,$48,$60,$78
	;$0A
	.db $11,$41,$29,$49,$09,$39,$21,$01,$19,$31
Level1BossRockXVel:
	.db $FF,$FF,$FF,$FF,$FF,$01,$01,$01,$01,$01
Level1BossRockAnim:
	.db $A2,$A4,$9A,$9C,$9E,$A0,$9E,$A0
Level1BossBoulderSetYVel:
	;Increment boulder Y velocity by $60
	lda Enemy_Temp2+$01
	clc
	adc #$60
	sta Enemy_Temp2+$01
	lda Enemy_Temp3+$01
	adc #$00
	sta Enemy_Temp3+$01
	sta $00
Level1BossBoulderSetYVel_Exit:
	rts
;$08: Boulder land
Enemy16_Sub8:
	;Decrement animation timer, check if 0
	dec Enemy_Temp2+$01
	bne Level1BossBoulderSetYVel_Exit
	;Set scroll Y position
	lda #$95
	sta TempMirror_PPUSCROLL_Y
	;Next task ($09: Run left)
	inc Enemy_Temp0+$01
	;Set X velocity
	lda #$FC
	sta Enemy_XVelHi+$01
	;Set enemy animation
	ldy #$8E
	jmp SetEnemyAnimation
;$09: Run left
Enemy16_Sub9:
	;Check if at left side of screen
	lda Enemy_X+$01
	cmp #$0F
	bne Level1BossBoulderSetYVel_Exit
Enemy16_Sub9_EntSB:
	;Next task ($0A: Idle left)
	inc Enemy_Temp0+$01
	;Clear enemy X velocity
	lda #$00
	sta Enemy_XVelHi+$01
	;Reset animation timer
	lda #$40
	sta Enemy_Temp2+$01
	;Play sound
	ldy #SE_CRASH
	jsr LoadSound
	;Set enemy animation
	ldy #$8C
	jsr SetEnemyAnimation
	;Spawn falling rocks
	ldx #$0A
	jmp Level1BossRockSpawn
;$0A: Idle left
Enemy16_SubA:
	;Process quaking effect
	jsr Level1BossQuake
	;Decrement animation timer, check if 0
	dec Enemy_Temp2+$01
	bne Level1BossBoulderSetYVel_Exit
	;Set enemy X velocity
	lda #$04
	sta Enemy_XVelHi+$01
	;Flip enemy X
	lda #$40
Enemy16_SubA_EntSC:
	sta Enemy_Props+$01
	;Next task ($0B: Run right)
	inc Enemy_Temp0+$01
	;Set enemy animation
	ldy #$8E
	jmp SetEnemyAnimation
;$0B: Run right
Enemy16_SubB:
	;Check if at right side of screen
	lda Enemy_X+$01
	cmp #$F7
	bne Level1BossBoulderSetYVel_Exit
	;Setup next state ($0C: Idle right)
	beq Enemy16_Sub9_EntSB
;$0C: Idle right
Enemy16_SubC:
	;Process quaking effect
	jsr Level1BossQuake
	;Decrement animation timer, check if 0
	dec Enemy_Temp2+$01
	bne Level1BossBoulderSetYVel_Exit
	;Set enemy X velocity
	lda #$FF
	sta Enemy_XVelHi+$01
	;Unflip enemy X and setup next task ($0D: Run to center)
	lda #$00
	beq Enemy16_SubA_EntSC
;$0D: Run to center
Enemy16_SubD:
	;Check if at center right of screen
	lda Enemy_X+$01
	cmp #$CA
	bne Enemy16_SubD_Exit
	;Next task ($01: Idle)
	lda #$01
	sta Enemy_Temp0+$01
	;Setup next task
	jmp Enemy16_Sub1_EntSD
Enemy16_SubD_Exit:
	rts

;$57: Trooper in trench
Enemy57:
	;Check if on left or right side of screen
	lda Enemy_X,x
	bmi Enemy57_Right
	;Don't flip enemy X
	lda #$00
	beq Enemy57_SetP
Enemy57_Right:
	;Flip enemy X
	lda #$40
Enemy57_SetP:
	sta Enemy_Props,x
	;Increment animation timer
	inc Enemy_Temp1,x
	;Check for shoot mode
	lda Enemy_Temp0,x
	cmp #$01
	beq Enemy57_Main
	;Check for finish mode
	cmp #$02
	beq Enemy57_Finish
	;If bits 0-5 of animation timer 0, shoot projectile
	lda Enemy_Temp1,x
	and #$3F
	bne Enemy57_Exit
	;If enemy X position $60-$A0, shoot upward
	lda Enemy_X,x
	cmp #$60
	bcc Enemy57_NoUp
	cmp #$A0
	bcs Enemy57_NoUp
	;Shoot diagonally
	lda #$00
	sta Enemy_Temp3,x
	;Set enemy animation
	ldy #$C0
	bne Enemy57_SetAnim
Enemy57_NoUp:
	;Shoot upward
	lda #$01
	sta Enemy_Temp3,x
	;Set enemy animation
	ldy #$BE
Enemy57_SetAnim:
	jsr SetEnemyAnimation
	;Next task ($01: Main)
	inc Enemy_Temp0,x
Enemy57_Exit:
	rts
Enemy57_Main:
	;If bits 0-3 of animation timer 0, finish shooting
	lda Enemy_Temp1,x
	and #$0F
	bne Enemy57_Exit
	;Get shooting direction index
	lda Enemy_Props,x
	lsr
	lsr
	lsr
	lsr
	lsr
	clc
	adc Enemy_Temp3,x
	tay
	;Get enemy position/velocity
	lda TrooperTrenchProjXPos,y
	sta $00
	lda TrooperTrenchProjYPos,y
	sta $01
	lda TrooperTrenchProjXVel,y
	sta $16
	lda TrooperTrenchProjYVel,y
	sta $17
	;Spawn enemy
	lda #$24
	jsr FindFreeEnemySlot
	;If no free slot available, exit early
	bcc Enemy57_Next
	;Set enemy velocity
	lda $16
	sta Enemy_XVelHi,y
	lda $17
	sta Enemy_YVelHi,y
Enemy57_Next:
	;Next task ($02: Finish)
	inc Enemy_Temp0,x
	rts
Enemy57_Finish:
	;If bits 0-3 of animation timer 0, start aiming again
	lda Enemy_Temp1,x
	and #$0F
	bne Enemy57_Exit
	;Next task ($00: Init)
	lda #$00
	sta Enemy_Temp0,x
	;Set enemy animation
	ldy #$16
	jmp SetEnemyAnimation
TrooperTrenchProjXPos:
	.db $01,$06,$FF,$FA
TrooperTrenchProjYPos:
	.db $F8,$FD,$F8,$FD
TrooperTrenchProjXVel:
	.db $00,$03,$00,$FD
TrooperTrenchProjYVel:
	.db $FC,$FE,$FC,$FE

;$46: Flashing arrow
Enemy46:
	;Check if already inited
	lda Enemy_Temp0,x
	bne Enemy46_Main
	;Check for level 2 vertical climbing area arrow
	cpx #$05
	bne Enemy46_Next
	;Check for level 2 vertical climbing area
	lda CurArea
	cmp #$28
	beq Enemy46_ClearF
Enemy46_Next:
	;Mark inited
	inc Enemy_Temp0,x
	rts
Enemy46_ClearF:
	;Clear enemy flags
	lda #$00
	sta Enemy_Flags,x
	rts
Enemy46_Main:
	;If bit 3 of global timer 0, show enemy
	lda LevelGlobalTimer
	and #$08
	beq Enemy46_Show
	;Clear enemy visible flag
	lda #(EF_ACTIVE|EF_NOANIM)
	sta Enemy_Flags,x
	rts
Enemy46_Show:
	;Set enemy visible flag
	lda #(EF_ACTIVE|EF_NOANIM|EF_VISIBLE)
	sta Enemy_Flags,x
	rts

;$49: Blue side spikes
Enemy49:
	;Check if already inited
	lda Enemy_Temp0,x
	bne Enemy49_Main
	;Check if on left or right side of screen
	lda Enemy_X,x
	bpl Enemy49_Left
	;Flip enemy X
	lda #$40
	sta Enemy_Props,x
	;Set enemy X velocity right
	lda #$00
	beq Enemy49_SetX
Enemy49_Left:
	;Set enemy X velocity left
	lda #$FF
Enemy49_SetX:
	sta Enemy_XVelHi,x
	lda #$80
	sta Enemy_XVelLo,x
	;Init animation timer
	lda #$10
	sta Enemy_Temp2,x
	;Set enemy flags
	lda #(EF_ACTIVE|EF_NOANIM|EF_HITENEMY|EF_VISIBLE)
	sta Enemy_Flags,x
	;Mark inited
	inc Enemy_Temp0,x
Enemy49_Exit:
	rts
Enemy49_Main:
	;Decrement animation timer, check if 0
	dec Enemy_Temp2,x
	bne Enemy49_Exit
	;Reset animation timer
	lda #$10
	sta Enemy_Temp2,x
	;Flip enemy X velocity
	lda Enemy_XVelHi,x
	eor #$FF
	sta Enemy_XVelHi,x

;$28: Lava bubble splash
Enemy28:
	;Do nothing
	rts

;$29: Lava bubble
Enemy29:
	;Do jump table
	lda Enemy_Temp0,x
	jsr DoJumpTable
Enemy29JumpTable:
	.dw Enemy29_Sub0	;$00  Init
	.dw Enemy29_Sub1	;$01  Up
	.dw Enemy29_Sub2	;$02  Down
	.dw Enemy29_Sub3	;$03  Splash
;$00: Init
Enemy29_Sub0:
	;Save enemy Y position
	lda Enemy_Y,x
	sta Enemy_Temp2,x
	;Next task ($01: Up)
	inc Enemy_Temp0,x
Enemy29_Sub0_EntS3:
	;Set enemy Y velocity/acceleration
	lda #$F6
	sta Enemy_YVelHi,x
	lda #$60
	sta Enemy_YAccel,x
Enemy29_Sub0_Exit:
	rts
;$01: Up
Enemy29_Sub1:
	;Check if moving down
	lda Enemy_YVelHi,x
	bmi Enemy29_Sub0_Exit
	;Next task ($02: Down)
	inc Enemy_Temp0,x
	;Set enemy animation
	ldy #$F4
	jmp SetEnemyAnimation
;$02: Down
Enemy29_Sub2:
	;Check if saved Y position < current Y position
	lda Enemy_Temp2,x
	cmp Enemy_Y,x
	bcs Enemy29_Sub0_Exit
	;Restore enemy Y position
	sta Enemy_Y,x
	;Init animation timer
	lda #$40
	sta Enemy_Temp3,x
	;Clear enemy Y velocity/acceleration
	lda #$00
	sta Enemy_YVelHi,x
	sta Enemy_YVelLo,x
	sta Enemy_YAccel,x
	;Next task ($03: Splash)
	inc Enemy_Temp0,x
	;Set enemy animation
	ldy #$F2
	jsr SetEnemyAnimation
	;Clear enemy visible flag
	lda #(EF_ACTIVE|EF_HITENEMY)
	sta Enemy_Flags,x
Enemy29_Sub2_EntS3:
	;Get slot index for lava bubble splash
	txa
	tay
	dey
	;Set enemy animation
	lda #$02
	sta Enemy_AnimOffs,y
	sta Enemy_AnimTimer,y
	rts
;$03: Splash
Enemy29_Sub3:
	;Decrement animation timer, check if 0
	dec Enemy_Temp3,x
	bne Enemy29_Sub0_Exit
	;Set enemy animation
	jsr Enemy29_Sub2_EntS3
	;Set enemy visible flag
	lda #(EF_ACTIVE|EF_HITENEMY|EF_VISIBLE)
	sta Enemy_Flags,x
	;Next task ($01: Up)
	lda #$01
	sta Enemy_Temp0,x
	;Set enemy Y velocity/acceleration
	bne Enemy29_Sub0_EntS3

;$2A: Volcano
Enemy2A:
	;Check for init mode
	lda Enemy_Temp0,x
	beq Enemy2A_Sub0
	;Set enemy X velocity
	jsr VolcanoSetXVel
	;Do jump table
	lda Enemy_Temp0,x
	jsr DoJumpTable
Enemy2AJumpTable:
	.dw Enemy2A_Sub0	;$00  Init
	.dw Enemy2A_Sub1	;$01  Wait
	.dw Enemy2A_Sub2	;$02  Erupt
	.dw Enemy2A_Sub3	;$03  Fall
;$00: Init
Enemy2A_Sub0:
	;Next task ($01: Wait)
	inc Enemy_Temp0,x
	;If on left side of screen, clear enemy flags
	lda Enemy_X,x
	bmi Enemy2A_Sub2_Exit
	;Clear enemy flags
	lda #$00
	sta Enemy_Flags,x
	rts
;$01: Wait
Enemy2A_Sub1:
	;If enemy X position < $B0, erupt
	lda Enemy_X,x
	cmp #$B0
	bcs Enemy2A_Sub2_Exit
	;Set enemy visible flag
	lda #(EF_ACTIVE|EF_VISIBLE)
	sta Enemy_Flags,x
	;Set enemy animation
	lda #$00
	sta Enemy_AnimOffs,x
	lda #$0E
	sta Enemy_AnimTimer,x
	;Set enemy sprite
	lda #$34
	sta Enemy_SpriteLo,x
	;Init animation timer
	lda #$27
	sta Enemy_Temp2,x
	;Next task ($02: Erupt)
	inc Enemy_Temp0,x
	;Play sound
	ldy #SE_BGFIREARCH
	jmp LoadSound
;$02: Erupt
Enemy2A_Sub2:
	;Decrement animation timer, check if 0
	dec Enemy_Temp2,x
	bne Enemy2A_Sub2_Exit
	;Clear enemy visible flag
	lda #EF_ACTIVE
	sta Enemy_Flags,x
	;Reset animation timer
	lda #$20
	sta Enemy_Temp2,x
	;Next task ($03: Fall)
	inc Enemy_Temp0,x
	;Spawn rock flying out of volcano
	lda #$03
	sta Enemy_Temp3,x
	ldy #$03
Enemy2A_Sub2_Fly:
	;Spawn enemy
	lda VolcanoFlyingRockXPos,y
	sta $00
	lda VolcanoFlyingRockYPos,y
	sta $01
	;Save Y register
	sty $0F
	lda VolcanoFlyingRockAnim,y
	jsr FindFreeEnemySlot
	;If no free slots available, exit early
	bcc Enemy2A_Sub2_Exit
	;Get slot index for flying rock
	tya
	tax
	;Restore Y register
	ldy $0F
	;Set enemy Y velocity
	lda #$F8
	sta Enemy_YVelHi,x
	;Restore X register
	ldx $10
Enemy2A_Sub2_Exit:
	rts
VolcanoFlyingRockXPos:
	.db $FE,$02,$FE,$02
VolcanoFlyingRockYPos:
	.db $00,$FC,$00,$FC
VolcanoFlyingRockAnim:
	.db $D2,$D0,$D2,$D0
;$03: Fall
Enemy2A_Sub3:
	;Decrement animation timer, check if 0
	dec Enemy_Temp2,x
	beq Enemy2A_Sub3_Fall
	;If bits 0-2 of animation timer 0, spawn another flying rock
	lda Enemy_Temp2,x
	and #$07
	bne Enemy2A_Sub2_Exit
	;Save X register
	stx $10
	;Decrement flying rock index
	dec Enemy_Temp3,x
	ldy Enemy_Temp3,x
	;Spawn rock flying out of volcano
	jmp Enemy2A_Sub2_Fly
Enemy2A_Sub3_Fall:
	;Spawn falling rocks
	lda #$00
	sta Enemy_Flags,x
	ldy #$04
Enemy2A_Sub3_Loop:
	;Spawn enemy
	lda #$00
	sta $00
	sta $01
	;Save Y register
	sty $0F
	lda VolcanoFallingRockAnim,y
	jsr FindFreeEnemySlot
	;If no free slots available, exit early
	bcc Enemy2A_Sub3_Exit
	;Get slot index for falling rock
	tya
	tax
	;Restore Y register
	ldy $0F
	;Set enemy X position
	lda VolcanoFallingRockXPos,y
	sta Enemy_X,x
	;Set delay timer
	lda VolcanoFallingRockTimer,y
	sta Enemy_Temp2,x
	;Set enemy ID to falling rock
	lda #ENEMY_FALLINGROCK
	sta Enemy_ID,x
	;Set enemy Y position
	lda #$00
	sta Enemy_Y,x
	;Restore X register
	ldx $10
	;Loop for each falling rock
	dey
	bpl Enemy2A_Sub3_Loop
Enemy2A_Sub3_Exit:
	rts
VolcanoFallingRockAnim:
	.db $C6,$CC,$CA,$C4,$C8
VolcanoFallingRockXPos:
	.db $78,$98,$B8,$D8,$F8
VolcanoFallingRockTimer:
	.db $20,$08,$38,$14,$2C
VolcanoSetXVel:
	;Set enemy X velocity based on scroll X velocity
	lda #$00
	sta $01
	lda ScrollXVelHi
	sta $00
	asl
	ror $00
	ror $01
	lda $00
	sta Enemy_XVelHi,x
	lda $01
	sta Enemy_XVelLo,x
	rts

;$2B: BG fire arch
Enemy2B:
	;Check for spawner
	lda Enemy_Temp2,x
	beq Enemy2B_Spawner
	;If enemy Y position >= $B0, clear enemy flags
	lda Enemy_Y,x
	cmp #$B0
	bcc Enemy2B_Exit
	;Clear enemy flags
	lda #$00
	sta Enemy_Flags,x
	rts
Enemy2B_Spawner:
	;If bits 0-1 of global timer not 0, exit early
	lda LevelGlobalTimer
	and #$03
	bne Enemy2B_Exit
	;If BG fire arch timer >= $0C, exit early
	lda BGFireArchTimer
	cmp #$0C
	bcs Enemy2B_Exit
	;If bit 0 of BG fire arch timer 0, exit early
	and #$01
	beq Enemy2B_Exit
	;Spawn enemy
	lda #$00
	sta $00
	sta $01
	;Get slot index for BG fire arch section
	lda BGFireArchTimer
	lsr
	clc
	adc #$07
	tay
	lda #$A8
	jsr SpawnEnemy
	;Set enemy X position
	lda Enemy_X,y
	sec
	sbc #$50
	sta Enemy_X,y
	;Set enemy flags
	lda #(EF_ACTIVE|EF_HITENEMY|EF_VISIBLE)
	sta Enemy_Flags,y
	;Set enemy X velocity
	lda #$04
	sta Enemy_XVelHi,y
	;Set enemy Y velocity/acceleration
	lda #$F8
	sta Enemy_YVelHi,y
	lda #$66
	sta Enemy_YAccel,y
	;Set not spawner flag
	lda #$01
	sta Enemy_Temp2,y
	;Set enemy ID to BG fire arch section
	lda #ENEMY_BGFIREARCH
	sta Enemy_ID,y
	;Set enemy collision size
	lda #$0E
	sta Enemy_CollWidth,y
	sta Enemy_CollHeight,y
Enemy2B_Exit:
	rts

;$2C: BG fire snake
Enemy2C:
	;Check if enemy Y position < $D0
	lda Enemy_Y,x
	cmp #$D0
	bcs Enemy2C_Sub0_Exit
	;Do jump table
	lda Enemy_Temp0,x
	jsr DoJumpTable
Enemy2CJumpTable:
	.dw Enemy2C_Sub0	;$00  Init
	.dw Enemy2C_Sub1	;$01  Left
	.dw Enemy2C_Sub2	;$02  Right
	.dw Enemy2C_Sub3	;$03  Down
;$00: Init
Enemy2C_Sub0:
	;Set path data index based on parameter value
	ldy Enemy_Temp1,x
	lda BGFireSnakeOffsetData,y
	tay
	;Get path data scroll Y position
	lda BGFireSnakePathData,y
	sta $00
	clc
	adc #$08
	sta $01
	;If scroll Y position in range, start path
	lda TempMirror_PPUSCROLL_Y
	cmp $00
	bcc Enemy2C_Sub0_Exit
	cmp $01
	bcs Enemy2C_Sub0_Exit
	;Save Y register
	sty $17
	;Play sound
	ldy #SE_BGFIRESNAKE
	jsr LoadSound
	;Restore Y register
	ldy $17
	;Get initial VRAM address
	iny
	lda BGFireSnakePathData,y
	sta Enemy_Temp2,x
	iny
	lda BGFireSnakePathData,y
	sta Enemy_Temp3,x
	iny
Enemy2C_Sub0_Next:
	;Get path segment direction
	lda BGFireSnakePathData,y
	sta Enemy_Temp0,x
	;If no more segments left, clear enemy flags
	beq Enemy2C_Sub0_ClearF
	iny
	;Get path segment length
	lda BGFireSnakePathData,y
	sta Enemy_Temp1,x
	iny
	;Save path data index
	tya
	sta Enemy_Temp4,x
Enemy2C_Sub0_Exit:
	rts
Enemy2C_Sub0_ClearF:
	;Clear enemy flags
	lda #$00
	sta Enemy_Flags,x
	rts
;$01: Left
Enemy2C_Sub1:
	;Decrement animation frame counter, check if 0
	dec Enemy_Temp1,x
	beq Enemy2C_Sub1_End
	;Check for half tile
	lda Enemy_Temp1,x
	lsr
	bcs Enemy2C_Sub0_Exit
	and #$01
	bne Enemy2C_Sub1_NoHalf
	;Draw half tile
	lda #$C2
	sta $02
	lda #$00
	sta $03
	lda #$01
	jmp BGFireSnakeDrawTiles
Enemy2C_Sub1_NoHalf:
	;Decrement VRAM address
	dec Enemy_Temp3,x
	;Draw whole tile
	lda #$C1
	sta $02
	jsr BGFireSnakeGetTileOffs
	adc #$B9
	sta $03
	lda #$01
	jmp BGFireSnakeDrawTiles
Enemy2C_Sub1_End:
	;Get next path segment direction
	ldy Enemy_Temp4,x
	jsr Enemy2C_Sub0_Next
	;Check for end of path data
	lda Enemy_Flags,x
	beq Enemy2C_Sub2_Exit
	;Draw top left corner
	lda #$BD
	sta $02
	lda #$B7
	sta $03
	lda #$02
	jmp BGFireSnakeDrawTiles
BGFireSnakeGetTileOffs:
	;Get tile number offset
	lda Enemy_Temp1,x
	and #$04
	lsr
	lsr
	rts
;$02: Right
Enemy2C_Sub2:
	;Decrement animation frame counter, check if 0
	dec Enemy_Temp1,x
	beq Enemy2C_Sub2_End
	;Check for half tile
	lda Enemy_Temp1,x
	lsr
	bcs Enemy2C_Sub0_Exit
	and #$01
	bne Enemy2C_Sub2_NoHalf
	;Draw half tile
	lda #$C4
	sta $02
	lda #$00
	sta $03
	lda #$01
	jmp BGFireSnakeDrawTiles
Enemy2C_Sub2_NoHalf:
	;Draw whole tile
	jsr BGFireSnakeGetTileOffs
	adc #$B9
	sta $02
	lda #$C3
	sta $03
	lda #$01
	jsr BGFireSnakeDrawTiles
	;Increment VRAM address
	inc Enemy_Temp3,x
Enemy2C_Sub2_Exit:
	rts
Enemy2C_Sub2_End:
	;Get next path segment direction
	ldy Enemy_Temp4,x
	jsr Enemy2C_Sub0_Next
	;Check for end of path data
	lda Enemy_Flags,x
	beq Enemy2C_Sub2_Exit
	;Draw top right corner
	lda #$BE
	sta $02
	lda #$B7
	sta $03
	lda #$02
	jmp BGFireSnakeDrawTiles
;$03: Down
Enemy2C_Sub3:
	;Increment Y position
	lda Enemy_Y,x
	clc
	adc #$04
	sta Enemy_Y,x
	;Decrement animation frame counter, check if 0
	dec Enemy_Temp1,x
	beq Enemy2C_Sub3_End
	;Check for half tile
	lda Enemy_Temp1,x
	and #$01
	beq Enemy2C_Sub3_NoHalf
	;Increment VRAM address
	lda Enemy_Temp3,x
	clc
	adc #$20
	sta Enemy_Temp3,x
	bcc Enemy2C_Sub3_HalfVRAMC
	inc Enemy_Temp2,x
Enemy2C_Sub3_HalfVRAMC:
	;Wrap vertically
	cmp #$C0
	bcc Enemy2C_Sub3_HalfVRAMC2
	lda Enemy_Temp2,x
	cmp #$27
	bne Enemy2C_Sub3_HalfVRAMC2
	lda #$24
	sta Enemy_Temp2,x
	lda Enemy_Temp3,x
	clc
	adc #$40
	sta Enemy_Temp3,x
Enemy2C_Sub3_HalfVRAMC2:
	;Draw half tile
	lda #$B7
	sta $02
	lda #$00
	sta $03
	lda #$02
	jmp BGFireSnakeDrawTiles
Enemy2C_Sub3_NoHalf:
	;Wrap vertically
	lda Enemy_Temp2,x
	cmp #$27
	bne Enemy2C_Sub3_NoHalfVRAMC
	lda Enemy_Temp3,x
	and #$E0
	cmp #$A0
	bne Enemy2C_Sub3_NoHalfVRAMC
	;Draw whole tile
	lda #$B8
	sta $02
	lda #$00
	sta $03
	lda #$01
	bne BGFireSnakeDrawTiles
Enemy2C_Sub3_NoHalfVRAMC:
	;Draw whole tile
	jsr BGFireSnakeGetTileOffs
	adc #$BB
	sta $02
	lda #$B8
	sta $03
	lda #$02
	bne BGFireSnakeDrawTiles
Enemy2C_Sub3_End:
	;Get next path segment direction
	ldy Enemy_Temp4,x
	lda BGFireSnakePathData,y
	;Check for next direction left
	cmp #$01
	beq Enemy2C_Sub3_EndL
	;Draw bottom left tile
	lda #$C0
	sta $02
	lda #$B5
	sta $03
	lda #$01
	jsr BGFireSnakeDrawTiles
	;Increment VRAM address
	inc Enemy_Temp3,x
	;Get next path segment direction
	ldy Enemy_Temp4,x
	jmp Enemy2C_Sub0_Next
Enemy2C_Sub3_EndL:
	;Decrement VRAM address
	dec Enemy_Temp3,x
	;Draw bottom right tile
	lda #$B3
	sta $02
	lda #$BF
	sta $03
	lda #$01
	jsr BGFireSnakeDrawTiles
	;Get next path segment direction
	ldy Enemy_Temp4,x
	jmp Enemy2C_Sub0_Next
BGFireSnakeDrawTiles:
	;Save A register
	sta $04
	;Save VRAM address
	ldy Enemy_Temp2,x
	lda Enemy_Temp3,x
	sta $01
	;Save X register
	stx $10
	;Init VRAM buffer row/column
	ldx VRAMBufferOffset
	lda $04
	sta VRAMBuffer,x
	inx
	;Set VRAM buffer address
	lda $01
	jsr WriteVRAMBufferCmd_Addr
	;Set tile in VRAM
	lda $02
	sta VRAMBuffer,x
	inx
	;Increment number of tiles drawn (unused?)
	lda #$01
	sta $00
	;Check for second tile
	lda $03
	beq BGFireSnakeDrawTiles_NoTile2
	;Set tile in VRAM
	sta VRAMBuffer,x
	inx
	;Increment number of tiles drawn (unused?)
	inc $00
BGFireSnakeDrawTiles_NoTile2:
	;End VRAM buffer
	jsr WriteVRAMBufferCmd_End
	;Draw collision tile row
	lda #$03
	sta $02
	jsr DrawCollisionTileRow
	;Restore X register
	ldx $10
	rts
BGFireSnakeOffsetData:
	.db $00,$1E,$30,$46,$54,$6A,$84,$90,$AA,$BC,$CA,$DC,$EA
BGFireSnakePathData:
	;$00
	.db $80,$27,$7F
	.db $01,$10,$03,$18,$01,$0C,$03,$08,$01,$0C,$03,$08,$01,$0C,$03,$08
	.db $01,$0C,$03,$18,$01,$0C,$03,$10,$01,$1C
	.db $00
	;$1E
	.db $60,$27,$60
	.db $02,$10,$03,$1C,$02,$2C,$03,$08,$02,$0C,$03,$10,$02,$30
	.db $00
	;$30
	.db $C0,$24,$7F
	.db $01,$10,$03,$08,$01,$0C,$03,$20,$01,$0C,$03,$14,$01,$1C,$03,$10
	.db $01,$28
	.db $00
	;$46
	.db $40,$26,$60
	.db $02,$10,$03,$08,$02,$1C,$03,$14,$02,$4C
	.db $00
	;$54
	.db $90,$24,$60
	.db $02,$10,$03,$10,$02,$1C,$03,$08,$02,$0C,$03,$08,$02,$0C,$03,$10
	.db $02,$2C
	.db $00
	;$6A
	.db $30,$26,$7F
	.db $01,$10,$03,$10,$01,$1C,$03,$08,$01,$0C,$03,$08,$01,$0C,$03,$08
	.db $01,$1C,$03,$14,$01,$08
	.db $00
	;$84
	.db $00,$24,$E0
	.db $03,$18,$02,$5C,$03,$10,$02,$1C
	.db $00
	;$90
	.db $40,$26,$7F
	.db $01,$10,$03,$10,$01,$1C,$03,$14,$01,$0C,$03,$08,$01,$0C,$03,$18
	.db $01,$0C,$03,$10,$01,$18
	.db $00
	;$AA
	.db $D0,$25,$FF
	.db $01,$10,$03,$08,$01,$2C,$03,$08,$01,$1C,$03,$10,$01,$18
	.db $00
	;$BC
	.db $20,$26,$20
	.db $02,$10,$03,$1C,$02,$1C,$03,$18,$02,$4C
	.db $00
	;$CA
	.db $C0,$24,$BF
	.db $01,$10,$03,$10,$01,$3C,$03,$18,$01,$1C,$03,$04,$01,$08
	.db $00
	;$DC
	.db $E0,$25,$60
	.db $02,$10,$03,$1C,$02,$2C,$03,$18,$02,$38
	.db $00
	;$EA
	.db $00,$25,$E0
	.db $02,$10,$03,$08,$02,$6C
	.db $00

;$2D: Boulder rolling spawner
Enemy2D:
	;If free slot not available, exit early
	lda Enemy_Flags+$07
	bne Enemy2D_Exit
	;If enemy X position $30-$CF, spawn boulder
	lda Enemy_X,x
	cmp #$30
	bcc Enemy2D_Exit
	cmp #$D0
	bcs Enemy2D_Exit
	;Spawn enemy
	lda #$00
	sta $00
	sta $01
	ldy #$07
	lda #$E0
	jsr SpawnEnemy
	;Set enemy ID to boulder rolling
	lda #ENEMY_BOULDERROLL
	sta Enemy_ID+$07
	;Set enemy parameter value to roll left
	lda #$00
	sta Enemy_Temp1+$07
Enemy2D_Exit:
	rts

;$2E: Trooper rolling
Enemy2E:
	;Check if turnaround timer 0
	lda Enemy_Temp4,x
	beq Enemy2E_Init
	;Decrement turnaround timer
	dec Enemy_Temp4,x
Enemy2E_Init:
	;If enemy Y position >= $B8, clear enemy flags
	lda Enemy_Y,x
	cmp #$B8
	bcs Enemy2E_ClearF
	;Check if already inited
	lda Enemy_Temp0,x
	bne Enemy2E_Main
	;Set enemy flags
	lda #(EF_ACTIVE|EF_HITBULLET|EF_HITENEMY|EF_VISIBLE)
	sta Enemy_Flags,x
	;Mark inited
	inc Enemy_Temp0,x
	;Set enemy X velocity based on if on left or right side of screen
	lda Enemy_X,x
	bmi Enemy2E_Left
	bpl Enemy2E_Right
Enemy2E_Main:
	;Check to change enemy ID
	jsr Enemy2E_Change
	;Check for screen edge collision
	jmp Enemy2E_HitEdge
Enemy2E_Change:
	;Check if enemy Y position - $02 = player Y position (to account for height difference)
	lda Enemy_Y,x
	sec
	sbc #$02
	cmp Enemy_Y
	bne Enemy2E_Exit
	;Check if enemy X position - player X position $30-$4F or $B0-$CF
	lda Enemy_X,x
	sec
	sbc Enemy_X
	cmp #$30
	bcc Enemy2E_Exit
	cmp #$50
	bcc Enemy2E_ChangeLeft
	cmp #$B0
	bcc Enemy2E_Exit
	cmp #$D0
	bcs Enemy2E_Exit
	;Check if enemy is facing right
	lda Enemy_Props,x
	bne Enemy2E_Exit
	;Set enemy X velocity right
	lda #$01
	bne Enemy2E_ChangeSetX
Enemy2E_ChangeLeft:
	;Check if enemy is facing left
	lda Enemy_Props,x
	beq Enemy2E_Exit
	;Set enemy X velocity left
	lda #$FF
Enemy2E_ChangeSetX:
	sta Enemy_XVelHi,x
	;Init shooting timer
	lda #$08
	sta Enemy_Temp2,x
	;Set enemy ID to trooper 2
	lda #ENEMY_TROOPER2
	sta Enemy_ID,x
	;Set enemy animation
	ldy #$0A
	jmp SetEnemyAnimation
Enemy2E_HitEdge:
	;Check if enemy X position $10-$F7
	lda Enemy_X,x
	cmp #$10
	bcc Enemy2E_Right
	cmp #$F8
	bcs Enemy2E_Left
Enemy2E_Exit:
	rts
Enemy2E_ClearF:
	;Clear enemy flags
	lda #$00
	sta Enemy_Flags,x
	rts
Enemy2E_Right:
	;Check for enemy X velocity right
	lda Enemy_XVelHi,x
	cmp #$02
	beq Enemy2E_Exit
	;Set enemy X velocity right
	lda #$02
	sta Enemy_XVelHi,x
	;Don't flip enemy X
	lda #$00
	beq Enemy2E_SetP
Enemy2E_Left:
	;Check for enemy X velocity left
	lda Enemy_XVelHi,x
	cmp #$FE
	beq Enemy2E_Exit
	;Set enemy X velocity left
	lda #$FE
	sta Enemy_XVelHi,x
	;Flip enemy X
	lda #$40
Enemy2E_SetP:
	sta Enemy_Props,x
	;If turnaround timer not 0, clear enemy flags
	lda Enemy_Temp4,x
	bne Enemy2E_ClearF
	;Reset turnaround timer
	lda #$04
	sta Enemy_Temp4,x
	rts

;$2F: Boulder pushable
Enemy2F:
	;Check if already inited
	lda Enemy_Temp0,x
	bne Enemy2F_Main
	;Set enemy flags
	lda #(EF_ACTIVE|EF_NOANIM|EF_PLATFORM|EF_HITENEMY|EF_VISIBLE)
	sta Enemy_Flags,x
	;Mark inited
	inc Enemy_Temp0,x
Enemy2F_Exit:
	rts
Enemy2F_Main:
	;Check if visible
	lda Enemy_Flags,x
	and #EF_VISIBLE
	bne Enemy2F_Exit
	;Reset enemy Y position
	lda #$80
	sta Enemy_Y,x
	;Check if enemy X position $70-$8F
	lda Enemy_X,x
	cmp #$70
	bcc Enemy2F_Exit
	cmp #$90
	bcs Enemy2F_Exit
	;Clear enemy flags
	lda #$00
	sta Enemy_Flags,x
	rts

;$30: Green ball dot
Enemy30:
	;Check for grabbed flag
	lda Enemy_Temp3,x
	bne Enemy2F_Exit
	;Set rotation direction based on IRQ scroll buffer
	lda IRQBufferPlatformXVel
	beq Enemy30_NoRot
	bmi Enemy30_Left
	;Rotate right
	dec Enemy_Temp2,x
	dec Enemy_Temp2,x
	jmp Enemy30_NoRot
Enemy30_Left:
	;Rotate left
	inc Enemy_Temp2,x
	inc Enemy_Temp2,x
Enemy30_NoRot:
	;Get dot angle based on parameter value
	ldy Enemy_Temp1,x
	lda GreenBallDotAngleTable,y
	clc
	adc Enemy_Temp2,x
	sta $08
	;Calculate sine
	jsr CalcSin
	;Scale result
	lsr
	lsr
	lsr
	sta $00
	lsr
	sta $01
	;Get dot radius based on parameter value
	lda Enemy_Temp1,x
	lsr
	lsr
	tay
	lda $00,y
	;Check for quadrant 3/4
	ldy $08
	bmi Enemy30_PosY
	;Negate result
	eor #$FF
	clc
	adc #$01
Enemy30_PosY:
	;Set enemy Y position
	clc
	adc #$68
	sta Enemy_Y,x
	;Calculate cosine
	lda $08
	jsr CalcCos
	;Scale result
	lsr
	lsr
	lsr
	sta $00
	lsr
	sta $01
	;Get dot radius based on parameter value
	lda Enemy_Temp1,x
	lsr
	lsr
	tay
	lda $00,y
	;Check for quadrant 2
	ldy $08
	cpy #$40
	bcc Enemy30_PosX
	;Check for quadrant 3
	cpy #$C0
	bcs Enemy30_PosX
	;Negate result
	eor #$FF
	clc
	adc #$01
Enemy30_PosX:
	;Set enemy X position
	clc
	adc #$C8
	sec
	sbc TempIRQBufferScrollX
	sta Enemy_X,x
	bcc Enemy30_NoXC
	;Check if using left nametable
	lda TempIRQBufferScrollHi
	cmp #$20
	beq Enemy30_Show
	bne Enemy30_Hide
Enemy30_NoXC:
	;Check if using left nametable
	lda TempIRQBufferScrollHi
	cmp #$20
	beq Enemy30_Hide
Enemy30_Show:
	;Set enemy visible flag
	lda #(EF_ACTIVE|EF_NOANIM|EF_PRIORITY|EF_VISIBLE)
	bne Enemy30_SetF
Enemy30_Hide:
	;Clear enemy visible flag
	lda #(EF_ACTIVE|EF_NOANIM|EF_PRIORITY)
Enemy30_SetF:
	sta Enemy_Flags,x
	rts
GreenBallDotAngleTable:
	.db $FA,$10,$C0,$89,$E0

;$32: Level 2 boss dot
Enemy32:
	;Set enemy Y acceleration
	jsr Level2BossDotSetYAccel
	;Check if enemy X position $0C-$F3
	lda Enemy_X+$03
	cmp #$0C
	bcc Enemy32_Right
	cmp #$F4
	bcc Level2BossDotSetYAccel_Exit
	;Set enemy X velocity left
	lda #$FD
	sta Enemy_XVelHi+$03
	rts
Enemy32_Right:
	;Check level 2 boss for mode $0B/$0C (roll left/roll right)
	lda Enemy_Temp0+$01
	cmp #$0B
	bcs Enemy32_Change
	;Set enemy X velocity right
	lda #$03
	sta Enemy_XVelHi+$03
	rts
Enemy32_Change:
	;Clear grabbed flag
	lda #$00
	sta Enemy_Temp3+$03
	;Set enemy ID to green ball dot
	lda #ENEMY_GREENBALLDOT
	sta Enemy_ID+$03
	rts
Level2BossDotSetYAccel:
	;If enemy Y position >= $84, set enemy Y position/velocity/acceleration
	lda Enemy_Y+$03
	cmp #$84
	bcc Level2BossDotSetYAccel_Exit
	;Set enemy Y position
	lda #$84
	sta Enemy_Y+$03
	;Set enemy Y velocity/acceleration
	lda #$FA
	sta Enemy_YVelHi+$03
	lda #$00
	sta Enemy_YVelLo+$03
	lda #$28
	sta Enemy_YAccel+$03
Level2BossDotSetYAccel_Exit:
	rts

;$31: Level 2 boss
Enemy31:
	;Set scroll/enemy X position
	lda #$C8
	sec
	sbc TempIRQBufferScrollX
	sta Enemy_X+$06
	bcc Enemy31_NoXC
	;Check if using left nametable
	lda TempIRQBufferScrollHi
	cmp #$20
	beq Enemy31_Show
	bne Enemy31_Hide
Enemy31_NoXC:
	;Check if using left nametable
	lda TempIRQBufferScrollHi
	cmp #$20
	beq Enemy31_Hide
Enemy31_Show:
	;Set enemy visible flag
	lda #(EF_ACTIVE|EF_INVINCIBLE|EF_HITBULLET|EF_VISIBLE)
	bne Enemy31_SetF
Enemy31_Hide:
	;Clear enemy visible flag
	lda #(EF_ACTIVE|EF_INVINCIBLE|EF_HITBULLET)
Enemy31_SetF:
	sta Enemy_Flags+$06
	;Do jump table
	lda Enemy_Temp0+$01
	jsr DoJumpTable
Enemy31JumpTable:
	.dw Enemy31_Sub0	;$00  Init
	.dw Enemy31_Sub1	;$01  Roll in
	.dw Enemy31_Sub2	;$02  Blink
	.dw Enemy31_Sub3	;$03  Grow arms/legs
	.dw Enemy31_Sub4	;$04  Wait
	.dw Enemy31_Sub5	;$05  Open
	.dw Enemy31_Sub6	;$06  Throw dot
	.dw Enemy31_Sub7	;$07  Shoot laser
	.dw Enemy31_Sub8	;$08  Trooper shoot
	.dw Enemy31_Sub9	;$09  Close
	.dw Enemy31_SubA	;$0A  Shrink arms/legs
	.dw Enemy31_SubB	;$0B  Roll left
	.dw Enemy31_SubC	;$0C  Roll right
;$00: Init
Enemy31_Sub0:
	;Set ball collision
	jsr Level2BossSetBallCollision
	;Set scroll X position
	lda #$A8
	sta TempMirror_PPUCTRL
	;Set enemy props
	lda #$60
	sta Enemy_Props+$01
	;Set IRQ buffer scroll speed
	lda #$FF
	sta IRQBufferPlatformXVel
	;Set boss enemy slot index
	lda #$01
	sta BossEnemyIndex
	;Next task ($01: Roll in)
	inc Enemy_Temp0+$01
	rts
Level2BossSetBallCollision:
	;Spawn enemy
	lda #$00
	sta $00
	sta $01
	ldy #$06
	lda #$A8
	jsr SpawnEnemy
	;Set enemy flags
	lda #(EF_ACTIVE|EF_INVINCIBLE|EF_HITBULLET)
	sta Enemy_Flags+$06
	;Set enemy Y position
	lda #$68
	sta Enemy_Y+$06
	;Set enemy collision size
	lda #$28
	sta Enemy_CollHeight+$06
	lda #$28
	sta Enemy_CollWidth+$06
Level2BossSetBallCollision_Exit:
	rts
Level2BossPlaySound:
	;Play sound
	ldy #SE_BALLROLL
	jmp LoadSound
;$01: Roll in
Enemy31_Sub1:
	;Move ball left $01
	inc TempIRQBufferScrollX
	inc TempIRQBufferScrollX+1
	;If scroll X position $80, play sound
	lda TempIRQBufferScrollX+1
	cmp #$80
	beq Level2BossPlaySound
	;If scroll X position not $FF, exit early
	cmp #$FF
	bne Level2BossSetBallCollision_Exit
	;Set IRQ buffer scroll speed
	lda #$00
	sta IRQBufferPlatformXVel
	;Spawn enemy
	lda #$08
	sta $00
	lda #$F7
	sta $01
	ldy #$05
	lda #$D6
	jsr SpawnEnemy
	;Set enemy ID to level 2 boss eyes
	lda #ENEMY_L2BSEYESBGGRPIPE
	sta Enemy_ID+$05
	;Mark inited
	lda #$01
	sta Enemy_Temp0+$05
	;Init animation timer
	lda #$40
	sta Enemy_Temp2+$01
	;Next task ($02: Blink)
	inc Enemy_Temp0+$01
	rts
;$02: Blink
Enemy31_Sub2:
	;Decrement animation timer, check if 0
	dec Enemy_Temp2+$01
	bne Level2BossSetBallCollision_Exit
	;Spawn enemy
	lda #$0A
	sta $00
	lda #$20
	sta $01
	ldy #$06
	lda #$DE
	jsr SpawnEnemy
	;Spawn enemy
	lda #$E6
	sta $00
	lda #$FE
	sta $01
	ldy #$0A
	lda #$29
	jsr SpawnEnemy
	;Spawn enemy
	lda #$28
	sta $00
	lda #$FE
	sta $01
	ldy #$07
	lda #$27
	jsr SpawnEnemy
	;Set enemy props
	lda #$20
	sta Enemy_Props+$06
	sta Enemy_Props+$0A
	sta Enemy_Props+$07
	;Next task ($03: Grow arms/legs)
	inc Enemy_Temp0+$01
	rts
;$03: Grow arms/legs
Enemy31_Sub3:
	;Increment animation timer
	inc Enemy_Temp2+$01
	;If bits 0-2 of animation timer 0, set enemy position to grow arms/legs
	lda Enemy_Temp2+$01
	and #$07
	bne Enemy31_Sub3_Exit
	;Set enemy position
	dec Enemy_X+$0A
	inc Enemy_X+$07
	inc Enemy_Y+$06
	;Check if legs are fully extended
	lda Enemy_Y+$06
	cmp #$88
	bne Enemy31_Sub3_Exit
	;Reset animation timer
	lda #$20
	sta Enemy_Temp2+$01
	;Next task ($04: Wait)
	inc Enemy_Temp0+$01
Enemy31_Sub3_Exit:
	rts
;$04: Wait
Enemy31_Sub4:
	;Decrement animation timer, check if 0
	dec Enemy_Temp2+$01
	bne Enemy31_Sub3_Exit
	;Set enemy flags
	lda #(EF_ACTIVE|EF_NOANIM|EF_HITBULLET|EF_HITENEMY|EF_VISIBLE)
	sta Enemy_Flags+$01
	;Set grabbed flag
	sta Enemy_Temp3+$03
	;Save X register
	stx $17
	;Load IRQ buffer set
	ldx #$0E
	jsr LoadIRQBufferSet
	;Restore X register
	ldx $17
	;Set scroll Y position
	lda #$05
	sta TempMirror_PPUSCROLL_Y
	;Set enemy Y position
	lda #$53
	sta Enemy_Y+$05
	;Next task ($05: Open)
	inc Enemy_Temp0+$01
	;Play sound
	ldy #SE_WHIRLONG
	jmp LoadSound
;$05: Open
Enemy31_Sub5:
	;Increment animation timer
	inc Enemy_Temp2+$01
	;If bits 0-1 of animation timer 0, open ball
	lda Enemy_Temp2+$01
	and #$03
	bne Enemy31_Sub3_Exit
	;Set enemy Y position
	dec Enemy_Y+$03
	dec Enemy_Y+$05
	dec Enemy_Y+$0A
	dec Enemy_Y+$07
	;Open ball $01
	inc TempMirror_PPUSCROLL_Y
	dec TempIRQBufferHeight
	inc TempIRQBufferHeight+1
	;Check if ball is fully opened
	lda TempIRQBufferHeight+1
	cmp #$0F
	bne Enemy31_Sub3_Exit
	;Set enemy priority to be in front of background
	lda #$00
	sta Enemy_Props+$0A
	sta Enemy_Props+$07
	;Set enemy animation
	ldx #$07
	ldy #$2B
	jsr SetEnemyAnimation
	;Reset animation timer
	lda #$68
	sta Enemy_Temp2+$01
	;Init repeat counter
	lda #$05
	sta Enemy_Temp3+$01
	;Restore X register
	ldx #$01
	;Next task ($06: Throw dot)
	inc Enemy_Temp0+$01
	rts
;$06: Throw dot
Enemy31_Sub6:
	;Set enemy animation timer
	lda #$FE
	sta Enemy_AnimTimer+$06
	sta Enemy_AnimTimer+$0A
	;Decrement animation timer, check if 0
	dec Enemy_Temp2+$01
	beq Enemy31_Sub6_Next
	;If animation timer $1C, throw dot
	lda Enemy_Temp2+$01
	cmp #$1C
	beq Enemy31_Sub6_Throw
	;If animation timer $60, hide green ball dot
	cmp #$60
	bne Enemy31_Sub6_Exit
	;Clear enemy visible flag
	lda #EF_ACTIVE
	sta Enemy_Flags+$03
	rts
Enemy31_Sub6_Throw:
	;Check if dot already thrown
	lda Enemy_Flags+$03
	cmp #(EF_ACTIVE|EF_HITENEMY|EF_VISIBLE)
	beq Enemy31_Sub6_Exit
	;Set enemy flags
	lda #(EF_ACTIVE|EF_HITENEMY|EF_VISIBLE)
	sta Enemy_Flags+$03
	;Set enemy velocity
	lda #$F8
	sta Enemy_XVelHi+$03
	lda #$08
	sta Enemy_YVelHi+$03
	;Set enemy ID to level 2 boss dot
	lda #ENEMY_LEVEL2BOSSDOT
	sta Enemy_ID+$03
	rts
Enemy31_Sub6_Next:
	;Set enemy animation
	ldx #$0A
	ldy #$2D
	jsr SetEnemyAnimation
	;Reset animation timer
	lda #$28
	sta Enemy_Temp2+$01
	;Restore X register
	ldx #$01
	;Next task ($07: Shoot laser)
	inc Enemy_Temp0+$01
Enemy31_Sub6_Exit:
	rts
;$07: Shoot laser
Enemy31_Sub7:
	;Set enemy animation timer
	lda #$FE
	sta Enemy_AnimTimer+$06
	sta Enemy_AnimTimer+$07
	;Decrement animation timer, check if 0
	dec Enemy_Temp2+$01
	beq Enemy31_Sub7_Next
	;If animation timer $18, shoot laser
	lda Enemy_Temp2+$01
	cmp #$18
	bne Enemy31_Sub6_Exit
	;Spawn enemy
	ldy #$0B
	lda #$C8
	sta $00
	lda #$F4
	sta $01
Enemy31_Sub7_Shoot:
	lda #$2F
	jsr SpawnEnemy
	;Set enemy velocity
	lda #$FE
	sta Enemy_XVelHi,y
	lda #$01
	sta Enemy_YVelHi,y
	;Play sound
	ldy #SE_SHOOTLASER
	jmp LoadSound
Enemy31_Sub7_Next:
	;Reset animation timer
	lda #$20
	sta Enemy_Temp2+$01
	;Next task ($08: Trooper shoot)
	inc Enemy_Temp0+$01
	rts
;$08: Trooper shoot
Enemy31_Sub8:
	;Decrement animation timer, check if 0
	dec Enemy_Temp2+$01
	beq Enemy31_Sub8_Next
	;If animation timer $10, shoot laser
	lda Enemy_Temp2+$01
	cmp #$10
	bne Enemy31_Sub6_Exit
	;Spawn enemy
	ldy #$0C
	lda #$F8
	sta $00
	lda #$08
	sta $01
	bne Enemy31_Sub7_Shoot
Enemy31_Sub8_Next:
	;Decrement loop counter, check if 0
	dec Enemy_Temp3+$01
	beq Enemy31_Sub8_EndL
	;Reset animation timer
	lda #$28
	sta Enemy_Temp2+$01
	;Next task ($06: Throw dot)
	lda #$06
	sta Enemy_Temp0+$01
	rts
Enemy31_Sub8_EndL:
	;Reset animation timer
	lda #$00
	sta Enemy_Temp2+$01
	;Next task ($09: Close)
	inc Enemy_Temp0+$01
	;Play sound
	ldy #SE_WHIRLONG
	jmp LoadSound
;$09: Close
Enemy31_Sub9:
	;Increment animation timer
	inc Enemy_Temp2+$01
	;If bits 0-2 of animation timer 0, open ball
	lda Enemy_Temp2+$01
	and #$03
	bne Enemy31_Sub9_Exit
	;Set enemy animation timer
	lda #$FE
	sta Enemy_AnimTimer+$06
	sta Enemy_AnimTimer+$07
	sta Enemy_AnimTimer+$0A
	;Set enemy Y position
	inc Enemy_Y+$07
	inc Enemy_Y+$0A
	inc Enemy_Y+$05
	;Close ball $01
	dec TempMirror_PPUSCROLL_Y
	inc TempIRQBufferHeight
	dec TempIRQBufferHeight+1
	;Check if ball fully closed
	lda TempIRQBufferHeight+1
	cmp #$00
	bne Enemy31_Sub9_Exit
	;Reset IRQ buffer
	lda #$1E
	sta TempIRQBufferHeight
	lda #$10
	sta TempIRQBufferHeight+1
	lda #$5F
	sta TempIRQBufferHeight+2
	lda #$00
	sta TempIRQBufferScrollY
	;Reset animation timer
	sta Enemy_Temp2+$01
	lda #$30
	sta TempIRQBufferScrollY+1
	lda #$90
	sta TempIRQBufferScrollY+2
	;Set enemy priority to be behind background
	lda #$20
	sta Enemy_Props+$0A
	sta Enemy_Props+$07
	;Set enemy Y position
	lda #$58
	sta Enemy_Y+$05
	;Next task ($0A: Shrink arms/legs)
	inc Enemy_Temp0+$01
Enemy31_Sub9_Exit:
	rts
;$0A: Shrink arms/legs
Enemy31_SubA:
	;Set enemy flags
	lda #(EF_ACTIVE|EF_NOANIM|EF_HITBULLET|EF_HITENEMY)
	sta Enemy_Flags+$01
	;Increment animation timer
	inc Enemy_Temp2+$01
	;If bits 0-2 of animation timer 0, set enemy position to shrink arms/legs
	lda Enemy_Temp2+$01
	and #$07
	bne Enemy31_Sub9_Exit
	;Set enemy animation timer
	lda #$FE
	sta Enemy_AnimTimer+$06
	sta Enemy_AnimTimer+$07
	sta Enemy_AnimTimer+$0A
	;Set enemy position
	inc Enemy_X+$0A
	dec Enemy_X+$07
	dec Enemy_Y+$06
	;Check if legs are fully retracted
	lda Enemy_Y+$06
	cmp #$6C
	bne Enemy31_Sub9_Exit
	;Clear enemy flags
	lda #$00
	sta Enemy_Flags+$07
	sta Enemy_Flags+$05
	sta Enemy_Flags+$06
	sta Enemy_Flags+$0A
	;Set scroll X position
	sta TempIRQBufferScrollX
	sta TempIRQBufferScrollX+1
	lda #$20
	sta TempIRQBufferScrollHi
	sta TempIRQBufferScrollHi+1
	;Set IRQ buffer scroll speed
	lda #$FE
	sta IRQBufferPlatformXVel
	;Next task ($0B: Roll left)
	inc Enemy_Temp0+$01
	;Set ball collision
	jsr Level2BossSetBallCollision
	;Play sound
	jmp Level2BossPlaySound
;$0B: Roll left
Enemy31_SubB:
	;Move ball left $02
	inc TempIRQBufferScrollX
	inc TempIRQBufferScrollX
	inc TempIRQBufferScrollX+1
	inc TempIRQBufferScrollX+1
	;Check if ball is off left side of screen
	lda TempIRQBufferScrollX+1
	cmp #$FE
	bne Enemy31_SubC_Exit
	;Set IRQ buffer scroll speed
	lda #$02
	sta IRQBufferPlatformXVel
	;Next task ($0C: Roll right)
	inc Enemy_Temp0+$01
	;Play sound
	jmp Level2BossPlaySound
;$0C: Roll right
Enemy31_SubC:
	;Move ball right $02
	dec TempIRQBufferScrollX
	dec TempIRQBufferScrollX
	dec TempIRQBufferScrollX+1
	dec TempIRQBufferScrollX+1
	;Check if ball is off right side of screen
	lda TempIRQBufferScrollX+1
	cmp #$FE
	bne Enemy31_SubC_Exit
	;Check if using right nametable
	lda TempIRQBufferScrollHi
	cmp #$24
	beq Enemy31_SubC_NoXC
	lda #$24
	sta TempIRQBufferScrollHi
	sta TempIRQBufferScrollHi+1
Enemy31_SubC_Exit:
	rts
Enemy31_SubC_NoXC:
	;Set scroll X position
	lda #$00
	sta TempIRQBufferScrollX
	sta TempIRQBufferScrollX+1
	;Next task ($00: Init)
	sta Enemy_Temp0+$01
	;Reset angle
	sta Enemy_Temp2+$02
	sta Enemy_Temp2+$03
	sta Enemy_Temp2+$04
	sta Enemy_Temp2+$08
	sta Enemy_Temp2+$09
	;Setup next task
	jmp Enemy31_Sub0

;$40: Frozen item/trooper in ice
Enemy40:
	;Check for collision with ice block particles
	ldy #$0E
Enemy40_Loop:
	;Check if ice block is active
	lda Enemy_Flags,y
	beq Enemy40_Next
	;Check for ice block particles animation
	lda Enemy_Anim,y
	cmp #$03
	beq Enemy40_CollCheck
	cmp #$95
	bne Enemy40_Next
Enemy40_CollCheck:
	;Check for collision
	lda Enemy_X,y
	sec
	sbc Enemy_X,x
	clc
	adc #$04
	cmp #$08
	bcs Enemy40_Next
	lda Enemy_Y,y
	sec
	sbc Enemy_Y,x
	clc
	adc #$04
	cmp #$08
	bcs Enemy40_Next
	;If enemy Y velocity not 0, exit early (ensure particles didn't fall from above)
	lda Enemy_YVelHi,y
	ora Enemy_YVelLo,y
	bne Enemy40_Next
	;Save Y register
	sty $17
	;Set enemy ID based on parameter value
	ldy Enemy_Temp1,x
	lda FrozenInIceID,y
	sta Enemy_ID,x
	;Set enemy animation based on parameter value
	lda FrozenInIceAnim,y
	tay
	jsr SetEnemyAnimation
	;Check for trooper
	lda Enemy_ID,x
	cmp #ENEMY_TROOPERINICE
	bne Enemy40_NoTrooper
	;Init animation timer
	lda #$20
	sta Enemy_Temp2,x
	;Set enemy flags
	lda #(EF_ACTIVE|EF_HITENEMY|EF_VISIBLE)
	sta Enemy_Flags,x
Enemy40_NoTrooper:
	;Restore Y register
	ldy $17
Enemy40_Next:
	;Loop for each particle
	iny
	cpy #$10
	bne Enemy40_Loop
	rts
FrozenInIceAnim:
	.db $AE,$B2,$B6,$B6,$B2,$B6,$AE,$B2,$AE,$B2,$0A
FrozenInIceID:
	.db ENEMY_LIFEUP
	.db ENEMY_1UP
	.db ENEMY_BONUSCOIN
	.db ENEMY_BONUSCOIN
	.db ENEMY_1UP
	.db ENEMY_BONUSCOIN
	.db ENEMY_LIFEUP
	.db ENEMY_1UP
	.db ENEMY_LIFEUP
	.db ENEMY_1UP
	.db ENEMY_TROOPERINICE

;$27: Trooper in ice
Enemy27:
	;Check for init mode
	lda Enemy_Temp0,x
	beq Enemy27_Init
	;Check for main mode
	cmp #$01
	beq Enemy27_Main
	rts
Enemy27_Init:
	;Mark inited and set enemy X velocity based on if on left or right side of screen
	jmp Enemy05_Ent07
Enemy27_Main:
	;Decrement animation timer, check if 0
	dec Enemy_Temp2,x
	bne Enemy27_Exit
	;Set enemy flags
	lda #(EF_ACTIVE|EF_HITBULLET|EF_HITENEMY|EF_VISIBLE)
	sta Enemy_Flags,x
	;Next task ($02: Finish)
	inc Enemy_Temp0,x
Enemy27_Exit:
	rts

;$41: Level 2 boss eyes/BG gray pipe
Enemy41:
	;Check if already inited
	lda Enemy_Temp0,x
	bne Enemy41_Exit
	;Set enemy collision size
	lda #$1F
	sta Enemy_CollWidth,x
	lda #$04
	sta Enemy_CollHeight,x
	;Set enemy flags
	lda BGGrayPipeFlags-1,x
	sta Enemy_Flags,x
	;Set enemy Y velocity
	lda #$FE
	sta Enemy_YVelHi,x
	;Mark inited
	inc Enemy_Temp0,x
Enemy41_Exit:
	rts
BGGrayPipeFlags:
	.db EF_ACTIVE|EF_NOANIM|EF_PLATFORM|EF_VISIBLE
	.db EF_ACTIVE|EF_NOANIM|EF_PLATFORM|EF_VISIBLE
	.db EF_ACTIVE|EF_NOANIM|EF_VISIBLE
	.db EF_ACTIVE|EF_NOANIM|EF_VISIBLE

;$33: BG snake
Enemy33:
	;If enemy Y position $90-$AF, set BG snake mask X position
	lda Enemy_Y,x
	cmp #$90
	bcc Enemy33_JT
	cmp #$B0
	bcs Enemy33_JT
	;Set enemy X position
	lda Enemy_X,x
	sta Enemy_X+$0C
Enemy33_JT:
	;Do jump table
	lda Enemy_Temp0,x
	jsr DoJumpTable
Enemy33JumpTable:
	.dw Enemy33_Sub0	;$00  Init
	.dw Enemy33_Sub1	;$01  Wait
	.dw Enemy33_Sub2	;$02  Main
;$00: Init
Enemy33_Sub0:
	;Next task ($01: Wait)
	inc Enemy_Temp0,x
	;Get enemy bit index based on parameter value
	lda Enemy_Temp1,x
	and #$07
	tay
	lda BGEnemyBitTable,y
	sta $00
	lda Enemy_Temp1,x
	lsr
	lsr
	lsr
	tay
	;Check if enemy is already triggered
	lda EnemyTriggeredBits,y
	and $00
	bne Enemy33_Sub2_ClearF
	;Set enemy triggered bit
	lda EnemyTriggeredBits,y
	ora $00
	sta EnemyTriggeredBits,y
	;Init delay timer
	ldy Enemy_Temp1,x
	lda BGSnakeDelayTimer,y
	sta Enemy_Temp3,x
	;Set enemy flags
	lda #(EF_ACTIVE|EF_HITENEMY)
	sta Enemy_Flags,x
	rts
;$01: Wait
Enemy33_Sub1:
	;Decrement delay timer, check if 0
	dec Enemy_Temp3,x
	bne Enemy33_Sub2_Exit
	;Get initial VRAM address based on parameter value
	ldy Enemy_Temp1,x
	lda BGSnakeVRAMAddrHi,y
	sta Enemy_Temp4,x
	lda BGSnakeVRAMAddrLo,y
	sta Enemy_Temp6,x
	;Set path data index based on parameter value
	ldy Enemy_Temp1,x
	lda BGSnakeOffsetData,y
	sta Enemy_Temp2,x
	;Get path segment direction
	tay
	lda BGSnakePathData,y
	sta $17
	jsr BGSnakeSetAnim
	;Set enemy visible flag
	lda Enemy_Flags,x
	eor #EF_VISIBLE
	sta Enemy_Flags,x
	;Reset delay timer
	lda #$10
	sta Enemy_Temp3,x
	;Next task ($02: Main)
	inc Enemy_Temp0,x
	;Play sound
	ldy #SE_BGSNAKE
	jmp LoadSound
;$02: Main
Enemy33_Sub2:
	;Decrement delay timer, check if 0
	dec Enemy_Temp3,x
	beq Enemy33_Sub2_Next
	;If bits 0-2 of delay timer 0, draw partial tiles
	lda Enemy_Temp3,x
	and #$07
	bne Enemy33_Sub2_Exit
	jmp Enemy33_Sub2_Part
Enemy33_Sub2_ClearF:
	;Clear enemy flags
	lda #$00
	sta Enemy_Flags,x
Enemy33_Sub2_Exit:
	rts
Enemy33_Sub2_Next:
	;Increment path data index
	inc Enemy_Temp2,x
	;Get next path segment direction
	ldy Enemy_Temp2,x
	lda BGSnakePathData,y
	;Check for end of path data
	cmp #$FF
	beq Enemy33_Sub2_ClearF
	sta $17
	;Check for corner
	lda BGSnakePathData-1,y
	cmp $17
	beq Enemy33_Sub2_NoCorner
	;Get index based on current and previous path segment direction
	asl
	asl
	clc
	adc $17
	sta $15
	tay
	;Offset VRAM address
	lda BGSnakeCornerVRAMOffs,y
	bpl Enemy33_Sub2_PosOffs
	;Check for $81 offset (left to down, should be positive)
	cmp #$81
	beq Enemy33_Sub2_PosOffs
	dec Enemy_Temp4,x
	bne Enemy33_Sub2_NoSpecialOffs
Enemy33_Sub2_PosOffs:
	;Check for $7F offset (down to left, should be negative)
	cmp #$7F
	bne Enemy33_Sub2_NoSpecialOffs
	dec Enemy_Temp4,x
Enemy33_Sub2_NoSpecialOffs:
	clc
	adc Enemy_Temp6,x
	sta Enemy_Temp6,x
	lda Enemy_Temp4,x
	adc #$00
	sta Enemy_Temp4,x
	;Set enemy X position
	lda Enemy_X,x
	clc
	adc BGSnakeCornerXOffs,y
	sta Enemy_X,x
	;Check if moving left or right
	lda BGSnakeCornerXOffs,y
	bmi Enemy33_Sub2_Left
	;Check if visible on screen (right)
	bcs Enemy33_Sub2_FlipF
	bcc Enemy33_Sub2_NoFlipF
Enemy33_Sub2_Left:
	;Check if visible on screen (left)
	bcs Enemy33_Sub2_NoFlipF
Enemy33_Sub2_FlipF:
	;Toggle enemy visible flag
	lda Enemy_Flags,x
	eor #EF_VISIBLE
	sta Enemy_Flags,x
Enemy33_Sub2_NoFlipF:
	;Set enemy Y position
	lda Enemy_Y,x
	clc
	adc BGSnakeCornerYOffs,y
	sta Enemy_Y,x
	;Set enemy animation
	jsr BGSnakeSetAnim
	;Get corner metatile data index
	ldy Enemy_Temp2,x
	;Save X register
	stx $16
	;Draw corner metatile
	ldx UpdateMetatileCount
	lda BGSnakeMetatilePosData,y
	and #$3F
	sta UpdateMetatilePos,x
	lda BGSnakeMetatilePosData,y
	and #$80
	clc
	rol
	rol
	sta UpdateMetatileProps,x
	ldy $15
	lda BGSnakeCornerMetatileID,y
	sta UpdateMetatileID,x
	inc UpdateMetatileCount
	;Restore X register
	ldx $16
Enemy33_Sub2_NoCorner:
	;Reset delay timer
	lda #$20
	sta Enemy_Temp3,x
Enemy33_Sub2_Part:
	;Save X register
	stx $16
	;Get current path segment direction
	ldy Enemy_Temp2,x
	lda BGSnakePathData,y
	tay
	;Save VRAM address
	lda Enemy_Temp4,x
	sta $08
	lda Enemy_Temp6,x
	sta $01
	;Offset VRAM address
	lda BGSnakeVRAMOffs,y
	bpl Enemy33_Sub2_PartVRAMC
	dec Enemy_Temp4,x
Enemy33_Sub2_PartVRAMC:
	clc
	adc Enemy_Temp6,x
	sta Enemy_Temp6,x
	lda Enemy_Temp4,x
	adc #$00
	sta Enemy_Temp4,x
	;If VRAM address $2300-$23BF or $2700-$27BF, don't draw anything
	lda $08
	and #$03
	cmp #$03
	beq Enemy33_Sub2_NoPart
	;Init VRAM buffer row/column
	ldx VRAMBufferOffset
	lda BGSnakeVRAMCmd,y
	sta VRAMBuffer,x
	inx
	;Set VRAM buffer address
	lda $01
	sta VRAMBuffer,x
	inx
	lda $08
	sta VRAMBuffer,x
	inx
	;Check for level 3
	lda CurLevel
	cmp #$02
	bne Enemy33_Sub2_NoWater
	;If VRAM address $2280-$229F or $2680-$269F, draw water surface tiles
	lda $01
	and #$E0
	cmp #$80
	bne Enemy33_Sub2_NoWater
	lda $08
	and #$03
	cmp #$02
	bne Enemy33_Sub2_NoWater
	tya
	ora #$10
	tay
Enemy33_Sub2_NoWater:
	;Set tiles in VRAM
	lda BGSnakeVRAMData,y
	sta VRAMBuffer,x
	inx
	lda BGSnakeVRAMData+$04,y
	sta VRAMBuffer,x
	inx
	lda BGSnakeVRAMData+$08,y
	sta VRAMBuffer,x
	inx
	lda BGSnakeVRAMData+$0C,y
	sta VRAMBuffer,x
	inx
	;End VRAM buffer
	jsr WriteVRAMBufferCmd_End
	;Check for row or column based on path direction
	tya
	and #$03
	tay
	lda #$04
	sta $00
	lda #$02
	sta $02
	cpy #$02
	bcs Enemy33_Sub2_Col
	;Draw collision tile row
	ldy $08
	jsr DrawCollisionTileRow
	;Restore X register
	ldx $16
	rts
Enemy33_Sub2_Col:
	;Draw collision tile column
	ldy $08
	jsr DrawCollisionTileCol
Enemy33_Sub2_NoPart:
	;Restore X register
	ldx $16
	rts
BGSnakeSetAnim:
	;Save enemy flags
	lda Enemy_Flags,x
	sta $16
	;Set enemy animation
	ldy $17
	lda BGSnakeAnim,y
	tay
	jsr SetEnemyAnimation
	;Restore enemy flags
	lda $16
	sta Enemy_Flags,x
	;Set enemy velocity
	ldy $17
	lda BGSnakeXVel,y
	sta Enemy_XVelHi,x
	lda BGSnakeYVel,y
	sta Enemy_YVelHi,x
	rts
BGSnakeAnim:
	.db $21,$23,$1F,$25
BGSnakeXVel:
	.db $00,$00,$FF,$01
BGSnakeYVel:
	.db $FF,$01,$00,$00
BGSnakeVRAMOffs:
	.db $E0,$20,$FF,$01
BGSnakeVRAMCmd:
	.db $01,$01,$02,$02
BGSnakeVRAMData:
	.db $6C,$68,$67,$63
	.db $6D,$69,$66,$62
	.db $6E,$6A,$65,$61
	.db $6F,$6B,$64,$60
	.db $00,$00,$00,$00
	.db $00,$00,$00,$00
	.db $00,$00,$00,$00
BGSnakeCornerXOffs:
	.db $00,$00,$E0,$20
	.db $00,$00,$E0,$20
	.db $20,$20,$00,$00
	.db $E0,$E0,$00,$00
BGSnakeCornerYOffs:
	.db $00,$00,$20,$20
	.db $00,$00,$E0,$E0
	.db $E0,$20,$00,$00
	.db $E0,$20,$00,$00
BGSnakeCornerVRAMOffs:
	.db $00,$00,$1F,$24
	.db $00,$00,$7F,$84
	.db $E1,$81,$00,$00
	.db $DC,$7C,$00,$00
BGSnakeCornerMetatileID:
	.db $00,$00,$2F,$32
	.db $00,$00,$30,$2C
	.db $2D,$33,$00,$00
	.db $31,$2E,$00,$00
BGSnakeOffsetData:
	.db $00,$0C,$16,$23,$35,$3E,$4F
BGSnakeDelayTimer:
	.db $20,$10,$10,$10,$14,$10,$10
BGSnakeVRAMAddrHi:
	.db $23,$27,$23,$23,$23,$1F,$27
BGSnakeVRAMAddrLo:
	.db $0C,$04,$E8,$0C,$F0,$E0,$04
BGSnakePathData:
	;$00
	.db $00,$00,$00,$00,$03,$01,$03,$03,$03,$01,$01
	.db $FF
	;$0C
	.db $00,$00,$00,$03,$03,$03,$03,$01,$01
	.db $FF
	;$16
	.db $01,$01,$01,$01,$02,$02,$00,$03,$00,$00,$00,$00
	.db $FF
	;$23
	.db $00,$00,$00,$00,$03,$03,$03,$00,$02,$02,$02,$02,$02,$01,$01,$01
	.db $01
	.db $FF
	;$35
	.db $01,$01,$01,$01,$03,$00,$00,$00
	.db $FF
	;$3E
	.db $01,$01,$01,$01,$01,$03,$00,$03,$03,$03,$00,$02,$02,$02,$00,$00
	.db $FF
	;$4F
	.db $00,$00,$00,$00,$03,$03,$03,$00,$02,$02,$00,$03,$03,$03,$01,$01
	.db $01,$01,$01
	.db $FF
BGSnakeMetatilePosData:
	;$00
	.db $00,$00,$00,$00,$1B,$1C,$24,$00,$00,$27,$00
	.db $00
	;$0C
	.db $00,$00,$00,$A1,$00,$00,$00,$A5,$00
	.db $00
	;$16
	.db $00,$00,$00,$00,$92,$00,$90,$88,$89,$00,$00,$00
	.db $00
	;$23
	.db $00,$00,$00,$23,$1B,$00,$00,$1E,$16,$00,$00,$00,$00,$11,$00,$00
	.db $00
	.db $00
	;$35
	.db $00,$00,$00,$00,$94,$95,$00,$00
	.db $00
	;$3E
	.db $00,$00,$00,$00,$00,$18,$19,$11,$00,$00,$14,$0C,$00,$00,$09,$00
	.db $00
	;$4F
	.db $00,$00,$00,$00,$99,$00,$00,$9C,$94,$00,$92,$8A,$00,$00,$8D,$00
	.db $00,$00,$00
	.db $00

;$34: BG iceberg/conveyor platform
Enemy34:
	;Check if conveyor platform or BG iceberg
	lda Enemy_Temp1,x
	cmp #$02
	beq Enemy34_BGIceberg
	;Check if already inited
	lda Enemy_Temp0,x
	bne Enemy34_ConveyorExit
	;Spawn conveyor platforms
	ldy ConveyorPlatSpawnIndex-8,x
Enemy34_Loop:
	;Spawn enemy
	lda #$00
	sta $00
	lda ConveyorPlatSpawnYPos-1,y
	sta $01
	lda #$CB
	jsr SpawnEnemy
	;Init animation frame counter
	lda ConveyorPlatSpawnCounter-1,y
	sta Enemy_Temp2,y
	;Set enemy sprite
	lda ConveyorPlatSpawnSprite-1,y
	sta Enemy_SpriteLo,y
	;Set enemy props
	lda ConveyorPlatSpawnProps-1,y
	sta Enemy_Props,y
	;Set enemy X velocity
	lda ConveyorPlatSpawnXVel-1,y
	sta Enemy_XVelHi,y
	;Set direction
	lda Enemy_Temp1,x
	sta Enemy_Temp6,y
	;Set enemy ID to conveyor platform
	lda #ENEMY_CONVEYORPLAT
	sta Enemy_ID,y
	;Init animation timer
	lda #$05
	sta Enemy_Temp1,y
	;Loop for each platform
	iny
	tya
	and #$01
	beq Enemy34_Loop
	;Mark inited
	inc Enemy_Temp0,x
	;Check to swap X velocities based on parameter value
	lda Enemy_Temp1,x
	beq Enemy34_ConveyorExit
	;Swap X velocities
	lda Enemy_XVelHi-$01,y
	sta $00
	lda Enemy_XVelHi-$02,y
	sta Enemy_XVelHi-$01,y
	lda $00
	sta Enemy_XVelHi-$02,y
Enemy34_ConveyorExit:
	rts
ConveyorPlatSpawnIndex:
	.db $01,$03
ConveyorPlatSpawnYPos:
	.db $E0,$20,$E0,$20
ConveyorPlatSpawnCounter:
	.db $00,$04,$00,$04
ConveyorPlatSpawnSprite:
	.db $1A,$14,$1A,$14
ConveyorPlatSpawnProps:
	.db $00,$40,$00,$40
ConveyorPlatSpawnXVel:
	.db $01,$FF,$01,$FF
Enemy34_BGIceberg:
	;Check for main mode
	lda Enemy_Temp6+$01
	beq Enemy34_BGIcebergMain
	;Check for finish mode
	cmp #$02
	beq Enemy34_BGIcebergFinish
	;Check if using left nametable
	lda TempIRQBufferScrollHi+1
	cmp #$20
	bne Enemy34_BGIcebergExit
	;Next task ($02: Finish)
	inc Enemy_Temp6+$01
	;Clear ship metatiles
	lda #$0E
	sta UpdateMetatilePos
	lda #$20
	sta UpdateMetatileID
	lda #$81
	sta UpdateMetatileProps
	lda #$0F
	sta UpdateMetatilePos+1
	lda #$13
	sta UpdateMetatileID+1
	lda #$01
	sta UpdateMetatileProps+1
	lda #$02
	sta UpdateMetatileCount
	rts
Enemy34_BGIcebergFinish:
	;Move iceberg left $01
	dec a:TempIRQBufferScrollX+3
	dec a:TempIRQBufferScrollX+5
	lda #$01
	sta IRQBufferPlatformXVel+3
Enemy34_BGIcebergExit:
	rts
Enemy34_BGIcebergMain:
	;Do tasks
	jsr BGIcebergTrooperSpawn
	jsr BGIcebergRockSub
	jsr BGIcebergShipMouthSub
	;If animation timer 0, exit early
	lda Enemy_Temp4+$01
	beq Enemy34_BGIcebergNoClear
	;Decrement animation timer, check if 0
	dec Enemy_Temp4+$01
	bne Enemy34_BGIcebergNoClear
	;Clear ship mouth metatile
	lda #$0E
	sta UpdateMetatilePos
	lda #$28
	sta UpdateMetatileID
	lda #$01
	sta UpdateMetatileProps
	sta UpdateMetatileCount
Enemy34_BGIcebergNoClear:
	rts
BGIcebergShipMouthSub:
	;Check if using right nametable
	lda TempIRQBufferScrollHi+1
	cmp #$24
	bne Enemy34_BGIcebergExit
	;If current ship mouth drop X position != scroll X position, exit early
	ldy Enemy_Temp3+$01
	lda BGIcebergShipMouthXPos,y
	cmp TempIRQBufferScrollX+1
	bne Enemy34_BGIcebergExit
	;Toggle rock spawn flag, if not 0, exit early
	lda Enemy_Temp2+$01
	eor #$01
	sta Enemy_Temp2+$01
	bne Enemy34_BGIcebergExit
	;Increment ship mouth index
	inc Enemy_Temp3+$01
	;Check if all 6 rocks have been spawned
	lda Enemy_Temp3+$01
	cmp #$06
	beq BGIcebergShipMouthSub_Clear
	;Spawn enemy
	lda #$00
	sta $00
	sta $01
	ldy #$06
	lda #$3F
	jsr SpawnEnemy
	;Set enemy Y position/acceleration
	lda #$7F
	sta Enemy_YAccel,y
	lda #$38
	sta Enemy_Y,y
	;Set enemy X position
	lda #$C0
	sec
	sbc TempIRQBufferScrollX+1
	sta Enemy_X,y
	;Draw ship mouth metatile
	lda #$0E
	sta UpdateMetatilePos
	lda #$2B
	sta UpdateMetatileID
	lda #$01
	sta UpdateMetatileProps
	sta UpdateMetatileCount
	rts
BGIcebergShipMouthSub_Clear
	;Next task ($01: Clear)
	lda #$01
	sta Enemy_Temp6+$01
	;Set current screen
	lda #$15
	sta CurScreen
	rts
BGIcebergShipMouthXPos:
	.db $B0,$00,$90,$20,$70,$40
BGIcebergRockSub:
	;If enemy not active, exit early
	lda Enemy_Flags+$06
	beq BGIcebergRockSub_Exit
	;If enemy Y position < $80, exit early
	lda Enemy_Y+$06
	bpl BGIcebergRockSub_Exit
	;If enemy lifetime not 0, exit early
	lda Enemy_Temp5+$06
	bne BGIcebergRockSub_Exit
	;Set enemy animation
	ldx #$06
	ldy #$E4
	jsr SetEnemyAnimation
	;Set enemy lifetime
	lda #$90
	sta Enemy_Temp5+$06
	;Clear enemy Y velocity/acceleration
	lda #$00
	sta Enemy_YVelHi+$06
	sta Enemy_YVelLo+$06
	sta Enemy_YAccel+$06
	;Play sound
	ldy #SE_CRASH
	jsr LoadSound
	;Set animation timer
	lda #$08
	sta Enemy_Temp4+$01
	;Check to destroy left or right iceberg tiles
	lda Enemy_Temp3+$01
	sec
	sbc #$01
	lsr
	sta $00
	bcs BGIcebergRockSub_Right
	;Draw destroyed iceberg tiles (left)
	ldx #$00
BGIcebergRockSub_LeftLoop:
	;Draw destroyed iceberg tile
	lda BGIcebergMetatileLeftPos,x
	clc
	adc $00
	sta UpdateMetatilePos,x
	lda BGIcebergMetatileLeftID,x
	sta UpdateMetatileID,x
	lda BGIcebergMetatileProps,x
	sta UpdateMetatileProps,x
	;Loop for each metatile
	inx
	cpx #$06
	bne BGIcebergRockSub_LeftLoop
	stx UpdateMetatileCount
	;Restore X register
	ldx #$01
	rts
BGIcebergRockSub_Right:
	;Draw destroyed iceberg tiles (right)
	ldx #$00
BGIcebergRockSub_RightLoop:
	;Draw destroyed iceberg tile
	lda BGIcebergMetatileRightPos,x
	sec
	sbc $00
	sta UpdateMetatilePos,x
	lda BGIcebergMetatileRightID,x
	sta UpdateMetatileID,x
	lda BGIcebergMetatileProps,x
	sta UpdateMetatileProps,x
	;Loop for each metatile
	inx
	cpx #$06
	bne BGIcebergRockSub_RightLoop
	stx UpdateMetatileCount
	;Restore X register
	ldx #$01
BGIcebergRockSub_Exit:
	rts
BGIcebergMetatileProps:
	.db $40,$00,$00,$00,$00,$00
BGIcebergMetatileLeftPos:
	.db $18,$20,$20,$28,$19,$21
BGIcebergMetatileRightPos:
	.db $1E,$26,$1D,$26,$25,$2D
BGIcebergMetatileLeftID:
	.db $13,$16,$03,$00,$08,$04
BGIcebergMetatileRightID:
	.db $13,$3D,$0B,$03,$07,$00
BGIcebergTrooperSpawn:
	;If free slot available, spawn trooper with jetpack on top or bottom of screen
	ldy #$03
	lda Enemy_Flags,y
	beq BGIcebergTrooperSpawn_TB
	;If free slot available, spawn trooper with jetpack on left or right of screen
	iny
	lda Enemy_Flags,y
	beq BGIcebergTrooperSpawn_LR
	rts
BGIcebergTrooperSpawn_TB:
	;Set enemy X position randomly
	jsr GetPRNGValue
	sta $00
	;Set enemy Y position top or bottom based on bit 6 of enemy X position
	and #$40
	clc
	adc #$40
	sta $01
	bne BGIcebergTrooperSpawn_Spawn
BGIcebergTrooperSpawn_LR:
	;Set enemy Y position randomly
	jsr GetPRNGValue
	sta $01
	;Set enemy X position left or right based on bit 4 of enemy Y position
	and #$10
	clc
	adc #$78
	sta $00
BGIcebergTrooperSpawn_Spawn:
	lda #$3D
	jsr SpawnEnemy
	;Set enemy ID to trooper with jetpack
	lda #ENEMY_TROOPERJETPACK
	sta Enemy_ID,y
	rts

;$4D: Reset meltable ice
Enemy4D:
	;Check if already inited
	lda Enemy_Temp0,x
	bne Enemy4D_Exit
	;If on right side of screen, clear enemy flags
	lda Enemy_X,x
	bmi Enemy4D_ClearF
	;Draw melting ice metatiles
	lda #$01
	sta Enemy_Temp3,x
	jsr MeltingIceDrawMetatile
	;Set metatile ID/props to reset ice platform
	ldy UpdateMetatileCount
	lda #$24
	sta UpdateMetatileID-2,y
	lda UpdateMetatileProps-2,y
	ora #$04
	sta UpdateMetatileProps-2,y
	lda #$25
	sta UpdateMetatileID-1,y
	lda UpdateMetatileProps-1,y
	ora #$04
	sta UpdateMetatileProps-1,y
	;Mark inited
	inc Enemy_Temp0,x
	rts
Enemy4D_ClearF:
	;Clear enemy flags
	lda #$00
	sta Enemy_Flags,x
Enemy4D_Exit:
	rts

;$35: Trooper melting ice
Enemy35:
	;Check if already inited
	lda Enemy_Temp0,x
	bne Enemy35_Main
	;Check if ice already melted
	ldy Enemy_Temp1,x
	lda BGEnemyBitTable,y
	and IceMeltedBits
	bne Enemy4D_ClearF
	;Set ice melted bit
	lda BGEnemyBitTable,y
	ora IceMeltedBits
	sta IceMeltedBits
	;Set animation timer
	lda #$30
	sta Enemy_Temp2,x
	;Set animation frame counter
	lda #$FF
	sta Enemy_Temp3,x
	;Set enemy animation
	ldy #$31
	jsr SetEnemyAnimation
	;Mark inited and set enemy X velocity based on if on left or right side of screen
	jmp Enemy05_Ent07
Enemy35_Main:
	;Decrement animation timer, check if 0
	dec Enemy_Temp2,x
	beq Enemy35_ResetT
	;If animation timer $40, check to melt ice
	lda Enemy_Temp2,x
	cmp #$40
	beq Enemy35_MeltCheck
	rts
Enemy35_ResetT:
	;Reset animation timer
	lda #$60
	sta Enemy_Temp2,x
	;Flip enemy X velocity
	lda #$00
	sec
	sbc Enemy_XVelHi,x
	sta Enemy_XVelHi,x
	;Flip enemy X
	lda Enemy_Props,x
	eor #$40
	sta Enemy_Props,x
Enemy35_Exit:
	rts
Enemy35_MeltCheck:
	;Set enemy animation
	lda #$FE
	sta Enemy_AnimTimer,x
	;If animation frame $02, exit early
	lda Enemy_Temp3,x
	cmp #$02
	beq Enemy35_Exit
	;If animation frame $FF, increment animation frame
	cmp #$FF
	beq MeltingIceDrawMetatile_Inc
	;Set enemy animation
	lda #$01
	sta Enemy_AnimTimer,x
	;Play sound
	ldy #SE_MELTINGICE
	jsr LoadSound
MeltingIceDrawMetatile:
	;Get melting ice metatile data index based on parameter value and animation frame
	lda Enemy_Temp1,x
	asl
	clc
	adc Enemy_Temp3,x
	tay
	;Save X register
	stx $17
	;Draw melting ice metatiles
	ldx UpdateMetatileCount
	lda MeltingIceMetatile0Pos,y
	sta UpdateMetatilePos,x
	lda MeltingIceMetatile0ID,y
	sta UpdateMetatileID,x
	lda MeltingIceMetatileProps,y
	sta UpdateMetatileProps,x
	inx
	lda MeltingIceMetatile1Pos,y
	sta UpdateMetatilePos,x
	lda MeltingIceMetatile1ID,y
	sta UpdateMetatileID,x
	lda MeltingIceMetatileProps,y
	sta UpdateMetatileProps,x
	inx
	stx UpdateMetatileCount
	;Restore X register
	ldx $17
MeltingIceDrawMetatile_Inc:
	;Increment animation frame counter
	inc Enemy_Temp3,x
	rts
MeltingIceMetatile0Pos:
	.db $1B,$1B,$1E,$1E,$1A,$1A,$19,$19
MeltingIceMetatile1Pos:
	.db $1C,$1C,$1F,$1F,$1B,$1B,$1A,$1A
MeltingIceMetatile0ID:
	.db $15,$13,$15,$13,$15,$13,$15,$13
MeltingIceMetatile1ID:
	.db $3C,$13,$3C,$13,$3C,$13,$3C,$13
MeltingIceMetatileProps:
	.db $00,$40,$01,$41,$00,$40,$01,$41

;$36: Trooper with jetpack
Enemy36:
	;Check if already inited
	lda Enemy_Temp0,x
	bne Enemy36_Main
	;Mark inited
	inc Enemy_Temp0,x
	;Init shooting timer
	lda #$20
	sta Enemy_Temp2,x
Enemy36_Main:
	;If enemy X position == player X position, clear enemy X acceleration
	lda Enemy_X,x
	cmp Enemy_X
	bne Enemy36_NoClearX
	;Clear enemy X acceleration
	lda #$00
	sta Enemy_XAccel,x
	beq Enemy36_CheckY
Enemy36_NoClearX:
	;Check if player is to left or right
	bcs Enemy36_Left
	;Set enemy X acceleration right
	lda #$04
	sta Enemy_XAccel,x
	;Don't flip enemy X
	lda #$00
	beq Enemy36_SetP
Enemy36_Left:
	;Set enemy X acceleration left
	lda #$FC
	sta Enemy_XAccel,x
	;Flip enemy X
	lda #$40
Enemy36_SetP:
	sta Enemy_Props,x
Enemy36_CheckY:
	;If enemy Y position == player Y position, clear enemy Y acceleration
	lda Enemy_Y,x
	cmp Enemy_Y
	bne Enemy36_NoClearY
	;Clear enemy X acceleration
	lda #$00
	sta Enemy_YAccel,x
	beq Enemy36_Level7Check
Enemy36_NoClearY:
	;Check if player is to top or bottom
	bcs Enemy36_Up
	;Set enemy Y acceleration down
	lda #$04
	bne Enemy36_SetY
Enemy36_Up:
	;Set enemy Y acceleration up
	lda #$FC
Enemy36_SetY:
	sta Enemy_YAccel,x
Enemy36_Level7Check:
	;Check for level 7
	lda CurLevel
	cmp #$06
	beq Enemy37_Sub1_Exit
	;Handle shooting
	jmp Enemy07_Main

;$37: Trooper dropping ice spikes
Enemy37:
	;Do jump table
	lda Enemy_Temp0,x
	jsr DoJumpTable
Enemy37JumpTable:
	.dw Enemy37_Sub0	;$00  Init
	.dw Enemy37_Sub1	;$01  Wait
	.dw Enemy37_Sub2	;$02  Drop
;$00: Init
Enemy37_Sub0:
	;Check if on left or right side of screen
	lda Enemy_X,x
	bpl Enemy37_Sub0_Left
	;Flip enemy X
	lda #$40
	sta Enemy_Props,x
Enemy37_Sub0_Left:
	;Init animation timer and setup next task ($01: Wait)
	lda TrooperIceSpikeTimer-1,x
	jmp Enemy38_Sub0_SetT
TrooperIceSpikeTimer:
	.db $48,$10,$28,$50,$20,$10,$30
;$01: Wait
Enemy37_Sub1:
	;If enemy Y position >= $C0, exit early
	lda Enemy_Y,x
	cmp #$C0
	bcs Enemy37_Sub1_Exit
	;Decrement animation timer, check if 0
	dec Enemy_Temp2,x
	bne Enemy37_Sub1_Exit
	;Next task ($02: Drop)
	inc Enemy_Temp0,x
	;Reset animation timer
	lda #$10
	sta Enemy_Temp2,x
	;Set enemy animation
	lda #$01
	sta Enemy_AnimTimer,x
Enemy37_Sub1_Exit:
	rts
;$02: Drop
Enemy37_Sub2:
	;Decrement animation timer, check if 0
	dec Enemy_Temp2,x
	bne Enemy37_Sub1_Exit
	;Set ice spike animation
	lda #$FE
	sta $02
IceObjectDrop:
	;Next task ($01: Wait)
	dec Enemy_Temp0,x
	;Reset animation timer
	lda #$60
	sta Enemy_Temp2,x
	;Check if enemy is facing left or right
	lda Enemy_Props,x
	and #$40
	beq IceObjectDrop_RightOffs
	;Set ice spike X offset left
	lda #$F8
	bne IceObjectDrop_SetX
IceObjectDrop_RightOffs:
	;Set ice spike X offset right
	lda #$08
IceObjectDrop_SetX:
	sta $00
	;Set ice spike Y offset
	lda #$F8
	sta $01
	;Spawn ice spike
	lda $02
	jsr FindFreeEnemySlot
	;If no free slot available, exit early
	bcc IceObjectDrop_Exit
	;Set enemy ID to ice spike
	lda #ENEMY_ICESPIKE
	sta Enemy_ID,y
	;Set enemy Y acceleration
	lda #$60
	sta Enemy_YAccel,y
	;Check if enemy is facing left or right
	lda Enemy_Props,x
	and #$40
	beq IceObjectDrop_RightVel
	;Set enemy X velocity left
	lda #$FF
	sta Enemy_XVelHi,y
	rts
IceObjectDrop_RightVel:
	;Set enemy X velocity right
	lda #$01
	sta Enemy_XVelHi,y
IceObjectDrop_Exit:
	rts

;$39: Ice spike
Enemy39:
	;Set enemy velocity
	jsr IceObjectSetVel
	;Check if already landed
	lda Enemy_Temp0,x
	bne IceObjectDrop_Exit
	;Get X position for collision
	lda Enemy_X,x
	and #$E0
	ora #$10
	sta $00
	;Get Y position for collision
	lda #$00
	sta $01
	lda Enemy_Y,x
	clc
	adc TempMirror_PPUSCROLL_Y
	bcs Enemy39_YC
	cmp #$F0
	bcc Enemy39_NoYC
Enemy39_YC:
	sbc #$F0
	ldy #$10
	sty $01
Enemy39_NoYC:
	and #$E0
	ora #$0F
	sec
	sbc $01
	sec
	sbc TempMirror_PPUSCROLL_Y
	sta $01
	;Get collision type
	jsr GetCollisionType
	;If solid tile at bottom, land ice spike
	bne Enemy39_Land
	;Get collision type
	inc $01
	jsr GetCollisionType
	;If solid tile at bottom, land ice spike
	beq IceObjectDrop_Exit
Enemy39_Land:
	;Set enemy position
	lda $00
	sta Enemy_X,x
	lda $01
	sta Enemy_Y,x
	;Clear enemy X velocity
	lda #$00
	sta Enemy_XVelHi,x
	;Save X register
	stx $02
	;Draw blank metatile
	ldx UpdateMetatileCount
	lda $00
	lsr
	lsr
	lsr
	lsr
	lsr
	sta $00
	lda $01
	clc
	adc TempMirror_PPUSCROLL_Y
	bcs Enemy39_YC2
	cmp #$F0
	bcc Enemy39_NoYC2
Enemy39_YC2:
	sbc #$F0
Enemy39_NoYC2:
	and #$E0
	lsr
	lsr
	clc
	adc $00
	sta UpdateMetatilePos,x
	lda #$34
	sta UpdateMetatileID,x
	lda #$C1
	sta UpdateMetatileProps,x
	inc UpdateMetatileCount
	;Restore X register
	ldx $02
	;Next task ($01: Land)
	inc Enemy_Temp0,x
	;Set enemy animation
	ldy #$05
	jsr SetEnemyAnimation
	;Play sound
	ldy #SE_CRASH
	jmp LoadSound

;$38: Trooper dropping ice blocks
Enemy38:
	;Do jump table
	lda Enemy_Temp0,x
	jsr DoJumpTable
Enemy38JumpTable:
	.dw Enemy38_Sub0	;$00  Init
	.dw Enemy37_Sub1	;$01  Wait
	.dw Enemy38_Sub2	;$02  Drop
;$00: Init
Enemy38_Sub0:
	;Check if on left or right side of screen
	lda Enemy_X,x
	bpl Enemy38_Sub0_Left
	;Set enemy animation
	ldy #$3B
	jsr SetEnemyAnimation
	;Flip enemy X
	lda #$40
	sta Enemy_Props,x
Enemy38_Sub0_Left:
	;Init animation timer
	lda #$20
Enemy38_Sub0_SetT:
	sta Enemy_Temp2,x
	;Set enemy flags
	lda #(EF_ACTIVE|EF_INVINCIBLE|EF_HITBULLET|EF_HITENEMY|EF_VISIBLE)
	sta Enemy_Flags,x
	;Next task ($01: Wait)
	inc Enemy_Temp0,x
	rts
;$02: Drop
Enemy38_Sub2:
	;Decrement animation timer, check if 0
	dec Enemy_Temp2,x
	bne Enemy38_Sub2_Exit
	;Set ice block animation
	lda #$33
	sta $02
	;Spawn ice block
	jsr IceObjectDrop
	;Set enemy ID to ice block
	lda #ENEMY_ICEBLOCK
	sta Enemy_ID,y
	;Reset animation timer
	lda #$10
	sta Enemy_Temp2,x
Enemy38_Sub2_Exit:
	rts
IceObjectSetVel:
	;If enemy Y velocity $06, clear enemy Y acceleration/X velocity
	lda Enemy_YVelHi,x
	cmp #$06
	bcc IceObjectSetVel_NoClearY
	;Clear enemy Y acceleration
	lda #$00
	sta Enemy_YAccel,x
	;Clear enemy X velocity
	sta Enemy_XVelHi,x
IceObjectSetVel_NoClearY:
	;If enemy Y position >= $B0, clear enemy flags
	lda Enemy_Y,x
	cmp #$B0
	bcc Enemy38_Sub2_Exit
	;Clear enemy flags
	lda #$00
	sta Enemy_Flags,x
	rts

;$3A: Ice block
Enemy3A:
	;Set enemy velocity
	jsr IceObjectSetVel
	;Save X register
	stx $17
	;Get collision type
	lda Enemy_X,x
	and #$F0
	ora #$08
	sta $00
	lda Enemy_Y,x
	clc
	adc TempMirror_PPUSCROLL_Y
	and #$F0
	ora #$07
	clc
	adc #$10
	sec
	sbc TempMirror_PPUSCROLL_Y
	sta $01
	jsr GetCollisionType
	;If no solid tile at bottom, don't land ice block
	beq Enemy3A_NoLand
	;Get collision type
	lda $01
	sec
	sbc #$10
	sta $01
	jsr GetCollisionType
	;If solid tile at top, clear enemy flags
	bne Enemy3A_ClearF
	;Init VRAM buffer row
	jsr WriteVRAMBufferCmd_InitRow
	;Get VRAM address at collision position
	jsr GetVRAMAddr
	;Set VRAM buffer address
	ldy $08
	lda $09
	and #$DE
	sta $09
	sta $01
	jsr WriteVRAMBufferCmd_Addr
	;Set tiles in VRAM
	lda #$C9
	sta VRAMBuffer,x
	inx
	lda #$CA
	sta VRAMBuffer,x
	inx
	;End VRAM buffer
	jsr WriteVRAMBufferCmd_End
	;Draw collision tile row
	lda #$02
	sta $00
	lda #$01
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
	lda #$CB
	sta VRAMBuffer,x
	inx
	lda #$CC
	sta VRAMBuffer,x
	inx
	;End VRAM buffer
	jsr WriteVRAMBufferCmd_End
	;Draw collision tile row
	lda #$02
	sta $00
	jsr DrawCollisionTileRow
	;Play sound
	ldy #SE_ICEBLOCKLAND
	jsr LoadSound
Enemy3A_ClearF:
	;Restore X register
	ldx $17
	;Clear enemy flags
	lda #$00
	sta Enemy_Flags,x
	rts
Enemy3A_NoLand:
	;Restore X register
	ldx $17
	rts

;$3B: Rolling spike
Enemy3B:
	;If current X velocity != saved X velocity, play sound
	lda Enemy_XVelHi,x
	cmp Enemy_Temp2,x
	beq Enemy3B_NoSound
	;Save enemy X velocity
	sta Enemy_Temp2,x
	;Play sound
	ldy #SE_ENEMYINVIN
	jsr LoadSound
Enemy3B_NoSound:
	;Check if already inited
	lda Enemy_Temp0,x
	bne Enemy3B_Main
	;If enemy Y position >= $B8, clear enemy Y velocity/acceleration
	lda Enemy_Y,x
	cmp #$B8
	bcs Enemy3B_ClearY
	;Mark inited and set enemy X velocity based on if on left or right side of screen
	jsr Enemy05_Ent07
	;Set enemy X velocity
	lda Enemy_XVelHi,x
	asl
	sta Enemy_XVelHi,x
	;Set enemy flags
	lda #(EF_ACTIVE|EF_HITENEMY|EF_VISIBLE)
	sta Enemy_Flags,x
Enemy3B_InitExit:
	rts
Enemy3B_ClearY:
	;Clear enemy Y velocity/acceleration
	lda #$00
	sta Enemy_YVelHi,x
	sta Enemy_YVelLo,x
	sta Enemy_YAccel,x
	rts
Enemy3B_Main:
	;Check for collision
	jsr RollingSpikeCheckCollision
	;If enemy Y position < $10, exit early
	lda Enemy_Y,x
	cmp #$10
	bcc Enemy3B_InitExit
	;If enemy X position < $02, set enemy X velocity right
	lda Enemy_X,x
	cmp #$02
	bcc Enemy3B_Right
	;If enemy X position >= $FE, set enemy X velocity left
	cmp #$FE
	bcc Enemy3B_InitExit
	;Set enemy X velocity left
	lda #$FE
	sta Enemy_XVelHi,x
	;Flip enemy X
	lda #$40
	bne Enemy3B_SetP
Enemy3B_Right:
	;Set enemy X velocity right
	lda #$02
	sta Enemy_XVelHi,x
	;Don't flip enemy X
	lda #$00
Enemy3B_SetP:
	sta Enemy_Props,x
Enemy3B_Exit:
	rts
RollingSpikeCheckCollision:
	;Get collision type
	lda Enemy_X,x
	sta $00
	lda Enemy_Y,x
	sec
	sbc #$08
	sta $01
	jsr GetCollisionType
	;If no solid tile at bottom, exit early
	beq Enemy3B_Exit
	;Move enmy down $08
	lda Enemy_X,x
	clc
	adc #$08
	sta Enemy_X,x
	rts

;$3C: Ice water decoration
Enemy3C:
	;Check if already inited
	lda Enemy_Temp0,x
	bne Enemy3C_Main
	;Set enemy animation based on parameter value
	ldy Enemy_Temp1,x
	lda IceWaterDecorationAnim,y
	tay
	jsr SetEnemyAnimation
	;Mark inited
	inc Enemy_Temp0,x
Enemy3C_Main:
	;Set enemy X position based on parameter value
	ldy Enemy_Temp1,x
	lda IceWaterDecorationXPos,y
	sec
	sbc TempIRQBufferScrollX+4
	sta Enemy_X,x
	rts
IceWaterDecorationXPos:
	.db $F0,$40,$A0
IceWaterDecorationAnim:
	.db $35,$37,$39

;$42: Icicle
Enemy42:
	;Do jump table
	lda Enemy_Temp0,x
	jsr DoJumpTable
Enemy42JumpTable:
	.dw Enemy42_Sub0	;$00  Init
	.dw Enemy42_Sub1	;$01  Shake
	.dw Enemy42_Sub2	;$02  Fall
	.dw Enemy42_Sub3	;$03  Land
;$00: Init
Enemy42_Sub0:
	;Set animation timer based on parameter value
	ldy Enemy_Temp1,x
	lda IcicleTimer,y
	sta Enemy_Temp2,x
Enemy42_Sub0_Next:
	;Next task
	inc Enemy_Temp0,x
;$03: Land
Enemy42_Sub3:
	rts
IcicleTimer:
	.db $20,$40
;$01: Shake
Enemy42_Sub1:
	;If bit 0 of global timer 0, don't shake
	lda LevelGlobalTimer
	and #$01
	beq Enemy42_Sub1_NoShake
	;Set enemy X position
	lda Enemy_X,x
	eor #$01
	sta Enemy_X,x
Enemy42_Sub1_NoShake:
	;Decrement animation timer, check if 0
	dec Enemy_Temp2,x
	bne Enemy42_Sub3
	;Set enemy Y acceleration
	lda #$7F
	sta Enemy_YAccel,x
	;Next task ($02: Fall)
	bne Enemy42_Sub0_Next
;$02: Fall
Enemy42_Sub2:
	;If enemy Y position < $98, exit early
	lda Enemy_Y,x
	cmp #$98
	bcc Enemy42_Sub3
	;Clear enemy Y velocity/acceleration
	lda #$00
	sta Enemy_YAccel,x
	sta Enemy_YVelHi,x
	sta Enemy_YVelLo,x
	;Set enemy flags
	lda #(EF_ACTIVE|EF_NOANIM|EF_VISIBLE)
	sta Enemy_Flags,x
	;Set enemy priority to be behind background
	lda #$20
	sta Enemy_Props,x
	;Next task ($03: Land)
	bne Enemy42_Sub0_Next

;$43: Trooper throwing icicles
Enemy43:
	;Do jump table
	lda Enemy_Temp0+$04
	jsr DoJumpTable
Enemy43JumpTable:
	.dw Enemy43_Sub0	;$00  Init
	.dw Enemy43_Sub1	;$01  Main
	.dw Enemy43_Sub2	;$02  Throw
;$00: Init
Enemy43_Sub0:
	;Flip enemy X
	lda #$40
	sta Enemy_Props+$04
	;Set enemy X velocity
	lda #$FF
	sta Enemy_XVelHi+$04
	;Init animation timer
	lda #$64
	sta Enemy_Temp2+$04
Enemy43_Sub0_Next:
	;Next task
	inc Enemy_Temp0+$04
Enemy43_Sub0_Exit:
	rts
;$01: Main
Enemy43_Sub1:
	;Check for icicle collision
	ldy #$03
Enemy43_Sub1_Loop:
	;If icicle not active, check next icicle
	lda Enemy_Flags,y
	beq Enemy43_Sub1_Next
	;If icicle Y position not $9E, check next icicle
	lda Enemy_Y,y
	cmp #$9E
	bne Enemy43_Sub1_Next
	;If icicle X position != enemy X position, check next icicle
	lda Enemy_X,y
	cmp Enemy_X+$04
	beq Enemy43_Sub1_Throw
Enemy43_Sub1_Next:
	;Loop for each icicle
	dey
	bne Enemy43_Sub1_Loop
	;Decrement animation timer, check if 0
	dec Enemy_Temp2+$04
	bne Enemy43_Sub0_Exit
	;Reset animation timer
	lda #$64
	sta Enemy_Temp2+$04
	;Flip enemy X velocity
	lda #$00
	sec
	sbc Enemy_XVelHi+$04
	sta Enemy_XVelHi+$04
	;Flip enemy X
	lda Enemy_Props+$04
	eor #$40
	sta Enemy_Props+$04
	rts
Enemy43_Sub1_Throw:
	;Set enemy flags
	lda #(EF_ACTIVE|EF_NOANIM)
	sta Enemy_Flags,y
	;Save icicle slot index
	sty Enemy_Temp3+$04
	;Set enemy animation
	ldy #$0B
	jsr SetEnemyAnimation
	;Save enemy X velocity
	lda Enemy_XVelHi+$04
	sta Enemy_Temp4+$04
	;Save enemy props
	lda Enemy_Props+$04
	sta Enemy_Temp6+$04
	;Clear enemy X velocity
	lda #$00
	sta Enemy_XVelHi+$04
	;Set throw animation timer
	lda #$18
	sta Enemy_YLo+$04
	;Next task ($02: Throw)
	bne Enemy43_Sub0_Next
;$02: Throw
Enemy43_Sub2:
	;Decrement throw animation timer, check if 0
	dec Enemy_YLo+$04
	lda Enemy_YLo+$04
	beq Enemy43_Sub2_EndThrow
	;If throw animation timer $08, spawn thrown icicle
	cmp #$08
	beq Enemy43_Sub2_Spawn
	;If throw animation timer $10, set throw direction
	cmp #$10
	bne Enemy43_Sub2_DirExit
	;Check if player is to left or right
	lda Enemy_X+$04
	cmp Enemy_X
	bcc Enemy43_Sub2_DirLeft
	;Flip enemy X
	lda #$40
	bne Enemy43_Sub2_DirSetX
Enemy43_Sub2_DirLeft:
	;Don't flip enemy X
	lda #$00
Enemy43_Sub2_DirSetX:
	sta Enemy_Props+$04
	;Clear enemy X velocity
	lda #$00
	sta Enemy_XVelHi+$04
Enemy43_Sub2_DirExit:
	rts
Enemy43_Sub2_Spawn:
	;Set enemy animation
	ldx Enemy_Temp3+$04
	ldy #$09
	jsr SetEnemyAnimation
	;Set enemy Y position/velocity
	lda #$84
	sta Enemy_Y,x
	lda #$40
	sta Enemy_YVelLo,x
	;Set enemy props
	lda Enemy_Props+$04
	sta Enemy_Props,x
	;Check if enemy is facing left or right
	beq Enemy43_Sub2_SpawnRight
	;Set enemy X velocity left
	lda #$FE
	bne Enemy43_Sub2_SpawnSetX
Enemy43_Sub2_SpawnRight:
	;Set enemy X velocity right
	lda #$02
Enemy43_Sub2_SpawnSetX:
	sta Enemy_XVelHi,x
	;Restore X register
	ldx #$04
Enemy43_Sub2_Exit:
	rts
Enemy43_Sub2_EndThrow:
	;Restore enemy X velocity
	lda Enemy_Temp4+$04
	sta Enemy_XVelHi+$04
	;Restore enemy props
	lda Enemy_Temp6+$04
	sta Enemy_Props+$04
	;Next task ($01: Main)
	lda #$01
	sta Enemy_Temp0+$04
	;Set enemy animation
	ldy #$0A
	jmp SetEnemyAnimation

;$3D: Sprite mask
Enemy3D:
	;Check if already inited
	lda Enemy_Temp0+$0C
	bne Enemy43_Sub2_Exit
	;Check for level 6
	lda CurLevel
	cmp #$05
	beq Enemy3D_Level6
	;Check for level 3
	cmp #$02
	beq Enemy3D_Level3
	;Set enemy flags
	lda #EF_ACTIVE
	sta Enemy_Flags+$0C
Enemy3D_Level3:
	;Set enemy priority to be behind background
	lda #$20
	sta Enemy_Props+$0C
	;Mark inited
	inc Enemy_Temp0+$0C
	;Clear enemy triggered bits
	lda #$00
	sta EnemyTriggeredBits
	rts
Enemy3D_Level6:
	;Mark inited
	inc Enemy_Temp0+$0C
	;Set enemy animation
	ldy #$A5
	jmp SetEnemyAnimation

;$3F: Level 3 boss missile
Enemy3F:
	;Decrement animation timer, check if 0
	dec Enemy_Temp2+$08
	bne Enemy3F_Exit
	;Clear enemy Y velocity
	lda #$00
	sta Enemy_YVelHi+$08
Enemy3F_Exit:
	rts

;$3E: Level 3 boss
Enemy3E:
	;Do subroutines
	jsr Enemy3E_DoSub
	;Increment frozen ice layer timer
	inc BGFrozenIceLayerTimer
	;If bits 0-4 of frozen ice layer timer not 0, exit early
	lda BGFrozenIceLayerTimer
	and #$1F
	bne Enemy3E_Exit
	;If water height $12, exit early
	lda TempIRQBufferHeight+1
	cmp #$12
	beq Enemy3E_Exit
	;Move water level up $01
	dec TempIRQBufferHeight
	inc TempIRQBufferHeight+1
Enemy3E_Exit:
	rts
Enemy3E_DoSub:
	;Do jump table
	lda Enemy_Temp0+$01
	jsr DoJumpTable
Enemy3EJumpTable:
	.dw Enemy3E_Sub0	;$00  Init
	.dw Enemy3E_Sub1	;$01  Intro wait
	.dw Enemy3E_Sub2	;$02  Intro fall
	.dw Enemy3E_Sub3	;$03  Idle
	.dw Enemy3E_Sub4	;$04  Jump
	.dw Enemy3E_Sub5	;$05  Land
	.dw Enemy3E_Sub6	;$06  Shoot init
	.dw Enemy3E_Sub7	;$07  Shoot
	.dw Enemy3E_Sub8	;$08  Freeze jump
	.dw Enemy3E_Sub9	;$09  Freeze shoot
;$00: Init
Enemy3E_Sub0:
	;Set player priority to be behind background
	lda #$20
	sta Enemy_Props
	;Set enemy priority to be behind background
	sta Enemy_Props+$01
	;Set ground level
	lda #$9C
	sta Enemy_Temp3+$01
	;Init animation timer
	lda #$60
	sta Enemy_Temp2+$01
	;Set boss enemy slot index
	lda #$01
	sta BossEnemyIndex
	;Next task ($01: Intro wait)
	inc Enemy_Temp0+$01
Enemy3E_Sub0_Exit:
	rts
;$01: Intro wait
Enemy3E_Sub1:
	;Decrement animation timer, check if 0
	dec Enemy_Temp2+$01
	bne Enemy3E_Sub0_Exit
	;Set enemy Y position/acceleration
	lda #$00
	sta Enemy_Y+$01
	lda #$7F
	sta Enemy_YAccel+$01
	;Next task ($02: Intro fall)
	inc Enemy_Temp0+$01
	rts
;$02: Intro fall
Enemy3E_Sub2:
	;If enemy Y position < $9C, exit early
	lda #$9C
	cmp Enemy_Y+$01
	bcs Enemy3E_Sub0_Exit
	;Set enemy Y position
	sta Enemy_Y+$01
	;Clear enemy Y velocity/acceleration
	lda #$00
	sta Enemy_YVelHi+$01
	sta Enemy_YVelLo+$01
	sta Enemy_YAccel+$01
	;Reset animation timer
	lda #$20
	sta Enemy_Temp2+$01
	;Next task ($03: Idle)
	inc Enemy_Temp0+$01
	rts
;$03: Idle
Enemy3E_Sub3:
	;Decrement animation timer, check if 0
	dec Enemy_Temp2+$01
	bne Enemy3E_Sub0_Exit
	;Set enemy Y velocity/acceleration
	lda #$F7
	sta Enemy_YVelHi+$01
	lda #$7F
	sta Enemy_YAccel+$01
	;Next task ($04: Jump)
	inc Enemy_Temp0+$01
	;Set enemy animation
	ldy #$15
	jsr SetEnemyAnimation
	;If water height not $12, exit early
	lda TempIRQBufferHeight+1
	cmp #$12
	bne Enemy3E_Sub0_Exit
	;If frozen ice height >= $7D, exit early
	lda TempIRQBufferHeight+2
	cmp #$7D
	bcs Enemy3E_Sub3_Exit
	;Move ground level up $10
	lda Enemy_Temp3+$01
	sec
	sbc #$10
	sta Enemy_Temp3+$01
	;Next task ($08: Freeze jump)
	lda #$08
	sta Enemy_Temp0+$01
Enemy3E_Sub3_Exit:
	rts
;$04: Jump
Enemy3E_Sub4:
	;If enemy Y position >= $C0, exit early
	lda Enemy_Y+$01
	cmp #$C0
	bcs Enemy3E_Sub3_Exit
	;If ground level >= enemy Y position, exit early
	lda Enemy_Temp3+$01
	cmp Enemy_Y+$01
	bcs Enemy3E_Sub3_Exit
	;Set enemy Y position
	sta Enemy_Y+$01
	;Clear enemy Y velocity/acceleration
	lda #$00
	sta Enemy_YVelHi+$01
	sta Enemy_YVelLo+$01
	sta Enemy_YAccel+$01
	;Reset animation timer
	lda #$10
	sta Enemy_Temp2+$01
	;Next task ($05: Land)
	inc Enemy_Temp0+$01
	;Set enemy animation
	ldy #$13
	jmp SetEnemyAnimation
;$05: Land
Enemy3E_Sub5:
	;Decrement animation timer, check if 0
	dec Enemy_Temp2+$01
	bne Enemy3E_Sub3_Exit
	;Reset animation timer
	lda #$10
	sta Enemy_Temp2+$01
	;Next task ($06: Shoot init)
	inc Enemy_Temp0+$01
	;Set enemy animation
	ldy #$19
	jmp SetEnemyAnimation
;$06: Shoot init
Enemy3E_Sub6:
	;Decrement animation timer, check if 0
	dec Enemy_Temp2+$01
	bne Enemy3E_Sub3_Exit
	;Spawn enemy
	lda #$F8
	sta $00
	lda #$00
	sta $01
	ldy #$08
	lda #$1B
	jsr SpawnEnemy
	;Increment missile Y velocity index
	inc Enemy_Temp4+$01
	lda Enemy_Temp4+$01
	cmp #$06
	bne Enemy3E_Sub6_NoC
	lda #$00
Enemy3E_Sub6_NoC:
	sta Enemy_Temp4+$01
	;Set enemy Y velocity
	tay
	lda Level3BossMissileYVel,y
	sta Enemy_YVelHi+$08
	;Init animation timer
	lda #$04
	sta Enemy_Temp2+$08
	;Set enemy X velocity
	lda #$FC
	sta Enemy_XVelHi+$08
	;Set enemy ID to level 3 boss missile
	lda #ENEMY_L3BSMISSBGICEROCK
	sta Enemy_ID+$08
	;Set animation timer
	lda #$10
	sta Enemy_Temp2+$01
	;Next task ($07: Shoot)
	inc Enemy_Temp0+$01
	;Play sound
	ldy #SE_BLAST
	jmp LoadSound
Level3BossMissileYVel:
	.db $03,$00,$FD,$00,$03,$06
;$07: Shoot
Enemy3E_Sub7:
	;Decrement animation timer, check if 0
	dec Enemy_Temp2+$01
	bne Enemy3E_Sub9_Exit
	;Reset animation timer
	lda #$10
	sta Enemy_Temp2+$01
	;Next task ($03: Idle)
	lda #$03
	sta Enemy_Temp0+$01
	;Set enemy animation
	ldy #$13
	jmp SetEnemyAnimation
;$08: Freeze jump
Enemy3E_Sub8:
	;If enemy Y velocity up, exit early
	lda Enemy_YVelHi+$01
	bmi Enemy3E_Sub9_Exit
	;Reset animation timer
	lda #$10
	sta Enemy_Temp2+$01
	;Next task ($09: Freeze shoot)
	inc Enemy_Temp0+$01
	;Spawn enemy
	lda #$E8
	sta $00
	lda #$12
	sta $01
	lda #$1D
	jsr FindFreeEnemySlot
	;Set enemy velocity
	lda #$FA
	sta Enemy_XVelHi,y
	lda #$06
	sta Enemy_YVelHi,y
	;Set enemy animation
	ldy #$17
	jsr SetEnemyAnimation
	;Play sound
	ldy #SE_WHIRLASER2
	jmp LoadSound
;$09: Freeze shoot
Enemy3E_Sub9:
	;Decrement animation timer, check if 0
	dec Enemy_Temp2+$01
	bne Enemy3E_Sub9_Exit
	;Set water height $02
	lda #$02
	sta TempIRQBufferHeight+1
	;Increment ice layer height $10
	lda TempIRQBufferHeight+2
	clc
	adc #$10
	sta TempIRQBufferHeight+2
	lda TempIRQBufferScrollY+1
	sec
	sbc #$10
	sta TempIRQBufferScrollY+1
	;Next task ($04: Jump)
	lda #$04
	sta Enemy_Temp0+$01
	;If ground level + $08 >= player Y position, exit early
	lda Enemy_Temp3+$01
	clc
	adc #$08
	cmp Enemy_Y
	bcs Enemy3E_Sub9_Exit
	;If enemy Y velocity up, exit early
	lda Enemy_YVelHi
	bmi Enemy3E_Sub9_Exit
	;Set frozen in ice layer flag
	lda #$01
	sta FrozenIceLayerFlag
	;Check if player is on left or right side of screen
	lda Enemy_X
	bpl Enemy3E_Sub9_Right
	;Move player left $08
	sec
	sbc #$08
	sta Enemy_X
Enemy3E_Sub9_Exit:
	rts
Enemy3E_Sub9_Right:
	;Move player right $08
	clc
	adc #$08
	sta Enemy_X
	rts

;$44: BG 3-way shooter
Enemy44:
	;Check if already inited
	lda Enemy_Temp0,x
	beq Enemy44_Init
	;If bits 0-4 of global timer not 0, exit early
	lda LevelGlobalTimer
	and #$1F
	beq Enemy44_Shoot
	rts
Enemy44_Init:
	;Set enemy flags
	lda #(EF_ACTIVE|EF_NOANIM|EF_HITBULLET|EF_HITENEMY|EF_VISIBLE)
	sta Enemy_Flags,x
	;Check if enemy is already dead, if not, init enemy and mark inited
	jmp Enemy09_Ent44
Enemy44_Shoot:
	;Increment shooting direction index
	lda Enemy_Temp2,x
	inc Enemy_Temp2,x
	;If shooting direction index 0, exit early
	and #$03
	beq Enemy44_Exit
	;Get shooting direction index
	asl
	asl
	tay
	;Get enemy position/velocity
	lda Shooter3WayVel-4,y
	sta $00
	lda Shooter3WayVel-4+1,y
	sta $01
	lda Shooter3WayVel-4+2,y
	sta $02
	lda Shooter3WayVel-4+3,y
	sta $03
	;Spawn enemy
	lda #$24
	jsr FindFreeEnemySlot
	;If no free slots available, exit early
	bcc Enemy44_Exit
	;Set enemy velocity
	lda $02
	sta Enemy_XVelHi,y
	lda $03
	sta Enemy_YVelHi,y
Enemy44_Exit:
	rts
Shooter3WayVel:
	.db $0F,$0C,$03,$03
	.db $F0,$0C,$FD,$03
	.db $01,$10,$00,$04

;$45: Crater gun
Enemy45:
	;Check for init mode
	ldy Enemy_Temp0,x
	beq Enemy45_Init
	;If animation timer $01, shoot laser
	dey
	beq Enemy45_Shoot
	;If animation timer $02, clear enemy Y velocity
	dey
	bne Enemy45_NoClearY
	;Clear enemy Y velocity
	tya
	sta Enemy_YVelHi,x
Enemy45_NoClearY:
	;Decrement animation timer
	dec Enemy_Temp0,x
Enemy45_Exit:
	rts
Enemy45_Shoot:
	;Increment shooting timer
	inc Enemy_Temp1,x
	;If bits 0-4 of shooting timer not 0, exit early
	lda Enemy_Temp1,x
	and #$1F
	bne Enemy45_Exit
	;Shoot toward front
	lda #$5F
	sta $02
	jmp EnemyShootDir
Enemy45_Init:
	;Init animation timer
	lda #$20
	sta Enemy_Temp0,x
	;Set enemy Y velocity
	lda #$FF
	sta Enemy_YVelHi,x
	;Set enemy flags
	lda #(EF_ACTIVE|EF_NOANIM|EF_HITBULLET|EF_HITENEMY|EF_VISIBLE)
	sta Enemy_Flags,x
	;Check if player is to left or right
	lda Enemy_X,x
	cmp Enemy_X
	bcs Enemy45_Left
	;Set enemy props
	lda #$20
	sta Enemy_Props,x
	;Set unused value
	lda #$08
	sta Enemy_Temp3,x
	bne Enemy45_Sound
Enemy45_Left:
	;Set enemy props
	lda #$60
	sta Enemy_Props,x
	;Set unused value
	lda #$F8
	sta Enemy_Temp3,x
Enemy45_Sound:
	;Play sound
	ldy #SE_WHIRSHORT
	jmp LoadSound

;$47: Dive bomber
Enemy47:
	;Do jump table
	lda Enemy_Temp0,x
	jsr DoJumpTable
Enemy47JumpTable:
	.dw Enemy47_Sub0	;$00  Init
	.dw Enemy47_Sub1	;$01  In
	.dw Enemy47_Sub2	;$02  Turn
	.dw Enemy47_Sub3	;$03  Out
;$00: Init
Enemy47_Sub0:
	;Next task ($01: In)
	inc Enemy_Temp0,x
	;Check if on left or right side of screen
	lda #$00
	sta $00
	lda Enemy_X,x
	bpl Enemy47_Sub0_Right
	;Set enemy X velocity/props left
	dec $00
Enemy47_Sub0_Right:
	;Set enemy X velocity/props right
	lda #$06
	eor $00
	sta Enemy_XVelHi,x
	lda #$D8
	eor $00
	sta Enemy_XAccel,x
	lda #$40
	and $00
	sta Enemy_Props,x
	;Set enemy velocity
	lda #$80
	sta Enemy_YVelLo,x
	lda #$80
	sta Enemy_XVelLo,x
	;Play sound
	ldy #SE_DIVEBOMBER
	jsr LoadSound
;$01: In
Enemy47_Sub1:
	;Increment animation timer
	inc Enemy_Temp1,x
	;If animation timer < $80, skip this part
	lda Enemy_Temp1,x
	cmp #$80
	bcc Enemy47_Sub2
	;If moving toward center of screen, skip this part
	lda Enemy_X,x
	eor Enemy_XVelHi,x
	bpl Enemy47_Sub2
	;Flip enemy X acceleration
	lda Enemy_XAccel,x
	eor #$FF
	sta Enemy_XAccel,x
	;Next task ($02: Turn)
	inc Enemy_Temp0,x
;$02: Turn
Enemy47_Sub2:
	;Increment animation timer
	inc Enemy_Temp1,x
	;If bits 0-5 of animation timer 0, shoot toward player
	lda Enemy_Temp1,x
	and #$3F
	bne Enemy47_Sub2_NoShoot
	;Shoot toward player
	lda #$00
	sta $00
	sta $01
	jsr EnemyShootPlayerOffs
Enemy47_Sub2_NoShoot:
	;If enemy Y position < $70, skip this part
	lda Enemy_Y,x
	cmp #$70
	bcc Enemy47_Sub3
	;Clear enemy Y velocity
	lda #$00
	sta Enemy_YVelHi,x
	;Set enemy Y acceleration
	lda #$F0
	sta Enemy_YAccel,x
	;Next task ($03: Out)
	inc Enemy_Temp0,x
;$03: Out
Enemy47_Sub3:
	;Set enemy properties based on if moving left or right
	jmp DiveBomberSetProps

;$48: Crater snake
Enemy48:
	;Do jump table
	lda Enemy_Temp0,x
	jsr DoJumpTable
Enemy48JumpTable:
	.dw Enemy48_Sub0	;$00  Init
	.dw Enemy48_Sub1	;$01  Out
	.dw Enemy48_Sub2	;$02  Change direction
	.dw Enemy48_Sub3	;$03  Main
;$00: Init
Enemy48_Sub0:
	;Next task ($01: Out)
	inc Enemy_Temp0,x
	;Init double speed timer
	lda #$00
	sta Enemy_Temp3,x
	;Set enemy Y acceleration
	lda #$F8
	sta Enemy_YAccel,x
	;Set enemy priority to be behind background
	lda #$20
	sta Enemy_Props,x
	;Set enemy visible flag
	inc Enemy_Flags,x
	;Check if parts enemy slots are active
	ldy #$07
Enemy48_Sub0_CheckLoop:
	;Loop for each slot index
	dey
	beq Enemy48_Sub0_Spawn
	;If slot active, clear enemy flags
	lda Enemy_Flags,y
	bpl Enemy48_Sub0_CheckLoop
	;Clear enemy flags
	lda #$00
	sta Enemy_Flags,x
	rts
Enemy48_Sub0_Spawn:
	;Save X register
	stx $07
	;Spawn parts
	ldy #$07
Enemy48_Sub0_SpawnLoop:
	;Loop for each part
	dey
	beq Enemy48_Sub0_End
	;Spawn enemy
	lda #$00
	sta $00
	sta $01
	lda #$4D
	jsr SpawnEnemy
	;Set enemy priority to be behind background
	lda #$20
	sta Enemy_Props,y
	;Set enemy ID to crater snake part
	lda #ENEMY_CRATERSNAKEPART
	sta Enemy_ID,y
	;Set part index
	lda Enemy_Temp1,x
	sta Enemy_Temp1,y
	;Set parent slot index
	txa
	sta Enemy_Temp4,y
	;Set sibling slot index
	tya
	sta Enemy_Temp6,x
	;Loop for each part
	tax
	inc Enemy_Temp1,x
	bne Enemy48_Sub0_SpawnLoop
Enemy48_Sub0_End:
	;Restore X register
	ldx $07
	rts
;$02: Change direction
Enemy48_Sub2:
	;Save X register
	stx $00
	;Next task ($03: Main)
	inc Enemy_Temp0,x
	;Increment double speed timer
	lda Enemy_Temp3,x
	adc #$0C
	sta Enemy_Temp3,x
	;Check for quadrant 3/4
	ldy #$00
	lda Enemy_Temp1,x
	bmi Enemy48_Sub2_NoSwap
	;If in quadrant 3/4, swap compare order
	ldy $00
	ldx #$00
Enemy48_Sub2_NoSwap:
	;Check for quadrant 2/4
	asl
	bmi Enemy48_Sub2_CheckX
	;Determine player relative position Y
	lda Enemy_Y,x
	cmp Enemy_Y,y
	jmp Enemy48_Sub2_Check
Enemy48_Sub2_CheckX:
	;Determine player relative position X
	lda Enemy_X,x
	cmp Enemy_X,y
Enemy48_Sub2_Check:
	;Check to set direction clockwise or counterclockwise
	bcc Enemy48_Sub2_CCW
	;Set direction clockwise
	lda #$FE
	bcs Enemy48_Sub2_SetDir
Enemy48_Sub2_CCW:
	;Set direction counterclockwise
	lda #$02
Enemy48_Sub2_SetDir:
	;Restore X register
	ldx $00
	;Set direction
	sta Enemy_Temp2,x
	rts
;$03: Main
Enemy48_Sub3:
	;Add angular velocity
	lda Enemy_Temp1,x
	adc Enemy_Temp2,x
	tay
	;If double speed timer < $40, add angular velocity again
	lda Enemy_Temp3,x
	cmp #$40
	tya
	bcs Enemy48_Sub3_NoDouble
	;Add angular velocity
	adc Enemy_Temp2,x
Enemy48_Sub3_NoDouble:
	sta Enemy_Temp1,x
	;If bits 1-4 of angle 0, set enemy animation based on angle and direction
	tay
	and #$1E
	bne Enemy48_Sub3_NoAnim
	;Get enemy animation index based on angle and direction
	tya
	lsr
	lsr
	lsr
	and #$1C
	tay
	lda Enemy_Temp2,x
	bpl Enemy48_Sub3_CCW
	iny
	iny
Enemy48_Sub3_CCW:
	;Set enemy props
	lda Enemy_Props,x
	and #$BF
	ora CraterSnakeAngleTable+1,y
	sta Enemy_Props,x
	;Set enemy animation
	lda CraterSnakeAngleTable,y
	tay
	jsr SetEnemyAnimation
	;Set enemy hit bullet/visible flags
	lda Enemy_Flags,x
	ora #(EF_HITBULLET|EF_VISIBLE)
	sta Enemy_Flags,x
Enemy48_Sub3_NoAnim:
	;Clear enemy velocity
	lda #$00
	sta Enemy_XVelHi,x
	sta Enemy_YVelHi,x
	;Set unused value
	sta $09
	;If bits 1-5 of angle 0, change direction
	lda Enemy_Temp1,x
	and #$3E
	beq Enemy48_Sub3_ChangeDir
	;Calculate cosine
	lda Enemy_Temp1,x
	jsr CalcCos
	;Check for quadrant 2/3
	bcc Enemy48_Sub3_PosX
	;Negate result
	eor #$FF
	adc #$00
	dec Enemy_XVelHi,x
Enemy48_Sub3_PosX:
	;Scale result
	asl
	rol Enemy_XVelHi,x
	sta Enemy_XVelLo,x
	;Calculate sine
	lda Enemy_Temp1,x
	jsr CalcSin
	;Scale result
	php
	sta Enemy_YVelLo,x
	lsr
	sta $08
	asl
	asl
	rol Enemy_YVelHi,x
	adc $08
	sta Enemy_YVelLo,x
	lda #$00
	adc Enemy_YVelHi,x
	sta Enemy_YVelHi,x
	;Check for quadrant 3/4
	plp
	bcs Enemy48_Sub3_PosY
	;Negate result
	eor #$FF
	sta Enemy_YVelHi,x
	lda #$FF
	eor Enemy_YVelLo,x
	adc #$01
	sta Enemy_YVelLo,x
Enemy48_Sub3_PosY:
	rts
Enemy48_Sub3_ChangeDir:
	;Next task ($02: Change direction)
	lda #$02
	sta Enemy_Temp0,x
	;If double speed timer < $3F, shoot toward player
	lda Enemy_Temp3,x
	cmp #$3F
	bcs Enemy48_Sub3_Exit
	;Shoot toward player
	lda #$00
	sta $00
	sta $01
	jsr EnemyShootPlayerOffs
Enemy48_Sub3_Exit:
	rts
CraterSnakeAngleTable:
	.db $4B,$40,$71,$40,$6F,$00,$4B,$40
	.db $6F,$00,$6F,$00,$4B,$00,$6F,$00
	.db $71,$00,$4B,$00,$49,$00,$71,$00
	.db $49,$00,$49,$00,$71,$40,$49,$00
;$01: Out
Enemy48_Sub1:
	;Increment animation timer
	inc Enemy_Temp1,x
	;If animation timer $40, setup next task ($02: Change direction)
	lda #$40
	eor Enemy_Temp1,x
	bne Enemy48_Sub1_NoNext
	;Next task ($02: Change direction)
	inc Enemy_Temp0,x
	;Set enemy priority to be in front of background
	lda #$00
	sta Enemy_Props,x
	rts
Enemy48_Sub1_NoNext:
	;If enemy Y position < $60, set enemy priority to be in front of background
	lda Enemy_Y,x
	cmp #$60
	bcs Enemy48_Sub1_Exit
	;Set enemy priority to be in front of background
	lda #$00
	sta Enemy_Props,x
Enemy48_Sub1_Exit:
	rts

;$4B: Crater snake part
Enemy4B:
	;Check for init mode
	ldy Enemy_Temp0,x
	beq Enemy4B_Init
	;Check for fly mode
	dey
	bne Enemy4B_Fly
	;Shift enemy X velocity right 6 bits
	lda Enemy_XVelLo,x
	sta $00
	lda Enemy_XVelHi,x
	sta $01
	jsr CraterSnakeShiftVel
	jsr CraterSnakeShiftVel
	;Set enemy X acceleration
	lda $00
	sta Enemy_XAccel,x
	;Shift enemy Y velocity right 6 bits
	lda Enemy_YVelLo,x
	sta $00
	lda Enemy_YVelHi,x
	sta $01
	jsr CraterSnakeShiftVel
	jsr CraterSnakeShiftVel
	;Set enemy Y acceleration
	lda $00
	sta Enemy_YAccel,x
	;Next task ($02: Fly)
	inc Enemy_Temp0,x
Enemy4B_Fly:
	rts
Enemy4B_Init:
	;Increment animation timer
	inc Enemy_Temp1,x
	;If parent not active, setup next task ($01: Fly init)
	ldy Enemy_Temp4,x
	lda Enemy_Flags,y
	bpl Enemy4B_FlyInit
	;If parent lifetime not 0, setup next task ($01: Fly init)
	lda Enemy_Temp5,y
	bmi Enemy4B_FlyInit
	;If bits 0-2 of animation timer 0, change direction
	lda Enemy_Temp1,x
	and #$07
	beq Enemy4B_ChangeDir
	rts
Enemy4B_FlyInit:
	;Next task ($01: Fly init)
	inc Enemy_Temp0,x
	;If this is the last part, exit early
	lda Enemy_Temp6,x
	beq Enemy4B_FlyExit
	;Loop for each part
	tax
	bne Enemy4B_FlyInit
Enemy4B_FlyExit:
	rts
Enemy4B_ChangeDir:
	;Check if parent is flashing
	sta $08
	lda Enemy_Flags,x
	eor Enemy_Flags,y
	and #EF_HITENEMY
	beq Enemy4B_NoFlash
	dec $08
Enemy4B_NoFlash:
	;Set enemy X velocity
	lda Enemy_X,y
	sec
	sbc Enemy_X,x
	sta Enemy_XVelHi,x
	;Shift enemy X velocity right 3 bits
	lda $08
	bcs Enemy4B_PosX
	eor #$FF
	sec
Enemy4B_PosX:
	bmi Enemy4B_PosX2
	clc
Enemy4B_PosX2:
	ror Enemy_XVelHi,x
	ror
	ror Enemy_XVelHi,x
	ror
	ror Enemy_XVelHi,x
	ror
	sta Enemy_XVelLo,x
	;Set enemy Y velocity
	lda Enemy_Y,y
	sec
	sbc Enemy_Y,x
	sta Enemy_YVelHi,x
	;Shift enemy Y velocity right 3 bits
	bcs Enemy4B_PosY
	lda #$07
	sec
	bcs Enemy4B_PosY2
Enemy4B_PosY:
	lda #$00
	clc
Enemy4B_PosY2:
	ror Enemy_YVelHi,x
	ror
	ror Enemy_YVelHi,x
	ror
	ror Enemy_YVelHi,x
	ror
	sta Enemy_YVelLo,x
	;Set enemy props
	lda Enemy_Props,y
	and #$BF
	sta Enemy_Props,x
	rts
CraterSnakeShiftVel:
	;Shift right arithmetically 3 bits
	lda $01
	cmp #$80
	ror
	ror $00
	cmp #$80
	ror
	ror $00
	cmp #$80
	ror
	ror $00
	sta $01
	rts
DiveBomberSetProps:
	;Check if moving left or right
	lda Enemy_XVelHi,x
	bmi DiveBomberSetProps_Left
	;Don't flip enemy X
	lda #$00
	sta $00
	beq DiveBomberSetProps_SetP
DiveBomberSetProps_Left:
	;Flip enemy X
	lda #$40
	sta $00
DiveBomberSetProps_SetP:
	lda Enemy_Props,x
	and #$BF
	ora $00
	sta Enemy_Props,x
	rts

;$52: Asteroid
Enemy52:
	;Check if already inited
	lda Enemy_Temp0,x
	bne Enemy53_Exit
	;Mark inited
	inc Enemy_Temp0,x
	;Set enemy X velocity/props based on parameter value
	ldy Enemy_Temp1,x
	lda AsteroidXVel,y
	and #$02
	sta Enemy_XVelHi,x
	lda AsteroidXVel,y
	and #$40
	sta Enemy_XVelLo,x
	lda AsteroidXVel,y
	and #$20
	sta Enemy_Props,x
	;Set enemy animation based on parameter value
	lda AsteroidAnim,y
	tay
	jsr SetEnemyAnimation
	;If gray asteroid, set enemy hit flags
	lda Enemy_Temp1,x
	cmp #$04
	bcc Enemy52_Exit
	;Set enemy hit flags
	lda #(EF_ACTIVE|EF_NOANIM|EF_HITBULLET|EF_HITENEMY|EF_VISIBLE)
	sta Enemy_Flags,x
Enemy52_Exit:
	rts
AsteroidXVel:
	.db $60,$60,$20,$20,$02,$02,$00,$00
AsteroidAnim:
	.db $5B,$5D,$5B,$5D,$45,$47,$45,$47

;$53: Asteroid platform
Enemy53:
	;Check if already inited
	lda Enemy_Temp0,x
	bne Enemy53_Main
	;Set enemy velocity based on parameter value
	ldy Enemy_Temp1,x
	lda AsteroidPlatformXVel,y
	sta Enemy_XVelHi,x
	lda AsteroidPlatformYVel,y
	sta Enemy_YVelHi,x
	;Mark inited
	inc Enemy_Temp0,x
	;Set enemy animation based on parameter value
	lda AsteroidPlatformAnim,y
	tay
	jsr SetEnemyAnimation
	;Set enemy flags
	lda #(EF_ACTIVE|EF_NOANIM|EF_PLATFORM|EF_VISIBLE)
	sta Enemy_Flags,x
	;Set enemy collision size
	lda #$0C
	sta Enemy_CollHeight,x
	sta Enemy_CollWidth,x
Enemy53_Exit:
	rts
AsteroidPlatformAnim:
	.db $45,$47,$47,$45
AsteroidPlatformXVel:
	.db $02,$02,$FE,$FE
AsteroidPlatformYVel:
	.db $FF,$01,$FF,$01
Enemy53_Main:
	;If enemy Y position >= $F0, loop around vertically
	lda Enemy_Y,x
	cmp #$F0
	bcc Enemy53_Exit
	;Check if moving up or down
	ldy Enemy_YVelHi,x
	bpl Enemy53_Down
	;Set enemy Y position up
	sec
	sbc #$10
	sta Enemy_Y,x
	rts
Enemy53_Down:
	;Set enemy Y position down
	clc
	adc #$10
	sta Enemy_Y,x
	rts

;$54: Vertical area ship fire
Enemy54:
	;Check if already inited
	lda Enemy_Temp0+$08
	bne Enemy54_Exit
	;Decrement animation timer, check if 0
	dec Enemy_Temp2+$08
	bne Enemy54_Exit
	;Set enemy flags
	lda #(EF_ACTIVE|EF_NOANIM|EF_HITENEMY|EF_VISIBLE)
	sta Enemy_Flags+$08
	;Set enemy X velocity
	lda #$FC
	sta Enemy_XVelHi+$08
	;Mark inited
	inc Enemy_Temp0+$08
Enemy54_Exit:
	rts

;$4A: Minecart
Enemy4A:
	;Do jump table
	lda Enemy_Temp0,x
	jsr DoJumpTable
Enemy4AJumpTable:
	.dw Enemy4A_Sub0	;$00  Init
	.dw Enemy4A_Sub1	;$01  Wait
	.dw Enemy4A_Sub2	;$02  Main
	.dw Enemy4A_Sub3	;$03  Slow init
	.dw Enemy4A_Sub4	;$04  Slow
	.dw Enemy4A_Sub5	;$05  Stop
	.dw Enemy4A_Sub6	;$06  Fall
;$00: Init
Enemy4A_Sub0:
	;Set enemy props based on parameter value
	ldy Enemy_Temp1,x
	lda MinecartProps,y
	sta Enemy_Props,x
	;Next task ($01: Wait)
	inc Enemy_Temp0,x
;$06: Fall
Enemy4A_Sub6:
	rts
;$01: Wait
Enemy4A_Sub1:
	;Check for collision
	jsr PlatformCheckCollision
	bne Enemy4A_Sub6
	;Check for slow minecarts
	ldy Enemy_Temp1,x
	cpy #$09
	bcc Enemy4A_Sub1_Fast
	;Set enemy X velocity slow
	lda #$FC
	bne Enemy4A_Sub1_SetX
Enemy4A_Sub1_Fast:
	;Check if enemy is facing left or right
	lda Enemy_Props,x
	bne Enemy4A_Sub1_Right
	;Set enemy X velocity fast left
	lda #$F8
	bne Enemy4A_Sub1_SetX
Enemy4A_Sub1_Right:
	;Set enemy X velocity fast right
	lda #$08
Enemy4A_Sub1_SetX:
	sta Enemy_XVelHi,x
	;Set path data index based on parameter value
	lda MinecartOffsetData,y
	sta Enemy_Temp2,x
	;Init animation timer
	lda #$FF
	sta Enemy_Temp3,x
	;Next task ($02: Main)
	inc Enemy_Temp0,x
;$02: Main
Enemy4A_Sub2:
	;Update path
	jsr MinecartUpdatePath
	;Adjust player Y position for path direction change
	jmp Enemy4A_Sub5_AdjustCheck
MinecartUpdatePath:
	;Increment animation timer
	inc Enemy_Temp3,x
	;If animation timer $10, increment path data index and reset animation timer
	lda Enemy_Temp3,x
	cmp #$10
	bne MinecartUpdatePath_NoC
	;Increment path data index
	inc Enemy_Temp2,x
	;Reset animation timer
	lda #$00
	sta Enemy_Temp3,x
MinecartUpdatePath_NoC:
	;If bits 0-1 of animation timer not 0, exit early
	and #$03
	bne Enemy4A_Sub6
	;Check for slow minecarts
	lda Enemy_Temp1,x
	cmp #$09
	bcc MinecartUpdatePath_Fast
	;If bit 2 of animation timer not 0, exit early
	lda Enemy_Temp3,x
	and #$04
	bne Enemy4A_Sub6
MinecartUpdatePath_Fast:
	;Get next path segment direction
	lda Enemy_Temp3,x
	lsr
	lsr
	tay
	lda CollSet3Table,y
	sta $00
	ldy Enemy_Temp2,x
	lda MinecartPathData,y
	and $00
	;Check for left direction
	beq MinecartUpdatePath_Left
	;Check for down direction
	sta $00
	and #$AA
	beq MinecartUpdatePath_Down
	;Check for up direction
	lda $00
	and #$55
	beq MinecartUpdatePath_Up
	;Check if moving left or right
	lda Enemy_XVelHi,x
	bpl MinecartUpdatePath_LeftX
	;Set enemy X acceleration right
	lda #$7F
	bne MinecartUpdatePath_SetX
MinecartUpdatePath_LeftX:
	;Set enemy X acceleration left
	lda #$80
MinecartUpdatePath_SetX:
	sta Enemy_XAccel,x
	;Next task ($03: Slow init)
	inc Enemy_Temp0,x
	;Play sound
	ldy #SE_MINECARTSLOW
	jmp LoadSound
MinecartUpdatePath_Up:
	;If enemy Y velocity $F8, exit early
	lda Enemy_YVelHi,x
	cmp #$F8
	beq Enemy4A_Sub3_Exit
	;Set enemy Y velocity up
	lda #$F8
	bne MinecartUpdatePath_SetY
MinecartUpdatePath_Down:
	;If enemy Y velocity $08, exit early
	lda Enemy_YVelHi,x
	cmp #$08
	beq Enemy4A_Sub3_Exit
	;Set enemy Y velocity down
	lda #$08
	bne MinecartUpdatePath_SetY
MinecartUpdatePath_Left:
	;If enemy Y velocity 0, exit early
	lda Enemy_YVelHi,x
	beq Enemy4A_Sub3_Exit
	;Clear enemy Y velocity
	lda #$00
MinecartUpdatePath_SetY:
	;Set player Y position adjust amount
	sta $00
	sec
	sbc Enemy_YVelHi,x
	sta Enemy_Temp4,x
	;Set enemy Y velocity
	tay
	lda $00
	sta Enemy_YVelHi,x
	;If current direction is not down and previous direction is down, play sound
	cmp #$F8
	beq Enemy4A_Sub3_Exit
	cpy #$F8
	bne Enemy4A_Sub3_Exit
	;Play sound
	ldy #SE_MINECARTMOVE
	jmp LoadSound
;$03: Slow init
Enemy4A_Sub3:
	;Check for enemy X velocity 0
	lda Enemy_XVelHi,x
	beq Enemy4A_Sub3_Right
	;Check for enemy X velocity $FF
	cmp #$FF
	beq Enemy4A_Sub3_Left
Enemy4A_Sub3_Exit:
	rts
Enemy4A_Sub3_Right:
	;Set enemy X velocity right
	lda #$01
	sta Enemy_XVelHi,x
Enemy4A_Sub3_Left:
	;Clear enemy X velocity/acceleration
	lda #$00
	sta Enemy_XVelLo,x
	sta Enemy_XAccel,x
	;Init animation timer
	lda #$20
	sta Enemy_Temp6,x
	;Next task ($04: Slow)
	inc Enemy_Temp0,x
	rts
;$04: Slow
Enemy4A_Sub4:
	;Decrement animation timer, check if 0
	dec Enemy_Temp6,x
	bne Enemy4A_Sub5_Exit
	;Check for slow minecarts
	lda Enemy_Temp1,x
	cmp #$09
	bcs Enemy4A_Sub4_Slow
	;Set enemy flags
	lda #(EF_ACTIVE|EF_NOANIM|EF_VISIBLE)
	sta Enemy_Flags,x
	;Set enemy Y acceleration
	lda #$7F
	sta Enemy_YAccel,x
	;Next task ($06: Fall)
	lda #$06
	sta Enemy_Temp0,x
	rts
Enemy4A_Sub4_Slow:
	;Check for last minecart
	cmp #$0F
	beq Enemy4A_Sub5_Exit
	;Clear enemy velocity/acceleration
	jsr ClearEnemy_ClearXY
	;Reset animation timer
	lda #$20
	sta Enemy_Temp6,x
	;Next task ($05: Stop)
	inc Enemy_Temp0,x
	;Play sound
	ldy #SE_CRASH
	jsr LoadSound
	;Set enemy animation
	ldy #$E4
	jmp SetEnemyAnimation
;$05: Stop
Enemy4A_Sub5:
	;Decrement animation timer, check if 0
	dec Enemy_Temp6,x
	bne Enemy4A_Sub5_Exit
	;Clear enemy flags
	lda #$00
	sta Enemy_Flags,x
	rts
Enemy4A_Sub5_AdjustCheck:
	;Check to adjust player Y position
	lda Enemy_Temp4,x
	beq Enemy4A_Sub5_Exit
	;Check for collision
	jsr PlatformCheckCollision
	bne Enemy4A_Sub5_NoAdjust
	;Adjust player Y position
	lda Enemy_Y
	clc
	adc Enemy_Temp4,x
	sta Enemy_Y
Enemy4A_Sub5_NoAdjust:
	;Clear player Y position adjust amount
	lda #$00
	sta Enemy_Temp4,x
Enemy4A_Sub5_Exit:
	rts
MinecartProps:
	.db $00,$40,$00,$00,$40,$00,$00,$40,$00,$00,$00,$00,$00,$00,$00,$00
MinecartOffsetData:
	.db $00,$2E,$48,$64,$78,$86,$96,$9E,$A0,$A4,$A4,$B8,$B8,$B8,$B8,$B8
MinecartPathData:
	;$00
	.db $00,$50,$00,$80,$02,$00,$00,$00,$00,$00,$00,$50,$00,$80,$02,$00
	.db $00,$00,$00,$50,$00,$A0,$00,$05,$00,$A0,$08,$00,$00,$00,$00,$01
	.db $40,$00,$10,$A0,$00,$50,$00,$0A,$80,$00,$04,$50,$00,$8C
	;$2E
	.db $00,$00,$05,$08,$00,$02,$80,$00,$00,$00,$00,$10,$05,$00,$A0,$00
	.db $05,$00,$0A,$20,$00,$01,$50,$00,$0A,$0C
	;$48
	.db $00,$00,$00,$01,$40,$00,$10,$A0,$00,$50,$00,$0A,$80,$00,$04,$50
	.db $00,$A0,$00,$05,$00,$a0,$08,$00,$00,$00,$00,$03
	;$64
	.db $00,$80,$02,$00,$00,$50,$00,$0A,$80,$00,$04,$05,$00,$A0,$08,$01
	.db $40,$00,$10,$8C
	;$78
	.db $00,$20,$00,$01,$50,$08,$00,$02,$80,$10,$05,$00,$A0,$0C
	;$86
	.db $00,$01,$40,$00,$10,$0A,$80,$00,$04,$05,$00,$A0,$08,$00,$00,$03
	;$96
	.db $00,$80,$02,$00,$00,$50,$00,$8C
	;$9E
	.db $00,$0C
	;$A0
	.db $00,$00,$00,$0C
	;$A4
	.db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.db $00,$00,$00,$00
	;$B8
	.db $00,$00,$00,$00,$C0

;$4F: Boss missile homing
Enemy4F:
	;Set enemy acceleration
	jsr BossMissileHomingSetAccel
	;Set enemy animation
	jmp BossMissileHomingSetAnim
BossMissileHomingSetAccel:
	;Check if player is to left or right
	lda Enemy_X,x
	cmp Enemy_X
	bcc BossMissileHomingSetAccel_RightCheck
	;If enemy X velocity not 0, set enemy X acceleration left
	lda Enemy_XVelLo,x
	bne BossMissileHomingSetAccel_Left
	;If enemy X velocity $FE, clear enemy X acceleration
	lda Enemy_XVelHi,x
	cmp #$FE
	beq BossMissileHomingSetAccel_ClearX
BossMissileHomingSetAccel_Left:
	;Set enemy X acceleration left
	lda #$F8
	bne BossMissileHomingSetAccel_SetX
BossMissileHomingSetAccel_RightCheck:
	;If enemy X velocity $02, clear enemy X acceleration
	lda Enemy_XVelHi,x
	cmp #$02
	beq BossMissileHomingSetAccel_ClearX
	;Set enemy X acceleration right
	lda #$08
	bne BossMissileHomingSetAccel_SetX
BossMissileHomingSetAccel_ClearX:
	;Clear enemy X acceleration
	lda #$00
BossMissileHomingSetAccel_SetX:
	sta Enemy_XAccel,x
	;Check if player is to top or bottom
	lda Enemy_Y,x
	cmp Enemy_Y
	bcc BossMissileHomingSetAccel_DownCheck
	;If enemy Y velocity not 0, set enemy X acceleration up
	lda Enemy_YVelLo,x
	bne BossMissileHomingSetAccel_Up
	;If enemy Y velocity $FE, clear enemy Y acceleration
	lda Enemy_YVelHi,x
	cmp #$FE
	beq BossMissileHomingSetAccel_ClearY
BossMissileHomingSetAccel_Up:
	;Set enemy Y acceleration up
	lda #$F8
	bne BossMissileHomingSetAccel_SetY
BossMissileHomingSetAccel_DownCheck:
	;If enemy Y velocity $02, clear enemy Y acceleration
	lda Enemy_YVelHi,x
	cmp #$02
	beq BossMissileHomingSetAccel_ClearY
	;Set enemy Y acceleration down
	lda #$08
	bne BossMissileHomingSetAccel_SetY
BossMissileHomingSetAccel_ClearY:
	;Clear enemy Y acceleration
	lda #$00
BossMissileHomingSetAccel_SetY:
	sta Enemy_YAccel,x
	rts
BossMissileHomingSetAnim:
	;Get animation data index based on enemy velocity
	lda Enemy_XVelHi,x
	clc
	adc #$02
	cmp #$04
	bcc BossMissileHomingSetAnim_NoXC
	lda #$03
BossMissileHomingSetAnim_NoXC:
	sta $00
	lda Enemy_YVelHi,x
	clc
	adc #$02
	cmp #$04
	bcc BossMissileHomingSetAnim_NoYC
	lda #$03
BossMissileHomingSetAnim_NoYC:
	asl
	asl
	clc
	adc $00
	tay
	;Set enemy props
	lda BossMissileHomingProps,y
	sta Enemy_Props,x
	;Set enemy sprite
	lda BossMissileHomingSprite,y
	sta Enemy_SpriteLo,x
	rts
BossMissileHomingProps:
	.db $40,$40,$00,$00
	.db $40,$40,$00,$00
	.db $C0,$C0,$80,$80
	.db $C0,$C0,$80,$80
BossMissileHomingSprite:
	.db $3A,$38,$38,$3A
	.db $3C,$3A,$3A,$3C
	.db $3C,$3A,$3A,$3C
	.db $3A,$38,$38,$3A

;$50: Level 4 boss fire
Enemy50:
	;If enemy Y velocity $05, flip enemy Y acceleration
	lda Enemy_YVelLo,x
	bne Enemy50_Exit
	lda Enemy_YVelHi,x
	cmp #$05
	beq Enemy50_FlipY
	;If enemy Y velocity $FB, flip enemy Y acceleration
	cmp #$FB
	bne Enemy50_Exit
Enemy50_FlipY:
	;Flip enemy Y acceleration
	lda Enemy_YAccel,x
	eor #$80
	sta Enemy_YAccel,x
Enemy50_Exit:
	rts

;$51: Level 4 boss part 1
Enemy51:
	;Do jump table
	lda Enemy_Temp1,x
	jsr DoJumpTable
Enemy51JumpTable:
	.dw Enemy51_Sub0	;$00  Top shooter
	.dw Enemy51_Sub1	;$01  Bottom shooter
	.dw Enemy51_Sub2	;$02  Sattelite dish
;$00: Top shooter
Enemy51_Sub0:
	;Set enemy X position
	lda #$37
	jsr Level4BossSetXPos
	;Do jump table
	lda Enemy_Temp0+$03
	jsr DoJumpTable
Enemy51TopJumpTable:
	.dw Enemy51_Top_Sub0	;$00  Init
	.dw Enemy51_Top_Sub1	;$01  Main
;$00: Init
Enemy51_Top_Sub0:
	;Set enemy collision size
	lda #$08
	sta Enemy_CollWidth+$03
	sta Enemy_CollHeight+$03
	;Init shooting timer
	lda #$C0
	sta Enemy_Temp2+$03
	;Next task ($01: Main)
	inc Enemy_Temp0+$03
Enemy51_Top_Sub0_Exit:
	rts
;$01: Main
Enemy51_Top_Sub1:
	;Decrement shooting timer, check if 0
	dec Enemy_Temp2+$03
	bne Enemy51_Top_Sub0_Exit
	;Reset shooting timer
	lda #$20
	sta Enemy_Temp2+$03
	;If not visible, exit early
	lda Enemy_Flags+$03
	and #EF_VISIBLE
	beq Enemy51_Top_Sub0_Exit
	;If missle active, exit early
	lda Enemy_Flags+$02
	bne Enemy51_Top_Sub0_Exit
	;If enemy X position >= $E0, exit early
	lda Enemy_X+$03
	cmp #$E0
	bcs Enemy51_Top_Sub0_Exit
	;Spawn enemy
	lda #$00
	sta $00
	sta $01
	ldy #$02
	lda #$79
	jsr SpawnEnemy
	;Set enemy velocity
	lda #$01
	sta Enemy_XVelHi+$02
	lda #$FF
	sta Enemy_YVelHi+$02
	;Set enemy ID to boss missile homing
	lda #ENEMY_BOSSMISSILEHOMING
	sta Enemy_ID+$02
	;Reset shooting timer
	lda #$80
	sta Enemy_Temp2+$03
	rts
;$01: Bottom shooter
Enemy51_Sub1:
	;Set enemy X position
	lda #$37
	jsr Level4BossSetXPos
	;Do jump table
	lda Enemy_Temp0+$04
	jsr DoJumpTable
Enemy51BottomJumpTable:
	.dw Enemy51_Bottom_Sub0	;$00  Init
	.dw Enemy51_Bottom_Sub1	;$01  Shoot part 1
	.dw Enemy51_Bottom_Sub2	;$02  Shoot part 2
	.dw Enemy51_Bottom_Sub3	;$03  Shoot part 3
;$00: Init
Enemy51_Bottom_Sub0:
	;Set enemy collision size
	lda #$08
	sta Enemy_CollWidth+$04
	sta Enemy_CollHeight+$04
	;Set enemy HP
	lda #$60
	sta Enemy_HP+$04
	;Next task ($01: Shoot part 1)
	inc Enemy_Temp0+$04
Enemy51_Bottom_Sub0_Exit:
	rts
;$01: Shoot part 1
Enemy51_Bottom_Sub1:
	;Decrement shooting timer, check if 0
	dec Enemy_Temp2+$04
	bne Enemy51_Bottom_Sub0_Exit
	;Reset shooting timer
	lda #$20
	sta Enemy_Temp2+$04
	;If enemy X position >= $C0, exit early
	lda Enemy_X+$04
	cmp #$C0
	bcs Enemy51_Bottom_Sub0_Exit
	;Reset shooting timer
	lda #$0C
	sta Enemy_Temp2+$04
	;Next task ($01: Shoot part 2)
	inc Enemy_Temp0+$04
	;Play sound
	ldy #SE_MACHINEGUN
	jsr LoadSound
	;Spawn projectiles
	ldy #$05
	bne Enemy51_Bottom_Sub3_SpawnLoop
;$02: Shoot part 2
Enemy51_Bottom_Sub2:
	;Decrement shooting timer, check if 0
	dec Enemy_Temp2+$04
	bne Enemy51_Bottom_Sub0_Exit
	;Reset shooting timer
	lda #$0C
	sta Enemy_Temp2+$04
	;Next task ($01: Shoot part 3)
	inc Enemy_Temp0+$04
	;Spawn projectiles
	ldy #$07
	bne Enemy51_Bottom_Sub3_SpawnLoop
;$03: Shoot part 3
Enemy51_Bottom_Sub3:
	;Decrement shooting timer, check if 0
	dec Enemy_Temp2+$04
	bne Enemy51_Bottom_Sub0_Exit
	;Next task ($01: Shoot part 1)
	lda #$01
	sta Enemy_Temp0+$04
	;Reset shooting timer
	lda #$68
	sta Enemy_Temp2+$04
	;Spawn projectiles
	ldy #$09
Enemy51_Bottom_Sub3_SpawnLoop:
	;If boss not in phase 2, spawn enemy
	lda Enemy_Temp0+$0C
	cmp #$04
	bcc Enemy51_Bottom_Sub3_Spawn
	;If not visible, exit early
	lda Enemy_Flags+$04
	and #EF_VISIBLE
	beq Enemy51_Bottom_Sub0_Exit
Enemy51_Bottom_Sub3_Spawn:
	;Spawn enemy
	lda #$00
	sta $00
	sta $01
	lda #$59
	jsr SpawnEnemy
	;Set enemy X velocity
	lda #$02
	sta Enemy_XVelHi,y
	;Set enemy Y velocity/acceleration
	lda Level4BossFireYVel-5,y
	sta Enemy_YVelHi,y
	lda Level4BossFireYAccel-5,y
	sta Enemy_YAccel,y
	;Set enemy ID to level 4 boss fire
	lda #ENEMY_LEVEL4BOSSFIRE
	sta Enemy_ID,y
	;Loop for each projectile
	iny
	tya
	lsr
	bcc Enemy51_Bottom_Sub3_SpawnLoop
	rts
Level4BossFireYVel:
	.db $FB,$05,$FB,$05,$FB,$05
Level4BossFireYAccel:
	.db $40,$C0,$40,$C0,$40,$C0
;$02: Satellite dish
Enemy51_Sub2:
	;Set enemy X position
	lda #$47
	jsr Level4BossSetXPos
	;Check if already inited
	lda Enemy_Temp0+$0B
	bne Enemy51_Sub2_Exit
	;Mark inited
	inc Enemy_Temp0+$0B
	;Set enemy HP
	lda #$06
	sta Enemy_HP+$0B
	;Set enemy animation
	ldy #$7D
	jmp SetEnemyAnimation
Enemy51_Sub2_Exit:
	rts

;$4E: Level 4 boss part 2
Enemy4E:
	;Do subroutines
	jsr Enemy4E_DoSub
	;Set enemy X position
	lda #$54
	jsr Level4BossSetXPos
	;Check parts
	jmp Level4BossCheckParts
Enemy4E_DoSub:
	;Do jump table
	lda Enemy_Temp0+$0C
	jsr DoJumpTable
Enemy4EJumpTable:
	.dw Enemy4E_Sub0	;$00  Init
	.dw Enemy4E_Sub1	;$01  Forward
	.dw Enemy4E_Sub2	;$02  Idle
	.dw Enemy4E_Sub3	;$03  Backward
	.dw Enemy4E_Sub4	;$04  Quake
	.dw Enemy4E_Sub5	;$05  Charge forward part 1
	.dw Enemy4E_Sub6	;$06  Charge forward part 2
	.dw Enemy4E_Sub7	;$07  Charge backward
	.dw Enemy4E_Sub8	;$08  Open mouth
	.dw Enemy4E_Sub9	;$09  Shoot laser init
	.dw Enemy4E_SubA	;$0A  Shoot laser
	.dw Enemy4E_SubB	;$0B  Clear laser init
	.dw Enemy4E_SubA	;$0C  Clear laser
	.dw Enemy4E_SubD	;$0D  Close mouth
;$00: Init
Enemy4E_Sub0:
	;Set boss enemy slot index
	lda #$0C
	sta BossEnemyIndex
	;Next task ($01: Forward
	inc Enemy_Temp0+$0C
Enemy4E_Sub0_Exit:
	rts
;$01: Forward
Enemy4E_Sub1:
	;If sattelite dish not active, start phase 2
	lda Enemy_Flags+$0B
	beq Enemy4E_Sub3_Phase2
	;Increment animation timer
	inc Enemy_Temp1+$0C
	;If bits 0-1 of animation timer not 0, exit early
	lda Enemy_Temp1+$0C
	and #$03
	bne Enemy4E_Sub0_Exit
	;Move tank right $01
	lda #$FF
	jsr Level4BossMoveTank
	;If tank scroll X position not 0, exit early
	lda TempIRQBufferScrollX
	bne Enemy4E_Sub0_Exit
	;Reset animation timer
	lda #$80
	sta Enemy_Temp1+$0C
	;Next task ($02: Idle)
	inc Enemy_Temp0+$0C
	rts
;$02: Idle
Enemy4E_Sub2:
	;If sattelite dish not active, start phase 2
	lda Enemy_Flags+$0B
	beq Enemy4E_Sub3_Phase2
	;Decrement animation timer, check if 0
	dec Enemy_Temp1+$0C
	bne Enemy4E_Sub0_Exit
	;Next task ($03: Backward)
	inc Enemy_Temp0+$0C
	rts
;$03: Backward
Enemy4E_Sub3:
	;If sattelite dish not active, start phase 2
	lda Enemy_Flags+$0B
	beq Enemy4E_Sub3_Phase2
	;Increment animation timer
	inc Enemy_Temp1+$0C
	;If bits 0-1 of animation timer not 0, exit early
	lda Enemy_Temp1+$0C
	and #$03
	bne Enemy4E_Sub0_Exit
	;Move tank left $01
	lda #$01
	jsr Level4BossMoveTank
	;If tank scroll X position not $30, exit early
	lda TempIRQBufferScrollX
	cmp #$30
	bne Enemy4E_Sub0_Exit
	;Next task ($01: Forward)
	lda #$01
	sta Enemy_Temp0+$0C
Enemy4E_Sub3_Exit:
	rts
Enemy4E_Sub3_Phase2:
	;Clear bits 0-1 of tank scroll X position
	lda TempIRQBufferScrollX
	and #$FC
	sta TempIRQBufferScrollX
	;Reset animation timer
	lda #$C0
	sta Enemy_Temp1+$0C
	;Next task ($04: Quake)
	lda #$04
	sta Enemy_Temp0+$0C
	;Play sound
	ldy #SE_HYPNOTIZE
	jmp LoadSound
;$04: Quake
Enemy4E_Sub4:
	;Set tank scroll X position to quake left/right
	lda TempIRQBufferScrollX
	eor #$02
	sta TempIRQBufferScrollX
	;Decrement animation timer, check if 0
	dec Enemy_Temp1+$0C
	bne Enemy4E_Sub3_Exit
	;Clear bits 0-1 of tank scroll X position
	lda TempIRQBufferScrollX
	and #$FC
	sta TempIRQBufferScrollX
	;Next task ($05: Charge forward part 1)
	inc Enemy_Temp0+$0C
	;Play sound
	ldy #SE_BLAST
	jmp LoadSound
;$05: Charge forward part 1
Enemy4E_Sub5:
	;Move tank right $04
	lda #$FC
	jsr Level4BossMoveTank
	;If tank scroll X position not $FC, exit early
	lda TempIRQBufferScrollX
	cmp #$FC
	bne Enemy4E_Sub3_Exit
	;Swap nametable
	lda #$20
	sta TempIRQBufferScrollHi
	;Next task ($06: Charge forward part 2)
	inc Enemy_Temp0+$0C
	rts
;$06: Charge forward part 2
Enemy4E_Sub6:
	;Move tank right $04
	lda #$FC
	jsr Level4BossMoveTank
	;If tank scroll X position not 0, exit early
	lda TempIRQBufferScrollX
	bne Enemy4E_Sub3_Exit
	;Next task ($07: Charge backward)
	inc Enemy_Temp0+$0C
	rts
;$07: Charge backward
Enemy4E_Sub7:
	;Move tank left $04
	lda #$04
	jsr Level4BossMoveTank
	;If tank scroll X position not $FC, exit early
	lda TempIRQBufferScrollX
	cmp #$FC
	bne Enemy4E_Sub3_Exit
	;Reset animation timer
	lda #$A0
	sta Enemy_Temp1+$0C
	;Next task ($08: Open mouth)
	inc Enemy_Temp0+$0C
	rts
;$08: Open mouth
Enemy4E_Sub8:
	;Decrement animation timer, check if 0
	dec Enemy_Temp1+$0C
	beq Enemy4E_Sub8_Spawn
	;If animation timer $10, draw ship mouth open 3 metatile
	lda Enemy_Temp1+$0C
	cmp #$10
	beq Enemy4E_Sub8_Open3
	;If animation timer $20, draw ship mouth open 2 metatile
	cmp #$20
	beq Enemy4E_Sub8_Open2
	;If animation timer $30, draw ship mouth open 1 metatile
	cmp #$30
	bne Enemy4E_Sub3_Exit
	;Play sound
	ldy #SE_WHIRLONG
	jsr LoadSound
	;Draw ship mouth open 1 metatile
	lda #$68
	bne Enemy4E_Sub8_Draw
Enemy4E_Sub8_Open2:
	;Draw ship mouth open 2 metatile
	lda #$67
	bne Enemy4E_Sub8_Draw
Enemy4E_Sub8_Open3:
	;Draw ship mouth open 3 metatile
	lda #$5F
Enemy4E_Sub8_Draw:
	ldy UpdateMetatileCount
	sta UpdateMetatileID,y
	lda #$1A
	sta UpdateMetatilePos,y
	lda #$01
	sta UpdateMetatileProps,y
	inc UpdateMetatileCount
	rts
Enemy4E_Sub8_Spawn:
	;Spawn enemy
	lda #$02
	sta $00
	lda #$1B
	sta $01
	ldy #$0B
	lda #$7F
	jsr SpawnEnemy
	;Set enemy priority to be behind background
	lda #$20
	sta Enemy_Props+$0B
	;Reset animation timer
	lda #$20
	sta Enemy_Temp1+$0C
	;Next task ($09: Shoot laser init)
	inc Enemy_Temp0+$0C
	rts
;$09: Shoot laser init
Enemy4E_Sub9:
	;Decrement animation timer, check if 0
	dec Enemy_Temp1+$0C
	beq Enemy4E_Sub9_Spawn
	;If animation timer $10, clear enemy visible flag
	lda Enemy_Temp1+$0C
	cmp #$10
	bne Enemy4E_Sub9_Exit
	;Clear enemy visible flag
	lda #(EF_ACTIVE|EF_NOANIM|EF_HITENEMY)
	sta Enemy_Flags+$0B
Enemy4E_Sub9_Exit:
	rts
Enemy4E_Sub9_Spawn:
	;Set enemy visible flag
	lda #(EF_ACTIVE|EF_NOANIM|EF_HITENEMY|EF_VISIBLE)
	sta Enemy_Flags+$0B
	;Set enemy sprite
	lda #$14
	sta Enemy_SpriteLo+$0B
	;Spawn enemy
	lda #$06
	sta $00
	lda #$1B
	sta $01
	ldy #$01
	lda #$53
	jsr SpawnEnemy
	;Set enemy X velocity
	lda #$08
	sta Enemy_XVelHi+$01
	;Set laser VRAM address low
	lda #$8C
	sta Enemy_Temp2+$0C
	;Set laser direction
	lda #$03
	sta Enemy_Temp3+$0C
	;Next task ($0A: Shoot laser)
	inc Enemy_Temp0+$0C
	;Play sound
	ldy #SE_WHIRLASER1
	jmp LoadSound
;$0A: Shoot laser
;$0C: Clear laser
Enemy4E_SubA:
	;Init VRAM buffer column
	jsr WriteVRAMBufferCmd_InitCol
	;Set VRAM buffer address
	lda Enemy_Temp2+$0C
	sta VRAMBuffer,x
	inx
	lda #$25
	sta VRAMBuffer,x
	inx
	;Check to shoot or clear laser
	tay
	lda Enemy_Temp3+$0C
	bne Enemy4E_SubA_Shoot
	;Set blank tiles in VRAM
	lda #$00
	sta VRAMBuffer,x
	inx
	sta VRAMBuffer,x
	inx
	sta VRAMBuffer,x
	inx
	bne Enemy4E_SubA_End
Enemy4E_SubA_Shoot:
	;Set laser tiles in VRAM
	lda #$7E
	sta VRAMBuffer,x
	inx
	lda #$7D
	sta VRAMBuffer,x
	inx
	lda #$7C
	sta VRAMBuffer,x
	inx
Enemy4E_SubA_End:
	;End VRAM buffer
	jsr WriteVRAMBufferCmd_End
	;Draw collision tile column
	lda #$03
	sta $00
	lda Enemy_Temp3+$0C
	sta $02
	lda Enemy_Temp2+$0C
	sta $01
	jsr DrawCollisionTileCol
	;Restore X register
	ldx #$0C
	;Increment laser VRAM address
	inc Enemy_Temp2+$0C
	;If laser VRAM address low not $A0, exit early
	lda Enemy_Temp2+$0C
	cmp #$A0
	bne Enemy4E_SubB_Exit
	;Next task ($0B: Clear laser init)
	inc Enemy_Temp0+$0C
	;Reset animation timer
	lda #$20
	sta Enemy_Temp1+$0C
	;Check for clear laser init mode
	lda Enemy_Temp0+$0C
	cmp #$0B
	beq Enemy4E_SubA_Exit
	;Reset animation timer
	lda #$40
	sta Enemy_Temp1+$0C
Enemy4E_SubA_Exit:
	rts
;$0B: Clear laser init
Enemy4E_SubB:
	;Decrement animation timer, check if 0
	dec Enemy_Temp1+$0C
	bne Enemy4E_SubB_Exit
	;Set enemy sprite
	lda #$12
	sta Enemy_SpriteLo+$0B
	;Set enemy X velocity
	lda #$08
	sta Enemy_XVelHi+$0B
	;Set enemy props
	lda #$40
	sta Enemy_Props+$0B
	;Set laser VRAM address low
	lda #$8C
	sta Enemy_Temp2+$0C
	;Set laser direction
	lda #$00
	sta Enemy_Temp3+$0C
	;Next task ($0C: Clear laser)
	inc Enemy_Temp0+$0C
Enemy4E_SubB_Exit:
	rts
;$0D: Close mouth
Enemy4E_SubD:
	;Decrement animation timer, check if 0
	dec Enemy_Temp1+$0C
	beq Enemy4E_SubD_Next
	;If animation timer $10, draw ship mouth close 3 metatile
	lda Enemy_Temp1+$0C
	cmp #$10
	beq Enemy4E_SubD_Close3
	;If animation timer $20, draw ship mouth close 2 metatile
	cmp #$20
	beq Enemy4E_SubD_Close2
	;If animation timer $30, draw ship mouth close 1 metatile
	cmp #$30
	bne Enemy4E_SubB_Exit
	;Play sound
	ldy #SE_WHIRLONG
	jsr LoadSound
	;Draw ship mouth close 1 metatile
	lda #$67
	jmp Enemy4E_Sub8_Draw
Enemy4E_SubD_Close2:
	;Draw ship mouth close 2 metatile
	lda #$68
	jmp Enemy4E_Sub8_Draw
Enemy4E_SubD_Close3:
	;Draw ship mouth close 3 metatile
	lda #$63
	jmp Enemy4E_Sub8_Draw
Enemy4E_SubD_Next:
	;Next task ($06: Charge forward part 2)
	lda #$06
	sta Enemy_Temp0+$0C
	;Play sound
	ldy #SE_BLAST
	jmp LoadSound
Level4BossSetXPos:
	;Set enemy X position based on tank scroll X position
	sec
	sbc TempIRQBufferScrollX
	sta Enemy_X,x
	;Check if offscreen
	bcc Level4BossSetXPos_XC
	lda TempIRQBufferScrollHi
	cmp #$24
	beq Level4BossSetXPos_NoXC
	bne Level4BossSetXPos_ClearF
Level4BossSetXPos_XC:
	lda TempIRQBufferScrollHi
	cmp #$24
	beq Level4BossSetXPos_ClearF
Level4BossSetXPos_NoXC:
	;If enemy lifetime not 0, exit early
	lda Enemy_Temp5,x
	bne Level4BossSetXPos_Exit
	;Set enemy visible flag
	lda Enemy_Flags,x
	ora #EF_VISIBLE
	sta Enemy_Flags,x
	rts
Level4BossSetXPos_ClearF:
	lda Enemy_Flags,x
	and #~EF_VISIBLE
	sta Enemy_Flags,x
Level4BossSetXPos_Exit:
	rts
Level4BossMoveTank:
	;Set tank scroll X position
	tay
	clc
	adc TempIRQBufferScrollX
	sta TempIRQBufferScrollX
	;Get CHR bank animation mask index
	iny
	iny
	iny
	iny
	;If bits of global timer not 0, exit early
	lda Level4BossTankAnimMask,y
	and LevelGlobalTimer
	bne Level4BossSetXPos_Exit
	;Load CHR bank
	lda TempCHRBanks+1
	eor #$02
	sta TempCHRBanks+1
	rts
Level4BossTankAnimMask:
	.db $03,$03,$00,$00,$FF,$00,$00,$03,$03
Level4BossCheckParts:
	;If a boss part is still active, exit early
	lda Enemy_Flags+$03
	ora Enemy_Flags+$04
	ora Enemy_Flags+$0B
	bne Level4BossSetXPos_Exit
	;Set enemy hit bullet flag
	lda Enemy_Flags+$0C
	ora #EF_HITBULLET
	sta Enemy_Flags+$0C
	rts

;$55: Behind BG area/BG glass pipe
Enemy55:
	;Clear enemy flags
	lda #$00
	sta Enemy_Flags,x
	;Check for level 8
	lda CurLevel
	cmp #$07
	beq Enemy55_JT
	;Check if player Y position >= $60
	lda Enemy_Y
	cmp #$60
	bcs Enemy55_Bottom
	;If enemy Y position < $80, do jump table
	lda Enemy_Y,x
	bpl Enemy55_JT
	rts
Enemy55_Bottom:
	;If enemy Y position >= $80, do jump table
	lda Enemy_Y,x
	bmi Enemy55_JT
	rts
Enemy55_JT:
	;Do jump table
	lda Enemy_Temp1,x
	jsr DoJumpTable
Enemy55JumpTable:
	.dw Enemy55_Sub0	;$00  Behind right
	.dw Enemy55_Sub1	;$01  Behind left
	.dw Enemy55_Sub2	;$02  In front right
	.dw Enemy55_Sub3	;$03  In front left
	.dw Enemy55_Sub4	;$04  BG glass pipe
;$00: Behind right
Enemy55_Sub0:
	;If on right side of screen, set player priority to be behind background
	lda Enemy_X,x
	bmi Enemy55_Sub1_Back
	rts
;$01: Behind left
Enemy55_Sub1:
	;If on left side of screen, set player priority to be behind background
	lda Enemy_X,x
	bmi Enemy55_Sub3_Exit
Enemy55_Sub1_Back:
	;Set player priority to be behind background
	lda Enemy_Props
	ora #$20
	bne Enemy55_Sub3_SetP
;$02: In front right
Enemy55_Sub2:
	;If on right side of screen, set player priority to be in front of background
	lda Enemy_X,x
	bmi Enemy55_Sub3_Front
	rts
;$03: In front left
Enemy55_Sub3:
	;If on left side of screen, set player priority to be in front of background
	lda Enemy_X,x
	bmi Enemy55_Sub3_Exit
Enemy55_Sub3_Front:
	;Set player priority to be in front of background
	lda Enemy_Props
	and #$DF
Enemy55_Sub3_SetP:
	sta Enemy_Props
Enemy55_Sub3_Exit:
	rts
;$04: BG glass pipe
Enemy55_Sub4:
	;Set enemy flags
	lda #(EF_ACTIVE|EF_NOANIM|EF_HITENEMY|EF_VISIBLE)
	sta Enemy_Flags,x
	;Set enemy collision size
	lda #$18
	sta Enemy_CollWidth,x
	lda #$60
	sta Enemy_CollHeight,x
	rts

;$56: Conveyor
Enemy56:
	;Check if already inited
	lda Enemy_Temp0,x
	bne Enemy56_Main
	;Set enemy flags
	lda #(EF_ACTIVE|EF_NOANIM|EF_PLATFORM|EF_VISIBLE)
	sta Enemy_Flags,x
	;Set enemy collision width based on parameter value
	ldy Enemy_Temp1,x
	lda ConveyorCollWidth,y
	sta Enemy_CollWidth,x
	;Set enemy collision height
	lda #$08
	sta Enemy_CollHeight,x
	;Mark inited
	inc Enemy_Temp0,x
	;Check if moving left or right
	tya
	and #$01
	bne Enemy56_Left
	;Set enemy X velocity right
	lda #$01
	bne Enemy56_SetX
Enemy56_Left:
	;Set enemy X velocity left
	lda #$FF
Enemy56_SetX:
	sta Enemy_XVelHi,x
	rts
ConveyorCollWidth:
	.db $20,$20,$40,$40
Enemy56_Main:
	;Counteract enemy X velocity
	lda Enemy_X,x
	sec
	sbc Enemy_XVelHi,x
	sta Enemy_X,x
	;Check if moving left or right
	lda Enemy_XVelHi,x
	bmi Enemy56_LeftCheck
	;Check if offscreen (right)
	bcc Enemy56_ClearF
	rts
Enemy56_LeftCheck:
	;Check if offscreen (left)
	bcs Enemy56_ClearF
	rts
Enemy56_ClearF:
	;Clear enemy flags
	lda #$00
	sta Enemy_Flags,x
	rts

;$5B: Hypno frog
Enemy5B:
	;If hypno frog pod, exit early
	cpx #$03
	bne Enemy5B_Sub2
	;Do jump table
	lda Enemy_Temp0+$03
	jsr DoJumpTable
Enemy5BJumpTable:
	.dw Enemy5B_Sub0	;$00  Down beam
	.dw Enemy5B_Sub1	;$01  Down
	.dw Enemy5B_Sub2	;$02  Out
;$00: Down beam
Enemy5B_Sub0:
	;If enemy Y position not $10, exit early
	lda Enemy_Y+$03
	cmp #$10
	bne Enemy5B_Sub2
	;Next task ($01: Down)
	inc Enemy_Temp0+$03
	;Clear enemy flags
	lda #$00
	sta Enemy_Flags+$02
;$02: Out
Enemy5B_Sub2:
	rts
;$01: Down
Enemy5B_Sub1:
	;If enemy Y position not $20, exit early
	lda Enemy_Y+$03
	cmp #$20
	bne Enemy5B_Sub2
	;Next task ($02: Out)
	inc Enemy_Temp0+$03
	;Check for level 5 hypno Jenny area
	lda CurArea
	cmp #$68
	bne Enemy5B_Sub1_Left
	;Set enemy X velocity/acceleration right
	lda #$04
	ldy #$E0
	bne Enemy5B_Sub1_SetX
Enemy5B_Sub1_Left:
	;Set enemy X velocity/acceleration left
	lda #$FC
	ldy #$20
Enemy5B_Sub1_SetX:
	sta Enemy_XVelHi+$03
	sta Enemy_XVelHi+$04
	sty Enemy_XAccel+$03
	sty Enemy_XAccel+$04
	rts

;$5C: Hypno frog beam
Enemy5C:
	;Set enemy animation
	jsr HypnoFrogBeamSetAnim
	;Do jump table
	lda Enemy_Temp0+$02
	jsr DoJumpTable
Enemy5CJumpTable:
	.dw Enemy5C_Sub0	;$00  Init
	.dw Enemy5C_Sub1	;$01  Down
	.dw Enemy5C_Sub2	;$02  Up flash
	.dw Enemy5C_Sub2	;$03  Up
;$00: Init
Enemy5C_Sub0:
	;Init animation timer
	lda #$08
	sta Enemy_Temp2+$02
	;Next task ($01: Down)
	inc Enemy_Temp0+$02
Enemy5C_Sub0_Exit:
	rts
;$01: Down
Enemy5C_Sub1:
	;If enemy Y position not $60, exit early
	lda Enemy_Y+$02
	cmp #$60
	bne Enemy5C_Sub0_Exit
	;Clear enemy Y velocity
	lda #$00
	sta Enemy_YVelHi+$02
	;Next task ($02: Up flash)
	inc Enemy_Temp0+$02
	rts
;$02: Up flash
;$03: Up
Enemy5C_Sub2:
	;If animation timer not 0, exit early
	lda Enemy_Temp2+$02
	cmp #$08
	bne Enemy5C_Sub0_Exit
	;If animation frame counter 0, unflash hypno palette
	lda Enemy_Temp3+$02
	beq Enemy5C_Sub2_Unflash
	;If animation frame counter $02, flash hypno palette
	cmp #$02
	bne Enemy5C_Sub0_Exit
	;Load palette
	lda #$B9
	sta CurPalette
	rts
Enemy5C_Sub2_Unflash:
	;Set enemy sprite
	lda #$82
	sta Enemy_SpriteLo+$02
	;Check for up mode
	lda Enemy_Temp0+$02
	cmp #$03
	beq Enemy5C_Sub0_Exit
	;Load palette
	lda #$B6
	sta CurPalette
	rts
HypnoFrogBeamSetAnim:
	;Decrement animation timer, check if 0
	dec Enemy_Temp2+$02
	bne Enemy5C_Sub0_Exit
	;Reset animation timer
	lda #$08
	sta Enemy_Temp2+$02
	;Increment animation frame counter
	inc Enemy_Temp3+$02
	lda Enemy_Temp3+$02
	and #$03
	sta Enemy_Temp3+$02
	;Set enemy sprite
	tay
	lda HypnoFrogBeamSprite,y
	sta Enemy_SpriteLo+$02
	;Set enemy props
	lda HypnoFrogBeamProps,y
	sta Enemy_Props+$02
	rts
HypnoFrogBeamSprite:
	.db $7E,$7E,$80,$80
HypnoFrogBeamProps:
	.db $20,$60,$20,$60

;$5D: Hypno Jenny light ball
Enemy5D:
	;Do jump table
	lda Enemy_Temp0+$05
	jsr DoJumpTable
Enemy5DJumpTable:
	.dw Enemy5D_Sub0	;$00  Init
	.dw Enemy5D_Sub1	;$01  Grow
	.dw Enemy5D_Sub2	;$02  Main
;$00: Init
Enemy5D_Sub0:
	;Init animation timer
	lda #$08
	sta Enemy_Temp1+$05
	;Next task ($01: Grow)
	inc Enemy_Temp0+$05
Enemy5D_Sub0_Exit:
	rts
;$01: Grow
Enemy5D_Sub1:
	;Decrement animation timer, check if 0
	dec Enemy_Temp1+$05
	bne Enemy5D_Sub0_Exit
	;Set enemy animation
	lda Enemy_Anim+$05
	clc
	adc #$02
	cmp #$60
	beq Enemy5D_Sub1_Next
	tay
	jsr SetEnemyAnimation
	;Set enemy flags
	lda #(EF_ACTIVE|EF_HITENEMY|EF_VISIBLE)
	sta Enemy_Flags+$05
	;Reset animation timer
	lda #$08
	sta Enemy_Temp1+$05
	rts
Enemy5D_Sub1_Next:
	;Next task ($02: Main)
	inc Enemy_Temp0+$05
	rts
;$02: Main
Enemy5D_Sub2:
	;Set enemy acceleration
	jmp BossMissileHomingSetAccel

;$58: Hypno Jenny
Enemy58:
	;If enemy HP >= 0, do fight mode
	lda Enemy_HP+$01
	bpl Enemy58_Fight
	;If enemy Y acceleration 0, do rescue mode
	lda Enemy_YAccel+$01
	beq Enemy58_Rescue
Enemy58_Fight:
	;Update hypno teammate fight state
	jsr HypnoTeammateFight
	;Do jump table
	lda Enemy_Temp0+$01
	jsr DoJumpTable
Enemy58FightJumpTable:
	.dw Enemy58_Fight_Sub0	;$00  Init
	.dw Enemy58_Fight_Sub1	;$01  Back and forth
	.dw Enemy58_Fight_Sub2	;$02  Hypnotized
	.dw Enemy58_Fight_Sub3	;$03  Light ball bottom
	.dw Enemy58_Fight_Sub4	;$04  Run bottom
	.dw Enemy58_Fight_Sub5	;$05  Jump bottom to middle
	.dw Enemy58_Fight_Sub6	;$06  Light ball middle 1
	.dw Enemy58_Fight_Sub7	;$07  Jump middle to top
	.dw Enemy58_Fight_Sub8	;$08  Run top
	.dw Enemy58_Fight_Sub5	;$09  Jump top to middle
	.dw Enemy58_Fight_SubA	;$0A  Light ball middle 2
	.dw Enemy58_Fight_SubB	;$0B  Jump middle to bottom
Enemy58_Rescue:
	;Update hypno teammate rescue state
	jsr HypnoTeammateRescue
	;Do jump table
	lda Enemy_Temp2+$01
	jsr DoJumpTable
Enemy58RescueJumpTable:
	.dw Enemy58_Rescue_Sub0	;$00  Init
	.dw Enemy58_Rescue_Sub1	;$01  Jingle
	.dw Enemy58_Rescue_Sub2	;$02  Scroll right
	.dw Enemy58_Rescue_Sub3	;$03  Wait
	.dw Enemy58_Rescue_Sub4	;$04  Scroll left
;$00: Init
Enemy58_Rescue_Sub0:
	;Clear enemy X velocity
	lda #$00
	sta Enemy_XVelHi+$01
	;Clear enemy flags
	sta Enemy_Flags+$05
	;Load CHR bank
	lda #$52
	sta TempCHRBanks+4
	;Set enemy flags
	lda #(EF_ACTIVE|EF_NOANIM|EF_PRIORITY|EF_VISIBLE)
	sta Enemy_Flags+$01
	;Set enemy sprite
	lda #$28
	sta Enemy_SpriteLo+$01
	;Clear rescue text
	lda #$05
	sta UpdateVRAMStripCount
	jsr HypnoTeammateClearRescueText
	;Draw VRAM strip
	lda #$98
	sta UpdateVRAMStripID+4
	;Next task ($01: Jingle)
	inc Enemy_Temp2+$01
	;Set animation timer
	lda #$00
	sta Enemy_Temp1+$01
	rts
HypnoTeammateClearRescueText:
	;Draw VRAM strips
	lda #$96
	sta UpdateVRAMStripID
	lda #$97
	sta UpdateVRAMStripID+1
	lda #$9E
	sta UpdateVRAMStripID+2
	lda #$9F
	sta UpdateVRAMStripID+3
	rts
HypnoTeammateRescue:
	;Check if player is to left or right
	lda Enemy_X
	cmp Enemy_X+$01
	bcc HypnoTeammateRescue_Left
	;Set enemy props right
	lda #$22
	sta Enemy_Props+$01
	rts
HypnoTeammateRescue_Left:
	;Set enemy props left
	lda #$62
	sta Enemy_Props+$01
HypnoTeammateRescue_Exit:
	rts
;$01: Jingle
Enemy58_Rescue_Sub1:
	;Decrement animation timer, check if 0
	dec Enemy_Temp1+$01
	beq Enemy58_Rescue_Sub1_Next
	;If bits 0-3 of animation timer not 0, exit early
	lda Enemy_Temp1+$01
	and #$0F
	bne HypnoTeammateRescue_Exit
	;Flash palette
	lda CurPalette
	eor #$8F
	sta CurPalette
	rts
Enemy58_Rescue_Sub1_Next:
	;Load palette
	lda #$B6
	sta CurPalette
	;Next task ($02: Scroll right)
	inc Enemy_Temp2+$01
	;Clear sound
	jsr ClearSound
	;Load music
	ldy #MUSIC_RESCUE
	jmp LoadSound
;$02: Scroll right
Enemy58_Rescue_Sub2:
	;Scroll right $02
	inc TempIRQBufferScrollX
	inc TempIRQBufferScrollX
	;If scroll X position not 0, exit early
	bne HypnoTeammateRescue_Exit
	;Scroll left $02
	dec TempIRQBufferScrollX
	dec TempIRQBufferScrollX
	;Next task ($03: Wait)
	inc Enemy_Temp2+$01
	rts
;$03: Wait
Enemy58_Rescue_Sub3:
	;If bit 0 of global timer not 0, exit early
	lda LevelGlobalTimer
	and #$01
	bne HypnoTeammateRescue_Exit
	;Decrement animation timer, check if 0
	dec Enemy_Temp1+$01
	bne HypnoTeammateRescue_Exit
	;Next task ($04: Scroll left)
	inc Enemy_Temp2+$01
	rts
;$04: Scroll left
Enemy58_Rescue_Sub4:
	;Scroll left $02
	dec TempIRQBufferScrollX
	dec TempIRQBufferScrollX
	;If scroll X position not 0, exit early
	bne HypnoTeammateRescue_Exit
	;Clear enemy flags
	lda #$00
	sta Enemy_Flags+$01
	;Clear disable side exit flag
	sta DisableSideExitFlag
	;Enable character Jenny
	lda CharacterPowerMax+1
	ora #$80
	sta CharacterPowerMax+1
	;Set current screen
	lda #$2C
	sta CurScreen
	;Clear sound
	jsr ClearSound
	;Load music
	ldy #MUSIC_LEVEL5
	jmp LoadSound
;$00: Init
Enemy58_Fight_Sub0:
	;Set enemy props
	lda #$22
	sta Enemy_Props+$01
	;Set enemy tile offset
	lda #$80
	sta Enemy_Temp7+$1
	;Set enemy X velocity
	lda #$01
	sta Enemy_XVelHi+$01
	;Set disable side exit flag
	sta DisableSideExitFlag
	;Next task ($01: Back and forth)
	inc Enemy_Temp0+$01
	;Load music
	ldy #MUSIC_RESCUE
	jmp LoadSound
;$01: Back and forth
Enemy58_Fight_Sub1:
	;If player X position < $A8 and enemy X position $3C, setup next task ($02: Hypnotized)
	lda Enemy_X
	cmp #$A8
	bcs Enemy58_Fight_Sub1_NoNext
	lda Enemy_X+$01
	cmp #$3C
	beq Enemy58_Fight_Sub1_Next
Enemy58_Fight_Sub1_NoNext:
	;If enemy Y position $2C or $4C, flip enemy X
	lda Enemy_X+$01
	cmp #$4C
	beq HypnoTeammateFlipX
	cmp #$2C
	bne HypnoTeammateFlipX_Exit
HypnoTeammateFlipX:
	;Flip enemy X velocity
	lda Enemy_XVelHi+$01
	eor #$FF
	clc
	adc #$01
	sta Enemy_XVelHi+$01
	;Flip enemy X
	lda Enemy_Props+$01
	eor #$40
	sta Enemy_Props+$01
HypnoTeammateFlipX_Exit:
	rts
Enemy58_Fight_Sub1_Next:
	;Set enemy props
	lda #$22
	sta Enemy_Props+$01
	;Set enemy flags
	lda #(EF_ACTIVE|EF_NOANIM|EF_PRIORITY|EF_VISIBLE)
	sta Enemy_Flags+$01
	;Set enemy sprite
	lda #$28
	sta Enemy_SpriteLo+$01
HypnoTeammateSpawnFrogBeam:
	;Clear enemy X velocity
	lda #$00
	sta Enemy_XVelHi+$01
	;Spawn enemy
	sta $00
	sta $01
	ldy #$02
	lda #$9B
	jsr SpawnEnemy
	;Set enemy position
	lda #$3C
	sta Enemy_X+$02
	lda #$20
	sta Enemy_Y+$02
	;Set enemy Y velocity
	lda #$04
	sta Enemy_YVelHi+$02
	;Set enemy priority to be behind background
	lda #$20
	sta Enemy_Props+$02
	;Set enemy ID to hypno frog beam
	lda #ENEMY_HYPNOFROGBEAM
	sta Enemy_ID+$02
	;Init animation timer
	lda #$40
	sta Enemy_Temp2+$01
	;Next task ($02: Hypnotized)
	inc Enemy_Temp0+$01
	;Play sound
	ldy #SE_HYPNOTIZE
	jmp LoadSound
HypnoTeammateSpawnFrog:
	;Spawn enemy
	lda #$00
	sta $00
	sta $01
	ldy #$03
	lda #$8B
	jsr SpawnEnemy
	;Set enemy Y position
	lda #$00
	sta Enemy_Y+$03
	;Spawn enemy
	lda #$00
	sta $00
	sta $01
	ldy #$04
	lda #$8D
	jsr SpawnEnemy
	;Set enemy Y position
	lda #$14
	sta Enemy_Y+$04
	;Set enemy ID to hypno frog
	lda #ENEMY_HYPNOFROG
	sta Enemy_ID+$03
	sta Enemy_ID+$04
	;Set enemy Y velocity
	lda #$20
	sta Enemy_YVelLo+$03
	sta Enemy_YVelLo+$04
	;Set enemy priority to be behind background
	sta Enemy_Props+$03
	sta Enemy_Props+$04
	;Next task ($01: Down)
	inc Enemy_Temp0+$02
	;Clear sound
	jsr ClearSound
	;Play music
	ldy #MUSIC_BOSS
	jmp LoadSound
;$02: Hypnotized
Enemy58_Fight_Sub2:
	;Decrement animation timer, check if 0
	dec Enemy_Temp2+$01
	bne Enemy58_Fight_Sub3_Exit
	;Spawn hypno frog
	jsr HypnoTeammateSpawnFrog
Enemy58_Fight_Sub2_Spawn:
	;Load CHR bank
	lda #$58
	sta TempCHRBanks+4
	;Set enemy animation
	ldy #$58
	jsr SetEnemyAnimation
	;Set enemy props
	lda #$22
	sta Enemy_Props+$01
	;Spawn enemy
	lda #$00
	sta $00
	lda #$E6
	sta $01
	ldy #$05
	lda #$5A
	jsr SpawnEnemy
	;Set enemy ID to hypno Jenny light ball
	lda #ENEMY_HYPNOJENNYLTBALL
	sta Enemy_ID+$05
	;Set enemy flags
	lda #(EF_ACTIVE|EF_HITENEMY|EF_VISIBLE)
	sta Enemy_Flags+$05
	;Set enemy props
	lda #$02
	sta Enemy_Props+$05
	;Set enemy tile offset
	lda #$80
	sta Enemy_Temp7+$05
	;Set animation timer
	lda #$80
	sta Enemy_Temp1+$01
	;Next task
	inc Enemy_Temp0+$01
	;Play sound
	ldy #SE_JENNYLTBALL
	jmp LoadSound
;$03: Light ball bottom
Enemy58_Fight_Sub3:
	;Decrement animation timer, check if 0
	dec Enemy_Temp1+$01
	bne Enemy58_Fight_Sub3_Exit
	;Set animation frame counter
	lda #$03
	sta Enemy_Temp1+$01
Enemy58_Fight_Sub3_Despawn:
	;Clear enemy flags
	lda #$00
	sta Enemy_Flags+$05
	;Load CHR bank
	lda #$52
	sta TempCHRBanks+4
	;Set enemy animation
	ldy #$04
	jsr SetEnemyAnimation
	;Set enemy X velocity
	lda #$01
	sta Enemy_XVelHi+$01
	;Next task
	inc Enemy_Temp0+$01
Enemy58_Fight_Sub3_Exit:
	rts
;$04: Run bottom
Enemy58_Fight_Sub4:
	;Run between X positions $10-$30
	lda #$10
	sta $00
	lda #$30
	sta $01
Enemy58_Fight_Sub4_Run:
	;If enemy X position at right point, run left
	lda Enemy_X+$01
	cmp $01
	beq Enemy58_Fight_Sub4_LeftDec
	;If enemy X position < left point, run right
	cmp $00
	bcc Enemy58_Fight_Sub4_Right
	;If enemy X position >= $98, run left
	cmp #$98
	bcs Enemy58_Fight_Sub4_Left
	;If bits 0-4 of enemy X position 0, shoot projectile
	and #$1F
	bne Enemy58_Fight_Sub3_Exit
	;Shoot projectile
	ldy #$1E
	lda #$F4
HypnoTeammateShoot:
	;Spawn enemy
	sta $01
	lda #$00
	sta $00
	tya
	jsr FindFreeEnemySlot
	;If no free slot available, exit early
	bcc HypnoTeammateShoot_Exit
	;Set enemy ID to enemy fire 2
	lda #ENEMY_ENEMYFIRE2
	sta Enemy_ID,y
	;Set enemy flags
	lda #(EF_ACTIVE|EF_HITENEMY|EF_VISIBLE)
	sta Enemy_Flags,y
	;Set enemy tile offset
	lda #$80
	sta Enemy_Temp7,y
	;Check if moving left or right
	lda Enemy_Props+$01
	and #$40
	bne HypnoTeammateShoot_Left
	;Set enemy X velocity right
	lda #$04
	sta Enemy_XVelHi,y
	;Set enemy props right
	lda #$02
	sta Enemy_Props,y
	rts
HypnoTeammateShoot_Left:
	;Set enemy X velocity left
	lda #$FC
	sta Enemy_XVelHi,y
	;Set enemy props left
	lda #$42
	sta Enemy_Props,y
HypnoTeammateShoot_Exit:
	rts
Enemy58_Fight_Sub4_Right:
	;Set enemy X velocity right
	lda #$01
	sta Enemy_XVelHi+$01
	;Set enemy props right
	lda #$22
	sta Enemy_Props+$01
	rts
Enemy58_Fight_Sub4_Left:
	;Set enemy X velocity left
	lda #$FF
	sta Enemy_XVelHi+$01
	;Set enemy props left
	lda #$62
	sta Enemy_Props+$01
Enemy58_Fight_Sub4_LeftExit:
	rts
Enemy58_Fight_Sub4_LeftDec:
	;Decrement animation frame counter, check if 0
	dec Enemy_Temp1+$01
	bne Enemy58_Fight_Sub4_LeftExit
	;Set enemy X velocity
	lda #$FF
	sta Enemy_XVelHi+$01
Enemy58_Fight_Sub4_Jump:
	;Set enemy animation
	ldy #$42
	jsr SetEnemyAnimation
HypnoTeammateJump:
	;Set enemy Y velocity/acceleration
	lda #$F8
	sta Enemy_YVelHi+$01
	lda #$7F
	sta Enemy_YAccel+$01
	;Next task
	inc Enemy_Temp0+$01
	rts
;$05: Jump bottom to middle
;$09: Jump top to middle
Enemy58_Fight_Sub5:
	;Jump to Y position $A3
	ldy #$73
	jsr HypnoTeammateLand
	;If not landed yet, exit early
	bcs Enemy58_Fight_Sub4_LeftExit
	;Spawn light ball
	jmp Enemy58_Fight_Sub2_Spawn
HypnoTeammateLand:
	;Set carry flag
	sec
	;If enemy Y velocity up, exit early
	lda Enemy_YVelHi+$01
	bmi Enemy58_Fight_Sub4_LeftExit
	;If enemy Y position < jump to Y position, exit early
	cpy Enemy_Y+$01
	bcs Enemy58_Fight_Sub4_LeftExit
	;Set enemy Y position
	sty Enemy_Y+$01
	;Clear enemy Y velocity/acceleration
	lda #$00
	sta Enemy_YVelHi+$01
	sta Enemy_YVelLo+$01
	sta Enemy_YAccel+$01
	;Clear enemy X velocity
	sta Enemy_XVelHi+$01
	;Clear carry flag
	clc
HypnoTeammateLand_Exit:
	rts
;$06: Light ball middle 1
Enemy58_Fight_Sub6:
	;Decrement animation timer, check if 0
	dec Enemy_Temp1+$01
	bne HypnoTeammateLand_Exit
	;Clear enemy flags
	lda #$00
	sta Enemy_Flags+$05
	;Load CHR bank
	lda #$52
	sta TempCHRBanks+4
	;Set enemy X velocity
	lda #$02
	sta Enemy_XVelHi+$01
	;Setup jumping
	jmp Enemy58_Fight_Sub4_Jump
;$07: Jump middle to top
Enemy58_Fight_Sub7:
	;Jump to Y position $A3
	ldy #$43
	jsr HypnoTeammateLand
	;If not landed yet, exit early
	bcs Enemy58_Fight_Sub4_LeftExit
	;Set animation frame counter
	lda #$03
	sta Enemy_Temp1+$01
	;Despawn light ball
	jmp Enemy58_Fight_Sub3_Despawn
;$08: Run top
Enemy58_Fight_Sub8:
	;Run between X positions $3C-$98
	lda #$3C
	sta $00
	lda #$3D
	sta $01
	jsr Enemy58_Fight_Sub4_Run
	rts
;$0A: Light ball middle 2
Enemy58_Fight_SubA:
	;Decrement animation timer, check if 0
	dec Enemy_Temp1+$01
	bne HypnoTeammateLand_Exit
	;Clear enemy flags
	lda #$00
	sta Enemy_Flags+$05
	;Load CHR bank
	lda #$52
	sta TempCHRBanks+4
	;Set enemy X velocity
	lda #$01
	sta Enemy_XVelHi+$01
	;Setup jumping
	jmp Enemy58_Fight_Sub4_Jump
;$0B: Jump middle to bottom
Enemy58_Fight_SubB:
	;Jump to Y position $A3
	ldy #$A3
	jsr HypnoTeammateLand
	;If not landed yet, exit early
	bcs Enemy58_Fight_SubB_Exit
	;Spawn light ball
	jsr Enemy58_Fight_Sub2_Spawn
	;Next task ($03: Light ball bottom)
	lda #$03
	sta Enemy_Temp0+$01
Enemy58_Fight_SubB_Exit:
	rts
HypnoTeammateFight:
	;If not in fight mode, exit early
	lda Enemy_Temp0,x
	cmp #$02
	bcc Enemy58_Fight_SubB_Exit
	;Set enemy flags
	lda Enemy_Flags+$01
	ora #(EF_HITBULLET|EF_HITENEMY)
	and #~EF_PRIORITY
	sta Enemy_Flags+$01
	rts

;$59: Hypno Willy
Enemy59:
	;If enemy HP >= 0, do fight mode
	lda Enemy_HP+$01
	bpl Enemy59_Fight
	;If enemy Y acceleration 0, do rescue mode
	lda Enemy_YAccel+$01
	beq Enemy59_Rescue
Enemy59_Fight:
	;Update hypno teammate fight state
	jsr HypnoTeammateFight
	;Do jump table
	lda Enemy_Temp0+$01
	jsr DoJumpTable
Enemy59FightJumpTable:
	.dw Enemy58_Fight_Sub0	;$00  Init
	.dw Enemy59_Fight_Sub1	;$01  Back and forth
	.dw Enemy59_Fight_Sub2	;$02  Hypnotized part 1
	.dw Enemy59_Fight_Sub3	;$03  Hypnotized part 2
	.dw Enemy59_Fight_Sub4	;$04  Run bottom left 1
	.dw Enemy59_Fight_Sub4	;$05  Run bottom right
	.dw Enemy59_Fight_Sub6	;$06  Run bottom left 2
	.dw Enemy59_Fight_Sub7	;$07  Jump bottom to top
	.dw Enemy59_Fight_Sub8	;$08  Run top
	.dw Enemy59_Fight_Sub9	;$09  Jump top to bottom
Enemy59_Rescue:
	;Update hypno teammate rescue state
	jsr HypnoTeammateRescue
	;Do jump table
	lda Enemy_Temp2+$01
	jsr DoJumpTable
Enemy59RescueJumpTable:
	.dw Enemy59_Rescue_Sub0	;$00  Init
	.dw Enemy59_Rescue_Sub1	;$01  Jingle
	.dw Enemy58_Rescue_Sub2	;$02  Scroll right
	.dw Enemy58_Rescue_Sub3	;$03  Wait
	.dw Enemy59_Rescue_Sub4	;$04  Scroll left
;$00: Init
Enemy59_Rescue_Sub0:
	;Clear enemy X velocity
	lda #$00
	sta Enemy_XVelHi+$01
	;Load CHR bank
	lda #$53
	sta TempCHRBanks+4
	;Set enemy flags
	lda #(EF_ACTIVE|EF_NOANIM|EF_PRIORITY|EF_VISIBLE)
	sta Enemy_Flags+$01
	;Set enemy sprite
	lda #$2A
	sta Enemy_SpriteLo+$01
	;Clear rescue text
	lda #$05
	sta UpdateVRAMStripCount
	jsr HypnoTeammateClearRescueText
	;Draw VRAM strip
	lda #$99
	sta UpdateVRAMStripID+4
	;Next task ($01: Jingle)
	inc Enemy_Temp2+$01
	;Set animation timer
	lda #$00
	sta Enemy_Temp1+$01
	rts
;$01: Jingle
Enemy59_Rescue_Sub1:
	;Decrement animation timer, check if 0
	dec Enemy_Temp1+$01
	beq Enemy59_Rescue_Sub1_Next
	;If bits 0-3 of animation timer not 0, exit early
	lda Enemy_Temp1+$01
	and #$0F
	bne Enemy59_Rescue_Sub1_Exit
	;Flash palette
	lda CurPalette
	eor #$8E
	sta CurPalette
Enemy59_Rescue_Sub1_Exit:
	rts
Enemy59_Rescue_Sub1_Next:
	;Load palette
	lda #$B7
	sta CurPalette
	;Next task ($02: Scroll right)
	inc Enemy_Temp2+$01
	;Clear sound
	jsr ClearSound
	;Load music
	ldy #MUSIC_RESCUE
	jmp LoadSound
;$04: Scroll left
Enemy59_Rescue_Sub4:
	;Scroll left $02
	dec TempIRQBufferScrollX
	dec TempIRQBufferScrollX
	;If scroll X position not 0, exit early
	bne Enemy59_Rescue_Sub1_Exit
	;Clear enemy flags
	lda #$00
	sta Enemy_Flags+$01
	;Clear disable side exit flag
	sta DisableSideExitFlag
	;Enable character Willy
	lda CharacterPowerMax+4
	ora #$80
	sta CharacterPowerMax+4
	;Set current screen
	lda #$2F
	sta CurScreen
	;Clear sound
	jsr ClearSound
	;Load music
	ldy #MUSIC_LEVEL5
	jmp LoadSound
;$01: Back and forth
Enemy59_Fight_Sub1:
	;If player X position >= $50 and enemy X position $CC, setup next task ($02: Hypnotized part 1)
	lda Enemy_X
	cmp #$50
	bcc Enemy59_Fight_Sub1_NoNext
	lda Enemy_X+$01
	cmp #$CC
	beq Enemy59_Fight_Sub1_Next
Enemy59_Fight_Sub1_NoNext:
	;If enemy Y position $BC or $DC, flip enemy X
	lda Enemy_X+$01
	cmp #$DC
	beq Enemy59_Fight_Sub1_FlipX
	cmp #$BC
	bne Enemy59_Fight_Sub1_Exit
Enemy59_Fight_Sub1_FlipX:
	;Flip enemy X
	jmp HypnoTeammateFlipX
Enemy59_Fight_Sub1_Next:
	;Set enemy props
	lda #$62
	sta Enemy_Props+$01
	;Set enemy flags
	lda #(EF_ACTIVE|EF_NOANIM|EF_PRIORITY|EF_VISIBLE)
	sta Enemy_Flags+$01
	;Set enemy sprite
	lda #$2A
	sta Enemy_SpriteLo+$01
	;Spawn hypno frog beam
	jsr HypnoTeammateSpawnFrogBeam
	;Set enemy X position
	lda #$CC
	sta Enemy_X+$02
Enemy59_Fight_Sub1_Exit:
	rts
;$02: Hypnotized part 1
Enemy59_Fight_Sub2:
	;Decrement animation timer, check if 0
	dec Enemy_Temp2+$01
	bne Enemy59_Fight_Sub1_Exit
	;Reset animation timer
	lda #$C0
	sta Enemy_Temp2+$01
	;Next task ($03: Hypnotized part 2)
	inc Enemy_Temp0+$01
	;Spawn hypno frog
	jmp HypnoTeammateSpawnFrog
;$03: Hypnotized part 2
Enemy59_Fight_Sub3:
	;Decrement animation timer, check if 0
	dec Enemy_Temp2+$01
	bne Enemy59_Fight_Sub1_Exit
Enemy59_Fight_Sub3_Left:
	;Set enemy animation
	ldy #$06
	jsr SetEnemyAnimation
	;Set enemy X velocity
	lda #$FF
	sta Enemy_XVelHi+$01
	;Next task
	inc Enemy_Temp0+$01
Enemy59_Fight_Sub3_Shoot:
	;Shoot projectile
	lda #$00
	ldy #$70
	jsr HypnoTeammateShoot
	;Set enemy ID to enemy fire 2
	lda #ENEMY_ENEMYFIRE2
	sta Enemy_ID,y
	;Play sound
	ldy #SE_WILLYSHOOT
	jmp LoadSound
;$04: Run bottom left 1
;$05: Run bottom right
Enemy59_Fight_Sub4:
	;If enemy X position $6A or $F0, setup next task
	lda Enemy_X+$01
	cmp #$6A
	beq Enemy59_Fight_Sub4_Next
	cmp #$F0
	bne Enemy59_Fight_Sub1_Exit
Enemy59_Fight_Sub4_Next:
	;Next task
	inc Enemy_Temp0+$01
	;Flip enemy X
	jsr HypnoTeammateFlipX
	;Shoot projectile
	jmp Enemy59_Fight_Sub3_Shoot
;$06: Run bottom left 2
Enemy59_Fight_Sub6:
	;If enemy X position not $D0, exit early
	lda Enemy_X+$01
	cmp #$D0
	bne Enemy59_Fight_Sub8_Exit
Enemy59_Fight_Sub6_Jump:
	;Set enemy animation
	ldy #$44
	jsr SetEnemyAnimation
	;Setup jumping
	jmp HypnoTeammateJump
;$07: Jump bottom to top
Enemy59_Fight_Sub7:
	;Jump to Y position $73
	ldy #$73
	jsr HypnoTeammateLand
	;If not landed yet, exit early
	bcs Enemy59_Fight_Sub8_Exit
	;Setup next task ($08: Run top)
	jmp Enemy59_Fight_Sub3_Left
;$08: Run top
Enemy59_Fight_Sub8:
	;If enemy X position $90, setup next task ($09: Jump top to bottom)
	lda Enemy_X+$01
	cmp #$90
	beq Enemy59_Fight_Sub6_Jump
Enemy59_Fight_Sub8_Exit:
	rts
;$09: Jump top to bottom
Enemy59_Fight_Sub9:
	;Jump to Y position $A3
	ldy #$A3
	jsr HypnoTeammateLand
	;If not landed yet, exit early
	bcs Enemy59_Fight_Sub8_Exit
	;Setup next task ($04: Run bottom left 1)
	lda #$03
	sta Enemy_Temp0+$01
	jmp Enemy59_Fight_Sub3_Left

;$5A: Hypno Dead-Eye
Enemy5A:
	;If enemy HP >= 0, do fight mode
	lda Enemy_HP+$01
	bpl Enemy5A_Fight
	;If enemy Y acceleration not 0, do fight mode
	lda Enemy_YAccel+$01
	bne Enemy5A_Fight
	;If enemy animation $54 or $72, do fight mode
	lda Enemy_Anim+$01
	cmp #$54
	beq Enemy5A_Fight
	cmp #$72
	bne Enemy5A_Rescue
Enemy5A_Fight:
	;Update hypno teammate fight state
	jsr HypnoTeammateFight
	;Do jump table
	lda Enemy_Temp0+$01
	jsr DoJumpTable
Enemy5AFightJumpTable:
	.dw Enemy58_Fight_Sub0	;$00  Init
	.dw Enemy59_Fight_Sub1	;$01  Back and forth
	.dw Enemy59_Fight_Sub2	;$02  Hypnotized part 1
	.dw Enemy5A_Fight_Sub03	;$03  Hypnotized part 2
	.dw Enemy5A_Fight_Sub04	;$04  Run bottom left 1
	.dw Enemy5A_Fight_Sub04	;$05  Run bottom right
	.dw Enemy5A_Fight_Sub06	;$06  Run bottom left 2
	.dw Enemy5A_Fight_Sub07	;$07  Jump bottom to wall
	.dw Enemy5A_Fight_Sub08	;$08  Climb wall up 1
	.dw Enemy5A_Fight_Sub09	;$09  Climb wall down
	.dw Enemy5A_Fight_Sub0A	;$0A  Climb wall up 2
	.dw Enemy5A_Fight_Sub0B	;$0B  Jump wall to top up
	.dw Enemy5A_Fight_Sub0C	;$0C  Jump wall to top down
	.dw Enemy5A_Fight_Sub0D	;$0D  Jump top to middle
	.dw Enemy5A_Fight_Sub0E	;$0E  Run middle left 1
	.dw Enemy5A_Fight_Sub0E	;$0F  Run middle right 1
	.dw Enemy5A_Fight_Sub0E	;$10  Run middle left 2
	.dw Enemy5A_Fight_Sub11	;$11  Run middle right 2
	.dw Enemy5A_Fight_Sub12	;$12  Jump middle to top
	.dw Enemy5A_Fight_Sub13	;$13  Jump top to bottom
Enemy5A_Rescue:
	;Update hypno teammate rescue state
	jsr HypnoTeammateRescue
	;Do jump table
	lda Enemy_Temp2+$01
	jsr DoJumpTable
Enemy5ARescueJumpTable:
	.dw Enemy5A_Rescue_Sub0	;$00  Init
	.dw Enemy5A_Rescue_Sub1	;$01  Jingle
	.dw Enemy58_Rescue_Sub2	;$02  Scroll right
	.dw Enemy58_Rescue_Sub3	;$03  Wait
	.dw Enemy5A_Rescue_Sub4	;$04  Scroll left
	.dw Enemy5A_Rescue_Sub5	;$05  Wait end
;$00: Init
Enemy5A_Rescue_Sub0:
	;Clear enemy X velocity
	lda #$00
	sta Enemy_XVelHi+$01
	;Load CHR bank
	lda #$51
	sta TempCHRBanks+4
	;Set enemy flags
	lda #(EF_ACTIVE|EF_NOANIM|EF_PRIORITY|EF_VISIBLE)
	sta Enemy_Flags+$01
	;Set enemy sprite
	lda #$24
	sta Enemy_SpriteLo+$01
	;Clear rescue text
	lda #$05
	sta UpdateVRAMStripCount
	jsr HypnoTeammateClearRescueText
	;Draw VRAM strip
	lda #$9A
	sta UpdateVRAMStripID+4
	;Next task ($01: Jingle)
	inc Enemy_Temp2+$01
	;Set animation timer
	lda #$00
	sta Enemy_Temp1+$01
	rts
;$01: Jingle
Enemy5A_Rescue_Sub1:
	;Decrement animation timer, check if 0
	dec Enemy_Temp1+$01
	beq Enemy5A_Rescue_Sub1_Next
	;If bits 0-3 of animation timer not 0, exit early
	lda Enemy_Temp1+$01
	and #$0F
	bne Enemy5A_Rescue_Sub5
	;Flash palette
	lda CurPalette
	eor #$81
	sta CurPalette
;$05: Wait end
Enemy5A_Rescue_Sub5:
	rts
Enemy5A_Rescue_Sub1_Next:
	;Load palette
	lda #$B8
	sta CurPalette
	;Next task ($02: Scroll right)
	inc Enemy_Temp2+$01
	;Clear sound
	jsr ClearSound
	;Load music
	ldy #MUSIC_RESCUE
	jmp LoadSound
;$04: Scroll left
Enemy5A_Rescue_Sub4:
	;Scroll left $02
	dec TempIRQBufferScrollX
	dec TempIRQBufferScrollX
	;If scroll X position not 0, exit early
	bne Enemy5A_Rescue_Sub5
	;Next task ($05: Wait end)
	inc Enemy_Temp2+$01
	;Clear enemy flags
	lda #$00
	sta Enemy_Flags+$01
	rts
;$03: Hypnotized part 2
Enemy5A_Fight_Sub03:
	;Decrement animation timer, check if 0
	dec Enemy_Temp2+$01
	bne Enemy5A_Rescue_Sub5
Enemy5A_Fight_Sub03_Jump:
	;Set enemy animation
	ldy #$02
	jsr SetEnemyAnimation
	;Set enemy X velocity
	lda #$FF
	sta Enemy_XVelHi+$01
	;Set enemy props
	lda #$62
	sta Enemy_Props+$01
	;Next task
	inc Enemy_Temp0+$01
Enemy5A_Fight_Sub03_Shoot:
	;Shoot projectiles
	lda #$02
	sta Enemy_Temp3+$01
Enemy5A_Fight_Sub03_ShootLoop:
	;Shoot projectile
	lda #$00
	ldy #$1A
	jsr HypnoTeammateShoot
	;Set enemy ID to enemy fire 2
	lda #ENEMY_ENEMYFIRE2
	sta Enemy_ID,y
	;Set enemy velocity
	ldx Enemy_Temp3+$01
	lda HypnoDeadEyeShootYVel,x
	sta Enemy_YVelHi,y
	lda HypnoDeadEyeShootXVel,x
	sta Enemy_XVelHi,y
	;Check if moving left or right
	lda Enemy_Props,y
	and #$40
	beq Enemy5A_Fight_Sub03_ShootNext
	;Flip enemy X velocity
	lda Enemy_XVelHi,y
	eor #$FF
	clc
	adc #$01
	sta Enemy_XVelHi,y
Enemy5A_Fight_Sub03_ShootNext:
	;Restore X register
	ldx #$01
	;Loop for each projectile
	dec Enemy_Temp3+$01
	bpl Enemy5A_Fight_Sub03_ShootLoop
	;Play sound
	ldy #SE_PLAYERSHOOT3
	jmp LoadSound
HypnoDeadEyeShootYVel:
	.db $FD,$03,$00
HypnoDeadEyeShootXVel:
	.db $03,$03,$04
;$04: Run bottom left 1
;$05: Run bottom right
Enemy5A_Fight_Sub04:
	;Run between X positions $6A-$F0
	lda #$F0
	sta $00
	bne Enemy5A_Fight_Sub0E_Run
;$0E: Run middle left 1
;$0F: Run middle right 1
;$10: Run middle left 2
Enemy5A_Fight_Sub0E:
	;Run between X positions $6A-$96
	lda #$96
	sta $00
Enemy5A_Fight_Sub0E_Run:
	;If enemy X position $6A, run right
	lda Enemy_X+$01
	cmp #$6A
	beq Enemy5A_Fight_Sub0E_Next
	;If enemy X position at right point, run left
	cmp $00
	bne Enemy5A_Fight_Sub09_Exit
Enemy5A_Fight_Sub0E_Next:
	;Next task
	inc Enemy_Temp0+$01
	;Flip enemy X
	jsr HypnoTeammateFlipX
	;Shoot projectile
	jmp Enemy5A_Fight_Sub03_Shoot
;$06: Run bottom left 2
Enemy5A_Fight_Sub06:
	;If enemy X position not $DB, exit early
	lda Enemy_X+$01
	cmp #$DB
	bne Enemy5A_Fight_Sub09_Exit
Enemy5A_Fight_Sub06_Jump:
	;Set enemy animation
	ldy #$40
	jsr SetEnemyAnimation
	;Setup jumping
	jmp HypnoTeammateJump
;$07: Jump bottom to wall
Enemy5A_Fight_Sub07:
	;Jump to Y position $60
	ldy #$60
	jsr HypnoTeammateLand
	;If not landed yet, exit early
	bcs Enemy5A_Fight_Sub09_Exit
	;Play sound
	ldy #SE_DEADEYEGRAB
	jsr LoadSound
	;Load CHR bank
	lda #$57
	sta TempCHRBanks+4
Enemy5A_Fight_Sub07_Up:
	;Next task
	inc Enemy_Temp0+$01
	;Set enemy Y velocity
	lda #$FF
	sta Enemy_YVelHi+$01
	;Set enemy animation
	ldy #$54
	jmp SetEnemyAnimation
;$08: Climb wall up 1
Enemy5A_Fight_Sub08:
	;If enemy Y position not $4C, exit early
	lda Enemy_Y+$01
	cmp #$4C
	bne Enemy5A_Fight_Sub09_Exit
	;Next task ($09: Climb wall down)
	inc Enemy_Temp0+$01
	;Set enemy Y velocity
	lda #$01
	sta Enemy_YVelHi+$01
	;Set enemy animation
	ldy #$72
	jmp SetEnemyAnimation
;$09: Climb wall down
Enemy5A_Fight_Sub09:
	;If enemy Y position $84, setup next task ($0A: Climb wall up 2)
	lda Enemy_Y+$01
	cmp #$84
	beq Enemy5A_Fight_Sub07_Up
Enemy5A_Fight_Sub09_Exit:
	rts
;$0A: Climb wall up 2
Enemy5A_Fight_Sub0A:
	;If enemy Y position not $4C, exit early
	lda Enemy_Y+$01
	cmp #$4C
	bne Enemy5A_Fight_Sub09_Exit
	;Load CHR bank
	lda #$51
	sta TempCHRBanks+4
	;Setup jumping
	jmp Enemy5A_Fight_Sub06_Jump
;$0B: Jump wall to top up
Enemy5A_Fight_Sub0B:
	;If enemy Y velocity up, exit early
	lda Enemy_YVelHi+$01
	bmi Enemy5A_Fight_Sub09_Exit
	;Set enemy X velocity
	lda #$FE
	sta Enemy_XVelHi+$01
	;Next task ($0C: Jump wall to top down)
	inc Enemy_Temp0+$01
	rts
;$0C: Jump wall to top down
Enemy5A_Fight_Sub0C:
	;Jump to Y position $33
	ldy #$33
	jsr HypnoTeammateLand
	;If not landed yet, exit early
	bcs Enemy5A_Fight_Sub09_Exit
	;Setup jumping
	jsr Enemy5A_Fight_Sub06_Jump
	;Set enemy velocity
	lda #$FA
	sta Enemy_YVelHi+$01
	lda #$FF
	sta Enemy_XVelHi+$01
	rts
;$0D: Jump top to middle
Enemy5A_Fight_Sub0D:
	;Jump to Y position $63
	ldy #$63
	jsr HypnoTeammateLand
	;If not landed yet, exit early
	bcs Enemy5A_Fight_Sub09_Exit
	;Setup jumping
	jmp Enemy5A_Fight_Sub03_Jump
;$11: Run middle right 2
Enemy5A_Fight_Sub11:
	;If enemy X position not $90, exit early
	lda Enemy_X+$01
	cmp #$90
	bne Enemy5A_Fight_Sub09_Exit
	;Setup jumping
	jsr Enemy5A_Fight_Sub06_Jump
	;Set enemy X velocity
	lda #$02
	sta Enemy_XVelHi+$01
	rts
;$12: Jump middle to top
Enemy5A_Fight_Sub12:
	;Jump to Y position $33
	ldy #$33
	jsr HypnoTeammateLand
	;If not landed yet, exit early
	bcs Enemy5A_Fight_Sub09_Exit
	;Setup jumping
	jsr Enemy5A_Fight_Sub06_Jump
	;Set enemy velocity
	lda #$01
	sta Enemy_XVelHi+$01
	lda #$FA
	sta Enemy_YVelHi+$01
	rts
;$13: Jump top to bottom
Enemy5A_Fight_Sub13:
	;Jump to Y position $A3
	ldy #$A3
	jsr HypnoTeammateLand
	;If not landed yet, exit early
	bcs Enemy5A_Fight_Sub09_Exit
	;Setup next task ($04: Run bottom left 1)
	lda #$03
	sta Enemy_Temp0+$01
	jmp Enemy5A_Fight_Sub03_Jump

;$5F: Arrow platform/Yoku block
Enemy5F:
	;Set enemy props
	jsr ArrowPlatformSetProps
	;Do jump table
	lda Enemy_Temp0,x
	jsr DoJumpTable
Enemy5FJumpTable:
	.dw Enemy5F_Sub0	;$00  Init
	.dw Enemy5F_Sub1	;$01  Wait
	.dw Enemy5F_Sub2	;$02  Main
;$00: Init
Enemy5F_Sub0:
	;Check for yoku block
	lda Enemy_Temp1,x
	cmp #$08
	beq Enemy5F_Sub0_Yoku
Enemy5F_Sub0_NextDir:
	;Get animation data index based on parameter value
	and #$03
	tay
	;Next task ($01: Wait)
	inc Enemy_Temp0,x
	;Set enemy props based on parameter value
	lda ArrowPlatformProps,y
	sta Enemy_Props,x
	;Set enemy animation based on parameter value
	lda ArrowPlatformAnim,y
	tay
	jmp SetEnemyAnimation
Enemy5F_Sub0_Yoku:
	;Decrement animation timer, check if 0
	dec Enemy_Temp2,x
	bne Enemy5F_Sub1_Exit
	;Clear enemy flags
	lda #$00
	sta Enemy_Flags,x
	rts
ArrowPlatformAnim:
	.db $F8,$FA,$F8,$FA
ArrowPlatformProps:
	.db $40,$01,$00,$81
ArrowPlatformXVel:
	.db $01,$00,$FF,$00
ArrowPlatformYVel:
	.db $00,$FF,$00,$01
ArrowPlatformParam:
	.db $02,$03,$00,$01
	.db $05,$06,$07,$04
;$01: Wait
Enemy5F_Sub1:
	;Check for collision
	jsr PlatformCheckCollision
	bne Enemy5F_Sub1_Exit
	;Play sound
	ldy #SE_WHIRSHORT
	jsr LoadSound
	;Set enemy velocity based on parameter value
	lda Enemy_Temp1,x
	and #$03
	tay
	lda ArrowPlatformXVel,y
	sta Enemy_XVelHi,x
	lda ArrowPlatformYVel,y
	sta Enemy_YVelHi,x
	;Set animation timer
	lda #$40
	sta Enemy_Temp2,x
	;Next task ($02: Main)
	inc Enemy_Temp0,x
Enemy5F_Sub1_Exit:
	rts
ArrowPlatformSetProps:
	;Check for square motion arrow platform
	lda Enemy_Temp1,x
	and #$04
	beq Enemy5F_Sub1_Exit
	;If bits 0-2 of global timer not 0, exit early
	lda LevelGlobalTimer
	and #$07
	bne Enemy5F_Sub1_Exit
	;Set enemy props
	lda Enemy_Props,x
	eor #$01
	sta Enemy_Props,x
ArrowPlatformSetProps_Exit:
	rts
;$02: Main
Enemy5F_Sub2:
	;Decrement animation timer, check if 0
	dec Enemy_Temp2,x
	bne Enemy5F_Sub1_Exit
	;Clear enemy velocity
	lda #$00
	sta Enemy_XVelHi,x
	sta Enemy_YVelHi,x
	;Next task ($00: Init)
	sta Enemy_Temp0,x
	;Get next path direction parameter value
	ldy Enemy_Temp1,x
	lda ArrowPlatformParam,y
	sta Enemy_Temp1,x
	;Setup next path direction
	jmp Enemy5F_Sub0_NextDir

;$60: Yoku block spawner
Enemy60:
	;If bits 0-5 of global timer not 0, exit early
	lda LevelGlobalTimer
	and #$3F
	bne ArrowPlatformSetProps_Exit
	;Play sound
	ldy #SE_BUZZ
	jsr LoadSound
	;Spawn blocks
	lda #$01
	sta $16
Enemy60_Loop:
	;Get yoku block position data index based on animation frame counter and parameter value
	lda Enemy_Temp2+$08
	asl
	sta $08
	lda Enemy_Temp1+$08
	asl
	asl
	asl
	adc $08
	adc $16
	tay
	;Spawn enemy
	lda YokuBlockXPos,y
	sta $00
	lda YokuBlockYPos,y
	sta $01
	lda $08
	and #$02
	clc
	adc $16
	tay
	iny
	lda #$93
	jsr SpawnEnemy
	;If no free slot available, clear enemy flags
	bcs Enemy60_NoClearF
	;Clear enemy flags
	lda #$00
	sta Enemy_Flags,y
	beq Enemy60_Next
Enemy60_NoClearF:
	;Set enemy ID to yoku block
	lda #ENEMY_ARROWYOKUBLOCK
	sta Enemy_ID,y
	;Set path direction to yoku block
	lda #$08
	sta Enemy_Temp1,y
	;Set animation timer
	lda #$88
	sta Enemy_Temp2,y
	;Set enemy props
	lda $16
	sta Enemy_Props,y
Enemy60_Next:
	;Loop for each block
	dec $16
	bpl Enemy60_Loop
	;Increment animation frame counter
	inc Enemy_Temp2+$08
	lda Enemy_Temp2+$08
	and #$03
	sta Enemy_Temp2+$08
	rts
YokuBlockXPos:
	.db $C8,$18,$18,$D8,$F8,$28,$38,$F8
	.db $38,$A8,$B8,$08,$18,$C8,$E8,$28
	.db $D8,$58,$58,$E8,$C8,$38,$F8,$A8
	.db $F8,$48,$38,$08,$E8,$28,$18,$D8
YokuBlockYPos:
	.db $28,$F8,$18,$E8,$08,$D8,$08,$C8
	.db $E8,$08,$38,$38,$08,$28,$48,$18
	.db $E8,$48,$F8,$48,$E8,$48,$18,$28
	.db $D8,$38,$E8,$28,$D8,$38,$08,$18

;$14: Lightning
;$65: Ceiling laser
Enemy14:
	;If bit 5 of global timer == parameter value, set enemy visible flag
	lda LevelGlobalTimer
	and #$20
	lsr
	lsr
	lsr
	lsr
	lsr
	cmp Enemy_Temp1,x
	beq Enemy14_Show
	;Clear enemy visible flag
	lda #EF_ACTIVE
	sta Enemy_Flags,x
Enemy14_Exit:
	rts
Enemy14_Show:
	;If visible, exit early
	lda Enemy_Flags,x
	cmp #(EF_ACTIVE|EF_HITENEMY|EF_VISIBLE)
	beq Enemy14_Exit
	;Set enemy visible flag
	lda #(EF_ACTIVE|EF_HITENEMY|EF_VISIBLE)
	sta Enemy_Flags,x
	;Play sound
	ldy #SE_LIGHTNING
	jmp LoadSound

;$69: BG fake block
Enemy69:
	;Do jump table
	lda Enemy_Temp0,x
	jsr DoJumpTable
Enemy69JumpTable:
	.dw Enemy69_Sub0	;$00  Init
	.dw Enemy69_Sub1	;$01  Wait
	.dw Enemy69_Sub2	;$02  Main
;$00: Init
Enemy69_Sub0:
	;Next task ($01: Wait)
	inc Enemy_Temp0,x
	;Save enemy Y position
	lda Enemy_Y,x
	sta Enemy_Temp2,x
	;Draw solid collision
	lda #$02
	jmp BGFakeBlockDrawCollision
;$01: Wait
Enemy69_Sub1:
	;Check for collision
	jsr PlatformCheckCollision
	bne Enemy14_Exit
	;Next task ($02: Main)
	inc Enemy_Temp0,x
	;Set enemy Y acceleration
	lda #$7F
	sta Enemy_YAccel,x
	;Draw nonsolid collision
	lda #$00
	jsr BGFakeBlockDrawCollision
	;Play sound
	ldy #SE_BGFAKEBLOCK
	jsr LoadSound
	;If Jenny light ball not in special state, exit early
	lda Enemy_Temp0
	bpl Enemy14_Exit
	;Set current power $04
	lda #$04
	sta CharacterPowerCur+3
	rts
;$02: Main
Enemy69_Sub2:
	;If enemy Y position < $C0, exit early
	lda Enemy_Y,x
	cmp #$C0
	bcc Enemy14_Exit
	;Next task ($01: Wait)
	dec Enemy_Temp0,x
	;Restore enemy Y position
	lda Enemy_Temp2,x
	sta Enemy_Y,x
	;Clear enemy Y velocity/acceleration
	lda #$00
	sta Enemy_YAccel,x
	sta Enemy_YVelHi,x
	sta Enemy_YVelLo,x
	;Draw solid collision
	lda #$02
BGFakeBlockDrawCollision:
	;Draw collision tile row
	sta $02
	lda #$04
	sta $00
	ldy Enemy_Temp1,x
	lda BGFakeBlockVRAMAddrLo,y
	sta $01
	lda BGFakeBlockVRAMAddrHi,y
	tay
	jmp DrawCollisionTileRow
BGFakeBlockVRAMAddrHi:
	.db $25,$25,$25,$21
BGFakeBlockVRAMAddrLo:
	.db $B8,$B0,$64,$3C

;$6B: Asteroid falling
Enemy6B:
	;Check for break mode
	lda Enemy_Temp0,x
	cmp #$03
	beq Enemy6B_Sub0_Exit
	;If enemy Y position >= $98, setup next task ($03: Fall through)
	lda Enemy_Y,x
	cmp #$98
	bcc Enemy6B_JT
	;Next task ($03: Break)
	lda #$03
	sta Enemy_Temp0,x
	;Set enemy Y acceleration
	lda #$40
	sta Enemy_YAccel,x
	;Set enemy animation
	ldy #$95
	jmp SetEnemyAnimation
Enemy6B_JT:
	;Do jump table
	lda Enemy_Temp0,x
	jsr DoJumpTable
Enemy6BJumpTable:
	.dw Enemy6B_Sub0	;$00  Init
	.dw Enemy6B_Sub1	;$01  Quake
	.dw Enemy6B_Sub2	;$02  Fall
;$00: Init
Enemy6B_Sub0:
	;Check for death collision type (used by spikes)
	jsr AsteroidFallingCheckCollision
	beq Enemy6B_Sub0_Exit
	;Set animation timer
	lda #$18
	sta Enemy_Temp1,x
	;Next task ($01: Quake)
	inc Enemy_Temp0,x
Enemy6B_Sub0_Exit:
	rts
;$01: Quake
Enemy6B_Sub1:
	;Decrement animation timer, check if 0
	dec Enemy_Temp1,x
	beq Enemy6B_Sub1_Next
	;If bit 0 of animation timer not 0, exit early
	lda Enemy_Temp1,x
	and #$01
	bne Enemy6B_Sub0_Exit
	;Set enemy X position
	lda Enemy_X,x
	eor #$03
	sta Enemy_X,x
	rts
Enemy6B_Sub1_Next:
	;Set enemy Y acceleration
	lda #$40
	sta Enemy_YAccel,x
	;Next task (;$02: Fall)
	inc Enemy_Temp0,x
	rts
;$02: Fall
Enemy6B_Sub2:
	;If enemy Y velocity $04, clear enemy Y acceleration
	lda Enemy_YVelHi,x
	cmp #$04
	bne Enemy6B_Sub2_NoClearY
	;Clear enemy Y acceleration
	lda #$00
	sta Enemy_YAccel,x
Enemy6B_Sub2_NoClearY:
	;Check for death collision type (used by spikes)
	jsr AsteroidFallingCheckCollision
	bne Enemy6B_Sub0_Exit
	;Clear enemy Y velocity/acceleration
	lda #$00
	sta Enemy_YAccel,x
	sta Enemy_YVelHi,x
	sta Enemy_YVelLo,x
	;Next task ($00: Init)
	sta Enemy_Temp0,x
	rts
AsteroidFallingCheckCollision:
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
	rts

;$6C: BG appearing spikes
Enemy6C:
	;Do jump table
	lda Enemy_Temp0,x
	jsr DoJumpTable
Enemy6CJumpTable:
	.dw Enemy6C_Sub0	;$00  Init
	.dw Enemy6C_Sub1	;$00  Main
;$00: Init
Enemy6C_Sub0:
	;Init spikes VRAM address/offset based on parameter value
	ldy Enemy_Temp1,x
	lda BGAppearingSpikesVRAMAddrHi,y
	sta Enemy_Temp2,x
	lda BGAppearingSpikesVRAMAddrLo,y
	sta Enemy_Temp3,x
	lda BGAppearingSpikesVRAMOffs,y
	sta Enemy_Temp4,x
	;Set start Y position
	lda #$40
	sta Enemy_Temp6,x
	;Next task ($01: Main)
	inc Enemy_Temp0,x
Enemy6C_Sub0_Exit:
	rts
BGAppearingSpikesVRAMAddrHi:
	.db $24,$25,$26,$27,$24,$25,$26
BGAppearingSpikesVRAMAddrLo:
	.db $42,$42,$42,$42,$DC,$DC,$DC
BGAppearingSpikesVRAMOffs:
	.db $02,$02,$02,$02,$FE,$FE,$FE
;$01: Main
Enemy6C_Sub1:
	;If enemy Y position $40, play sound
	lda Enemy_Y,x
	cmp Enemy_Temp6,x
	beq Enemy6C_Sub1_Sound
	;If enemy Y position >= $40, draw spike tiles
	bcs Enemy6C_Sub1_NoSound
	rts
Enemy6C_Sub1_Sound:
	;Play sound
	ldy #SE_WHIRLASER1
	jsr LoadSound
Enemy6C_Sub1_NoSound:
	;If bits 0-2 of global timer != to parameter value, exit early
	lda LevelGlobalTimer
	and #$07
	cmp Enemy_Temp1,x
	bne Enemy6C_Sub0_Exit
	;Increment spikes VRAM address
	lda Enemy_Temp3,x
	clc
	adc Enemy_Temp4,x
	sta Enemy_Temp3,x
	;If spikes VRAM address low $50 or $CE, clear enemy flags
	sta $09
	cmp #$50
	beq Enemy6C_Sub1_ClearF
	cmp #$CE
	beq Enemy6C_Sub1_ClearF
	;Init VRAM buffer row
	lda Enemy_Temp2,x
	sta $08
	;Save X register
	stx $17
	;Init VRAM buffer row
	jsr WriteVRAMBufferCmd_InitRow
	;Set VRAM buffer address
	lda $09
	sta VRAMBuffer,x
	inx
	lda $08
	sta VRAMBuffer,x
	inx
	;Set spike tiles in VRAM
	lda #$FA
	sta VRAMBuffer,x
	inx
	lda #$FB
	sta VRAMBuffer,x
	inx
	;End VRAM buffer
	jsr WriteVRAMBufferCmd_End
	;Init VRAM buffer row
	jsr WriteVRAMBufferCmd_InitRow
	;Set VRAM buffer address
	lda $09
	clc
	adc #$20
	sta VRAMBuffer,x
	inx
	lda $08
	sta VRAMBuffer,x
	inx
	;Set spike tiles in VRAM
	lda #$FC
	sta VRAMBuffer,x
	inx
	lda #$FD
	sta VRAMBuffer,x
	inx
	;End VRAM buffer
	jsr WriteVRAMBufferCmd_End
	;Draw collision tile row
	ldy $08
	lda $09
	sta $01
	lda #$02
	sta $00
	lda #$03
	sta $02
	jsr DrawCollisionTileRow
	;Draw collision tile row
	ldy $08
	lda $09
	clc
	adc #$20
	sta $01
	lda #$02
	sta $00
	jsr DrawCollisionTileRow
	;Restore X register
	ldx $17
	rts
Enemy6C_Sub1_ClearF:
	;Clear enemy flags
	lda #$00
	sta Enemy_Flags,x
	rts

;$66: Caged pig
Enemy66:
	;Do jump table
	lda Enemy_Temp0,x
	jsr DoJumpTable
Enemy66JumpTable:
	.dw Enemy66_Sub0	;$00  Init
	.dw Enemy66_Sub1	;$01  Idle
	.dw Enemy66_Sub2	;$02  Run init
	.dw Enemy66_Sub3	;$03  Run
	.dw Enemy66_Sub4	;$04  Jump
;$00: Init
Enemy66_Sub0:
	;Set enemy flags
	lda #(EF_ACTIVE|EF_HITBULLET|EF_HITENEMY|EF_VISIBLE)
	sta Enemy_Flags,x
	;Set enemy priority to be behind background
	lda #$20
	sta Enemy_Props,x
	;Next task ($01: Idle)
	inc Enemy_Temp0,x
	rts
;$01: Idle
Enemy66_Sub1:
	;Check if player is to left or right
	lda Enemy_X,x
	bmi Enemy66_Sub1_Left
	;Don't flip enemy X
	lda #$20
	sta Enemy_Props,x
	rts
Enemy66_Sub1_Left:
	;Flip enemy X
	lda #$60
	sta Enemy_Props,x
	rts
;$02: Run init
Enemy66_Sub2:
	;Set enemy flags
	lda #(EF_ACTIVE|EF_INVINCIBLE|EF_HITBULLET|EF_HITENEMY|EF_VISIBLE)
	sta Enemy_Flags,x
	;Set enemy X velocity
	lda #$02
	sta Enemy_XVelHi,x
	;Set enemy priority to be behind background
	lda #$20
	sta Enemy_Props,x
	;Set animation timer
	lda #$10
	sta Enemy_Temp1,x
	;Set animation frame counter
	lda #$04
	sta Enemy_Temp2,x
	;Next task ($03: Run)
	inc Enemy_Temp0,x
Enemy66_Sub2_Exit:
	rts
;$03: Run
Enemy66_Sub3:
	;Decrement animation timer, check if 0
	dec Enemy_Temp1,x
	bne Enemy66_Sub2_Exit
	;Decrement animation frame counter, check if 0
	dec Enemy_Temp2,x
	beq Enemy66_Sub3_Jump
	;If animation frame counter $01, reset animation timer halfway
	lda Enemy_Temp2,x
	cmp #$01
	beq Enemy66_Sub3_Half
	;Reset animation timer
	lda #$20
	bne Enemy66_Sub3_SetT
Enemy66_Sub3_Half:
	;Reset animation timer
	lda #$11
Enemy66_Sub3_SetT:
	sta Enemy_Temp1,x
	;Flip enemy X velocity
	lda #$00
	sec
	sbc Enemy_XVelHi,x
	sta Enemy_XVelHi,x
	;Flip enemy X
	lda Enemy_Props,x
	eor #$40
	sta Enemy_Props,x
	rts
Enemy66_Sub3_Jump:
	;Set animation frame counter
	lda #$02
	sta Enemy_Temp2,x
	;Next task ($04: Jump)
	inc Enemy_Temp0,x
	;Set enemy animation
	ldy #$87
	jsr SetEnemyAnimation
	;Set enemy flags
	lda #(EF_ACTIVE|EF_INVINCIBLE|EF_HITBULLET|EF_HITENEMY|EF_VISIBLE)
	sta Enemy_Flags,x
Enemy66_Sub3_SetXY:
	;Clear enemy X velocity
	lda #$00
	sta Enemy_XVelHi,x
	;Set enemy Y velocity/acceleration
	lda #$F8
	sta Enemy_YVelHi,x
	lda #$7F
	sta Enemy_YAccel,x
	rts
;$04: Jump
Enemy66_Sub4:
	;If enemy Y position <= $53, exit early
	lda #$53
	cmp Enemy_Y,x
	bcs Enemy66_Sub2_Exit
	;Set enemy Y position
	sta Enemy_Y,x
	;Decrement animation frame counter, check if 0
	dec Enemy_Temp2,x
	bne Enemy66_Sub3_SetXY
	;Clear enemy Y velocity/acceleration
	lda #$00
	sta Enemy_YVelHi,x
	sta Enemy_YVelLo,x
	sta Enemy_YAccel,x
	;Set enemy animation
	ldy #$85
	jsr SetEnemyAnimation
	;Set enemy flags
	lda #(EF_ACTIVE|EF_INVINCIBLE|EF_HITBULLET|EF_HITENEMY|EF_VISIBLE)
	sta Enemy_Flags,x
	;Setup next task ($02: Run init)
	lda #$01
	sta Enemy_Temp0,x
	jmp Enemy66_Sub2

;$5E: BG chute crusher
Enemy5E:
	;If bit 3 of parameter value not 0, exit early
	lda Enemy_Temp1,x
	and #$08
	bne Enemy5E_Sub0_Exit
	;Do jump table
	lda Enemy_Temp0,x
	jsr DoJumpTable
Enemy5EJumpTable:
	.dw Enemy5E_Sub0	;$00  Init
	.dw Enemy5E_Sub1	;$01  Main
	.dw Enemy5E_Sub2	;$02  Finish
;$00: Init
Enemy5E_Sub0:
	;If enemy Y position >= $D0, exit early
	lda Enemy_Y,x
	cmp #$D0
	bcs Enemy5E_Sub0_Exit
	;Next task ($01: Main)
	inc Enemy_Temp0,x
	;Get VRAM strip data index
	lda Enemy_Temp1,x
	and #$01
	asl
	asl
	asl
	clc
	adc #$04
	sta Enemy_Temp2,x
	;Set enemy collision size
	lda #$01
	sta Enemy_CollWidth,x
	sta Enemy_CollWidth+$01,x
	lda #$0B
	sta Enemy_CollHeight,x
	sta Enemy_CollHeight+$01,x
	;Set enemy flags
	lda #(EF_ACTIVE|EF_NOANIM|EF_HITENEMY|EF_VISIBLE)
Enemy5E_Sub0_SetF:
	sta Enemy_Flags,x
	sta Enemy_Flags+$01,x
Enemy5E_Sub0_Exit:
	rts
;$01: Main
Enemy5E_Sub1:
	;If enemy Y position < $10, clear enemy flags
	lda Enemy_Y,x
	cmp #$10
	bcc Enemy5E_Sub1_ClearF
	;If bits 0-2 of global timer not 0, exit early
	lda LevelGlobalTimer
	and #$07
	bne Enemy5E_Sub0_Exit
	;Draw chute crusher VRAM strip based on parameter value and data index
	ldy Enemy_Temp1,x
	lda BGChuteCrusherVRAMStripBase,y
	ldy Enemy_Temp2,x
	clc
	adc BGChuteCrusherVRAMStripOffset,y
	ldy UpdateVRAMStripCount
	sta UpdateVRAMStripID,y
	inc UpdateVRAMStripCount
	;Check if moving in or out
	lda Enemy_Temp2,x
	and #$08
	beq Enemy5E_Sub1_In
	;Set enemy X position out
	lda Enemy_X,x
	sec
	sbc #$08
	sta Enemy_X,x
	lda Enemy_X+$01,x
	clc
	adc #$08
	sta Enemy_X+$01,x
	bne Enemy5E_Sub1_Next
Enemy5E_Sub1_In
	;Set enemy X position in
	lda Enemy_X,x
	clc
	adc #$08
	sta Enemy_X,x
	lda Enemy_X+$01,x
	sec
	sbc #$08
	sta Enemy_X+$01,x
Enemy5E_Sub1_Next:
	;Increment VRAM strip data index
	lda Enemy_Temp2,x
	clc
	adc #$01
	and #$0F
	sta Enemy_Temp2,x
;$02: Finish
Enemy5E_Sub2:
	rts
Enemy5E_Sub1_ClearF:
	;Clear enemy flags
	lda #$00
	beq Enemy5E_Sub0_SetF
BGChuteCrusherVRAMStripBase:
	.db $00,$08,$10,$18,$40,$48,$50,$58
BGChuteCrusherVRAMStripOffset:
	.db $00,$01,$02,$03,$04,$05,$06,$07
	.db $27,$26,$25,$24,$23,$22,$21,$20

;$64: Beetle moving up/down
Enemy64:
	;Check if already inited
	lda Enemy_Temp0,x
	bne Enemy64_NoInit
	;Mark inited
	inc Enemy_Temp0,x
	;Set enemy Y velocity based on parameter value
	ldy Enemy_Temp1,x
	lda BeetleUpDownYVelHi,y
	sta Enemy_YVelHi,x
	lda BeetleUpDownYVelLo,y
	;Set enemy props based on parameter value
	sta Enemy_YVelLo,x
	lda BeetleUpDownProps,y
	;Set enemy animation based on parameter value
	sta Enemy_Props,x
	lda BeetleUpDownAnim,y
	tay
	jmp SetEnemyAnimation
BeetleUpDownAnim:
	.db $7A,$7A,$9D,$FC
BeetleUpDownYVelHi:
	.db $00,$FF,$01,$FF
BeetleUpDownYVelLo:
	.db $80,$80,$00,$00
BeetleUpDownProps:
	.db $A0,$20,$00,$00
Enemy64_NoInit:
	;Wrap vertically
	lda Enemy_Y,x
	cmp #$D0
	beq Enemy64_Wrap
	cmp #$00
	bne Enemy64_Exit
	lda #$CF
	bne Enemy64_SetY
Enemy64_Wrap:
	lda #$01
Enemy64_SetY:
	sta Enemy_Y,x
Enemy64_Exit:
	rts

;UNUSED SPACE
	;$04 bytes of free space available
	;.db $FF,$FF,$FF,$FF

	.org $C000

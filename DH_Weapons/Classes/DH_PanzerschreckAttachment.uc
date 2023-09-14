//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_PanzerschreckAttachment extends DHRocketWeaponAttachment;

defaultproperties
{
    Mesh=SkeletalMesh'DH_Panzerschreck_3rd.Panzerschreck_3rd'
    MenuImage=Texture'DH_InterfaceArt_tex.weapon_icons.Panzerschreck_icon'
    mExhFlashClass=class'DH_Effects.DH3rdPersonPSchreckExhaustFX'
    mMuzFlashClass=class'DH_Effects.DHMuzzleFlash3rdBazooka'
    ExhaustBoneName="exhaust"
    MuzzleBoneName="Muzzle"
    WarheadBoneName="Warhead"
    bHideWarheadWhenFired=true

    BackAttachmentLocationOffset=(X=8.0,Y=2.0,Z=0.0)
    BackAttachmentRotationOffset=(Pitch=-2000,Roll=32000,Yaw=2000)

    WA_Idle="idle_rpzb"
    WA_Fire="idle_rpzb"
    WA_Reload="reload_rpzb"

    PA_AssistedReloadAnim="crouch_reload_assist_rpzb"
    PA_ProneAssistedReloadAnim="prone_reload_assist_rpzb"

    PA_MovementAnims(0)="stand_jogF_rpzb"
    PA_MovementAnims(1)="stand_jogB_rpzb"
    PA_MovementAnims(2)="stand_jogL_rpzb"
    PA_MovementAnims(3)="stand_jogR_rpzb"
    PA_MovementAnims(4)="stand_jogFL_rpzb"
    PA_MovementAnims(5)="stand_jogFR_rpzb"
    PA_MovementAnims(6)="stand_jogBL_rpzb"
    PA_MovementAnims(7)="stand_jogBR_rpzb"

    PA_CrouchAnims(0)="crouch_walkF_rpzb"
    PA_CrouchAnims(1)="crouch_walkB_rpzb"
    PA_CrouchAnims(2)="crouch_walkL_rpzb"
    PA_CrouchAnims(3)="crouch_walkR_rpzb"
    PA_CrouchAnims(4)="crouch_walkFL_rpzb"
    PA_CrouchAnims(5)="crouch_walkFR_rpzb"
    PA_CrouchAnims(6)="crouch_walkBL_rpzb"
    PA_CrouchAnims(7)="crouch_walkBR_rpzb"

    PA_ProneAnims(0)="prone_crawlF_rpzb"
    PA_ProneAnims(1)="prone_crawlB_rpzb"
    PA_ProneAnims(2)="prone_crawlL_rpzb"
    PA_ProneAnims(3)="prone_crawlR_rpzb"
    PA_ProneAnims(4)="prone_crawlFL_rpzb"
    PA_ProneAnims(5)="prone_crawlFR_rpzb"
    PA_ProneAnims(6)="prone_crawlBL_rpzb"
    PA_ProneAnims(7)="prone_crawlBR_rpzb"

    PA_ProneIronAnims(0)="prone_slowcrawlF_rpzb"
	PA_ProneIronAnims(1)="prone_slowcrawlB_rpzb"
	PA_ProneIronAnims(2)="prone_slowcrawlL_rpzb"
	PA_ProneIronAnims(3)="prone_slowcrawlR_rpzb"
	PA_ProneIronAnims(4)="prone_slowcrawlL_rpzb"
	PA_ProneIronAnims(5)="prone_slowcrawlR_rpzb"
	PA_ProneIronAnims(6)="prone_slowcrawlB_rpzb"
	PA_ProneIronAnims(7)="prone_slowcrawlB_rpzb"

    PA_WalkAnims(0)="stand_walkFhip_rpzb"
    PA_WalkAnims(1)="stand_walkBhip_rpzb"
    PA_WalkAnims(2)="stand_walkLhip_rpzb"
    PA_WalkAnims(3)="stand_walkRhip_rpzb"
    PA_WalkAnims(4)="stand_walkFLhip_rpzb"
    PA_WalkAnims(5)="stand_walkFRhip_rpzb"
    PA_WalkAnims(6)="stand_walkBLhip_rpzb"
    PA_WalkAnims(7)="stand_walkBRhip_rpzb"

    PA_WalkIronAnims(0)="stand_walkFiron_rpzb"
    PA_WalkIronAnims(1)="stand_walkBiron_rpzb"
    PA_WalkIronAnims(2)="stand_walkLiron_rpzb"
    PA_WalkIronAnims(3)="stand_walkRiron_rpzb"
    PA_WalkIronAnims(4)="stand_walkFLiron_rpzb"
    PA_WalkIronAnims(5)="stand_walkFRiron_rpzb"
    PA_WalkIronAnims(6)="stand_walkBLiron_rpzb"
    PA_WalkIronAnims(7)="stand_walkBRiron_rpzb"

    PA_SprintAnims(0)="stand_sprintF_rpzb"
    PA_SprintAnims(1)="stand_sprintB_rpzb"
    PA_SprintAnims(2)="stand_sprintL_rpzb"
    PA_SprintAnims(3)="stand_sprintR_rpzb"
    PA_SprintAnims(4)="stand_sprintFL_rpzb"
    PA_SprintAnims(5)="stand_sprintFR_rpzb"
    PA_SprintAnims(6)="stand_sprintBL_rpzb"
    PA_SprintAnims(7)="stand_sprintBR_rpzb"

    PA_SprintCrouchAnims(0)="crouch_sprintF_rpzb"
    PA_SprintCrouchAnims(1)="crouch_sprintB_rpzb"
    PA_SprintCrouchAnims(2)="crouch_sprintL_rpzb"
    PA_SprintCrouchAnims(3)="crouch_sprintR_rpzb"
    PA_SprintCrouchAnims(4)="crouch_sprintFL_rpzb"
    PA_SprintCrouchAnims(5)="crouch_sprintFR_rpzb"
    PA_SprintCrouchAnims(6)="crouch_sprintBL_rpzb"
    PA_SprintCrouchAnims(7)="crouch_sprintBR_rpzb"

    PA_TurnRightAnim="stand_turnRrest_rpzb"
    PA_TurnLeftAnim="stand_turnLrest_rpzb"
    PA_TurnIronRightAnim="stand_turnRiron_rpzb"
    PA_TurnIronLeftAnim="stand_turnLiron_rpzb"
    PA_ProneTurnRightAnim="prone_turnR_rpzb"
    PA_ProneTurnLeftAnim="prone_turnL_rpzb"

    PA_CrouchTurnIronRightAnim="crouch_turnRiron_rpzb"
    PA_CrouchTurnIronLeftAnim="crouch_turnRiron_rpzb"
	PA_CrouchTurnRightAnim="crouch_turnR_rpzb"
	PA_CrouchTurnLeftAnim="crouch_turnL_rpzb"

    PA_StandToProneAnim="StandtoProne_rpzb"
    PA_CrouchToProneAnim="CrouchtoProne_rpzb"
    PA_ProneToStandAnim="PronetoStand_rpzb"
    PA_ProneToCrouchAnim="PronetoCrouch_rpzb"

    PA_DiveToProneStartAnim="prone_diveF_rpzb"
    PA_DiveToProneEndAnim="prone_diveend_rpzb"

    PA_CrouchIdleRestAnim="crouch_idle_rpzb"
    PA_IdleCrouchAnim="crouch_idle_rpzb"
    PA_IdleRestAnim="stand_idlerest_rpzb"
    PA_IdleWeaponAnim="stand_idlerest_rpzb"
    PA_IdleIronRestAnim="stand_idleiron_rpzb"
    PA_IdleIronWeaponAnim="stand_idleiron_rpzb"
    PA_IdleCrouchIronWeaponAnim="crouch_idleiron_rpzb"
    PA_IdleProneAnim="prone_idle_rpzb"
    PA_ReloadAnim="crouch_reload_rpzb"
    PA_ReloadEmptyAnim="crouch_reload_rpzb"
    PA_ProneReloadEmptyAnim="prone_reload_rpzb"
    PA_ProneIdleRestAnim="prone_idle_rpzb"
    PA_Fire="stand_shootiron_rpzb"
    PA_IronFire="stand_shootiron_rpzb"
    PA_CrouchFire="crouch_shootiron_rpzb"
    PA_CrouchIronFire="crouch_shootiron_rpzb"
    PA_ProneFire="prone_shoot_rpzb"

    PA_MoveStandFire(0)="stand_shootiron_rpzb"
    PA_MoveStandFire(1)="stand_shootiron_rpzb"
    PA_MoveStandFire(2)="stand_shootLRiron_rpzb"
    PA_MoveStandFire(3)="stand_shootLRiron_rpzb"
    PA_MoveStandFire(4)="stand_shootFLiron_rpzb"
    PA_MoveStandFire(5)="stand_shootFRiron_rpzb"
    PA_MoveStandFire(6)="stand_shootFRiron_rpzb"
    PA_MoveStandFire(7)="stand_shootFLiron_rpzb"

    PA_MoveCrouchFire(0)="crouch_shootF_rpzb"
    PA_MoveCrouchFire(1)="crouch_shootF_rpzb"
    PA_MoveCrouchFire(2)="crouch_shootLR_rpzb"
    PA_MoveCrouchFire(3)="crouch_shootLR_rpzb"
    PA_MoveCrouchFire(4)="crouch_shootF_rpzb"
    PA_MoveCrouchFire(5)="crouch_shootF_rpzb"
    PA_MoveCrouchFire(6)="crouch_shootF_rpzb"
    PA_MoveCrouchFire(7)="crouch_shootF_rpzb"

    PA_MoveWalkFire(0)="stand_shootFwalk_rpzb"
    PA_MoveWalkFire(1)="stand_shootFwalk_rpzb"
    PA_MoveWalkFire(2)="stand_shootLRwalk_rpzb"
    PA_MoveWalkFire(3)="stand_shootLRwalk_rpzb"
    PA_MoveWalkFire(4)="stand_shootFLwalk_rpzb"
    PA_MoveWalkFire(5)="stand_shootFRwalk_rpzb"
    PA_MoveWalkFire(6)="stand_shootFRwalk_rpzb"
    PA_MoveWalkFire(7)="stand_shootFLwalk_rpzb"

    PA_MoveStandIronFire(0)="stand_shootiron_rpzb"
    PA_MoveStandIronFire(1)="stand_shootiron_rpzb"
    PA_MoveStandIronFire(2)="stand_shootLRiron_rpzb"
    PA_MoveStandIronFire(3)="stand_shootLRiron_rpzb"
    PA_MoveStandIronFire(4)="stand_shootFLiron_rpzb"
    PA_MoveStandIronFire(5)="stand_shootFRiron_rpzb"
    PA_MoveStandIronFire(6)="stand_shootFRiron_rpzb"
    PA_MoveStandIronFire(7)="stand_shootFLiron_rpzb"

    PA_AltFire="stand_idlestrike_kar" // unused
    PA_CrouchAltFire="stand_idlestrike_kar" // unused
    PA_ProneAltFire="prone_idlestrike_bayo"
    PA_FireLastShot="stand_shoothip_kar" // unused
    PA_IronFireLastShot="crouch_shoot_rpzb"
    PA_CrouchFireLastShot="crouch_shoot_rpzb"
    PA_ProneFireLastShot="prone_shoot_rpzb"

    PA_AirStillAnim=jump_mid_rpzb
    PA_AirAnims(0)=jumpF_mid_rpzb
    PA_AirAnims(1)=jumpB_mid_rpzb
    PA_AirAnims(2)=jumpL_mid_rpzb
    PA_AirAnims(3)=jumpR_mid_rpzb
    PA_TakeoffStillAnim=jump_takeoff_rpzb
    PA_TakeoffAnims(0)=jumpF_takeoff_rpzb
    PA_TakeoffAnims(1)=jumpB_takeoff_rpzb
    PA_TakeoffAnims(2)=jumpL_takeoff_rpzb
    PA_TakeoffAnims(3)=jumpR_takeoff_rpzb
    PA_LandAnims(0)=jumpF_land_rpzb
    PA_LandAnims(1)=jumpB_land_rpzb
    PA_LandAnims(2)=jumpL_land_rpzb
    PA_LandAnims(3)=jumpR_land_rpzb
    PA_DodgeAnims(0)=jumpF_mid_rpzb
    PA_DodgeAnims(1)=jumpB_mid_rpzb
    PA_DodgeAnims(2)=jumpL_mid_rpzb
    PA_DodgeAnims(3)=jumpR_mid_rpzb
}

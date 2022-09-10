//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DH_PIATAttachment extends DHRocketWeaponAttachment;

defaultproperties
{
    Mesh=SkeletalMesh'DH_PIAT_3rd.PIAT_3rd'
    MenuImage=Texture'DH_PIAT_tex.weapon_icons.PIAT_icon'
    mMuzFlashClass=class'DH_Effects.DHMuzzleFlash3rdPIAT'
    MuzzleBoneName=Muzzle
    WarheadBoneName=Bomb
    bHideWarheadWhenFired=true
    bHeavy=true
    bStaticReload=true
    bInitiallyLoaded=true

    WA_Idle="idle_piat"
    WA_Fire="idle_piat"
    WA_Reload="stand_reload_piat"
    WA_CrouchReload="crouch_reload_piat"
    WA_ProneReload="prone_reload_piat"

    PA_MovementAnims(0)="stand_jogF_piat"
    PA_MovementAnims(1)="stand_jogB_piat"
    PA_MovementAnims(2)="stand_jogL_piat"
    PA_MovementAnims(3)="stand_jogR_piat"
    PA_MovementAnims(4)="stand_jogFL_piat"
    PA_MovementAnims(5)="stand_jogFR_piat"
    PA_MovementAnims(6)="stand_jogBL_piat"
    PA_MovementAnims(7)="stand_jogBR_piat"

    PA_CrouchAnims(0)="crouch_walkF_piat"
    PA_CrouchAnims(1)="crouch_walkB_piat"
    PA_CrouchAnims(2)="crouch_walkL_piat"
    PA_CrouchAnims(3)="crouch_walkR_piat"
    PA_CrouchAnims(4)="crouch_walkFL_piat"
    PA_CrouchAnims(5)="crouch_walkFR_piat"
    PA_CrouchAnims(6)="crouch_walkBL_piat"
    PA_CrouchAnims(7)="crouch_walkBR_piat"

    PA_ProneAnims(0)="prone_crawlF_piat"
    PA_ProneAnims(1)="prone_crawlB_piat"
    PA_ProneAnims(2)="prone_crawlL_piat"
    PA_ProneAnims(3)="prone_crawlR_piat"
    PA_ProneAnims(4)="prone_crawlFL_piat"
    PA_ProneAnims(5)="prone_crawlFR_piat"
    PA_ProneAnims(6)="prone_crawlBL_piat"
    PA_ProneAnims(7)="prone_crawlBR_piat"

    PA_WalkAnims(0)="stand_walkFhip_piat"
    PA_WalkAnims(1)="stand_walkBhip_piat"
    PA_WalkAnims(2)="stand_walkLhip_piat"
    PA_WalkAnims(3)="stand_walkRhip_piat"
    PA_WalkAnims(4)="stand_walkFLhip_piat"
    PA_WalkAnims(5)="stand_walkFRhip_piat"
    PA_WalkAnims(6)="stand_walkBLhip_piat"
    PA_WalkAnims(7)="stand_walkBRhip_piat"

    PA_WalkIronAnims(0)="stand_walkFiron_piat"
    PA_WalkIronAnims(1)="stand_walkBiron_piat"
    PA_WalkIronAnims(2)="stand_walkLiron_piat"
    PA_WalkIronAnims(3)="stand_walkRiron_piat"
    PA_WalkIronAnims(4)="stand_walkFLiron_piat"
    PA_WalkIronAnims(5)="stand_walkFRiron_piat"
    PA_WalkIronAnims(6)="stand_walkBLiron_piat"
    PA_WalkIronAnims(7)="stand_walkBRiron_piat"

    PA_SprintAnims(0)="stand_sprintF_piat"
    PA_SprintAnims(1)="stand_sprintB_piat"
    PA_SprintAnims(2)="stand_sprintL_piat"
    PA_SprintAnims(3)="stand_sprintR_piat"
    PA_SprintAnims(4)="stand_sprintFL_piat"
    PA_SprintAnims(5)="stand_sprintFR_piat"
    PA_SprintAnims(6)="stand_sprintBL_piat"
    PA_SprintAnims(7)="stand_sprintBR_piat"

    PA_SprintCrouchAnims(0)="crouch_sprintF_piat"
    PA_SprintCrouchAnims(1)="crouch_sprintB_piat"
    PA_SprintCrouchAnims(2)="crouch_sprintL_piat"
    PA_SprintCrouchAnims(3)="crouch_sprintR_piat"
    PA_SprintCrouchAnims(4)="crouch_sprintFL_piat"
    PA_SprintCrouchAnims(5)="crouch_sprintFR_piat"
    PA_SprintCrouchAnims(6)="crouch_sprintBL_piat"
    PA_SprintCrouchAnims(7)="crouch_sprintBR_piat"

    PA_TurnRightAnim="stand_turnRrest_piat"
    PA_TurnLeftAnim="stand_turnLrest_piat"
    PA_TurnIronRightAnim="stand_turnRiron_piat"
    PA_TurnIronLeftAnim="stand_turnLiron_piat"

    PA_CrouchTurnIronRightAnim="crouch_turnRiron_piat"
    PA_CrouchTurnIronLeftAnim="crouch_turnRiron_piat"

    PA_ProneTurnRightAnim="prone_turnR_piat"
    PA_ProneTurnLeftAnim="prone_turnL_piat"

    PA_StandToProneAnim="StandtoProne_piat"
    PA_CrouchToProneAnim="CrouchtoProne_piat"
    PA_ProneToStandAnim="PronetoStand_piat"
    PA_ProneToCrouchAnim="PronetoCrouch_piat"

    PA_DiveToProneStartAnim="prone_diveF_kar"
    PA_DiveToProneEndAnim="prone_diveend_faust"

    PA_CrouchTurnRightAnim="crouch_turnR_piat"
    PA_CrouchTurnLeftAnim="crouch_turnL_piat"
    PA_CrouchIdleRestAnim="crouch_idle_piat"

    PA_IdleCrouchAnim="crouch_idle_piat"
    PA_IdleRestAnim="stand_idlerest_piat"
    PA_IdleWeaponAnim="stand_idlerest_piat"
    PA_IdleIronRestAnim="stand_idleiron_piat"
    PA_IdleIronWeaponAnim="stand_idleiron_piat"
    PA_IdleCrouchIronWeaponAnim="crouch_idleiron_piat"
    PA_IdleProneAnim="prone_idle_piat"
    PA_ProneIdleRestAnim="prone_idle_piat"

    PA_Fire="stand_shootiron_piat"
    PA_IronFire="stand_shootiron_piat"
    PA_CrouchFire="crouch_shoot_piat"
    PA_ProneFire="prone_shoot_piat"

    PA_MoveCrouchFire(0)="crouch_shootF_piat"
    PA_MoveCrouchFire(1)="crouch_shootF_piat"
    PA_MoveCrouchFire(2)="crouch_shootLR_piat"
    PA_MoveCrouchFire(3)="crouch_shootLR_piat"
    PA_MoveCrouchFire(4)="crouch_shootF_piat"
    PA_MoveCrouchFire(5)="crouch_shootF_piat"
    PA_MoveCrouchFire(6)="crouch_shootF_piat"
    PA_MoveCrouchFire(7)="crouch_shootF_piat"

    PA_MoveStandIronFire(0)="stand_shootiron_piat"
    PA_MoveStandIronFire(1)="stand_shootiron_piat"
    PA_MoveStandIronFire(2)="stand_shootLRiron_piat"
    PA_MoveStandIronFire(3)="stand_shootLRiron_piat"
    PA_MoveStandIronFire(4)="stand_shootFLiron_piat"
    PA_MoveStandIronFire(5)="stand_shootFRiron_piat"
    PA_MoveStandIronFire(6)="stand_shootFRiron_piat"
    PA_MoveStandIronFire(7)="stand_shootFLiron_piat"


    // RELOAD

    PA_ReloadAnim="stand_reload_piat"
    PA_CrouchReloadAnim="crouch_reload_piat"
    PA_CrouchReloadEmptyAnim="crouch_reload_piat"
    PA_ProneReloadAnim="prone_reload_piat"
    PA_ReloadEmptyAnim="stand_reload_piat"
    PA_ProneReloadEmptyAnim="prone_reload_piat"


    // DEPLOYMENT

    PA_IdleDeployedAnim="stand_idleiron_piat"
    PA_IdleDeployedProneAnim="prone_idle_piat"
    PA_IdleDeployedCrouchAnim="crouch_idledeploy_piat"

    PA_StandWeaponDeployAnim="stand_idleiron_piat"
    PA_ProneWeaponDeployAnim="prone_idle_piat"
    PA_StandWeaponUnDeployAnim="stand_idleiron_piat"
    PA_ProneWeaponUnDeployAnim="prone_idle_piat"

    PA_DeployedFire="stand_shootiron_piat"
    PA_CrouchDeployedFire="crouch_shootdeploy_piat"
    PA_ProneDeployedFire="prone_shoot_piat"


    // UNAVAILABLE

    PA_FireLastShot="stand_shootiron_piat"
    PA_IronFireLastShot="stand_shootiron_piat"
    PA_CrouchFireLastShot="crouch_shoot_piat"
    PA_ProneFireLastShot="prone_shoot_piat"

    PA_AltFire="stand_idlestrike_kar"
    PA_CrouchAltFire="stand_idlestrike_kar"
    PA_ProneAltFire="prone_idlestrike_bayo"

    PA_ProneIronAnims(0)="prone_slowcrawlF_faust"
    PA_ProneIronAnims(1)="prone_slowcrawlB_faust"
    PA_ProneIronAnims(2)="prone_slowcrawlL_faust"
    PA_ProneIronAnims(3)="prone_slowcrawlR_faust"
    PA_ProneIronAnims(4)="prone_slowcrawlL_faust"
    PA_ProneIronAnims(5)="prone_slowcrawlR_faust"
    PA_ProneIronAnims(6)="prone_slowcrawlB_faust"
    PA_ProneIronAnims(7)="prone_slowcrawlB_faust"

    PA_MoveWalkFire(0)="stand_shootFwalk_faust"
    PA_MoveWalkFire(1)="stand_shootFwalk_faust"
    PA_MoveWalkFire(2)="stand_shootLRwalk_faust"
    PA_MoveWalkFire(3)="stand_shootLRwalk_faust"
    PA_MoveWalkFire(4)="stand_shootFLwalk_faust"
    PA_MoveWalkFire(5)="stand_shootFRwalk_faust"
    PA_MoveWalkFire(6)="stand_shootFRwalk_faust"
    PA_MoveWalkFire(7)="stand_shootFLwalk_faust"

    PA_MoveStandFire(0)="stand_shootiron_piat"
    PA_MoveStandFire(1)="stand_shootiron_piat"
    PA_MoveStandFire(2)="stand_shootLRiron_piat"
    PA_MoveStandFire(3)="stand_shootLRiron_piat"
    PA_MoveStandFire(4)="stand_shootFLiron_piat"
    PA_MoveStandFire(5)="stand_shootFRiron_piat"
    PA_MoveStandFire(6)="stand_shootFRiron_piat"
    PA_MoveStandFire(7)="stand_shootFLiron_piat"

    PA_AirStillAnim=jump_mid_piat
    PA_AirAnims(0)=jumpF_mid_piat
    PA_AirAnims(1)=jumpB_mid_piat
    PA_AirAnims(2)=jumpL_mid_piat
    PA_AirAnims(3)=jumpR_mid_piat
    PA_TakeoffStillAnim=jump_takeoff_piat
    PA_TakeoffAnims(0)=jumpF_takeoff_piat
    PA_TakeoffAnims(1)=jumpB_takeoff_piat
    PA_TakeoffAnims(2)=jumpL_takeoff_piat
    PA_TakeoffAnims(3)=jumpR_takeoff_piat
    PA_LandAnims(0)=jumpF_land_piat
    PA_LandAnims(1)=jumpB_land_piat
    PA_LandAnims(2)=jumpL_land_piat
    PA_LandAnims(3)=jumpR_land_piat
    PA_DodgeAnims(0)=jumpF_mid_piat
    PA_DodgeAnims(1)=jumpB_mid_piat
    PA_DodgeAnims(2)=jumpL_mid_piat
    PA_DodgeAnims(3)=jumpR_mid_piat
}

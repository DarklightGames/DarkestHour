//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DH_Breda30Attachment extends DHWeaponAttachment;

defaultproperties
{
    Mesh=SkeletalMesh'DH_Breda30_anm.Breda30_world'
    MenuImage=Texture'DH_Breda30_tex.weapon_icons.breda30_icon'
    
    mMuzFlashClass=class'ROEffects.MuzzleFlash3rdSTG'
    ROShellCaseClass=class'ROAmmo.RO3rdShellEject762x54mm'
    MuzzleBoneName="MUZZLE"
    ShellEjectionBoneName="EJECTOR"

    WA_Idle="idle_breda"
    WA_IdleEmpty="idle_breda"
    WA_ProneIdle="idle_breda"
    WA_DeployedIdle="idle_breda"
    WA_Fire="idle_breda"
    WA_DeployedFire="idle_breda"
    WA_Reload="idle_breda"
    WA_ReloadEmpty="idle_breda"
    WA_CrouchReload="idle_breda"
    WA_CrouchReloadEmpty="idle_breda"
    WA_ProneReload="idle_breda"
    WA_ProneReloadEmpty="idle_breda"


    // STAND

    PA_IdleDeployedAnim="stand_idleiron_breda"
    PA_IdleIronRestAnim="stand_idlerest_breda"
    PA_IdleIronWeaponAnim="stand_idlehip_breda"

    PA_StandWeaponDeployAnim="stand_idleiron_breda"
    PA_StandWeaponUnDeployAnim="stand_idlehip_breda"
    PA_DeployedFire="stand_shootiron_breda"

    PA_IdleRestAnim="stand_idlerest_breda"
    PA_IdleWeaponAnim="stand_idlehip_breda"

    PA_Fire="stand_shoothip_breda"
    PA_IronFire="stand_shoothip_breda"

    PA_TurnRightAnim="stand_turnRrest_breda"
    PA_TurnLeftAnim="stand_turnLrest_breda"
    PA_TurnIronRightAnim="stand_turnRhip_breda"
    PA_TurnIronLeftAnim="stand_turnLhip_breda"

    PA_ReloadAnim="stand_reload_m1919"      // TODO: PLACEHOLDER
    PA_ReloadEmptyAnim="stand_reload_m1919" // TODO: PLACEHOLDER

    PA_MoveStandIronFire(0)="stand_shootFwalk_breda"
    PA_MoveStandIronFire(1)="stand_shootFwalk_breda"
    PA_MoveStandIronFire(2)="stand_shootLRwalk_breda"
    PA_MoveStandIronFire(3)="stand_shootLRwalk_breda"
    PA_MoveStandIronFire(4)="stand_shootFLwalk_breda"
    PA_MoveStandIronFire(5)="stand_shootFRwalk_breda"
    PA_MoveStandIronFire(6)="stand_shootFRwalk_breda"
    PA_MoveStandIronFire(7)="stand_shootFLwalk_breda"

    PA_MovementAnims(0)="stand_jogF_breda"
    PA_MovementAnims(1)="stand_jogB_breda"
    PA_MovementAnims(2)="stand_jogL_breda"
    PA_MovementAnims(3)="stand_jogR_breda"
    PA_MovementAnims(4)="stand_jogFL_breda"
    PA_MovementAnims(5)="stand_jogFR_breda"
    PA_MovementAnims(6)="stand_jogBL_breda"
    PA_MovementAnims(7)="stand_jogBR_breda"

    PA_SprintAnims(0)="stand_sprintF_breda"
    PA_SprintAnims(1)="stand_sprintB_breda"
    PA_SprintAnims(2)="stand_sprintL_breda"
    PA_SprintAnims(3)="stand_sprintR_breda"
    PA_SprintAnims(4)="stand_sprintFL_breda"
    PA_SprintAnims(5)="stand_sprintFR_breda"
    PA_SprintAnims(6)="stand_sprintBL_breda"
    PA_SprintAnims(7)="stand_sprintBR_breda"

    PA_WalkAnims(0)="stand_walkFhip_breda"
    PA_WalkAnims(1)="stand_walkBhip_breda"
    PA_WalkAnims(2)="stand_walkLhip_breda"
    PA_WalkAnims(3)="stand_walkRhip_breda"
    PA_WalkAnims(4)="stand_walkFLhip_breda"
    PA_WalkAnims(5)="stand_walkFRhip_breda"
    PA_WalkAnims(6)="stand_walkBLhip_breda"
    PA_WalkAnims(7)="stand_walkBRhip_breda"

    PA_MoveStandFire(0)="stand_shootFwalk_breda"
    PA_MoveStandFire(1)="stand_shootFwalk_breda"
    PA_MoveStandFire(2)="stand_shootLRwalk_breda"
    PA_MoveStandFire(3)="stand_shootLRwalk_breda"
    PA_MoveStandFire(4)="stand_shootFLwalk_breda"
    PA_MoveStandFire(5)="stand_shootFRwalk_breda"
    PA_MoveStandFire(6)="stand_shootFRwalk_breda"
    PA_MoveStandFire(7)="stand_shootFLwalk_breda"

    PA_MoveWalkFire(0)="stand_shootFwalk_breda"
    PA_MoveWalkFire(1)="stand_shootFwalk_breda"
    PA_MoveWalkFire(2)="stand_shootLRwalk_breda"
    PA_MoveWalkFire(3)="stand_shootLRwalk_breda"
    PA_MoveWalkFire(4)="stand_shootFLwalk_breda"
    PA_MoveWalkFire(5)="stand_shootFRwalk_breda"
    PA_MoveWalkFire(6)="stand_shootFRwalk_breda"
    PA_MoveWalkFire(7)="stand_shootFLwalk_breda"

    PA_WalkIronAnims(0)="stand_walkFhip_breda"
    PA_WalkIronAnims(1)="stand_walkBhip_breda"
    PA_WalkIronAnims(2)="stand_walkLhip_breda"
    PA_WalkIronAnims(3)="stand_walkRhip_breda"
    PA_WalkIronAnims(4)="stand_walkFLhip_breda"
    PA_WalkIronAnims(5)="stand_walkFRhip_breda"
    PA_WalkIronAnims(6)="stand_walkBLhip_breda"
    PA_WalkIronAnims(7)="stand_walkBRhip_breda"


    // CROUCH

    PA_CrouchTurnIronRightAnim="crouch_turnR_breda"
    PA_CrouchTurnIronLeftAnim="crouch_turnR_breda"
    PA_CrouchTurnRightAnim="crouch_turnR_breda"
    PA_CrouchTurnLeftAnim="crouch_turnL_breda"

    PA_IdleCrouchAnim="crouch_idle_breda"
    PA_CrouchIdleRestAnim="crouch_idle_breda"
    PA_IdleCrouchIronWeaponAnim="crouch_idle_breda"

    PA_CrouchFire="crouch_shoot_breda"
    PA_CrouchIronFire="crouch_shoot_breda"
    PA_CrouchAltFire="crouch_shoot_breda"
    PA_CrouchFireLastShot="crouch_shoot_breda"

    PA_CrouchDeployedFire="crouch_shootiron_breda"
    PA_IdleDeployedCrouchAnim="crouch_idleiron_breda"

    PA_CrouchReloadAnim="crouch_reload_m1919"      // TODO: PLACEHOLDER
    PA_CrouchReloadEmptyAnim="crouch_reload_m1919" // TODO: PLACEHOLDER

    PA_CrouchAnims(0)="crouch_walkF_breda"
    PA_CrouchAnims(1)="crouch_walkB_breda"
    PA_CrouchAnims(2)="crouch_walkL_breda"
    PA_CrouchAnims(3)="crouch_walkR_breda"
    PA_CrouchAnims(4)="crouch_walkFL_breda"
    PA_CrouchAnims(5)="crouch_walkFR_breda"
    PA_CrouchAnims(6)="crouch_walkBL_breda"
    PA_CrouchAnims(7)="crouch_walkBR_breda"

    PA_MoveCrouchFire(0)="crouch_shootF_breda"
    PA_MoveCrouchFire(1)="crouch_shootF_breda"
    PA_MoveCrouchFire(2)="crouch_shootLR_breda"
    PA_MoveCrouchFire(3)="crouch_shootLR_breda"
    PA_MoveCrouchFire(4)="crouch_shootF_breda"
    PA_MoveCrouchFire(5)="crouch_shootF_breda"
    PA_MoveCrouchFire(6)="crouch_shootF_breda"
    PA_MoveCrouchFire(7)="crouch_shootF_breda"

    PA_SprintCrouchAnims(0)="crouch_sprintF_breda"
    PA_SprintCrouchAnims(1)="crouch_sprintB_breda"
    PA_SprintCrouchAnims(2)="crouch_sprintL_breda"
    PA_SprintCrouchAnims(3)="crouch_sprintR_breda"
    PA_SprintCrouchAnims(4)="crouch_sprintFL_breda"
    PA_SprintCrouchAnims(5)="crouch_sprintFR_breda"
    PA_SprintCrouchAnims(6)="crouch_sprintBL_breda"
    PA_SprintCrouchAnims(7)="crouch_sprintBR_breda"


    // PRONE

    PA_IdleProneAnim="prone_idle_breda"
    PA_ProneTurnRightAnim="prone_turnR_breda"
    PA_ProneTurnLeftAnim="prone_turnL_breda"
    PA_ProneWeaponUnDeployAnim="prone_idle_breda"
    PA_IdleDeployedProneAnim="prone_idle_breda"
    PA_ProneFireLastShot="prone_shoot_breda"

    PA_ProneReloadAnim="prone_reload_m1919"      // TODO: PLACEHOLDER
    PA_ProneReloadEmptyAnim="prone_reload_m1919" // TODO: PLACEHOLDER

    PA_ProneIdleRestAnim="prone_idle_breda"
    PA_ProneWeaponDeployAnim="prone_idle_breda"
    PA_ProneFire="prone_shoot_breda"
    PA_ProneDeployedFire="prone_shoot_breda"

    PA_ProneAnims(0)="prone_crawlF_breda"
    PA_ProneAnims(1)="prone_crawlB_breda"
    PA_ProneAnims(2)="prone_crawlL_breda"
    PA_ProneAnims(3)="prone_crawlR_breda"
    PA_ProneAnims(4)="prone_crawlFL_breda"
    PA_ProneAnims(5)="prone_crawlFR_breda"
    PA_ProneAnims(6)="prone_crawlBL_breda"
    PA_ProneAnims(7)="prone_crawlBR_breda"


    // TRANSITIONS

    PA_StandToProneAnim="StandtoProne_breda"
    PA_CrouchToProneAnim="CrouchtoProne_breda"
    PA_ProneToStandAnim="PronetoStand_breda"
    PA_ProneToCrouchAnim="PronetoCrouch_breda"
    PA_DiveToProneStartAnim="prone_diveF_breda"
    PA_DiveToProneEndAnim="prone_diveend_breda"


    // JUMPs

    PA_AirStillAnim="jump_mid_breda"
    PA_AirAnims(0)="jumpF_mid_breda"
    PA_AirAnims(1)="jumpB_mid_breda"
    PA_AirAnims(2)="jumpL_mid_breda"
    PA_AirAnims(3)="jumpR_mid_breda"
    PA_TakeoffStillAnim="jump_takeoff_breda"
    PA_TakeoffAnims(0)="jumpF_takeoff_breda"
    PA_TakeoffAnims(1)="jumpB_takeoff_breda"
    PA_TakeoffAnims(2)="jumpL_takeoff_breda"
    PA_TakeoffAnims(3)="jumpR_takeoff_breda"
    PA_LandAnims(0)="jumpF_land_breda"
    PA_LandAnims(1)="jumpB_land_breda"
    PA_LandAnims(2)="jumpL_land_breda"
    PA_LandAnims(3)="jumpR_land_breda"
    PA_DodgeAnims(0)="jumpF_mid_breda"
    PA_DodgeAnims(1)="jumpB_mid_breda"
    PA_DodgeAnims(2)="jumpL_mid_breda"
    PA_DodgeAnims(3)="jumpR_mid_breda"
}

//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================
// TODO:
// - Export WA_ reloads
// - Add more bob to crouch walk anims
// - Fix "invalid bone index" log spam
// - Fix PA_ fire animations not playing
// - Fix elbows on left/right crouch walks
// - Fix missing reference for crouch fire animation

class DH_30calAttachment extends DHHighROFWeaponAttachment;

defaultproperties
{
    Mesh=SkeletalMesh'DH_M1919_anm.M1919A6_world'
    MenuImage=Texture'DH_M1919_tex.interface.m1919a6_icon'
    mMuzFlashClass=class'ROEffects.MuzzleFlash3rdMG'
    ROShellCaseClass=class'ROAmmo.RO3rdShellEject762x54mm'
    MuzzleBoneName="Muzzle"
    ShellEjectionBoneName="ejector"
    bStaticReload=true

    ClientProjectileClass=class'DH_Weapons.DH_30calBullet'
    bUsesTracers=true
    TracerFrequency=5
    ClientTracerClass=class'DH_Weapons.DH_30calTracerBullet'

    WA_Idle="idle_m1919"
    WA_IdleEmpty="idle_m1919"
    WA_Fire="idle_m1919"
    WA_Reload="idle_m1919"
    WA_ReloadEmpty="idle_m1919"
    WA_ProneReload="idle_m1919"
    WA_ProneReloadEmpty="idle_m1919"


    // STAND

    PA_IdleDeployedAnim="stand_idleiron_m1919"
    PA_IdleIronRestAnim="stand_idlerest_m1919"
    PA_IdleIronWeaponAnim="stand_idlehip_m1919"

    PA_StandWeaponDeployAnim="stand_idleiron_m1919"
    PA_StandWeaponUnDeployAnim="stand_idlehip_m1919"
    PA_DeployedFire="stand_shootiron_m1919"

    PA_IdleRestAnim="stand_idlerest_m1919"
    PA_IdleWeaponAnim="stand_idlehip_m1919"

    PA_Fire="stand_shoothip_m1919"
    PA_IronFire="stand_shoothip_m1919"

    // PA_AltFire="single_iron_m1919"

    PA_TurnRightAnim="stand_turnR_m1919"
    PA_TurnLeftAnim="stand_turnL_m1919"
    PA_TurnIronRightAnim="stand_turnRiron_m1919"
    PA_TurnIronLeftAnim="stand_turnLiron_m1919"

    PA_ReloadAnim="stand_reload_m1919"
    PA_ReloadEmptyAnim="stand_reload_m1919"

    // PA_FireLastShot=""
    // PA_IronFireLastShot=""

    PA_MoveStandIronFire(0)="stand_shoothip_m1919"
    PA_MoveStandIronFire(1)="stand_shoothip_m1919"
    PA_MoveStandIronFire(2)="stand_shootLRhip_m1919"
    PA_MoveStandIronFire(3)="stand_shootLRhip_m1919"
    PA_MoveStandIronFire(4)="stand_shootFLhip_m1919"
    PA_MoveStandIronFire(5)="stand_shootFRhip_m1919"
    PA_MoveStandIronFire(6)="stand_shootFRhip_m1919"
    PA_MoveStandIronFire(7)="stand_shootFLhip_m1919"

    PA_MovementAnims(0)="stand_jogF_m1919"
    PA_MovementAnims(1)="stand_jogB_m1919"
    PA_MovementAnims(2)="stand_jogL_m1919"
    PA_MovementAnims(3)="stand_jogR_m1919"
    PA_MovementAnims(4)="stand_jogFL_m1919"
    PA_MovementAnims(5)="stand_jogFR_m1919"
    PA_MovementAnims(6)="stand_jogBL_m1919"
    PA_MovementAnims(7)="stand_jogBR_m1919"

    PA_SprintAnims(0)="stand_sprintF_m1919"
    PA_SprintAnims(1)="stand_sprintB_m1919"
    PA_SprintAnims(2)="stand_sprintL_m1919"
    PA_SprintAnims(3)="stand_sprintR_m1919"
    PA_SprintAnims(4)="stand_sprintFL_m1919"
    PA_SprintAnims(5)="stand_sprintFR_m1919"
    PA_SprintAnims(6)="stand_sprintBL_m1919"
    PA_SprintAnims(7)="stand_sprintBR_m1919"

    PA_WalkAnims(0)="stand_walkFhip_m1919"
    PA_WalkAnims(1)="stand_walkBhip_m1919"
    PA_WalkAnims(2)="stand_walkLhip_m1919"
    PA_WalkAnims(3)="stand_walkRhip_m1919"
    PA_WalkAnims(4)="stand_walkFLhip_m1919"
    PA_WalkAnims(5)="stand_walkFRhip_m1919"
    PA_WalkAnims(6)="stand_walkBLhip_m1919"
    PA_WalkAnims(7)="stand_walkBRhip_m1919"

    PA_MoveStandFire(0)="stand_shootFhip_m1919"
    PA_MoveStandFire(1)="stand_shootFhip_m1919"
    PA_MoveStandFire(2)="stand_shootLRhip_m1919"
    PA_MoveStandFire(3)="stand_shootLRhip_m1919"
    PA_MoveStandFire(4)="stand_shootFLhip_m1919"
    PA_MoveStandFire(5)="stand_shootFRhip_m1919"
    PA_MoveStandFire(6)="stand_shootFRhip_m1919"
    PA_MoveStandFire(7)="stand_shootFLhip_m1919"

    PA_MoveWalkFire(0)="stand_shootFwalk_m1919"
    PA_MoveWalkFire(1)="stand_shootFwalk_m1919"
    PA_MoveWalkFire(2)="stand_shootLRwalk_m1919"
    PA_MoveWalkFire(3)="stand_shootLRwalk_m1919"
    PA_MoveWalkFire(4)="stand_shootFLwalk_m1919"
    PA_MoveWalkFire(5)="stand_shootFRwalk_m1919"
    PA_MoveWalkFire(6)="stand_shootFRwalk_m1919"
    PA_MoveWalkFire(7)="stand_shootFLwalk_m1919"

    PA_WalkIronAnims(0)="stand_walkFhip_m1919"
    PA_WalkIronAnims(1)="stand_walkBhip_m1919"
    PA_WalkIronAnims(2)="stand_walkLhip_m1919"
    PA_WalkIronAnims(3)="stand_walkRhip_m1919"
    PA_WalkIronAnims(4)="stand_walkFLhip_m1919"
    PA_WalkIronAnims(5)="stand_walkFRhip_m1919"
    PA_WalkIronAnims(6)="stand_walkBLhip_m1919"
    PA_WalkIronAnims(7)="stand_walkBRhip_m1919"


    // CROUCH

    PA_CrouchTurnIronRightAnim="crouch_turnR_m1919"
    PA_CrouchTurnIronLeftAnim="crouch_turnR_m1919"
    PA_CrouchTurnRightAnim="crouch_turnR_m1919"
    PA_CrouchTurnLeftAnim="crouch_turnL_m1919"

    PA_IdleCrouchAnim="crouch_idle_m1919"
    PA_CrouchIdleRestAnim="crouch_idle_m1919"
    PA_IdleCrouchIronWeaponAnim="crouch_idle_m1919"

    PA_CrouchFire="crouch_shoot_m1919"
    PA_CrouchAltFire="crouch_shoot_m1919"
    PA_CrouchFireLastShot="crouch_shoot_m1919"

    PA_CrouchDeployedFire="crouch_shootiron_m1919"
    PA_IdleDeployedCrouchAnim="crouch_idleiron_m1919"

    PA_CrouchAnims(0)="crouch_walkF_m1919"
    PA_CrouchAnims(1)="crouch_walkB_m1919"
    PA_CrouchAnims(2)="crouch_walkL_m1919"
    PA_CrouchAnims(3)="crouch_walkR_m1919"
    PA_CrouchAnims(4)="crouch_walkFL_m1919"
    PA_CrouchAnims(5)="crouch_walkFR_m1919"
    PA_CrouchAnims(6)="crouch_walkBL_m1919"
    PA_CrouchAnims(7)="crouch_walkBR_m1919"

    PA_MoveCrouchFire(0)="crouch_shootF_m1919"
    PA_MoveCrouchFire(1)="crouch_shootF_m1919"
    PA_MoveCrouchFire(2)="crouch_shootLR_m1919"
    PA_MoveCrouchFire(3)="crouch_shootLR_m1919"
    PA_MoveCrouchFire(4)="crouch_shootF_m1919"
    PA_MoveCrouchFire(5)="crouch_shootF_m1919"
    PA_MoveCrouchFire(6)="crouch_shootF_m1919"
    PA_MoveCrouchFire(7)="crouch_shootF_m1919"

    PA_SprintCrouchAnims(0)="crouch_sprintF_m1919"
    PA_SprintCrouchAnims(1)="crouch_sprintB_m1919"
    PA_SprintCrouchAnims(2)="crouch_sprintL_m1919"
    PA_SprintCrouchAnims(3)="crouch_sprintR_m1919"
    PA_SprintCrouchAnims(4)="crouch_sprintFL_m1919"
    PA_SprintCrouchAnims(5)="crouch_sprintFR_m1919"
    PA_SprintCrouchAnims(6)="crouch_sprintBL_m1919"
    PA_SprintCrouchAnims(7)="crouch_sprintBR_m1919"


    // PRONE

    PA_IdleProneAnim="prone_idle_m1919"
    PA_ProneTurnRightAnim="prone_turnR_m1919"
    PA_ProneTurnLeftAnim="prone_turnL_m1919"
    PA_ProneReloadEmptyAnim="prone_reload_m1919"
    PA_ProneWeaponUnDeployAnim="prone_idle_m1919"
    PA_IdleDeployedProneAnim="prone_idle_m1919"
    PA_ProneFireLastShot="prone_shoot_m1919"

    PA_ProneReloadAnim="prone_reload_m1919"
    PA_ProneIdleRestAnim="prone_idle_m1919"
    PA_ProneWeaponDeployAnim="prone_idle_m1919"
    PA_ProneFire="prone_shoot_m1919"
    PA_ProneDeployedFire="prone_shoot_m1919"
    // PA_ProneAltFire="prone_single_m1919"

    PA_ProneAnims(0)="prone_crawlF_piat"
    PA_ProneAnims(1)="prone_crawlB_piat"
    PA_ProneAnims(2)="prone_crawlL_piat"
    PA_ProneAnims(3)="prone_crawlR_piat"
    PA_ProneAnims(4)="prone_crawlFL_piat"
    PA_ProneAnims(5)="prone_crawlFR_piat"
    PA_ProneAnims(6)="prone_crawlBL_piat"
    PA_ProneAnims(7)="prone_crawlBR_piat"


    // TRANSITIONS

    PA_StandToProneAnim="StandtoProne_m1919"
    PA_CrouchToProneAnim="CrouchtoProne_m1919"
    PA_ProneToStandAnim="PronetoStand_m1919"
    PA_ProneToCrouchAnim="PronetoCrouch_m1919"
    PA_DiveToProneStartAnim="prone_diveF_m1919"
    PA_DiveToProneEndAnim="prone_diveend_m1919"


    // JUMPs

    PA_AirStillAnim="jump_mid_m1919"
    PA_AirAnims(0)="jumpF_mid_m1919"
    PA_AirAnims(1)="jumpB_mid_m1919"
    PA_AirAnims(2)="jumpL_mid_m1919"
    PA_AirAnims(3)="jumpR_mid_m1919"
    PA_TakeoffStillAnim="jump_takeoff_m1919"
    PA_TakeoffAnims(0)="jumpF_takeoff_m1919"
    PA_TakeoffAnims(1)="jumpB_takeoff_m1919"
    PA_TakeoffAnims(2)="jumpL_takeoff_m1919"
    PA_TakeoffAnims(3)="jumpR_takeoff_m1919"
    PA_LandAnims(0)="jumpF_land_m1919"
    PA_LandAnims(1)="jumpB_land_m1919"
    PA_LandAnims(2)="jumpL_land_m1919"
    PA_LandAnims(3)="jumpR_land_m1919"
    PA_DodgeAnims(0)="jumpF_mid_m1919"
    PA_DodgeAnims(1)="jumpB_mid_m1919"
    PA_DodgeAnims(2)="jumpL_mid_m1919"
    PA_DodgeAnims(3)="jumpR_mid_m1919"
}

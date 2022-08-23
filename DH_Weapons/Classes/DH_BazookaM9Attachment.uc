//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2021
//==============================================================================
// [ ] Texture for LOD version
// [ ] Verify that we have a M6A3 rocket for the rocket
// [ ] Calibrate firing ranges
//==============================================================================

class DH_BazookaM9Attachment extends DHRocketWeaponAttachment;

defaultproperties
{
    Mesh=SkeletalMesh'DH_Bazooka_3rd.M9A1Bazooka_3rd'
    MenuImage=Texture'DH_InterfaceArt_tex.weapon_icons.bazooka_m9a1_icon'
    mExhFlashClass=class'DH_Effects.DH3rdPersonBazookaExhaustFX'
    mMuzFlashClass=class'DH_Effects.DHMuzzleFlash3rdBazooka'
    ExhaustBoneName="dummy_rocket"
    MuzzleBoneName="Muzzle"

    WA_Idle="idle_m9a1"
    WA_Fire="idle_m9a1"
    WA_Reload="reload_m9a1"
    WA_ProneReload="reload_m9a1"

    PA_AssistedReloadAnim="crouch_reload_baz_m9"

    PA_MovementAnims(0)="stand_jogF_baz_m9"
    PA_MovementAnims(1)="stand_jogB_baz_m9"
    PA_MovementAnims(2)="stand_jogL_baz_m9"
    PA_MovementAnims(3)="stand_jogR_baz_m9"
    PA_MovementAnims(4)="stand_jogFL_baz_m9"
    PA_MovementAnims(5)="stand_jogFR_baz_m9"
    PA_MovementAnims(6)="stand_jogBL_baz_m9"
    PA_MovementAnims(7)="stand_jogBR_baz_m9"

    PA_CrouchAnims(0)="crouch_walkF_baz_m9"
    PA_CrouchAnims(1)="crouch_walkB_baz_m9"
    PA_CrouchAnims(2)="crouch_walkL_baz_m9"
    PA_CrouchAnims(3)="crouch_walkR_baz_m9"
    PA_CrouchAnims(4)="crouch_walkFL_baz_m9"
    PA_CrouchAnims(5)="crouch_walkFR_baz_m9"
    PA_CrouchAnims(6)="crouch_walkBL_baz_m9"
    PA_CrouchAnims(7)="crouch_walkBR_baz_m9"

    PA_WalkAnims(0)="stand_walkFhip_baz_m9"
    PA_WalkAnims(1)="stand_walkBhip_baz_m9"
    PA_WalkAnims(2)="stand_walkLhip_baz_m9"
    PA_WalkAnims(3)="stand_walkRhip_baz_m9"
    PA_WalkAnims(4)="stand_walkFLhip_baz_m9"
    PA_WalkAnims(5)="stand_walkFRhip_baz_m9"
    PA_WalkAnims(6)="stand_walkBLhip_baz_m9"
    PA_WalkAnims(7)="stand_walkBRhip_baz_m9"

    PA_WalkIronAnims(0)="stand_walkFiron_baz_m9"
    PA_WalkIronAnims(1)="stand_walkBiron_baz_m9"
    PA_WalkIronAnims(2)="stand_walkLiron_baz_m9"
    PA_WalkIronAnims(3)="stand_walkRiron_baz_m9"
    PA_WalkIronAnims(4)="stand_walkFLiron_baz_m9"
    PA_WalkIronAnims(5)="stand_walkFRiron_baz_m9"
    PA_WalkIronAnims(6)="stand_walkBLiron_baz_m9"
    PA_WalkIronAnims(7)="stand_walkBRiron_baz_m9"

    PA_SprintAnims(0)="stand_sprintF_baz_m9"
    PA_SprintAnims(1)="stand_sprintB_baz_m9"
    PA_SprintAnims(2)="stand_sprintL_baz_m9"
    PA_SprintAnims(3)="stand_sprintR_baz_m9"
    PA_SprintAnims(4)="stand_sprintFL_baz_m9"
    PA_SprintAnims(5)="stand_sprintFR_baz_m9"
    PA_SprintAnims(6)="stand_sprintBL_baz_m9"
    PA_SprintAnims(7)="stand_sprintBR_baz_m9"

    PA_SprintCrouchAnims(0)="crouch_sprintF_baz_m9"
    PA_SprintCrouchAnims(1)="crouch_sprintB_baz_m9"
    PA_SprintCrouchAnims(2)="crouch_sprintL_baz_m9"
    PA_SprintCrouchAnims(3)="crouch_sprintR_baz_m9"
    PA_SprintCrouchAnims(4)="crouch_sprintFL_baz_m9"
    PA_SprintCrouchAnims(5)="crouch_sprintFR_baz_m9"
    PA_SprintCrouchAnims(6)="crouch_sprintBL_baz_m9"
    PA_SprintCrouchAnims(7)="crouch_sprintBR_baz_m9"

    PA_TurnRightAnim="stand_turnRrest_baz_m9"
    PA_TurnLeftAnim="stand_turnLrest_baz_m9"
    PA_TurnIronRightAnim="stand_turnRrest_baz_m9" // ?
    PA_TurnIronLeftAnim="stand_turnLrest_baz_m9" // ?

    PA_CrouchTurnIronRightAnim="crouch_turnRiron_baz_m9"
    PA_CrouchTurnIronLeftAnim="crouch_turnRiron_baz_m9"

    PA_StandToProneAnim="StandtoProne_baz_m9"
    PA_CrouchToProneAnim="CrouchtoProne_baz_m9"
    PA_ProneToStandAnim="PronetoStand_baz_m9"
    PA_ProneToCrouchAnim="PronetoCrouch_baz_m9"

    PA_DiveToProneStartAnim="prone_diveF_baz_m9"
    PA_DiveToProneEndAnim="prone_diveend_baz_m9"

    PA_CrouchIdleRestAnim="crouch_idle_baz_m9"
    PA_IdleCrouchAnim="crouch_idleiron_baz_m9"
    PA_IdleRestAnim="stand_idlerest_baz_m9"
    PA_IdleWeaponAnim="stand_idlerest_baz_m9"
    PA_IdleIronRestAnim="stand_idleiron_baz_m9"
    PA_IdleIronWeaponAnim="stand_idleiron_baz_m9"
    PA_IdleCrouchIronWeaponAnim="crouch_idleiron_baz_m9"
    PA_ReloadAnim="crouch_reload_baz_m9"
    PA_ReloadEmptyAnim="crouch_reload_baz_m9"
    PA_ProneReloadEmptyAnim="prone_reload_baz_m9"
    PA_ProneIdleRestAnim="prone_idle_baz_m9"
    PA_Fire="stand_shootiron_baz_m9"
    PA_IronFire="stand_shootiron_baz_m9"
    PA_CrouchFire="crouch_shootiron_baz_m9"
    PA_CrouchIronFire="crouch_shootiron_baz_m9"
    PA_ProneFire="prone_shoot_baz_m9"

    PA_MoveStandFire(0)="stand_shootiron_baz_m9"
    PA_MoveStandFire(1)="stand_shootiron_baz_m9"
    PA_MoveStandFire(2)="stand_shootLRiron_baz_m9"
    PA_MoveStandFire(3)="stand_shootLRiron_baz_m9"
    PA_MoveStandFire(4)="stand_shootFLiron_baz_m9"
    PA_MoveStandFire(5)="stand_shootFRiron_baz_m9"
    PA_MoveStandFire(6)="stand_shootFRiron_baz_m9"
    PA_MoveStandFire(7)="stand_shootFLiron_baz_m9"

    PA_MoveCrouchFire(0)="crouch_shootF_baz_m9"
    PA_MoveCrouchFire(1)="crouch_shootF_baz_m9"
    PA_MoveCrouchFire(2)="crouch_shootLR_baz_m9"
    PA_MoveCrouchFire(3)="crouch_shootLR_baz_m9"
    PA_MoveCrouchFire(4)="crouch_shootF_baz_m9"
    PA_MoveCrouchFire(5)="crouch_shootF_baz_m9"
    PA_MoveCrouchFire(6)="crouch_shootF_baz_m9"
    PA_MoveCrouchFire(7)="crouch_shootF_baz_m9"

    PA_MoveWalkFire(0)="stand_shootFwalk_baz_m9"
    PA_MoveWalkFire(1)="stand_shootFwalk_baz_m9"
    PA_MoveWalkFire(2)="stand_shootLRwalk_baz_m9"
    PA_MoveWalkFire(3)="stand_shootLRwalk_baz_m9"
    PA_MoveWalkFire(4)="stand_shootFLwalk_baz_m9"
    PA_MoveWalkFire(5)="stand_shootFRwalk_baz_m9"
    PA_MoveWalkFire(6)="stand_shootFRwalk_baz_m9"
    PA_MoveWalkFire(7)="stand_shootFLwalk_baz_m9"

    PA_MoveStandIronFire(0)="stand_shootiron_baz_m9"
    PA_MoveStandIronFire(1)="stand_shootiron_faust"
    PA_MoveStandIronFire(2)="stand_shootLRiron_baz_m9"
    PA_MoveStandIronFire(3)="stand_shootLRiron_baz_m9"
    PA_MoveStandIronFire(4)="stand_shootFLiron_baz_m9"
    PA_MoveStandIronFire(5)="stand_shootFRiron_baz_m9"
    PA_MoveStandIronFire(6)="stand_shootFRiron_baz_m9"
    PA_MoveStandIronFire(7)="stand_shootFLiron_baz_m9"

    PA_AltFire="stand_idlestrike_kar" // unused
    PA_CrouchAltFire="stand_idlestrike_kar" // unused
    PA_ProneAltFire="prone_idlestrike_bayo"
    PA_FireLastShot="stand_shoothip_kar" // unused
    PA_IronFireLastShot="crouch_shoot_baz_m9"
    PA_CrouchFireLastShot="crouch_shoot_baz_m9"
    PA_ProneFireLastShot="prone_shoot_baz_m9"
}

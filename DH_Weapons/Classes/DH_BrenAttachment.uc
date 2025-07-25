//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_BrenAttachment extends DHWeaponAttachment;

defaultproperties
{
    Mesh=SkeletalMesh'DH_Weapons3rd_CC_anm.bren_3rd'
    MenuImage=Texture'DH_Bren_tex.bren_icon'
    
    mMuzFlashClass=Class'MuzzleFlash3rdSTG'
    ROShellCaseClass=Class'RO3rdShellEject762x54mm'
    MuzzleBoneName="tip"
    ShellEjectionBoneName="weapon_eject"

    PA_MovementAnims(0)="stand_jogF_zb30"
    PA_MovementAnims(1)="stand_jogB_zb30"
    PA_MovementAnims(2)="stand_jogL_zb30"
    PA_MovementAnims(3)="stand_jogR_zb30"
    PA_MovementAnims(4)="stand_jogFL_zb30"
    PA_MovementAnims(5)="stand_jogFR_zb30"
    PA_MovementAnims(6)="stand_jogBL_zb30"
    PA_MovementAnims(7)="stand_jogBR_zb30"
    PA_CrouchAnims(0)="crouch_walkF_zb30"
    PA_CrouchAnims(1)="crouch_walkB_zb30"
    PA_CrouchAnims(2)="crouch_walkL_zb30"
    PA_CrouchAnims(3)="crouch_walkR_zb30"
    PA_CrouchAnims(4)="crouch_walkFL_zb30"
    PA_CrouchAnims(5)="crouch_walkFR_zb30"
    PA_CrouchAnims(6)="crouch_walkBL_zb30"
    PA_CrouchAnims(7)="crouch_walkBR_zb30"
    PA_ProneIronAnims(0)="prone_crawlF_kar"
    PA_ProneIronAnims(1)="prone_crawlB_kar"
    PA_ProneIronAnims(2)="prone_crawlL_kar"
    PA_ProneIronAnims(3)="prone_crawlR_kar"
    PA_ProneIronAnims(4)="prone_crawlFL_kar"
    PA_ProneIronAnims(5)="prone_crawlFR_kar"
    PA_ProneIronAnims(6)="prone_crawlBL_kar"
    PA_ProneIronAnims(7)="prone_crawlBR_kar"
    PA_WalkAnims(0)="stand_walkF_zb30"
    PA_WalkAnims(1)="stand_walkB_zb30"
    PA_WalkAnims(2)="stand_walkL_zb30"
    PA_WalkAnims(3)="stand_walkR_zb30"
    PA_WalkAnims(4)="stand_walkFL_zb30"
    PA_WalkAnims(5)="stand_walkFR_zb30"
    PA_WalkAnims(6)="stand_walkBL_zb30"
    PA_WalkAnims(7)="stand_walkBR_zb30"
    PA_WalkIronAnims(0)="stand_walkFiron_stg44"
    PA_WalkIronAnims(1)="stand_walkBiron_stg44"
    PA_WalkIronAnims(2)="stand_walkLiron_stg44"
    PA_WalkIronAnims(3)="stand_walkRiron_stg44"
    PA_WalkIronAnims(4)="stand_walkFLiron_stg44"
    PA_WalkIronAnims(5)="stand_walkFRiron_stg44"
    PA_WalkIronAnims(6)="stand_walkBLiron_stg44"
    PA_WalkIronAnims(7)="stand_walkBRiron_stg44"
    PA_SprintAnims(0)="stand_sprintF_zb30"
    PA_SprintAnims(1)="stand_sprintB_zb30"
    PA_SprintAnims(2)="stand_sprintL_zb30"
    PA_SprintAnims(3)="stand_sprintR_zb30"
    PA_SprintAnims(4)="stand_sprintFL_zb30"
    PA_SprintAnims(5)="stand_sprintFR_zb30"
    PA_SprintAnims(6)="stand_sprintBL_zb30"
    PA_SprintAnims(7)="stand_sprintBR_zb30"
    PA_SprintCrouchAnims(0)="crouch_sprintF_zb30"
    PA_SprintCrouchAnims(1)="crouch_sprintB_zb30"
    PA_SprintCrouchAnims(2)="crouch_sprintL_zb30"
    PA_SprintCrouchAnims(3)="crouch_sprintR_zb30"
    PA_SprintCrouchAnims(4)="crouch_sprintFL_zb30"
    PA_SprintCrouchAnims(5)="crouch_sprintFR_zb30"
    PA_SprintCrouchAnims(6)="crouch_sprintBL_zb30"
    PA_SprintCrouchAnims(7)="crouch_sprintBR_zb30"
    PA_LimpAnims(0)="stand_limpFhip_zb30"
    PA_LimpAnims(1)="stand_limpBhip_zb30"
    PA_LimpAnims(2)="stand_limpLhip_zb30"
    PA_LimpAnims(3)="stand_limpRhip_zb30"
    PA_LimpAnims(4)="stand_limpFLhip_zb30"
    PA_LimpAnims(5)="stand_limpFRhip_zb30"
    PA_LimpAnims(6)="stand_limpBLhip_zb30"
    PA_LimpAnims(7)="stand_limpBRhip_zb30"
    PA_LimpIronAnims(0)="stand_limpFiron_zb30"
    PA_LimpIronAnims(1)="stand_limpBiron_zb30"
    PA_LimpIronAnims(2)="stand_limpLiron_zb30"
    PA_LimpIronAnims(3)="stand_limpRiron_zb30"
    PA_LimpIronAnims(4)="stand_limpFLiron_zb30"
    PA_LimpIronAnims(5)="stand_limpFRiron_zb30"
    PA_LimpIronAnims(6)="stand_limpBLiron_zb30"
    PA_LimpIronAnims(7)="stand_limpBRiron_zb30"
    PA_TurnRightAnim="stand_turnR_zb30"
    PA_TurnLeftAnim="stand_turnL_zb30"
    PA_TurnIronRightAnim="stand_ironturnR_zb30"
    PA_TurnIronLeftAnim="stand_ironturnL_zb30"
    PA_CrouchTurnIronRightAnim="crouch_turnR_zb30"
    PA_CrouchTurnIronLeftAnim="crouch_turnL_zb30"
    PA_ProneTurnRightAnim="prone_turnR_zb30"
    PA_ProneTurnLeftAnim="prone_turnL_zb30"
    PA_StandToProneAnim="StandtoProne_kar"
    PA_CrouchToProneAnim="CrouchtoProne_zb30"
    PA_ProneToStandAnim="PronetoStand_kar"
    PA_ProneToCrouchAnim="PronetoCrouch_zb30"
    PA_CrouchTurnRightAnim="crouch_turnR_zb30"
    PA_CrouchTurnLeftAnim="crouch_turnL_zb30"
    PA_CrouchIdleRestAnim="crouch_idle_zb30"
    PA_IdleCrouchAnim="crouch_idleiron_zb30"
    PA_IdleRestAnim="stand_idlehip_zb30"
    PA_IdleWeaponAnim="stand_idlehip_zb30"
    PA_IdleIronRestAnim="stand_idleiron_zb30"
    PA_IdleIronWeaponAnim="stand_idleiron_zb30"
    PA_IdleCrouchIronWeaponAnim="crouch_idle_zb30"
    PA_IdleProneAnim="prone_idleiron_zb30"
    PA_IdleDeployedAnim="stand_idleiron_zb30"
    PA_IdleDeployedProneAnim="prone_idle_zb30"
    PA_IdleDeployedCrouchAnim="crouch_idle_zb30"
    PA_ReloadAnim="stand_reloadB_zb30" // TO DO: it should be `stand_reload_zb30` for deployed state
    PA_ProneReloadAnim="prone_reload_zb30"
    PA_ReloadEmptyAnim="stand_reloadB_zb30" // it should be `stand_reload_zb30` for deployed state
    PA_ProneReloadEmptyAnim="prone_reload_zb30"
    PA_ProneIdleRestAnim="prone_idle_zb30"
    PA_StandWeaponDeployAnim="stand_idleiron_zb30"
    PA_ProneWeaponDeployAnim="prone_idle_zb30"
    PA_StandWeaponUnDeployAnim="stand_idleiron_zb30"
    PA_ProneWeaponUnDeployAnim="prone_idle_zb30"
    PA_Fire="stand_shoothip_zb30"
    PA_IronFire="stand_shootiron_zb30"
    PA_CrouchFire="crouch_shoot_zb30"
    PA_CrouchIronFire="crouch_shootiron_zb30"
    PA_ProneFire="prone_shoot_zb30"
    PA_DeployedFire="stand_shootiron_zb30"
    PA_CrouchDeployedFire="crouch_shoot_zb30"
    PA_ProneDeployedFire="prone_shoot_zb30"
    PA_MoveStandFire(0)="stand_shootFwalk_zb30"
    PA_MoveStandFire(1)="stand_shootFwalk_zb30"
    PA_MoveStandFire(2)="stand_shootLRwalk_zb30"
    PA_MoveStandFire(3)="stand_shootLRwalk_zb30"
    PA_MoveStandFire(4)="stand_shootFLwalk_zb30"
    PA_MoveStandFire(5)="stand_shootFRwalk_zb30"
    PA_MoveStandFire(6)="stand_shootFRwalk_zb30"
    PA_MoveStandFire(7)="stand_shootFLwalk_zb30"
    PA_MoveCrouchFire(0)="crouch_shootF_zb30"
    PA_MoveCrouchFire(1)="crouch_shootF_zb30"
    PA_MoveCrouchFire(2)="crouch_shootLR_zb30"
    PA_MoveCrouchFire(3)="crouch_shootLR_zb30"
    PA_MoveCrouchFire(4)="crouch_shootF_zb30"
    PA_MoveCrouchFire(5)="crouch_shootF_zb30"
    PA_MoveCrouchFire(6)="crouch_shootF_zb30"
    PA_MoveCrouchFire(7)="crouch_shootF_zb30"
    PA_MoveWalkFire(0)="stand_shootFwalk_zb30"
    PA_MoveWalkFire(1)="stand_shootFwalk_zb30"
    PA_MoveWalkFire(2)="stand_shootLRwalk_zb30"
    PA_MoveWalkFire(3)="stand_shootLRwalk_zb30"
    PA_MoveWalkFire(4)="stand_shootFLwalk_zb30"
    PA_MoveWalkFire(5)="stand_shootFRwalk_zb30"
    PA_MoveWalkFire(6)="stand_shootFRwalk_zb30"
    PA_MoveWalkFire(7)="stand_shootFLwalk_zb30"
    PA_MoveStandIronFire(2)="stand_shootLRiron_zb30"
    PA_MoveStandIronFire(3)="stand_shootLRiron_zb30"
    PA_FireLastShot="stand_shoothip_zb30"
    PA_IronFireLastShot="stand_shootiron_zb30"
    PA_CrouchFireLastShot="crouch_shoot_zb30"
    PA_ProneFireLastShot="prone_shoot_zb30"
    
    PA_DiveToProneStartAnim="prone_diveF_kar"
    PA_DiveToProneEndAnim="prone_diveend_kar"
    
    WA_Idle="idle_zb30"
    WA_IdleEmpty="idle_zb30"
    WA_Fire="idle_zb30"
    WA_Reload="reload_zb30"
    WA_ReloadEmpty="reload_zb30"
    WA_ProneReload="prone_reload_zb30"
    WA_ProneReloadEmpty="prone_reload_zb30"
}

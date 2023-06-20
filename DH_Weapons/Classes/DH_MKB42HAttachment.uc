//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DH_MKB42HAttachment extends DHWeaponAttachment;

defaultproperties
{
    Mesh=SkeletalMesh'DH_Weapons3rd_2_anm.mkb42h_3rd'
    MenuImage=Texture'InterfaceArt_tex.Menu_weapons.stg44'
    mMuzFlashClass=class'ROEffects.MuzzleFlash3rdSTG'
    ROShellCaseClass=class'DH_weapons.DH_3rdShellEject556mm'

    WA_Idle="idle_mkb"
    WA_IdleEmpty="idle_mkb"
    WA_Fire="shoot_mkb"
    WA_Reload="reload_mkb"
    WA_ReloadEmpty="reload_mkb"
    WA_ProneReload="prone_reload_mkb"
    WA_ProneReloadEmpty="prone_reload_mkb"
    WA_BayonetIdle="idle_mkb_bayo"
    WA_BayonetIdleEmpty="idle_mkb_bayo"
    WA_BayonetFire="shoot_mkb_bayo"
    WA_BayonetReload="reload_mkb_bayo"
    WA_BayonetReloadEmpty="reload_mkb_bayo"
    WA_BayonetProneReload="prone_reload_mkb_bayo"
    WA_BayonetProneReloadEmpty="prone_reload_mkb_bayo"
    WA_BayonetAttach="bayo_on_mkb"
    WA_BayonetDetach="bayo_off_mkb"
    WA_BayonetAttachProne="bayo_on_mkb"
    WA_BayonetDetachProne="bayo_off_mkb"

    PA_MovementAnims(0)="stand_jogF_stg44"
    PA_MovementAnims(1)="stand_jogB_stg44"
    PA_MovementAnims(2)="stand_jogL_stg44"
    PA_MovementAnims(3)="stand_jogR_stg44"
    PA_MovementAnims(4)="stand_jogFL_stg44"
    PA_MovementAnims(5)="stand_jogFR_stg44"
    PA_MovementAnims(6)="stand_jogBL_stg44"
    PA_MovementAnims(7)="stand_jogBR_stg44"
    PA_CrouchAnims(0)="crouch_walkF_stg44"
    PA_CrouchAnims(1)="crouch_walkB_stg44"
    PA_CrouchAnims(2)="crouch_walkL_stg44"
    PA_CrouchAnims(3)="crouch_walkR_stg44"
    PA_CrouchAnims(4)="crouch_walkFL_stg44"
    PA_CrouchAnims(5)="crouch_walkFR_stg44"
    PA_CrouchAnims(6)="crouch_walkBL_stg44"
    PA_CrouchAnims(7)="crouch_walkBR_stg44"
    PA_ProneIronAnims(0)="Prone_slowcrawlF_stg44"
    PA_ProneIronAnims(1)="Prone_slowcrawlB_stg44"
    PA_ProneIronAnims(2)="Prone_slowcrawlL_stg44"
    PA_ProneIronAnims(3)="Prone_slowcrawlR_stg44"
    PA_ProneIronAnims(4)="Prone_slowcrawlL_stg44"
    PA_ProneIronAnims(5)="Prone_slowcrawlR_stg44"
    PA_ProneIronAnims(6)="Prone_slowcrawlB_stg44"
    PA_ProneIronAnims(7)="Prone_slowcrawlB_stg44"
    PA_WalkAnims(0)="stand_walkFhip_stg44"
    PA_WalkAnims(1)="stand_walkBhip_stg44"
    PA_WalkAnims(2)="stand_walkLhip_stg44"
    PA_WalkAnims(3)="stand_walkRhip_stg44"
    PA_WalkAnims(4)="stand_walkFLhip_stg44"
    PA_WalkAnims(5)="stand_walkFRhip_stg44"
    PA_WalkAnims(6)="stand_walkBLhip_stg44"
    PA_WalkAnims(7)="stand_walkBRhip_stg44"
    PA_WalkIronAnims(0)="stand_walkFiron_stg44"
    PA_WalkIronAnims(1)="stand_walkBiron_stg44"
    PA_WalkIronAnims(2)="stand_walkLiron_stg44"
    PA_WalkIronAnims(3)="stand_walkRiron_stg44"
    PA_WalkIronAnims(4)="stand_walkFLiron_stg44"
    PA_WalkIronAnims(5)="stand_walkFRiron_stg44"
    PA_WalkIronAnims(6)="stand_walkBLiron_stg44"
    PA_WalkIronAnims(7)="stand_walkBRiron_stg44"
    PA_SprintAnims(0)="stand_sprintF_stg44"
    PA_SprintAnims(1)="stand_sprintB_stg44"
    PA_SprintAnims(2)="stand_sprintL_stg44"
    PA_SprintAnims(3)="stand_sprintR_stg44"
    PA_SprintAnims(4)="stand_sprintFL_stg44"
    PA_SprintAnims(5)="stand_sprintFR_stg44"
    PA_SprintAnims(6)="stand_sprintBL_stg44"
    PA_SprintAnims(7)="stand_sprintBR_stg44"
    PA_SprintCrouchAnims(0)="crouch_sprintF_stg44"
    PA_SprintCrouchAnims(1)="crouch_sprintB_stg44"
    PA_SprintCrouchAnims(2)="crouch_sprintL_stg44"
    PA_SprintCrouchAnims(3)="crouch_sprintR_stg44"
    PA_SprintCrouchAnims(4)="crouch_sprintFL_stg44"
    PA_SprintCrouchAnims(5)="crouch_sprintFR_stg44"
    PA_SprintCrouchAnims(6)="crouch_sprintBL_stg44"
    PA_SprintCrouchAnims(7)="crouch_sprintBR_stg44"
    PA_TurnRightAnim="stand_turnRhip_stg44"
    PA_TurnLeftAnim="stand_turnLhip_stg44"
    PA_TurnIronRightAnim="stand_turnRiron_stg44"
    PA_TurnIronLeftAnim="stand_turnLiron_stg44"
    PA_CrouchTurnIronRightAnim="crouch_turnRiron_stg44"
    PA_CrouchTurnIronLeftAnim="crouch_turnRiron_stg44"
    PA_ProneTurnRightAnim="Prone_turnR_stg44"
    PA_ProneTurnLeftAnim="Prone_turnL_stg44"
    PA_StandToProneAnim="StandtoProne_stg44"
    PA_CrouchToProneAnim="CrouchtoProne_stg44"
    PA_ProneToStandAnim="PronetoStand_stg44"
    PA_ProneToCrouchAnim="PronetoCrouch_stg44"
    PA_DiveToProneStartAnim="prone_diveF_kar"
    PA_DiveToProneEndAnim="prone_diveend_kar"
    PA_CrouchTurnRightAnim="crouch_turnR_stg44"
    PA_CrouchTurnLeftAnim="crouch_turnL_stg44"
    PA_CrouchIdleRestAnim="crouch_idle_stg44"
    PA_IdleCrouchAnim="crouch_idle_stg44"
    PA_IdleRestAnim="stand_idlehip_stg44"
    PA_IdleWeaponAnim="stand_idlehip_stg44"
    PA_IdleIronRestAnim="stand_idleiron_stg44"
    PA_IdleIronWeaponAnim="stand_idleiron_stg44"
    PA_IdleCrouchIronWeaponAnim="crouch_idleiron_stg44"
    PA_IdleProneAnim="Prone_idle_stg44"
    PA_ReloadAnim="stand_reloadhalf_stg44"
    PA_ProneReloadAnim="prone_reloadhalf_stg44"
    PA_ReloadEmptyAnim="stand_reloadempty_stg44"
    PA_ProneReloadEmptyAnim="prone_reloadempty_stg44"
    PA_ProneIdleRestAnim="Prone_idle_stg44"
    PA_Fire="stand_shoothip_stg44"
    PA_IronFire="stand_shootiron_stg44"
    PA_CrouchFire="crouch_shoot_stg44"
    PA_ProneFire="prone_shoot_stg44"
    PA_MoveStandFire(0)="stand_shootFhip_stg44"
    PA_MoveStandFire(1)="stand_shootFhip_stg44"
    PA_MoveStandFire(2)="stand_shootLRhip_stg44"
    PA_MoveStandFire(3)="stand_shootLRhip_stg44"
    PA_MoveStandFire(4)="stand_shootFLhip_stg44"
    PA_MoveStandFire(5)="stand_shootFRhip_stg44"
    PA_MoveStandFire(6)="stand_shootFRhip_stg44"
    PA_MoveStandFire(7)="stand_shootFLhip_stg44"
    PA_MoveCrouchFire(0)="crouch_shootF_stg44"
    PA_MoveCrouchFire(1)="crouch_shootF_stg44"
    PA_MoveCrouchFire(2)="crouch_shootLR_stg44"
    PA_MoveCrouchFire(3)="crouch_shootLR_stg44"
    PA_MoveCrouchFire(4)="crouch_shootF_stg44"
    PA_MoveCrouchFire(5)="crouch_shootF_stg44"
    PA_MoveCrouchFire(6)="crouch_shootF_stg44"
    PA_MoveCrouchFire(7)="crouch_shootF_stg44"
    PA_MoveWalkFire(0)="stand_shootFwalk_stg44"
    PA_MoveWalkFire(1)="stand_shootFwalk_stg44"
    PA_MoveWalkFire(2)="stand_shootLRwalk_stg44"
    PA_MoveWalkFire(3)="stand_shootLRwalk_stg44"
    PA_MoveWalkFire(4)="stand_shootFLwalk_stg44"
    PA_MoveWalkFire(5)="stand_shootFRwalk_stg44"
    PA_MoveWalkFire(6)="stand_shootFRwalk_stg44"
    PA_MoveWalkFire(7)="stand_shootFLwalk_stg44"
    PA_MoveStandIronFire(0)="stand_shootiron_stg44"
    PA_MoveStandIronFire(1)="stand_shootiron_stg44"
    PA_MoveStandIronFire(2)="stand_shootLRiron_stg44"
    PA_MoveStandIronFire(3)="stand_shootLRiron_stg44"
    PA_MoveStandIronFire(4)="stand_shootFLiron_stg44"
    PA_MoveStandIronFire(5)="stand_shootFRiron_stg44"
    PA_MoveStandIronFire(6)="stand_shootFRiron_stg44"
    PA_MoveStandIronFire(7)="stand_shootFLiron_stg44"
    PA_AltFire="stand_idlestrike_kar"
    PA_CrouchAltFire="stand_idlestrike_kar"
    PA_ProneAltFire="prone_idlestrike_bayo"
    PA_FireLastShot="stand_shoothip_stg44"
    PA_IronFireLastShot="stand_shootiron_stg44"
    PA_CrouchFireLastShot="crouch_shoot_stg44"
    PA_ProneFireLastShot="prone_shoot_stg44"
    
    PA_BayonetAltFire="stand_stab_kar"
    PA_CrouchBayonetAltFire="crouch_idlestrike_bayo"
    PA_ProneBayonetAltFire="prone_idlestrike_bayo"
    PA_BayonetAttachAnim="stand_bayattach_kar"
    PA_ProneBayonetAttachAnim="prone_bayattach_kar"
    PA_BayonetDetachAnim="stand_bayremove_kar"
    PA_ProneBayonetDetachAnim="prone_bayremove_kar"
}
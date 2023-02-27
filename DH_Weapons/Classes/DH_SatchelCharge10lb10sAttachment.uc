//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_SatchelCharge10lb10sAttachment extends DHThrowableExplosiveAttachment;

defaultproperties
{
    Mesh=SkeletalMesh'Weapons3rd_anm.satchel'
    Skins(0)=Texture'Weapons3rd_tex.German.satchel_world'
    MenuImage=Texture'InterfaceArt_tex.Menu_weapons.satchel'

    WA_Idle="idle_satchel"
    WA_Fire="idle_satchel"

    PA_MovementAnims(0)="stand_jogF_satchel"
    PA_MovementAnims(1)="stand_jogB_satchel"
    PA_MovementAnims(2)="stand_jogL_satchel"
    PA_MovementAnims(3)="stand_jogR_satchel"
    PA_MovementAnims(4)="stand_jogFL_satchel"
    PA_MovementAnims(5)="stand_jogFR_satchel"
    PA_MovementAnims(6)="stand_jogBL_satchel"
    PA_MovementAnims(7)="stand_jogBR_satchel"
    PA_CrouchAnims(0)="crouch_walkF_satchel"
    PA_CrouchAnims(1)="crouch_walkB_satchel"
    PA_CrouchAnims(2)="crouch_walkL_satchel"
    PA_CrouchAnims(3)="crouch_walkR_satchel"
    PA_CrouchAnims(4)="crouch_walkFL_satchel"
    PA_CrouchAnims(5)="crouch_walkFR_satchel"
    PA_CrouchAnims(6)="crouch_walkBL_satchel"
    PA_CrouchAnims(7)="crouch_walkBR_satchel"
    PA_ProneAnims(0)="prone_crawlF_satchel"
    PA_ProneAnims(1)="prone_crawlB_satchel"
    PA_ProneAnims(2)="prone_crawlL_satchel"
    PA_ProneAnims(3)="prone_crawlR_satchel"
    PA_ProneAnims(4)="prone_crawlFL_satchel"
    PA_ProneAnims(5)="prone_crawlFR_satchel"
    PA_ProneAnims(6)="prone_crawlBL_satchel"
    PA_ProneAnims(7)="prone_crawlBR_satchel"
    PA_ProneIronAnims(0)="prone_slowcrawlF_satchel"
    PA_ProneIronAnims(1)="prone_slowcrawlB_satchel"
    PA_ProneIronAnims(2)="prone_slowcrawlL_satchel"
    PA_ProneIronAnims(3)="prone_slowcrawlR_satchel"
    PA_ProneIronAnims(4)="prone_slowcrawlL_satchel"
    PA_ProneIronAnims(5)="prone_slowcrawlR_satchel"
    PA_ProneIronAnims(6)="prone_slowcrawlB_satchel"
    PA_ProneIronAnims(7)="prone_slowcrawlB_satchel"
    PA_WalkAnims(0)="stand_walkFhip_satchel"
    PA_WalkAnims(1)="stand_walkBhip_satchel"
    PA_WalkAnims(2)="stand_walkLhip_satchel"
    PA_WalkAnims(3)="stand_walkRhip_satchel"
    PA_WalkAnims(4)="stand_walkFLhip_satchel"
    PA_WalkAnims(5)="stand_walkFRhip_satchel"
    PA_WalkAnims(6)="stand_walkBLhip_satchel"
    PA_WalkAnims(7)="stand_walkBRhip_satchel"
    PA_WalkIronAnims(0)="stand_walkFhip_satchel"
    PA_WalkIronAnims(1)="stand_walkBhip_satchel"
    PA_WalkIronAnims(2)="stand_walkLhip_satchel"
    PA_WalkIronAnims(3)="stand_walkRhip_satchel"
    PA_WalkIronAnims(4)="stand_walkFLhip_satchel"
    PA_WalkIronAnims(5)="stand_walkFRhip_satchel"
    PA_WalkIronAnims(6)="stand_walkBLhip_satchel"
    PA_WalkIronAnims(7)="stand_walkBRhip_satchel"
    PA_SprintAnims(0)="stand_sprintF_satchel"
    PA_SprintAnims(1)="stand_sprintB_satchel"
    PA_SprintAnims(2)="stand_sprintL_satchel"
    PA_SprintAnims(3)="stand_sprintR_satchel"
    PA_SprintAnims(4)="stand_sprintFL_satchel"
    PA_SprintAnims(5)="stand_sprintFR_satchel"
    PA_SprintAnims(6)="stand_sprintBL_satchel"
    PA_SprintAnims(7)="stand_sprintBR_satchel"
    PA_SprintCrouchAnims(0)="crouch_sprintF_satchel"
    PA_SprintCrouchAnims(1)="crouch_sprintB_satchel"
    PA_SprintCrouchAnims(2)="crouch_sprintL_satchel"
    PA_SprintCrouchAnims(3)="crouch_sprintR_satchel"
    PA_SprintCrouchAnims(4)="crouch_sprintFL_satchel"
    PA_SprintCrouchAnims(5)="crouch_sprintFR_satchel"
    PA_SprintCrouchAnims(6)="crouch_sprintBL_satchel"
    PA_SprintCrouchAnims(7)="crouch_sprintBR_satchel"
    PA_MoveHoldExplosive(0)="stand_jogFhold_nade"
    PA_MoveHoldExplosive(1)="stand_jogBhold_nade"
    PA_MoveHoldExplosive(2)="stand_jogLhold_nade"
    PA_MoveHoldExplosive(3)="stand_jogRhold_nade"
    PA_MoveHoldExplosive(4)="stand_jogFLhold_nade"
    PA_MoveHoldExplosive(5)="stand_jogFRhold_nade"
    PA_MoveHoldExplosive(6)="stand_jogBLhold_nade"
    PA_MoveHoldExplosive(7)="stand_jogBRhold_nade"
    PA_WalkHoldExplosive(0)="stand_walkFhold_nade"
    PA_WalkHoldExplosive(1)="stand_walkBhold_nade"
    PA_WalkHoldExplosive(2)="stand_walkLhold_nade"
    PA_WalkHoldExplosive(3)="stand_walkRhold_nade"
    PA_WalkHoldExplosive(4)="stand_walkFLhold_nade"
    PA_WalkHoldExplosive(5)="stand_walkFRhold_nade"
    PA_WalkHoldExplosive(6)="stand_walkBLhold_nade"
    PA_WalkHoldExplosive(7)="stand_walkBRhold_nade"
    PA_CrouchHoldExplosive(0)="crouch_walkFhold_nade"
    PA_CrouchHoldExplosive(1)="crouch_walkBhold_nade"
    PA_CrouchHoldExplosive(2)="crouch_walkLhold_nade"
    PA_CrouchHoldExplosive(3)="crouch_walkRhold_nade"
    PA_CrouchHoldExplosive(4)="crouch_walkFLhold_nade"
    PA_CrouchHoldExplosive(5)="crouch_walkFRhold_nade"
    PA_CrouchHoldExplosive(6)="crouch_walkBLhold_nade"
    PA_CrouchHoldExplosive(7)="crouch_walkBRhold_nade"
    PA_SprintHoldExplosive(0)="stand_sprintFhold_nade"
    PA_SprintHoldExplosive(1)="stand_sprintBhold_nade"
    PA_SprintHoldExplosive(2)="stand_sprintLhold_nade"
    PA_SprintHoldExplosive(3)="stand_sprintRhold_nade"
    PA_SprintHoldExplosive(4)="stand_sprintFLhold_nade"
    PA_SprintHoldExplosive(5)="stand_sprintFRhold_nade"
    PA_SprintHoldExplosive(6)="stand_sprintBLhold_nade"
    PA_SprintHoldExplosive(7)="stand_sprintBRhold_nade"
    PA_SprintCrouchHoldExplosive(0)="crouch_sprintFhold_nade"
    PA_SprintCrouchHoldExplosive(1)="crouch_sprintBhold_nade"
    PA_SprintCrouchHoldExplosive(2)="crouch_sprintLhold_nade"
    PA_SprintCrouchHoldExplosive(3)="crouch_sprintRhold_nade"
    PA_SprintCrouchHoldExplosive(4)="crouch_sprintFLhold_nade"
    PA_SprintCrouchHoldExplosive(5)="crouch_sprintFRhold_nade"
    PA_SprintCrouchHoldExplosive(6)="crouch_sprintBLhold_nade"
    PA_SprintCrouchHoldExplosive(7)="crouch_sprintBRhold_nade"
    PA_ProneHoldExplosive(0)="prone_slowcrawlF_nade"
    PA_ProneHoldExplosive(1)="prone_slowcrawlB_nade"
    PA_ProneHoldExplosive(2)="prone_slowcrawlL_nade"
    PA_ProneHoldExplosive(3)="prone_slowcrawlR_nade"
    PA_ProneHoldExplosive(4)="prone_slowcrawlF_nade"
    PA_ProneHoldExplosive(5)="prone_slowcrawlF_nade"
    PA_ProneHoldExplosive(6)="prone_slowcrawlB_nade"
    PA_ProneHoldExplosive(7)="prone_slowcrawlB_nade"
    PA_IdleExplosiveHold="stand_hold_satchel"
    PA_IdleCrouchExplosiveHold="crouch_hold_satchel"
    PA_IdleProneExplosiveHold="prone_hold_satchel"
    PA_TurnRightAnim="stand_turnRhip_satchel"
    PA_TurnLeftAnim="stand_turnLhip_satchel"
    PA_TurnIronRightAnim="stand_turnRhip_satchel"
    PA_TurnIronLeftAnim="stand_turnLhip_satchel"
    PA_ProneTurnRightAnim="prone_turnR_satchel"
    PA_ProneTurnLeftAnim="prone_turnL_satchel"
    PA_StandToProneAnim="StandtoProne_satchel"
    PA_CrouchToProneAnim="CrouchtoProne_satchel"
    PA_ProneToStandAnim="PronetoStand_satchel"
    PA_ProneToCrouchAnim="PronetoCrouch_satchel"
    PA_DiveToProneStartAnim="prone_diveF_satchel"
    PA_DiveToProneEndAnim="prone_diveend_satchel"
    PA_CrouchTurnRightAnim="crouch_turnR_satchel"
    PA_CrouchTurnLeftAnim="crouch_turnL_satchel"
    PA_CrouchIdleRestAnim="crouch_idle_satchel"
    PA_IdleCrouchAnim="crouch_idle_satchel"
    PA_IdleRestAnim="stand_idlehip_satchel"
    PA_IdleWeaponAnim="stand_idlehip_satchel"
    PA_IdleIronRestAnim="stand_idlehip_satchel"
    PA_IdleIronWeaponAnim="stand_idlehip_satchel"
    PA_IdleProneAnim="prone_idle_satchel"
    PA_ReloadAnim=""
    PA_ProneReloadAnim=""
    PA_ProneIdleRestAnim="prone_idle_satchel"
    PA_Fire="stand_throw_satchel"
    PA_IronFire="stand_throw_satchel"
    PA_CrouchFire="crouch_throw_satchel"
    PA_ProneFire="prone_throw_satchel"
    PA_MoveStandFire(0)="stand_throw_satchel"
    PA_MoveStandFire(1)="stand_throw_satchel"
    PA_MoveStandFire(2)="stand_throw_satchel"
    PA_MoveStandFire(3)="stand_throw_satchel"
    PA_MoveStandFire(4)="stand_throw_satchel"
    PA_MoveStandFire(5)="stand_throw_satchel"
    PA_MoveStandFire(6)="stand_throw_satchel"
    PA_MoveStandFire(7)="stand_throw_satchel"
    PA_MoveCrouchFire(0)="crouch_throw_satchel"
    PA_MoveCrouchFire(1)="crouch_throw_satchel"
    PA_MoveCrouchFire(2)="crouch_throw_satchel"
    PA_MoveCrouchFire(3)="crouch_throw_satchel"
    PA_MoveCrouchFire(4)="crouch_throw_satchel"
    PA_MoveCrouchFire(5)="crouch_throw_satchel"
    PA_MoveCrouchFire(6)="crouch_throw_satchel"
    PA_MoveCrouchFire(7)="crouch_throw_satchel"
    PA_MoveWalkFire(0)="stand_throw_satchel"
    PA_MoveWalkFire(1)="stand_throw_satchel"
    PA_MoveWalkFire(2)="stand_throw_satchel"
    PA_MoveWalkFire(3)="stand_throw_satchel"
    PA_MoveWalkFire(4)="stand_throw_satchel"
    PA_MoveWalkFire(5)="stand_throw_satchel"
    PA_MoveWalkFire(6)="stand_throw_satchel"
    PA_MoveWalkFire(7)="stand_throw_satchel"
    PA_MoveStandIronFire(0)="stand_throw_satchel"
    PA_MoveStandIronFire(1)="stand_throw_satchel"
    PA_MoveStandIronFire(2)="stand_throw_satchel"
    PA_MoveStandIronFire(3)="stand_throw_satchel"
    PA_MoveStandIronFire(4)="stand_throw_satchel"
    PA_MoveStandIronFire(5)="stand_throw_satchel"
    PA_MoveStandIronFire(6)="stand_throw_satchel"
    PA_MoveStandIronFire(7)="stand_throw_satchel"
    PA_FireLastShot="stand_throw_satchel"
    PA_IronFireLastShot="stand_throw_satchel"
    PA_CrouchFireLastShot="crouch_throw_satchel"
    PA_ProneFireLastShot="prone_throw_satchel"
    PA_AirStillAnim="jump_mid_satchel"
    PA_AirAnims(0)="jumpF_mid_satchel"
    PA_AirAnims(1)="jumpB_mid_satchel"
    PA_AirAnims(2)="jumpL_mid_satchel"
    PA_AirAnims(3)="jumpR_mid_satchel"
    PA_TakeoffStillAnim="jump_takeoff_satchel"
    PA_TakeoffAnims(0)="jumpF_takeoff_satchel"
    PA_TakeoffAnims(1)="jumpB_takeoff_satchel"
    PA_TakeoffAnims(2)="jumpL_takeoff_satchel"
    PA_TakeoffAnims(3)="jumpR_takeoff_satchel"
    PA_LandAnims(0)="jumpF_land_satchel"
    PA_LandAnims(1)="jumpB_land_satchel"
    PA_LandAnims(2)="jumpL_land_satchel"
    PA_LandAnims(3)="jumpR_land_satchel"
    PA_DodgeAnims(0)="jumpF_mid_satchel"
    PA_DodgeAnims(1)="jumpB_mid_satchel"
    PA_DodgeAnims(2)="jumpL_mid_satchel"
    PA_DodgeAnims(3)="jumpR_mid_satchel"
}

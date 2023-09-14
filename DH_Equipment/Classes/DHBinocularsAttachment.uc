//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHBinocularsAttachment extends DHWeaponAttachment;

// Modified to remove stuff related to bullets
simulated event ThirdPersonEffects()
{
    if (Level.NetMode != NM_DedicatedServer && ROPawn(Instigator) != none)
    {
        if (FlashCount == 0)
        {
            ROPawn(Instigator).StopFiring();
        }
        else if (FiringMode == 0)
        {
            ROPawn(Instigator).StartFiring(bHeavy, bRapidFire);
        }
        else
        {
            ROPawn(Instigator).StartFiring(bHeavy, bAltRapidFire);
        }
    }
}

defaultproperties
{
    Mesh=SkeletalMesh'Weapons3rd_anm.Binocs_ger'
    CullDistance=4096.0 // 68m - undo the increase added in DHWeaponAttachment, as binoculars don't have a muzzle flash & are also small
    MenuImage=Texture'InterfaceArt_tex.Menu_weapons.Binocs'
    bRapidFire=false
    LightType=LT_None
    LightEffect=LE_None

    WA_Idle="idle_binocs"
    WA_Fire="idle_binocs"

    PA_MovementAnims(0)="stand_jogF_nade"
    PA_MovementAnims(1)="stand_jogB_nade"
    PA_MovementAnims(2)="stand_jogL_nade"
    PA_MovementAnims(3)="stand_jogR_nade"
    PA_MovementAnims(4)="stand_jogFL_nade"
    PA_MovementAnims(5)="stand_jogFR_nade"
    PA_MovementAnims(6)="stand_jogBL_nade"
    PA_MovementAnims(7)="stand_jogBR_nade"
    PA_CrouchAnims(0)="crouch_walkF_binoc"
    PA_CrouchAnims(1)="crouch_walkB_binoc"
    PA_CrouchAnims(2)="crouch_walkL_binoc"
    PA_CrouchAnims(3)="crouch_walkR_binoc"
    PA_CrouchAnims(4)="crouch_walkFL_binoc"
    PA_CrouchAnims(5)="crouch_walkFR_binoc"
    PA_CrouchAnims(6)="crouch_walkBL_binoc"
    PA_CrouchAnims(7)="crouch_walkBR_binoc"
    PA_ProneAnims(0)="prone_crawlF_nade"
    PA_ProneAnims(1)="prone_crawlB_nade"
    PA_ProneAnims(2)="prone_crawlL_nade"
    PA_ProneAnims(3)="prone_crawlR_nade"
    PA_ProneAnims(4)="prone_crawlFL_nade"
    PA_ProneAnims(5)="prone_crawlFR_nade"
    PA_ProneAnims(6)="prone_crawlBL_nade"
    PA_ProneAnims(7)="prone_crawlBR_nade"
    PA_ProneIronAnims(0)="prone_slowcrawlF_binoc"
    PA_ProneIronAnims(1)="prone_slowcrawlB_binoc"
    PA_ProneIronAnims(2)="prone_slowcrawlL_binoc"
    PA_ProneIronAnims(3)="prone_slowcrawlR_binoc"
    PA_ProneIronAnims(4)="prone_slowcrawlL_binoc"
    PA_ProneIronAnims(5)="prone_slowcrawlR_binoc"
    PA_ProneIronAnims(6)="prone_slowcrawlB_binoc"
    PA_ProneIronAnims(7)="prone_slowcrawlB_binoc"
    PA_WalkAnims(0)="stand_walkFhip_nade"
    PA_WalkAnims(1)="stand_walkBhip_nade"
    PA_WalkAnims(2)="stand_walkLhip_nade"
    PA_WalkAnims(3)="stand_walkRhip_nade"
    PA_WalkAnims(4)="stand_walkFLhip_nade"
    PA_WalkAnims(5)="stand_walkFRhip_nade"
    PA_WalkAnims(6)="stand_walkBLhip_nade"
    PA_WalkAnims(7)="stand_walkBRhip_nade"
    PA_WalkIronAnims(0)="stand_walkFiron_binoc"
    PA_WalkIronAnims(1)="stand_walkBiron_binoc"
    PA_WalkIronAnims(2)="stand_walkLiron_binoc"
    PA_WalkIronAnims(3)="stand_walkRiron_binoc"
    PA_WalkIronAnims(4)="stand_walkFLiron_binoc"
    PA_WalkIronAnims(5)="stand_walkFRiron_binoc"
    PA_WalkIronAnims(6)="stand_walkBLiron_binoc"
    PA_WalkIronAnims(7)="stand_walkBRiron_binoc"
    PA_SprintAnims(0)="stand_sprintF_nade"
    PA_SprintAnims(1)="stand_sprintB_nade"
    PA_SprintAnims(2)="stand_sprintL_nade"
    PA_SprintAnims(3)="stand_sprintR_nade"
    PA_SprintAnims(4)="stand_sprintFL_nade"
    PA_SprintAnims(5)="stand_sprintFR_nade"
    PA_SprintAnims(6)="stand_sprintBL_nade"
    PA_SprintAnims(7)="stand_sprintBR_nade"
    PA_SprintCrouchAnims(0)="crouch_sprintF_nade"
    PA_SprintCrouchAnims(1)="crouch_sprintB_nade"
    PA_SprintCrouchAnims(2)="crouch_sprintL_nade"
    PA_SprintCrouchAnims(3)="crouch_sprintR_nade"
    PA_SprintCrouchAnims(4)="crouch_sprintFL_nade"
    PA_SprintCrouchAnims(5)="crouch_sprintFR_nade"
    PA_SprintCrouchAnims(6)="crouch_sprintBL_nade"
    PA_SprintCrouchAnims(7)="crouch_sprintBR_nade"
    PA_TurnRightAnim="stand_turnRhip_binoc"
    PA_TurnLeftAnim="stand_turnLhip_binoc"
    PA_TurnIronRightAnim="stand_turnRiron_binoc"
    PA_TurnIronLeftAnim="stand_turnLiron_binoc"
    PA_CrouchTurnIronRightAnim="crouch_turnRiron_binoc"
    PA_CrouchTurnIronLeftAnim="crouch_turnLiron_binoc"
    PA_ProneTurnRightAnim="prone_turnR_binoc"
    PA_ProneTurnLeftAnim="prone_turnL_binoc"
    PA_StandToProneAnim="StandtoProne_binoc"
    PA_CrouchToProneAnim="CrouchtoProne_binoc"
    PA_ProneToStandAnim="PronetoStand_binoc"
    PA_ProneToCrouchAnim="ProneToCrouch_binoc"
    PA_DiveToProneStartAnim="prone_diveF_binoc"
    PA_DiveToProneEndAnim="prone_diveend_binoc"
    PA_CrouchTurnRightAnim="crouch_turnR_nade"
    PA_CrouchTurnLeftAnim="crouch_turnL_nade"  // there is a "crouch_turnL_binoc" anim, but nade anims are used instead because there is no "crouch_turnR_binoc"
    PA_CrouchIdleRestAnim="crouch_idle_binoc"
    PA_IdleCrouchAnim="crouch_idle_binoc"
    PA_IdleRestAnim="stand_idlehip_binoc"
    PA_IdleWeaponAnim="stand_idlehip_binoc"
    PA_IdleIronRestAnim="stand_idleiron_binoc"
    PA_IdleIronWeaponAnim="stand_idleiron_binoc"
    PA_IdleCrouchIronWeaponAnim="crouch_idleiron_binoc"
    PA_IdleProneAnim="prone_idle_binoc"
    PA_ReloadAnim=""
    PA_ProneReloadAnim=""
    PA_ProneIdleRestAnim="prone_idle_binoc"
    PA_AirStillAnim="jump_mid_nade"
    PA_AirAnims(0)="jumpF_mid_nade"
    PA_AirAnims(1)="jumpB_mid_nade"
    PA_AirAnims(2)="jumpL_mid_nade"
    PA_AirAnims(3)="jumpR_mid_nade"
    PA_TakeoffStillAnim="jump_takeoff_nade"
    PA_TakeoffAnims(0)="jumpF_takeoff_nade"
    PA_TakeoffAnims(1)="jumpB_takeoff_nade"
    PA_TakeoffAnims(2)="jumpL_takeoff_nade"
    PA_TakeoffAnims(3)="jumpR_takeoff_nade"
    PA_LandAnims(0)="jumpF_land_nade"
    PA_LandAnims(1)="jumpB_land_nade"
    PA_LandAnims(2)="jumpL_land_nade"
    PA_LandAnims(3)="jumpR_land_nade"
    PA_DodgeAnims(0)="jumpF_mid_nade"
    PA_DodgeAnims(1)="jumpB_mid_nade"
    PA_DodgeAnims(2)="jumpL_mid_nade"
    PA_DodgeAnims(3)="jumpR_mid_nade"
}

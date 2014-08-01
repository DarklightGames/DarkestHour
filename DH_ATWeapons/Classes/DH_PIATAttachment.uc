//=============================================================================
// DH_PIATAttachment
//=============================================================================
class DH_PIATAttachment extends DHWeaponAttachment;

var   mesh   EmptyMesh;  // The mesh to swap to after the round is fired

// Overridden because the 3rd person effects are handled differently for the panzerfaust
simulated function PostBeginPlay()
{
	if (Role == ROLE_Authority)
	{
		bOldBayonetAttached = bBayonetAttached;
		bOldBarrelSteamActive = bBarrelSteamActive;
		bUpdated = true;
	}
}

// Overridden because the 3rd person effects are handled differently for the panzerfaust
simulated event ThirdPersonEffects()
{

	// Only switch to the empty mesh if its not a melee attack
	if (FiringMode == 0)
		LinkMesh(EmptyMesh);

	if (Level.NetMode == NM_DedicatedServer || ROPawn(Instigator) == none)
		return;

/*	if (FlashCount > 0 && ((FiringMode == 0) || bAltFireFlash))
	{
		if ((Level.TimeSeconds - LastRenderTime > 0.2) && (PlayerController(Instigator.Controller) == none))
			return;

		WeaponLight();

		mMuzFlash3rd = Spawn(mMuzFlashClass);
		AttachToBone(mMuzFlash3rd, MuzzleBoneName);
	}*/

    if (FlashCount == 0)
    {
        ROPawn(Instigator).StopFiring();
    }
    else if (FiringMode == 0)
    {
        ROPawn(Instigator).StartFiring(false, bRapidFire);
    }
    else
    {
        ROPawn(Instigator).StartFiring(true, bAltRapidFire);
    }

}

defaultproperties
{
     EmptyMesh=SkeletalMesh'DH_Weapons3rd_anm.PIAT_NoShell_3rd'
     MuzzleBoneName="Muzzle"
     PA_MovementAnims(0)="stand_jogF_ptrd"
     PA_MovementAnims(1)="stand_jogB_ptrd"
     PA_MovementAnims(2)="stand_jogL_ptrd"
     PA_MovementAnims(3)="stand_jogR_ptrd"
     PA_MovementAnims(4)="stand_jogFL_ptrd"
     PA_MovementAnims(5)="stand_jogFR_ptrd"
     PA_MovementAnims(6)="stand_jogBL_ptrd"
     PA_MovementAnims(7)="stand_jogBR_ptrd"
     PA_CrouchAnims(0)="crouch_walkF_ptrd"
     PA_CrouchAnims(1)="crouch_walkB_ptrd"
     PA_CrouchAnims(2)="crouch_walkL_ptrd"
     PA_CrouchAnims(3)="crouch_walkR_ptrd"
     PA_CrouchAnims(4)="crouch_walkFL_ptrd"
     PA_CrouchAnims(5)="crouch_walkFR_ptrd"
     PA_CrouchAnims(6)="crouch_walkBL_ptrd"
     PA_CrouchAnims(7)="crouch_walkBR_ptrd"
     PA_ProneAnims(0)="prone_crawlF_C96"
     PA_ProneAnims(1)="prone_crawlB_C96"
     PA_ProneAnims(2)="prone_crawlL_C96"
     PA_ProneAnims(3)="prone_crawlR_C96"
     PA_ProneAnims(4)="prone_crawlFL_C96"
     PA_ProneAnims(5)="prone_crawlFR_C96"
     PA_ProneAnims(6)="prone_crawlBL_C96"
     PA_ProneAnims(7)="prone_crawlBR_C96"
     PA_ProneIronAnims(0)="prone_slowcrawlF_faust"
     PA_ProneIronAnims(1)="prone_slowcrawlB_faust"
     PA_ProneIronAnims(2)="prone_slowcrawlL_faust"
     PA_ProneIronAnims(3)="prone_slowcrawlR_faust"
     PA_ProneIronAnims(4)="prone_slowcrawlL_faust"
     PA_ProneIronAnims(5)="prone_slowcrawlR_faust"
     PA_ProneIronAnims(6)="prone_slowcrawlB_faust"
     PA_ProneIronAnims(7)="prone_slowcrawlB_faust"
     PA_WalkAnims(0)="stand_walkFhip_ptrd"
     PA_WalkAnims(1)="stand_walkBhip_ptrd"
     PA_WalkAnims(2)="stand_walkLhip_ptrd"
     PA_WalkAnims(3)="stand_walkRhip_ptrd"
     PA_WalkAnims(4)="stand_walkFLhip_ptrd"
     PA_WalkAnims(5)="stand_walkFRhip_ptrd"
     PA_WalkAnims(6)="stand_walkBLhip_ptrd"
     PA_WalkAnims(7)="stand_walkBRhip_ptrd"
     PA_WalkIronAnims(0)="stand_walkFiron_faust"
     PA_WalkIronAnims(1)="stand_walkBiron_faust"
     PA_WalkIronAnims(2)="stand_walkLiron_faust"
     PA_WalkIronAnims(3)="stand_walkRiron_faust"
     PA_WalkIronAnims(4)="stand_walkFLiron_faust"
     PA_WalkIronAnims(5)="stand_walkFRiron_faust"
     PA_WalkIronAnims(6)="stand_walkBLiron_faust"
     PA_WalkIronAnims(7)="stand_walkBRiron_faust"
     PA_SprintAnims(0)="stand_sprintF_ptrd"
     PA_SprintAnims(1)="stand_sprintB_ptrd"
     PA_SprintAnims(2)="stand_sprintL_ptrd"
     PA_SprintAnims(3)="stand_sprintR_ptrd"
     PA_SprintAnims(4)="stand_sprintFL_ptrd"
     PA_SprintAnims(5)="stand_sprintFR_ptrd"
     PA_SprintAnims(6)="stand_sprintBL_ptrd"
     PA_SprintAnims(7)="stand_sprintBR_ptrd"
     PA_SprintCrouchAnims(0)="crouch_sprintF_ptrd"
     PA_SprintCrouchAnims(1)="crouch_sprintB_ptrd"
     PA_SprintCrouchAnims(2)="crouch_sprintL_ptrd"
     PA_SprintCrouchAnims(3)="crouch_sprintR_ptrd"
     PA_SprintCrouchAnims(4)="crouch_sprintFL_ptrd"
     PA_SprintCrouchAnims(5)="crouch_sprintFR_ptrd"
     PA_SprintCrouchAnims(6)="crouch_sprintBL_ptrd"
     PA_SprintCrouchAnims(7)="crouch_sprintBR_ptrd"
     PA_LimpAnims(0)="stand_limpFhip_ptrd"
     PA_LimpAnims(1)="stand_limpBhip_ptrd"
     PA_LimpAnims(2)="stand_limpLhip_ptrd"
     PA_LimpAnims(3)="stand_limpRhip_ptrd"
     PA_LimpAnims(4)="stand_limpFLhip_ptrd"
     PA_LimpAnims(5)="stand_limpFRhip_ptrd"
     PA_LimpAnims(6)="stand_limpBLhip_ptrd"
     PA_LimpAnims(7)="stand_limpBRhip_ptrd"
     PA_LimpIronAnims(0)="stand_limpFiron_faust"
     PA_LimpIronAnims(1)="stand_limpBiron_faust"
     PA_LimpIronAnims(2)="stand_limpLiron_faust"
     PA_LimpIronAnims(3)="stand_limpRiron_faust"
     PA_LimpIronAnims(4)="stand_limpFLiron_faust"
     PA_LimpIronAnims(5)="stand_limpFRiron_faust"
     PA_LimpIronAnims(6)="stand_limpBLiron_faust"
     PA_LimpIronAnims(7)="stand_limpBRiron_faust"
     PA_TurnRightAnim="stand_turnRhip_ptrd"
     PA_TurnLeftAnim="stand_turnLhip_ptrd"
     PA_TurnIronRightAnim="stand_turnRiron_faust"
     PA_TurnIronLeftAnim="stand_turnLiron_faust"
     PA_CrouchTurnIronRightAnim="crouch_turnRiron_faust"
     PA_CrouchTurnIronLeftAnim="crouch_turnRiron_faust"
     PA_ProneTurnRightAnim="prone_turnR_mg34"
     PA_ProneTurnLeftAnim="prone_turnL_mg34"
     PA_StandToProneAnim="StandtoProne_mg34"
     PA_CrouchToProneAnim="CrouchtoProne_mg42"
     PA_ProneToStandAnim="PronetoStand_ptrd"
     PA_ProneToCrouchAnim="PronetoCrouch_ptrd"
     PA_DiveToProneStartAnim="prone_diveF_kar"
     PA_DiveToProneEndAnim="prone_diveend_faust"
     PA_CrouchTurnRightAnim="crouch_turnR_ptrd"
     PA_CrouchTurnLeftAnim="crouch_turnL_ptrd"
     PA_CrouchIdleRestAnim="crouch_idle_ptrd"
     PA_IdleCrouchAnim="crouch_idle_ptrd"
     PA_IdleRestAnim="stand_idlehip_ptrd"
     PA_IdleWeaponAnim="stand_idlehip_ptrd"
     PA_IdleIronRestAnim="stand_idleiron_mg42"
     PA_IdleIronWeaponAnim="stand_idleiron_mg42"
     PA_IdleCrouchIronWeaponAnim="crouch_idleiron_mg42"
     PA_IdleProneAnim="prone_idle_mg42"
     PA_ReloadAnim="stand_reloadempty_dp27"
     PA_ProneReloadAnim="prone_reloadempty_dp27"
     PA_ReloadEmptyAnim="stand_reloadempty_dp27"
     PA_ProneReloadEmptyAnim="prone_reloadempty_dp27"
     PA_ProneIdleRestAnim="prone_idle_mg42"
     PA_BayonetAttachAnim="bayattach_faust"
     PA_ProneBayonetAttachAnim="prone_Bayattach_faust"
     PA_BayonetDetachAnim="bayremove_faust"
     PA_ProneBayonetDetachAnim="prone_Bayremove_faust"
     PA_Fire="stand_shootiron_mg42"
     PA_IronFire="stand_shootiron_mg42"
     PA_CrouchFire="crouch_shoot_mg34"
     PA_ProneFire="prone_shoot_mg42"
     PA_MoveStandFire(0)="stand_shootiron_mg42"
     PA_MoveStandFire(1)="stand_shootiron_mg42"
     PA_MoveStandFire(2)="stand_shootLRiron_faust"
     PA_MoveStandFire(3)="stand_shootLRiron_faust"
     PA_MoveStandFire(4)="stand_shootFLiron_faust"
     PA_MoveStandFire(5)="stand_shootFRiron_faust"
     PA_MoveStandFire(6)="stand_shootFRiron_faust"
     PA_MoveStandFire(7)="stand_shootFLiron_faust"
     PA_MoveCrouchFire(0)="crouch_shootF_faust"
     PA_MoveCrouchFire(1)="crouch_shootF_faust"
     PA_MoveCrouchFire(2)="crouch_shootLR_faust"
     PA_MoveCrouchFire(3)="crouch_shootLR_faust"
     PA_MoveCrouchFire(4)="crouch_shootF_faust"
     PA_MoveCrouchFire(5)="crouch_shootF_faust"
     PA_MoveCrouchFire(6)="crouch_shootF_faust"
     PA_MoveCrouchFire(7)="crouch_shootF_faust"
     PA_MoveWalkFire(0)="stand_shootFwalk_faust"
     PA_MoveWalkFire(1)="stand_shootFwalk_faust"
     PA_MoveWalkFire(2)="stand_shootLRwalk_faust"
     PA_MoveWalkFire(3)="stand_shootLRwalk_faust"
     PA_MoveWalkFire(4)="stand_shootFLwalk_faust"
     PA_MoveWalkFire(5)="stand_shootFRwalk_faust"
     PA_MoveWalkFire(6)="stand_shootFRwalk_faust"
     PA_MoveWalkFire(7)="stand_shootFLwalk_faust"
     PA_MoveStandIronFire(0)="stand_shootiron_mg42"
     PA_MoveStandIronFire(1)="stand_shootiron_mg42"
     PA_MoveStandIronFire(2)="stand_shootLRiron_faust"
     PA_MoveStandIronFire(3)="stand_shootLRiron_faust"
     PA_MoveStandIronFire(4)="stand_shootFLiron_faust"
     PA_MoveStandIronFire(5)="stand_shootFRiron_faust"
     PA_MoveStandIronFire(6)="stand_shootFRiron_faust"
     PA_MoveStandIronFire(7)="stand_shootFLiron_faust"
     PA_AltFire="stand_idlestrike_kar"
     PA_CrouchAltFire="stand_idlestrike_kar"
     PA_ProneAltFire="prone_idlestrike_bayo"
     PA_BayonetAltFire="baystrike_faust"
     PA_CrouchBayonetAltFire="baystrike_faust"
     PA_ProneBayonetAltFire="baystrike_faust"
     PA_FireLastShot="stand_shoothip_faust"
     PA_IronFireLastShot="stand_shootiron_faust"
     PA_CrouchFireLastShot="crouch_shoot_faust"
     PA_ProneFireLastShot="prone_shoot_faust"
     WA_Idle="idle_PIAT"
     WA_Fire="idle_PIAT"
     WA_Reload="idle_PIAT"
     WA_ProneReload="idle_PIAT"
     menuImage=Texture'DH_InterfaceArt_tex.weapon_icons.PIAT_icon'
     MenuDescription="P.I.A.T.: Projector, Infantry Anti-Tank. Man portable anti-tank weapon used by British and Commonwealth forces. Uses a manually set spigot system to launch a hollow charge bomb up to 350 yards, although only accurate to about 100 yards. Armor penetration: 85 to 90mm of effective armor. Sights are calibrated at 50, 80, and 110 yards."
     bHeavy=true
     bRapidFire=false
     Mesh=SkeletalMesh'DH_Weapons3rd_anm.PIAT_3rd'
}

//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_Winchester1897Attachment extends DHWeaponAttachment;


// Modified so we don't play play the idle anim (which is all the Super does) if we just played reload or pre-reload animation
// This is because the reload anims play in a sequence, ending with the post-reload anim (same as bolt action sniper rifles)
simulated function AnimEnd(int Channel)
{
    local name  Anim;
    local float Frame, Rate;

    GetAnimParams(0, Anim, Frame, Rate);

    if (Anim != WA_Reload && Anim != WA_PreReload)
    {
        super.AnimEnd(Channel);
    }
}

defaultproperties
{
    Mesh=SkeletalMesh'DH_Winchester1897_anm.Winchester1897_3rd'
    Skins(0)=Texture'DH_Winchester1897_tex.Winchester.Winchester1897_3rdP'
    MenuImage=Texture'DH_InterfaceArt_tex.weapon_icons.Winchester1897_icon'

    mMuzFlashClass=class'ROEffects.MuzzleFlash3rdNagant'
    MuzzleBoneName="muzzle"
    ROShellCaseClass=class'DH_Weapons.DH_3rdShellEjectShotgun'
    ShellEjectionBoneName="ejector"
    bAnimNotifiedShellEjects=true // 'Pump_action' animation includes an anim notify to spawn an ejected shell that other players see
    bRapidFire=false


    //weapon animations, mostly handled by the character
    WA_Idle="idle_1897"
    WA_Fire="idle_1897"
    WA_WorkBolt="pump_standing_1897"
    WA_Reload="idle_1897"
    WA_ProneReload="idle_1897"
    WA_PostReload="reload_end_1897"

    // bayonet
    WA_BayonetIdle="idle_bayo_1897" 
    WA_BayonetIdleEmpty="idle_bayo_1897"
    WA_BayonetFire="idle_bayo_1897"
    WA_BayonetReload="idle_bayo_1897"
    WA_BayonetReloadEmpty="idle_bayo_1897"
    WA_BayonetProneReload="idle_bayo_1897"
    WA_BayonetProneReloadEmpty="idle_bayo_1897"
    WA_BayonetPreReload="idle_bayo_1897"
    WA_BayonetPostReload="reload_end_bayo_1897"
    WA_BayonetAttach="stand_bayattach_1897" 
    WA_BayonetDetach="stand_bayremove_1897" 
    WA_BayonetAttachProne="prone_bayattach_1897" 
    WA_BayonetDetachProne="prone_bayremove_1897"   
    WA_BayonetWorkBolt="pump_standing_bayo_1897"

    //pumping animations
    PA_StandBoltActionAnim="pump_standing_1897"
    PA_StandIronBoltActionAnim="pump_standing_iron_1897"
    PA_CrouchBoltActionAnim="pump_crouch_1897"
    PA_CrouchIronBoltActionAnim="pump_crouch_iron_1897"
    PA_ProneBoltActionAnim="pump_prone_1897"

    //reload anims
    PA_PreReloadAnim="reload_start_1897"
    PA_PronePreReloadAnim="prone_reload_start_1897" 
    PA_ReloadAnim="reload_single_1897"
    PA_ReloadEmptyAnim="reload_single_1897"
    PA_ProneReloadAnim="prone_reload_single_1897"
    PA_ProneReloadEmptyAnim="prone_reload_single_1897"
    PA_PostReloadAnim="reload_end_1897"
    PA_PronePostReloadAnim="prone_reload_end_1897"

    //bayonet attaching animations
    PA_BayonetAttachAnim="stand_bayattach_1897"
    PA_ProneBayonetAttachAnim="prone_Bayattach_1897"
    PA_BayonetDetachAnim="stand_bayremove_1897" 
    PA_ProneBayonetDetachAnim="prone_bayremove_1897"
    
    //bayonet stabbing animations
    PA_BayonetAltFire="stand_stab_kar"
    PA_CrouchBayonetAltFire="crouch_idlestrike_bayo"
    PA_ProneBayonetAltFire="prone_idlestrike_bayo"
    
    //movement animations
    PA_MovementAnims(0)="stand_jogF_1897"
    PA_MovementAnims(1)="stand_jogB_1897"
    PA_MovementAnims(2)="stand_jogL_1897"
    PA_MovementAnims(3)="stand_jogR_1897"
    PA_MovementAnims(4)="stand_jogFL_1897"
    PA_MovementAnims(5)="stand_jogFR_1897"
    PA_MovementAnims(6)="stand_jogBL_1897"
    PA_MovementAnims(7)="stand_jogBR_1897"

    //crouch
    PA_CrouchAnims(0)="crouch_walkF_1897"
    PA_CrouchAnims(1)="crouch_walkB_1897"
    PA_CrouchAnims(2)="crouch_walkL_1897"
    PA_CrouchAnims(3)="crouch_walkR_1897"
    PA_CrouchAnims(4)="crouch_walkFL_1897"
    PA_CrouchAnims(5)="crouch_walkFR_1897"
    PA_CrouchAnims(6)="crouch_walkBL_1897"
    PA_CrouchAnims(7)="crouch_walkBR_1897"

    //walk
    PA_WalkAnims(0)="stand_walkFhip_1897"
    PA_WalkAnims(1)="stand_walkBhip_1897"
    PA_WalkAnims(2)="stand_walkLhip_1897"
    PA_WalkAnims(3)="stand_walkRhip_1897"
    PA_WalkAnims(4)="stand_walkFLhip_1897"
    PA_WalkAnims(5)="stand_walkFRhip_1897"
    PA_WalkAnims(6)="stand_walkBLhip_1897"
    PA_WalkAnims(7)="stand_walkBRhip_1897"

    //walkiron
    PA_WalkIronAnims(0)="stand_walkFiron_1897"
    PA_WalkIronAnims(1)="stand_walkBiron_1897"
    PA_WalkIronAnims(2)="stand_walkLiron_1897"
    PA_WalkIronAnims(3)="stand_walkRiron_1897"
    PA_WalkIronAnims(4)="stand_walkFLiron_1897"
    PA_WalkIronAnims(5)="stand_walkFRiron_1897"
    PA_WalkIronAnims(6)="stand_walkBLiron_1897"
    PA_WalkIronAnims(7)="stand_walkBRiron_1897"

    //prone iron anims
    PA_ProneIronAnims(0)="prone_slowcrawlF_1897"
	PA_ProneIronAnims(1)="prone_slowcrawlB_1897"
	PA_ProneIronAnims(2)="prone_slowcrawlL_1897"
	PA_ProneIronAnims(3)="prone_slowcrawlR_1897"
	PA_ProneIronAnims(4)="prone_slowcrawlL_1897"
	PA_ProneIronAnims(5)="prone_slowcrawlR_1897"
	PA_ProneIronAnims(6)="prone_slowcrawlB_1897"
	PA_ProneIronAnims(7)="prone_slowcrawlB_1897"

    //sprint, anims match up, no change
    PA_SprintAnims(0)="stand_sprintF_kar" 
    PA_SprintAnims(1)="stand_sprintB_kar" 
    PA_SprintAnims(2)="stand_sprintL_kar"
    PA_SprintAnims(3)="stand_sprintR_kar"
    PA_SprintAnims(4)="stand_sprintFL_kar"
    PA_SprintAnims(5)="stand_sprintFR_kar"
    PA_SprintAnims(6)="stand_sprintBL_kar"
    PA_SprintAnims(7)="stand_sprintBR_kar"

    //sprintcrouch, anims match up, no change
    PA_SprintCrouchAnims(0)="crouch_sprintF_kar"
    PA_SprintCrouchAnims(1)="crouch_sprintB_kar"
    PA_SprintCrouchAnims(2)="crouch_sprintL_kar"
    PA_SprintCrouchAnims(3)="crouch_sprintR_kar"
    PA_SprintCrouchAnims(4)="crouch_sprintFL_kar"
    PA_SprintCrouchAnims(5)="crouch_sprintFR_kar"
    PA_SprintCrouchAnims(6)="crouch_sprintBL_kar"
    PA_SprintCrouchAnims(7)="crouch_sprintBR_kar"

    //turn, no change
    PA_TurnRightAnim="stand_turnRhip_kar"
    PA_TurnLeftAnim="stand_turnLhip_kar"
    PA_TurnIronRightAnim="stand_turnRiron_kar"
    PA_TurnIronLeftAnim="stand_turnLiron_kar"
    PA_ProneTurnRightAnim="prone_turnR_1987"
	PA_ProneTurnLeftAnim="prone_turnL_1987"

    //intermission anims
    PA_StandToProneAnim="StandtoProne_1897"
    PA_CrouchToProneAnim="CrouchtoProne_1897"
    PA_ProneToStandAnim="PronetoStand_kar"
    PA_ProneToCrouchAnim="PronetoCrouch_kar"

    //dive, no change
    PA_DiveToProneStartAnim="prone_diveF_kar"
    PA_DiveToProneEndAnim="prone_diveend_kar"

    //idle
    PA_CrouchIdleRestAnim="crouch_idle_1897"
    PA_IdleCrouchAnim="crouch_idle_1897"
    PA_IdleRestAnim="stand_idlehip_1897"
    PA_IdleWeaponAnim="stand_idlehip_1897"
    PA_IdleIronRestAnim="stand_idleiron_1897"
    PA_IdleIronWeaponAnim="stand_idleiron_1897"
    PA_IdleCrouchIronWeaponAnim="crouch_idleiron_1897"
    PA_ProneIdleRestAnim="prone_idle_1897"  
    PA_IdleProneAnim="prone_idle_1897"

    //shooting
    PA_Fire="stand_shoothip_kar"
    PA_IronFire="stand_shootiron_kar"
    PA_CrouchFire="crouch_shoot_kar"
    PA_ProneFire="prone_shoot_kar"

    //moving shooting
    PA_MoveStandFire(0)="stand_shootFhip_1897"
    PA_MoveStandFire(1)="stand_shootFhip_1897"
    PA_MoveStandFire(2)="stand_shootLRhip_1897"
    PA_MoveStandFire(3)="stand_shootLRhip_1897"
    PA_MoveStandFire(4)="stand_shootFLhip_1897"
    PA_MoveStandFire(5)="stand_shootFRhip_1897"
    PA_MoveStandFire(6)="stand_shootFRhip_1897"
    PA_MoveStandFire(7)="stand_shootFLhip_1897"

    //moving, crouching firing
    PA_MoveCrouchFire(0)="crouch_shootF_1897"
    PA_MoveCrouchFire(1)="crouch_shootF_1897"
    PA_MoveCrouchFire(2)="crouch_shootLR_1897"
    PA_MoveCrouchFire(3)="crouch_shootLR_1897"
    PA_MoveCrouchFire(4)="crouch_shootF_1897"
    PA_MoveCrouchFire(5)="crouch_shootF_1897"
    PA_MoveCrouchFire(6)="crouch_shootF_1897"
    PA_MoveCrouchFire(7)="crouch_shootF_1897"

    //moving, walking firing
    PA_MoveWalkFire(0)="stand_shootFwalk_1897"
    PA_MoveWalkFire(1)="stand_shootFwalk_1897"
    PA_MoveWalkFire(2)="stand_shootLRwalk_1897"
    PA_MoveWalkFire(3)="stand_shootLRwalk_1897"
    PA_MoveWalkFire(4)="stand_shootFLwalk_1897"
    PA_MoveWalkFire(5)="stand_shootFRwalk_1897"
    PA_MoveWalkFire(6)="stand_shootFRwalk_1897"
    PA_MoveWalkFire(7)="stand_shootFLwalk_1897"

    //moving, standing firing
    PA_MoveStandIronFire(0)="stand_shootiron_1897"
    PA_MoveStandIronFire(1)="stand_shootiron_1897"
    PA_MoveStandIronFire(2)="stand_shootLRiron_1897"
    PA_MoveStandIronFire(3)="stand_shootLRiron_1897"
    PA_MoveStandIronFire(4)="stand_shootFLiron_1897"
    PA_MoveStandIronFire(5)="stand_shootFRiron_1897"
    PA_MoveStandIronFire(6)="stand_shootFRiron_1897"
    PA_MoveStandIronFire(7)="stand_shootFLiron_1897"

    //misc
    PA_FireLastShot="stand_shoothip_1897"
    PA_IronFireLastShot="stand_shootiron_1897"
    PA_CrouchFireLastShot="crouch_shoot_1897"
    PA_ProneFireLastShot="prone_shoot_1897"
    PA_AltFire="stand_idlestrike_kar"
    PA_CrouchAltFire="stand_idlestrike_kar"
    PA_ProneAltFire="prone_idlestrike_bayo"
}

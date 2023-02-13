//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_Winchester1897Attachment extends DHWeaponAttachment;

#exec OBJ LOAD FILE=..\Sounds\DH_WeaponSounds.uax // Required

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

// New function to play the pump action sound for other players
// Can't do this from an animation notify in weapon attachment's 'pump' anim, as it would also play for the 1st person player
// He would then get the sound twice, creating an echo effect, as he already gets it from the 1st person weapon anim notifies
// So instead we make the attachment anim notify call this function, where we can apply a 3rd person player check
simulated function PlayThirdPersonPumpActionSound()
{
    if (Instigator != none && !Instigator.IsFirstPerson())
    {
        PlaySound(Sound'DH_WeaponSounds.Winchester1897.Shotgun_PumpAction');
    }
}

defaultproperties
{
    Mesh=SkeletalMesh'DH_Weapons3rd_anm.Winchester1897_3rd'
    Skins(0)=Texture'DH_Weapon_tex.AlliedSmallArms_3rdP.Winchester1897_3rdP'
    MenuImage=Texture'DH_InterfaceArt_tex.weapon_icons.Winchester1897_icon'

    mMuzFlashClass=class'ROEffects.MuzzleFlash3rdNagant'
    MuzzleBoneName="Muzzle"
    ROShellCaseClass=class'DH_Weapons.DH_3rdShellEjectShotgun'
    ShellEjectionBoneName="ejector"
    bAnimNotifiedShellEjects=true // 'Pump_action' animation includes an anim notify to spawn an ejected shell that other players see
    bRapidFire=false

    WA_Idle="Idle"
    WA_Fire="Idle"
    WA_WorkBolt="Pump_action"
    WA_Reload="Idle"
    WA_ProneReload="Idle"
    WA_PostReload="Pump_action"

    // Remove inherited player bolting anims as they look completely wrong for shotgun's pump action
    // Ideally we would have player anims working the pump action, but better to play no anim than an obviously bad one
    // Note we can't specify neutral idle anims here as they're too long & cause problems, e.g. their AnimEnd() triggers AnimBlendTimer() mid reload, screwing it up
    PA_StandBoltActionAnim=""
    PA_StandIronBoltActionAnim=""
    PA_CrouchBoltActionAnim=""
    PA_CrouchIronBoltActionAnim=""
    PA_ProneBoltActionAnim=""

    // Also don't have any specific player anims for reloading, so having to use single round reload player anims for sniper rifle
    // Round insert doesn't look too bad, but pre & post reload anims have the player working an invisible bolt
    // Have to play the pre-reload anim as it's required to progress to the reload anim (using a neutral idle anim doesn't work)
    // But can omit post-reload anims (can't use idle anim, as above), although would really benefit from a player anim working the pump action
    PA_PreReloadAnim="stand_open_karscope"
    PA_PronePreReloadAnim="prone_open_karscope"
    PA_ReloadAnim="stand_insert_karscope"
    PA_ReloadEmptyAnim="stand_insert_karscope"
    PA_ProneReloadAnim="prone_insert_karscope"
    PA_ProneReloadEmptyAnim="prone_insert_karscope"
//  PA_PostReloadAnim="stand_close_karscope"
//  PA_PronePostReloadAnim="prone_close_karscope"

    PA_MovementAnims(0)="stand_jogF_kar"
    PA_MovementAnims(1)="stand_jogB_kar"
    PA_MovementAnims(2)="stand_jogL_kar"
    PA_MovementAnims(3)="stand_jogR_kar"
    PA_MovementAnims(4)="stand_jogFL_kar"
    PA_MovementAnims(5)="stand_jogFR_kar"
    PA_MovementAnims(6)="stand_jogBL_kar"
    PA_MovementAnims(7)="stand_jogBR_kar"
    PA_CrouchAnims(0)="crouch_walkF_kar"
    PA_CrouchAnims(1)="crouch_walkB_kar"
    PA_CrouchAnims(2)="crouch_walkL_kar"
    PA_CrouchAnims(3)="crouch_walkR_kar"
    PA_CrouchAnims(4)="crouch_walkFL_kar"
    PA_CrouchAnims(5)="crouch_walkFR_kar"
    PA_CrouchAnims(6)="crouch_walkBL_kar"
    PA_CrouchAnims(7)="crouch_walkBR_kar"
    PA_WalkAnims(0)="stand_walkFhip_kar"
    PA_WalkAnims(1)="stand_walkBhip_kar"
    PA_WalkAnims(2)="stand_walkLhip_kar"
    PA_WalkAnims(3)="stand_walkRhip_kar"
    PA_WalkAnims(4)="stand_walkFLhip_kar"
    PA_WalkAnims(5)="stand_walkFRhip_kar"
    PA_WalkAnims(6)="stand_walkBLhip_kar"
    PA_WalkAnims(7)="stand_walkBRhip_kar"
    PA_WalkIronAnims(0)="stand_walkFiron_kar"
    PA_WalkIronAnims(1)="stand_walkBiron_kar"
    PA_WalkIronAnims(2)="stand_walkLiron_kar"
    PA_WalkIronAnims(3)="stand_walkRiron_kar"
    PA_WalkIronAnims(4)="stand_walkFLiron_kar"
    PA_WalkIronAnims(5)="stand_walkFRiron_kar"
    PA_WalkIronAnims(6)="stand_walkBLiron_kar"
    PA_WalkIronAnims(7)="stand_walkBRiron_kar"
    PA_SprintAnims(0)="stand_sprintF_kar"
    PA_SprintAnims(1)="stand_sprintB_kar"
    PA_SprintAnims(2)="stand_sprintL_kar"
    PA_SprintAnims(3)="stand_sprintR_kar"
    PA_SprintAnims(4)="stand_sprintFL_kar"
    PA_SprintAnims(5)="stand_sprintFR_kar"
    PA_SprintAnims(6)="stand_sprintBL_kar"
    PA_SprintAnims(7)="stand_sprintBR_kar"
    PA_SprintCrouchAnims(0)="crouch_sprintF_kar"
    PA_SprintCrouchAnims(1)="crouch_sprintB_kar"
    PA_SprintCrouchAnims(2)="crouch_sprintL_kar"
    PA_SprintCrouchAnims(3)="crouch_sprintR_kar"
    PA_SprintCrouchAnims(4)="crouch_sprintFL_kar"
    PA_SprintCrouchAnims(5)="crouch_sprintFR_kar"
    PA_SprintCrouchAnims(6)="crouch_sprintBL_kar"
    PA_SprintCrouchAnims(7)="crouch_sprintBR_kar"
    PA_TurnRightAnim="stand_turnRhip_kar"
    PA_TurnLeftAnim="stand_turnLhip_kar"
    PA_TurnIronRightAnim="stand_turnRiron_kar"
    PA_TurnIronLeftAnim="stand_turnLiron_kar"
    PA_StandToProneAnim="StandtoProne_kar"
    PA_CrouchToProneAnim="CrouchtoProne_kar"
    PA_ProneToStandAnim="PronetoStand_kar"
    PA_ProneToCrouchAnim="PronetoCrouch_kar"
    PA_DiveToProneStartAnim="prone_diveF_kar"
    PA_DiveToProneEndAnim="prone_diveend_kar"
    PA_CrouchIdleRestAnim="crouch_idle_kar"
    PA_IdleCrouchAnim="crouch_idle_kar"
    PA_IdleRestAnim="stand_idlehip_kar"
    PA_IdleWeaponAnim="stand_idlehip_kar"
    PA_IdleIronRestAnim="stand_idleiron_kar"
    PA_IdleIronWeaponAnim="stand_idleiron_kar"
    PA_IdleCrouchIronWeaponAnim="crouch_idleiron_kar"
    PA_ProneIdleRestAnim="prone_idle_kar"
    PA_Fire="stand_shoothip_kar"
    PA_IronFire="stand_shootiron_kar"
    PA_CrouchFire="crouch_shoot_kar"
    PA_ProneFire="prone_shoot_kar"
    PA_MoveStandFire(0)="stand_shootFhip_kar"
    PA_MoveStandFire(1)="stand_shootFhip_kar"
    PA_MoveStandFire(2)="stand_shootLRhip_kar"
    PA_MoveStandFire(3)="stand_shootLRhip_kar"
    PA_MoveStandFire(4)="stand_shootFLhip_kar"
    PA_MoveStandFire(5)="stand_shootFRhip_kar"
    PA_MoveStandFire(6)="stand_shootFRhip_kar"
    PA_MoveStandFire(7)="stand_shootFLhip_kar"
    PA_MoveCrouchFire(0)="crouch_shootF_kar"
    PA_MoveCrouchFire(1)="crouch_shootF_kar"
    PA_MoveCrouchFire(2)="crouch_shootLR_kar"
    PA_MoveCrouchFire(3)="crouch_shootLR_kar"
    PA_MoveCrouchFire(4)="crouch_shootF_kar"
    PA_MoveCrouchFire(5)="crouch_shootF_kar"
    PA_MoveCrouchFire(6)="crouch_shootF_kar"
    PA_MoveCrouchFire(7)="crouch_shootF_kar"
    PA_MoveWalkFire(0)="stand_shootFwalk_kar"
    PA_MoveWalkFire(1)="stand_shootFwalk_kar"
    PA_MoveWalkFire(2)="stand_shootLRwalk_kar"
    PA_MoveWalkFire(3)="stand_shootLRwalk_kar"
    PA_MoveWalkFire(4)="stand_shootFLwalk_kar"
    PA_MoveWalkFire(5)="stand_shootFRwalk_kar"
    PA_MoveWalkFire(6)="stand_shootFRwalk_kar"
    PA_MoveWalkFire(7)="stand_shootFLwalk_kar"
    PA_MoveStandIronFire(0)="stand_shootiron_kar"
    PA_MoveStandIronFire(1)="stand_shootiron_kar"
    PA_MoveStandIronFire(2)="stand_shootLRiron_kar"
    PA_MoveStandIronFire(3)="stand_shootLRiron_kar"
    PA_MoveStandIronFire(4)="stand_shootFLiron_kar"
    PA_MoveStandIronFire(5)="stand_shootFRiron_kar"
    PA_MoveStandIronFire(6)="stand_shootFRiron_kar"
    PA_MoveStandIronFire(7)="stand_shootFLiron_kar"
    PA_FireLastShot="stand_shoothip_kar"
    PA_IronFireLastShot="stand_shootiron_kar"
    PA_CrouchFireLastShot="crouch_shoot_kar"
    PA_ProneFireLastShot="prone_shoot_kar"
    PA_AltFire="stand_idlestrike_kar"
    PA_CrouchAltFire="stand_idlestrike_kar"
    PA_ProneAltFire="prone_idlestrike_bayo"
}

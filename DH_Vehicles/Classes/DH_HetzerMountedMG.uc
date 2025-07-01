//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_HetzerMountedMG extends DH_StuH42MountedMG;

var name IdleAnim;
var int GunReloadChannel;
var name GunReloadAnim;
var name GunReloadRootBone;
var name DriverReloadAnim;

simulated function PostBeginPlay()
{
    super.PostBeginPlay();

    AnimBlendParams(GunReloadChannel, 1.0,,, default.YawBone);
}

// Modified to put us into the reloading state.
simulated function StartReload(optional bool bResumingPausedReload)
{
    // We never resume from a paused reload on the Hetzer.
    super.StartReload(false);

    GotoState('Reloading');
}

simulated function PauseReload()
{
    super.PauseReload();

    GotoState('');
}

simulated state Reloading
{
    simulated function BeginState()
    {
        PitchBone = '';
        YawBone = '';

        SetBoneRotation(default.PitchBone, Rot(0, 0, 0));
        SetBoneRotation(default.YawBone, Rot(0, 0, 0));

        PlayAnim(GunReloadAnim, 1.0, 0.0, GunReloadChannel);

        if (WeaponPawn != none && WeaponPawn.Driver != none)
        {
            WeaponPawn.Driver.PlayAnim(DriverReloadAnim);
        }
    }

    simulated function EndState()
    {
        // Restore the pitch and yaw bone references.
        PitchBone = default.PitchBone;
        YawBone = default.YawBone;

        PlayAnim(IdleAnim, 1.0, 0.0, GunReloadChannel);
    }
Begin:
Sleep(GetAnimDuration(GunReloadAnim));
GotoState('');
}

defaultproperties
{
    Mesh=SkeletalMesh'DH_Hetzer_anm.HETZER_MG_EXT'
    Skins(0)=Texture'DH_Hetzer_tex.hetzer_body_ext'
    Skins(1)=Texture'Weapons3rd_tex.German.mg34_world'
    Skins(2)=Texture'DH_Hetzer_tex.hetzer_int'
    CollisionStaticMeshes(0)=(CollisionStaticMesh=StaticMesh'DH_Hetzer_stc.HETZER_MG_COLLISION_YAW',AttachBone="YAW")
    CollisionStaticMeshes(1)=(CollisionStaticMesh=StaticMesh'DH_Hetzer_stc.HETZER_MG_COLLISION_HATCH_L',AttachBone="HATCH_L")
    CollisionStaticMeshes(2)=(CollisionStaticMesh=StaticMesh'DH_Hetzer_stc.HETZER_MG_COLLISION_HATCH_R',AttachBone="HATCH_R")
    WeaponFireAttachmentBone="MUZZLE"
    FireEffectOffset=(X=-4.0)
    AmbientEffectEmitterClass=Class'DH_HetzerVehicleMGEmitter'
    CustomPitchUpLimit=1092         // + 6 degrees
    CustomPitchDownLimit=63716      // -10 degrees
    BeginningIdleAnim="idle"
    PitchBone="PITCH"
    YawBone="YAW"
    bLimitYaw=false
    GunnerAttachmentBone="ROOT"
    GunReloadAnim="RELOAD"
    GunReloadRootBone="YAW"
    IdleAnim="IDLE"
    GunReloadChannel=2
    DriverReloadAnim="HETZER_MG_RELOAD"

    // Timed so that the reload is considered complete once the bolt has been racked in the animation.
    // The sounds will be handled by notifies in the animation.
    ReloadStages(0)=(Sound=none,Duration=6.9)
    ReloadStages(1)=(Sound=none,Duration=0.0)
    ReloadStages(2)=(Sound=none,Duration=0.0)
    ReloadStages(3)=(Sound=none,Duration=0.0)
}

//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_HetzerMountedMGPawn extends DH_StuH42MountedMGPawn;

var() RangeInt HatchClearRange;

simulated function bool IsHatchBlocked()
{
    if (Gun == none)
    {
        return false;
    }

    if (Gun.CurrentAim.Yaw < HatchClearRange.Min || Gun.CurrentAim.Yaw > HatchClearRange.Max)
    {
        return true;
    }

    return false;
}

// Modified to prevent player from unbuttoning if MG is not turned sideways (otherwise it will be blocking hatch, due to hetzer's small size)
simulated function NextWeapon()
{
    if (IsHatchBlocked())
    {
        if (IsHumanControlled())
        {
            PlayerController(Controller).ReceiveLocalizedMessage(class'DH_HetzerVehicleMessage');
        }

        return;
    }

    super.NextWeapon();
}

exec simulated function ROManualReload()
{
    if (DriverPositionIndex != 1 || IsInState('ViewTransition'))
    {
        return;
    }

    // TODO: debugging the reload animations
    if (Driver != none)
    {
        Driver.PlayAnim(DriverReloadAnim);
    }

    const CHANNEL = 2;

    if (Gun != none)
    {
        //native final function AnimBlendParams( int Stage, optional float BlendAlpha, optional float InTime, optional float OutTime, optional name BoneName, optional bool bGlobalPose);
        // Gun.SetBoneRotation(Gun.YawBone, rot(0, 0, 0));
        // Gun.SetBoneRotation(Gun.PitchBone, rot(0, 0, 0));
        // TODO: We have an issue here with the gun because it's adding the yaw & pitch of the gun ontop of the animations.
        //  In order for this to look correct, we'd need to zero out the gun's rotation before playing the animation.
        //  However, this is not really possible because the native code to this doesn't seem to be exposed.
        Gun.CurrentAim.Pitch = 0;
        Gun.CurrentAim.Yaw = 0;
        CustomAim.Pitch = 0;
        CustomAim.Yaw = 0;
        UpdateSpecialCustomAim(1.0, 0, 0);
        //Gun.AnimBlendParams(CHANNEL, 1.0, 0.2, 0.2, GunReloadRootBone, true);
        Gun.SetBoneRotation(Gun.YawBone, rot(0, 0, 0));
        Gun.SetBoneRotation(Gun.PitchBone, rot(0, 0, 0));
        Gun.PlayAnim(GunReloadAnim, 1.0, 0.0);
    }
}

defaultproperties
{
    HatchClearRange=(Min=-24500,Max=-18200)
    BinocsDrivePos=(X=0,Y=0,Z=0)
    DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_Hetzer_anm.HETZER_MG_INT',TransitionUpAnim="raise",DriverTransitionAnim="hetzer_mg_lower")
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_Hetzer_anm.HETZER_MG_INT',TransitionDownAnim="lower",DriverTransitionAnim="hetzer_mg_raise")
    DriverPositions(2)=(PositionMesh=SkeletalMesh'DH_Hetzer_anm.HETZER_MG_INT')
    GunClass=Class'DH_Vehicles.DH_HetzerMountedMG'
    DrivePos=(X=-1.08303,Y=-13.4031,Z=58)
    DriveAnim="hetzer_mg_idle"
    GunsightCameraBone="GUNSIGHT_CAMERA"
    CameraBone="COM_CAMERA"
    DriverReloadAnim="hetzer_mg_reload"
    GunReloadAnim="reload"
    GunReloadRootBone="YAW"
}

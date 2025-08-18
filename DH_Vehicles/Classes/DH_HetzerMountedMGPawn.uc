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

simulated function bool CanReload()
{
    return DriverPositionIndex == 1 && !IsInState('ViewTransition');
}

defaultproperties
{
    HatchClearRange=(Min=-24500,Max=-18200)
    BinocsDrivePos=(X=0,Y=0,Z=0)
    DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_Hetzer_anm.HETZER_MG_INT',TransitionUpAnim="raise",DriverTransitionAnim="hetzer_mg_lower")
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_Hetzer_anm.HETZER_MG_INT',TransitionDownAnim="lower",DriverTransitionAnim="hetzer_mg_raise")
    DriverPositions(2)=(PositionMesh=SkeletalMesh'DH_Hetzer_anm.HETZER_MG_INT',DriverTransitionAnim="hetzer_mg_binocs")
    GunClass=Class'DH_HetzerMountedMG'
    DrivePos=(X=-1.08303,Y=-13.4031,Z=58)
    DriveAnim="hetzer_mg_idle"
    GunsightCameraBone="GUNSIGHT_CAMERA"
    CameraBone="COM_CAMERA"
}

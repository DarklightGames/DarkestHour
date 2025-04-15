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

defaultproperties
{
    HatchClearRange=(Min=-24500,Max=-18200)
    BinocsDrivePos=(X=0,Y=0,Z=0)
    DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_Hetzer_anm.Hetzer_MG_ext',TransitionUpAnim="raise",DriverTransitionAnim="VT60_com_close")
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_Hetzer_anm.Hetzer_MG_ext',TransitionDownAnim="lower",DriverTransitionAnim="VT60_com_open")
    DriverPositions(2)=(PositionMesh=SkeletalMesh'DH_Hetzer_anm.Hetzer_MG_ext')
    GunClass=Class'DH_Vehicles.DH_HetzerMountedMG'
    DrivePos=(X=0,Y=0,Z=0)
    DriveAnim="VT60_com_idle_open"
    GunsightCameraBone="GUNSIGHT_CAMERA"
    CameraBone="COM_CAMERA"
}

//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_HetzerMountedMGPawn extends DH_StuH42MountedMGPawn;

// Modified to prevent player from unbuttoning if MG is not turned sideways (otherwise it will be blocking hatch, due to hetzer's small size)
simulated function NextWeapon()
{
    if (Gun != none && Abs(Gun.CurrentAim.Yaw) > 10700 && Abs(Gun.CurrentAim.Yaw) < 22700) // to open, MG must be between approx 2 to 4 o'clock, or 8 to 10 o'clock
    {
        super.NextWeapon();
    }
    else if (IsHumanControlled())
    {
        PlayerController(Controller).ReceiveLocalizedMessage(Class'DH_HetzerVehicleMessage', 1); // "MG is blocking the hatch - turn it sideways to open"
    }
}

defaultproperties
{
     BinocsDrivePos=(X=0.000000,Y=0.000000,Z=0.000000)
     DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_Hetzer_anm.Hetzer_MG',TransitionUpAnim="MG_open",DriverTransitionAnim="VT60_com_close")
     DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_Hetzer_anm.Hetzer_MG',TransitionDownAnim="MG_close",DriverTransitionAnim="VT60_com_open")
     DriverPositions(2)=(PositionMesh=SkeletalMesh'DH_Hetzer_anm.Hetzer_MG')
     GunClass=Class'DH_HetzerMountedMG'
     DrivePos=(X=0.000000,Y=0.000000,Z=0.000000)
     DriveAnim="VT60_com_idle_open"
}

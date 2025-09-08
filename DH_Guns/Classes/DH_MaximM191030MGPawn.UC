//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_MaximM191030MGPawn extends DHMountedMGPawn;

defaultproperties
{
    //HandsMesh=SkeletalMesh'DH_Fiat1435_anm.FIAT1435_HANDS'
    GunClass=Class'DH_MaximM191030MG'
    DrivePos=(X=0,Y=0,Z=0)
    DriveRot=(Pitch=0,Yaw=0,Roll=0)
    DriveAnim="cv33_gunner_closed"  // TODO: replace
    DriverPositions(0)=(bExposed=true)
    //AnimationDrivers(0)=(Sequence="fiat1435_gunner_yaw_driver",FrameCount=20,Type=ADT_Yaw,DriverPositionIndexRange=(Min=0,Max=0))
}

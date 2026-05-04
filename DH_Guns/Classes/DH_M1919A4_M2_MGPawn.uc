//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_M1919A4_M2_MGPawn extends DHMountedMGPawn;

defaultproperties
{
    DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_M1919A4_anm.M1919A4_M2_TURRET_INT',ViewFOV=72.5,bExposed=true)
    GunClass=Class'DH_M1919A4_M2_MG'
    CameraBone="SIGHT_CAMERA"
    ReloadCameraBone="RELOAD_CAMERA"
}

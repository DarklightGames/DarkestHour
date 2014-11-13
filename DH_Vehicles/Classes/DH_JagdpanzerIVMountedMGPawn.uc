//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_JagdpanzerIVMountedMGPawn extends DH_ROMountedTankMGPawn;

defaultproperties
{
     OverlayCenterSize=0.500000
     MGOverlay=Texture'DH_VehicleOptics_tex.Common.MG_sight'
     WeaponFov=72.000000
     GunClass=Class'DH_Vehicles.DH_JagdpanzerIVMountedMG'
     bHasAltFire=false
     CameraBone="mg_yaw"
     bDrawDriverInTP=false
     DrivePos=(Z=130.000000)
     EntryRadius=130.000000
     FPCamViewOffset=(Z=3.000000)
     TPCamDistance=300.000000
     TPCamLookat=(X=-25.000000,Z=0.000000)
     TPCamWorldOffset=(Z=120.000000)
     VehiclePositionString="in a Jagdpanzer IV Mounted MG"
     VehicleNameString="Jagdpanzer IV Mounted MG"
     PitchUpLimit=2730
     PitchDownLimit=64000
}

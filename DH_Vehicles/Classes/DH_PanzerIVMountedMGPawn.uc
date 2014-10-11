//===================================================================
// PanzerIVMountedMGPawn
//
// Copyright (C) 2004 John "Ramm-Jaeger"  Gibson
//
// Panzer 4 tank mounted machine gun pawn
//===================================================================
class DH_PanzerIVMountedMGPawn extends DH_ROMountedTankMGPawn;

defaultproperties
{
     OverlayCenterSize=0.700000
     MGOverlay=Texture'DH_VehicleOptics_tex.German.KZF2_MGSight'
     WeaponFov=41.000000
     GunClass=Class'DH_Vehicles.DH_PanzerIVMountedMG'
     bHasAltFire=false
     CameraBone="mg_yaw"
     bDrawDriverInTP=false
     DrivePos=(Z=130.000000)
     EntryRadius=130.000000
     FPCamViewOffset=(X=10.000000,Y=-5.000000,Z=1.000000)
     TPCamDistance=300.000000
     TPCamLookat=(X=-25.000000,Z=0.000000)
     TPCamWorldOffset=(Z=120.000000)
     VehiclePositionString="in a Panzer IV Mounted MG"
     VehicleNameString="Panzer IV Mounted MG"
     PitchUpLimit=3640
     PitchDownLimit=63715
}

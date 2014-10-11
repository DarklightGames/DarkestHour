//===================================================================
// DH_Tiger2BMountedMGPawn
//
// All original content - Copyright (C) 2005 Tripwire Interactive LLC
// Coding and Sound Effects - (c) 2007-2008 Eric Parris (Shurek)
// Animations,Models, and Textures - (c) 2007-2008 Paul Pepera (Capt.Obvious)
//
// King Tiger Hull Mounted MG34
//===================================================================
class DH_Tiger2BMountedMGPawn extends DH_ROMountedTankMGPawn;

defaultproperties
{
     OverlayCenterSize=0.700000
     MGOverlay=Texture'DH_VehicleOptics_tex.German.KZF2_MGSight'
     WeaponFov=41.000000
     GunClass=Class'DH_Vehicles.DH_Tiger2BMountedMG'
     bHasAltFire=false
     CameraBone="mg_yaw"
     bDrawDriverInTP=false
     DrivePos=(Z=130.000000)
     FPCamViewOffset=(X=10.000000,Y=-5.000000,Z=1.000000)
     TPCamDistance=300.000000
     TPCamLookat=(X=-25.000000,Z=0.000000)
     TPCamWorldOffset=(Z=120.000000)
     VehiclePositionString="in a Panzer VI Ausf.B Mounted MG"
     VehicleNameString="Panzer VI Ausf.B Mounted MG"
     PitchUpLimit=3000
     PitchDownLimit=63000
}

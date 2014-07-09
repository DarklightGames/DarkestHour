//===================================================================
// PanzerIIIMountedMGPawn
//
// Copyright (C) 2005 John "Ramm-Jaeger"  Gibson
//
// PanzerIII tank mounted machine gun pawn
//===================================================================
class DH_PanzerIIIMountedMGPawn extends DH_JagdpantherMountedMGPawn;

defaultproperties
{
     GunClass=Class'DH_Vehicles.DH_PanzerIIIMountedMG'
     ExitPositions(0)=(X=100.000000,Y=120.000000,Z=100.000000)
     ExitPositions(1)=(X=100.000000,Y=-120.000000,Z=100.000000)
     VehiclePositionString="in a Panzer III Mounted MG"
     VehicleNameString="Panzer III Mounted MG"
     PitchUpLimit=3640
     PitchDownLimit=63715
}

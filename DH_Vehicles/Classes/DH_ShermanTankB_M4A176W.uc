//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_ShermanTankB_M4A176W extends DH_ShermanTankA_M4A176W;

defaultproperties
{
     PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_ShermanCannonPawnB_M4A176W')
     DestroyedVehicleMesh=StaticMesh'DH_allies_vehicles_stc2.ShermanM4A1W.ShermanM4A1W_DestB'
     DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_ShermanM4A176W_anm.shermanM4A1w_body_intB')
     DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_ShermanM4A176W_anm.shermanM4A1w_body_intB')
     DriverPositions(2)=(PositionMesh=SkeletalMesh'DH_ShermanM4A176W_anm.shermanM4A1w_body_intB')
     Mesh=SkeletalMesh'DH_ShermanM4A176W_anm.shermanM4A1w_body_extB'
}

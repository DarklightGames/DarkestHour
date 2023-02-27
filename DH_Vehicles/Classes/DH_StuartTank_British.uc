//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_StuartTank_British extends DH_StuartTank;

defaultproperties
{
    VehicleNameString="Stuart Mk.VI"
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_StuartCannonPawn_British')
    Mesh=SkeletalMesh'DH_Stuart_anm.Stuart_body_extB'
    Skins(0)=Texture'DH_VehiclesUK_tex.ext_vehicles.Brit_M5_body_ext'
    Skins(4)=Texture'DH_VehiclesUK_tex.ext_vehicles.Brit_M5_armor'
    DestroyedVehicleMesh=StaticMesh'DH_allies_vehicles_stc.M5_Stuart.M5_Stuart_dest_Brit'
    DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_Stuart_anm.Stuart_body_intB')
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_Stuart_anm.Stuart_body_intB')
    DriverPositions(2)=(PositionMesh=SkeletalMesh'DH_Stuart_anm.Stuart_body_intB')
    SpawnOverlay(0)=Material'DH_InterfaceArt_tex.Vehicles.m5_stuart_uk'
}

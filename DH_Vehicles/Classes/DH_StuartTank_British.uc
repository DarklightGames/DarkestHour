//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_StuartTank_British extends DH_StuartTank;

#exec OBJ LOAD FILE=..\Textures\DH_VehiclesUK_tex.utx

defaultproperties
{
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_StuartCannonPawn_British')
    DriverPositions(0)=(PositionMesh=SkeletalMesh'DH_Stuart_anm.Stuart_body_intB')
    DriverPositions(1)=(PositionMesh=SkeletalMesh'DH_Stuart_anm.Stuart_body_intB')
    DriverPositions(2)=(PositionMesh=SkeletalMesh'DH_Stuart_anm.Stuart_body_intB')
    VehicleNameString="M5A1 Stuart"
    Mesh=SkeletalMesh'DH_Stuart_anm.Stuart_body_extB'
    Skins(0)=texture'DH_VehiclesUK_tex.ext_vehicles.Brit_M5_body_ext'
    Skins(1)=texture'DH_VehiclesUK_tex.ext_vehicles.Brit_M5_armor'
    Skins(4)=texture'DH_VehiclesUS_tex.int_vehicles.M5_body_int'
}

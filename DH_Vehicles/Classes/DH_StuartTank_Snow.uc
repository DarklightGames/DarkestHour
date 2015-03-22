//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_StuartTank_Snow extends DH_StuartTank;

#exec OBJ LOAD FILE=..\Textures\DH_VehiclesUS_tex2.utx

defaultproperties
{
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_StuartCannonPawn_Snow')
    Skins(0)=texture'DH_VehiclesUS_tex2.ext_vehicles.M5_body_snow'
    Skins(2)=texture'DH_VehiclesUS_tex2.Treads.M5_treadsnow'
    Skins(3)=texture'DH_VehiclesUS_tex2.Treads.M5_treadsnow'
}

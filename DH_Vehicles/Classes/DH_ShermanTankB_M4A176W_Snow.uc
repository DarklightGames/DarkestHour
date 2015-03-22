//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_ShermanTankB_M4A176W_Snow extends DH_ShermanTankB_M4A176W;

#exec OBJ LOAD FILE=..\Textures\DH_VehiclesUS_tex2.utx

defaultproperties
{
    PassengerWeapons(0)=(WeaponPawnClass=class'DH_Vehicles.DH_ShermanCannonPawnB_M4A176W_Snow')
    Skins(0)=texture'DH_VehiclesUS_tex2.ext_vehicles.Sherman_body_snow'
    Skins(1)=texture'DH_VehiclesUS_tex2.ext_vehicles.Sherman76w_turret_Snow'
}

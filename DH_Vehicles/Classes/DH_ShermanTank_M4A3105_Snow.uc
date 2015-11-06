//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_ShermanTank_M4A3105_Snow extends DH_ShermanTank_M4A3105;

#exec OBJ LOAD FILE=..\Textures\DH_VehiclesUS_tex2.utx

defaultproperties
{
    Skins(0)=texture'DH_VehiclesUS_tex2.ext_vehicles.ShermanM4A3_ext_snow'
    Skins(1)=texture'DH_VehiclesUS_tex2.ext_vehicles.ShermanM4A3E2_wheels_snow'
    CannonSkins(0)=texture'DH_VehiclesUS_tex3.Dest_vehicles.Sherman_105_ext_dest_snow' // TODO: make whitewash texture for 105mm turret - this is using a blackened destroyed texture !
}

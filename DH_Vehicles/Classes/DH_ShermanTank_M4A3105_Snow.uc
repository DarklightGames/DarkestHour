//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DH_ShermanTank_M4A3105_Snow extends DH_ShermanTank_M4A3105;

#exec OBJ LOAD FILE=..\Textures\DH_VehiclesUS_tex2.utx

defaultproperties
{
    Skins(0)=texture'DH_VehiclesUS_tex2.ext_vehicles.ShermanM4A3_ext_snow'
    Skins(1)=texture'DH_VehiclesUS_tex2.ext_vehicles.ShermanM4A3E2_wheels_snow'
    Skins(4)=texture'DH_VehiclesUS_tex2.Treads.Sherman_treadsnow'
    Skins(5)=texture'DH_VehiclesUS_tex2.Treads.Sherman_treadsnow'
    CannonSkins(0)=texture'DH_VehiclesUS_tex2.Destroyed.Sherman_105_ext_snow_dest' // TODO: make whitewash texture for 105mm turret - this is using an old blackened destroyed texture!
    DestroyedVehicleMesh=StaticMesh'DH_allies_vehicles_stc3.ShermanM4A3.M4A3_105dest_snow'
}

//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_ShermanTank_M4A376W_Snow extends DH_ShermanTank_M4A376W;

#exec OBJ LOAD FILE=..\Textures\DH_VehiclesUS_tex2.utx

defaultproperties
{
    Skins(0)=texture'DH_VehiclesUS_tex2.ext_vehicles.ShermanM4A3_ext_snow'
    Skins(1)=texture'DH_VehiclesUS_tex2.ext_vehicles.ShermanM4A3E2_wheels_snow'
    Skins(4)=texture'DH_VehiclesUS_tex2.Treads.Sherman_treadsnow'
    Skins(5)=texture'DH_VehiclesUS_tex2.Treads.Sherman_treadsnow'

    // TODO: make whitewash texture for 76mm turret - this uses a snow-topped texture, which doesn't match when used on the M4A3 whitewashed hull
    CannonSkins(0)=texture'DH_VehiclesUS_tex2.ext_vehicles.Sherman76w_turret_Snow'
    CannonSkins(1)=texture'DH_VehiclesUS_tex2.ext_vehicles.Sherman_body_snow'
}

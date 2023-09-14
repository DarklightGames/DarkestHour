//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_PanzerIVHCannon extends DH_PanzerIVGLateCannon;

defaultproperties
{
    Mesh=SkeletalMesh'DH_PanzerIV_anm.Panzer4H_turret_ext'
    Skins(0)=Texture'DH_VehiclesGE_tex3.ext_vehicles.Panzer4J_body_camo1'
    Skins(1)=Texture'DH_VehiclesGE_tex.ext_vehicles.PanzerIV_armor_camo1'
    Skins(2)=Texture'axis_vehicles_tex.int_vehicles.panzer3_int'
    Skins(3)=Texture'DH_VehiclesGE_tex2.ext_vehicles.gear_Stug'
    HighDetailOverlay=Shader'axis_vehicles_tex.int_vehicles.panzer3_int_s'

    WeaponFireOffset=1.0
    AltFireOffset=(X=-200.0,Y=20.0,Z=0.0)
}

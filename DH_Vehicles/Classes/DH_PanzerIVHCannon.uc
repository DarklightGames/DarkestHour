//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
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

    // Cannon ammo
    TertiaryProjectileClass=class'DH_Vehicles.DH_PanzerIVCannonShellHEAT'

    nProjectileDescriptions(2)="Gr.38 Hl/C" //PzIVH variant began production in June 1943, a bit before Hl/C seems to have been introduced, but is generally only used on our 1944 maps.

    WeaponFireOffset=1.0
    AltFireOffset=(X=-200.0,Y=20.0,Z=0.0)
}

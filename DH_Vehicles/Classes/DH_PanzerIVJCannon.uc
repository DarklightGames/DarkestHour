//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_PanzerIVJCannon extends DH_PanzerIVGLateCannon;

defaultproperties
{
    Mesh=SkeletalMesh'DH_PanzerIV_anm.panzer4J_turret_ext'
    Skins(0)=Texture'DH_VehiclesGE_tex3.panzer4J_body_ext'
    Skins(1)=Texture'DH_VehiclesGE_tex3.Panzer4J_armor_ext'
    Skins(2)=Texture'axis_vehicles_tex.panzer3_int'
    HighDetailOverlay=Shader'axis_vehicles_tex.panzer3_int_s'

    InitialPrimaryAmmo=44
    MaxPrimaryAmmo=56
    WeaponFireOffset=0.0
    AltFireOffset=(X=-200.0,Y=20.0,Z=0.0)

    SmokeLauncherClass=Class'DH_Nahverteidigungswaffe'
    SmokeLauncherFireOffset(0)=(X=18.5,Y=34.5,Z=39.0)
}

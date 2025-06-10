//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_Stug3GCannon_Late extends DH_Stug3GCannon;

defaultproperties
{
    Mesh=SkeletalMesh'DH_Stug3G_anm.Stuglate_turret_ext'
    Skins(0)=Texture'DH_VehiclesGE_tex2.ext_vehicles.Stug3g_body_camo2'
    GunMantletArmorFactor=8.0
    GunMantletSlope=45.0
    WeaponFireOffset=10.5
    SmokeLauncherClass=Class'DH_Nahverteidigungswaffe'
    SmokeLauncherFireOffset(0)=(X=-18.0,Y=23.0,Z=30.0)
}

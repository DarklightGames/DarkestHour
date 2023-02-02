//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_Stug3GCannon_Late extends DH_Stug3GCannon;

defaultproperties
{
    Mesh=SkeletalMesh'DH_Stug3G_anm.Stuglate_turret_ext'
    Skins(0)=Texture'DH_VehiclesGE_tex2.ext_vehicles.Stug3g_body_camo2'
    GunMantletArmorFactor=8.0
    GunMantletSlope=45.0
    WeaponFireOffset=10.5
    SmokeLauncherClass=class'DH_Vehicles.DH_Nahverteidigungswaffe'
    SmokeLauncherFireOffset(0)=(X=-18.0,Y=23.0,Z=30.0)
}

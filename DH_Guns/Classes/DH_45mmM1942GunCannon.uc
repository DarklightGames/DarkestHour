//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_45mmM1942GunCannon extends DH_45mmM1937GunCannon;

defaultproperties
{
    Mesh=SkeletalMesh'DH_45mm_anm.45mmM1942_gun'
    PrimaryProjectileClass=class'DH_Guns.DH_45mmM1942GunCannonShell'
    TertiaryProjectileClass=class'DH_Guns.DH_45mmM1942GunCannonShellAPCR'
    WeaponFireOffset=42.9

    nProjectileDescriptions(2)="BR-240P"
    ProjectileDescriptions(2)="APCR"


    InitialTertiaryAmmo=3
    MaxTertiaryAmmo=7
}

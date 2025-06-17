//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_45mmM1942GunCannon extends DH_45mmM1937GunCannon;

defaultproperties
{
    Mesh=SkeletalMesh'DH_Pak36_anm.M42_TURRET_EXT'
    PrimaryProjectileClass=class'DH_45mmM1942GunCannonShell'
    TertiaryProjectileClass=class'DH_45mmM1942GunCannonShellAPCR'
    WeaponFireOffset=42.9
    nProjectileDescriptions(2)="BR-240P"
    ProjectileDescriptions(2)="APCR"
    WeaponFireAttachmentBone="MUZZLE_M42"
    InitialTertiaryAmmo=3
    MaxTertiaryAmmo=7
    CollisionStaticMeshes(2)=(CollisionStaticMesh=StaticMesh'DH_Pak36_stc.m42_barrel_collision',AttachBone="BARREL")
}

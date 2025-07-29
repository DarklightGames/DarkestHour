//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_JacksonCannon_Early extends DH_JacksonCannon;

defaultproperties
{
    // Turret mesh
    Skins(3)=Texture'DH_VehiclesGE_tex2.Alpha' // hides the muzzle brake

    // Cannon ammo
    PrimaryProjectileClass=Class'DH_JacksonCannonShell_Early'
    SecondaryProjectileClass=Class'DH_JacksonCannonShellAP'

    ProjectileDescriptions(1)="AP"

    nProjectileDescriptions(0)="M82 APC"
    nProjectileDescriptions(1)="M77 AP-T"
    nProjectileDescriptions(2)="M71 HE-T"

    InitialPrimaryAmmo=25
    InitialSecondaryAmmo=12
    MaxPrimaryAmmo=25
    MaxSecondaryAmmo=13

    // Weapon fire
    WeaponFireOffset=16.5
}

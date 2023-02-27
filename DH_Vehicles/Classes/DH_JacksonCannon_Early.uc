//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_JacksonCannon_Early extends DH_JacksonCannon;

defaultproperties
{
    // Turret mesh
    Skins(3)=Texture'DH_VehiclesGE_tex2.ext_vehicles.Alpha' // hides the muzzle brake

    // Cannon ammo
    PrimaryProjectileClass=class'DH_Vehicles.DH_JacksonCannonShell_Early'
    SecondaryProjectileClass=class'DH_Vehicles.DH_JacksonCannonShellAP'

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

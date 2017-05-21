//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DH_JacksonCannon_Early extends DH_JacksonCannon;

defaultproperties
{
    Skins(3)=texture'DH_VehiclesGE_tex2.ext_vehicles.Alpha' // hides the muzzle brake
    ProjectileClass=class'DH_Vehicles.DH_JacksonCannonShell_Early'
    PrimaryProjectileClass=class'DH_Vehicles.DH_JacksonCannonShell_Early'
    SecondaryProjectileClass=class'DH_Vehicles.DH_JacksonCannonShellAP'
    ProjectileDescriptions(1)="AP"
    InitialPrimaryAmmo=25
    InitialSecondaryAmmo=13
    WeaponFireOffset=16.5
}

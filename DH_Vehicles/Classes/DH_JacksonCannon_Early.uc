//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_JacksonCannon_Early extends DH_JacksonCannon;

defaultproperties
{
    Mesh=SkeletalMesh'DH_Jackson_anm.jackson_turret_extB'
    ProjectileClass=class'DH_Vehicles.DH_JacksonCannonShell_Early'
    PrimaryProjectileClass=class'DH_Vehicles.DH_JacksonCannonShell_Early'
    SecondaryProjectileClass=class'DH_Vehicles.DH_JacksonCannonShellAP'
    ProjectileDescriptions(1)="AP"
    InitialPrimaryAmmo=25
    InitialSecondaryAmmo=13
    WeaponFireOffset=10.0
}

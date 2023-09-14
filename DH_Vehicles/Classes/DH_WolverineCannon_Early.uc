//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_WolverineCannon_Early extends DH_WolverineCannon;

defaultproperties
{
    SecondaryProjectileClass=class'DH_Vehicles.DH_WolverineCannonShellHE'
    TertiaryProjectileClass=class'DH_Vehicles.DH_WolverineCannonShellSmoke'

    ProjectileDescriptions(1)="HE"
    ProjectileDescriptions(2)="Smoke"

    nProjectileDescriptions(0)="M62 APC"
    nProjectileDescriptions(1)="M42A1 HE-T"
    nProjectileDescriptions(2)="M88 HC"

    InitialPrimaryAmmo=30
    InitialSecondaryAmmo=10
    InitialTertiaryAmmo=4
    MaxPrimaryAmmo=30
    MaxSecondaryAmmo=20
    MaxTertiaryAmmo=4
    SecondarySpread=0.00135
    TertiarySpread=0.0036
}

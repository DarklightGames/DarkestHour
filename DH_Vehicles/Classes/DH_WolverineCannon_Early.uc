//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_WolverineCannon_Early extends DH_WolverineCannon;

defaultproperties
{
    InitialTertiaryAmmo=4
    TertiaryProjectileClass=class'DH_Vehicles.DH_WolverineCannonShellSmoke'
    ProjectileDescriptions(1)="HE"
    ProjectileDescriptions(2)="Smoke"
    InitialPrimaryAmmo=30
    InitialSecondaryAmmo=20
    SecondaryProjectileClass=class'DH_Vehicles.DH_WolverineCannonShellHE'
}

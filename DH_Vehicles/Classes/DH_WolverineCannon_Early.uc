//==============================================================================
// DH_WolverineCannon_Early
//
// Darkest Hour Source - (c) Darkest Hour Team 2010
// Red Orchestra Source - (c) Tripwire Interactive 2006
//
// American M10 "Wolverine" tank destroyer cannon - no HVAP
//==============================================================================
class DH_WolverineCannon_Early extends DH_WolverineCannon;

defaultproperties
{
     InitialTertiaryAmmo=4
     TertiaryProjectileClass=Class'DH_Vehicles.DH_WolverineCannonShellSmoke'
     ProjectileDescriptions(1)="HE"
     ProjectileDescriptions(2)="Smoke"
     InitialPrimaryAmmo=30
     InitialSecondaryAmmo=20
     SecondaryProjectileClass=Class'DH_Vehicles.DH_WolverineCannonShellHE'
}

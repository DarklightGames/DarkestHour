//==============================================================================
// DH_ShermanCannonA_M4A176W_Early
//
// Darkest Hour Source - (c) Darkest Hour Team 2010
// Red Orchestra Source - (c) Tripwire Interactive 2006
//
// American M4A1(76)W (Sherman) tank cannon - no HVAP
//==============================================================================
class DH_ShermanCannonA_M4A176W_Early extends DH_ShermanCannonA_M4A176W;

defaultproperties
{
     InitialTertiaryAmmo=4
     TertiaryProjectileClass=Class'DH_Vehicles.DH_ShermanM4A176WCannonShellSmoke'
     ProjectileDescriptions(1)="HE"
     ProjectileDescriptions(2)="Smoke"
     InitialPrimaryAmmo=42
     InitialSecondaryAmmo=25
     SecondaryProjectileClass=Class'DH_Vehicles.DH_ShermanM4A176WCannonShellHE'
}

//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_ShermanCannonA_M4A176W_Early extends DH_ShermanCannonA_M4A176W;

defaultproperties
{
     InitialTertiaryAmmo=4
     TertiaryProjectileClass=class'DH_Vehicles.DH_ShermanM4A176WCannonShellSmoke'
     ProjectileDescriptions(1)="HE"
     ProjectileDescriptions(2)="Smoke"
     InitialPrimaryAmmo=42
     InitialSecondaryAmmo=25
     SecondaryProjectileClass=class'DH_Vehicles.DH_ShermanM4A176WCannonShellHE'
}

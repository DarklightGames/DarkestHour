//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_ShermanCannonA_76mm_Early extends DH_ShermanCannonA_76mm;

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

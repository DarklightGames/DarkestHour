//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_ShermanCannonA_76mm_Early extends DH_ShermanCannonA_76mm;

defaultproperties
{
    SecondaryProjectileClass=class'DH_Vehicles.DH_ShermanM4A176WCannonShellHE'
    TertiaryProjectileClass=class'DH_Vehicles.DH_ShermanM4A176WCannonShellSmoke'


    ProjectileDescriptions(1)="HE"
    ProjectileDescriptions(2)="Smoke"

    nProjectileDescriptions(1)="M42A1 HE-T"
    nProjectileDescriptions(2)="M88 HC"

    InitialPrimaryAmmo=30
    InitialSecondaryAmmo=12
    InitialTertiaryAmmo=3
    MaxPrimaryAmmo=42
    MaxSecondaryAmmo=25
    MaxTertiaryAmmo=4
    SecondarySpread=0.00135
    TertiarySpread=0.0036
}

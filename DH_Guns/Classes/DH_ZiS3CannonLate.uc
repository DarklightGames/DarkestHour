//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2020
//==============================================================================

class DH_ZiS3CannonLate extends DH_ZiS3Cannon; //added APCR

defaultproperties
{
    TertiaryProjectileClass=class'DH_Guns.DH_ZiS3CannonShellAPCR'
    ProjectileDescriptions(2)="APCR"
	nProjectileDescriptions(2)="BR-350P"

    InitialTertiaryAmmo=2 
    MaxTertiaryAmmo=4

}

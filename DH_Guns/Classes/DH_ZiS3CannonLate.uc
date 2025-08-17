//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================
// Has APCR round.
//==============================================================================


class DH_ZiS3CannonLate extends DH_ZiS3Cannon;

defaultproperties
{
    TertiaryProjectileClass=Class'DH_ZiS3CannonShellAPCR'
    ProjectileDescriptions(2)="APCR"
	nProjectileDescriptions(2)="BR-350P"

    InitialTertiaryAmmo=2
    MaxTertiaryAmmo=4
}

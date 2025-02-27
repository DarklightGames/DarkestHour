//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_USTankerPawn extends DH_AmericanPawn;

defaultproperties
{
    Mesh=SkeletalMesh'DHCharactersUS_anm.US_tanker'
    Skins(1)=Texture'DHUSCharactersTex.743rdTank.US_743Armored_1'

// Same texture declared twice as this role has only one texture variant, necessary due to AmericanPawn inheritance
	BodySkins(0)=Texture'DHUSCharactersTex.743rdTank.US_743Armored_1'
    BodySkins(1)=Texture'DHUSCharactersTex.743rdTank.US_743Armored_1'
}

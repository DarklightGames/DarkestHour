//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_CSAZ_BritcoatSniper extends DHCSSniperRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=Class'DH_CSAZbritcoatPawn',Weight=3.0)
    RolePawns(1)=(PawnClass=Class'DH_CSAZbritcoatSidorPawn',Weight=1.0)
    Headgear(0)=Class'DH_CSAZSidecap'
    Headgear(1)=Class'DH_BritishTommyHelmet'
    Headgear(2)=Class'DH_SovietHelmet'
    SleeveTexture=Texture'DHBritishCharactersTex.Brit_Coat_Sleeves'
    
    HeadgearProbabilities(0)=0.8
    HeadgearProbabilities(1)=0.1
    HeadgearProbabilities(2)=0.1
}

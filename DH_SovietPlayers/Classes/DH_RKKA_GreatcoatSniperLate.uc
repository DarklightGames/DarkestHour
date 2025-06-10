//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_RKKA_GreatcoatSniperLate extends DHSOVSniperRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=Class'DH_SovietGreatcoatBrownSLLatePawn',Weight=1.0)
    RolePawns(1)=(PawnClass=Class'DH_SovietGreatcoatGreySLLatePawn',Weight=1.0)
    RolePawns(2)=(PawnClass=Class'DH_SovietGreatcoatBrownBagLatePawn',Weight=1.0)
    SleeveTexture=Texture'DHSovietCharactersTex.RussianSleeves.DH_RussianCoatSleeves'
    Headgear(0)=Class'DH_SovietFurHat'
    Headgear(1)=Class'DH_SovietSideCap'
    Headgear(2)=Class'DH_SovietHelmet'

    HeadgearProbabilities(0)=0.3
    HeadgearProbabilities(1)=0.3
    HeadgearProbabilities(2)=0.4
}

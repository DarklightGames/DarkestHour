//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_RKKA_GreatcoatRadioOperatorLate extends DHSOVRadioOperatorRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=Class'DH_SovietGreatcoatBrownStrapsLatePawn',Weight=2.0)
    RolePawns(1)=(PawnClass=Class'DH_SovietGreatcoatGreyStrapsLatePawn',Weight=1.0)
    Headgear(0)=Class'DH_SovietFurHat'
    Headgear(1)=Class'DH_SovietSideCap'
    Headgear(2)=Class'DH_SovietHelmet'
    HeadgearProbabilities(0)=0.3
    HeadgearProbabilities(1)=0.3
    HeadgearProbabilities(2)=0.4
    SleeveTexture=Texture'DHSovietCharactersTex.DH_RussianCoatSleeves'
}

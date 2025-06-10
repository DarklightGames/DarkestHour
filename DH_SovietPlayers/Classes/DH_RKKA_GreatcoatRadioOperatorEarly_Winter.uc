//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_RKKA_GreatcoatRadioOperatorEarly_Winter extends DHSOVRadioOperatorRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=Class'DH_SovietGreatcoatBrownStrapsEarlyPawn_Winter',Weight=1.0)
    RolePawns(1)=(PawnClass=Class'DH_SovietGreatcoatGreyStrapsEarlyPawn_Winter',Weight=1.0)
    Headgear(0)=Class'DH_SovietFurHatUnfolded'
    Headgear(1)=Class'DH_SovietHelmet'
    HeadgearProbabilities(0)=0.75
    HeadgearProbabilities(1)=0.25
    HandType=Hand_Gloved
    SleeveTexture=Texture'DHSovietCharactersTex.RussianSleeves.DH_RussianCoatSleeves'
}

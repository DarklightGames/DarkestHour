//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_RKKA_GreatcoatAntiTankEarly_Winter extends DHSOVAntiTankRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=Class'DH_SovietGreatcoatBrownBagEarlyPawn_Winter',Weight=2.0)
    RolePawns(1)=(PawnClass=Class'DH_SovietGreatcoatGreyEarlyPawn_Winter',Weight=1.0)
    Headgear(0)=Class'DH_SovietHelmet'
    SleeveTexture=Texture'DHSovietCharactersTex.DH_RussianCoatSleeves'
    GivenItems(0)="none"
    HeadgearProbabilities(0)=1.0
    HandType=Hand_Gloved
}

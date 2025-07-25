//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_RKKA_GreatcoatFireteamLeaderEarly_Winter extends DHSOVCorporalRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=Class'DH_SovietGreatcoatBrownSLEarlyPawn_Winter',Weight=1.0)
    RolePawns(1)=(PawnClass=Class'DH_SovietGreatcoatGreySLEarlyPawn_Winter',Weight=1.0)
    RolePawns(2)=(PawnClass=Class'DH_SovietGreatcoatGreyBagEarlyPawn_Winter',Weight=1.0)
    SleeveTexture=Texture'DHSovietCharactersTex.DH_RussianCoatSleeves'
    Headgear(0)=Class'DH_SovietFurHat'
    Headgear(1)=Class'DH_SovietFurHatUnfolded'
    Headgear(2)=Class'DH_SovietHelmet'
    HeadgearProbabilities(0)=0.25
    HeadgearProbabilities(1)=0.5
    HeadgearProbabilities(2)=0.25
    HandType=Hand_Gloved
}

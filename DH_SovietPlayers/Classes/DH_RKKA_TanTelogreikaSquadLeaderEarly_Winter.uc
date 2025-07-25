//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_RKKA_TanTelogreikaSquadLeaderEarly_Winter extends DHSOVSergeantRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=Class'DH_SovietTanTeloSLEarlyPawn_Winter',Weight=1.0)
    SleeveTexture=Texture'DHSovietCharactersTex.DH_rus_sleeves_tan'
    Headgear(0)=Class'DH_SovietFurHatUnfolded'
    Headgear(1)=Class'DH_SovietFurHat'
    HeadgearProbabilities(0)=0.8
    HeadgearProbabilities(1)=0.2
    HandType=Hand_Gloved
}

//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_RKKA_GreatcoatSquadLeaderEarly_Winter extends DH_RKKA_GreatcoatSquadLeaderEarly;

defaultproperties
{
    RolePawns(0)=(PawnClass=class'DH_SovietPlayers.DH_SovietGreatcoatBrownSLEarlyPawn_Winter',Weight=1.0)
    RolePawns(1)=(PawnClass=class'DH_SovietPlayers.DH_SovietGreatcoatGreySLEarlyPawn_Winter',Weight=1.0)
    SleeveTexture=Texture'DHSovietCharactersTex.RussianSleeves.DH_RussianCoatSleeves'
    Headgear(0)=class'DH_SovietPlayers.DH_SovietFurHat'
    Headgear(1)=class'DH_SovietPlayers.DH_SovietFurHatUnfolded'
    Headgear(2)=class'DH_SovietPlayers.DH_SovietHelmet'
    HeadgearProbabilities(0)=0.25
    HeadgearProbabilities(1)=0.5
    HeadgearProbabilities(2)=0.25
    HandType=Hand_Gloved
}

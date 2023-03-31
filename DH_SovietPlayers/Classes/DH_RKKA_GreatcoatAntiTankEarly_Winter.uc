//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_RKKA_GreatcoatAntiTankEarly_Winter extends DHSOVAntiTankRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=class'DH_SovietPlayers.DH_SovietGreatcoatBrownBagEarlyPawn_Winter',Weight=2.0)
    RolePawns(1)=(PawnClass=class'DH_SovietPlayers.DH_SovietGreatcoatGreyEarlyPawn_Winter',Weight=1.0)
    Headgear(0)=class'DH_SovietPlayers.DH_SovietHelmet'
    SleeveTexture=Texture'DHSovietCharactersTex.RussianSleeves.DH_RussianCoatSleeves'
    GivenItems(0)="none"
    HeadgearProbabilities(0)=1.0
    HandType=Hand_Gloved
}

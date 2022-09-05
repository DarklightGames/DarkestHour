//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DH_RKKA_GreatcoatRadioOperatorLate_Winter extends DHSOVRadioOperatorRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=class'DH_SovietPlayers.DH_SovietGreatcoatBrownStrapsLatePawn_Winter',Weight=1.0)
    RolePawns(1)=(PawnClass=class'DH_SovietPlayers.DH_SovietGreatcoatGreyStrapsLatePawn_Winter',Weight=1.0)
    Headgear(0)=class'DH_SovietPlayers.DH_SovietFurHatUnfolded'
    Headgear(1)=class'DH_SovietPlayers.DH_SovietHelmet'
    HeadgearProbabilities(0)=0.75
    HeadgearProbabilities(1)=0.25
    HandType=Hand_Gloved
}

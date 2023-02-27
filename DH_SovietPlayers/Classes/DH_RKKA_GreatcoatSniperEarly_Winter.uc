//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_RKKA_GreatcoatSniperEarly_Winter extends DHSOVSniperRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=class'DH_SovietPlayers.DH_SovietGreatcoatBrownEarlyPawn_Winter',Weight=1.0)
    RolePawns(1)=(PawnClass=class'DH_SovietPlayers.DH_SovietGreatcoatGreyBagEarlyPawn_Winter',Weight=1.0)
    RolePawns(2)=(PawnClass=class'DH_SovietPlayers.DH_SovietGreatcoatGreySLEarlyPawn_Winter',Weight=1.0)
    SleeveTexture=Texture'DHSovietCharactersTex.RussianSleeves.DH_RussianCoatSleeves'
    Headgear(0)=class'DH_SovietPlayers.DH_SovietFurHat'
    Headgear(1)=class'DH_SovietPlayers.DH_SovietFurHatUnfolded'
    Headgear(2)=class'DH_SovietPlayers.DH_SovietHelmet'
    HeadgearProbabilities(0)=0.25
    HeadgearProbabilities(1)=0.5
    HeadgearProbabilities(2)=0.25
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_MN9130ScopedPEWeapon',AssociatedAttachment=class'ROInventory.ROMN9130AmmoPouch')
    PrimaryWeapons(1)=(Item=class'DH_Weapons.DH_SVT40ScopedWeapon',AssociatedAttachment=class'ROInventory.SVT40AmmoPouch')
    HandType=Hand_Gloved
}

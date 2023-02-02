//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_RKKA_GreatcoatRiflemanLate_Winter extends DH_RKKA_GreatcoatRiflemanEarly;

defaultproperties
{
    RolePawns(0)=(PawnClass=class'DH_SovietPlayers.DH_SovietGreatcoatBrownLatePawn_Winter',Weight=1.0)
    RolePawns(1)=(PawnClass=class'DH_SovietPlayers.DH_SovietGreatcoatGreyBagLatePawn_Winter',Weight=1.0)
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_MN9130Weapon',AssociatedAttachment=class'ROInventory.ROMN9130AmmoPouch')
    PrimaryWeapons(1)=(Item=class'DH_Weapons.DH_M38Weapon',AssociatedAttachment=class'ROInventory.ROMN9130AmmoPouch')
    Headgear(0)=class'DH_SovietPlayers.DH_SovietFurHatUnfolded'
    Headgear(1)=class'DH_SovietPlayers.DH_SovietHelmet'
    HeadgearProbabilities(0)=0.75
    HeadgearProbabilities(1)=0.25
    HandType=Hand_Gloved
}

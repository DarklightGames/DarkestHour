//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DH_RKKA_GreatcoatRiflemanLate extends DH_RKKA_GreatcoatRiflemanEarly;

defaultproperties
{
    RolePawns(0)=(PawnClass=class'DH_SovietPlayers.DH_SovietGreatcoatBrownLatePawn',Weight=2.0)
    RolePawns(1)=(PawnClass=class'DH_SovietPlayers.DH_SovietGreatcoatGreyLatePawn',Weight=1.0)
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_MN9130Weapon',AssociatedAttachment=class'ROInventory.ROMN9130AmmoPouch')
    PrimaryWeapons(1)=(Item=class'DH_Weapons.DH_M38Weapon',AssociatedAttachment=class'ROInventory.ROMN9130AmmoPouch')

    Headgear(0)=class'DH_SovietPlayers.DH_SovietFurHat'
    Headgear(1)=class'DH_SovietPlayers.DH_SovietSideCap'
    Headgear(2)=class'DH_SovietPlayers.DH_SovietHelmet'
    HeadgearProbabilities(0)=0.3
    HeadgearProbabilities(1)=0.3
    HeadgearProbabilities(2)=0.4
}

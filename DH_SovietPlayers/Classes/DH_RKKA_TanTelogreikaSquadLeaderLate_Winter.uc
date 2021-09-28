//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2021
//==============================================================================

class DH_RKKA_TanTelogreikaSquadLeaderLate_Winter extends DH_RKKA_TanTelogreikaSquadLeaderEarly;

defaultproperties
{
    RolePawns(0)=(PawnClass=class'DH_SovietPlayers.DH_SovietTanTeloSLLatePawn_Winter',Weight=1.0)

    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_PPSH41_stickWeapon',AssociatedAttachment=class'ROInventory.ROPPSh41AmmoPouch')
    PrimaryWeapons(1)=(Item=class'DH_Weapons.DH_SVT40Weapon',AssociatedAttachment=class'ROInventory.ROMN9130AmmoPouch')
    PrimaryWeapons(2)=(Item=class'DH_Weapons.DH_PPS43Weapon',AssociatedAttachment=class'ROInventory.ROPPS43AmmoPouch')

    Headgear(0)=class'DH_SovietPlayers.DH_SovietFurHatUnfolded'
    Headgear(1)=class'DH_SovietPlayers.DH_SovietFurHat'

    HeadgearProbabilities(0)=0.8
    HeadgearProbabilities(1)=0.2
    
    HandType=Hand_Gloved
    GlovedHandTexture=Texture'DHSovietCharactersTex.soviet_gear.hands_sovgloves'
    BareHandTexture=Texture'DHSovietCharactersTex.soviet_gear.hands_sovgloves'
    CustomHandTexture=Texture'DHSovietCharactersTex.soviet_gear.hands_sovgloves'
}

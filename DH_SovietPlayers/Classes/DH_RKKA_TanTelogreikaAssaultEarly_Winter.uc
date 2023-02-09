//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_RKKA_TanTelogreikaAssaultEarly_Winter extends DHSOVAssaultRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=class'DH_SovietPlayers.DH_SovietTanTeloEarlyPawn_Winter',Weight=1.0)
    Headgear(0)=class'DH_SovietPlayers.DH_SovietHelmet'
    HeadgearProbabilities(0)=1.0
    SleeveTexture=Texture'DHSovietCharactersTex.RussianSleeves.DH_rus_sleeves_tan'
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_PPD40Weapon',AssociatedAttachment=class'ROInventory.ROPPSh41AmmoPouch')
    PrimaryWeapons(1)=(Item=class'DH_Weapons.DH_PPSH41Weapon',AssociatedAttachment=class'ROInventory.ROPPSh41AmmoPouch')
    HandType=Hand_Gloved
}

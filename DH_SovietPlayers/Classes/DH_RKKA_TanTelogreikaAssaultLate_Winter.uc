//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_RKKA_TanTelogreikaAssaultLate_Winter extends DH_RKKA_TanTelogreikaAssaultEarly;

defaultproperties
{
    RolePawns(0)=(PawnClass=class'DH_SovietPlayers.DH_SovietTanTeloLatePawn_Winter',Weight=1.0)
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_PPSH41Weapon',AssociatedAttachment=class'ROInventory.ROPPSh41AmmoPouch')
    HandType=Hand_Gloved
    Headgear(0)=class'DH_SovietPlayers.DH_SovietHelmet'
    HeadgearProbabilities(0)=1.0
}

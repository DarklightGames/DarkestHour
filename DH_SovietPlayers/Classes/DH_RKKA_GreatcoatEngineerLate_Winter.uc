//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_RKKA_GreatcoatEngineerLate_Winter extends DH_RKKA_GreatcoatEngineerEarly;

defaultproperties
{
    RolePawns(0)=(PawnClass=class'DH_SovietPlayers.DH_SovietGreatcoatBrownBagLatePawn_Winter',Weight=1.0)
    RolePawns(1)=(PawnClass=class'DH_SovietPlayers.DH_SovietGreatcoatGreyLatePawn_Winter',Weight=1.0)
    Grenades(0)=(Item=class'DH_Weapons.DH_RPG43GrenadeWeapon')
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_M38Weapon',AssociatedAttachment=class'ROInventory.ROMN9130AmmoPouch')
    Headgear(0)=class'DH_SovietPlayers.DH_SovietHelmet'
    HeadgearProbabilities(0)=1.0
    HandType=Hand_Gloved
}

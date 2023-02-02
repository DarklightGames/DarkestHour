//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_RKKA_Leaf1944EngineerLate extends DH_RKKA_Leaf1942EngineerLate;

defaultproperties
{
    RolePawns(0)=(PawnClass=class'DH_SovietPlayers.DH_SovietLeaf1944Pawn',Weight=1.0)
    SleeveTexture=Texture'DHSovietCharactersTex.RussianSleeves.Leaf1944Sleeves'
    Grenades(0)=(Item=class'DH_Weapons.DH_RPG43GrenadeWeapon')
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_M38Weapon',AssociatedAttachment=class'ROInventory.ROMN9130AmmoPouch')
    PrimaryWeapons(1)=(Item=class'DH_Weapons.DH_M38Weapon',AssociatedAttachment=class'ROInventory.ROMN9130AmmoPouch')
}

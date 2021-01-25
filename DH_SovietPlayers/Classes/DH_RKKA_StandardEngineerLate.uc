//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2021
//==============================================================================

class DH_RKKA_StandardEngineerLate extends DH_RKKA_StandardEngineerEarly;

defaultproperties
{
    RolePawns(0)=(PawnClass=class'DH_SovietPlayers.DH_SovietTunicLatePawn',Weight=1.0)

    Grenades(0)=(Item=class'DH_Weapons.DH_RPG43GrenadeWeapon')
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_M38Weapon',AssociatedAttachment=class'ROInventory.ROMN9130AmmoPouch')
    PrimaryWeapons(1)=(Item=class'DH_Weapons.DH_M38Weapon',AssociatedAttachment=class'ROInventory.ROMN9130AmmoPouch')
}

//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_ROSU_RKK_StandardEngineerLate extends DH_ROSU_RKK_StandardEngineer;

defaultproperties
{
    Grenades(0)=(Item=class'DH_ROWeapons.DH_RPG43GrenadeWeapon',Amount=3)
    PrimaryWeapons(0)=(Item=class'DH_ROWeapons.DH_M44Weapon',Amount=15,AssociatedAttachment=Class'ROInventory.ROMN9130AmmoPouch')
    PrimaryWeapons(1)=(Item=class'DH_ROWeapons.DH_M38Weapon',Amount=15,AssociatedAttachment=Class'ROInventory.ROMN9130AmmoPouch')
}

//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_LWP_StandardSniperLate extends DHPOLSniperRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=class'DH_SovietPlayers.DH_LWPTunicNocoatLatePawn',Weight=3.0)

    Headgear(0)=class'DH_SovietPlayers.DH_LWPcap'

    SleeveTexture=Texture'DHSovietCharactersTex.RussianSleeves.DH_rus_sleeves'

    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_MN9130ScopedWeapon',AssociatedAttachment=class'ROInventory.ROMN9130AmmoPouch')
    PrimaryWeapons(1)=(Item=class'DH_Weapons.DH_SVT40Weapon',AssociatedAttachment=class'ROInventory.SVT40AmmoPouch')
    PrimaryWeapons(2)=(Item=class'DH_Weapons.DH_G43Weapon',AssociatedAttachment=class'ROInventory.SVT40AmmoPouch')
}

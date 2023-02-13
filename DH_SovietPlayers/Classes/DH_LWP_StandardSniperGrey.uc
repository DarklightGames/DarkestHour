//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DH_LWP_StandardSniperGrey extends DHPOLSniperRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=class'DH_SovietPlayers.DH_LWPTunicSLGreyPawn',Weight=2.0)
    RolePawns(1)=(PawnClass=class'DH_SovietPlayers.DH_LWPTunicMixBGreyPawn',Weight=1.0)
    Headgear(0)=class'DH_SovietPlayers.DH_LWPcap'

    SleeveTexture=Texture'DHSovietCharactersTex.RussianSleeves.LWP_grey_sleeves'

    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_MN9130ScopedWeapon',AssociatedAttachment=class'ROInventory.ROMN9130AmmoPouch')
    PrimaryWeapons(1)=(Item=class'DH_Weapons.DH_SVT40Weapon',AssociatedAttachment=class'ROInventory.SVT40AmmoPouch')
    PrimaryWeapons(2)=(Item=class'DH_Weapons.DH_G43Weapon',AssociatedAttachment=class'ROInventory.SVT40AmmoPouch')
}

//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2021
//==============================================================================

class DH_LWP_StandardRiflemanGrey extends DHPOLRiflemanRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=class'DH_SovietPlayers.DH_LWPTunicBackpackGreyPawn',Weight=2.0)
    RolePawns(1)=(PawnClass=class'DH_SovietPlayers.DH_LWPTunicGreyPawn',Weight=1.0)
    Headgear(0)=class'DH_SovietPlayers.DH_LWPcap'
    Headgear(1)=class'DH_SovietPlayers.DH_LWPHelmet'
    HeadgearProbabilities(0)=0.5
    HeadgearProbabilities(1)=0.5

    SleeveTexture=Texture'DHSovietCharactersTex.RussianSleeves.LWP_grey_sleeves'

    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_MN9130Weapon',AssociatedAttachment=class'ROInventory.ROMN9130AmmoPouch')
    PrimaryWeapons(1)=(Item=class'DH_Weapons.DH_m44Weapon',AssociatedAttachment=class'ROInventory.SVT40AmmoPouch')
    PrimaryWeapons(2)=(Item=class'DH_Weapons.DH_kar98Weapon',AssociatedAttachment=class'ROInventory.SVT40AmmoPouch')
}

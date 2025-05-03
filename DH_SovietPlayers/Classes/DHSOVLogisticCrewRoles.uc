//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHSOVLogisticCrewRoles extends DHAlliedLogisticCrewRoles
    abstract;

defaultproperties
{
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_M38Weapon',AssociatedAttachment=class'ROInventory.ROMN9130AmmoPouch')
    Grenades(0)=(Item=class'DH_Weapons.DH_F1GrenadeWeapon')
    GivenItems(0)="DH_Equipment.DHShovelItem_Russian"
    VoiceType="DH_SovietPlayers.DHSovietVoice"
    AltVoiceType="DH_SovietPlayers.DHSovietVoice"
    SleeveTexture=Texture'DHSovietCharactersTex.RussianSleeves.DH_rus_sleeves'
    GlovedHandTexture=Texture'DHSovietCharactersTex.soviet_gear.hands_sovgloves'

}

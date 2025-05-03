//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHCSLogisticCrewRoles extends DHAlliedLogisticCrewRoles
    abstract;

defaultproperties
{
    AltName="Zenista"
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_SVT40Weapon',AssociatedAttachment=class'ROInventory.SVT40AmmoPouch') 
    Grenades(0)=(Item=class'DH_Weapons.DH_F1GrenadeWeapon')
    GivenItems(1)="DH_Equipment.DHWireCuttersItem"
    VoiceType="DH_SovietPlayers.DHCzechVoice"
    AltVoiceType="DH_SovietPlayers.DHCzechVoice"
    SleeveTexture=Texture'DHSovietCharactersTex.RussianSleeves.DH_rus_sleeves'
    GlovedHandTexture=Texture'DHBritishCharactersTex.Winter.hands_BRITgloves'
}

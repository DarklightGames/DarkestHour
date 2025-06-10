//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHCSEngineerRoles extends DHAlliedEngineerRoles
    abstract;

defaultproperties
{
    AltName="Zenista"
    PrimaryWeapons(0)=(Item=Class'DH_SVT40Weapon',AssociatedAttachment=Class'ROInventory.SVT40AmmoPouch')
    Grenades(0)=(Item=Class'DH_F1GrenadeWeapon')
    Grenades(1)=(Item=Class'DH_RDG1SmokeGrenadeWeapon')
    GivenItems(0)="DH_Weapons.DH_SatchelCharge10lb10sWeapon"  //to do: RPG-40
    GivenItems(1)="DH_Equipment.DHWireCuttersItem"
    VoiceType="DH_SovietPlayers.DHCzechVoice"
    AltVoiceType="DH_SovietPlayers.DHCzechVoice"
    SleeveTexture=Texture'DHSovietCharactersTex.RussianSleeves.DH_rus_sleeves'
    GlovedHandTexture=Texture'DHBritishCharactersTex.Winter.hands_BRITgloves'
}

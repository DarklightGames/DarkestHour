//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHCSSergeantRoles extends DHAlliedSergeantRoles
    abstract;

defaultproperties
{
    AltName="Cetar"
    PrimaryWeapons(0)=(Item=Class'DH_PPSH41Weapon',AssociatedAttachment=Class'ROInventory.ROPPSh41AmmoPouch')
    PrimaryWeapons(1)=(Item=Class'DH_AVT40Weapon',AssociatedAttachment=Class'ROInventory.ROMN9130AmmoPouch')
    SecondaryWeapons(0)=(Item=Class'DH_TT33Weapon')
    SecondaryWeapons(1)=(Item=Class'DH_Nagant1895Weapon')
    Grenades(0)=(Item=Class'DH_F1GrenadeWeapon')
    Grenades(1)=(Item=Class'DH_RDG1SmokeGrenadeWeapon')
    GivenItems(0)="DH_Equipment.DHBinocularsItemSoviet"
    VoiceType="DH_SovietPlayers.DHCzechVoice"
    AltVoiceType="DH_SovietPlayers.DHCzechVoice"
    SleeveTexture=Texture'DHSovietCharactersTex.DH_rus_sleeves'
    GlovedHandTexture=Texture'DHBritishCharactersTex.hands_BRITgloves'
}

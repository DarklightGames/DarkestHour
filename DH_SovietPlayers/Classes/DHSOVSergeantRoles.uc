//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHSOVSergeantRoles extends DHAlliedSergeantRoles
    abstract;

defaultproperties
{
    MyName="Squad leader"
    AltName="Komandir otdeleniya"
    PrimaryWeapons(0)=(Item=Class'DH_PPD40Weapon',AssociatedAttachment=Class'ROInventory.ROPPSh41AmmoPouch')
    PrimaryWeapons(1)=(Item=Class'DH_MN9130Weapon',AssociatedAttachment=Class'ROInventory.ROMN9130AmmoPouch')
    PrimaryWeapons(2)=(Item=Class'DH_SVT38Weapon',AssociatedAttachment=Class'ROInventory.SVT40AmmoPouch')
    SecondaryWeapons(0)=(Item=Class'DH_TT33Weapon')
    SecondaryWeapons(1)=(Item=Class'DH_Nagant1895Weapon')
    Grenades(0)=(Item=Class'DH_F1GrenadeWeapon')
    Grenades(1)=(Item=Class'DH_RDG1SmokeGrenadeWeapon')
    GivenItems(0)="DH_Equipment.DHBinocularsItemSoviet"
    VoiceType="DH_SovietPlayers.DHSovietVoice"
    AltVoiceType="DH_SovietPlayers.DHSovietVoice"
    SleeveTexture=Texture'DHSovietCharactersTex.DH_rus_sleeves'
    GlovedHandTexture=Texture'DHSovietCharactersTex.hands_sovgloves'
}

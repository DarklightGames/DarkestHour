//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHPOLSniperRoles extends DHAlliedSniperRoles
    abstract;

defaultproperties
{
    AltName="Strzelec wyborowy"
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_MN9130ScopedWeapon',AssociatedAttachment=class'ROInventory.ROMN9130AmmoPouch')
    SecondaryWeapons(0)=(Item=class'DH_Weapons.DH_Nagant1895Weapon')
    VoiceType="DH_SovietPlayers.DHPolishVoice"
    AltVoiceType="DH_SovietPlayers.DHPolishVoice"
    SleeveTexture=Texture'DHSovietCharactersTex.RussianSleeves.DH_rus_sleeves'
    GlovedHandTexture=Texture'DHSovietCharactersTex.soviet_gear.hands_sovgloves'
}

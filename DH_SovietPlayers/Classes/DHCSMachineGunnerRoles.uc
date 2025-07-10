//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHCSMachineGunnerRoles extends DHAlliedMachineGunnerRoles
    abstract;

defaultproperties
{
    AltName="Kulometcik"
    PrimaryWeapons(0)=(Item=Class'DH_DP27Weapon')
    SecondaryWeapons(0)=(Item=Class'DH_Nagant1895Weapon')
    VoiceType="DH_SovietPlayers.DHCzechVoice"
    AltVoiceType="DH_SovietPlayers.DHCzechVoice"
    Headgear(0)=Class'DH_SovietHelmet'
    GlovedHandTexture=Texture'DHSovietCharactersTex.hands_sovgloves'
}

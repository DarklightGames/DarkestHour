//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHPOLMachineGunnerRoles extends DHAlliedMachineGunnerRoles
    abstract;

defaultproperties
{
    AltName="Celowniczy KM"
    PrimaryWeapons(0)=(Item=Class'DH_DP27Weapon')
    SecondaryWeapons(0)=(Item=Class'DH_Nagant1895Weapon')
    VoiceType="DH_SovietPlayers.DHPolishVoice"
    AltVoiceType="DH_SovietPlayers.DHPolishVoice"
    Headgear(0)=Class'DH_SovietHelmet'
    GlovedHandTexture=Texture'DHSovietCharactersTex.hands_sovgloves'
}

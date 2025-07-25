//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHUSMachineGunnerRoles extends DHAlliedMachineGunnerRoles
    abstract;

defaultproperties
{
    PrimaryWeapons(0)=(Item=Class'DH_30calWeapon')
    SecondaryWeapons(0)=(Item=Class'DH_ColtM1911Weapon')
    HeadgearProbabilities(0)=0.2
    HeadgearProbabilities(1)=0.8
    SleeveTexture=Texture'DHUSCharactersTex.US_sleeves'
    GlovedHandTexture=Texture'DHUSCharactersTex.hands_USgloves'
    VoiceType="DH_USPlayers.DHUSVoice"
    AltVoiceType="DH_USPlayers.DHUSVoice"
}

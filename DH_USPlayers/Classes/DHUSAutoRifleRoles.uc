//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHUSAutoRifleRoles extends DHAlliedAutoRifleRoles;

defaultproperties
{
    PrimaryWeapons(0)=(Item=Class'DH_BARWeapon',AssociatedAttachment=Class'DH_Weapons.DH_M1CarbineAmmoPouch')
    SecondaryWeapons(0)=(Item=Class'DH_ColtM1911Weapon')
    VoiceType="DH_USPlayers.DHUSVoice"
    AltVoiceType="DH_USPlayers.DHUSVoice"
    SleeveTexture=Texture'DHUSCharactersTex.US_sleeves'
    GlovedHandTexture=Texture'DHUSCharactersTex.hands_USgloves'
    HeadgearProbabilities(0)=0.2
    HeadgearProbabilities(1)=0.8
}

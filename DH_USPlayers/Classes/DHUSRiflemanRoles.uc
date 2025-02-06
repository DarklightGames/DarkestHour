//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHUSRiflemanRoles extends DHAlliedRiflemanRoles
    abstract;

defaultproperties
{
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_M1GarandWeapon',AssociatedAttachment=class'DH_Weapons.DH_M1GarandAmmoPouch')
    Grenades(0)=(Item=class'DH_Weapons.DH_M1GrenadeWeapon')
    HeadgearProbabilities(0)=0.2
    HeadgearProbabilities(1)=0.8
    HeadgearProbabilities(2)=0.3
    SleeveTexture=Texture'DHUSCharactersTex.Sleeves.US_sleeves'
    GlovedHandTexture=Texture'DHUSCharactersTex.Gear.hands_USgloves'
    VoiceType="DH_USPlayers.DHUSVoice"
    AltVoiceType="DH_USPlayers.DHUSVoice"
}

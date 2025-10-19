//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHUSRadioOperatorRoles extends DHAlliedRadioOperatorRoles
    abstract;

defaultproperties
{
    PrimaryWeapons(0)=(Item=Class'DH_M1CarbineWeapon',AssociatedAttachment=Class'DH_Weapons.DH_M1CarbineAmmoPouch')
    PrimaryWeapons(1)=(Item=Class'DH_M1GarandWeapon',AssociatedAttachment=Class'DH_Weapons.DH_M1GarandAmmoPouch')
    Grenades(0)=(Item=Class'DH_M1GrenadeWeapon')
    GivenItems(0)="DH_Equipment.DHRadioItem"
    HeadgearProbabilities(0)=0.2
    HeadgearProbabilities(1)=0.8
    SleeveTexture=Texture'DHUSCharactersTex.US_sleeves'
    GlovedHandTexture=Texture'DHUSCharactersTex.hands_USgloves'
    VoiceType="DH_USPlayers.DHUSVoice"
    AltVoiceType="DH_USPlayers.DHUSVoice"
}

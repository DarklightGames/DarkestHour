//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHUSAntiTankRoles extends DHAlliedAntiTankRoles
    abstract;

defaultproperties
{
    PrimaryWeapons(0)=(Item=Class'DH_M1CarbineWeapon',AssociatedAttachment=Class'DH_Weapons.DH_M1CarbineAmmoPouch')
    PrimaryWeapons(1)=(Item=Class'DH_M1GarandWeapon',AssociatedAttachment=Class'DH_Weapons.DH_M1GarandAmmoPouch')
    Grenades(0)=(Item=Class'DH_USSmokeGrenadeWeapon')
    GivenItems(0)="DH_Weapons.DH_BazookaWeapon"
    VoiceType="DH_USPlayers.DHUSVoice"
    AltVoiceType="DH_USPlayers.DHUSVoice"
    SleeveTexture=Texture'DHUSCharactersTex.US_sleeves'
    GlovedHandTexture=Texture'DHUSCharactersTex.hands_USgloves'
    HeadgearProbabilities(0)=0.2
    HeadgearProbabilities(1)=0.8
}

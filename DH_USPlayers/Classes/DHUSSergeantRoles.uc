//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHUSSergeantRoles extends DHAlliedSergeantRoles
    abstract;

defaultproperties
{
    PrimaryWeapons(0)=(Item=Class'DH_ThompsonWeapon',AssociatedAttachment=Class'DH_Weapons.DH_ThompsonAmmoPouch')
    PrimaryWeapons(1)=(Item=Class'DH_GreaseGunWeapon',AssociatedAttachment=Class'DH_Weapons.DH_ThompsonAmmoPouch')
    PrimaryWeapons(2)=(Item=Class'DH_M1GarandWeapon',AssociatedAttachment=Class'DH_Weapons.DH_M1GarandAmmoPouch')
    SecondaryWeapons(0)=(Item=Class'DH_ColtM1911Weapon')
    Grenades(0)=(Item=Class'DH_USSmokeGrenadeWeapon')
    Grenades(1)=(Item=Class'DH_RedSmokeWeapon')
    Grenades(2)=(Item=Class'DH_M1GrenadeWeapon')
    HeadgearProbabilities(0)=0.2
    HeadgearProbabilities(1)=0.8
    SleeveTexture=Texture'DHUSCharactersTex.Sleeves.US_sleeves'
    GlovedHandTexture=Texture'DHUSCharactersTex.Gear.hands_USgloves'
    VoiceType="DH_USPlayers.DHUSVoice"
    AltVoiceType="DH_USPlayers.DHUSVoice"
}

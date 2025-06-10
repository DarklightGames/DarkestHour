//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHUSCorporalRoles extends DHAlliedCorporalRoles
    abstract;

defaultproperties
{
    PrimaryWeapons(0)=(Item=Class'DH_GreaseGunWeapon',AssociatedAttachment=Class'DH_Weapons.DH_ThompsonAmmoPouch')
    PrimaryWeapons(1)=(Item=Class'DH_M1928_20rndWeapon',AssociatedAttachment=Class'DH_Weapons.DH_ThompsonAmmoPouch')
    PrimaryWeapons(2)=(Item=Class'DH_M1GarandWeapon',AssociatedAttachment=Class'DH_Weapons.DH_M1GarandAmmoPouch')
    Grenades(0)=(Item=Class'DH_M1GrenadeWeapon')
    Grenades(1)=(Item=Class'DH_USSmokeGrenadeWeapon')
    VoiceType="DH_USPlayers.DHUSVoice"
    AltVoiceType="DH_USPlayers.DHUSVoice"
    SleeveTexture=Texture'DHUSCharactersTex.Sleeves.US_sleeves'
    GlovedHandTexture=Texture'DHUSCharactersTex.Gear.hands_USgloves'
    HeadgearProbabilities(0)=0.2
    HeadgearProbabilities(1)=0.8
}

//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHCWAntiTankRoles extends DHAlliedAntiTankRoles
    abstract;

defaultproperties
{
    MyName="Tank Hunter"
    AltName="Tank Hunter"
    PrimaryWeapons(0)=(Item=Class'DH_StenMkIIWeapon')
    PrimaryWeapons(1)=(Item=Class'DH_EnfieldNo4Weapon')
    PrimaryWeapons(2)=(Item=Class'DH_StenMkIIIWeapon')
    Grenades(0)=(Item=Class'DH_MillsBombWeapon')
    Grenades(1)=(Item=Class'DH_USSmokeGrenadeWeapon')
    GivenItems(0)="DH_Weapons.DH_PIATWeapon"
    Headgear(0)=Class'DH_BritishTurtleHelmet'
    Headgear(1)=Class'DH_BritishTurtleHelmetNet'
    Headgear(2)=Class'DH_BritishTommyHelmet'
    HeadgearProbabilities(0)=0.1
    HeadgearProbabilities(1)=0.1
    HeadgearProbabilities(2)=0.8
    VoiceType="DH_BritishPlayers.DHBritishVoice"
    AltVoiceType="DH_BritishPlayers.DHBritishVoice"
    SleeveTexture=Texture'DHBritishCharactersTex.brit_sleeves'
}

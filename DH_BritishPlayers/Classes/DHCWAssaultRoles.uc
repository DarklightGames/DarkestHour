//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHCWAssaultRoles extends DHAlliedAssaultRoles
    abstract;

defaultproperties
{

    PrimaryWeapons(0)=(Item=Class'DH_StenMkIIWeapon')
    PrimaryWeapons(1)=(Item=Class'DH_StenMkIIIWeapon')

    Grenades(0)=(Item=Class'DH_MillsBombWeapon')
    Grenades(1)=(Item=Class'DH_USSmokeGrenadeWeapon')
    GivenItems(0)="DH_Equipment.DHShovelItem_US"
    VoiceType="DH_BritishPlayers.DHBritishVoice"
    AltVoiceType="DH_BritishPlayers.DHBritishVoice"
    HeadgearProbabilities(0)=0.1
    HeadgearProbabilities(1)=0.1
    HeadgearProbabilities(2)=0.8
    Headgear(0)=Class'DH_BritishTurtleHelmet'
    Headgear(1)=Class'DH_BritishTurtleHelmetNet'
    Headgear(2)=Class'DH_BritishTommyHelmet'
    SleeveTexture=Texture'DHBritishCharactersTex.Sleeves.brit_sleeves'
}

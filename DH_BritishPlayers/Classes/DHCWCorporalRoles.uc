//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHCWCorporalRoles extends DHAlliedCorporalRoles
    abstract;

defaultproperties
{
    MyName="Lance Corporal"
    AltName="Lance Corporal"
    PrimaryWeapons(0)=(Item=Class'DH_EnfieldNo4Weapon')
    PrimaryWeapons(1)=(Item=Class'DH_StenMkIIWeapon')
    PrimaryWeapons(2)=(Item=Class'DH_StenMkIIIWeapon')

    Grenades(0)=(Item=Class'DH_MillsBombWeapon')
    Grenades(1)=(Item=Class'DH_USSmokeGrenadeWeapon')
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

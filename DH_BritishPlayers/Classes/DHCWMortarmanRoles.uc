//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHCWMortarmanRoles extends DHAlliedMortarmanRoles
    abstract;

defaultproperties
{
    PrimaryWeapons(0)=(Item=Class'DH_EnfieldNo4Weapon')
    GivenItems(0)="DH_Weapons.DH_M2MortarWeapon"
    GivenItems(1)="DH_Equipment.DHBinocularsItemAllied"
    HeadgearProbabilities(0)=0.1
    HeadgearProbabilities(1)=0.1
    HeadgearProbabilities(2)=0.8
    Headgear(0)=Class'DH_BritishTurtleHelmet'
    Headgear(1)=Class'DH_BritishTurtleHelmetNet'
    Headgear(2)=Class'DH_BritishTommyHelmet'
    VoiceType="DH_BritishPlayers.DHBritishVoice"
    AltVoiceType="DH_BritishPlayers.DHBritishVoice"
    SleeveTexture=Texture'DHBritishCharactersTex.brit_sleeves'
}

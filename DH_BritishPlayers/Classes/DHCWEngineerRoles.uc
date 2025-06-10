//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHCWEngineerRoles extends DHAlliedEngineerRoles
    abstract;

defaultproperties
{
    PrimaryWeapons(0)=(Item=Class'DH_EnfieldNo4Weapon')
    Grenades(0)=(Item=Class'DH_MillsBombWeapon')
    Grenades(1)=(Item=Class'DH_USSmokeGrenadeWeapon')
    GivenItems(0)="DH_Weapons.DH_SatchelCharge10lb10sWeapon"
    GivenItems(1)="DH_Equipment.DHWireCuttersItem"
    GivenItems(2)="DH_Equipment.DHShovelItem_US"
    Headgear(0)=Class'DH_BritishTurtleHelmet'
    Headgear(1)=Class'DH_BritishTurtleHelmetNet'
    Headgear(2)=Class'DH_BritishTommyHelmet'
    HeadgearProbabilities(0)=0.1
    HeadgearProbabilities(1)=0.1
    HeadgearProbabilities(2)=0.8
    VoiceType="DH_BritishPlayers.DHBritishVoice"
    AltVoiceType="DH_BritishPlayers.DHBritishVoice"
    SleeveTexture=Texture'DHBritishCharactersTex.Sleeves.brit_sleeves'
}

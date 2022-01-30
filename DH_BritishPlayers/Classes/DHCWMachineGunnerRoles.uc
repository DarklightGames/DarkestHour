//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DHCWMachineGunnerRoles extends DHAlliedMachineGunnerRoles
    abstract;

defaultproperties
{
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_30calWeapon')
    SecondaryWeapons(0)=(Item=class'DH_Weapons.DH_EnfieldNo2Weapon')
    Headgear(0)=class'DH_BritishPlayers.DH_BritishTurtleHelmet'
    Headgear(1)=class'DH_BritishPlayers.DH_BritishTurtleHelmetNet'
    Headgear(2)=class'DH_BritishPlayers.DH_BritishTommyHelmet'
    HeadgearProbabilities(0)=0.1
    HeadgearProbabilities(1)=0.1
    HeadgearProbabilities(2)=0.8
    VoiceType="DH_BritishPlayers.DHBritishVoice"
    AltVoiceType="DH_BritishPlayers.DHBritishVoice"
    SleeveTexture=Texture'DHBritishCharactersTex.Sleeves.brit_sleeves'
}

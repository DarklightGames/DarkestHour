//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHCWCorporalRoles extends DHAlliedCorporalRoles
    abstract;

defaultproperties
{
    MyName="Lance Corporal"
    AltName="Lance Corporal"
    PluralName="Lance Corporals"
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_EnfieldNo4Weapon')
    PrimaryWeapons(1)=(Item=class'DH_Weapons.DH_StenMkIIWeapon')
    PrimaryWeapons(2)=(Item=class'DH_Weapons.DH_StenMkIIIWeapon')

    Grenades(0)=(Item=class'DH_Weapons.DH_MillsBombWeapon')
    Grenades(1)=(Item=class'DH_Equipment.DH_USSmokeGrenadeWeapon')
    VoiceType="DH_BritishPlayers.DHBritishVoice"
    AltVoiceType="DH_BritishPlayers.DHBritishVoice"
    HeadgearProbabilities(0)=0.1
    HeadgearProbabilities(1)=0.1
    HeadgearProbabilities(2)=0.8
    Headgear(0)=class'DH_BritishPlayers.DH_BritishTurtleHelmet'
    Headgear(1)=class'DH_BritishPlayers.DH_BritishTurtleHelmetNet'
    Headgear(2)=class'DH_BritishPlayers.DH_BritishTommyHelmet'
    SleeveTexture=Texture'DHBritishCharactersTex.Sleeves.brit_sleeves'
}

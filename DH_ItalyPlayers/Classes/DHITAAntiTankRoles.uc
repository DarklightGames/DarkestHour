//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHITAAntiTankRoles extends DHAxisAntiTankRoles
    abstract;

defaultproperties
{
    AltName="Anticarro Fuciliere"

    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_Wz35Weapon')
    SecondaryWeapons(0)=(Item=class'DH_Weapons.DH_BerettaM1934Weapon')

    Grenades(0)=(Item=class'DH_Weapons.DH_LTypeGrenadeWeapon')
    Grenades(1)=(Item=class'DH_Weapons.DH_SRCMMod35SmokeGrenadeWeapon')

    VoiceType="DH_ItalyPlayers.DHItalyVoice"
    AltVoiceType="DH_ItalyPlayers.DHItalyVoice"
    BareHandTexture=Texture'DHItalianCharactersTex.Hands.Italian_hands'
    SleeveTexture=Texture'DHItalianCharactersTex.Sleeves.Livorno_sleeves'
    GlovedHandTexture=Texture'DHSovietCharactersTex.soviet_gear.hands_sovgloves' // TODO: replace

    Headgear(0)=class'DH_ItalyPlayers.DH_ItalianHelmet'
    Headgear(1)=class'DH_ItalyPlayers.DH_ItalianHelmet_Livorno'

    HeadgearProbabilities(0)=0.5
    HeadgearProbabilities(1)=0.5

    DetachedArmClass=class'DH_ItalyPlayers.DHSeveredArm_ItalianLivorno'
    DetachedLegClass=class'DH_ItalyPlayers.DHSeveredLeg_ItalianLivorno'
}

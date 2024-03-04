//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHITAEngineerRoles extends DHAxisEngineerRoles
    abstract;

defaultproperties
{
    AltName="Artiere"

    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_CarcanoM91Weapon')

    Grenades(0)=(Item=class'DH_Weapons.DH_LTypeGrenadeWeapon')
    Grenades(1)=(Item=class'DH_Weapons.DH_SRCMMod35SmokeGrenadeWeapon')

    GivenItems(0)="DH_Weapons.DH_SatchelCharge10lb10sWeapon"
    GivenItems(1)="DH_Equipment.DHWireCuttersItem"

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

//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHUSAutoRifleRoles extends DHAlliedAutoRifleRoles;

defaultproperties
{
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_BARWeapon',AssociatedAttachment=class'DH_Weapons.DH_M1CarbineAmmoPouch')
    SecondaryWeapons(0)=(Item=class'DH_Weapons.DH_ColtM1911Weapon')
    VoiceType="DH_USPlayers.DHUSVoice"
    AltVoiceType="DH_USPlayers.DHUSVoice"
    SleeveTexture=Texture'DHUSCharactersTex.Sleeves.US_sleeves'
    GlovedHandTexture=Texture'DHUSCharactersTex.Gear.hands_USgloves'
    HeadgearProbabilities(0)=0.2
    HeadgearProbabilities(1)=0.8
}

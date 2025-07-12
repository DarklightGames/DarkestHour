//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHITAAntiTankRoles extends DHAxisAntiTankRoles
    abstract;

defaultproperties
{
    AltName="Fuciliere Anticarro"

    PrimaryWeapons(0)=(Item=Class'DH_Wz35Weapon')
    PrimaryWeapons(1)=(Item=Class'DH_CarcanoM9138CarbineWeapon')
    SecondaryWeapons(0)=(Item=Class'DH_BerettaM1934Weapon')

    Grenades(0)=(Item=Class'DH_LTypeGrenadeWeapon')
    Grenades(1)=(Item=Class'DH_SRCMMod35SmokeGrenadeWeapon')
    VoiceType="DH_ItalyPlayers.DHItalyVoice"
    AltVoiceType="DH_ItalyPlayers.DHItalyVoice"
    BareHandTexture=Texture'DHItalianCharactersTex.Italian_hands'
    SleeveTexture=Texture'DHItalianCharactersTex.Livorno_sleeves'
    GlovedHandTexture=Texture'DHSovietCharactersTex.hands_sovgloves' // TODO: replace

    Headgear(0)=Class'DH_ItalianHelmet'
    Headgear(1)=Class'DH_ItalianHelmet_Livorno'
    Headgear(2)=Class'DH_ItalianHelmet_Adrian'
    Headgear(3)=Class'DH_ItalianHelmet_AdrianTwo'

    HeadgearProbabilities(0)=0.4
    HeadgearProbabilities(1)=0.5
    HeadgearProbabilities(2)=0.05
    HeadgearProbabilities(3)=0.05

    DetachedArmClass=Class'DHSeveredArm_ItalianLivorno'
    DetachedLegClass=Class'DHSeveredLeg_ItalianLivorno'

    AddedRoleRespawnTime=10 // Reduced from the default because of this role's relative ineffectiveness.
}

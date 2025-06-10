//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHITARiflemanRoles extends DHAxisRiflemanRoles
    abstract;

defaultproperties
{
    AltName="Fuciliere"

    PrimaryWeapons(0)=(Item=Class'DH_CarcanoM91Weapon',AssociatedAttachment=Class'DH_Weapons.DH_CarcanoM91AmmoPouch')
    PrimaryWeapons(1)=(Item=none,AssociatedAttachment=none)
    PrimaryWeapons(2)=(Item=none,AssociatedAttachment=none)

    Grenades(0)=(Item=Class'DH_SRCMMod35GrenadeWeapon')

    VoiceType="DH_ItalyPlayers.DHItalyVoice"
    AltVoiceType="DH_ItalyPlayers.DHItalyVoice"
    BareHandTexture=Texture'DHItalianCharactersTex.Hands.Italian_hands'
    SleeveTexture=Texture'DHItalianCharactersTex.Sleeves.Livorno_sleeves'
    GlovedHandTexture=Texture'DHSovietCharactersTex.soviet_gear.hands_sovgloves' // TODO: replace

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
}

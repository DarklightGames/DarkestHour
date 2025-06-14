//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHITCorporalRoles extends DHAxisCorporalRoles
    abstract;

defaultproperties
{
    AltName="Caporale"
    PrimaryWeapons(0)=(Item=Class'DH_CarcanoM91Weapon',AssociatedAttachment=Class'DH_Weapons.DH_CarcanoM91AmmoPouch')
    // TODO: Add the Carbine Carcano M91/38
    Grenades(0)=(Item=Class'DH_SRCMMod35GrenadeWeapon')
    Grenades(1)=(Item=Class'DH_SRCMMod35SmokeGrenadeWeapon')

    Headgear(0)=Class'DH_ItalianHelmet'
    Headgear(1)=Class'DH_ItalianHelmet_Livorno'
    Headgear(2)=Class'DH_ItalianHelmet_Adrian'
    Headgear(3)=Class'DH_ItalianHelmet_AdrianTwo'

    HeadgearProbabilities(0)=0.4
    HeadgearProbabilities(1)=0.5
    HeadgearProbabilities(2)=0.05
    HeadgearProbabilities(3)=0.05

    VoiceType="DH_ItalyPlayers.DHItalyVoice"
    AltVoiceType="DH_ItalyPlayers.DHItalyVoice"
    BareHandTexture=Texture'DHItalianCharactersTex.Italian_hands'
    SleeveTexture=Texture'DHItalianCharactersTex.Livorno_sleeves'
    DetachedArmClass=Class'DHSeveredArm_ItalianLivorno'
    DetachedLegClass=Class'DHSeveredLeg_ItalianLivorno'
    GlovedHandTexture=Texture'Weapons1st_tex.hands_gergloves'
    GivenItems(0)="DH_Equipment.DHShovelItem_Italian"
}

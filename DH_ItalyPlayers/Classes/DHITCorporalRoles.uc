//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHITCorporalRoles extends DHAxisCorporalRoles
    abstract;

defaultproperties
{
    AltName="Caporale"
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_CarcanoM91Weapon',AssociatedAttachment=class'DH_Weapons.DH_CarcanoM91AmmoPouch')
    // TODO: Add the Carbine Carcano M91/38
    Grenades(0)=(Item=class'DH_Weapons.DH_SRCMMod35GrenadeWeapon')
    Grenades(1)=(Item=class'DH_Weapons.DH_SRCMMod35SmokeGrenadeWeapon')

    Headgear(0)=class'DH_ItalyPlayers.DH_ItalianHelmet'
    Headgear(1)=class'DH_ItalyPlayers.DH_ItalianHelmet_Livorno'
    Headgear(2)=class'DH_ItalyPlayers.DH_ItalianHelmet_Adrian'
    Headgear(3)=class'DH_ItalyPlayers.DH_ItalianHelmet_AdrianTwo'

    HeadgearProbabilities(0)=0.4
    HeadgearProbabilities(1)=0.5
    HeadgearProbabilities(2)=0.05
    HeadgearProbabilities(3)=0.05

    VoiceType="DH_ItalyPlayers.DHItalyVoice"
    AltVoiceType="DH_ItalyPlayers.DHItalyVoice"
    BareHandTexture=Texture'DHItalianCharactersTex.Hands.Italian_hands'
    SleeveTexture=Texture'DHItalianCharactersTex.Sleeves.Livorno_sleeves'
    DetachedArmClass=class'DH_ItalyPlayers.DHSeveredArm_ItalianLivorno'
    DetachedLegClass=class'DH_ItalyPlayers.DHSeveredLeg_ItalianLivorno'
    GlovedHandTexture=Texture'Weapons1st_tex.Arms.hands_gergloves'
    GivenItems(0)="DH_Equipment.DHShovelItem_Italian"
}

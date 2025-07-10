//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHITARadioOperatorRoles extends DHAxisRadioOperatorRoles
    abstract;

defaultproperties
{
    AltName="Radiotelegrafista"

    PrimaryWeapons(0)=(Item=Class'DH_CarcanoM9138CarbineWeapon',AssociatedAttachment=Class'DH_Weapons.DH_CarcanoM91AmmoPouch')
    Grenades(0)=(Item=Class'DH_SRCMMod35GrenadeWeapon')  // TODO: replace with italian grenade

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

    GivenItems(0)="DH_Equipment.DH_ItalianRadioItem"
    
    Backpacks(0)=(BackpackClass=Class'DH_StazioneRF1Backpack')

    DetachedArmClass=Class'DHSeveredArm_ItalianLivorno'
    DetachedLegClass=Class'DHSeveredLeg_ItalianLivorno'
}

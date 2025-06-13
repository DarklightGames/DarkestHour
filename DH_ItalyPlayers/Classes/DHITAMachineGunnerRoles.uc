//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHITAMachineGunnerRoles extends DHAxisMachineGunnerRoles
    abstract;

defaultproperties
{
    AltName="Mitragliere"
    AddedRoleRespawnTime=10

    PrimaryWeapons(0)=(Item=Class'DH_Breda30Weapon',AssociatedAttachment=Class'DH_Weapons.DH_Breda30AmmoPouch')
    SecondaryWeapons(0)=(Item=Class'DH_BerettaM1934Weapon',AssociatedAttachment=Class'DH_BerettaM1934AmmoPouch')

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

    Backpacks(0)=(BackpackClass=Class'DH_Breda30Backpack')
    
    DetachedArmClass=Class'DHSeveredArm_ItalianLivorno'
    DetachedLegClass=Class'DHSeveredLeg_ItalianLivorno'
}

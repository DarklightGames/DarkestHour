//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHITASergeantRoles extends DHAxisSergeantRoles
    abstract;

defaultproperties
{
    AltName="Sergente"

    PrimaryWeapons(0)=(Item=Class'DH_CarcanoM9138CarbineWeapon',AssociatedAttachment=Class'DH_CarcanoM91AmmoPouch')
    PrimaryWeapons(1)=(Item=Class'DH_CarcanoM91Weapon',AssociatedAttachment=Class'DH_CarcanoM91AmmoPouch')

    SecondaryWeapons(0)=(Item=Class'DH_BerettaM1934Weapon',AssociatedAttachment=Class'DH_BerettaM1934AmmoPouch')

    Grenades(0)=(Item=Class'DH_SRCMMod35GrenadeWeapon')
    Grenades(1)=(Item=Class'DH_SRCMMod35SmokeGrenadeWeapon')

    VoiceType="DH_ItalyPlayers.DHItalyVoice"
    AltVoiceType="DH_ItalyPlayers.DHItalyVoice"
    BareHandTexture=Texture'DHItalianCharactersTex.Italian_hands'
    SleeveTexture=Texture'DHItalianCharactersTex.Livorno_sleeves'
    GlovedHandTexture=Texture'DHSovietCharactersTex.hands_sovgloves' // TODO: replace
    
    Headgear(0)=Class'DH_ItalianHelmet'
    Headgear(1)=Class'DH_ItalianHelmet_Livorno'
    Headgear(2)=Class'DH_ItalianCapNCO'
    
    HeadgearProbabilities(0)=0.4
    HeadgearProbabilities(1)=0.4
    HeadgearProbabilities(2)=0.2

    DetachedArmClass=Class'DHSeveredArm_ItalianLivorno'
    DetachedLegClass=Class'DHSeveredLeg_ItalianLivorno'
}

//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHITATankCrewmanRoles extends DHAxisTankCrewmanRoles
    abstract;

defaultproperties
{
    AltName="Carrista"

    PrimaryWeapons(0)=(Item=none,AssociatedAttachment=none)
    PrimaryWeapons(1)=(Item=none,AssociatedAttachment=none)
    PrimaryWeapons(2)=(Item=none,AssociatedAttachment=none)

    SecondaryWeapons(0)=(Item=Class'DH_BerettaM1934Weapon',AssociatedAttachment=Class'DH_BerettaM1934AmmoPouch')

    GivenItems(0)="DH_Equipment.DHBinocularsItemItalian"

    VoiceType="DH_ItalyPlayers.DHItalyVoice"
    AltVoiceType="DH_ItalyPlayers.DHItalyVoice"
    BareHandTexture=Texture'DHItalianCharactersTex.Hands.Italian_hands'
    SleeveTexture=Texture'DHItalianCharactersTex.Sleeves.Livorno_sleeves'   // TODO: replace with tanker sleeves
    GlovedHandTexture=Texture'DHSovietCharactersTex.soviet_gear.hands_sovgloves' // TODO: replace with tanker gloves

    Headgear(0)=Class'DH_ItalianCapTanker'
    Headgear(1)=Class'DH_ItalianCapTanker'  // TODO: goggles on helmet
    Headgear(2)=Class'DH_ItalianCapTanker'  // TODO: goggles on eyes

    HeadgearProbabilities(0)=0.2
    HeadgearProbabilities(1)=0.6
    HeadgearProbabilities(2)=0.2

    DetachedArmClass=Class'DHSeveredArm_ItalianLivorno' // TODO: need gibs for tankers
    DetachedLegClass=Class'DHSeveredLeg_ItalianLivorno'
}

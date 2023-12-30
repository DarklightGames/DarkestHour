//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DHITATankCrewmanRoles extends DHAxisTankCrewmanRoles
    abstract;

defaultproperties
{
    AltName="Carrista"

    PrimaryWeapons(0)=(Item=none,AssociatedAttachment=none)
    PrimaryWeapons(1)=(Item=none,AssociatedAttachment=none)
    PrimaryWeapons(2)=(Item=none,AssociatedAttachment=none)

    SecondaryWeapons(0)=(Item=class'DH_Weapons.DH_BerettaM1934Weapon',AssociatedAttachment=class'DH_BerettaM1934AmmoPouch')

    GivenItems(0)="DH_Equipment.DHBinocularsItemItalian"

    VoiceType="DH_ItalyPlayers.DHItalyVoice"
    AltVoiceType="DH_ItalyPlayers.DHItalyVoice"
    BareHandTexture=Texture'DHItalianCharactersTex.Hands.Italian_hands'
    SleeveTexture=Texture'DHItalianCharactersTex.Sleeves.Livorno_sleeves'   // TODO: replace with tanker sleeves
    GlovedHandTexture=Texture'DHSovietCharactersTex.soviet_gear.hands_sovgloves' // TODO: replace with tanker gloves

    Headgear(0)=class'DH_ItalyPlayers.DH_ItalianCapTanker'
    Headgear(1)=class'DH_ItalyPlayers.DH_ItalianCapTanker'  // TODO: goggles on helmet
    Headgear(2)=class'DH_ItalyPlayers.DH_ItalianCapTanker'  // TODO: goggles on eyes

    HeadgearProbabilities(0)=0.2
    HeadgearProbabilities(1)=0.6
    HeadgearProbabilities(2)=0.2

    DetachedArmClass=class'DH_ItalyPlayers.DHSeveredArm_ItalianLivorno' // TODO: need gibs for tankers
    DetachedLegClass=class'DH_ItalyPlayers.DHSeveredLeg_ItalianLivorno'
}

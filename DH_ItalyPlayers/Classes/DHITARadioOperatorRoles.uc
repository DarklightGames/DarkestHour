//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DHITARadioOperatorRoles extends DHAxisRadioOperatorRoles
    abstract;

defaultproperties
{
    AltName="Radiotelegrafista"

    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_CarcanoM91Weapon',AssociatedAttachment=class'DH_Weapons.DH_CarcanoM91AmmoPouch')
    Grenades(0)=(Item=class'DH_Weapons.DH_StielGranateWeapon')  // TODO: replace with italian grenade

    VoiceType="DH_ItalyPlayers.DHItalyVoice"
    AltVoiceType="DH_ItalyPlayers.DHItalyVoice"
    SleeveTexture=Texture'Weapons1st_tex.russian_sleeves'
    GlovedHandTexture=Texture'DHSovietCharactersTex.soviet_gear.hands_sovgloves'    // ?

    Headgear(0)=class'DH_ItalyPlayers.DH_ItalianHelmet'
    Headgear(1)=class'DH_ItalyPlayers.DH_ItalianHelmet_Livorno'

    HeadgearProbabilities(0)=0.5
    HeadgearProbabilities(1)=0.5

    GivenItems(0)="DH_Equipment.DHRadioItem"    // TODO: custom radio icons for all factions
    
    Backpack(0)=(BackpackClass=class'DH_ItalyPlayers.DH_StazioneRF1Backpack')

    DetachedArmClass=class'DH_ItalyPlayers.DHSeveredArm_ItalianLivorno'
    DetachedLegClass=class'DH_ItalyPlayers.DHSeveredLeg_ItalianLivorno'
}

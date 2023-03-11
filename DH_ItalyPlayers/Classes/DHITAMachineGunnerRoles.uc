//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DHITAMachineGunnerRoles extends DHAxisMachineGunnerRoles
    abstract;

defaultproperties
{
    AltName="Mitragliere"

    // TODO: replace this once we get the carcanos
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_Breda30Weapon',AssociatedAttachment=class'DH_Weapons.DH_Breda30AmmoPouch')

    VoiceType="DH_ItalyPlayers.DHItalyVoice"
    AltVoiceType="DH_ItalyPlayers.DHItalyVoice"
    SleeveTexture=Texture'Weapons1st_tex.russian_sleeves'
    GlovedHandTexture=Texture'DHSovietCharactersTex.soviet_gear.hands_sovgloves'    // ?

    Headgear(0)=class'DH_ItalyPlayers.DH_ItalianHelmet'
    Headgear(1)=class'DH_ItalyPlayers.DH_ItalianHelmet_Livorno'

    HeadgearProbabilities(0)=0.5
    HeadgearProbabilities(1)=0.5

    Backpack(0)=(BackpackClass=class'DH_ItalyPlayers.DH_Breda30Backpack')
    
    DetachedArmClass=class'DH_ItalyPlayers.DHSeveredArm_ItalianLivorno'
    DetachedLegClass=class'DH_ItalyPlayers.DHSeveredLeg_ItalianLivorno'
}
//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DHITASergeantRoles extends DHAxisSergeantRoles
    abstract;

defaultproperties
{
    AltName="Sergente"

    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_MAB42Weapon',AssociatedAttachment=none)
    PrimaryWeapons(1)=(Item=class'DH_Weapons.DH_MAB38Weapon',AssociatedAttachment=none)

    // TODO: give Berretta eventually!
    SecondaryWeapons(0)=(Item=class'DH_Weapons.DH_P08LugerWeapon',AssociatedAttachment=class'DH_BerettaM1934AmmoPouch')

    Grenades(0)=(Item=class'DH_Weapons.DH_StielGranateWeapon')  // TODO: replace with italian grenade

    VoiceType="DH_ItalyPlayers.DHItalyVoice"
    AltVoiceType="DH_ItalyPlayers.DHItalyVoice"
    SleeveTexture=Texture'Weapons1st_tex.russian_sleeves'
    GlovedHandTexture=Texture'DHSovietCharactersTex.soviet_gear.hands_sovgloves'    // ?

    Headgear(0)=class'DH_ItalyPlayers.DH_ItalianHelmet'
    Headgear(1)=class'DH_ItalyPlayers.DH_ItalianHelmet_Livorno'
    Headgear(2)=class'DH_ItalyPlayers.DH_ItalianCapNCO'

    HeadgearProbabilities(0)=0.4
    HeadgearProbabilities(1)=0.4
    HeadgearProbabilities(2)=0.2

    DetachedArmClass=class'DH_ItalyPlayers.DHSeveredArm_ItalianLivorno'
    DetachedLegClass=class'DH_ItalyPlayers.DHSeveredLeg_ItalianLivorno'
}

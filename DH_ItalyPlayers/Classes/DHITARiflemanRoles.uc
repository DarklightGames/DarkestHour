//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DHITARiflemanRoles extends DHAxisRiflemanRoles
    abstract;

defaultproperties
{
    AltName="Fuciliere"

    // TODO: replace this once we get the carcanos
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_CarcanoM91Weapon',AssociatedAttachment=class'DH_Weapons.DH_CarcanoM91AmmoPouch')
    // TODO: move these to the sergeant role
    PrimaryWeapons(1)=(Item=class'DH_Weapons.DH_MAB38Weapon',AssociatedAttachment=class'DH_Weapons.DH_CarcanoM91AmmoPouch')
    PrimaryWeapons(2)=(Item=class'DH_Weapons.DH_MAB42Weapon',AssociatedAttachment=class'DH_Weapons.DH_CarcanoM91AmmoPouch')

    Grenades(0)=(Item=class'DH_Weapons.DH_F1GrenadeWeapon') // TODO: replcae with standard italian grenade

    VoiceType="DH_ItalyPlayers.DHItalyVoice"
    AltVoiceType="DH_ItalyPlayers.DHItalyVoice"
    GlovedHandTexture=Texture'DHSovietCharactersTex.soviet_gear.hands_sovgloves'    // ?

    Headgear(0)=class'DH_ItalyPlayers.DH_ItalianHelmet'
    Headgear(1)=class'DH_ItalyPlayers.DH_ItalianHelmet_Livorno'

    HeadgearProbabilities(0)=0.5
    HeadgearProbabilities(1)=0.5
}

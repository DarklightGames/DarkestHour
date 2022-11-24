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
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_MAB38Weapon'/*,AssociatedAttachment=class'ROInventory.ROMN9130AmmoPouch'*/)
    PrimaryWeapons(1)=(Item=class'DH_Weapons.DH_MAB42Weapon'/*,AssociatedAttachment=class'ROInventory.ROMN9130AmmoPouch'*/)
    Grenades(0)=(Item=class'DH_Weapons.DH_F1GrenadeWeapon')
    VoiceType="DH_ItalyPlayers.DHItalyVoice"
    AltVoiceType="DH_ItalyPlayers.DHItalyVoice"
    GlovedHandTexture=Texture'DHSovietCharactersTex.soviet_gear.hands_sovgloves'    // ?
}
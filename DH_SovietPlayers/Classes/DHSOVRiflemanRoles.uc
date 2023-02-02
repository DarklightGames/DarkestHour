//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHSOVRiflemanRoles extends DHAlliedRiflemanRoles
    abstract;

defaultproperties
{
    AltName="Strelok"
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_MN9130Weapon',AssociatedAttachment=class'ROInventory.ROMN9130AmmoPouch')
    Grenades(0)=(Item=class'DH_Weapons.DH_F1GrenadeWeapon')
    VoiceType="DH_SovietPlayers.DHSovietVoice"
    AltVoiceType="DH_SovietPlayers.DHSovietVoice"
    GlovedHandTexture=Texture'DHSovietCharactersTex.soviet_gear.hands_sovgloves'
}

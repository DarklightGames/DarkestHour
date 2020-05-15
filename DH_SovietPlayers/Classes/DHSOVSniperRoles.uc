//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2020
//==============================================================================

class DHSOVSniperRoles extends DHAlliedSniperRoles
    abstract;

defaultproperties
{
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_MN9130ScopedWeapon',AssociatedAttachment=class'ROInventory.ROMN9130AmmoPouch')
    SecondaryWeapons(0)=(Item=class'DH_Weapons.DH_TT33Weapon')
    VoiceType="DH_SovietPlayers.DHSovietVoice"
    AltVoiceType="DH_SovietPlayers.DHSovietVoice"
    SleeveTexture=Texture'Weapons1st_tex.russian_sleeves'
}

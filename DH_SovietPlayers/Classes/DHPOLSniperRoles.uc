//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2021
//==============================================================================

class DHPOLSniperRoles extends DHAlliedSniperRoles
    abstract;

defaultproperties
{
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_MN9130ScopedWeapon',AssociatedAttachment=class'ROInventory.ROMN9130AmmoPouch')
    SecondaryWeapons(0)=(Item=class'DH_Weapons.DH_Nagant1895Weapon')
    VoiceType="DH_SovietPlayers.DHPolishVoice"
    AltVoiceType="DH_SovietPlayers.DHPolishVoice"
    SleeveTexture=Texture'DHSovietCharactersTex.RussianSleeves.DH_rus_sleeves'
}

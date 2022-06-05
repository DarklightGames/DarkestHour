//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DHSOVAssaultRoles extends DHAlliedAssaultRoles
    abstract;

defaultproperties
{
    AltName="Avtomatchik"
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_PPSH41Weapon')
    Grenades(0)=(Item=class'DH_Weapons.DH_F1GrenadeWeapon')
    VoiceType="DH_SovietPlayers.DHSovietVoice"
    AltVoiceType="DH_SovietPlayers.DHSovietVoice"
    GlovedHandTexture=Texture'DHSovietCharactersTex.soviet_gear.hands_sovgloves'
}

//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHCSMachineGunnerRoles extends DHAlliedMachineGunnerRoles
    abstract;

defaultproperties
{
    AltName="Kulometcik"
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_DP27Weapon')
    SecondaryWeapons(0)=(Item=class'DH_Weapons.DH_Nagant1895Weapon')
    VoiceType="DH_SovietPlayers.DHCzechVoice"
    AltVoiceType="DH_SovietPlayers.DHCzechVoice"
    Headgear(0)=class'DH_SovietPlayers.DH_SovietHelmet'
    GlovedHandTexture=Texture'DHSovietCharactersTex.soviet_gear.hands_sovgloves'
}

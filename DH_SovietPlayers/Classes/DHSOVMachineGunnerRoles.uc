//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DHSOVMachineGunnerRoles extends DHAlliedMachineGunnerRoles
    abstract;

defaultproperties
{
    AltName="Pulemetchik"
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_DP28Weapon')
    SecondaryWeapons(0)=(Item=class'DH_Weapons.DH_TT33Weapon')
    VoiceType="DH_SovietPlayers.DHSovietVoice"
    AltVoiceType="DH_SovietPlayers.DHSovietVoice"

    Headgear(0)=class'DH_SovietPlayers.DH_SovietHelmet'
}

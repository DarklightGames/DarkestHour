//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DHSOVAntiTankRoles extends DHAlliedAntiTankRoles
    abstract;

defaultproperties
{
    AltName="PT-Soldat"
    VoiceType="DH_SovietPlayers.DHSovietVoice"
    AltVoiceType="DH_SovietPlayers.DHSovietVoice"
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_M38Weapon',AssociatedAttachment=class'ROInventory.ROMN9130AmmoPouch')
    PrimaryWeapons(1)=(Item=class'DH_Weapons.DH_PTRDWeapon',AssociatedAttachment=class'ROInventory.ROPPSh41AmmoPouch')
    SecondaryWeapons(0)=(Item=class'DH_Weapons.DH_TT33Weapon')
    Grenades(0)=(Item=class'DH_Weapons.DH_RPG43GrenadeWeapon')
}

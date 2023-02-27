//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHCSCorporalRoles extends DHAlliedCorporalRoles
    abstract;

defaultproperties
{
    AltName="Desatnik"
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_SVT40Weapon',AssociatedAttachment=class'ROInventory.SVT40AmmoPouch')
    PrimaryWeapons(1)=(Item=class'DH_Weapons.DH_PPSH41_stickWeapon',AssociatedAttachment=class'ROInventory.ROPPS43AmmoPouch')
    Grenades(0)=(Item=class'DH_Weapons.DH_F1GrenadeWeapon')
    Grenades(1)=(Item=class'DH_Equipment.DH_RDG1SmokeGrenadeWeapon')
    VoiceType="DH_SovietPlayers.DHCzechVoice"
    AltVoiceType="DH_SovietPlayers.DHCzechVoice"
    GlovedHandTexture=Texture'DHBritishCharactersTex.Winter.hands_BRITgloves'
}

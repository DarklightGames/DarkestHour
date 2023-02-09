//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHPOLCorporalRoles extends DHAlliedCorporalRoles
    abstract;

defaultproperties
{
    AltName="Kapral"
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_SVT40Weapon',AssociatedAttachment=class'ROInventory.SVT40AmmoPouch')
    Grenades(0)=(Item=class'DH_Weapons.DH_F1GrenadeWeapon')
    Grenades(1)=(Item=class'DH_Equipment.DH_RDG1SmokeGrenadeWeapon')
    VoiceType="DH_SovietPlayers.DHPolishVoice"
    AltVoiceType="DH_SovietPlayers.DHPolishVoice"
    GlovedHandTexture=Texture'DHSovietCharactersTex.soviet_gear.hands_sovgloves'
}

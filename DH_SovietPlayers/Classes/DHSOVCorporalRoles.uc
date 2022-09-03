//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DHSOVCorporalRoles extends DHAlliedCorporalRoles
    abstract;

defaultproperties
{
    MyName="Fireteam leader"
    PluralName="Fireteam leaders"
    AltName="Komandir zvena"
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_MN9130Weapon',AssociatedAttachment=class'ROInventory.ROMN9130AmmoPouch')
    PrimaryWeapons(1)=(Item=class'DH_Weapons.DH_SVT40Weapon',AssociatedAttachment=class'ROInventory.SVT40AmmoPouch')
    Grenades(0)=(Item=class'DH_Weapons.DH_F1GrenadeWeapon')
    Grenades(1)=(Item=class'DH_Equipment.DH_RDG1SmokeGrenadeWeapon')
    VoiceType="DH_SovietPlayers.DHSovietVoice"
    AltVoiceType="DH_SovietPlayers.DHSovietVoice"
    GlovedHandTexture=Texture'DHSovietCharactersTex.soviet_gear.hands_sovgloves'
}

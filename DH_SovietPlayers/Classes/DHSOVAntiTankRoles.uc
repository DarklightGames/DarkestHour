//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHSOVAntiTankRoles extends DHAlliedAntiTankRoles
    abstract;

defaultproperties
{
    AltName="Broneboyschik"
    VoiceType="DH_SovietPlayers.DHSovietVoice"
    AltVoiceType="DH_SovietPlayers.DHSovietVoice"
    //removed m38 as an option because this is usually a strategically important role, if someone will take it and "waste" by taking non-PTRD weapon, this will damage the whole team
    //i recommend adding m38 manually only on late war maps where PTRD should be in abundance and less effective against tanks (together with higher role limit)
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_PTRDWeapon',AssociatedAttachment=class'ROInventory.ROPPSh41AmmoPouch')
    SecondaryWeapons(0)=(Item=class'DH_Weapons.DH_Nagant1895Weapon')
    SecondaryWeapons(1)=(Item=class'DH_Weapons.DH_TT33Weapon')
    Grenades(0)=(Item=class'DH_Weapons.DH_F1GrenadeWeapon')
    GlovedHandTexture=Texture'DHSovietCharactersTex.soviet_gear.hands_sovgloves'
}

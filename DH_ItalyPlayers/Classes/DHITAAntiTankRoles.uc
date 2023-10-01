//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHITAAntiTankRoles extends DHAxisAntiTankRoles
    abstract;

defaultproperties
{
    AltName="Anticarro Fuciliere"
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_Wz35Weapon')
    SecondaryWeapons(0)=(Item=class'DH_Weapons.DH_BerettaM1934Weapon')
    Grenades(0)=(Item=class'DH_Weapons.DH_LTypeGrenadeWeapon')
    GlovedHandTexture=Texture'Weapons1st_tex.Arms.hands_gergloves'  // TODO: Add italian gloves
}

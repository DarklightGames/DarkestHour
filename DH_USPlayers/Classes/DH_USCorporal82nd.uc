//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_USCorporal82nd extends DH_US_82nd_Airborne;

defaultproperties
{
    MyName="Corporal"
    AltName="Corporal"
    Article="a "
    PluralName="Corporals"
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_M1GarandWeapon',AssociatedAttachment=class'DH_Weapons.DH_M1GarandAmmoPouch')
    SecondaryWeapons(0)=(Item=class'DH_Weapons.DH_ColtM1911Weapon')
    Grenades(0)=(Item=class'DH_Weapons.DH_M1GrenadeWeapon')
    Grenades(1)=(Item=class'DH_Equipment.DH_USSmokeGrenadeWeapon')
    Headgear(0)=class'DH_USPlayers.DH_AmericanHelmet82ndEMa'
    Headgear(1)=class'DH_USPlayers.DH_AmericanHelmet82ndEMb'
    Limit=2
}

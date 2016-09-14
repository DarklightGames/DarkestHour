//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_USCorporal2ndR extends DH_US_2ndRangersBattalion;

defaultproperties
{
    MyName="Corporal"
    AltName="Corporal"
    Article="a "
    PluralName="Corporals"
    SleeveTexture=texture'DHUSCharactersTex.Sleeves.US_sleeves'
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_M1GarandWeapon',AssociatedAttachment=class'DH_Weapons.DH_M1GarandAmmoPouch')
    Grenades(0)=(Item=class'DH_Weapons.DH_M1GrenadeWeapon')
    Grenades(1)=(Item=class'DH_Equipment.DH_USSmokeGrenadeWeapon')
    Headgear(0)=class'DH_USPlayers.DH_AmericanHelmet2ndREMa'
    Headgear(1)=class'DH_USPlayers.DH_AmericanHelmet2ndREMb'
    PrimaryWeaponType=WT_SemiAuto
    Limit=2
}

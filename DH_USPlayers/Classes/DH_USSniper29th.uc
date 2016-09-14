//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_USSniper29th extends DH_US_29th_Infantry;

defaultproperties
{
    MyName="Sniper"
    AltName="Sniper"
    Article="a "
    PluralName="Snipers"
    SleeveTexture=texture'DHUSCharactersTex.Sleeves.US_sleeves'
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_SpringfieldScopedWeapon',AssociatedAttachment=class'DH_Weapons.DH_M1GarandAmmoPouch')
    SecondaryWeapons(0)=(Item=class'DH_Weapons.DH_ColtM1911Weapon')
    Headgear(0)=class'DH_USPlayers.DH_AmericanHelmet29thEMa'
    Headgear(1)=class'DH_USPlayers.DH_AmericanHelmet29thEMb'
    PrimaryWeaponType=WT_Sniper
    Limit=1
}

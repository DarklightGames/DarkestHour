//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_USSniper82nd extends DH_US_82nd_Airborne;

defaultproperties
{
    MyName="Sniper"
    AltName="Sniper"
    Article="a "
    PluralName="Snipers"
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_SpringfieldScopedWeapon',AssociatedAttachment=class'DH_Weapons.DH_M1GarandAmmoPouch')
    SecondaryWeapons(0)=(Item=class'DH_Weapons.DH_ColtM1911Weapon')
    Headgear(0)=class'DH_USPlayers.DH_AmericanHelmet82ndEMa'
    Headgear(1)=class'DH_USPlayers.DH_AmericanHelmet82ndEMb'
    Limit=1
}

//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_USAntiTank82nd extends DH_US_82nd_Airborne;

defaultproperties
{
    bIsATGunner=true
    MyName="Anti-Tank Soldier"
    AltName="Anti-Tank Soldier"
    Article="an "
    PluralName="Anti-Tank Soldiers"
    MenuImage=texture'DHUSCharactersTex.Icons.ABAT'
    Models(0)="US_82AB1"
    Models(1)="US_82AB2"
    Models(2)="US_82AB3"
    bIsGunner=true
    SleeveTexture=texture'DHUSCharactersTex.Sleeves.USAB_sleeves'
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_M1CarbineWeapon',AssociatedAttachment=class'DH_Weapons.DH_M1CarbineAmmoPouch')
    PrimaryWeapons(1)=(Item=class'DH_Weapons.DH_GreaseGunWeapon',AssociatedAttachment=class'DH_Weapons.DH_ThompsonAmmoPouch')
    SecondaryWeapons(0)=(Item=class'DH_Weapons.DH_ColtM1911Weapon')
    Grenades(0)=(Item=class'DH_Equipment.DH_USSmokeGrenadeWeapon')
    GivenItems(0)="DH_ATWeapons.DH_BazookaWeapon"
    Headgear(0)=class'DH_USPlayers.DH_AmericanHelmet82ndEMa'
    Headgear(1)=class'DH_USPlayers.DH_AmericanHelmet82ndEMb'
    PrimaryWeaponType=WT_SMG
    Limit=1
}

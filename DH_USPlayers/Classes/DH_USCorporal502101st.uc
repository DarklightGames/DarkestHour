//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_USCorporal502101st extends DH_US_502PIR;

defaultproperties
{
    MyName="Corporal"
    AltName="Corporal"
    Article="a "
    PluralName="Corporals"
    MenuImage=texture'DHUSCharactersTex.Icons.IconCorporal'
    Models(0)="US_502101AB1"
    Models(1)="US_502101AB2"
    Models(2)="US_502101AB3"
    SleeveTexture=texture'DHUSCharactersTex.Sleeves.USAB_sleeves'
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_M1GarandWeapon',Amount=6,AssociatedAttachment=class'DH_Weapons.DH_M1GarandAmmoPouch')
    SecondaryWeapons(0)=(Item=class'DH_Weapons.DH_ColtM1911Weapon',Amount=1)
    Grenades(0)=(Item=class'DH_Weapons.DH_M1GrenadeWeapon',Amount=2)
    Grenades(1)=(Item=class'DH_Equipment.DH_USSmokeGrenadeWeapon',Amount=1)
    Headgear(0)=class'DH_USPlayers.DH_AmericanHelmet502101stEMa'
    Headgear(1)=class'DH_USPlayers.DH_AmericanHelmet502101stEMb'
    PrimaryWeaponType=WT_SemiAuto
    Limit=2
}
ass'DH_Equipment.DH_USSmokeGrenadeWeapon',Amount=1)
    Headgear(0)=class'DH_USPlayers.DH_AmericanHelmet502101stEMa'
    Headgear(1)=class'DH_USPlayers.DH_AmericanHelmet502101stEMb'
    PrimaryWeaponType=WT_SemiAuto
    Limit=2
}

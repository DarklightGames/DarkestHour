//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_USRadioOperator2ndR extends DH_US_2ndRangersBattalion;

defaultproperties
{
    RolePawns(0)=(PawnClass=class'DH_USPlayers.DH_USRadio2ndRPawn',Weight=1.0)
    RolePawns(1)=(PawnClass=none,Weight=0.0)
    MyName="Radio Operator"
    AltName="Radio Operator"
    Article="a "
    PluralName="Radio Operators"
    SleeveTexture=texture'DHUSCharactersTex.Sleeves.US_sleeves'
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_M1CarbineWeapon',AssociatedAttachment=class'DH_Weapons.DH_M1CarbineAmmoPouch')
    PrimaryWeapons(1)=(Item=class'DH_Weapons.DH_GreaseGunWeapon',AssociatedAttachment=class'DH_Weapons.DH_ThompsonAmmoPouch')
    Grenades(0)=(Item=class'DH_Weapons.DH_M1GrenadeWeapon')
    GivenItems(0)="DH_Equipment.DHRadioItem"
    Headgear(0)=class'DH_USPlayers.DH_AmericanHelmet2ndREMa'
    Headgear(1)=class'DH_USPlayers.DH_AmericanHelmet2ndREMb'
    PrimaryWeaponType=WT_SemiAuto
    Limit=1
}

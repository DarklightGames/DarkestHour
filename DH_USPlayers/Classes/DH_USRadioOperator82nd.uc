//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_USRadioOperator82nd extends DH_US_82nd_Airborne;

defaultproperties
{
    MyName="Radio Operator"
    AltName="Radio Operator"
    Article="a "
    PluralName="Radio Operators"
    InfoText="The radio operator carries a man-packed radio and is tasked with the role of calling in artillery strikes towards targets designated by the artillery officer. Effective communication between the radio operator and the artillery officer is critical to the success of a coordinated barrage."
    MenuImage=texture'DHUSCharactersTex.Icons.IconRadOp'
    Models(0)="US_82ABRad1"
    Models(1)="US_82ABRad2"
    Models(2)="US_82ABRad3"
    SleeveTexture=texture'DHUSCharactersTex.Sleeves.USAB_sleeves'
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_M1CarbineWeapon',Amount=6,AssociatedAttachment=class'DH_Weapons.DH_M1CarbineAmmoPouch')
    PrimaryWeapons(1)=(Item=class'DH_Weapons.DH_GreaseGunWeapon',Amount=6,AssociatedAttachment=class'DH_Weapons.DH_ThompsonAmmoPouch')
    Grenades(0)=(Item=class'DH_Weapons.DH_M1GrenadeWeapon',Amount=2)
    GivenItems(0)="DH_Equipment.DH_USRadioItem"
    Headgear(0)=class'DH_USPlayers.DH_AmericanHelmet82ndEMa'
    Headgear(1)=class'DH_USPlayers.DH_AmericanHelmet82ndEMb'
    PrimaryWeaponType=WT_SemiAuto
    Limit=1
}

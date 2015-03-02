//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_USrifleman3rd extends DH_US_3rd_Infantry;

defaultproperties
{
    MyName="Rifleman"
    AltName="Rifleman"
    Article="a "
    PluralName="Riflemen"
    MenuImage=texture'DHUSCharactersTex.Icons.IconGI'
    Models(0)="US_3Inf1"
    Models(1)="US_3Inf2"
    Models(2)="US_3Inf3"
    Models(3)="US_3Inf4"
    Models(4)="US_3Inf5"
    SleeveTexture=texture'DHUSCharactersTex.Sleeves.US_sleeves'
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_M1GarandWeapon',Amount=6,AssociatedAttachment=class'DH_Weapons.DH_M1GarandAmmoPouch')
    Grenades(0)=(Item=class'DH_Weapons.DH_M1GrenadeWeapon',Amount=2)
    Headgear(0)=class'DH_USPlayers.DH_AmericanHelmet3rdEMa'
    Headgear(1)=class'DH_USPlayers.DH_AmericanHelmet3rdEMb'
    PrimaryWeaponType=WT_SemiAuto
}

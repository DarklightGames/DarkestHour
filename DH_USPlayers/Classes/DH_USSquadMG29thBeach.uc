//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_USSquadMG29thBeach extends DH_US_29th_Infantry;

defaultproperties
{
    MyName="Light Machine-Gunner"
    AltName="Light Machine-Gunner"
    Article="a "
    PluralName="Light Machine-Gunners"
    MenuImage=texture'DHUSCharactersTex.Icons.IconSMG'
    Models(0)="US_29Inf1b"
    Models(1)="US_29Inf2b"
    Models(2)="US_29Inf3b"
    Models(3)="US_29Inf4b"
    Models(4)="US_29Inf5b"
    bIsGunner=true
    SleeveTexture=texture'DHUSCharactersTex.Sleeves.US_sleeves'
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_BARWeapon',AssociatedAttachment=class'DH_Weapons.DH_M1CarbineAmmoPouch')
    Headgear(0)=class'DH_USPlayers.DH_AmericanHelmet29thEMa'
    Headgear(1)=class'DH_USPlayers.DH_AmericanHelmet29thEMb'
    PrimaryWeaponType=WT_SMG
    Limit=2
}

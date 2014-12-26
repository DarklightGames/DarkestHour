//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_USRiflemanAutumn extends DH_US_Autumn_Infantry;

defaultproperties
{
    MyName="Rifleman"
    AltName="Rifleman"
    Article="a "
    PluralName="Riflemen"
    InfoText="The rifleman is the basic soldier of the battlefield that is tasked with the important role of capturing and holding objectives, as well as the defense of key positions. Armed with the standard-issue battle rifle, the rifleman’s efficiency is determined by his ability to work as a member of a larger unit."
    MenuImage=texture'DHUSCharactersTex.Icons.IconGI'
    Models(0)="US_AutumnInf1"
    Models(1)="US_AutumnInf2"
    Models(2)="US_AutumnInf3"
    Models(3)="US_AutumnInf4"
    Models(4)="US_AutumnInf5"
    SleeveTexture=texture'DHUSCharactersTex.Sleeves.US_sleeves'
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_M1GarandWeapon',Amount=6,AssociatedAttachment=class'DH_Weapons.DH_M1GarandAmmoPouch')
    Grenades(0)=(Item=class'DH_Weapons.DH_M1GrenadeWeapon',Amount=2)
    Headgear(0)=class'DH_USPlayers.DH_AmericanHelmet1stEMa'
    Headgear(1)=class'DH_USPlayers.DH_AmericanHelmet1stEMb'
    PrimaryWeaponType=WT_SemiAuto
}

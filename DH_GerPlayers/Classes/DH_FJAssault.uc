//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_FJAssault extends DH_FJ;

defaultproperties
{
    MyName="Assault Trooper"
    AltName="Stoﬂtruppe"
    Article="an "
    PluralName="Assault Troopers"
    MenuImage=texture'DHGermanCharactersTex.Icons.FJ_Ass'
    Models(0)="FJ1"
    Models(1)="FJ2"
    Models(2)="FJ3"
    Models(3)="FJ4"
    Models(4)="FJ5"
    SleeveTexture=texture'DHGermanCharactersTex.GerSleeves.FJ_Sleeve'
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_MP40Weapon',Amount=6,AssociatedAttachment=class'ROInventory.ROMP40AmmoPouch')
    SecondaryWeapons(0)=(Item=class'DH_Weapons.DH_P38Weapon',Amount=1)
    Grenades(0)=(Item=class'DH_Weapons.DH_StielGranateWeapon',Amount=2)
    Headgear(0)=class'DH_GerPlayers.DH_FJHelmetCamo1'
    Headgear(1)=class'DH_GerPlayers.DH_FJHelmetCamo2'
    Headgear(2)=class'DH_GerPlayers.DH_FJHelmetNet1'
    PrimaryWeaponType=WT_SMG
    bEnhancedAutomaticControl=true
    Limit=4
}

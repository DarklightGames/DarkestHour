//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_FJSniper extends DH_FJ;

defaultproperties
{
    MyName="Sniper"
    AltName="Scharfschütze"
    Article="a "
    PluralName="Snipers"
    MenuImage=texture'DHGermanCharactersTex.Icons.FJ_Sniper'
    Models(0)="FJ1"
    Models(1)="FJ2"
    Models(2)="FJ3"
    Models(3)="FJ4"
    Models(4)="FJ5"
    SleeveTexture=texture'DHGermanCharactersTex.GerSleeves.FJ_Sleeve'
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_Kar98ScopedWeapon',Amount=18)
    PrimaryWeapons(1)=(Item=class'DH_Weapons.DH_G43ScopedWeapon',Amount=6)
    SecondaryWeapons(0)=(Item=class'DH_Weapons.DH_P38Weapon',Amount=1)
    Headgear(0)=class'DH_GerPlayers.DH_FJHelmetCamo1'
    Headgear(1)=class'DH_GerPlayers.DH_FJHelmetCamo2'
    Headgear(2)=class'DH_GerPlayers.DH_FJHelmetNet1'
    PrimaryWeaponType=WT_Sniper
    Limit=2
}

//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_FJFireteamLeader extends DH_FJ;

defaultproperties
{
    MyName="Corporal"
    AltName="Gefreiter"
    Article="a "
    PluralName="Corporals"
    MenuImage=texture'DHGermanCharactersTex.Icons.FJ_Ftl'
    Models(0)="FJ1"
    Models(1)="FJ2"
    Models(2)="FJ3"
    Models(3)="FJ4"
    Models(4)="FJ5"
    SleeveTexture=texture'DHGermanCharactersTex.GerSleeves.FJ_Sleeve'
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_MP40Weapon',AssociatedAttachment=class'ROInventory.ROMP40AmmoPouch')
    PrimaryWeapons(1)=(Item=class'DH_Weapons.DH_FG42Weapon')
    PrimaryWeapons(2)=(Item=class'DH_Weapons.DH_G41Weapon',AssociatedAttachment=class'ROInventory.ROG43AmmoPouch')
    SecondaryWeapons(0)=(Item=class'DH_Weapons.DH_P38Weapon')
    SecondaryWeapons(1)=(Item=class'DH_Weapons.DH_P08LugerWeapon')
    Grenades(0)=(Item=class'DH_Weapons.DH_StielGranateWeapon')
    Headgear(0)=class'DH_GerPlayers.DH_FJHelmet1'
    Headgear(1)=class'DH_GerPlayers.DH_FJHelmet2'
    Headgear(2)=class'DH_GerPlayers.DH_FJHelmetNet1'
    Limit=1
    Limit33to44=2
    LimitOver44=2
}

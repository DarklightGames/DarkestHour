//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_BritishLanceCorporalHampshires extends DH_Hampshires;

defaultproperties
{
    MyName="Lance Corporal"
    AltName="Lance Corporal"
    Article="a "
    PluralName="Lance Corporals"
    MenuImage=texture'DHBritishCharactersTex.Icons.Brit_LanceCorporal'
    Models(0)="Hamp_1"
    Models(1)="Hamp_2"
    Models(2)="Hamp_3"
    Models(3)="Hamp_4"
    Models(4)="Hamp_5"
    Models(5)="Hamp_6"
    SleeveTexture=texture'DHBritishCharactersTex.Sleeves.brit_sleeves'
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_StenMkIIWeapon')
    PrimaryWeapons(1)=(Item=class'DH_Weapons.DH_ThompsonWeapon')
    Grenades(0)=(Item=class'DH_Weapons.DH_M1GrenadeWeapon')
    Grenades(1)=(Item=class'DH_Equipment.DH_USSmokeGrenadeWeapon')
    Headgear(0)=class'DH_BritishPlayers.DH_BritishTurtleHelmet'
    Headgear(1)=class'DH_BritishPlayers.DH_BritishTurtleHelmetNet'
    Headgear(2)=class'DH_BritishPlayers.DH_BritishTommyHelmet'
    Limit=2
}

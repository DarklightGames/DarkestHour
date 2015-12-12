//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_BritishLanceCorporalOx_Bucks extends DH_Ox_Bucks;

defaultproperties
{
    MyName="Lance Corporal"
    AltName="Lance Corporal"
    Article="a "
    PluralName="Lance Corporals"
    MenuImage=texture'DHBritishCharactersTex.Icons.Brit_LanceCorporal'
    Models(0)="para1"
    Models(1)="para2"
    Models(2)="para3"
    Models(3)="para4"
    Models(4)="para5"
    Models(5)="para6"
    SleeveTexture=texture'DHBritishCharactersTex.Sleeves.Brit_Para_sleeves'
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_EnfieldNo4Weapon')
    PrimaryWeapons(1)=(Item=class'DH_Weapons.DH_StenMkIIWeapon')
    PrimaryWeapons(2)=(Item=class'DH_Weapons.DH_ThompsonWeapon')
    SecondaryWeapons(0)=(Item=class'DH_Weapons.DH_EnfieldNo2Weapon')
    Grenades(0)=(Item=class'DH_Weapons.DH_M1GrenadeWeapon')
    Grenades(1)=(Item=class'DH_Equipment.DH_USSmokeGrenadeWeapon')
    Headgear(0)=class'DH_BritishPlayers.DH_BritishParaHelmet1'
    Headgear(1)=class'DH_BritishPlayers.DH_BritishParaHelmet2'
    Headgear(2)=class'DH_BritishPlayers.DH_BritishParaHelmet1'
    PrimaryWeaponType=WT_Rifle
    Limit=2
}

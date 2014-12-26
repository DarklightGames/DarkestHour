//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_BritishEngineerOx_Bucks extends DH_Ox_Bucks;

defaultproperties
{
    MyName="Combat Engineer"
    AltName="Combat Engineer"
    Article="a "
    PluralName="Combat Engineers"
    InfoText="The combat engineer is tasked with destroying front-line enemy obstacles and fortifications.  Geared for close quarters combat, the combat engineer is generally equipped with sub machine-guns and grenades.  For instances where enemy fortifications or obstacles are exposed to enemy fire, he is equipped with concealment smoke so he may get close enough to destroy the target."
    MenuImage=texture'DHBritishCharactersTex.Icons.Brit_Eng'
    Models(0)="para1"
    Models(1)="para2"
    Models(2)="para3"
    Models(3)="para4"
    Models(4)="para5"
    Models(5)="para6"
    SleeveTexture=texture'DHBritishCharactersTex.Sleeves.Brit_Para_sleeves'
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_StenMkIIWeapon',Amount=6)
    SecondaryWeapons(0)=(Item=class'DH_Weapons.DH_EnfieldNo2Weapon',Amount=1)
    Grenades(0)=(Item=class'DH_Weapons.DH_M1GrenadeWeapon',Amount=2)
    Grenades(1)=(Item=class'DH_Equipment.DH_USSmokeGrenadeWeapon',Amount=1)
    GivenItems(0)="DH_Equipment.DHWireCuttersItem"
    Headgear(0)=class'DH_BritishPlayers.DH_BritishParaHelmet1'
    Headgear(1)=class'DH_BritishPlayers.DH_BritishParaHelmet2'
    Headgear(2)=class'DH_BritishPlayers.DH_BritishAirborneBeretOx_Bucks'
    PrimaryWeaponType=WT_SMG
    Limit=3
}

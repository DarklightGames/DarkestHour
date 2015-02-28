//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_USPlatoonMGWinter extends DH_US_Winter_Infantry;

defaultproperties
{
    MyName="Machine-Gunner"
    AltName="Machine-Gunner"
    Article="a "
    PluralName="Machine-Gunners"
    InfoText="The machine-gunner is tasked with the tactical employment of the medium machine gun to provide direct fire support to his squad, and in many cases being its primary source of mid- and long-range firepower. Due to the medium machine gun's high rate of fire, an adequate supply of ammunition is needed to maintain a constant rate of fire, provided largely by his accompanying units."
    MenuImage=texture'DHUSCharactersTex.Icons.IconPMG'
    Models(0)="US_WinterInf1"
    Models(1)="US_WinterInf2"
    Models(2)="US_WinterInf3"
    Models(3)="US_WinterInf4"
    Models(4)="US_WinterInf5"
    bIsGunner=true
    SleeveTexture=texture'DHUSCharactersTex.Sleeves.US_sleeves'
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_30calWeapon',Amount=6)
    SecondaryWeapons(0)=(Item=class'DH_Weapons.DH_ColtM1911Weapon',Amount=1)
    Headgear(0)=class'DH_USPlayers.DH_AmericanHelmet1stEMa'
    Headgear(1)=class'DH_USPlayers.DH_AmericanHelmetWinter'
    bCarriesMGAmmo=false
    PrimaryWeaponType=WT_LMG
    Limit=1
}

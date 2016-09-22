//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_FJ45Gunner extends DH_FJ_1945;

defaultproperties
{
    MyName="Machine-Gunner"
    AltName="Maschinengewehrschütze"
    Article="a "
    PluralName="Machine-Gunners"
    bIsGunner=true

    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_MG42Weapon')
    PrimaryWeapons(1)=(Item=class'DH_Weapons.DH_MG34Weapon')
    SecondaryWeapons(0)=(Item=class'DH_Weapons.DH_P38Weapon')
    Headgear(0)=class'DH_GerPlayers.DH_FJHelmet1'
    Headgear(1)=class'DH_GerPlayers.DH_FJHelmetNet1'
    Headgear(2)=class'DH_GerPlayers.DH_FJHelmetNet2'
    Limit=2
}

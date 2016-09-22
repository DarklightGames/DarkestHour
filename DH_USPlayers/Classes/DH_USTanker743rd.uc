//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_USTanker743rd extends DH_US_743rd_TankBattalion;

defaultproperties
{
    MyName="Tank Crewman"
    AltName="Tank Crewman"
    Article="a "
    PluralName="Tank Crewmen"
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_GreaseGunWeapon')
    SecondaryWeapons(0)=(Item=class'DH_Weapons.DH_ColtM1911Weapon')
    GivenItems(0)="DH_Equipment.DHBinocularsItem"
    Headgear(0)=class'DH_USPlayers.DH_USTankerHat'
    bCanBeTankCrew=true
    Limit=3
}

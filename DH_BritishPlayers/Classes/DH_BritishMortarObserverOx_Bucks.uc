//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DH_BritishMortarObserverOx_Bucks extends DH_Ox_Bucks;

defaultproperties
{
    bIsMortarObserver=true
    MyName="Artillery Observer"
    AltName="Artillery Observer"
    Article="a "
    PluralName="Artillery Observers"
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_EnfieldNo4Weapon')
    SecondaryWeapons(0)=(Item=class'DH_Weapons.DH_EnfieldNo2Weapon')
    Grenades(0)=(Item=class'DH_Weapons.DH_M1GrenadeWeapon')
    GivenItems(0)="DH_Equipment.DHBinocularsItem"
    Headgear(0)=class'DH_BritishPlayers.DH_BritishParaHelmetOne'
    Headgear(1)=class'DH_BritishPlayers.DH_BritishParaHelmetTwo'
    Headgear(2)=class'DH_BritishPlayers.DH_BritishParaHelmetOne'
}

//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_FJRadioman extends DH_FJ;

defaultproperties
{
    MyName="Funktruppe"
    AltName="Funktruppe"
    Article="a "
    PluralName="Funktruppen"
    MenuImage=texture'DHGermanCharactersTex.Icons.FJ_Radioman'
    Models(0)="FJ_Radio_1"
    SleeveTexture=texture'DHGermanCharactersTex.GerSleeves.FJ_Sleeve'
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_Kar98Weapon')
    GivenItems(0)="DH_Equipment.DH_GerRadioItem"
    Headgear(0)=class'DH_GerPlayers.DH_FJHelmetCamo1'
    Headgear(1)=class'DH_GerPlayers.DH_FJHelmetCamo2'
    Headgear(2)=class'DH_GerPlayers.DH_FJHelmetNet1'
    Limit=1
}

//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_FJ45Radioman extends DH_FJ_1945;

defaultproperties
{
    MyName="Radio Operator"
    AltName="Funktruppe"
    Article="a "
    PluralName="Radio Operator"
    MenuImage=texture'DHGermanCharactersTex.Icons.FJ_Radioman'
    Models(0)="FJ_Radio_1"
    SleeveTexture=texture'DHGermanCharactersTex.GerSleeves.FJ_Sleeve'
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_Kar98Weapon',Amount=18)
    SecondaryWeapons(0)=(Item=class'DH_Weapons.DH_P38Weapon',Amount=1)
    GivenItems(0)="DH_Equipment.DH_GerRadioItem"
    Headgear(0)=class'DH_GerPlayers.DH_FJHelmetCamo1'
    Headgear(1)=class'DH_GerPlayers.DH_FJHelmetCamo2'
    Headgear(2)=class'DH_GerPlayers.DH_FJHelmetNet1'
    Limit=1
}

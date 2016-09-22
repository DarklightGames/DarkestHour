//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_BritishRadioOperator extends DH_British_Infantry;

defaultproperties
{
    RolePawns(0)=(PawnClass=class'DH_BritishPlayers.DH_BritishRadioPawn',Weight=1.0)
    MyName="Radio Operator"
    AltName="Radio Operator"
    Article="a "
    PluralName="Radio Operators"
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_EnfieldNo4Weapon')
    GivenItems(0)="DH_Equipment.DHRadioItem"
    Headgear(0)=class'DH_BritishPlayers.DH_BritishTurtleHelmet'
    Headgear(1)=class'DH_BritishPlayers.DH_BritishTurtleHelmetNet'
    Headgear(2)=class'DH_BritishPlayers.DH_BritishTommyHelmet'
    Limit=1
}

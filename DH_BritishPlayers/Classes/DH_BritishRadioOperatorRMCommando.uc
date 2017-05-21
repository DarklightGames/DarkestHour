//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2017
//==============================================================================

class DH_BritishRadioOperatorRMCommando extends DH_RoyalMarineCommandos;

defaultproperties
{
    RolePawns(0)=(PawnClass=class'DH_BritishPlayers.DH_BritishRadioRMCommandoPawn')
    MyName="Radio Operator"
    AltName="Radio Operator"
    Article="a "
    PluralName="Radio Operators"
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_EnfieldNo4Weapon')
    GivenItems(0)="DH_Equipment.DHRadioItem"
    Headgear(0)=class'DH_BritishPlayers.DH_BritishRMCommandoBeret'
    Limit=1
}

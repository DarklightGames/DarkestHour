//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_CanadianRadioOperatorRoyalNewBrunswicks extends DH_RoyalNewBrunswicks;

function class<ROHeadgear> GetHeadgear()
{
    if (FRand() < 0.2)
    {
        if (FRand() < 0.5)
            return Headgear[2];
        else
            return Headgear[1];
    }
    else
    {
        return Headgear[0];
    }
}

defaultproperties
{
    MyName="Radio Operator"
    AltName="Radio Operator"
    Article="a "
    PluralName="Radio Operators"
    InfoText="The radio operator carries a man-packed radio and is tasked with the role of calling in artillery strikes towards targets designated by the artillery officer. Effective communication between the radio operator and the artillery officer is critical to the success of a coordinated barrage."
    MenuImage=texture'DHCanadianCharactersTex.Icons.Can_RadOp'
    Models(0)="RNB_Rad1"
    Models(1)="RNB_Rad2"
    Models(2)="RNB_Rad3"
    SleeveTexture=texture'DHCanadianCharactersTex.Sleeves.CanadianSleeves'
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_EnfieldNo4Weapon',Amount=6)
    GivenItems(0)="DH_Equipment.DH_USRadioItem"
    Headgear(0)=class'DH_BritishPlayers.DH_BritishTurtleHelmet'
    Headgear(1)=class'DH_BritishPlayers.DH_BritishTurtleHelmetNet'
    Headgear(2)=class'DH_BritishPlayers.DH_BritishTommyHelmet'
    PrimaryWeaponType=WT_SemiAuto
    Limit=1
}

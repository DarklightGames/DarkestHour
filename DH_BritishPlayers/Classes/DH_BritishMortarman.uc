//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_BritishMortarman extends DH_British_Infantry;

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
        return Headgear[0];
}

defaultproperties
{
     bCanUseMortars=true
     bCarriesMortarAmmo=false
     MyName="Mortar Operator"
     AltName="Mortar Operator"
     Article="a "
     PluralName="Mortar Operators"
     InfoText="The mortar operator is tasked with providing indirect fire on distant targets using his medium mortar.  The mortar operator should work closely with a mortar observer to accurately bombard targets out of visual range.||* Targets marked by the mortar observer will appear on your situation map.|* Rounds that land near the marked target will appear on your situation map."
     MenuImage=Texture'DHBritishCharactersTex.Icons.Brit_MortarOperator'
     Models(0)="PBI_1"
     Models(1)="PBI_2"
     Models(2)="PBI_3"
     Models(3)="PBI_4"
     Models(4)="PBI_5"
     Models(5)="PBI_6"
     SleeveTexture=Texture'DHBritishCharactersTex.Sleeves.brit_sleeves'
     PrimaryWeapons(0)=(Item=Class'DH_Weapons.DH_EnfieldNo4Weapon',Amount=6)
     GivenItems(0)="DH_Mortars.DH_M2MortarWeapon"
     GivenItems(1)="DH_Equipment.DH_USBinocularsItem"
     Headgear(0)=Class'DH_BritishPlayers.DH_BritishTurtleHelmet'
     Headgear(1)=Class'DH_BritishPlayers.DH_BritishTurtleHelmetNet'
     Headgear(2)=Class'DH_BritishPlayers.DH_BritishTommyHelmet'
     Limit=1
}

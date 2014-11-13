//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_USMortarmanWinter extends DH_US_Winter_Infantry;

function class<ROHeadgear> GetHeadgear()
{
    if (FRand() < 0.2)
        return Headgear[0];
    else
        return Headgear[1];
}

defaultproperties
{
     bCanUseMortars=true
     bCarriesMortarAmmo=false
     MyName="Mortar Operator"
     AltName="Mortar Operator"
     Article="a "
     PluralName="Mortar Operators"
     InfoText="The mortar operator is tasked with providing indirect fire on distant targets using his medium mortar.  The mortar operator should work closely with a mortar observer to accurately bombard targets out of visual range.||* Targets marked by a mortar observer will appear on your situation map.|* Rounds that land near the marked target will appear on your situation map."
     MenuImage=Texture'DHUSCharactersTex.Icons.IconMortarOperator'
     Models(0)="US_WinterInf1"
     Models(1)="US_WinterInf2"
     Models(2)="US_WinterInf3"
     Models(3)="US_WinterInf4"
     Models(4)="US_WinterInf5"
     SleeveTexture=Texture'DHUSCharactersTex.Sleeves.US_sleeves'
     PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_M1CarbineWeapon',Amount=6,AssociatedAttachment=class'DH_Weapons.DH_M1CarbineAmmoPouch')
     GivenItems(0)="DH_Mortars.DH_M2MortarWeapon"
     GivenItems(1)="DH_Equipment.DH_USBinocularsItem"
     Headgear(0)=class'DH_USPlayers.DH_AmericanHelmet1stEMa'
     Headgear(1)=class'DH_USPlayers.DH_AmericanHelmetWinter'
     PrimaryWeaponType=WT_SemiAuto
     Limit=1
}

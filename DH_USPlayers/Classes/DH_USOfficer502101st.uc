//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_USOfficer502101st extends DH_US_502PIR;

function class<ROHeadgear> GetHeadgear()
{
    if (FRand() < 0.2)
        return Headgear[0];
    else
        return Headgear[1];
}

defaultproperties
{
     bIsArtilleryOfficer=true
     MyName="Artillery Officer"
     AltName="Artillery Officer"
     Article="an "
     PluralName="Artillery Officers"
     InfoText="The artillery officer is tasked with directing artillery fire upon the battlefield through the use of long-range observation. Coordinating his efforts with a radio operator, he is able to target locations for off-grid artillery to lay down a  barrage with devastating effect."
     MenuImage=Texture'DHUSCharactersTex.Icons.ABOf'
     Models(0)="US_502101ABOf1"
     Models(1)="US_502101ABOf2"
     Models(2)="US_502101ABOf3"
     SleeveTexture=Texture'DHUSCharactersTex.Sleeves.USAB_sleeves'
     PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_M1CarbineWeapon',Amount=6,AssociatedAttachment=class'DH_Weapons.DH_M1CarbineAmmoPouch')
     SecondaryWeapons(0)=(Item=class'DH_Weapons.DH_ColtM1911Weapon',Amount=1)
     GivenItems(0)="DH_Equipment.DH_USArtyBinocularsItem"
     Headgear(0)=class'DH_USPlayers.DH_AmericanHelmet502101stOfficera'
     Headgear(1)=class'DH_USPlayers.DH_AmericanHelmet502101stOfficerb'
     PrimaryWeaponType=WT_SMG
     bEnhancedAutomaticControl=true
     Limit=1
}

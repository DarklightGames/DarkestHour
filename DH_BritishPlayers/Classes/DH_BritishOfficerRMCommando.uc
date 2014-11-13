//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_BritishOfficerRMCommando extends DH_RoyalMarineCommandos;

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
     bIsArtilleryOfficer=true
     MyName="Artillery Officer"
     AltName="Artillery Officer"
     Article="an "
     PluralName="Artillery Officers"
     InfoText="The artillery officer is tasked with directing artillery fire upon the battlefield through the use of long-range observation. Coordinating his efforts with a radio operator, he is able to target locations for off-grid artillery to lay down a  barrage with devastating effect."
     MenuImage=Texture'DHBritishCharactersTex.Icons.Brit_Off'
     Models(0)="RMCOf1"
     Models(1)="RMCOf2"
     Models(2)="RMCOf3"
     SleeveTexture=Texture'DHBritishCharactersTex.Sleeves.brit_sleeves'
     PrimaryWeapons(0)=(Item=Class'DH_Weapons.DH_EnfieldNo4Weapon',Amount=6)
     SecondaryWeapons(0)=(Item=Class'DH_Weapons.DH_EnfieldNo2Weapon',Amount=1)
     GivenItems(0)="DH_Equipment.DH_USArtyBinocularsItem"
     Headgear(0)=Class'DH_BritishPlayers.DH_BritishTommyHelmet'
     Headgear(1)=Class'DH_BritishPlayers.DH_BritishRMCommandoBeret'
     Headgear(2)=Class'DH_BritishPlayers.DH_BritishRMCommandoBeret'
     PrimaryWeaponType=WT_SMG
     bEnhancedAutomaticControl=true
     Limit=1
}

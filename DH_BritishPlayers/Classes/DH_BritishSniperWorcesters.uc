//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_BritishSniperWorcesters extends DH_Worcesters;

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
     MyName="Sniper"
     AltName="Sniper"
     Article="a "
     PluralName="Snipers"
     InfoText="The sniper is tasked with the specialized goal of eliminating key hostile units and shaking enemy morale through careful marksmanship and fieldcraft.  Through patient observation, the sniper is also capable of providing valuable reconnaissance which can have a significant impact on the outcome of the battle."
     MenuImage=Texture'DHBritishCharactersTex.Icons.Brit_Snip'
     Models(0)="Wor_1"
     Models(1)="Wor_2"
     Models(2)="Wor_3"
     Models(3)="Wor_4"
     Models(4)="Wor_5"
     Models(5)="Wor_6"
     SleeveTexture=Texture'DHBritishCharactersTex.Sleeves.brit_sleeves'
     PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_EnfieldNo4ScopedWeapon',Amount=18)
     SecondaryWeapons(0)=(Item=class'DH_Weapons.DH_EnfieldNo2Weapon',Amount=1)
     Grenades(0)=(Item=class'DH_Weapons.DH_M1GrenadeWeapon',Amount=2)
     GivenItems(0)="DH_Equipment.DH_USBinocularsItem"
     Headgear(0)=class'DH_BritishPlayers.DH_BritishTurtleHelmet'
     Headgear(1)=class'DH_BritishPlayers.DH_BritishTurtleHelmetNet'
     Headgear(2)=class'DH_BritishPlayers.DH_BritishTommyHelmet'
     PrimaryWeaponType=WT_Sniper
     Limit=2
}

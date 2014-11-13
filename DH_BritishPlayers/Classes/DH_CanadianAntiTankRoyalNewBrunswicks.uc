//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_CanadianAntiTankRoyalNewBrunswicks extends DH_RoyalNewBrunswicks;

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
     bIsATGunner=true
     bCarriesATAmmo=false
     MyName="Tank Hunter"
     AltName="Tank Hunter"
     Article="an "
     PluralName="Tank Hunters"
     InfoText="The tank hunter is tasked with locating and destroying or disabling enemy vehicles.  Armed with close-range anti-tank weaponry, he must often get dangerously close to his target in order to assure a hit.  His weaponry can also be effective against enemy fortifications."
     MenuImage=Texture'DHCanadianCharactersTex.Icons.Can_AT'
     Models(0)="RNB_1"
     Models(1)="RNB_2"
     Models(2)="RNB_3"
     Models(3)="RNB_4"
     Models(4)="RNB_5"
     Models(5)="RNB_6"
     SleeveTexture=Texture'DHCanadianCharactersTex.Sleeves.CanadianSleeves'
     PrimaryWeapons(0)=(Item=Class'DH_Weapons.DH_StenMkIIWeapon',Amount=6)
     Grenades(0)=(Item=Class'DH_Weapons.DH_M1GrenadeWeapon',Amount=1)
     Grenades(1)=(Item=Class'DH_Equipment.DH_USSmokeGrenadeWeapon',Amount=1)
     GivenItems(0)="DH_ATWeapons.DH_PIATWeapon"
     Headgear(0)=Class'DH_BritishPlayers.DH_BritishTurtleHelmet'
     Headgear(1)=Class'DH_BritishPlayers.DH_BritishTurtleHelmetNet'
     Headgear(2)=Class'DH_BritishPlayers.DH_BritishTommyHelmet'
     PrimaryWeaponType=WT_SMG
     Limit=1
}

//=============================================================================
// DH_BritishAntiTank
//=============================================================================
class DH_BritishAntiTankHampshires extends DH_Hampshires;

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
     Article="a "
     PluralName="Tank Hunters"
     InfoText="The tank hunter is tasked with locating and destroying or disabling enemy vehicles.  Armed with close-range anti-tank weaponry, he must often get dangerously close to his target in order to assure a hit.  His weaponry can also be effective against enemy fortifications."
     MenuImage=Texture'DHBritishCharactersTex.Icons.Brit_AT'
     Models(0)="Hamp_1"
     Models(1)="Hamp_2"
     Models(2)="Hamp_3"
     Models(3)="Hamp_4"
     Models(4)="Hamp_5"
     Models(5)="Hamp_6"
     SleeveTexture=Texture'DHBritishCharactersTex.Sleeves.brit_sleeves'
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

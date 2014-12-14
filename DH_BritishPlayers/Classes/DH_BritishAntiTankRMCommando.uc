//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_BritishAntiTankRMCommando extends DH_RoyalMarineCommandos;

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
    Models(0)="RMC1"
    Models(1)="RMC2"
    Models(2)="RMC3"
    Models(3)="RMC4"
    Models(4)="RMC5"
    Models(5)="RMC6"
    SleeveTexture=Texture'DHBritishCharactersTex.Sleeves.brit_sleeves'
    PrimaryWeapons(1)=(Item=class'DH_Weapons.DH_StenMkIIWeapon',Amount=6)
    Grenades(0)=(Item=class'DH_Weapons.DH_M1GrenadeWeapon',Amount=1)
    Grenades(1)=(Item=class'DH_Equipment.DH_USSmokeGrenadeWeapon',Amount=1)
    GivenItems(0)="DH_ATWeapons.DH_PIATWeapon"
    Headgear(0)=class'DH_BritishPlayers.DH_BritishTurtleHelmetNet'
    Headgear(1)=class'DH_BritishPlayers.DH_BritishTurtleHelmet'
    Headgear(2)=class'DH_BritishPlayers.DH_BritishRMCommandoBeret'
    PrimaryWeaponType=WT_SMG
    Limit=1
}

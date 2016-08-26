//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_ROGEAntiTankGreatH extends DH_ROGE_Heer_Greatcoat;

function class<ROHeadgear> GetHeadgear()
{
    if (FRand() < 0.2)
    {
        return Headgear[0];
    }
    else
    {
        return Headgear[1];
    }
}

defaultproperties
{
    bIsATGunner=True
    MyName="Tank Hunter"
    AltName="Panzerjäger"
    Article="a "
    PluralName="Tank Hunters"
    InfoText="The tank hunter is tasked with locating and destroying or disabling enemy vehicles.  Armed with close-range anti-tank weaponry, he must often get dangerously close to his target in order to assure a hit.  His weaponry can also be effective against enemy fortifications."
    menuImage=texture'DHGermanCharactersTex.Icons.Pak-soldat'
    SleeveTexture=texture'DHGermanCharactersTex.GerSleeves.Dot44Sleeve'
    PrimaryWeapons(0)=(Item=Class'DH_Weapons.DH_MP40Weapon',Amount=6,AssociatedAttachment=Class'ROInventory.ROMP40AmmoPouch')
    Grenades(0)=(Item=Class'DH_Equipment.DH_NebelGranate39Weapon',Amount=1)
    GivenItems(0)="DH_ATWeapons.DH_PanzerschreckWeapon"
    Headgear(0)=Class'DH_GerPlayers.DH_HeerHelmetThree'
    Headgear(1)=Class'DH_GerPlayers.DH_HeerHelmetTwo'
    PrimaryWeaponType=WT_SMG
    limit=1
}

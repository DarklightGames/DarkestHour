//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_WHAntiTankC extends DH_HeerCamo;

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
     bIsATGunner=true
     bCarriesATAmmo=false
     MyName="Tank Hunter"
     AltName="Panzerjäger"
     Article="a "
     PluralName="Tank Hunters"
     InfoText="The tank hunter is tasked with locating and destroying or disabling enemy vehicles.  Armed with close-range anti-tank weaponry, he must often get dangerously close to his target in order to assure a hit.  His weaponry can also be effective against enemy fortifications."
     MenuImage=Texture'DHGermanCharactersTex.Icons.Pak-soldat'
     Models(0)="WH_C1"
     Models(1)="WH_C2"
     Models(2)="WH_C3"
     Models(3)="WH_C4"
     Models(4)="WH_C5"
     Models(5)="WH_C6"
     SleeveTexture=Texture'Weapons1st_tex.Arms.german_sleeves'
     PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_MP40Weapon',Amount=6,AssociatedAttachment=class'ROInventory.ROMP40AmmoPouch')
     Grenades(0)=(Item=class'DH_Equipment.DH_NebelGranate39Weapon',Amount=1)
     GivenItems(0)="DH_ATWeapons.DH_PanzerschreckWeapon"
     Headgear(0)=class'DH_GerPlayers.DH_HeerHelmetOne'
     Headgear(1)=class'DH_GerPlayers.DH_HeerHelmetTwo'
     PrimaryWeaponType=WT_SMG
     Limit=1
}

// *************************************************************************
//
//  ***   DHHeerAntiTank  ***
//
// *************************************************************************


class DH_WHAntiTank_Snow extends DH_HeerSnow;

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
     Models(0)="WHS_1"
     Models(1)="WHS_2"
     Models(2)="WHS_3"
     Models(3)="WHS_4"
     Models(4)="WHS_5"
     Models(5)="WHS_6"
     SleeveTexture=Texture'Weapons1st_tex.Arms.RussianSnow_Sleeves'
     PrimaryWeapons(0)=(Item=Class'DH_Weapons.DH_MP40Weapon',Amount=6,AssociatedAttachment=Class'ROInventory.ROMP40AmmoPouch')
     Grenades(0)=(Item=Class'DH_Equipment.DH_NebelGranate39Weapon',Amount=1)
     GivenItems(0)="DH_ATWeapons.DH_PanzerschreckWeapon"
     Headgear(0)=Class'DH_GerPlayers.DH_HeerHelmetCover'
     Headgear(1)=Class'DH_GerPlayers.DH_HeerHelmetSnow'
     PrimaryWeaponType=WT_SMG
     Limit=1
}

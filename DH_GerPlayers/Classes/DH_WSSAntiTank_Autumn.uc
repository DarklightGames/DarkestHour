// *************************************************************************
//
//  ***   DHWSSAntiTank  ***
//
// *************************************************************************

class DH_WSSAntiTank_Autumn extends DH_WaffenSSAutumn;

function class<ROHeadgear> GetHeadgear()
{
    if (FRand() < 0.2)
        return Headgear[0];
    else
        return Headgear[1];
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
     MenuImage=Texture'DHGermanCharactersTex.Icons.WSS_AT'
     Models(0)="SSA_1"
     Models(1)="SSA_2"
     Models(2)="SSA_3"
     Models(3)="SSA_4"
     Models(4)="SSA_5"
     Models(5)="SSA_6"
     SleeveTexture=Texture'DHGermanCharactersTex.GerSleeves.Dot44Sleeve'
     PrimaryWeapons(0)=(Item=Class'DH_Weapons.DH_MP40Weapon',Amount=6,AssociatedAttachment=Class'ROInventory.ROMP40AmmoPouch')
     PrimaryWeapons(1)=(Item=Class'DH_Weapons.DH_G43Weapon',Amount=9,AssociatedAttachment=Class'ROInventory.ROG43AmmoPouch')
     Grenades(0)=(Item=Class'DH_Equipment.DH_NebelGranate39Weapon',Amount=1)
     GivenItems(0)="DH_ATWeapons.DH_PanzerschreckWeapon"
     Headgear(0)=Class'DH_GerPlayers.DH_SSHelmetCover'
     Headgear(1)=Class'DH_GerPlayers.DH_SSHelmetNoCover'
     PrimaryWeaponType=WT_SMG
     Limit=1
}

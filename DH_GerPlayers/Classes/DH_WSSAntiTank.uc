//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_WSSAntiTank extends DH_WaffenSS;

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
     Models(0)="SS_1"
     Models(1)="SS_2"
     Models(2)="SS_3"
     Models(3)="SS_4"
     Models(4)="SS_5"
     Models(5)="SS_6"
     SleeveTexture=Texture'DHGermanCharactersTex.GerSleeves.Dot44Sleeve'
     PrimaryWeapons(0)=(Item=Class'DH_Weapons.DH_MP40Weapon',Amount=6,AssociatedAttachment=Class'ROInventory.ROMP40AmmoPouch')
     PrimaryWeapons(1)=(Item=Class'DH_Weapons.DH_G43Weapon',Amount=9,AssociatedAttachment=Class'ROInventory.ROG43AmmoPouch')
     Grenades(0)=(Item=Class'DH_Equipment.DH_NebelGranate39Weapon',Amount=1)
     GivenItems(0)="DH_ATWeapons.DH_PanzerschreckWeapon"
     Headgear(0)=Class'DH_GerPlayers.DH_SSHelmetOne'
     Headgear(1)=Class'DH_GerPlayers.DH_SSHelmetTwo'
     PrimaryWeaponType=WT_SMG
     Limit=1
}

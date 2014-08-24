// *************************************************************************
//
//  ***   FJ AntiTank   ***
//
// *************************************************************************


class DH_FJAntiTank extends DH_FJ;

function class<ROHeadgear> GetHeadgear()
{
    local int RandNum;
    RandNum = Rand(3);

    switch (RandNum)
    {
        case 0:
             return Headgear[0];
        case 1:
             return Headgear[1];
        case 2:
             return Headgear[2];
        default:
             return Headgear[0];
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
     MenuImage=Texture'DHGermanCharactersTex.Icons.FJ_AT'
     Models(0)="FJ1"
     Models(1)="FJ2"
     Models(2)="FJ3"
     Models(3)="FJ4"
     Models(4)="FJ5"
     SleeveTexture=Texture'DHGermanCharactersTex.GerSleeves.FJ_Sleeve'
     PrimaryWeapons(0)=(Item=Class'DH_Weapons.DH_MP40Weapon',Amount=6,AssociatedAttachment=Class'ROInventory.ROMP40AmmoPouch')
     SecondaryWeapons(0)=(Item=Class'DH_Weapons.DH_P38Weapon',Amount=1)
     Grenades(0)=(Item=Class'DH_Equipment.DH_NebelGranate39Weapon',Amount=1)
     GivenItems(0)="DH_ATWeapons.DH_PanzerschreckWeapon"
     Headgear(0)=Class'DH_GerPlayers.DH_FJHelmetCamo1'
     Headgear(1)=Class'DH_GerPlayers.DH_FJHelmetCamo2'
     Headgear(2)=Class'DH_GerPlayers.DH_FJHelmetNet1'
     PrimaryWeaponType=WT_SMG
     Limit=1
}

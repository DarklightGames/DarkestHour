// *************************************************************************
//
//  ***   WK AntiTank ***
//
// *************************************************************************


class DH_WKAntiTank extends DH_Kriegsmarine;

defaultproperties
{
     bIsATGunner=true
     bCarriesATAmmo=false
     MyName="Anti-tank soldier"
     AltName="PaK-Soldat"
     Article="an "
     PluralName="Anti-tank soldiers"
     InfoText="PaK-Soldat - Difficulty: Advanced||The Panzerschreck, or 'Tank Shocker', was developed by the Germans based off the captured American 'Bazooka'. Firing a sizeable 8.8cm rocket, it's a serious threat to any and all Allied armour."
     menuImage=Texture'DHGermanCharactersTex.Icons.Pak-soldat'
     Models(0)="WK_1"
     Models(1)="WK_2"
     Models(2)="WK_3"
     Models(3)="WK_4"
     SleeveTexture=Texture'Weapons1st_tex.Arms.german_sleeves'
     PrimaryWeapons(0)=(Item=Class'DH_Weapons.DH_MP40Weapon',Amount=6,AssociatedAttachment=Class'ROInventory.ROMP40AmmoPouch')
     GivenItems(0)="DH_ATWeapons.DH_PanzerschreckWeapon"
     Headgear(0)=Class'DH_GerPlayers.DH_KriegsmarineHelmet'
     PrimaryWeaponType=WT_SMG
     limit=2
}

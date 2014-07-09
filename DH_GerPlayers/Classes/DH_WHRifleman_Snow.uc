// *************************************************************************
//
//	***   Heer Rifleman   ***
//
// *************************************************************************

class DH_WHRifleman_Snow extends DH_HeerSnow;

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
     MyName="Rifleman"
     AltName="Schütze"
     Article="a "
     PluralName="Riflemen"
     InfoText="The rifleman is the basic soldier of the battlefield that is tasked with the important role of capturing and holding objectives, as well as the defense of key positions. Armed with the standard-issue battle rifle, the rifleman's efficiency is determined by his ability to work as a member of a larger unit."
     menuImage=Texture'InterfaceArt_tex.SelectMenus.Schutze'
     Models(0)="WHS_1"
     Models(1)="WHS_2"
     Models(2)="WHS_3"
     Models(3)="WHS_4"
     Models(4)="WHS_5"
     Models(5)="WHS_6"
     SleeveTexture=Texture'Weapons1st_tex.Arms.RussianSnow_Sleeves'
     PrimaryWeapons(0)=(Item=Class'DH_Weapons.DH_Kar98Weapon',Amount=18,AssociatedAttachment=Class'ROInventory.ROKar98AmmoPouch')
     Grenades(0)=(Item=Class'DH_Weapons.DH_StielGranateWeapon',Amount=2)
     Headgear(0)=Class'DH_GerPlayers.DH_HeerHelmetCover'
     Headgear(1)=Class'DH_GerPlayers.DH_HeerHelmetSnow'
}

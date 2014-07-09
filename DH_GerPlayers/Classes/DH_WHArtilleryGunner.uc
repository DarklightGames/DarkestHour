// *************************************************************************
//
//	***   WH Artillery Gunner   ***
//
// *************************************************************************

class DH_WHArtilleryGunner extends DH_HeerArtilleryCrew;

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
     MyName="Artillery Gunner"
     AltName="Artillerie Schütze"
     Article="a "
     PluralName="Artillery Gunners"
     InfoText="Artillerie Schütze||The artillery gunner is a specialized role, requiring specialized training. ||Only artillery crew can use artillery"
     menuImage=Texture'InterfaceArt_tex.SelectMenus.Schutze'
     Models(0)="WHA_1"
     Models(1)="WHA_2"
     Models(2)="WHA_3"
     Models(3)="WHA_4"
     SleeveTexture=Texture'Weapons1st_tex.Arms.german_sleeves'
     PrimaryWeapons(0)=(Item=Class'DH_Weapons.DH_Kar98Weapon',Amount=18,AssociatedAttachment=Class'ROInventory.ROKar98AmmoPouch')
     SecondaryWeapons(0)=(Item=Class'DH_Weapons.DH_P38Weapon',Amount=1)
     Headgear(0)=Class'DH_GerPlayers.DH_HeerHelmetThree'
     Headgear(1)=Class'DH_GerPlayers.DH_HeerHelmetTwo'
     bCanBeTankCrew=True
     limit=5
}

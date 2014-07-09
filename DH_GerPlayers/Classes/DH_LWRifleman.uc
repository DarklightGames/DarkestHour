// *************************************************************************
//
//	***   DH_LWRifleman   ***
//
// *************************************************************************

class DH_LWRifleman extends DH_LuftwaffeFlak;

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
     InfoText="Schütze||The Schütze is the main-stay of the German infantry platoon.  He is tasked with the vital role of taking and holding ground.  Using his standard issue rifle, he can effectively engage the enemy at moderate to long range."
     menuImage=Texture'InterfaceArt_tex.SelectMenus.Schutze'
     Models(0)="WL_1"
     Models(1)="WL_2"
     Models(2)="WL_3"
     Models(3)="WL_4"
     SleeveTexture=Texture'DHGermanCharactersTex.GerSleeves.FJ_Sleeve'
     PrimaryWeapons(0)=(Item=Class'DH_Weapons.DH_Kar98Weapon',Amount=18,AssociatedAttachment=Class'ROInventory.ROKar98AmmoPouch')
     Headgear(0)=Class'DH_GerPlayers.DH_LWHelmet'
     Headgear(1)=Class'DH_GerPlayers.DH_LWHelmetTwo'
}

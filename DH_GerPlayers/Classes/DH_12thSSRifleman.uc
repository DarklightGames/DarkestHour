// *************************************************************************
//
//	***   SS Rifleman   ***
//
// *************************************************************************

class DH_12thSSRifleman extends DH_12thSS;

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
     menuImage=Texture'DHGermanCharactersTex.Icons.WSS_k98'
     Models(0)="12SS_1"
     Models(1)="12SS_2"
     Models(2)="12SS_3"
     Models(3)="12SS_4"
     Models(4)="12SS_5"
     Models(5)="12SS_6"
     SleeveTexture=Texture'DHGermanCharactersTex.GerSleeves.12thSS_Sleeve'
     PrimaryWeapons(0)=(Item=Class'DH_Weapons.DH_Kar98Weapon',Amount=18,AssociatedAttachment=Class'ROInventory.ROKar98AmmoPouch')
     Grenades(0)=(Item=Class'DH_Weapons.DH_StielGranateWeapon',Amount=2)
     Headgear(0)=Class'DH_GerPlayers.DH_SSHelmetOne'
     Headgear(1)=Class'DH_GerPlayers.DH_SSHelmetTwo'
}

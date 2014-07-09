// *************************************************************************
//
//	***   SS Fireteam Leader ***
//
// *************************************************************************

class DH_WSSFireteamLeader_Winter extends DH_WaffenSSSnow;

function class<ROHeadgear> GetHeadgear()
{
	if (FRand() < 0.2)
		return Headgear[0];
	else
		return Headgear[1];
}

defaultproperties
{
     MyName="Fireteam Leader"
     AltName="Rottenführer"
     Article="a "
     PluralName="Fireteam Leaders"
     InfoText="The fireteam leader is the NCO tasked to coordinate his team's movement in accordance with the squad's objectives. As the direct assistant to the squad leader, he is expected to provide a comparable level of support to his men."
     menuImage=Texture'DHGermanCharactersTex.Icons.WSS_Semi'
     Models(0)="WHS_1"
     Models(1)="WHS_2"
     Models(2)="WHS_3"
     Models(3)="WHS_4"
     Models(4)="WHS_5"
     Models(5)="WHS_6"
     SleeveTexture=Texture'DHGermanCharactersTex.GerSleeves.Dot44Sleeve'
     PrimaryWeapons(0)=(Item=Class'DH_Weapons.DH_STG44Weapon',Amount=6,AssociatedAttachment=Class'ROInventory.ROSTG44AmmoPouch')
     PrimaryWeapons(1)=(Item=Class'DH_Weapons.DH_MP40Weapon',Amount=6,AssociatedAttachment=Class'ROInventory.ROMP40AmmoPouch')
     SecondaryWeapons(0)=(Item=Class'DH_Weapons.DH_P38Weapon',Amount=1)
     SecondaryWeapons(1)=(Item=Class'DH_Weapons.DH_P08LugerWeapon',Amount=1)
     Grenades(0)=(Item=Class'DH_Weapons.DH_StielGranateWeapon',Amount=2)
     Headgear(0)=Class'DH_GerPlayers.DH_HeerHelmetCover'
     Headgear(1)=Class'DH_GerPlayers.DH_HeerHelmetSnow'
     PrimaryWeaponType=WT_SMG
     bEnhancedAutomaticControl=True
     limit=1
     Limit33to44=2
     LimitOver44=2
}

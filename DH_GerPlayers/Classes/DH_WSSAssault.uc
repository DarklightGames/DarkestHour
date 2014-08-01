// *************************************************************************
//
//	***   DH_WSSAssault   ***
//
// *************************************************************************

class DH_WSSAssault extends DH_WaffenSS;

function class<ROHeadgear> GetHeadgear()
{
	if (FRand() < 0.2)
		return Headgear[0];
	else
		return Headgear[1];
}

defaultproperties
{
     MyName="Assault Trooper"
     AltName="Stoßtruppe"
     Article="an "
     PluralName="Assault Troopers"
     InfoText="The assault trooper is a specialized infantry class who is tasked with closing with the enemy and eliminating him from difficult positions such as houses and fortifications.  The assault trooper is generally better armed than most infantrymen."
     menuImage=Texture'DHGermanCharactersTex.Icons.WSS_Ass'
     Models(0)="SS_1"
     Models(1)="SS_2"
     Models(2)="SS_3"
     Models(3)="SS_4"
     Models(4)="SS_5"
     Models(5)="SS_6"
     SleeveTexture=Texture'DHGermanCharactersTex.GerSleeves.Dot44Sleeve'
     PrimaryWeapons(0)=(Item=Class'DH_Weapons.DH_STG44Weapon',Amount=6,AssociatedAttachment=Class'ROInventory.ROSTG44AmmoPouch')
     PrimaryWeapons(1)=(Item=Class'DH_Weapons.DH_MP40Weapon',Amount=6,AssociatedAttachment=Class'ROInventory.ROMP40AmmoPouch')
     Grenades(0)=(Item=Class'DH_Weapons.DH_StielGranateWeapon',Amount=2)
     Headgear(0)=Class'DH_GerPlayers.DH_SSHelmetOne'
     Headgear(1)=Class'DH_GerPlayers.DH_SSHelmetTwo'
     PrimaryWeaponType=WT_SMG
     bEnhancedAutomaticControl=true
     limit=4
}

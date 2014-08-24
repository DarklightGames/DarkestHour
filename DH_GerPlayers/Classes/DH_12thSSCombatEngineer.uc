// *************************************************************************
//
//  ***   DH_12thSSCombatEngineer   ***
//
// *************************************************************************

class DH_12thSSCombatEngineer extends DH_12thSS;

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
     MyName="Combat Engineer"
     AltName="Sturmpioniere"
     Article="a "
     PluralName="Combat Engineers"
     InfoText="The combat engineer is tasked with destroying front-line enemy obstacles and fortifications.  Geared for close quarters combat, the combat engineer is generally equipped with submachine-guns and grenades.  For instances where enemy fortifications or obstacles are exposed to enemy fire, he is equipped with concealment smoke so he may get close enough to destroy the target."
     MenuImage=Texture'DHGermanCharactersTex.Icons.WSS_Eng'
     Models(0)="12SS_1"
     Models(1)="12SS_2"
     Models(2)="12SS_3"
     Models(3)="12SS_4"
     Models(4)="12SS_5"
     Models(5)="12SS_6"
     SleeveTexture=Texture'DHGermanCharactersTex.GerSleeves.12thSS_Sleeve'
     PrimaryWeapons(0)=(Item=Class'DH_Weapons.DH_MP40Weapon',Amount=6,AssociatedAttachment=Class'ROInventory.ROMP40AmmoPouch')
     Grenades(0)=(Item=Class'DH_Weapons.DH_StielGranateWeapon',Amount=2)
     Grenades(1)=(Item=Class'DH_Equipment.DH_NebelGranate39Weapon',Amount=1)
     GivenItems(0)="DH_Weapons.DH_SatchelCharge10lb10sWeapon"
     Headgear(0)=Class'DH_GerPlayers.DH_SSHelmetOne'
     Headgear(1)=Class'DH_GerPlayers.DH_SSHelmetTwo'
     PrimaryWeaponType=WT_SMG
     Limit=1
}

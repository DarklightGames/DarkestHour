// *************************************************************************
//
//  ***   WSS Tank Comander   ***
//
// *************************************************************************

class DH_WSSTankComander extends DH_WaffenSSTankCrew;

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
     MyName="Tank Commander"
     AltName="Panzerführer"
     Article="a "
     PluralName="Tank Commanders"
     InfoText="The tank commander is primarily tasked with the operation of the main gun of the tank as well as to direct the rest of the operating crew. From his usual turret position, he is often the only crew member with an all-round view. As a commander, he is expected to lead a complete platoon of tanks as well as direct his own."
     MenuImage=Texture'DHGermanCharactersTex.Icons.WSS_TankCom'
     Models(0)="SSP_1"
     Models(1)="SSP_2"
     Models(2)="SSP_3"
     Models(3)="SSP_4"
     Models(4)="SSP_5"
     SleeveTexture=Texture'DHGermanCharactersTex.GerSleeves.Dot44Sleeve'
     DetachedArmClass=Class'ROEffects.SeveredArmGerTanker'
     DetachedLegClass=Class'ROEffects.SeveredLegGerTanker'
     PrimaryWeapons(0)=(Item=Class'DH_Weapons.DH_MP40Weapon',Amount=6,AssociatedAttachment=Class'ROInventory.ROMP40AmmoPouch')
     PrimaryWeapons(1)=(Item=Class'DH_Weapons.DH_C96Weapon',Amount=2,AssociatedAttachment=Class'DH_Weapons.DH_C96AmmoPouch')
     SecondaryWeapons(0)=(Item=Class'DH_Weapons.DH_P38Weapon',Amount=1)
     SecondaryWeapons(1)=(Item=Class'DH_Weapons.DH_P08LugerWeapon',Amount=1)
     GivenItems(0)="DH_Equipment.DH_GerBinocularsItem"
     Headgear(0)=Class'DH_GerPlayers.DH_WSSTankerCrushercap'
     Headgear(1)=Class'DH_GerPlayers.DH_SSCap'
     PrimaryWeaponType=WT_SMG
     bEnhancedAutomaticControl=true
     bCanBeTankCrew=true
     bCanBeTankCommander=true
     Limit=1
}

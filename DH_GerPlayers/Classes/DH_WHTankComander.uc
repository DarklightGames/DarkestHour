//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_WHTankComander extends DH_HeerTankCrew;

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
     MenuImage=Texture'DHGermanCharactersTex.Icons.WH_TankCom'
     Models(0)="WHP_1"
     Models(1)="WHP_2"
     Models(2)="WHP_3"
     Models(3)="WHP_4"
     Models(4)="WHP_5"
     Models(5)="WHP_6"
     SleeveTexture=Texture'Weapons1st_tex.Arms.GermanTankerSleeves'
     DetachedArmClass=Class'ROEffects.SeveredArmGerTanker'
     DetachedLegClass=Class'ROEffects.SeveredLegGerTanker'
     PrimaryWeapons(0)=(Item=Class'DH_Weapons.DH_MP40Weapon',Amount=6,AssociatedAttachment=Class'ROInventory.ROMP40AmmoPouch')
     SecondaryWeapons(0)=(Item=Class'DH_Weapons.DH_P38Weapon',Amount=1)
     SecondaryWeapons(1)=(Item=Class'DH_Weapons.DH_P08LugerWeapon',Amount=1)
     GivenItems(0)="DH_Equipment.DH_GerBinocularsItem"
     Headgear(0)=Class'DH_GerPlayers.DH_HeerTankerCrushercap'
     Headgear(1)=Class'DH_GerPlayers.DH_HeerTankerCap'
     RolePawnClass="DH_GerPlayers.DH_WH_TankerPawn"
     PrimaryWeaponType=WT_SMG
     bEnhancedAutomaticControl=true
     bCanBeTankCrew=true
     bCanBeTankCommander=true
     Limit=1
}

// *************************************************************************
//
//  ***   DH_WHReconaissanceOfficer   ***
//
// *************************************************************************

class DH_WHReconaissanceOfficer extends DH_HeerTankCrew;

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
     bCanBeReconCrew=true
     bCanBeReconOfficer=true
     bIsArtilleryOfficer=true
     MyName="Reconnaissance Commander"
     AltName="Spähwagenoffizier"
     Article="a "
     PluralName="Reconnaissance Commanders"
     InfoText="The reconnaissance commander is primarily tasked with the operation of the main gun of the armored car as well as to direct the rest of the operating crew. As the commanding officer of the scouting mission, he is capable of directing his team from within his assigned vehicle as well as while dismounted."
     MenuImage=Texture'DHGermanCharactersTex.Icons.WH_ReconOfficer'
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
     PrimaryWeapons(1)=(Item=Class'DH_Weapons.DH_C96Weapon',Amount=2,AssociatedAttachment=Class'DH_Weapons.DH_C96AmmoPouch')
     GivenItems(0)="DH_Equipment.DH_GerArtyBinocularsItem"
     Headgear(0)=Class'DH_GerPlayers.DH_HeerTankerCrushercap'
     Headgear(1)=Class'DH_GerPlayers.DH_HeerTankerCap'
     RolePawnClass="DH_GerPlayers.DH_WH_TankerPawn"
     PrimaryWeaponType=WT_SMG
     bEnhancedAutomaticControl=true
     Limit=1
}

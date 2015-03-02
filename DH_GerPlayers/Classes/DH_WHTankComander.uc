//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_WHTankComander extends DH_HeerTankCrew;

defaultproperties
{
    MyName="Tank Commander"
    AltName="Panzerführer"
    Article="a "
    PluralName="Tank Commanders"
    MenuImage=texture'DHGermanCharactersTex.Icons.WH_TankCom'
    Models(0)="WHP_1"
    Models(1)="WHP_2"
    Models(2)="WHP_3"
    Models(3)="WHP_4"
    Models(4)="WHP_5"
    Models(5)="WHP_6"
    SleeveTexture=texture'Weapons1st_tex.Arms.GermanTankerSleeves'
    DetachedArmClass=class'ROEffects.SeveredArmGerTanker'
    DetachedLegClass=class'ROEffects.SeveredLegGerTanker'
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_MP40Weapon',Amount=6,AssociatedAttachment=class'ROInventory.ROMP40AmmoPouch')
    SecondaryWeapons(0)=(Item=class'DH_Weapons.DH_P38Weapon',Amount=1)
    SecondaryWeapons(1)=(Item=class'DH_Weapons.DH_P08LugerWeapon',Amount=1)
    GivenItems(0)="DH_Engine.DH_BinocularsItem"
    Headgear(0)=class'DH_GerPlayers.DH_HeerTankerCrushercap'
    Headgear(1)=class'DH_GerPlayers.DH_HeerTankerCap'
    RolePawnClass="DH_GerPlayers.DH_WH_TankerPawn"
    PrimaryWeaponType=WT_SMG
    bEnhancedAutomaticControl=true
    bCanBeTankCrew=true
    bCanBeTankCommander=true
    Limit=1
}

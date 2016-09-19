//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_ROSU_RKK_TankCrewman extends DH_ROSU_RKK;

defaultproperties
{
    MyName="Tank Crewman"
    AltName="Ekipazh tanka"
    Article="a "
    PluralName="Tank Crewmen"
    ObjCaptureWeight=2
    PointValue=3.000000
    SleeveTexture=Texture'Weapons1st_tex.Arms.RussianTankerSleeves'
    DetachedArmClass=class'ROEffects.SeveredArmSovTanker'
    DetachedLegClass=class'ROEffects.SeveredLegSovTanker'
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_PPSH41Weapon',Amount=6,AssociatedAttachment=class'ROInventory.ROPPSh41AmmoPouch')
    SecondaryWeapons(0)=(Item=class'DH_Weapons.DH_TT33Weapon',Amount=1)
    GivenItems(0)="DH_Equipment.DHBinocularsItem"
    Headgear(0)=class'ROInventory.ROSovietTankerHat'
    RolePawnClass="DH_RUPlayers.DH_RUTankerPawn"
    PrimaryWeaponType=WT_SMG
    bEnhancedAutomaticControl=true
    bCanBeTankCrew=true
    bCanBeTankCommander=true
    limit=1
}

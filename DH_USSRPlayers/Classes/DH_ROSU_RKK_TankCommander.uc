//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_ROSU_RKK_TankCommander extends DH_ROSU_RKK;

defaultproperties
{
    MyName="Tank Commander"
    AltName="Komandir tanka"
    Article="a "
    PluralName="Tank Commanders"
    InfoText="The tank commander is primarily tasked with the operation of the main gun of the tank as well as to direct the rest of the operating crew. From his usual turret position, he is often the only crew member with an all-round view. As a commander, he is expected to lead a complete platoon of tanks as well as direct his own."
    menuImage=Texture'InterfaceArt_tex.SelectMenus.Komandirtanka'
    ObjCaptureWeight=2
    PointValue=3.000000
    SleeveTexture=Texture'Weapons1st_tex.Arms.RussianTankerSleeves'
    DetachedArmClass=Class'ROEffects.SeveredArmSovTanker'
    DetachedLegClass=Class'ROEffects.SeveredLegSovTanker'
    PrimaryWeapons(0)=(Item=class'DH_ROWeapons.DH_PPSH41Weapon',Amount=6,AssociatedAttachment=class'ROInventory.ROPPSh41AmmoPouch')
    SecondaryWeapons(0)=(Item=class'DH_ROWeapons.DH_TT33Weapon',Amount=1)
    GivenItems(0)="DH_Equipment.DH_USBinocularsItem"
    Headgear(0)=class'ROInventory.ROSovietTankerHat'
    RolePawnClass="DH_ROPlayers.DH_RUTankerPawn"
    PrimaryWeaponType=WT_SMG
    bEnhancedAutomaticControl=True
    bCanBeTankCrew=True
    bCanBeTankCommander=True
    limit=1
}

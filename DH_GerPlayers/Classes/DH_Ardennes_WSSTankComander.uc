//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_Ardennes_WSSTankComander extends DH_WaffenSSTankCrew;

defaultproperties
{
    MyName="Tank Commander"
    AltName="Panzerführer"
    Article="a "
    PluralName="Tank Commanders"
    MenuImage=texture'DHGermanCharactersTex.Icons.WSS_TankCom'
    Models(0)="Ardennes_SSP_1"
    Models(1)="Ardennes_SSP_2"
    Models(2)="Ardennes_SSP_3"
    Models(3)="Ardennes_SSP_4"
    Models(4)="Ardennes_SSP_5"
    SleeveTexture=texture'DHGermanCharactersTex.GerSleeves.Dot44Sleeve'
    DetachedArmClass=class'ROEffects.SeveredArmGerTanker'
    DetachedLegClass=class'ROEffects.SeveredLegGerTanker'
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_MP40Weapon',Amount=6,AssociatedAttachment=class'ROInventory.ROMP40AmmoPouch')
    PrimaryWeapons(1)=(Item=class'DH_Weapons.DH_C96Weapon',Amount=2,AssociatedAttachment=class'DH_Weapons.DH_C96AmmoPouch')
    SecondaryWeapons(0)=(Item=class'DH_Weapons.DH_P38Weapon',Amount=1)
    SecondaryWeapons(1)=(Item=class'DH_Weapons.DH_P08LugerWeapon',Amount=1)
    GivenItems(0)="DH_Engine.DH_BinocularsItem"
    Headgear(0)=class'DH_GerPlayers.DH_WSSTankerCrushercap'
    Headgear(1)=class'DH_GerPlayers.DH_SSCap'
    PrimaryWeaponType=WT_SMG
    bEnhancedAutomaticControl=true
    bCanBeTankCrew=true
    bCanBeTankCommander=true
    Limit=1
}
ss'DH_Weapons.DH_P08LugerWeapon',Amount=1)
    GivenItems(0)="DH_Engine.DH_BinocularsItem"
    Headgear(0)=class'DH_GerPlayers.DH_WSSTankerCrushercap'
    Headgear(1)=class'DH_GerPlayers.DH_SSCap'
    PrimaryWeaponType=WT_SMG
    bEnhancedAutomaticControl=true
    bCanBeTankCrew=true
    bCanBeTankCommander=true
    Limit=1
}

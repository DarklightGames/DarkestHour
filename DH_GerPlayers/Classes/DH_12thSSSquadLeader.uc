//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_12thSSSquadLeader extends DH_12thSS;

defaultproperties
{
    MyName="Sergeant"
    AltName="Unterscharführer"
    Article="a "
    PluralName="Sergeantss"
    Models(0)="12SS_1"
    Models(1)="12SS_2"
    Models(2)="12SS_3"
    Models(3)="12SS_4"
    Models(4)="12SS_5"
    Models(5)="12SS_6"
    bIsLeader=true
    SleeveTexture=texture'DHGermanCharactersTex.GerSleeves.12thSS_Sleeve'
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_MP40Weapon',AssociatedAttachment=class'ROInventory.ROMP40AmmoPouch')
    SecondaryWeapons(0)=(Item=class'DH_Weapons.DH_P38Weapon')
    SecondaryWeapons(1)=(Item=class'DH_Weapons.DH_P08LugerWeapon')
    Grenades(0)=(Item=class'DH_Equipment.DH_NebelGranate39Weapon')
    Grenades(1)=(Item=class'DH_Equipment.DH_OrangeSmokeWeapon')
    Headgear(0)=class'DH_GerPlayers.DH_SSHelmetOne'
    Headgear(1)=class'DH_GerPlayers.DH_SSHelmetTwo'
    PrimaryWeaponType=WT_SMG
    bEnhancedAutomaticControl=true
    Limit=1
    Limit33to44=2
    LimitOver44=2
}

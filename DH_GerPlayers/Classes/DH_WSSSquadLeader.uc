//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_WSSSquadLeader extends DH_WaffenSS;

defaultproperties
{
    bIsSquadLeader=true
    MyName="Sergeant"
    AltName="Unterscharführer"
    Article="a "
    PluralName="Sergeants"
    MenuImage=texture'DHGermanCharactersTex.Icons.WSS_SqL'
    Models(0)="SS_1"
    Models(1)="SS_2"
    Models(2)="SS_3"
    Models(3)="SS_4"
    Models(4)="SS_5"
    Models(5)="SS_6"
    bIsLeader=true
    SleeveTexture=texture'DHGermanCharactersTex.GerSleeves.Dot44Sleeve'
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_G43Weapon',AssociatedAttachment=class'ROInventory.ROG43AmmoPouch')
    PrimaryWeapons(1)=(Item=class'DH_Weapons.DH_MP40Weapon',AssociatedAttachment=class'ROInventory.ROMP40AmmoPouch')
    SecondaryWeapons(0)=(Item=class'DH_Weapons.DH_P38Weapon')
    SecondaryWeapons(1)=(Item=class'DH_Weapons.DH_P08LugerWeapon')
    Grenades(0)=(Item=class'DH_Weapons.DH_StielGranateWeapon')
    Grenades(1)=(Item=class'DH_Equipment.DH_NebelGranate39Weapon')
    Grenades(2)=(Item=class'DH_Equipment.DH_OrangeSmokeWeapon')
    Headgear(0)=class'DH_GerPlayers.DH_SSHelmetOne'
    Headgear(1)=class'DH_GerPlayers.DH_SSHelmetTwo'
    PrimaryWeaponType=WT_SemiAuto
    bEnhancedAutomaticControl=true
    Limit=1
    Limit33to44=2
    LimitOver44=2
}

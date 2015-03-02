//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_WSSSquadLeader_Autumn extends DH_WaffenSSAutumn;

defaultproperties
{
    bIsSquadLeader=true
    MyName="Squad Leader"
    AltName="Unterscharführer"
    Article="a "
    PluralName="Squad Leaders"
    MenuImage=texture'DHGermanCharactersTex.Icons.WSS_SqL'
    Models(0)="SSA_1"
    Models(1)="SSA_2"
    Models(2)="SSA_3"
    Models(3)="SSA_4"
    Models(4)="SSA_5"
    Models(5)="SSA_6"
    bIsLeader=true
    SleeveTexture=texture'DHGermanCharactersTex.GerSleeves.Dot44Sleeve'
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_G43Weapon',Amount=9,AssociatedAttachment=class'ROInventory.ROG43AmmoPouch')
    PrimaryWeapons(1)=(Item=class'DH_Weapons.DH_MP40Weapon',Amount=6,AssociatedAttachment=class'ROInventory.ROMP40AmmoPouch')
    SecondaryWeapons(0)=(Item=class'DH_Weapons.DH_P38Weapon',Amount=1)
    SecondaryWeapons(1)=(Item=class'DH_Weapons.DH_P08LugerWeapon',Amount=1)
    Grenades(0)=(Item=class'DH_Weapons.DH_StielGranateWeapon',Amount=2)
    Grenades(1)=(Item=class'DH_Equipment.DH_NebelGranate39Weapon',Amount=1)
    Grenades(2)=(Item=class'DH_Equipment.DH_OrangeSmokeWeapon',Amount=1)
    Headgear(0)=class'DH_GerPlayers.DH_SSHelmetOne'
    Headgear(1)=class'DH_GerPlayers.DH_SSHelmetTwo'
    PrimaryWeaponType=WT_SemiAuto
    bEnhancedAutomaticControl=true
    Limit=1
    Limit33to44=2
    LimitOver44=2
}

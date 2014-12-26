//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_WSSSquadLeader_Snow extends DH_WaffenSSSnow;

defaultproperties
{
    bIsSquadLeader=true
    MyName="Squad Leader"
    AltName="Unterscharführer"
    Article="a "
    PluralName="Squad Leaders"
    InfoText="The squad leader is tasked with overseeing the completion of the squad's objectives by directing his men in combat and ensuring the overall firepower is put to good use.  With the effective use of smoke and close-quarters weaponry, the squad leader's presence is an excellent force multiplier to the units under his command."
    MenuImage=texture'DHGermanCharactersTex.Icons.WSS_SqL'
    Models(0)="SSS_1"
    Models(1)="SSS_2"
    Models(2)="SSS_3"
    Models(3)="SSS_4"
    Models(4)="SSS_5"
    Models(5)="SSS_6"
    bIsLeader=true
    SleeveTexture=texture'Weapons1st_tex.Arms.RussianSnow_Sleeves'
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_G43Weapon',Amount=9,AssociatedAttachment=class'ROInventory.ROG43AmmoPouch')
    PrimaryWeapons(1)=(Item=class'DH_Weapons.DH_MP40Weapon',Amount=6,AssociatedAttachment=class'ROInventory.ROMP40AmmoPouch')
    SecondaryWeapons(0)=(Item=class'DH_Weapons.DH_P38Weapon',Amount=1)
    SecondaryWeapons(1)=(Item=class'DH_Weapons.DH_P08LugerWeapon',Amount=1)
    Grenades(0)=(Item=class'DH_Weapons.DH_StielGranateWeapon',Amount=2)
    Grenades(1)=(Item=class'DH_Equipment.DH_NebelGranate39Weapon',Amount=1)
    Grenades(2)=(Item=class'DH_Equipment.DH_OrangeSmokeWeapon',Amount=1)
    Headgear(0)=class'DH_GerPlayers.DH_SSHelmetCover'
    Headgear(1)=class'DH_GerPlayers.DH_WSSCrushercap'
    PrimaryWeaponType=WT_SemiAuto
    bEnhancedAutomaticControl=true
    Limit=1
    Limit33to44=2
    LimitOver44=2
}

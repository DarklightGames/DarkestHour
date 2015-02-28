//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_12thSSSquadLeader extends DH_12thSS;

defaultproperties
{
    bIsSquadLeader=true
    MyName="Squad Leader"
    AltName="Unterscharführer"
    Article="a "
    PluralName="Squad Leaders"
    InfoText="The squad leader is tasked with overseeing the completion of the squad's objectives by directing his men in combat and ensuring the overall firepower is put to good use.  With the effective use of smoke and close-quarters weaponry, the squad leaders presence is an excellent force multiplier to the units under his command."
    MenuImage=texture'DHGermanCharactersTex.Icons.WSS_SqL'
    Models(0)="12SS_1"
    Models(1)="12SS_2"
    Models(2)="12SS_3"
    Models(3)="12SS_4"
    Models(4)="12SS_5"
    Models(5)="12SS_6"
    bIsLeader=true
    SleeveTexture=texture'DHGermanCharactersTex.GerSleeves.12thSS_Sleeve'
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_MP40Weapon',Amount=6,AssociatedAttachment=class'ROInventory.ROMP40AmmoPouch')
    SecondaryWeapons(0)=(Item=class'DH_Weapons.DH_P38Weapon',Amount=1)
    SecondaryWeapons(1)=(Item=class'DH_Weapons.DH_P08LugerWeapon',Amount=1)
    Grenades(0)=(Item=class'DH_Equipment.DH_NebelGranate39Weapon',Amount=1)
    Grenades(1)=(Item=class'DH_Equipment.DH_OrangeSmokeWeapon',Amount=1)
    Headgear(0)=class'DH_GerPlayers.DH_SSHelmetOne'
    Headgear(1)=class'DH_GerPlayers.DH_SSHelmetTwo'
    PrimaryWeaponType=WT_SMG
    bEnhancedAutomaticControl=true
    Limit=1
    Limit33to44=2
    LimitOver44=2
}

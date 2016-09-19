//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_ROSU_RKK_GreenTelogreikaSquadLeader extends DH_ROSU_RKK_GreenTelogreika;

defaultproperties
{
    MyName="Squad Leader"
    AltName="Komandir otdeleniya"
    Article="a "
    PluralName="Squad Leaders"
    PrimaryWeaponType=WT_SMG
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_PPSH41Weapon',Amount=6,AssociatedAttachment=class'ROInventory.ROPPSh41AmmoPouch')
    PrimaryWeapons(1)=(Item=class'DH_Weapons.DH_M38Weapon',Amount=15,AssociatedAttachment=class'ROInventory.ROMN9130AmmoPouch')
    SecondaryWeapons(0)=(Item=class'DH_Weapons.DH_TT33Weapon',Amount=1)
    Grenades(0)=(Item=class'DH_Weapons.DH_F1GrenadeWeapon',Amount=2)
    Grenades(1)=(Item=class'DH_RDG1GrenadeWeapon',Amount=2)
    GivenItems(0)="DH_Equipment.DHBinocularsItem"
    Headgear(0)=class'DH_RUPlayers.DH_ROSovietHelmet'
    Headgear(1)=class'DH_RUPlayers.DH_ROSovietHelmet'
    Headgear(2)=class'DH_RUPlayers.DH_ROSovietHelmet'
    bEnhancedAutomaticControl=true
    PointValue=3.0
    ObjCaptureWeight=2
    bIsLeader=true
    limit=2
}

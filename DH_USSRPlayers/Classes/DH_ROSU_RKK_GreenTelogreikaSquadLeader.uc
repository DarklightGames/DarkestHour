//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_ROSU_RKK_GreenTelogreikaSquadLeader extends DH_ROSU_RKK_GreenTelogreika;

defaultproperties
{
    bIsSquadLeader=true
    MyName="Squad Leader"
    AltName="Komandir otdeleniya"
    Article="a "
    PluralName="Squad Leaders"
    PrimaryWeaponType=WT_SMG
    PrimaryWeapons(0)=(Item=class'DH_ROWeapons.DH_PPSH41Weapon',Amount=6,AssociatedAttachment=class'ROInventory.ROPPSh41AmmoPouch')
    PrimaryWeapons(1)=(Item=class'DH_ROWeapons.DH_M38Weapon',Amount=15,AssociatedAttachment=Class'ROInventory.ROMN9130AmmoPouch')
    SecondaryWeapons(0)=(Item=class'DH_ROWeapons.DH_TT33Weapon',Amount=1)
    Grenades(0)=(Item=class'DH_ROWeapons.DH_F1GrenadeWeapon',Amount=2)
    Grenades(1)=(Item=class'DH_RDG1GrenadeWeapon',Amount=2)
    GivenItems(0)="DH_Equipment.DH_USBinocularsItem"
    Headgear(0)=class'DH_ROPlayers.DH_ROSovietHelmet'
    Headgear(1)=class'DH_ROPlayers.DH_ROSovietHelmet'
    Headgear(2)=class'DH_ROPlayers.DH_ROSovietHelmet'
    InfoText="The squad leader is tasked with overseeing the completion of the squad's objectives by directing his men in combat and ensuring the overall firepower is put to good use.  With the effective use of smoke and close-quarters weaponry, the squad leader's presence is an excellent force multiplier to the units under his command."
    bEnhancedAutomaticControl=true
    PointValue=3.0
    ObjCaptureWeight=2
    bIsLeader=true
    MenuImage=Texture'InterfaceArt_tex.SelectMenus.KO'
    limit=2
}

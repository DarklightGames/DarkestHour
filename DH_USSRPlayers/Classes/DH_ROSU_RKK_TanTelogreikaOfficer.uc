//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_ROSU_RKK_TanTelogreikaOfficer extends DH_ROSU_RKK_TanTelogreika;

defaultproperties
{
    MyName="Artillery Officer"
    AltName="Artillerie Ofitser"
    Article="an "
    PluralName="Artillery Officers"
    InfoText="The artillery officer is tasked with directing artillery fire upon the battlefield through the use of long-range observation. Coordinating his efforts over the radio, he is able to target locations for off-grid artillery to lay down a barrage with devastating effect."
    menuImage=Texture'InterfaceArt_tex.SelectMenus.KO'
    PrimaryWeapons(0)=(Item=class'DH_ROWeapons.DH_PPSH41Weapon',Amount=6,AssociatedAttachment=class'ROInventory.ROPPSh41AmmoPouch')
    PrimaryWeapons(1)=(Item=class'DH_ROWeapons.DH_M38Weapon',Amount=15)
    SecondaryWeapons(0)=(Item=class'DH_ROWeapons.DH_TT33Weapon',Amount=1)
    Grenades(0)=(Item=class'DH_RDG1GrenadeWeapon',Amount=2)
    Grenades(1)=(Item=class'DH_ROWeapons.DH_F1GrenadeWeapon',Amount=2)
    GivenItems(0)="DH_Equipment.DH_USArtyBinocularsItem"
    Headgear(0)=class'DH_ROPlayers.DH_ROSovietOfficerHat'
    Headgear(1)=class'DH_ROPlayers.DH_ROSovietOfficerHat'
    Headgear(2)=class'DH_ROPlayers.DH_ROSovietOfficerHat'
    PrimaryWeaponType=WT_SMG
    bEnhancedAutomaticControl=True
    limit=1
    bIsArtilleryOfficer=true
}

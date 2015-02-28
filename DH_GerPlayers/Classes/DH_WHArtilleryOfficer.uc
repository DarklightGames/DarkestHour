//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_WHArtilleryOfficer extends DH_Heer;

defaultproperties
{
    MyName="Artillery Officer"
    AltName="Artillerie Offizier"
    Article="a "
    PluralName="Artillery Officers"
    InfoText="Artillerie Offizier||The artillery officer is the artillery commander, either an NCO or officer. His primary task was to spot targets for the gunner. ||Only artillery crew can use artillery"
    MenuImage=texture'DHGermanCharactersTex.Icons.Zugfuhrer'
    Models(0)="WHA_1"
    Models(1)="WHA_2"
    Models(2)="WHA_3"
    Models(3)="WHA_4"
    SleeveTexture=texture'Weapons1st_tex.Arms.german_sleeves'
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_MP40Weapon',Amount=6,AssociatedAttachment=class'ROInventory.ROMP40AmmoPouch')
    SecondaryWeapons(0)=(Item=class'DH_Weapons.DH_P38Weapon',Amount=1)
    SecondaryWeapons(1)=(Item=class'DH_Weapons.DH_P08LugerWeapon',Amount=1)
    GivenItems(0)="DH_Engine.DH_BinocularsItem"
    Headgear(0)=class'DH_GerPlayers.DH_HeerHelmetThree'
    Headgear(1)=class'DH_GerPlayers.DH_HeerHelmetOne'
    PrimaryWeaponType=WT_SMG
    bEnhancedAutomaticControl=true
    bCanBeTankCrew=true
    Limit=1
}

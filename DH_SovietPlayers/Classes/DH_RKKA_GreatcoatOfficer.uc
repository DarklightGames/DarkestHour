//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_RKKA_GreatcoatOfficer extends DH_RKKA_Greatcoat;

defaultproperties
{
    MyName="Artillery Officer"
    AltName="Artillerie Ofitser"
    Article="an "
    PluralName="Artillery Officers"
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_PPSH41Weapon',Amount=6,AssociatedAttachment=class'ROInventory.ROPPSh41AmmoPouch')
    PrimaryWeapons(1)=(Item=class'DH_Weapons.DH_M38Weapon',Amount=15,AssociatedAttachment=class'ROInventory.ROMN9130AmmoPouch')
    SecondaryWeapons(0)=(Item=class'DH_Weapons.DH_TT33Weapon',Amount=1)
    Grenades(0)=(Item=class'DH_Equipment.DH_RDG1SmokeGrenadeWeapon',Amount=2)
    Grenades(1)=(Item=class'DH_Weapons.DH_F1GrenadeWeapon',Amount=2)
    GivenItems(0)="DH_Equipment.DHBinocularsItem"
    Headgear(0)=class'DH_SovietPlayers.DH_SovietOfficerHat'
    Headgear(1)=class'DH_SovietPlayers.DH_SovietOfficerHat'
    Headgear(2)=class'DH_SovietPlayers.DH_SovietOfficerHat'
    Limit=1
    bIsArtilleryOfficer=true
}

//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_OstTruppenRifleman extends DH_OstTruppen;

defaultproperties
{
    MyName="Schütze Osttruppe"
    AltName="Schütze Osttruppe"
    Article="a "
    PluralName="Schütze Osttruppen"
    MenuImage=texture'InterfaceArt_tex.SelectMenus.Schutze'
    Models(0)="OT_1"
    Models(1)="OT_2"
    Models(2)="OT_3"
    Models(3)="OT_4"
    Models(4)="OT_5"
    Models(5)="OT_6"
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_Kar98Weapon',AssociatedAttachment=class'ROInventory.ROKar98AmmoPouch')
    Grenades(0)=(Item=class'DH_Weapons.DH_StielGranateWeapon')
    Headgear(0)=class'DH_GerPlayers.DH_HeerHelmetThree'
    Headgear(1)=class'DH_GerPlayers.DH_HeerHelmetTwo'
}

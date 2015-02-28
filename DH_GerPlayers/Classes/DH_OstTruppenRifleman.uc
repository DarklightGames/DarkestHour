//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_OstTruppenRifleman extends DH_OstTruppen;

defaultproperties
{
    MyName="Osttruppe Rifleman"
    AltName="Schütze Osttruppe"
    Article="a "
    PluralName="Riflemen"
    InfoText="Schütze Osttruppe||The Osttruppen were formed by foreign 'volunteers' - mainly POWs from the Eastern Front.They were not considered to be reliable troops, their job was to buy time until a counter attack could be mounted."
    MenuImage=texture'InterfaceArt_tex.SelectMenus.Schutze'
    Models(0)="OT_1"
    Models(1)="OT_2"
    Models(2)="OT_3"
    Models(3)="OT_4"
    Models(4)="OT_5"
    Models(5)="OT_6"
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_Kar98Weapon',Amount=18,AssociatedAttachment=class'ROInventory.ROKar98AmmoPouch')
    Grenades(0)=(Item=class'DH_Weapons.DH_StielGranateWeapon',Amount=1)
    Headgear(0)=class'DH_GerPlayers.DH_HeerHelmetThree'
    Headgear(1)=class'DH_GerPlayers.DH_HeerHelmetTwo'
}

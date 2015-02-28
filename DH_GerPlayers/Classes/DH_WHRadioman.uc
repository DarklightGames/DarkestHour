//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_WHRadioman extends DH_Heer;

defaultproperties
{
    MyName="Radio Operator"
    AltName="Funktruppe"
    Article="a "
    PluralName="Radio Operator"
    MenuImage=texture'DHGermanCharactersTex.Icons.WH_Radioman'
    Models(0)="Wh_Radio_1"
    SleeveTexture=texture'Weapons1st_tex.Arms.german_sleeves'
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_Kar98Weapon',Amount=18,AssociatedAttachment=class'ROInventory.ROKar98AmmoPouch')
    GivenItems(0)="DH_Equipment.DH_GerRadioItem"
    Headgear(0)=class'DH_GerPlayers.DH_HeerHelmetThree'
    Headgear(1)=class'DH_GerPlayers.DH_HeerHelmetTwo'
    RolePawnClass="DH_GerPlayers.DH_WHRadiomanPawn"
    Limit=1
}
pon',Amount=18,AssociatedAttachment=class'ROInventory.ROKar98AmmoPouch')
    GivenItems(0)="DH_Equipment.DH_GerRadioItem"
    Headgear(0)=class'DH_GerPlayers.DH_HeerHelmetThree'
    Headgear(1)=class'DH_GerPlayers.DH_HeerHelmetTwo'
    RolePawnClass="DH_GerPlayers.DH_WHRadiomanPawn"
    Limit=1
}

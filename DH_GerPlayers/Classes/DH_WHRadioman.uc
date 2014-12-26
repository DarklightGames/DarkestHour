//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_WHRadioman extends DH_Heer;

defaultproperties
{
    MyName="Radio Operator"
    AltName="Funktruppe"
    Article="a "
    PluralName="Radio Operator"
    InfoText="The radio operator carries a man-packed radio and is tasked with the role of calling in artillery strikes towards targets designated by the artillery officer. Effective communication between the radio operator and the artillery officer is critical to the success of a coordinated barrage."
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

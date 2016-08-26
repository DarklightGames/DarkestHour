//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2016
//==============================================================================

class DH_WSSRadioman extends DH_WaffenSS;

defaultproperties
{
    MyName="Radio Operator"
    AltName="Funktruppe"
    Article="a "
    PluralName="Radio Operator"
    Models(0)="WSS_Radio_1"
    SleeveTexture=texture'DHGermanCharactersTex.GerSleeves.Dot44Sleeve'
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_Kar98Weapon',AssociatedAttachment=class'ROInventory.ROKar98AmmoPouch')
    GivenItems(0)="DH_Equipment.DHRadioItem"
    Headgear(0)=class'DH_GerPlayers.DH_SSHelmetOne'
    Headgear(1)=class'DH_GerPlayers.DH_SSHelmetTwo'
    Limit=1
}

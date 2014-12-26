//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2014
//==============================================================================

class DH_FJMortarObserver extends DH_FJ;

defaultproperties
{
    bIsMortarObserver=true
    MyName="Mortar Observer"
    AltName="Werferbeobachter"
    Article="a "
    PluralName="Mortar Observers"
    InfoText="The mortar observer is tasked with assisting the mortar operator by acquiring and marking targets using his binoculars.  Targets marked by the mortar observer will be relayed to the mortar operator."
    MenuImage=texture'DHGermanCharactersTex.Icons.FJ_MortarObserver'
    Models(0)="FJ1"
    Models(1)="FJ2"
    Models(2)="FJ3"
    Models(3)="FJ4"
    Models(4)="FJ5"
    SleeveTexture=texture'DHGermanCharactersTex.GerSleeves.FJ_Sleeve'
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_Kar98Weapon',Amount=18,AssociatedAttachment=class'ROInventory.ROKar98AmmoPouch')
    PrimaryWeapons(1)=(Item=class'DH_Weapons.DH_G41Weapon',Amount=9,AssociatedAttachment=class'ROInventory.ROG43AmmoPouch')
    SecondaryWeapons(0)=(Item=class'DH_Weapons.DH_P38Weapon',Amount=1)
    Grenades(0)=(Item=class'DH_Weapons.DH_StielGranateWeapon',Amount=2)
    GivenItems(0)="DH_Engine.DH_BinocularsItem"
    Headgear(0)=class'DH_GerPlayers.DH_FJHelmetCamo1'
    Headgear(1)=class'DH_GerPlayers.DH_FJHelmetCamo2'
    Headgear(2)=class'DH_GerPlayers.DH_FJHelmetNet1'
    Limit=1
}

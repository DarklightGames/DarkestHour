//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2015
//==============================================================================

class DH_WSSMortarObserver_Autumn extends DH_WaffenSSAutumn;

defaultproperties
{
    bIsMortarObserver=true
    MyName="Mortar Observer"
    AltName="Werferbeobachter"
    Article="a "
    PluralName="Mortar Observers"
    MenuImage=texture'DHGermanCharactersTex.Icons.WSS_MortarObserver'
    Models(0)="SSA_1"
    Models(1)="SSA_2"
    Models(2)="SSA_3"
    Models(3)="SSA_4"
    Models(4)="SSA_5"
    Models(5)="SSA_6"
    SleeveTexture=texture'DHGermanCharactersTex.GerSleeves.Dot44Sleeve'
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_Kar98Weapon',Amount=18,AssociatedAttachment=class'ROInventory.ROKar98AmmoPouch')
    Grenades(0)=(Item=class'DH_Weapons.DH_StielGranateWeapon',Amount=2)
    GivenItems(0)="DH_Engine.DH_BinocularsItem"
    Headgear(0)=class'DH_GerPlayers.DH_SSHelmetCover'
    Headgear(1)=class'DH_GerPlayers.DH_SSHelmetNoCover'
    Limit=1
}
ons.DH_StielGranateWeapon',Amount=2)
    GivenItems(0)="DH_Engine.DH_BinocularsItem"
    Headgear(0)=class'DH_GerPlayers.DH_SSHelmetCover'
    Headgear(1)=class'DH_GerPlayers.DH_SSHelmetNoCover'
    Limit=1
}

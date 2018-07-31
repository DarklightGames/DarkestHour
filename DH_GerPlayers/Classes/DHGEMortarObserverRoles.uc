//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
//==============================================================================

class DHGEMortarObserverRoles extends DHAxisMortarObserverRoles
    abstract;

defaultproperties
{
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_Kar98Weapon',AssociatedAttachment=class'ROInventory.ROKar98AmmoPouch')
    Grenades(0)=(Item=class'DH_Weapons.DH_StielGranateWeapon')
    GivenItems(0)="DH_Equipment.DHBinocularsItem"
    HeadgearProbabilities(0)=0.2
    HeadgearProbabilities(1)=0.8
}

//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHROMAntiTankRoles extends DHRomRoles
    abstract;

defaultproperties
{
    MyName="Tank Hunter"
    AltName="aaa"
    Limit=2
    bCanCarryExtraAmmo=false
    AddedRoleRespawnTime=15
    bExemptSquadRequirement=true
    bCanBeSquadLeader=false
    //by standard, these did not carry primary weapons for lighter weight, but i am going to give them second-line rifles 
    //because otherwise they will just pick up whatever they see first and its not gonna make sense
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_G98Weapon',AssociatedAttachment=class'ROInventory.ROKar98AmmoPouch')
    PrimaryWeapons(1)=(Item=class'DH_Weapons.DH_MN9130Weapon',AssociatedAttachment=class'ROInventory.ROKar98AmmoPouch') //replace with imperial mosin
    //add M95 
    SecondaryWeapons(0)=(Item=Class'DH_BerettaM1934Weapon')
    Grenades(0)=(Item=class'DH_Weapons.DH_M34GrenadeWeapon')
    Grenades(1)=(Item=class'DH_Weapons.DH_StielGranateWeapon')
    Grenades(2)=(Item=class'DH_Equipment.DH_NebelGranate39Weapon') //replace with new smoke candle
    GivenItems(0)="DH_Weapons.DH_SatchelCharge10lb10sWeapon"
    GivenItems(1)="DH_Weapons.DH_GLWeapon" //this is more or less an accurate AT loadout, these guys didnt really have proper AT weapons
    //until panzerfausts; PTRD is problematic because captured ammo must have been scarce, it shouldnt be a standard role weapon.
    //HeadgearProbabilities(0)=0.2
    //HeadgearProbabilities(1)=0.8
}

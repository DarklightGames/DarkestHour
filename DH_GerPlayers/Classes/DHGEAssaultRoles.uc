//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2018
//==============================================================================

class DHGEAssaultRoles extends DHAxisAssaultRoles
    abstract;

defaultproperties
{
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_MP40Weapon',AssociatedAttachment=class'ROInventory.ROMP40AmmoPouch')
    PrimaryWeapons(1)=(Item=class'DH_Weapons.DH_STG44Weapon',AssociatedAttachment=class'ROInventory.ROSTG44AmmoPouch')
    Grenades(0)=(Item=class'DH_Weapons.DH_StielGranateWeapon')
    HeadgearProbabilities(0)=0.5
    HeadgearProbabilities(1)=0.5
}

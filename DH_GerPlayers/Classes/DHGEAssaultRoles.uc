//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DHGEAssaultRoles extends DHAxisAssaultRoles
    abstract;

defaultproperties
{
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_MP40Weapon',AssociatedAttachment=class'ROInventory.ROMP40AmmoPouch')
    Grenades(0)=(Item=class'DH_Weapons.DH_StielGranateWeapon')
    HeadgearProbabilities(0)=0.5
    HeadgearProbabilities(1)=0.5
    GlovedHandTexture=Texture'Weapons1st_tex.Arms.hands_gergloves'
    GivenItems(0)="DH_Equipment.DHShovelItem_German"
}

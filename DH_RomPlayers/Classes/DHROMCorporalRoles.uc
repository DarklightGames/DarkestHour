//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHROMCorporalRoles extends DHAxisCorporalRoles
    abstract;

defaultproperties
{ 
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_MP41Weapon',AssociatedAttachment=class'ROInventory.ROMP40AmmoPouch')
    PrimaryWeapons(1)=(Item=class'DH_Weapons.DH_MAB38Weapon',AssociatedAttachment=class'ROInventory.ROMP40AmmoPouch')
    //to do: mp28
    SecondaryWeapons(0)=(Item=class'DH_Weapons.DH_P38Weapon')  //m1912
    Grenades(0)=(Item=class'DH_Weapons.DH_M34GrenadeWeapon')
    HeadgearProbabilities(0)=0.2
    HeadgearProbabilities(1)=0.8
    GlovedHandTexture=Texture'Weapons1st_tex.Arms.hands_gergloves'
}

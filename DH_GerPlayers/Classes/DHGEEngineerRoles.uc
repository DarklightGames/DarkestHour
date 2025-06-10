//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHGEEngineerRoles extends DHAxisEngineerRoles
    abstract;

defaultproperties
{
    PrimaryWeapons(0)=(Item=Class'DH_Kar98Weapon',AssociatedAttachment=Class'ROInventory.ROKar98AmmoPouch')
    PrimaryWeapons(1)=(Item=Class'DH_Kar98NoCoverWeapon',AssociatedAttachment=Class'ROInventory.ROKar98AmmoPouch')
    Grenades(0)=(Item=Class'DH_StielGranateWeapon')
    Grenades(1)=(Item=Class'DH_NebelGranate39Weapon')
    GivenItems(0)="DH_Weapons.DH_SatchelCharge10lb10sWeapon"
    GivenItems(1)="DH_Equipment.DHWireCuttersItem"
    HeadgearProbabilities(0)=0.2
    HeadgearProbabilities(1)=0.8
    GlovedHandTexture=Texture'Weapons1st_tex.Arms.hands_gergloves'
}

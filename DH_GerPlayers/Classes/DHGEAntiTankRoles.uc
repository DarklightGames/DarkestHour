//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHGEAntiTankRoles extends DHAxisAntiTankRoles
    abstract;

defaultproperties
{
    PrimaryWeapons(0)=(Item=Class'DH_Kar98Weapon',AssociatedAttachment=Class'ROInventory.ROKar98AmmoPouch',AssociatedAttachment=Class'ROInventory.ROKar98AmmoPouch')
    PrimaryWeapons(1)=(Item=Class'DH_MP40Weapon',AssociatedAttachment=Class'ROInventory.ROMP40AmmoPouch')
    Grenades(0)=(Item=Class'DH_NebelGranate39Weapon')
    GivenItems(0)="DH_Weapons.DH_PanzerschreckWeapon"
    HeadgearProbabilities(0)=0.2
    HeadgearProbabilities(1)=0.8
    GlovedHandTexture=Texture'Weapons1st_tex.hands_gergloves'
}

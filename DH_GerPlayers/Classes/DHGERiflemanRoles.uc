//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHGERiflemanRoles extends DHAxisRiflemanRoles
    abstract;

defaultproperties
{
    PrimaryWeapons(0)=(Item=Class'DH_Kar98Weapon',AssociatedAttachment=Class'ROInventory.ROKar98AmmoPouch')
    PrimaryWeapons(1)=(Item=Class'DH_Kar98NoCoverWeapon',AssociatedAttachment=Class'ROInventory.ROKar98AmmoPouch')
    Grenades(0)=(Item=Class'DH_StielGranateWeapon')
    HeadgearProbabilities(0)=0.5
    HeadgearProbabilities(1)=0.5
    GlovedHandTexture=Texture'Weapons1st_tex.hands_gergloves'
}

//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHGERadioOperatorRoles extends DHAxisRadioOperatorRoles
    abstract;

defaultproperties
{
    PrimaryWeapons(0)=(Item=Class'DH_Kar98Weapon',AssociatedAttachment=Class'ROInventory.ROKar98AmmoPouch')
    PrimaryWeapons(1)=(Item=Class'DH_Kar98NoCoverWeapon',AssociatedAttachment=Class'ROInventory.ROKar98AmmoPouch')
    Grenades(0)=(Item=Class'DH_StielGranateWeapon')
    GivenItems(0)="DH_Equipment.DHRadioItem"
    HeadgearProbabilities(0)=0.5
    HeadgearProbabilities(1)=0.5
    GlovedHandTexture=Texture'Weapons1st_tex.Arms.hands_gergloves'
}

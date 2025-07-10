//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHGEAssaultRoles extends DHAxisAssaultRoles
    abstract;

defaultproperties
{
    PrimaryWeapons(0)=(Item=Class'DH_MP40Weapon',AssociatedAttachment=Class'ROInventory.ROMP40AmmoPouch')
    Grenades(0)=(Item=Class'DH_StielGranateWeapon')
    HeadgearProbabilities(0)=0.5
    HeadgearProbabilities(1)=0.5
    GlovedHandTexture=Texture'Weapons1st_tex.hands_gergloves'
    GivenItems(0)="DH_Equipment.DHShovelItem_German"
}

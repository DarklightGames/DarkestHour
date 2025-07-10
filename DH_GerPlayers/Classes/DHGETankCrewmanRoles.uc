//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHGETankCrewmanRoles extends DHAxisTankCrewmanRoles
    abstract;

defaultproperties
{
    PrimaryWeapons(0)=(Item=Class'DH_MP40Weapon',AssociatedAttachment=Class'ROInventory.ROMP40AmmoPouch')
    PrimaryWeapons(1)=(Item=Class'DH_M712Weapon')

    SecondaryWeapons(0)=(Item=Class'DH_P38Weapon')
    SecondaryWeapons(1)=(Item=Class'DH_P08LugerWeapon')

    GivenItems(0)="DH_Equipment.DHBinocularsItemGerman"

    DetachedArmClass=Class'SeveredArmGerTanker'
    DetachedLegClass=Class'SeveredLegGerTanker'

    HeadgearProbabilities(0)=0.5
    HeadgearProbabilities(1)=0.5

    GlovedHandTexture=Texture'Weapons1st_tex.hands_gergloves'
}

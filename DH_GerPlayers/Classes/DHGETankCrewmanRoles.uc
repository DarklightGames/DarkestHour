//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHGETankCrewmanRoles extends DHAxisTankCrewmanRoles
    abstract;

defaultproperties
{
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_MP40Weapon',AssociatedAttachment=class'ROInventory.ROMP40AmmoPouch')
    PrimaryWeapons(1)=(Item=class'DH_Weapons.DH_M712Weapon')

    SecondaryWeapons(0)=(Item=class'DH_Weapons.DH_P38Weapon')
    SecondaryWeapons(1)=(Item=class'DH_Weapons.DH_P08LugerWeapon')

    GivenItems(0)="DH_Equipment.DHBinocularsItemGerman"

    DetachedArmClass=class'ROEffects.SeveredArmGerTanker'
    DetachedLegClass=class'ROEffects.SeveredLegGerTanker'

    HeadgearProbabilities(0)=0.5
    HeadgearProbabilities(1)=0.5

    GlovedHandTexture=Texture'Weapons1st_tex.Arms.hands_gergloves'
}

//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2023
//==============================================================================

class DHROMTankCrewmanRoles extends DHAxisTankCrewmanRoles
    abstract;

defaultproperties
{
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_vz24Weapon',AssociatedAttachment=class'ROInventory.ROKar98AmmoPouch')


    SecondaryWeapons(0)=(Item=class'DH_Weapons.DH_P38Weapon') //change to m1912

    GivenItems(0)="DH_Equipment.DHBinocularsItemGerman"

    DetachedArmClass=class'ROEffects.SeveredArmGerTanker'
    DetachedLegClass=class'ROEffects.SeveredLegGerTanker'

    GlovedHandTexture=Texture'Weapons1st_tex.Arms.hands_gergloves'
}

//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2022
//==============================================================================

class DHGERadioOperatorRoles extends DHAxisRadioOperatorRoles
    abstract;

defaultproperties
{
    PrimaryWeapons(0)=(Item=class'DH_Weapons.DH_Kar98Weapon')
    PrimaryWeapons(1)=(Item=class'DH_Weapons.DH_Kar98NoCoverWeapon')
    Grenades(0)=(Item=class'DH_Weapons.DH_StielGranateWeapon')
    GivenItems(0)="DH_Equipment.DHRadioItem"
    HeadgearProbabilities(0)=0.5
    HeadgearProbabilities(1)=0.5
    GlovedHandTexture=Texture'Weapons1st_tex.Arms.hands_gergloves'
}

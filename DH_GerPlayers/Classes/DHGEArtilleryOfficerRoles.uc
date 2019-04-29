//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DHGEArtilleryOfficerRoles extends DHAxisArtilleryOfficerRoles
    abstract;

defaultproperties
{
    // Many childs have different primary weapons defined, so no point in defining any here
    SecondaryWeapons(0)=(Item=class'DH_Weapons.DH_P38Weapon')
    SecondaryWeapons(1)=(Item=class'DH_Weapons.DH_P08LugerWeapon')
    GivenItems(0)="DH_Equipment.DHBinocularsItem"
    HeadgearProbabilities(0)=0.2
    HeadgearProbabilities(1)=0.8
}

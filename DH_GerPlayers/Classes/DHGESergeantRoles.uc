//==============================================================================
// Darkest Hour: Europe '44-'45
// Darklight Games (c) 2008-2019
//==============================================================================

class DHGESergeantRoles extends DHAxisSergeantRoles
    abstract;

defaultproperties
{
    SecondaryWeapons(0)=(Item=class'DH_Weapons.DH_P38Weapon')
    SecondaryWeapons(1)=(Item=class'DH_Weapons.DH_P08LugerWeapon')
    SecondaryWeapons(2)=(Item=class'DH_Weapons.dh_c96Weapon')
    Grenades(0)=(Item=class'DH_Weapons.DH_StielGranateWeapon')
    Grenades(1)=(Item=class'DH_Equipment.DH_NebelGranate39Weapon')
    Grenades(2)=(Item=class'DH_Equipment.DH_OrangeSmokeWeapon')
    HeadgearProbabilities(0)=0.5
    HeadgearProbabilities(1)=0.5
}

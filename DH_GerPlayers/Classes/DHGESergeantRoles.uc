//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHGESergeantRoles extends DHAxisSergeantRoles
    abstract;

defaultproperties
{
    SecondaryWeapons(0)=(Item=Class'DH_P38Weapon')
    SecondaryWeapons(1)=(Item=Class'DH_P08LugerWeapon')
    SecondaryWeapons(2)=(Item=Class'DH_ViSWeapon')
    Grenades(0)=(Item=Class'DH_StielGranateWeapon')
    Grenades(1)=(Item=Class'DH_NebelGranate39Weapon')
    Grenades(2)=(Item=Class'DH_OrangeSmokeWeapon')
    HeadgearProbabilities(0)=0.5
    HeadgearProbabilities(1)=0.5
    GlovedHandTexture=Texture'Weapons1st_tex.Arms.hands_gergloves'
}

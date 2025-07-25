//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DHGEMarksmanRoles extends DHAxisMarksmanRoles
    abstract;

defaultproperties
{
    //ZF41 was used in place of regular snipers as a way to extend the gruppe's range and allow them to take out harder targets like machineguns and pillboxes
    //There was distinction between snipers and marksmen
    PrimaryWeapons(0)=(Item=Class'DH_Kar98ScopedZF41Weapon')
    Grenades(0)=(Item=Class'DH_StielGranateWeapon')
    HeadgearProbabilities(0)=0.5
    HeadgearProbabilities(1)=0.5
    GlovedHandTexture=Texture'Weapons1st_tex.hands_gergloves'
}

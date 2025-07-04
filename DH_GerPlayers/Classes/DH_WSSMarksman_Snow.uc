//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_WSSMarksman_Snow extends DHGEMarksmanRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=Class'DH_GermanParkaSnowSSPawn',Weight=2.0)
    RolePawns(1)=(PawnClass=Class'DH_GermanSmockToqueSSPawn',Weight=1.0)
    SleeveTexture=Texture'Weapons1st_tex.RussianSnow_Sleeves'
    Headgear(0)=Class'DH_SSHelmetSnow'
    HeadgearProbabilities(0)=1.0
    SecondaryWeapons(0)=(Item=Class'DH_BHPWeapon')
    SecondaryWeapons(1)=(Item=Class'DH_P08LugerWeapon')
    SecondaryWeapons(2)=(Item=Class'DH_TT33Weapon')
    HandType=Hand_Gloved
}

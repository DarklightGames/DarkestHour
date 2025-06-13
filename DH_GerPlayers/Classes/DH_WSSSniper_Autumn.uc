//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_WSSSniper_Autumn extends DHGESniperRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=Class'DH_GermanParkaSSPawn',Weight=1.5)
    RolePawns(1)=(PawnClass=Class'DH_GermanAutumnSmockSSPawn',Weight=1.0)
    RolePawns(2)=(PawnClass=Class'DH_GermanAutumnSSPawn',Weight=1.0)
    SleeveTexture=Texture'DHGermanCharactersTex.Dot44Sleeve'
    Headgear(0)=Class'DH_SSHelmetCover'
    HeadgearProbabilities(0)=1.0

    SecondaryWeapons(0)=(Item=Class'DH_BHPWeapon')
    SecondaryWeapons(1)=(Item=Class'DH_P08LugerWeapon')
    SecondaryWeapons(2)=(Item=Class'DH_TT33Weapon')
}

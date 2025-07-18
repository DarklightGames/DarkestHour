//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_12thSSSniper extends DHGESniperRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=Class'DH_German12thSSPawnB',Weight=1.0)
    SleeveTexture=Texture'DHGermanCharactersTex.Dot44Sleeve'
    Headgear(0)=Class'DH_SSHelmetOne'
    Headgear(1)=Class'DH_SSHelmetTwo'

    SecondaryWeapons(0)=(Item=Class'DH_BHPWeapon')
    SecondaryWeapons(1)=(Item=Class'DH_P08LugerWeapon')
    SecondaryWeapons(2)=(Item=Class'DH_TT33Weapon')
}

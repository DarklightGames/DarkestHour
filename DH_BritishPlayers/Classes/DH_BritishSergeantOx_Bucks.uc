//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_BritishSergeantOx_Bucks extends DHCWSergeantRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=Class'DH_BritishAirbornSergeantPawn')
    Headgear(0)=Class'DH_BritishAirborneBeretOx_Bucks'
    SleeveTexture=Texture'DHBritishCharactersTex.Brit_Para_sleeves'

    PrimaryWeapons(1)=(Item=Class'DH_StenMkVWeapon')
    PrimaryWeapons(2)=(Item=none)
}

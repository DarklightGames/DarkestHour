//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_BritishAntiTankOx_Bucks extends DHCWAntiTankRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=Class'DH_BritishAirbornePawn',Weight=1.0)
    Headgear(0)=Class'DH_BritishParaHelmetOne'
    Headgear(1)=Class'DH_BritishParaHelmetTwo'
    Headgear(2)=Class'DH_BritishAirborneBeretOx_Bucks'
    SleeveTexture=Texture'DHBritishCharactersTex.Sleeves.Brit_Para_sleeves'

    PrimaryWeapons(0)=(Item=Class'DH_StenMkVWeapon')
    PrimaryWeapons(2)=(Item=none)

    SecondaryWeapons(0)=(Item=Class'DH_EnfieldNo2Weapon')
}

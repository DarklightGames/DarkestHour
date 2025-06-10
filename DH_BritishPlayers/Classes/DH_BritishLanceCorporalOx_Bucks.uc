//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_BritishLanceCorporalOx_Bucks extends DHCWCorporalRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=Class'DH_BritishAirbornePawn',Weight=1.0)
    Headgear(0)=Class'DH_BritishParaHelmetOne'
    Headgear(1)=Class'DH_BritishParaHelmetTwo'
    Headgear(2)=Class'DH_BritishParaHelmetOne'
    SleeveTexture=Texture'DHBritishCharactersTex.Sleeves.Brit_Para_sleeves'

    SecondaryWeapons(0)=(Item=Class'DH_EnfieldNo2Weapon')

    PrimaryWeapons(1)=(Item=Class'DH_StenMkVWeapon')
    PrimaryWeapons(2)=(Item=none)
}

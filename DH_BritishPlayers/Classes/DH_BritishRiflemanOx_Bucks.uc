//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_BritishRiflemanOx_Bucks extends DHCWRiflemanRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=Class'DH_BritishAirbornePawn',Weight=1.0)
    SleeveTexture=Texture'DHBritishCharactersTex.Brit_Para_sleeves'
    Headgear(0)=Class'DH_BritishParaHelmetOne'
    Headgear(1)=Class'DH_BritishParaHelmetTwo'
    Headgear(2)=Class'DH_BritishParaHelmetOne'

    SecondaryWeapons(0)=(Item=Class'DH_EnfieldNo2Weapon')
}

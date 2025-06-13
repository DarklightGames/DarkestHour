//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_USCorporal82nd extends DHUSCorporalRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=Class'DH_USAB82ndPawn',Weight=1.0)
    SleeveTexture=Texture'DHUSCharactersTex.USAB_sleeves'
    Headgear(0)=Class'DH_AmericanHelmet82ndEMa'
    Headgear(1)=Class'DH_AmericanHelmet82ndEMb'

    SecondaryWeapons(0)=(Item=Class'DH_ColtM1911Weapon')
}

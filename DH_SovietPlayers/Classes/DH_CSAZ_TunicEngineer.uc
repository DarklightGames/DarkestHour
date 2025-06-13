//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_CSAZ_TunicEngineer extends DHCSEngineerRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=Class'DH_CSAZTunicRPawn',Weight=2.0)
    RolePawns(1)=(PawnClass=Class'DH_CSAZTunicRBritpackPawn',Weight=1.0)
    RolePawns(2)=(PawnClass=Class'DH_CSAZTunicRSidorPawn',Weight=1.0)
    Headgear(0)=Class'DH_CSAZSidecap'
    Headgear(1)=Class'DH_BritishTommyHelmet'
    Headgear(2)=Class'DH_SovietHelmet'
    SleeveTexture=Texture'Weapons1st_tex.russian_sleeves'
    
    HeadgearProbabilities(0)=0.6
    HeadgearProbabilities(1)=0.2
    HeadgearProbabilities(2)=0.2
}

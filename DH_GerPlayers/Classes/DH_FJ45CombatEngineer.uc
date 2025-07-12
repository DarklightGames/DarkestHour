//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_FJ45CombatEngineer extends DHGEEngineerRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=Class'DH_GermanArdennesFJPawn',Weight=1.0)
    Headgear(0)=Class'DH_FJHelmetOne'
    Headgear(1)=Class'DH_FJHelmetTwo'
    Headgear(2)=Class'DH_FJHelmetNetOne'
    HeadgearProbabilities(0)=0.33
    HeadgearProbabilities(1)=0.33
    HeadgearProbabilities(2)=0.33
    SleeveTexture=Texture'DHGermanCharactersTex.FJ_Sleeve'
}

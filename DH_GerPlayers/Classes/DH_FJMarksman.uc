//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_FJMarksman extends DHGEMarksmanRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=Class'DH_GermanFJPawn',Weight=1.0)
    SleeveTexture=Texture'DHGermanCharactersTex.GerSleeves.FJ_Sleeve'
    Headgear(0)=Class'DH_FJHelmetCamoOne'
    Headgear(1)=Class'DH_FJHelmetCamoTwo'
    Headgear(2)=Class'DH_FJHelmetNetOne'
    HeadgearProbabilities(0)=0.33
    HeadgearProbabilities(1)=0.33
    HeadgearProbabilities(2)=0.33
}

//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_USEngineer1stIDSicilyBeach extends DHUSEngineerRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=Class'DH_US1stIDSicilyBeachPawn',Weight=1.0)
    
    SleeveTexture=Texture'DHUSCharactersTex.Sleeves.US_HBT_Light_sleeves'
    
    Headgear(0)=Class'DH_AmericanHelmet'
    Headgear(1)=Class'DH_AmericanHelmet1stEMa'
    
    HeadgearProbabilities(0)=0.3
    HeadgearProbabilities(1)=0.7
}

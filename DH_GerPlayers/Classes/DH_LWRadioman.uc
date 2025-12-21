//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_LWRadioman extends DHGERadioOperatorRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=Class'DH_GermanRadioFJPawn')
    SleeveTexture=Texture'DHGermanCharactersTex.FJ_Sleeve'
    Headgear(0)=Class'DH_LWHelmet'
    Headgear(1)=Class'DH_LWCap'
    HeadgearProbabilities(0)=0.60
    HeadgearProbabilities(1)=0.40
}
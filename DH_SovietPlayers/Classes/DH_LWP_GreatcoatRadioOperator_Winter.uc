//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_LWP_GreatcoatRadioOperator_Winter extends DHPOLRadioOperatorRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=Class'DH_LWPGreatcoatBrownStrapsPawn_Winter',Weight=6.0)
    RolePawns(1)=(PawnClass=Class'DH_LWPGreatcoatGreyStrapsPawn_Winter',Weight=1.0)
    SleeveTexture=Texture'DHSovietCharactersTex.RussianSleeves.DH_LWPCoatSleeves'
    Headgear(0)=Class'DH_LWPcap'
    Headgear(1)=Class'DH_LWPHelmet'
    HeadgearProbabilities(0)=0.5
    HeadgearProbabilities(1)=0.5
    HandType=Hand_Gloved
}

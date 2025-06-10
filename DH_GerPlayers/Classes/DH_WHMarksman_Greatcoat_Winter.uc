//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_WHMarksman_Greatcoat_Winter extends DHGEMarksmanRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=Class'DH_GermanGreatCoatPawn_Winter',Weight=1.0)
    SleeveTexture=Texture'Weapons1st_tex.Arms.GermanCoatSleeves'
    DetachedArmClass=Class'SeveredArmGerGreat'
    DetachedLegClass=Class'SeveredLegGerGreat'
    Headgear(0)=Class'ROGermanHat'
    Headgear(1)=Class'DH_HeerCamoCap'
    HandType=Hand_Gloved
}

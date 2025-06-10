//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_WHAssault_Snow extends DHGEAssaultRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=Class'DH_GermanParkaSnowHeerPawnB',Weight=2.0)
    RolePawns(1)=(PawnClass=Class'DH_GermanSmockToqueHeerPawn',Weight=1.0)
    SleeveTexture=Texture'DHGermanCharactersTex.GerSleeves.12thSS_Sleeve' //to do:
    Headgear(0)=Class'DH_HeerHelmetCover'
    Headgear(1)=Class'DH_HeerHelmetSnow'
    HandType=Hand_Gloved
}

//==============================================================================
// Darkest Hour: Europe '44-'45
// Copyright (c) Darklight Games.  All rights reserved.
//==============================================================================

class DH_WSSCombatEngineer_Snow extends DHGEEngineerRoles;

defaultproperties
{
    RolePawns(0)=(PawnClass=Class'DH_GermanParkaSnowSSPawn',Weight=2.0)
    RolePawns(1)=(PawnClass=Class'DH_GermanSmockToqueSSPawn',Weight=1.0)
    SleeveTexture=Texture'Weapons1st_tex.Arms.RussianSnow_Sleeves'
    Headgear(0)=Class'DH_SSHelmetCover'
    Headgear(1)=Class'DH_SSHelmetSnow'
    HandType=Hand_Gloved
}
